//
//  SupersiorInfoObj.h
//  IDIAI
//
//  Created by iMac on 15-2-4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupersiorInfoObj : NSObject

@property (strong, nonatomic) NSString *supervisorId;
@property (strong, nonatomic) NSString *supervisorLogoUrl;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *experience;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *supervisorLevel;
@property (strong, nonatomic) NSString *description_;
@property (strong, nonatomic) NSString *mobileNo;
@property (strong, nonatomic) NSString *phoneNo;
@property (strong, nonatomic) NSString *supervisorWorks;
@property (strong, nonatomic) NSString *browsePoints;
@property (strong, nonatomic) NSString *collectPoints;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *qualificationRating;

@property (strong, nonatomic) NSString *appointmentNum;
@property (strong, nonatomic) NSString *priceMin;
@property (strong, nonatomic) NSString *priceMax;
@property (nonatomic,strong) NSString * objId;

@property (strong, nonatomic) NSArray *authzs;
@property (strong, nonatomic) NSArray *supervisorImagesPath;
@property (strong, nonatomic) NSArray *specialtyFeatureIds;

@property (nonatomic,strong) NSString * successOrderPoint;
+(SupersiorInfoObj *)objWithDict:(NSDictionary *)dict;

@end
