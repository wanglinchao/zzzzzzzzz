//
//  EnterMobileNumView.h
//  IDIAI
//
//  Created by iMac on 15-4-7.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@protocol registerDelegate <NSObject>
@optional
-(void)registerSucceedWithParemeters:(id)paremeters;
@end

@interface EnterMobileNumView : UIView<UITextFieldDelegate>
{
    UIControl *control;
    MBProgressHUD *phud;
}

@property(nonatomic,strong)UIView *mainPartView;
@property(nonatomic,strong)UILabel * voiceLab;
@property(nonatomic,strong)UIButton * voiceBtn;
@property (nonatomic, assign) NSInteger display_start;
@property (nonatomic, assign) NSInteger dismiss_end;
@property (nonatomic, strong) UITextField *textf_mobile;
@property (nonatomic, strong) UITextField *textf_smsCode;
@property (nonatomic, strong) UITextField *textf_passWord;
@property (nonatomic, strong) UIButton * smsCodeBtn;
@property (nonatomic, strong) UIButton * securityInPutBtn;
@property (strong, nonatomic) NSString *resgi_Number;
@property (strong, nonatomic) NSString *Req_type;
@property (nonatomic, assign) NSInteger gettingWay;//获取验证的方法。1 短信验证 2 语音验证
@property (strong, nonatomic) NSString *fromResgi;  //是否从登录页面跳转过来，YES：是    NO：否
@property (assign, nonatomic) NSInteger smsDownTime;
@property (weak, nonatomic) id delegate_mobile;
@property (nonatomic,assign)BOOL isVerifyByVoice;//是否是语音验证
@property (nonatomic,weak)id<registerDelegate>registerDelegate;

-(id)initWithFrame:(CGRect)frame leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle display:(NSInteger)display dismiss:(NSInteger)dismiss;

-(void)show;

@end
