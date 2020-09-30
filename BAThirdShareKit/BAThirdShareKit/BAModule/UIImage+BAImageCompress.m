//
//  UIImage+BAImageCompress.m
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import "UIImage+BAImageCompress.h"

@implementation UIImage (BAImageCompress)

- (UIImage *)ba_imageCompressSizeLimitMax:(NSUInteger)maxLength {
    NSData *imgData = [self ba_compressImgToDataLimit:maxLength];
    return [UIImage imageWithData:imgData];
}

- (NSData *)ba_compressImgToDataLimit:(NSUInteger)maxLength {
    NSUInteger maxByteLength = maxLength * 1024;
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxByteLength) {
        return data;
    }
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxByteLength * 0.9) {
            min = compression;
        } else if (data.length > maxByteLength) {
            max = compression;
        } else {
            break;
        }
    }
    if (data.length < maxByteLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    NSUInteger lastDataLength = 0;
    while (data.length > maxByteLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxByteLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)), (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}


@end
