//
//  BASinaTool.h
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#import "BASinaShareModel.h"
#import "BASinaUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

/* sina登录授权回调 */
typedef void(^BASinaAuthBlock)(BASinaUserInfo *_Nullable userInfo, WBAuthorizeResponse *authResp, BASinaAuthRespStatus authStatus);
/* sina分享回调 */
typedef void(^BASinaShareBlock)(BASinaShareRespStatus shareStatus);


@interface BASinaTool : NSObject

/* sina注册 : appId、是否开启debug调试 */
+ (void)ba_sinaRegister:(NSString *)appId debug:(BOOL)enable;


/* 是否安装了微博客户端 */
+ (BOOL)ba_isSinaInstalled;

/* 判断是否是微博回调 */
+ (BOOL)ba_sinaCheckUrl:(NSURL *)url;

/* handleOpenURL */
+ (BOOL)ba_sinaHandleOpenUrl:(NSURL *)url;

/* sina授权登录回调 */
+ (void)ba_sinaAuthLoginBlock:(BASinaAuthBlock)authBlock;

/* sina分享结果 */
+ (void)ba_sinaShareInfo:(BASinaShareModel *)shareInfo shareBlock:(BASinaShareBlock)shareBlock;


@end

NS_ASSUME_NONNULL_END
