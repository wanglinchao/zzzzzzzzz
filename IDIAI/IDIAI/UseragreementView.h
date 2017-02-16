//
//  UseragreementView.h
//  IDIAI
//
//  Created by iMac on 14-7-15.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UseragreementView : UIView
{
    UIControl *control;
}
@property (nonatomic, strong) UIButton *back_Button;
@property (nonatomic, strong) UILabel *title_Lab;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)show;

@end
