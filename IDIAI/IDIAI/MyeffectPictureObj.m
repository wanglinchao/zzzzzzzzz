//
//  MyeffectPictureObj.m
//  IDIAI
//
//  Created by iMac on 14-7-29.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyeffectPictureObj.h"

@implementation MyeffectPictureObj

+(MyeffectPictureObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        MyeffectPictureObj *obj = [[MyeffectPictureObj alloc] init];
        if(![[dict objectForKey:@"browserNum"] isEqual:[NSNull null]])
            [obj setBrowserNum:[NSString stringWithFormat:@"%@",[dict objectForKey:@"browserNum"]]];
        if(![[dict objectForKey:@"collectionCount"] isEqual:[NSNull null]])
            [obj setCollectionCount:[NSString stringWithFormat:@"%@",[dict objectForKey:@"collectionCount"]]];
        if(![[dict objectForKey:@"collectionName"] isEqual:[NSNull null]])
            [obj setCollectionName:[NSString stringWithFormat:@"%@",[dict objectForKey:@"collectionName"]]];
        if(![[dict objectForKey:@"collectionNum"] isEqual:[NSNull null]])
            [obj setCollectionNum:[NSString stringWithFormat:@"%@",[dict objectForKey:@"collectionNum"]]];
        if(![[dict objectForKey:@"designerID"] isEqual:[NSNull null]])
            [obj setDesignerID:[NSString stringWithFormat:@"%@",[dict objectForKey:@"designerID"]]];
        if(![[dict objectForKey:@"designerImagePath"] isEqual:[NSNull null]])
            [obj setDesignerImagePath:[NSString stringWithFormat:@"%@",[dict objectForKey:@"designerImagePath"]]];
        if(![[dict objectForKey:@"designerName"] isEqual:[NSNull null]])
            [obj setDesignerName:[NSString stringWithFormat:@"%@",[dict objectForKey:@"designerName"]]];
        if(![[dict objectForKey:@"id"] isEqual:[NSNull null]])
            [obj setPicture_id:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]];
        if(![[dict objectForKey:@"imagePath"] isEqual:[NSNull null]])
            [obj setImagePath:[NSString stringWithFormat:@"%@",[dict objectForKey:@"imagePath"]]];
        if(![[dict objectForKey:@"rendreingsHeight"] isEqual:[NSNull null]])
            [obj setRendreingsHeight:[NSString stringWithFormat:@"%@",[dict objectForKey:@"rendreingsHeight"]]];
        if(![[dict objectForKey:@"rendreingsPath"] isEqual:[NSNull null]])
            [obj setRendreingsPath:[NSString stringWithFormat:@"%@",[dict objectForKey:@"rendreingsPath"]]];
        if(![[dict objectForKey:@"shareUrl"] isEqual:[NSNull null]])
            [obj setShareUrl:[NSString stringWithFormat:@"%@",[dict objectForKey:@"shareUrl"]]];
        if(![[dict objectForKey:@"state"] isEqual:[NSNull null]])
            [obj setState:[NSString stringWithFormat:@"%@",[dict objectForKey:@"state"]]];
        
        if(![[dict objectForKey:@"doorModel"] isEqual:[NSNull null]])
            [obj setDoorModel:[NSString stringWithFormat:@"%@",[dict objectForKey:@"doorModel"]]];
        if(![[dict objectForKey:@"buildingArea"] isEqual:[NSNull null]])
            [obj setBuildingArea:[NSString stringWithFormat:@"%@",[dict objectForKey:@"buildingArea"]]];
        if(![[dict objectForKey:@"price"] isEqual:[NSNull null]])
            [obj setPrice:[NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]]];
        if(![[dict objectForKey:@"frameName"] isEqual:[NSNull null]])
            [obj setFrameName:[NSString stringWithFormat:@"%@",[dict objectForKey:@"frameName"]]];
        if(![[dict objectForKey:@"description"] isEqual:[NSNull null]])
            [obj setDescription_:[NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]]];
        if(![[dict objectForKey:@"bathRoom"] isEqual:[NSNull null]])
            [obj setBathRoom:[NSString stringWithFormat:@"%@",[dict objectForKey:@"bathRoom"]]];
        if(![[dict objectForKey:@"livingRoom"] isEqual:[NSNull null]])
            [obj setLivingRoom:[NSString stringWithFormat:@"%@",[dict objectForKey:@"livingRoom"]]];
        if(![[dict objectForKey:@"bedRoom"] isEqual:[NSNull null]])
            [obj setBedRoom:[NSString stringWithFormat:@"%@",[dict objectForKey:@"bedRoom"]]];
        if(![[dict objectForKey:@"objId"] isEqual:[NSNull null]])
            [obj setObjId:[NSString stringWithFormat:@"%@",[dict objectForKey:@"objId"]]];
        if([[dict objectForKey:@"picList"] count])
            [obj setPicList:[dict objectForKey:@"picList"]];
        
        return obj;
    }
}

@end
