//
//  BAWechatUserInfo.h
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* 登录结果回调状态 */
typedef NS_OPTIONS(NSUInteger, BAWechatAuthRespStatus) {
    BAWechatAuthRespSuccess   = 1 << 0,     // 授权登录成功
    BAWechatAuthRespSucData   = 1 << 1,     // 授权成功并获取用户信息
    BAWechatAuthRespFailure   = 1 << 2,     // 授权登录失败
    BAWechatAuthRespDeny      = 1 << 3,     // 授权登录被拒绝
    BAWechatAuthRespCancel    = 1 << 4,     // 授权用户取消
};

/* 授权完成回调状态 */
typedef NS_OPTIONS(NSUInteger, BAWechatRespInfoStatus) {
    BAWechatRespInfoSuccess   = 1 << 0,     // 获取用户信息成功
    BAWechatRespInfoFailure   = 1 << 1,     // 获取用户信息失败
};

/* 登录成功获取到的用户信息 */
@interface BAWechatUserInfo : NSObject

@property (nonatomic, copy) NSString *unionId;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headImgUrl;
@property (nonatomic, copy) NSString *gender;   // 男 | 女

@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *city;


@end

NS_ASSUME_NONNULL_END
