//
//  BAWechatTool.m
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import "BAWechatTool.h"
#import "UIImage+BAImageCompress.h"

@interface BAWechatTool ()<WXApiDelegate>

@property (nonatomic, copy, nonnull) NSString *appId;
@property (nonatomic, copy, nonnull) NSString *appSecret;
@property (nonatomic, copy, nonnull) NSString *universalLink;

@property (nonatomic, copy) BAWechatAuthBlock       baAuthBlock;
@property (nonatomic, copy) BAWechatGainInfoBlock   baGainInfoBlock;
@property (nonatomic, copy) BAWechatPayBlock        baPayBlock;
@property (nonatomic, copy) BAWechatShareBlock      baShareBlock;

@end

@implementation BAWechatTool

#pragma mark - 单例

+ (instancetype)sharedInstance {
    static BAWechatTool *weChatManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weChatManager = [[BAWechatTool alloc] init];
    });
    return weChatManager;
}


/* 判断是否是微信回调 */
+ (BOOL)ba_weChatCheckUrl:(NSURL *)url {
    BAWechatTool *wechat = [BAWechatTool sharedInstance];
    NSString *appId = wechat.appId ?: @"wx";
    BOOL check = [url.scheme isEqualToString:appId];
    return check;
}


/* handleOpenURL */
+ (BOOL)ba_weChatHandleOpenUrl:(NSURL *)url {
    BOOL handle = [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)[BAWechatTool sharedInstance]];
    return handle;
}


/* 注册微信SDK: appId、secret、 回调 */
+ (BOOL)ba_weChatRegister:(NSString *)appId
               withSecret:(NSString *)secret
            universalLink:(NSString *)uniLink {
    BAWechatTool *wechat = [BAWechatTool sharedInstance];
    wechat.appId = [appId copy];
    wechat.appSecret = [secret copy];
    wechat.universalLink = [uniLink copy];
    
    BOOL reg = [WXApi registerApp:appId universalLink:uniLink];
    return reg;
}


/* 是否安装微信 */
+ (BOOL)ba_isWeChatInstalled {
    return [WXApi isWXAppInstalled];
}


/* 微信登录授权 */
+ (void)ba_weChatAuthLoginBlock:(BAWechatAuthBlock)authBlock {
    BAWechatTool *wechat = [BAWechatTool sharedInstance];
    wechat.baAuthBlock = authBlock;
    
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
    [WXApi sendReq:req completion:nil];
}


/* 获取微信用户信息 */
+ (void)ba_weChatGainInfo:(SendAuthResp *)authResp block:(BAWechatGainInfoBlock)infoBlock {
    BAWechatTool *wechat = [BAWechatTool sharedInstance];
    wechat.baGainInfoBlock = infoBlock;
    [wechat prepareQueryUserInfo:authResp];
}

/* 微信分享 */
+ (void)ba_weChatShareWebPage:(BAWechatShareModel *)shareInfo
                        sence:(BAWechatScene)shareSence
                        block:(BAWechatShareBlock)shareBlock {
    BAWechatTool *wechat = [BAWechatTool sharedInstance];
    wechat.baShareBlock = shareBlock;
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = shareInfo.shareLink;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareInfo.title;
    message.description = shareInfo.desString ?: @"";
    UIImage *thumbImg = [shareInfo.thumbImage ba_imageCompressSizeLimitMax:64];
    [message setThumbImage:thumbImg];
    message.mediaObject = webObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    
    if (shareSence == BAWechatSceneSession) {
        // 聊天页面
        req.scene = WXSceneSession;
    } else {
        // 朋友圈
        req.scene = WXSceneTimeline;
    }
    
    [WXApi sendReq:req completion:nil];
}


#pragma mark - 查询用户信息
/* 查询用户信息 */
- (void)prepareQueryUserInfo:(SendAuthResp *)authResp {
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", self.appId, self.appSecret, authResp.code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                // 获取到的三方凭证
                NSString *accessToken = dic[@"access_token"] ?: @"";
                // 三方唯一标识
                NSString *openId = dic[@"openid"] ?: @"";
                [self queryUserInfo:authResp token:accessToken openid:openId];
            }
        });
    });
}

