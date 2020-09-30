//
//  BASinaUserInfo.h
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* sina登录结果 */
typedef NS_OPTIONS(NSUInteger, BASinaAuthRespStatus) {
    BASinaAuthSuccess    = 1 << 0,     // 授权登录成功
    BASinaAuthSucData    = 1 << 1,     // 授权成功并获取用户信息
    BASinaAuthFailure    = 1 << 2,     // 授权登录失败
    BASinaAuthCancel     = 1 << 3,     // 取消授权登录
};


/* sina用户信息 */
@interface BASinaUserInfo : NSObject

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headImgUrl;
@property (nonatomic, copy) NSString *gender;   // 男 | 女

@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;

@end

NS_ASSUME_NONNULL_END
