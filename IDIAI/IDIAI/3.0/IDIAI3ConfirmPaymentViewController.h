//
//  IDIAI3ConfirmPaymentViewController.h
//  IDIAI
//
//  Created by Ricky on 15/12/30.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralWithBackBtnViewController.h"
@interface IDIAI3ConfirmPaymentViewController : GeneralWithBackBtnViewController
@property(nonatomic,assign)float payforMoney;
@property(nonatomic,assign)NSInteger orderType;
@property(nonatomic,strong)NSString *orderCode;

@property (nonatomic, assign) double numberStart;
@property (nonatomic, strong) UIView *startView;
@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property (nonatomic, assign) double numberStart_two;
@property (nonatomic, strong) UIView *startView_two;
@property (nonatomic, strong) NSMutableArray *imageViewArray_two;

@property (nonatomic, assign) double numberStart_three;
@property (nonatomic, strong) UIView *startView_three;
@property (nonatomic, strong) NSMutableArray *imageViewArray_three;
@property (nonatomic,strong)NSString *fromStr;
@end
