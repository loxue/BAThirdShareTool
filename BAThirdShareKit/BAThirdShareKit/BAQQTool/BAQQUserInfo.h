//
//  BAQQUserInfo.h
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* 登录结果回调状态 */
typedef NS_OPTIONS(NSUInteger, BAQQAuthRespStatus) {
   BAQQAuthSuccess    = 1 << 0,      // 授权登录成功
   BAQQAuthSucData    = 1 << 1,      // 授权成功并获取用户信息
   BAQQAuthFailure    = 1 << 2,      // 授权登录失败
   BAQQAuthCancel     = 1 << 3,      // 取消授权登录
};

/* QQ用户信息 */
@interface BAQQUserInfo : NSObject

@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headImgUrl;
@property (nonatomic, copy) NSString *gender;       // 男 | 女

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *year;

@end

NS_ASSUME_NONNULL_END
