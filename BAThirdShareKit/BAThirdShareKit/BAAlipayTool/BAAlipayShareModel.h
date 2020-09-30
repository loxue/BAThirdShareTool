//
//  BAAlipayShareModel.h
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/* 分享类型 */
typedef NS_OPTIONS(NSUInteger, BAAlipayScene) {
    BAAlipaySceneSession   = 1 << 0,    // 聊天界面
    BAAlipaySceneTimeLine  = 1 << 1,    // 朋友圈
};

/* 分享完成回调状态 */
typedef NS_OPTIONS(NSUInteger, BAAlipayShareRespStatus) {
    BAAlipayShareRespSuccess = 1 << 0, // 分享成功
    BAAlipayShareRespFailure = 1 << 1, // 分享失败
    BAAlipayShareRespCancel  = 1 << 2, // 取消分享
};

@interface BAAlipayShareModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desString;
@property (nonatomic, copy) NSString *shareLink;
@property (nonatomic, strong) UIImage *thumbImage;

@end

NS_ASSUME_NONNULL_END
