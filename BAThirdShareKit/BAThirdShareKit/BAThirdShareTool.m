//
//  BAThirdShareTool.m
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import "BAThirdShareTool.h"

@implementation BAThirdShareTool

+ (BOOL)ba_shareApplication:(UIApplication *)application openUrl:(NSURL *)url {
    if ([BAQQTool ba_qqAuthCheckUrl:url]) {
        // QQ Auth
        return [BAQQTool ba_qqAuthHandleOpenUrl:url];
    } else if ([BAQQTool ba_qqInterfaceCheckUrl:url]) {
        // QQ Share
        return [BAQQTool ba_qqInterfaceHandleOpenUrl:url];
    } else if ([BAWechatTool ba_weChatCheckUrl:url]) {
        // WeChat
        return [BAWechatTool ba_weChatHandleOpenUrl:url];
    } else if ([BASinaTool ba_sinaCheckUrl:url]) {
        // Sina
        return [BASinaTool ba_sinaHandleOpenUrl:url];
    }
    return NO;
}

@end
