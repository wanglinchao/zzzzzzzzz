//
//  GoodslistObj.m
//  IDIAI
//
//  Created by iMac on 14-8-6.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GoodslistObj.h"

@implementation GoodslistObj

+(GoodslistObj *)objWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        
        GoodslistObj *obj = [[GoodslistObj alloc] init];
        if(![[dict objectForKey:@"shopId"] isEqual:[NSNull null]])
            [obj setShopID:[NSString stringWithFormat:@"%@",[dict objectForKey:@"shopId"]]];
        if(![[dict objectForKey:@"shopLevel"] isEqual:[NSNull null]])
            [obj setShopLevel:[dict objectForKey:@"shopLevel"]];
        if(![[dict objectForKey:@"shopLongitude"] isEqual:[NSNull null]])
            [obj setShopLongitude:[dict objectForKey:@"shopLongitude"]];
        if(![[dict objectForKey:@"shopLatitude"] isEqual:[NSNull null]])
            [obj setShopLatitude:[NSString stringWithFormat:@"%@",[dict objectForKey:@"shopLatitude"]]];
        if(![[dict objectForKey:@"shopName"] isEqual:[NSNull null]])
            [obj setShopName:[dict objectForKey:@"shopName"]];
        if(![[dict objectForKey:@"shopLogoPath"] isEqual:[NSNull null]])
            [obj setShopLogoPath:[dict objectForKey:@"shopLogoPath"]];
        if(![[dict objectForKey:@"shopLitimgPath"] isEqual:[NSNull null]])
            [obj setShopLitimgPath:[dict objectForKey:@"shopLitimgPath"]];
        if(![[dict objectForKey:@"shopAddress"] isEqual:[NSNull null]])
            [obj setShopAddress:[NSString stringWithFormat:@"%@",[dict objectForKey:@"shopAddress"]]];
        if(![[dict objectForKey:@"shopDescription"] isEqual:[NSNull null]])
            [obj setShopDescription:[dict objectForKey:@"shopDescription"]];
        if(![[dict objectForKey:@"shopPhone"] isEqual:[NSNull null]])
            [obj setShopPhoneNum:[dict objectForKey:@"shopPhone"]];
        if(![[dict objectForKey:@"shopMobile"] isEqual:[NSNull null]])
            [obj setShopMobileNum:[NSString stringWithFormat:@"%@",[dict objectForKey:@"shopMobile"]]];
        if(![[dict objectForKey:@"shopContact"] isEqual:[NSNull null]])
            [obj setShopContact:[dict objectForKey:@"shopContact"]];
        if(![[dict objectForKey:@"distance"] isEqual:[NSNull null]])
            [obj setDistance:[NSString stringWithFormat:@"%@",[dict objectForKey:@"distance"]]];
        if([[dict objectForKey:@"shopBusinessType"]count]){
            [obj setShopBusinessType:[dict objectForKey:@"shopBusinessType"]];
        }
        if([[dict objectForKey:@"shopImgPath"] count]){
            obj.arr_picture=[dict objectForKey:@"shopImgPath"];
        }
        if([[dict objectForKey:@"shopIdentificationType"] count]){
            obj.arr_rztype=[dict objectForKey:@"shopIdentificationType"];
        }
        if(![[dict objectForKey:@"browsePoints"] isEqual:[NSNull null]])
            [obj setShopBrowsePoints:[NSString stringWithFormat:@"%@",[dict objectForKey:@"browsePoints"]]];
        if(![[dict objectForKey:@"collectPoints"] isEqual:[NSNull null]])
            [obj setShopCollectPoints:[NSString stringWithFormat:@"%@",[dict objectForKey:@"collectPoints"]]];
        
        return obj;
    }
}

@end
