//
//  BASinaTool.m
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import "BASinaTool.h"
#import "UIImage+BAImageCompress.h"

@interface BASinaTool()<WeiboSDKDelegate,WBHttpRequestDelegate>

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *sinaSchema;

@property (nonatomic, strong) WBAuthorizeResponse *authResp;
@property (nonatomic, copy) NSString *sinaAccessToken;

@property (nonatomic, copy) BASinaAuthBlock authBlock;
@property (nonatomic, copy) BASinaShareBlock shareBlock;

@end



@implementation BASinaTool

+ (BASinaTool *)sharedInstance {
    static BASinaTool *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BASinaTool alloc] init];
    });
    return sharedInstance;
}

/* 注册sina */
+ (void)ba_sinaRegister:(NSString *)appId debug:(BOOL)enable {
    [WeiboSDK enableDebugMode:enable];
    [WeiboSDK registerApp:appId];
    BASinaTool *sina = [BASinaTool sharedInstance];
    sina.appId = [appId copy];
    sina.sinaSchema = [NSString stringWithFormat:@"wb%@", appId];
}

/* 是否安装了微博 */
+ (BOOL)ba_isSinaInstalled {
    return [WeiboSDK isWeiboAppInstalled];
}

/* 是否是微博回调 */
+ (BOOL)ba_sinaCheckUrl:(NSURL *)url {
    BASinaTool *sina = [BASinaTool sharedInstance];
    NSString *schema = sina.sinaSchema ?: @"wb";
    BOOL check = [url.scheme isEqualToString:schema];
    return check;
}


/* handleOpenURL */
+ (BOOL)ba_sinaHandleOpenUrl:(NSURL *)url {
    BOOL handle = [WeiboSDK handleOpenURL:url delegate:(id<WeiboSDKDelegate>)[BASinaTool sharedInstance]];
    return handle;
}


/* 授权登录回调 */
+ (void)ba_sinaAuthLoginBlock:(BASinaAuthBlock)authBlock {
    BASinaTool *sina = [BASinaTool sharedInstance];
    sina.authBlock = authBlock;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://www.weibo.com";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": NSStringFromClass([self class]),
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    
    [WeiboSDK sendRequest:request];
}


/* sina分享block */
+ (void)ba_sinaShareInfo:(BASinaShareModel *)shareInfo shareBlock:(BASinaShareBlock)shareBlock {
    BASinaTool *sina = [BASinaTool sharedInstance];
    sina.shareBlock = shareBlock;
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = shareInfo.text;
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"baSinaShare";
    webpage.title = shareInfo.title;
    webpage.description = shareInfo.desString;
    webpage.webpageUrl = shareInfo.shareLink;
    NSData *thumbImgData = [shareInfo.thumbImage ba_compressImgToDataLimit:32];
    webpage.thumbnailData = thumbImgData;
    message.mediaObject = webpage;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"http://www.weibo.com";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.userInfo = @{@"ShareMessageFrom": NSStringFromClass([self class]),
                         @"Other_Info_1":@(1234),
                         @"Other_Info_2":@[@"obj1", @"obj2"],
                         @"Other_Info_3":@{@"key1":@"obj1", @"key2":@"obj2"}};
    [WeiboSDK sendRequest:request];
}


/* 请求sina用户信息 */
- (void)querySinaUserInfo:(WBAuthorizeResponse *)response {
    NSString *accessToken = [response accessToken];
    NSString *userId = [response userID];
    self.sinaAccessToken = [accessToken copy];
    self.authResp = response;
    
    NSDictionary *params = @{@"access_token":accessToken,
                             @"uid":userId
                             };
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:params delegate:self withTag:@"elkSinaShare"];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (resDict) {
        BASinaUserInfo *userInfo = [[BASinaUserInfo alloc] init];
        userInfo.accessToken = self.sinaAccessToken ?: @"";
        userInfo.nickName = resDict[@"name"] ?: @"";
        userInfo.headImgUrl = resDict[@"avatar_large"] ?: @"";
        NSString *gender = @"女";
        if ([resDict[@"gender"] isEqualToString:@"m"]){
            gender = @"男";
        }
        userInfo.gender = gender;
        userInfo.language = resDict[@"lang"] ?: @"zh-cn";
        userInfo.province = resDict[@"province"] ?: @"";
        userInfo.city = resDict[@"city"] ?: @"";
        if (self.authBlock) {
            self.authBlock(userInfo, self.authResp, BASinaAuthSucData);
        }
    } else {
        if (self.authBlock) {
            self.authBlock(nil, self.authResp, BASinaAuthSuccess);
        }
    }
}


#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        if (self.authBlock) {
            WBAuthorizeResponse *authResp = (WBAuthorizeResponse *)response;
            if (authResp.statusCode == WeiboSDKResponseStatusCodeSuccess) {
                [self querySinaUserInfo:authResp];
            } else if (authResp.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
                self.authBlock(nil, authResp, BASinaAuthCancel);
            } else {
                self.authBlock(nil, authResp, BASinaAuthFailure);
            }
        }
    } else if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        if (self.shareBlock) {
            WBSendMessageToWeiboResponse *shareResp = (WBSendMessageToWeiboResponse *)response;
            if (shareResp.statusCode == WeiboSDKResponseStatusCodeSuccess) {
                self.shareBlock(BASinaShareRespSuccess);
            } else if (shareResp.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
                self.shareBlock(BASinaShareRespCancel);
            } else {
                self.shareBlock(BASinaShareRespFailure);
            }
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

@end
