//
//  EnterPasswordView.m
//  IDIAI
//
//  Created by iMac on 15-4-7.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "EnterPasswordView.h"
#import "HexColor.h"
#import "EnterSMSCodeView.h"
#import "TLToast.h"
#import "util.h"
#import "savelogObj.h"

#define kAlertWidth frame.size.width
#define kAlertHeight frame.size.height

@implementation EnterPasswordView
@synthesize pwd_Number,Req_typepwd,delegate_pwd,fromResgi;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(id)initWithFrame:(CGRect)frame leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle display:(NSInteger)display dismiss:(NSInteger)dismiss smsCodeTime:(NSInteger)smscodetime;
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
        
        UIView *line_bottom=[[UIView alloc]initWithFrame:CGRectMake(15, 100, self.frame.size.width-30, 0.5)];
        line_bottom.backgroundColor=[UIColor colorWithHexString:@"#E6E6E6" alpha:0.8];
        [self addSubview:line_bottom];
        
        UIView *line_center=[[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-0.5)/2, 105, 0.5, 40)];
        line_center.backgroundColor=[UIColor colorWithHexString:@"#E6E6E6" alpha:0.8];
        [self addSubview:line_center];
        
        UIButton *btn_quex = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_quex.frame = CGRectMake(0, 105,self.frame.size.width/2, 40);
        btn_quex.tag = 10;
        [btn_quex setTitle:leftTitle forState:UIControlStateNormal];
        [btn_quex setTitleColor:[UIColor colorWithHexString:@"#A6A5AB" alpha:1.0] forState:UIControlStateNormal];
        [btn_quex addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_quex];
        
        UIButton *btn_quer = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_quer.frame = CGRectMake(self.frame.size.width/2, 105, self.frame.size.width/2, 40);
        btn_quer.tag = 11;
        btn_quer.enabled=NO;
        [btn_quer setTitle:rigthTitle forState:UIControlStateNormal];
        [btn_quer setTitleColor:[UIColor colorWithHexString:@"#A6A5AB" alpha:1.0] forState:UIControlStateNormal];
        [btn_quer addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_quer];
        
        self.textf_pwd=[[UITextField alloc]initWithFrame:CGRectMake(30, 10, self.frame.size.width-60, 30)];
        [self.textf_pwd setBorderStyle:UITextBorderStyleNone]; //外框类型
        self.textf_pwd.placeholder = @"请输入登录密码"; //默认显示的字
        self.textf_pwd.secureTextEntry = YES; //密码
        self.textf_pwd.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textf_pwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //self.textf.returnKeyType = UIReturnKeyDone;
        self.textf_pwd.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        self.textf_pwd.tintColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
        [self addSubview:self.textf_pwd];
        
        self.textf_pwd_resuse=[[UITextField alloc]initWithFrame:CGRectMake(30, 60, self.frame.size.width-60, 30)];
        [self.textf_pwd_resuse setBorderStyle:UITextBorderStyleNone]; //外框类型
        self.textf_pwd_resuse.placeholder = @"请确认登录密码"; //默认显示的字
        self.textf_pwd_resuse.secureTextEntry = YES; //密码
        self.textf_pwd_resuse.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textf_pwd_resuse.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //self.textf.returnKeyType = UIReturnKeyDone;
        self.textf_pwd_resuse.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        self.textf_pwd_resuse.tintColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
        [self addSubview:self.textf_pwd_resuse];
        
        [self.textf_pwd becomeFirstResponder];
        
        self.smsDownTime_mm=smscodetime;
        [self runloopTime:self.smsDownTime_mm];
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

