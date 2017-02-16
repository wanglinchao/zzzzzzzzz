//
//  GongzhangListObj.h
//  IDIAI
//
//  Created by iMac on 15-2-4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GongzhangListObj : NSObject

@property (strong, nonatomic) NSString *foremanId;
@property (strong, nonatomic) NSString *foremanIconPath;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *foremanExperience;
@property (strong, nonatomic) NSString *popularityLevel;
@property (strong, nonatomic) NSString *foremanDesc;
@property (strong, nonatomic) NSString *foremanMobile;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *collectPoints;
@property (strong, nonatomic) NSString *browsePoints;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSArray *foremanAuthzs;
@property (strong, nonatomic) NSString *teamMemberNum;
@property (strong, nonatomic) NSString *appointmentNum;

+(GongzhangListObj *)objWithDict:(NSDictionary *)dict;

@end
