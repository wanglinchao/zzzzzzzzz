//
//  OrderDetailModel.h
//  IDIAI
//
//  Created by Ricky on 15-1-30.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property (copy, nonatomic) NSString *orderCode;
@property (copy, nonatomic) NSString *userCommunityName;
@property (copy, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger orderType;
@property (assign, nonatomic) NSInteger nowPhase;
@property (copy, nonatomic) NSString *nowPhaseName;
@property (assign, nonatomic) float nowPhaseFee;
@property (assign, nonatomic) NSInteger orderState;
@property (copy, nonatomic) NSString *orderStateName;
@property (copy, nonatomic) NSString *servantName;
@property (strong, nonatomic) NSMutableArray *orderPhase;
@property (assign, nonatomic) float refundFee;
@property (copy, nonatomic) NSString *refundId;
@property (copy, nonatomic) NSString *servantId;

@property (assign, nonatomic) NSInteger resCode;

@end
