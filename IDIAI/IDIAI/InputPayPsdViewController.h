//
//  InputPayPsdViewController.h
//  IDIAI
//
//  Created by Ricky on 15-2-2.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "MyOrderModel.h"
#import "OrderDetailModel.h"
#import "ConfirmOrderOfGoodsModel.h"
#import "OrderOfGoodsListModel.h"

@interface InputPayPsdViewController : GeneralWithBackBtnViewController

@property (strong, nonatomic) MyOrderModel *myOrderModel;
@property (strong, nonatomic) OrderDetailModel *orderDetailModel;

@property (copy, nonatomic) NSString *sourceVC;

@property (strong, nonatomic) OrderOfGoodsListModel *detailModel;

@property (copy, nonatomic) NSString *fromStr;

@end
