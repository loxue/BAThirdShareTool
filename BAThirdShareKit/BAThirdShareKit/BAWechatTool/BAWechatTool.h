//
//  BAWechatTool.h
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "BAWechatShareModel.h"
#import "BAWechatPayModel.h"
#import "BAWechatUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 回调方法

/* 微信登录授权回调 */
typedef void(^BAWechatAuthBlock)(BAWechatUserInfo *_Nullable userInfo, SendAuthResp *authResp, BAWechatAuthRespStatus authStatus);
/* 微信登录获取用户信息回调 */
typedef void(^BAWechatGainInfoBlock)(BAWechatUserInfo *_Nullable userInfo, BAWechatRespInfoStatus respStatus);
/* 微信分享回调 */
typedef void(^BAWechatShareBlock)(BAWechatShareRespStatus shareStatus);
/* 微信支付回调 */
typedef void(^BAWechatPayBlock)(BAWechatPayRespStatus payRespStatus);

@interface BAWechatTool : NSObject

/* 是否安装微信 */
+ (BOOL)ba_isWeChatInstalled;


/* 注册微信SDK */
+ (BOOL)ba_weChatRegister:(NSString *)appId
               withSecret:(NSString *)secret
            universalLink:(NSString *)uniLink;


/* 是否是微信回调 */
+ (BOOL)ba_weChatCheckUrl:(NSURL *)url;


/* handle url */
+ (BOOL)ba_weChatHandleOpenUrl:(NSURL *)url;


/* 登录block */
+ (void)ba_weChatAuthLoginBlock:(BAWechatAuthBlock)authBlock;


/* 获取微信用户信息 */
+ (void)ba_weChatGainInfo:(SendAuthResp *)authResp block:(BAWechatGainInfoBlock)infoBlock;


/* 网页微信分享 */
+ (void)ba_weChatShareWebPage:(BAWechatShareModel *)shareInfo
                        sence:(BAWechatScene)shareSence
                        block:(BAWechatShareBlock)shareBlock;


/* 微信支付 */
+ (void)ba_weChatPay:(BAWechatPayModel *)payInfo block:(BAWechatPayBlock)payBlock;

@end

NS_ASSUME_NONNULL_END
