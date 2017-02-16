//
//  MyOrderModel.h
//  IDIAI
//
//  Created by Ricky on 15-1-21.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject

@property (copy, nonatomic) NSString *orderCode;
@property (copy, nonatomic) NSString *userCommunityName;
@property (assign,nonatomic) float orderTotalFee;
@property (assign,nonatomic) NSInteger orderType;
@property (copy, nonatomic) NSString *orderPhraseName;
@property (assign,nonatomic) float orderPhraseFee;
@property (assign,nonatomic) NSInteger orderState;
@property (copy, nonatomic) NSString *stateName;
@property (copy, nonatomic) NSString *servantName;
@property (assign,nonatomic) float refundFee;
@property (copy, nonatomic) NSString *refundId;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *orderCodePhase;
@property (copy, nonatomic) NSString *nowPhrase;
@property (copy, nonatomic) NSString *servantId;

@end

