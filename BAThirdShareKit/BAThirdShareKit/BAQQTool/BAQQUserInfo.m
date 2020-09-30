//
//  BAQQUserInfo.m
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import "BAQQUserInfo.h"

@implementation BAQQUserInfo

- (NSString *)description {
    return [NSString stringWithFormat:@"BAQQUserInfo : { openId : %@ , \n nickName : %@ , \n headImgUrl : %@ , \n gender : %@ , \n province : %@ , \n city : %@ }", self.openId, self.nickName, self.headImgUrl, self.gender, self.province, self.city];
}

@end
