//
//  EnterSMSCodeView.m
//  IDIAI
//
//  Created by iMac on 15-4-7.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "EnterSMSCodeView.h"
#import "HexColor.h"
#import "EnterPasswordView.h"
#import "EnterMobileNumView.h"
#import "TLToast.h"

#define kAlertWidth frame.size.width
#define kAlertHeight frame.size.height

@implementation EnterSMSCodeView
@synthesize check_Number,Req_typeSMS,delegate_SMS,fromResgi;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(id)initWithFrame:(CGRect)frame leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle display:(NSInteger)display dismiss:(NSInteger)dismiss smsCodeTime:(NSInteger)smscodetime
{
    self=[super initWithFrame:frame];
    if (self) {
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText:) name:UITextFieldTextDidChangeNotification object:nil];
        
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        control = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.45];
        //[control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        self.display_start=display;
        self.dismiss_end=dismiss;
        
        UIView *line_top=[[UIView alloc]initWithFrame:CGRectMake(15, 50, self.frame.size.width-30, 0.5)];
        line_top.backgroundColor=[UIColor colorWithHexString:@"#E6E6E6" alpha:0.8];
        [self addSubview:line_top];
        
        UIView *line_center=[[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-0.5)/2, 55, 0.5, 40)];
        line_center.backgroundColor=[UIColor colorWithHexString:@"#E6E6E6" alpha:0.8];
        [self addSubview:line_center];
        
        UIButton *btn_quex = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_quex.frame = CGRectMake(0, 55,self.frame.size.width/2, 40);
        btn_quex.tag = 10;
        [btn_quex setTitle:leftTitle forState:UIControlStateNormal];
        [btn_quex setTitleColor:[UIColor colorWithHexString:@"#A6A5AB" alpha:1.0] forState:UIControlStateNormal];
        [btn_quex addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_quex];
        
        UIButton *btn_quer = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_quer.frame = CGRectMake(self.frame.size.width/2, 55, self.frame.size.width/2, 40);
        btn_quer.tag = 11;
        btn_quer.enabled=NO;
        [btn_quer setTitle:rigthTitle forState:UIControlStateNormal];
        [btn_quer setTitleColor:[UIColor colorWithHexString:@"#A6A5AB" alpha:1.0] forState:UIControlStateNormal];
        [btn_quer addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_quer];
        
        UIButton *btn_forgetpwd = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_forgetpwd.frame = CGRectMake(self.frame.size.width-95, 10, 90, 40);
        btn_forgetpwd.tag = 12;
        [btn_forgetpwd setTitle:@"(重新发送)" forState:UIControlStateNormal];
        [btn_forgetpwd setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
        btn_forgetpwd.titleLabel.font=[UIFont systemFontOfSize:13];
        btn_forgetpwd.titleEdgeInsets=UIEdgeInsetsMake(20, 0, 5, 0);
        [btn_forgetpwd addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_forgetpwd];
        
        self.textf_mobile=[[UITextField alloc]initWithFrame:CGRectMake(30, 10, self.frame.size.width-120, 30)];
        [self.textf_mobile setBorderStyle:UITextBorderStyleNone]; //外框类型
        self.textf_mobile.placeholder = @"请输入手机验证码"; //默认显示的字
        self.textf_mobile.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textf_mobile.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //self.textf.returnKeyType = UIReturnKeyDone;
        self.textf_mobile.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        self.textf_mobile.tintColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
        self.textf_mobile.keyboardType=UIKeyboardTypeNumberPad;
        [self addSubview:self.textf_mobile];
        
        [self.textf_mobile becomeFirstResponder];
        
        self.smsDownTime=smscodetime;
        [self runloopTime:self.smsDownTime];
    }
    
    return self;
}

-(void)createProgressView{
    if (!phud) {
        phud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:phud];
        phud.mode=MBProgressHUDModeIndeterminate;
        //self.pHUD.dimBackground=YES; //是否开启背景变暗
        // phud.labelText = @"数据加载中...";
        phud.blur=NO;  //是否开启ios7毛玻璃风格
        phud.darkBlur=YES; //受blur限制（blur为YES时设置darkBlur才有用）
        [phud show:YES];
    }
    else{
        [phud show:YES];
    }
}

//获取验证码倒计时
-(void)runloopTime:(NSInteger)downTime{
    __block NSInteger timeout=downTime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UIButton *btn=(UIButton *)[self viewWithTag:12];
                btn.enabled=YES;
                [btn setTitle:@"( 重新发送 )" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
                self.smsDownTime=0;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"( %ld秒后重发 )", (long)timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UIButton *btn=(UIButton *)[self viewWithTag:12];
                btn.enabled=NO;
                [btn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateDisabled];
                [btn setTitleColor:[UIColor colorWithHexString:@"#BAB9BE" alpha:1.0] forState:UIControlStateDisabled];
            });
            timeout--;
            self.smsDownTime=timeout;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark -
#pragma mark - UIButton

-(void)btnPressed:(UIButton *)sender{
    if(sender.tag==10){
         [control removeFromSuperview];
        [self dismiss];
        EnterMobileNumView *entermob=[[EnterMobileNumView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-100)/2, kMainScreenWidth-60, 100)leftButtonTitle:@"返回" rightButtonTitle:@"下一步" display:1 dismiss:2];
        entermob.resgi_Number=check_Number;
        entermob.Req_type=Req_typeSMS;
        entermob.delegate_mobile=delegate_SMS;
        entermob.fromResgi=fromResgi;
        [entermob show];
    }
    else if (sender.tag==11){
        [self createProgressView];
        [self SendSMScodeToServer];
    }
    else{
        if([Req_typeSMS isEqualToString:@"resgister"]) [self SendmobileNumToServer];
        else [self NetworkRequestTwo];
    }
}

