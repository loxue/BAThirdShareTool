//
//  BASinaShareModel.h
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/* sina分享回调状态 */
typedef NS_OPTIONS(NSUInteger, BASinaShareRespStatus) {
    BASinaShareRespSuccess = 1 << 0,       // 分享成功
    BASinaShareRespFailure = 1 << 1,       // 分享失败
    BASinaShareRespCancel  = 1 << 2,       // 取消分享
};

/* sina分享信息 */
@interface BASinaShareModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desString;
@property (nonatomic, copy) NSString *shareLink;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIImage *thumbImage;

@end

NS_ASSUME_NONNULL_END
