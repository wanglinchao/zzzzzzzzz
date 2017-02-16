//
//  GongzhangListObj.m
//  IDIAI
//
//  Created by iMac on 15-2-4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GongzhangListObj.h"

@implementation GongzhangListObj

+(GongzhangListObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        GongzhangListObj *obj = [[GongzhangListObj alloc] init];
        if(![[dict objectForKey:@"foremanId"] isEqual:[NSNull null]])
            [obj setForemanId:[NSString stringWithFormat:@"%@",[dict objectForKey:@"foremanId"]]];
        if(![[dict objectForKey:@"foremanIconPath"] isEqual:[NSNull null]])
            [obj setForemanIconPath:[NSString stringWithFormat:@"%@",[dict objectForKey:@"foremanIconPath"]]];
        if(![[dict objectForKey:@"nickName"] isEqual:[NSNull null]])
            [obj setNickName:[NSString stringWithFormat:@"%@",[dict objectForKey:@"nickName"]]];
        if(![[dict objectForKey:@"foremanExperience"] isEqual:[NSNull null]])
            [obj setForemanExperience:[NSString stringWithFormat:@"%@",[dict objectForKey:@"foremanExperience"]]];
        if(![[dict objectForKey:@"popularityLevel"] isEqual:[NSNull null]])
            [obj setPopularityLevel:[NSString stringWithFormat:@"%@",[dict objectForKey:@"popularityLevel"]]];
        if(![[dict objectForKey:@"foremanDesc"] isEqual:[NSNull null]])
            [obj setForemanDesc:[NSString stringWithFormat:@"%@",[dict objectForKey:@"foremanDesc"]]];
        if(![[dict objectForKey:@"foremanMobile"] isEqual:[NSNull null]])
            [obj setForemanMobile:[NSString stringWithFormat:@"%@",[dict objectForKey:@"foremanMobile"]]];
        if(![[dict objectForKey:@"address"] isEqual:[NSNull null]])
            [obj setAddress:[NSString stringWithFormat:@"%@",[dict objectForKey:@"address"]]];
        if(![[dict objectForKey:@"collectPoints"] isEqual:[NSNull null]])
            [obj setCollectPoints:[NSString stringWithFormat:@"%@",[dict objectForKey:@"collectPoints"]]];
        if(![[dict objectForKey:@"browsePoints"] isEqual:[NSNull null]])
            [obj setBrowsePoints:[NSString stringWithFormat:@"%@",[dict objectForKey:@"browsePoints"]]];
        if([[dict objectForKey:@"foremanAuthzs"] count])
            obj.foremanAuthzs=[dict objectForKey:@"foremanAuthzs"];
        if(![[dict objectForKey:@"state"] isEqual:[NSNull null]])
            [obj setState:[NSString stringWithFormat:@"%@",[dict objectForKey:@"state"]]];
        if(![[dict objectForKey:@"teamMemberNum"] isEqual:[NSNull null]])
        [obj setTeamMemberNum:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"teamMemberNum"] intValue]]];
        if(![[dict objectForKey:@"appointmentNum"] isEqual:[NSNull null]])
            [obj setAppointmentNum:[NSString stringWithFormat:@"%@",[dict objectForKey:@"appointmentNum"]]];
        
        return obj;
    }
}

@end
