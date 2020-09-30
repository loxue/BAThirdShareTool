//
//  BASinaUserInfo.m
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import "BASinaUserInfo.h"

@implementation BASinaUserInfo

- (NSString *)description {
    return [NSString stringWithFormat:@"BASinaUserInfo : { accessToken : %@ , \n nickName : %@ , \n headImgUrl : %@ , \n gender : %@ , \n language : %@ , \n province : %@ , \n city : %@ }", self.accessToken, self.nickName, self.headImgUrl, self.gender, self.language, self.province, self.city];
}

@end