/* 查询用户信息 */
- (void)queryUserInfo:(SendAuthResp *)authResp
                token:(NSString *)accessToken
               openid:(NSString *)openId {
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", accessToken, openId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                BAWechatUserInfo *wechatInfo = [[BAWechatUserInfo alloc] init];
                wechatInfo.unionId = dataDict[@"unionid"] ?: @"";
                wechatInfo.openId = dataDict[@"openid"] ?: @"";
                wechatInfo.nickName = dataDict[@"nickname"] ?: @"";
                wechatInfo.headImgUrl = dataDict[@"headimgurl"] ?: @"";
                wechatInfo.province = dataDict[@"province"] ?: @"";
                wechatInfo.country = dataDict[@"country"] ?: @"";
                wechatInfo.city = dataDict[@"city"] ?: @"";
                wechatInfo.language = dataDict[@"language"] ?: @"";
                NSNumber *gender = dataDict[@"sex"] ?: @1;
                wechatInfo.gender = [gender integerValue] ? @"男" : @"女";
                if (self.baAuthBlock) {
                    self.baAuthBlock(wechatInfo, authResp, BAWechatAuthRespSucData);
                }
                if (self.baGainInfoBlock) {
                    self.baGainInfoBlock(wechatInfo, BAWechatRespInfoSuccess);
                }
            } else {
                if (self.baAuthBlock) {
                    self.baAuthBlock(nil, authResp, BAWechatAuthRespSuccess);
                }
                if (self.baGainInfoBlock) {
                    self.baGainInfoBlock(nil, BAWechatRespInfoFailure);
                }
            }
        });
    });
}


/* 微信支付 */
+ (void)ba_weChatPay:(BAWechatPayModel *)payInfo block:(BAWechatPayBlock)payBlock {
    BAWechatTool *wechat = [BAWechatTool sharedInstance];
    wechat.baPayBlock = payBlock;
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = payInfo.partnerId;
    request.prepayId = payInfo.prepayId;
    request.package = payInfo.package;
    request.nonceStr = payInfo.nonceStr;
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    request.timeStamp = [payInfo.timeStamp integerValue] ?: timeStamp;
    request.sign = payInfo.sign;
    
    [WXApi sendReq:request completion:nil];
}


#pragma mark - WXApiDelegate
/* 微信回调 */
- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        // share
        if (self.baShareBlock) {
            SendMessageToWXResp *msgResp = (SendMessageToWXResp *)resp;
            BAWechatShareRespStatus shareRespStatus = BAWechatShareRespSuccess;
            if (msgResp.errCode == 0) {
                shareRespStatus = BAWechatShareRespSuccess;
            } else if (msgResp.errCode == -2) {
                shareRespStatus = BAWechatShareRespCancel;
            } else {
                shareRespStatus = BAWechatShareRespFailure;
            }
            self.baShareBlock(shareRespStatus);
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        // auth
        if (self.baAuthBlock) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            if (authResp.errCode == WXErrCodeAuthDeny) {
                self.baAuthBlock(nil, authResp, BAWechatAuthRespDeny);
            } else if (authResp.errCode == WXErrCodeUserCancel) {
                self.baAuthBlock(nil, authResp, BAWechatAuthRespCancel);
            } else if (authResp.errCode == WXErrCodeSentFail || authResp.errCode == WXErrCodeUnsupport) {
                self.baAuthBlock(nil, authResp, BAWechatAuthRespFailure);
            } else if (authResp.errCode == WXErrCodeCommon) {
                self.baAuthBlock(nil, authResp, BAWechatAuthRespFailure);
            } else {
                [self prepareQueryUserInfo:authResp];
            }
        }
    } else if ([resp isKindOfClass:[PayResp class]]) {
        // pay
        if (self.baPayBlock) {
            PayResp *pay = (PayResp *)resp;
            BAWechatPayRespStatus payRespStatus = BAWechatPayRespSuccess;
            if (pay.errCode == 0) {
                payRespStatus = BAWechatPayRespSuccess;
            } else if (pay.errCode == -2) {
                payRespStatus = BAWechatPayRespCancel;
            } else {
                payRespStatus = BAWechatPayRespFailure;
            }
            self.baPayBlock(payRespStatus);
        }
    }
}


@end
