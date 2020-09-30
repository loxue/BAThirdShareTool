//
//  BAQQTool.m
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import "BAQQTool.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface BAQQTool ()<TencentSessionDelegate,TencentLoginDelegate,QQApiInterfaceDelegate>

@property (nonatomic, strong) TencentOAuth *qqOauth;
@property (nonatomic, copy) NSString *qqAppId;

@property (nonatomic, copy) BAQQAuthBlock authBlock;
@property (nonatomic, copy) BAQQLogoutBlock logoutBlock;
@property (nonatomic, copy) BAQQShareBlock shareBlock;

@end

@implementation BAQQTool


+ (BAQQTool *)sharedInstance {
    static BAQQTool * sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BAQQTool alloc] init];
    });
    return sharedInstance;
}


/*  注册QQ SDK : tencentAppId */
+ (void)ba_qqRegister:(NSString *)appId {
    BAQQTool *qq = [BAQQTool sharedInstance];
    qq.qqAppId = [appId copy];
    qq.qqOauth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:qq];
}


/* 是否安装QQ客户端 */
+ (BOOL)ba_isQQInstalled {
    return [TencentOAuth iphoneQQInstalled];
}


/* 是否是QQ登录回调 */
+ (BOOL)ba_qqAuthCheckUrl:(NSURL *)url {
    BOOL check = [url.host isEqualToString:@"qzapp"];
    return check;
}


/* Handle Open Url */
+ (BOOL)ba_qqAuthHandleOpenUrl:(NSURL *)url {
    return [TencentOAuth HandleOpenURL:url];
}


/* 是否是QQ分享回调 */
+ (BOOL)ba_qqInterfaceCheckUrl:(NSURL *)url {
    BOOL check = [url.host isEqualToString:@"response_from_qq"];
    return check;
}


/* Handle Open Url */
+ (BOOL)ba_qqInterfaceHandleOpenUrl:(NSURL *)url {
    BOOL handle = [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[BAQQTool sharedInstance]];
    return handle;
}


/* 登录结果block */
+ (void)ba_qqAuthLoginBlock:(BAQQAuthBlock)authBlock {
    BAQQTool *qq = [BAQQTool sharedInstance];
    qq.authBlock = authBlock;
    
    NSArray *permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_GET_INFO, nil];
    [[BAQQTool sharedInstance].qqOauth authorize:permissions inSafari:NO];
}


/* 登出结果block */
+ (void)ba_qqLogoutBlock:(BAQQLogoutBlock)logoutBlock {
    BAQQTool *tencent = [BAQQTool sharedInstance];
    tencent.logoutBlock = logoutBlock;
    [tencent.qqOauth logout:tencent];
}


/* 分享到QQ好友 */
+ (void)ba_qqShare:(BAQQShareModel *)shareInfo
             sence:(BAQQShareScene)sence
             block:(BAQQShareBlock)shareBlock {
    BAQQTool *qq = [BAQQTool sharedInstance];
    qq.shareBlock = shareBlock;
    
    NSString *shareLink = shareInfo.shareLink;
    NSString *title = shareInfo.title;
    NSString *description = shareInfo.desString ?: @"";
    NSString *previewImageUrl = shareInfo.previewImageUrl;
    NSData *imageData = shareInfo.imageData;
    
    // 分享图片数据
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imageData
                                                previewImageData:imageData
                                                           title:title
                                                     description:description];
    
    // 分享文本
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareLink] title:title description:description previewImageURL:[NSURL URLWithString:previewImageUrl]];
    
    // 设置分享类型
    SendMessageToQQReq *req;
    if (imageData == nil) {
        req = [SendMessageToQQReq reqWithContent:newsObj];
    } else {
        req = [SendMessageToQQReq reqWithContent:imgObj];
    }
    
    if (sence == BAQQSceneMessage) {
        [QQApiInterface sendReq:req];
    } else {
        [QQApiInterface SendReqToQZone:req];
    }
}


#pragma mark - TencentLoginDelegate

/* 登录成功回调 */
- (void)tencentDidLogin {
    [self.qqOauth getUserInfo];
}

/* 登录失败回调 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (self.authBlock) {
        BAQQAuthRespStatus resStatus = BAQQAuthFailure;
        if (cancelled) {
            resStatus = BAQQAuthCancel;
        }
        self.authBlock(nil, resStatus);
    }
}

/* 登录网络异常 */
- (void)tencentDidNotNetWork {
    if (self.authBlock) {
        self.authBlock(nil, BAQQAuthFailure);
    }
}

#pragma mark - TencentSessionDelegate

/* 退出登录回调 */
- (void)tencentDidLogout {
    if (self.logoutBlock) {
        self.logoutBlock();
    }
}

/* 获取用户个人信息回调 */
- (void)getUserInfoResponse:(APIResponse *)response {
    if (URLREQUEST_SUCCEED == response.retCode
        && kOpenSDKErrorSuccess == response.detailRetCode) {
        if (self.authBlock) {
            BAQQUserInfo *userInfo = [[BAQQUserInfo alloc] init];
            userInfo.openId = [self.qqOauth.openId copy] ?: @"";
            userInfo.nickName = [response.jsonResponse objectForKey:@"nickname"] ?: @"";
            userInfo.headImgUrl = [response.jsonResponse objectForKey:@"figureurl_qq_2"] ?: @"";
            userInfo.gender = response.jsonResponse[@"gender"] ?: @"男";
            userInfo.city = response.jsonResponse[@"city"] ?: @"";
            userInfo.year = response.jsonResponse[@"year"] ?: @"";
            userInfo.province = response.jsonResponse[@"province"] ?: @"";
            self.authBlock(userInfo, BAQQAuthSucData);
        }
    } else {
        if (self.authBlock) {
            self.authBlock(nil, BAQQAuthSuccess);
        }
    }
}


#pragma mark - QQApiInterfaceDelegate

- (void)onReq:(QQBaseReq *)req {
    
}

- (void)onResp:(QQBaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        SendMessageToQQResp *msgResp = (SendMessageToQQResp *)resp;
        if (self.shareBlock) {
            BAQQShareRespStatus shareStatus = BAQQShareRespFailure;
            if ([msgResp.result isEqualToString:@"0"]) {
                shareStatus = BAQQShareRespSuccess;
            } else if ([msgResp.result isEqualToString:@"-4"]) {
                shareStatus = BAQQShareRespCancel;
            }
            self.shareBlock(shareStatus);
        }
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}


@end

