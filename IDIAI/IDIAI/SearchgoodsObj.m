//
//  SearchgoodsObj.m
//  IDIAI
//
//  Created by iMac on 14-8-6.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SearchgoodsObj.h"

@implementation SearchgoodsObj

+(SearchgoodsObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        SearchgoodsObj *obj = [[SearchgoodsObj alloc] init];
        if(![[dict objectForKey:@"businessTypeId"] isEqual:[NSNull null]])
            [obj setBusinessTypeId:[NSString stringWithFormat:@"%@",[dict objectForKey:@"businessTypeId"]]];
        if(![[dict objectForKey:@"businessTypeLogoPath"] isEqual:[NSNull null]])
            [obj setBusinessTypeLogoPath:[dict objectForKey:@"businessTypeLogoPath"]];
        if(![[dict objectForKey:@"businessTypeName"] isEqual:[NSNull null]])
            [obj setBusinessTypeName:[dict objectForKey:@"businessTypeName"]];
        
        return obj;
    }
}

@end