//想服务器发送验证码
-(void)SendSMScodeToServer{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0009\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"smsCode\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],check_Number,self.textf_mobile.text];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                //NSLog(@"1---返回信息：%@",jsonDict);
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10101) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [control removeFromSuperview];
                        [self dismiss];
                        EnterPasswordView *entermob=[[EnterPasswordView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"返回" rightButtonTitle:@"完成" display:1 dismiss:2 smsCodeTime:self.smsDownTime];
                        [entermob show];
                        entermob.Req_typepwd=Req_typeSMS;
                        entermob.pwd_Number=check_Number;
                        entermob.delegate_pwd=delegate_SMS;
                        entermob.fromResgi=fromResgi;
                        [phud hide:YES];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10102){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"请输入正确的手机验证码" topOffset:220.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10103){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"验证码已失效" topOffset:220.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10109){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"验证失败" topOffset:220.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"验证失败" topOffset:220.0f duration:1.0];
                    });
                }
            });
        }
                               failedBlock:^{
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [phud hide:YES];
                                       [TLToast showWithText:@"验证失败" topOffset:220.0f duration:1.0];
                                   });
                               }
                                    method:url postDict:nil];
    });
    
}

//向服务器发送手机号来获取短信验证码
-(void)SendmobileNumToServer{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0008\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],check_Number];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                // NSLog(@"2----返回信息：%@",jsonDict);
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10091) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        self.smsDownTime=60;
                        [self runloopTime:self.smsDownTime];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10002){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"不是有效手机号" topOffset:220.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10092){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"手机号码已经注册过" topOffset:220.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10099){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"获取验证码失败" topOffset:220.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"获取验证码失败" topOffset:220.0f duration:1.0];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [phud hide:YES];
                                  [TLToast showWithText:@"获取验证码失败" topOffset:220.0f duration:1.0];
                              });
                          }
                               method:url postDict:nil];
    });
    
}

//向服务器发送手机号修改密码
-(void)NetworkRequestTwo{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0023\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],check_Number];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req cancelRequest];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"3---返回信息：%@",jsonDict);
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10131) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        self.smsDownTime=60;
                        [self runloopTime:self.smsDownTime];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10132){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"手机号码未注册" topOffset:220.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10139){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"连接服务器失败" topOffset:220.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"连接服务器失败" topOffset:220.0f duration:1.0];
                    });
                }
                
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [phud hide:YES];
                                  [TLToast showWithText:@"连接服务器失败" topOffset:220.0f duration:1.0];
                              });
                          }
                               method:url postDict:nil];
    });
    
}

#pragma mark -
#pragma mark - Public Methods

- (void)show {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    if(self.display_start==0){
        [keywindow addSubview:control];
        [keywindow addSubview:self];
    }
    
    else if(self.display_start==1){
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            self.alpha = 1;
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [keywindow addSubview:control];
            [keywindow addSubview:self];
        }];
    }
    
    if(self.display_start==2){
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            self.alpha = 1.0;
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            [UIView animateWithDuration:0.005 animations:^{
                self.alpha = 1;
                self.transform = CGAffineTransformMakeScale(1, 1);
                [keywindow addSubview:control];
                [keywindow addSubview:self];
            }];
            
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
    }
    
    if(self.display_start==3){
        self.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            self.alpha = 1.0;
            self.transform = CGAffineTransformMakeScale(-1.2, 0.2);
            [UIView animateWithDuration:0.05 animations:^{
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                [keywindow addSubview:control];
                [keywindow addSubview:self];
            }];
            
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
    }
    
    if(self.display_start==4){
        self.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            self.transform = CGAffineTransformMakeScale(-1.2, -1.2);
            self.alpha = 1.0;
            [UIView animateWithDuration:0.15 animations:^{
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                [keywindow addSubview:control];
                [keywindow addSubview:self];
            }];
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
    }
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f-50);
}

-(void)dismiss{
    //效果一
    if(self.dismiss_end==1){
        [UIView animateWithDuration:.35 animations:^{
            self.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [control removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }
    
    //效果二
    else if(self.dismiss_end==2){
        [UIView animateWithDuration:.35 animations:^{
            self.transform = CGAffineTransformMakeScale(0.91, -0.01);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [control removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }
    
    //效果三
    else if(self.dismiss_end==3){
        [UIView animateWithDuration:.35 animations:^{
            self.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [control removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }
    
    //效果四
    else if(self.dismiss_end==4){
        [UIView animateWithDuration:.35 animations:^{
            self.transform = CGAffineTransformMakeScale(-0.1, -0.1);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [control removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }
}

#pragma mark -
#pragma mark - UITextFieldDelegate

-(void)changeText:(NSNotification *)notif{
    if(self.textf_mobile.text.length>=6){
        UIButton *btn=(UIButton *)[self viewWithTag:11];
        btn.enabled=YES;
        [btn setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
    }
    else{
        UIButton *btn_=(UIButton *)[self viewWithTag:11];
        btn_.enabled=NO;
        [btn_ setTitleColor:[UIColor colorWithHexString:@"#A6A5AB" alpha:1.0] forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
