//
//  EnterSMSCodeView.h
//  IDIAI
//
//  Created by iMac on 15-4-7.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface EnterSMSCodeView : UIView
{
    UIControl *control;
    MBProgressHUD *phud;
}

@property (nonatomic, assign) NSInteger display_start;
@property (nonatomic, assign) NSInteger dismiss_end;
@property (nonatomic, strong) UITextField *textf_mobile;

@property (strong, nonatomic) NSString *check_Number;
@property (strong, nonatomic) NSString *Req_typeSMS;

@property (strong, nonatomic) NSString *fromResgi;  //是否从登录页面跳转过来，YES：是    NO：否
@property (assign, nonatomic) NSInteger smsDownTime;  //短信验证码倒计时

@property (weak, nonatomic) id delegate_SMS;

-(id)initWithFrame:(CGRect)frame leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle display:(NSInteger)display dismiss:(NSInteger)dismiss smsCodeTime:(NSInteger)smscodetime;

-(void)show;

@end
