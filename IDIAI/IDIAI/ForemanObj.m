//
//  ForemanObj.m
//  IDIAI
//
//  Created by iMac on 14-10-27.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ForemanObj.h"

@implementation ForemanObj

+(ForemanObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        ForemanObj *obj = [[ForemanObj alloc] init];
        if(![[dict objectForKey:@"foremanId"] isEqual:[NSNull null]])
            [obj setForemanId:[[dict objectForKey:@"foremanId"] integerValue]];
        if(![[dict objectForKey:@"nickName"] isEqual:[NSNull null]])
            [obj setNickName:[dict objectForKey:@"nickName"]];
        if(![[dict objectForKey:@"foremanIconPath"] isEqual:[NSNull null]])
            [obj setForemanIconPath:[dict objectForKey:@"foremanIconPath"]];
        if(![[dict objectForKey:@"foremanLevel"] isEqual:[NSNull null]])
            [obj setForemanLevel:[NSString stringWithFormat:@"%@",[dict objectForKey:@"foremanLevel"]]];
        if(![[dict objectForKey:@"foremanMobile"] isEqual:[NSNull null]])
            [obj setForemanMobile:[dict objectForKey:@"foremanMobile"]];
        if(![[dict objectForKey:@"foremanExperience"] isEqual:[NSNull null]])
            [obj setForemanExperience:[dict objectForKey:@"foremanExperience"]];
        if(![[dict objectForKey:@"foremanDesc"] isEqual:[NSNull null]])
            [obj setForemanDesc:[dict objectForKey:@"foremanDesc"]];
        if(![[dict objectForKey:@"gradeSign"] isEqual:[NSNull null]])
            [obj setGradeSign:[NSString stringWithFormat:@"%@",[dict objectForKey:@"gradeSign"]]];
        if([[dict objectForKey:@"foremanAuthents"] count])
            obj.foremanAuthents_arr=[dict objectForKey:@"foremanAuthents"];
        if([[dict objectForKey:@"foremanImagePaths"] count])
            obj.foremanImagePaths_arr=[dict objectForKey:@"foremanImagePaths"];
        
        return obj;
    }
}


@end
