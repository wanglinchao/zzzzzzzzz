//
//  MySubscribeDetailViewController.h
//  IDIAI
//
//  Created by Ricky on 15-1-18.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "SubscribeListModel.h"
@class MySubscribeDetailViewController;

@protocol MySubscribeDetailDelegate <NSObject>

- (void)stateBtnDidClick:(MySubscribeDetailViewController *)mySubscribeDetailVC;

@end

@interface MySubscribeDetailViewController : GeneralWithBackBtnViewController{
    BOOL is_open_first;
    BOOL is_open_second;
    BOOL is_open_third;
    BOOL is_open_fourth;
    BOOL is_change_first;
    BOOL is_change_second;
    BOOL is_change_third;
    BOOL is_change_fourth;
}

@property (nonatomic,assign) NSInteger count_first;
@property (nonatomic,assign) NSInteger count_second;
@property (nonatomic,assign) NSInteger count_third;
@property (nonatomic,assign) NSInteger count_fouth;
@property (nonatomic,strong) UIImageView *imv_zkai;
@property (nonatomic,strong) UIImageView *imv_zkai_seond;
@property (nonatomic,strong) UIImageView *imv_zkai_third;
@property (nonatomic,strong) UIImageView *imv_zkai_fourth;

@property (assign, nonatomic) id <MySubscribeDetailDelegate> delegate;

@property (strong, nonatomic) SubscribeListModel *subscribeListModel;

@property (strong, nonatomic) NSString *fromStr;

@end
