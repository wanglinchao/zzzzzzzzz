//
//  GongzhangInfoObj.m
//  IDIAI
//
//  Created by iMac on 15-2-4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GongzhangInfoObj.h"

@implementation GongzhangInfoObj

+(GongzhangInfoObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        GongzhangInfoObj *obj = [[GongzhangInfoObj alloc] init];
        if(![[dict objectForKey:@"foremanId"] isEqual:[NSNull null]])
            [obj setForemanId:[NSString stringWithFormat:@"%@",[dict objectForKey:@"foremanId"]]];
        if(![[dict objectForKey:@"foremanIconPath"] isEqual:[NSNull null]])
            [obj setForemanIconPath:[NSString stringWithFormat:@"%@",[dict objectForKey:@"foremanIconPath"]]];
        if(![[dict objectForKey:@"nickName"] isEqual:[NSNull null]])
            [obj setNickName:[NSString stringWithFormat:@"%@",[dict objectForKey:@"nickName"]]];
        if(![[dict objectForKey:@"foremanExperience"] isEqual:[NSNull null]])
            [obj setForemanExperience:[NSString stringWithFormat:@"%@",[dict objectForKey:@"foremanExperience"]]];
        if(![[dict objectForKey:@"foremanLevel"] isEqual:[NSNull null]])
            [obj setForemanLevel:[NSString stringWithFormat:@"%@",[dict objectForKey:@"foremanLevel"]]];
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
        if(![[dict objectForKey:@"state"] isEqual:[NSNull null]])
            [obj setState:[NSString stringWithFormat:@"%@",[dict objectForKey:@"state"]]];
        if([[dict objectForKey:@"foremanAuthzs"] count])
            obj.foremanAuthzs=[dict objectForKey:@"foremanAuthzs"];
        if([[dict objectForKey:@"foremanImagesPath"] count])
            obj.foremanImagesPath=[dict objectForKey:@"foremanImagesPath"];
        if(![[dict objectForKey:@"appointmentNum"] isEqual:[NSNull null]])
            [obj setAppointmentNum:[NSString stringWithFormat:@"%@",[dict objectForKey:@"appointmentNum"]]];
        if([[dict objectForKey:@"foremanSiteses"] count])
            obj.foremanSiteses=[dict objectForKey:@"foremanSiteses"];
        if([[dict objectForKey:@"specialtyFeatureIds"] count])
            obj.specialtyFeatureIds=[dict objectForKey:@"specialtyFeatureIds"];
        if(![[dict objectForKey:@"waterElectrianNum"] isEqual:[NSNull null]])
            [obj setWaterElectrianNum:[NSString stringWithFormat:@"%@",[dict objectForKey:@"waterElectrianNum"]]];
        if(![[dict objectForKey:@"bricklayerNum"] isEqual:[NSNull null]])
            [obj setBricklayerNum:[NSString stringWithFormat:@"%@",[dict objectForKey:@"bricklayerNum"]]];
        if(![[dict objectForKey:@"carpenterNum"] isEqual:[NSNull null]])
            [obj setCarpenterNum:[NSString stringWithFormat:@"%@",[dict objectForKey:@"carpenterNum"]]];
        if(![[dict objectForKey:@"painterNum"] isEqual:[NSNull null]])
            [obj setPainterNum:[NSString stringWithFormat:@"%@",[dict objectForKey:@"painterNum"]]];
        if(![[dict objectForKey:@"otherNum"] isEqual:[NSNull null]])
            [obj setOtherNum:[NSString stringWithFormat:@"%@",[dict objectForKey:@"otherNum"]]];
        if(![[dict objectForKey:@"objId"] isEqual:[NSNull null]])
            [obj setObjId:[NSString stringWithFormat:@"%@",[dict objectForKey:@"objId"]]];
        if(![[dict objectForKey:@"successOrderPoint"] isEqual:[NSNull null]])
            [obj setSuccessOrderPoint:[NSString stringWithFormat:@"%@",[dict objectForKey:@"successOrderPoint"]]];
        return obj;
    }
}


@end
