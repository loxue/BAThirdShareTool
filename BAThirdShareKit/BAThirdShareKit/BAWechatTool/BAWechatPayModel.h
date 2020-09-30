//
//  BAWechatPayModel.h
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*  支付完成回调状态 */
typedef NS_OPTIONS(NSUInteger, BAWechatPayRespStatus) {
    BAWechatPayRespSuccess = 1 << 0,    // 支付成功
    BAWechatPayRespFailure = 1 << 1,    // 支付失败
    BAWechatPayRespCancel  = 1 << 2,    // 取消支付
};

/*  Wechat Pay */
@interface BAWechatPayModel : NSObject

@property (nonatomic, copy, nonnull) NSString *partnerId;
@property (nonatomic, copy, nonnull) NSString *prepayId;
@property (nonatomic, copy, nonnull) NSString *package;
@property (nonatomic, copy, nonnull) NSString *nonceStr;
@property (nonatomic, copy, nonnull) NSString *timeStamp;
@property (nonatomic, copy, nonnull) NSString *sign;

@end

NS_ASSUME_NONNULL_END