//
//  OrderOfGoodsListModel.h
//  IDIAI
//
//  Created by Ricky on 15/5/21.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderOfGoodsListModel : NSObject

@property (copy, nonatomic) NSString *buyerAddress;

@property (copy, nonatomic) NSString *buyerName;

@property (copy, nonatomic) NSString *buyerPhone;

@property (copy, nonatomic) NSString *createAt;

@property (assign, nonatomic) CGFloat goodsTotal;

@property (assign, nonatomic) CGFloat goodsTotalMoney;

@property (assign, nonatomic) NSInteger orderId;

@property (assign, nonatomic) NSInteger orderStatus;

@property (assign, nonatomic) CGFloat orderTotalMoney;

@property (copy, nonatomic) NSString *payDate;

@property (assign, nonatomic) CGFloat shipFee;

@property (assign, nonatomic) NSInteger shopId;

@property (copy, nonatomic) NSString *shopLogoPath;

@property (copy, nonatomic) NSString *shopName;

@property (strong, nonatomic) NSMutableArray *shopOrderDetailes;

@property (copy, nonatomic) NSString *shopPhone;

@property (copy, nonatomic) NSString *orderCode;

@property (copy, nonatomic) NSString *userMessage;
@property (nonatomic,assign) double originalTotalFee;
@property (assign, nonatomic) NSInteger state;
@property (strong, nonatomic) NSString *stateName;
@property (assign, nonatomic) double alreadyPayment;
@property (assign, nonatomic) double waitePayment;
@property (nonatomic, assign)double couponTotalFee;
@end
