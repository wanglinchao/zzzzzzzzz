//
//  GoodslistObj.h
//  IDIAI
//
//  Created by iMac on 14-8-6.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodslistObj : NSObject

@property (strong, nonatomic) NSString *shopID;
@property (strong, nonatomic) NSString *shopLevel;
@property (strong, nonatomic) NSString *shopLongitude;
@property (strong, nonatomic) NSString *shopLatitude;
@property (strong, nonatomic) NSString *shopName;
@property (strong, nonatomic) NSString *shopLogoPath;
@property (strong, nonatomic) NSString *shopLitimgPath;
@property (strong, nonatomic) NSString *shopAddress;
@property (strong, nonatomic) NSString *shopDescription;
@property (strong, nonatomic) NSString *shopPhoneNum;
@property (strong, nonatomic) NSString *shopMobileNum;
@property (strong, nonatomic) NSString *ShopContact;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *shopBrowsePoints;
@property (strong, nonatomic) NSString *shopCollectPoints;
@property (strong, nonatomic) NSMutableArray *shopBusinessType;
@property (strong, nonatomic) NSMutableArray *arr_picture;
@property (strong, nonatomic) NSMutableArray *arr_rztype;

+(GoodslistObj *)objWithDict:(NSDictionary *)dict;

@end
