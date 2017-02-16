//
//  RefundDetailViewController.h
//  IDIAI
//
//  Created by Ricky on 15-2-4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "RefundListModel.h"
@class RefundDetailViewController;

@protocol RefundDetailVCDelegate <NSObject>

- (void)stateBtnDidClick:(RefundDetailViewController *)myOrderDetailVC;

@end



@interface RefundDetailViewController : GeneralWithBackBtnViewController


@property (assign, nonatomic) id <RefundDetailVCDelegate> delegate;

@property (strong, nonatomic) RefundListModel *refundListModel;

@property (copy, nonatomic) NSString *refundIDStr;

@property (nonatomic,strong) UIButton *btn_phone;
@end
