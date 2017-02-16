//
//  DesignerInfoObj.m
//  IDIAI
//
//  Created by iMac on 14-12-3.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DesignerInfoObj.h"

@implementation DesignerInfoObj

+(DesignerInfoObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        DesignerInfoObj *obj = [[DesignerInfoObj alloc] init];
        if(![[dict objectForKey:@"designerID"] isEqual:[NSNull null]])
            [obj setDesignerID:[NSString stringWithFormat:@"%@",[dict objectForKey:@"designerID"]]];
        if(![[dict objectForKey:@"designerName"] isEqual:[NSNull null]])
            [obj setDesignerName:[dict objectForKey:@"designerName"]];
        if(![[dict objectForKey:@"designerIconPath"] isEqual:[NSNull null]])
            [obj setDesignerIconPath:[dict objectForKey:@"designerIconPath"]];
        if(![[dict objectForKey:@"designerExperience"] isEqual:[NSNull null]])
            [obj setDesignerExperience:[NSString stringWithFormat:@"%@",[dict objectForKey:@"designerExperience"]]];
        if(![[dict objectForKey:@"designerAddress"] isEqual:[NSNull null]])
            [obj setDesignerAddress:[dict objectForKey:@"designerAddress"]];
        if(![[dict objectForKey:@"designerLevel"] isEqual:[NSNull null]])
            [obj setDesignerLevel:[NSString stringWithFormat:@"%@",[dict objectForKey:@"designerLevel"]]];
        if(![[dict objectForKey:@"designerDesc"] isEqual:[NSNull null]])
            [obj setDesignerDesc:[dict objectForKey:@"designerDesc"]];
        if(![[dict objectForKey:@"designerWorks"] isEqual:[NSNull null]])
            [obj setDesignerWorks:[NSString stringWithFormat:@"%@",[dict objectForKey:@"designerWorks"]]];
        if(![[dict objectForKey:@"designerMobileNum"] isEqual:[NSNull null]])
            [obj setDesignerMobileNum:[dict objectForKey:@"designerMobileNum"]];
        if(![[dict objectForKey:@"designerPhoneNum"] isEqual:[NSNull null]])
            [obj setDesignerPhoneNum:[dict objectForKey:@"designerPhoneNum"]];
        if(![[dict objectForKey:@"browsePoints"] isEqual:[NSNull null]])
            [obj setDesignerBrowsePoints:[NSString stringWithFormat:@"%@",[dict objectForKey:@"browsePoints"]]];
        if(![[dict objectForKey:@"collectPoints"] isEqual:[NSNull null]])
            [obj setDesignerCollectPoints:[NSString stringWithFormat:@"%@",[dict objectForKey:@"collectPoints"]]];
        if([[dict objectForKey:@"designerIsAuthent"] count]){
            obj.arr_rztype=[dict objectForKey:@"designerIsAuthent"];
        }
        if([[dict objectForKey:@"designerImagesPath"] count]){
            obj.arr_picture=[dict objectForKey:@"designerImagesPath"];
        }
        if(![[dict objectForKey:@"state"] isEqual:[NSNull null]])
            [obj setState:[NSString stringWithFormat:@"%@",[dict objectForKey:@"state"]]];
        
        if(![[dict objectForKey:@"appointmentNum"] isEqual:[NSNull null]])
            [obj setAppointmentNum:[NSString stringWithFormat:@"%@",[dict objectForKey:@"appointmentNum"]]];
        if(![[dict objectForKey:@"priceMin"] isEqual:[NSNull null]])
            [obj setPriceMin:[NSString stringWithFormat:@"%@",[dict objectForKey:@"priceMin"]]];
        if(![[dict objectForKey:@"priceMax"] isEqual:[NSNull null]])
            [obj setPriceMax:[NSString stringWithFormat:@"%@",[dict objectForKey:@"priceMax"]]];
        if(![[dict objectForKey:@"qualificationRating"] isEqual:[NSNull null]])
            [obj setQualificationRating:[NSString stringWithFormat:@"%@",[dict objectForKey:@"qualificationRating"]]];
        
        return obj;
    }
}

@end
