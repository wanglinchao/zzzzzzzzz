//
//  CityListObj.m
//  IDIAI
//
//  Created by iMac on 14-12-17.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CityListObj.h"

@implementation CityListObj

+(CityListObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        CityListObj *obj = [[CityListObj alloc] init];
        if(![[dict objectForKey:@"cityName"] isEqual:[NSNull null]])
            [obj setCityName:[NSString stringWithFormat:@"%@",[dict objectForKey:@"cityName"]]];
        if(![[dict objectForKey:@"cityCode"] isEqual:[NSNull null]])
            [obj setCityCode:[dict objectForKey:@"cityCode"]];
        if(![[dict objectForKey:@"cityAreanum"] isEqual:[NSNull null]])
            [obj setCityAreanum:[dict objectForKey:@"cityAreanum"]];
        if(![[dict objectForKey:@"isHotCity"] isEqual:[NSNull null]])
            [obj setIsHotCity:[NSString stringWithFormat:@"%@",[dict objectForKey:@"isHotCity"]]];
        
        return obj;
    }
}

@end
