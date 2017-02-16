//
//  PushMessageListModel.h
//  IDIAI
//
//  Created by Ricky on 15-1-20.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushMessageListModel : NSObject

@property(assign, nonatomic) NSInteger resCode;
@property(strong, nonatomic) NSArray *noticeList;
@property(strong, nonatomic) NSDate  *timeStamp;
@property(assign, nonatomic) NSInteger currentPage;
@property(assign, nonatomic) NSInteger pageRow;
@property(assign, nonatomic) NSInteger totoalRow;
@property(assign, nonatomic) NSInteger totalPage;

@end
