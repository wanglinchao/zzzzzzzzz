//
//  PersonalInfoObj.m
//  IDIAI
//
//  Created by iMac on 14-7-15.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PersonalInfoObj.h"

@implementation PersonalInfoObj

+(PersonalInfoObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        PersonalInfoObj *obj = [[PersonalInfoObj alloc] init];
        if(![[dict objectForKey:@"userLogo"] isEqual:[NSNull null]])
            [obj setUserlogo:[dict objectForKey:@"userLogo"]];
        if(![[dict objectForKey:@"nickName"] isEqual:[NSNull null]])
            [obj setNickname:[dict objectForKey:@"nickName"]];
        if(![[dict objectForKey:@"sex"] isEqual:[NSNull null]])
            [obj setSex:[dict objectForKey:@"sex"]];
        if(![[dict objectForKey:@"userAddress"] isEqual:[NSNull null]])
            [obj setUserAddress:[dict objectForKey:@"userAddress"]];
        if(![[dict objectForKey:@"userMobile"] isEqual:[NSNull null]])
            [obj setUserMobile:[dict objectForKey:@"userMobile"]];
        if(![[dict objectForKey:@"loginName"] isEqual:[NSNull null]])
            [obj setLoginName:[dict objectForKey:@"loginName"]];
        
        return obj;
    }
}

@end
