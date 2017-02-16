//
//  CircleProgressHUD.h
//  IDIAI
//
//  Created by iMac on 14-7-11.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressHUD : UIView
{
    UIControl *control;
}

@property (nonatomic, strong) UIImageView *imageview_bg;
@property (nonatomic, strong) UILabel *title_main;
@property (nonatomic, strong) UILabel *title_sub;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, assign) NSInteger display_start;
@property (nonatomic, assign) NSInteger dismiss_end;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

- (void)show;

- (void)hide;

@end
