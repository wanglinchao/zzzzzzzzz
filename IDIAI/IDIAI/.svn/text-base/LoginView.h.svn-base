//
//  LoginView.h
//  IDIAI
//
//  Created by iMac on 15-4-7.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SPKitExample.h"
@protocol LoginViewDelegate <NSObject>
-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict;//登录或注册成功回调
//-(void)pushToConversitonListViewControllerWithbePushedViewController:(UIViewController*)viewController;//跳到IM会话列表
@end

@interface LoginView : UIView<UITextFieldDelegate>
{
    UIControl *control;
    MBProgressHUD *phud;
}
@property (nonatomic, weak) id<LoginViewDelegate>delegate;
@property (nonatomic, assign) NSInteger display_start;
@property (nonatomic, assign) NSInteger dismiss_end;
@property (nonatomic, strong) UITextField *textf_mobile;
@property (nonatomic, strong) UITextField *textf_pwd;

@property (strong, nonatomic) NSString *mobile_Number;

-(id)initWithFrame:(CGRect)frame leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle display:(NSInteger)display dismiss:(NSInteger)dismiss;

-(void)show;

+(void)addIMServiceCountWithUserMobile:(NSString*)userMobile andWeakSpkitExample:(SPKitExample*) weakSpkitExample;
@end
