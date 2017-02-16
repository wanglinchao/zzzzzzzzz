//
//  RefundDetailViewController.h
//  IDIAI
//
//  Created by Ricky on 15-2-4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "AfterSaleListModel.h"
@class AfterSaleDetailViewController;

@protocol RefundDetailVCDelegate <NSObject>

- (void)stateBtnDidClick:(AfterSaleDetailViewController *)myOrderDetailVC;

@end



@interface AfterSaleDetailViewController : GeneralWithBackBtnViewController


@property (assign, nonatomic) id <RefundDetailVCDelegate> delegate;

@property (strong, nonatomic) AfterSaleListModel *afterSaleListModel;

@property (copy, nonatomic) NSString *afterSaleIDStr;

@property (nonatomic,strong) UIButton *btn_phone;
@end
