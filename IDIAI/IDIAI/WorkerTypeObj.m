//
//  WorkerTypeObj.m
//  IDIAI
//
//  Created by iMac on 14-10-27.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "WorkerTypeObj.h"

@implementation WorkerTypeObj

+(WorkerTypeObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        WorkerTypeObj *obj = [[WorkerTypeObj alloc] init];
        if(![[dict objectForKey:@"jobScopeId"] isEqual:[NSNull null]])
            [obj setJobScopeId:[[dict objectForKey:@"jobscopeId"] integerValue]];
        if(![[dict objectForKey:@"JobScopeImgPath"] isEqual:[NSNull null]])
            [obj setJobScopeImgPath:[dict objectForKey:@"jobscopeImgPath"]];
        if(![[dict objectForKey:@"jobScopeName"] isEqual:[NSNull null]])
            [obj setJobScopeName:[dict objectForKey:@"jobscopeName"]];
        
        return obj;
    }
}

@end
