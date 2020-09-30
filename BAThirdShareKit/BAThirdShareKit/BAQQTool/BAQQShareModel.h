//
//  BAQQShareModel.h
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* 分享类型 */
typedef NS_OPTIONS(NSUInteger, BAQQShareScene) {
    BAQQSceneMessage = 1 << 0,        // 分享到好友
    BAQQSceneZone    = 1 << 1,        // 分享到空间
};

/* 分享回调状态 */
typedef NS_OPTIONS(NSUInteger, BAQQShareRespStatus) {
    BAQQShareRespSuccess = 1 << 0,      // 分享成功
    BAQQShareRespFailure = 1 << 1,      // 分享失败
    BAQQShareRespCancel  = 1 << 2,      // 取消分享
};

/* QQ分享信息 */
@interface BAQQShareModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desString;
@property (nonatomic, copy) NSString *shareLink;
@property (nonatomic, copy) NSString *previewImageUrl;

/* @分享纯图片
 * 1、如果只分享图片，上面四个参数可以不用设置值。相反如果正常分享，则不需要传递imageData参数
 */
@property (nonatomic, copy) NSData *imageData;

@end

NS_ASSUME_NONNULL_END
