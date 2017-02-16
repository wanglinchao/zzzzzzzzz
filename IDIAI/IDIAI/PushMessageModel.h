//
//  PushMessageModel.h
//  IDIAI
//
//  Created by Ricky on 15-1-21.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushMessageModel : NSObject

@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger messageID;
@property (copy, nonatomic) NSString *headImgPath;
@property (copy, nonatomic) NSString *name;

@end