#pragma mark - 验证码倒计时
-(void)runloopTime:(NSInteger)downTime{
    __block NSInteger timeout=downTime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的显示 根据自己需求设置
                self.smsDownTime_mm=0;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的显示 根据自己需求设置
            });
            timeout--;
            self.smsDownTime_mm=timeout;
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
        EnterSMSCodeView *entermob=[[EnterSMSCodeView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-100)/2, kMainScreenWidth-60, 100)leftButtonTitle:@"返回" rightButtonTitle:@"下一步" display:1 dismiss:2 smsCodeTime:self.smsDownTime_mm];
        entermob.check_Number=pwd_Number;
        entermob.Req_typeSMS=Req_typepwd;
        entermob.delegate_SMS=delegate_pwd;
        entermob.fromResgi=fromResgi;
        [entermob show];
    }
    else if (sender.tag==11){
        
        if([util checkKey:self.textf_pwd.text]){
            if(self.textf_pwd.text.length>=6&&self.textf_pwd.text.length<=16)
            {
                if ([self.textf_pwd.text isEqualToString:self.textf_pwd_resuse.text]) {
                    [self createProgressView];
                    if([Req_typepwd isEqualToString:@"resgister"]){
                        [self NetworkRequestOne];
                    }
                    else{
                        [self NetworkRequestTwo];
                    }
                }
                else{
                    [TLToast showWithText:@"确认密码与密码必须一致" topOffset:220.0f duration:1.0];
                }
            }
            else
            {
                [TLToast showWithText:@"登录密码由6～16位的英文字母或数字组成" topOffset:220.0f duration:1.0];
            }
        }
    }
}

//注册设置密码
-(void)NetworkRequestOne{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *kDeviceToken=@"";
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken]) {
            kDeviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken];  //推送的token
        }
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0010\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"password\":\"%@\",\"uniqueDeviceNumber\":\"%@\",\"deviceToken\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],pwd_Number,[util md5:self.textf_pwd.text],[OpenUDID value],kDeviceToken];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                // NSLog(@"返回信息：%@",jsonDict);
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10111) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [savelogObj saveLog:@"注册" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:4];
                        
                        [phud hide:YES];
//                        [TLToast showWithText:@"注册成功" topOffset:220.0f duration:1.0];
                        [self dismiss];
                        
                        
                        NSString *userIDStr = [NSString stringWithFormat:@"%ld",(long)[[jsonDict objectForKey:@"userID"]integerValue]];
                        NSString *tokenStr = [jsonDict objectForKey:@"token"];
                        
                        if (userIDStr) {
                            [[NSUserDefaults standardUserDefaults]setObject:userIDStr forKey:User_ID];
                        }
                        if (tokenStr) {
                            [[NSUserDefaults standardUserDefaults]setObject:tokenStr forKey:User_Token];
                        }
                        
                        [[NSUserDefaults standardUserDefaults]setObject:pwd_Number forKey:User_Name];
                        [[NSUserDefaults standardUserDefaults]setObject:[util md5:self.textf_pwd.text] forKey:User_Password];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                       [[NSNotificationCenter defaultCenter]postNotificationName:@"resgister_succeed" object:nil];
                        
                        
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10112){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"注册失败" topOffset:220.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10119){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"设置密码失败" topOffset:220.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"设置密码失败" topOffset:220.0f duration:1.0];
                    });
                }
                
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [phud hide:YES];
                                  [TLToast showWithText:@"设置密码失败" topOffset:220.0f duration:1.0];
                              });
                          }
                               method:url postDict:nil];
    });
    
}

//重置密码
-(void)NetworkRequestTwo{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0024\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"password\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],pwd_Number,[util md5:self.textf_pwd.text]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                // NSLog(@"返回信息：%@",jsonDict);
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10141) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [savelogObj saveLog:@"忘记密码：重置密码" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:19];
                        
                        [phud hide:YES];
                        [TLToast showWithText:@"重置密码成功" topOffset:220.0f duration:1.0];
                        [self dismiss];
                        
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10142){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"重置密码失败" topOffset:220.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10149){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"连接服务器异常" topOffset:220.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"连接服务器异常" topOffset:220.0f duration:1.0];
                    });
                }
                
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [phud hide:YES];
                                  [TLToast showWithText:@"连接服务器异常" topOffset:220.0f duration:1.0];
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
    if(self.textf_pwd.text.length>=6 && self.textf_pwd_resuse.text.length>=6){
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
