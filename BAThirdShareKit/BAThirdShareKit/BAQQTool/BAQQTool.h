//
//  BAQQTool.h
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAQQShareModel.h"
#import "BAQQUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

// Tencent登录授权响应
typedef void(^BAQQAuthBlock)(BAQQUserInfo *_Nullable userInfo, BAQQAuthRespStatus authStatus);
// Tencent登出响应
typedef void(^BAQQLogoutBlock)(void);
// Tencent分享响应
typedef void(^BAQQShareBlock)(BAQQShareRespStatus shareStatus);

@interface BAQQTool : NSObject

/* 注册Tencent SDK : tencentAppId */
+ (void)ba_qqRegister:(NSString * _Nonnull)appId;


/* 是否QQ客户端 */
+ (BOOL)ba_isQQInstalled;


/* 是否是QQ回调 */
+ (BOOL)ba_qqAuthCheckUrl:(NSURL *)url;


/* Handle Open Url */
+ (BOOL)ba_qqAuthHandleOpenUrl:(NSURL *)url;


/* 是否是QQ分享回调 */
+ (BOOL)ba_qqInterfaceCheckUrl:(NSURL *)url;


/* Handle Open Url */
+ (BOOL)ba_qqInterfaceHandleOpenUrl:(NSURL *)url;


/* QQ登录结果block */
+ (void)ba_qqAuthLoginBlock:(BAQQAuthBlock)authBlock;


/* QQ登出block */
+ (void)ba_qqLogoutBlock:(BAQQLogoutBlock)logoutBlock;


/* QQ好友分享 */
+ (void)ba_qqShare:(BAQQShareModel *)shareInfo
             sence:(BAQQShareScene)sence
             block:(BAQQShareBlock)shareBlock;

@end

NS_ASSUME_NONNULL_END
