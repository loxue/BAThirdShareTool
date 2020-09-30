//
//  UIImage+BAImageCompress.h
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BAImageCompress)

#pragma mark - 图片压缩

- (UIImage *)ba_imageCompressSizeLimitMax:(NSUInteger)maxLength;
- (NSData *)ba_compressImgToDataLimit:(NSUInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
