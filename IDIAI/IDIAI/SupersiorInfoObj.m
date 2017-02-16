//
//  SupersiorInfoObj.m
//  IDIAI
//
//  Created by iMac on 15-2-4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SupersiorInfoObj.h"

@implementation SupersiorInfoObj

+(SupersiorInfoObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        SupersiorInfoObj *obj = [[SupersiorInfoObj alloc] init];
        if(![[dict objectForKey:@"supervisorId"] isEqual:[NSNull null]])
            [obj setSupervisorId:[NSString stringWithFormat:@"%@",[dict objectForKey:@"supervisorId"]]];
        if(![[dict objectForKey:@"supervisorLogoUrl"] isEqual:[NSNull null]])
            [obj setSupervisorLogoUrl:[NSString stringWithFormat:@"%@",[dict objectForKey:@"supervisorLogoUrl"]]];
        if(![[dict objectForKey:@"nickName"] isEqual:[NSNull null]])
            [obj setNickName:[NSString stringWithFormat:@"%@",[dict objectForKey:@"nickName"]]];
        if(![[dict objectForKey:@"experience"] isEqual:[NSNull null]])
            [obj setExperience:[NSString stringWithFormat:@"%@",[dict objectForKey:@"experience"]]];
        if(![[dict objectForKey:@"address"] isEqual:[NSNull null]])
            [obj setAddress:[NSString stringWithFormat:@"%@",[dict objectForKey:@"address"]]];
        if(![[dict objectForKey:@"supervisorLevel"] isEqual:[NSNull null]])
            [obj setSupervisorLevel:[NSString stringWithFormat:@"%@",[dict objectForKey:@"supervisorLevel"]]];
        if(![[dict objectForKey:@"description"] isEqual:[NSNull null]])
            [obj setDescription_:[NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]]];
        if(![[dict objectForKey:@"mobileNo"] isEqual:[NSNull null]])
            [obj setMobileNo:[NSString stringWithFormat:@"%@",[dict objectForKey:@"mobileNo"]]];
        if(![[dict objectForKey:@"phoneNo"] isEqual:[NSNull null]])
            [obj setPhoneNo:[NSString stringWithFormat:@"%@",[dict objectForKey:@"phoneNo"]]];
        if(![[dict objectForKey:@"supervisorWorks"] isEqual:[NSNull null]])
            [obj setSupervisorWorks:[NSString stringWithFormat:@"%@",[dict objectForKey:@"supervisorWorks"]]];
        if(![[dict objectForKey:@"browsePoints"] isEqual:[NSNull null]])
            [obj setBrowsePoints:[NSString stringWithFormat:@"%@",[dict objectForKey:@"browsePoints"]]];
        if(![[dict objectForKey:@"collectPoints"] isEqual:[NSNull null]])
            [obj setCollectPoints:[NSString stringWithFormat:@"%@",[dict objectForKey:@"collectPoints"]]];
        if(![[dict objectForKey:@"state"] isEqual:[NSNull null]])
            [obj setState:[NSString stringWithFormat:@"%@",[dict objectForKey:@"state"]]];
        
        if(![[dict objectForKey:@"appointmentNum"] isEqual:[NSNull null]])
            [obj setAppointmentNum:[NSString stringWithFormat:@"%@",[dict objectForKey:@"appointmentNum"]]];
        if(![[dict objectForKey:@"priceMin"] isEqual:[NSNull null]])
            [obj setPriceMin:[NSString stringWithFormat:@"%@",[dict objectForKey:@"priceMin"]]];
        if(![[dict objectForKey:@"priceMax"] isEqual:[NSNull null]])
            [obj setPriceMax:[NSString stringWithFormat:@"%@",[dict objectForKey:@"priceMax"]]];
        if(![[dict objectForKey:@"objId"] isEqual:[NSNull null]])
            [obj setObjId:[NSString stringWithFormat:@"%@",[dict objectForKey:@"objId"]]];
        if(![[dict objectForKey:@"successOrderPoint"] isEqual:[NSNull null]])
            [obj setSuccessOrderPoint:[NSString stringWithFormat:@"%@",[dict objectForKey:@"successOrderPoint"]]];
        
        if([[dict objectForKey:@"authzs"] count])
            obj.authzs=[dict objectForKey:@"authzs"];
        if([[dict objectForKey:@"supervisorImagesPath"] count])
            obj.supervisorImagesPath=[dict objectForKey:@"supervisorImagesPath"];
        if ([dict objectForKey:@"qualificationRating"]) {
            obj.qualificationRating=[dict objectForKey:@"qualificationRating"];
        }
        if([[dict objectForKey:@"specialtyFeatureIds"] count])
            obj.specialtyFeatureIds=[dict objectForKey:@"specialtyFeatureIds"];
        return obj;
    }
}

@end
