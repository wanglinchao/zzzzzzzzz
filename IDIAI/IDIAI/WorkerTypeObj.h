//
//  WorkerTypeObj.h
//  IDIAI
//
//  Created by iMac on 14-10-27.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkerTypeObj : NSObject

@property (assign, nonatomic) NSInteger jobScopeId;
@property (strong, nonatomic) NSString *JobScopeImgPath;
@property (strong, nonatomic) NSString *jobScopeName;

+(WorkerTypeObj *)objWithDict:(NSDictionary *)dict;

@end
