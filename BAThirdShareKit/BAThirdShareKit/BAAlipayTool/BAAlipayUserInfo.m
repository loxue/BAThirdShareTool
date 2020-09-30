//
//  BAAlipayUserInfo.m
//  封装工具
//
//  Created by pugss000 on 2020/9/4.
//  Copyright © 2020 pugss000. All rights reserved.
//

#import "BAAlipayUserInfo.h"

@implementation BAAlipayUserInfo

- (NSString *)description {
    return [NSString stringWithFormat:@"BAAlipayUserInfo : { unionId : %@ , \n openId : %@ , \n nickName : %@ , \n headImgUrl : %@ , \n gender : %@ , \n language : %@ , \n country : %@ , \n province : %@ , \n city : %@ }", self.unionId, self.openId, self.nickName, self.headImgUrl, self.gender, self.language, self.country, self.province, self.city];
}

@end
