//
//  BAThirdShareTool.h
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAWechatTool.h"
#import "BAQQTool.h"
#import "BASinaTool.h"
#import "BAAlipayTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface BAThirdShareTool : NSObject

+ (BOOL)ba_shareApplication:(UIApplication *)application openUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
