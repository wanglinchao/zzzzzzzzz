//
//  MyOrderDetailViewController.h
//  IDIAI
//
//  Created by Ricky on 15-1-21.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "MyOrderModel.h"
@class MyOrderDetailViewController;

@protocol MyOrderDetailDelegate <NSObject>

- (void)stateBtnDidClick:(MyOrderDetailViewController *)myOrderDetailVC;

@end

@interface MyOrderDetailViewController : GeneralWithBackBtnViewController

@property (assign, nonatomic) id <MyOrderDetailDelegate> delegate;

@property (strong, nonatomic) MyOrderModel *myOrderModel;

@property (copy, nonatomic) NSString *orderIDStr;
@property (assign, nonatomic) NSInteger orderStateInteger;

@end
