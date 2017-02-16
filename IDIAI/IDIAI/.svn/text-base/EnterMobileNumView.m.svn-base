//
//  EnterMobileNumView.m
//  IDIAI
//
//  Created by iMac on 15-4-7.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "EnterMobileNumView.h"
#import "HexColor.h"
#import "LoginView.h"
#import "TLToast.h"
#import "util.h"
#import "savelogObj.h"
#import "SPKitExample.h"
#import "SPContactManager.h"

#define kAlertWidth frame.size.width
#define kAlertHeight frame.size.height

@implementation EnterMobileNumView
@synthesize Req_type,resgi_Number,delegate_mobile,fromResgi;



-(id)initWithFrame:(CGRect)frame leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle display:(NSInteger)display dismiss:(NSInteger)dismiss
{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];//自己成为背景透明的父视图
        self.mainPartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height-30)];
        
        
        _mainPartView.layer.cornerRadius = 5.0f;
        _mainPartView.layer.masksToBounds = YES;
        _mainPartView.backgroundColor = [UIColor whiteColor];
        control = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.45];
       // [control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        self.display_start=display;
        self.dismiss_end=dismiss;
        
        [self addSubview:_mainPartView];
        
        self.textf_mobile=[[UITextField alloc]initWithFrame:CGRectMake(20, 10, self.frame.size.width-60, 30)];
        self.textf_mobile.delegate=self;
        [self.textf_mobile setBorderStyle:UITextBorderStyleNone]; //外框类型
        self.textf_mobile.placeholder = @"请输入手机号"; //默认显示的字
        self.textf_mobile.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textf_mobile.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //self.textf.returnKeyType = UIReturnKeyDone;
        self.textf_mobile.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        self.textf_mobile.tintColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
        self.textf_mobile.keyboardType=UIKeyboardTypeNumberPad;
        [self addSubview:self.textf_mobile];
        
        UIView *line_top1=[[UIView alloc]initWithFrame:CGRectMake(15, 50, self.frame.size.width-30, 0.5)];
        line_top1.backgroundColor=[UIColor colorWithHexString:@"#E6E6E6" alpha:0.8];
        [self.mainPartView addSubview:line_top1];
        
     
        self.textf_smsCode = [[UITextField alloc]initWithFrame:CGRectMake(20, 60.5, CGRectGetWidth(self.textf_mobile.frame)/2+10,30)];
        [self.textf_smsCode setBorderStyle:UITextBorderStyleNone];
         self.textf_smsCode.placeholder = @"请输入验证码" ;
         self.textf_smsCode.autocorrectionType = UITextAutocapitalizationTypeNone;
         self.textf_smsCode.clearButtonMode = UITextFieldViewModeWhileEditing;
         self.textf_smsCode.tintColor = [UIColor colorWithHexString:@"#EF6562" alpha:1.0];
         self.textf_smsCode.keyboardType = UIKeyboardTypeNumberPad;
        [self.mainPartView addSubview:self.textf_smsCode];
        
        self.smsCodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _smsCodeBtn.frame = CGRectMake(CGRectGetMaxX(self.textf_smsCode.frame)+25,CGRectGetMinY(self.textf_smsCode.frame),CGRectGetWidth(self.textf_mobile.frame)/2,30);
        [_smsCodeBtn setTitle:@"( 短信验证码 )" forState:UIControlStateNormal];
        [_smsCodeBtn setTitleColor:emphasizeTextColor forState:UIControlStateNormal];
//        smsCodeBtn.font = [UIFont systemFontOfSize:14];
        [_smsCodeBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        _smsCodeBtn.tag = 8;
        [self.mainPartView addSubview:_smsCodeBtn];
        
        
        UIView * line_top2 =[[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.textf_smsCode.frame)+10,self.frame.size.width-30, 0.5)];
        line_top2.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6" alpha:0.8];
        [self.mainPartView addSubview:line_top2];
        
        
        
        self.textf_passWord = [[UITextField alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(line_top2.frame)+10, CGRectGetWidth(self.textf_mobile.frame)-30,30)];
        [self.textf_passWord setBorderStyle:UITextBorderStyleNone];
        self.textf_passWord.placeholder = @"请输入密码";
        self.textf_passWord.autocorrectionType = UITextAutocapitalizationTypeNone;
        self.textf_passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textf_passWord.tintColor = [UIColor colorWithHexString:@"#EF6562" alpha:1.0];
        self.textf_passWord.keyboardType = UIKeyboardAppearanceDefault;
        [self.mainPartView addSubview:self.textf_passWord];
        
        self.securityInPutBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        self.securityInPutBtn.frame = CGRectMake(CGRectGetMaxX(self.textf_passWord.frame)+25, CGRectGetMinY(self.textf_passWord.frame), 30, 30);
        [self.securityInPutBtn setImage:[UIImage imageNamed:@"ic_xianshi_s"] forState:UIControlStateNormal];
        [self.securityInPutBtn setImage:[UIImage imageNamed:@"ic_xianshi_n"] forState:UIControlStateSelected];
        [self.securityInPutBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.securityInPutBtn.tag = 9;
        [self.mainPartView addSubview:self.securityInPutBtn];
        
        UIView * line_top3 = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(self.textf_passWord.frame)+10, self.frame.size.width-30, 0.5)];
         line_top3.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6" alpha:0.8];
        [self.mainPartView addSubview:line_top3];
        
        
        UIButton *btn_quex = [UIButton buttonWithType:UIButtonTypeCustom];//取消按钮
        btn_quex.frame = CGRectMake(0,CGRectGetMaxY(line_top3.frame)+5,self.frame.size.width/2, 40);
        btn_quex.tag = 10;
        [btn_quex setTitle:leftTitle forState:UIControlStateNormal];
        [btn_quex setTitleColor:emphasizeTextColor forState:UIControlStateNormal];
        [btn_quex addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainPartView addSubview:btn_quex];
        
        UIButton *btn_quer = [UIButton buttonWithType:UIButtonTypeCustom]; //提交按钮
        btn_quer.frame = CGRectMake(self.frame.size.width/2,CGRectGetMaxY(line_top3.frame)+5,self.frame.size.width/2, 40);
        btn_quer.tag = 11;
        btn_quer.enabled=YES;
        [btn_quer setTitle:rigthTitle forState:UIControlStateNormal];
        [btn_quer setTitleColor:emphasizeTextColor forState:UIControlStateNormal];
        [btn_quer addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainPartView addSubview:btn_quer];
        
        
        UIView *line_center=[[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-0.5)/2,CGRectGetMaxY(line_top3.frame)+5, 0.5, 40)];
        line_center.backgroundColor=[UIColor colorWithHexString:@"#E6E6E6" alpha:0.8];
        [self.mainPartView addSubview:line_center];
        
        
        self.voiceLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_mainPartView.frame),CGRectGetMaxY(_mainPartView.frame),kMainScreenWidth-135, 30)];
        _voiceLab.tag  =4321;
        _voiceLab.text = @"收不到短信验证码请尝试";
        _voiceLab.font = [UIFont systemFontOfSize:16];
        _voiceLab.textColor = [UIColor whiteColor];
        _voiceLab.backgroundColor = [UIColor clearColor];

        self.voiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_voiceLab.frame), CGRectGetMaxY(_mainPartView.frame), 80, 30)];
        _voiceBtn.backgroundColor = [UIColor clearColor];
        [_voiceBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        _voiceBtn.tag = 12;
        
        
//        _voiceBtn setTitle:@"语音验证" forState:UIControlStateNormal
        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc]initWithString:@"语音验证" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:emphasizeTextColor,NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        [_voiceBtn setAttributedTitle:attrString forState:UIControlStateNormal];
        
        self.smsDownTime = 60 ;
        [self.textf_mobile becomeFirstResponder];
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

#pragma mark -
#pragma mark - UIButton

-(void)btnPressed:(UIButton *)sender{
    if (sender.tag==8) {
        //点击获取验证码或重新发送
//        self.isVerifyByVoice = NO;
        [self.textf_mobile resignFirstResponder];
        if([util checkTel:self.textf_mobile.text]){
            [self createProgressView];
              self.gettingWay = 1;//短信验证
            if([Req_type isEqualToString:@"resgister"]){

                [self NetworkRequestOne];}
            else {
              
                [self NetworkRequestTwo];
            }
        }
        
        
    }else if (sender.tag ==9){
        //密文输入
        if (self.securityInPutBtn.selected==NO) {
            
            self.securityInPutBtn.selected = YES;
            self.textf_passWord.secureTextEntry = YES;
            
        }else{
          //非密文输入
            self.securityInPutBtn.selected = NO;
            self.textf_passWord.secureTextEntry = NO;
            
        }
        
    
    }else if(sender.tag==10){
//        [control removeFromSuperview];
        //点击返回
        [self dismiss];
        if([fromResgi isEqualToString:@"YES"]) {
            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
            login.mobile_Number=self.textf_mobile.text;
            login.delegate=delegate_mobile;
            [login show];
        }
    }
    else if (sender.tag==11){
          //点击提交
        if (self.textf_smsCode.text.length==0) {
            [TLToast showWithText:@"请输入验证码"];
            return;
        }
        if ([util checkKey:self.textf_passWord.text]==NO) {
            return;
        }
         [phud show:YES];
        if ([Req_type isEqualToString:@"resetpwd"]||[Req_type isEqualToString:@"resgister"]) {
           [self SendSMScodeToServer];
        }
        else {
            
        }
    } else if (sender.tag ==12){
       //语音验证
//        self.isVerifyByVoice = YES;
        if([util checkTel:self.textf_mobile.text]){
            [self createProgressView];
             self.gettingWay = 2 ;//语音验证
            if([Req_type isEqualToString:@"resgister"]){
                
                [self NetworkRequestOne];}
            else {
                [self NetworkRequestTwo];
                
            }
        }

    
    
    }
    
}

//向服务器发送注册手机号获取短信验证
-(void)NetworkRequestOne{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{

        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0008\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"gettingWay\":%ld}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.textf_mobile.text,(long)self.gettingWay];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req cancelRequest];//?
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"向服务器发送手机号注册返回信息：%@",jsonDict);
                  //服务器已向用户发送验证码
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10091) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [savelogObj saveLog:@"获取短信验证码" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:3];
                        
                        if (self.gettingWay==1) {
                            [TLToast showWithText:@"验证码已发送，请注意查收"];
                            [self runloopTime];
                        }else {
                            [TLToast showWithText:@"语音验证已发送，请注意接听"];
                        }
                       
                        [phud hide:YES];
                        
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10092){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"手机号码已经注册过" topOffset:220.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10093){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"不是有效手机号码" topOffset:220.0f duration:1.0];
                    });
                }
                else if ([[jsonDict objectForKey:@"resCode"] integerValue]==10094) {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [control removeFromSuperview];
//                        [self dismiss];
//                        EnterSMSCodeView *entermob=[[EnterSMSCodeView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-100)/2, kMainScreenWidth-60, 100)leftButtonTitle:@"返回" rightButtonTitle:@"下一步" display:1 dismiss:2 smsCodeTime:60];
//                        entermob.Req_typeSMS=Req_type;
//                        entermob.check_Number=self.textf_mobile.text;
//                        entermob.delegate_SMS=delegate_mobile;
//                        entermob.fromResgi=fromResgi;
//                        [entermob show];
//
                        [phud hide:YES];
                        [TLToast showWithText:@"请在倒计时结束后再尝试"];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10099){
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

-(void)runloopTime{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UIButton *btn=(UIButton *)[self viewWithTag:8];
                btn.enabled=YES;
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [btn setTitleColor:emphasizeTextColor forState:UIControlStateNormal];
                
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"（%d秒后重发）", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UIButton *btn=(UIButton *)[self viewWithTag:8];
                btn.enabled=NO;
                [btn setTitleColor:disableTextColor forState:UIControlStateDisabled];
                [btn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateDisabled];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

////获取验证码倒计时（含语音验证）
//-(void)runloopTime{
//    __block int timeout=60; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout<=0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                if (self.isVerifyByVoice==YES) {
//                    UIButton *btn=(UIButton *)[self viewWithTag:12];
//                    btn.enabled=YES;
//                    NSAttributedString *  attStr =  [[NSAttributedString alloc]initWithString:@"重新发送" attributes:@{NSForegroundColorAttributeName:emphasizeTextColor,NSFontAttributeName:[UIFont systemFontOfSize:16]}];
//                    [btn setAttributedTitle:attStr forState:UIControlStateNormal];
//                    
//                    UIButton *btn1=(UIButton *)[self viewWithTag:8];
//                    btn1.enabled=YES;//开起短信验证
//                    self.isVerifyByVoice =NO;
//                }else{
//                    UIButton *btn=(UIButton *)[self viewWithTag:8];
//                    btn.enabled=YES;
//                    [btn setTitle:@"重新发送" forState:UIControlStateNormal];
//                    btn.titleLabel.font = [UIFont systemFontOfSize:16];
//                    UIButton *btn1=(UIButton *)[self viewWithTag:12];
//                    btn1.enabled=YES;//开起语音验证
//                    
//                }
//                
//            });
//        }else{
//            
//            NSString *strTime = [NSString stringWithFormat:@"(%ld秒后重发)", (long)timeout];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                if (self.isVerifyByVoice==YES) {//语音验证
//                    UIButton *btn=(UIButton *)[self viewWithTag:12];
//                    btn.enabled=NO;
//                    NSAttributedString *  attStr =  [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(%ld)",(long)timeout] attributes:@{NSForegroundColorAttributeName:emphasizeTextColor,NSFontAttributeName:[UIFont systemFontOfSize:16]}];
//                    [btn setAttributedTitle:attStr forState:UIControlStateDisabled];
//                    UIButton *btn1=(UIButton *)[self viewWithTag:8];
//                    [btn1 setTitle:@"重新发送" forState:UIControlStateNormal];
//                    btn1.enabled=NO;//禁用验证码按钮
//                    //
//                }else{
//                    UIButton *btn=(UIButton *)[self viewWithTag:8];
//                    btn.enabled=NO;
//                    [btn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateDisabled];
//                    btn.titleLabel.font = [UIFont systemFontOfSize:16];
//                    UIButton *btn1=(UIButton *)[self viewWithTag:12];
//                    [btn1 setTitle:@"重新发送" forState:UIControlStateNormal];
//                    btn1.enabled=NO;//禁用语音按钮
//                }
//                
//            });
//            timeout--;
//            
//        }
//    });
//    dispatch_resume(_timer);
//}


//向服务器发送验证码
-(void)SendSMScodeToServer{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0009\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"smsCode\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.textf_mobile.text,self.textf_smsCode.text];
        
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
                        
                        [self setPassWordOrReSetPassWordAfterVerificationPassed];                        
                    
                        
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




- (void)setPassWordOrReSetPassWordAfterVerificationPassed{

                if([Req_type isEqualToString:@"resgister"]){
                    //注册
                    [self regesterRequestSendToServer];
                }
                else if ([Req_type isEqualToString:@"resetpwd"])
                     {
                    //重置密码
                    [self resetPassWordSendToServer];
                }
                else {
                
                
                }
    
}
    


//向服务器发送手机号获取验证码修改密码
-(void)NetworkRequestTwo{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token;
        NSString *string_userid;
        NSString * string_cityCode;
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];;
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
            string_cityCode = [[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"];
        
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0023\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"gettingWay\":%ld}",kDefaultUpdateVersionServerURL,string_cityCode,self.textf_mobile.text,(long)self.gettingWay];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req cancelRequest];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"向服务器发送手机号修改密码返回信息：%@",jsonDict);
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10131) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [savelogObj saveLog:@"忘记密码：获取验证码" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:19];
                        
//                      
//                        EnterSMSCodeView *entermob=[[EnterSMSCodeView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-100)/2, kMainScreenWidth-60, 100)leftButtonTitle:@"返回" rightButtonTitle:@"下一步" display:1 dismiss:2 smsCodeTime:60];
//                        [entermob show];
//                        entermob.Req_typeSMS=Req_type;
//                        entermob.check_Number=self.textf_mobile.text;
//                        entermob.delegate_SMS=delegate_mobile;
//                        entermob.fromResgi=fromResgi;
                        
                        if (self.gettingWay==1) {
                            [TLToast showWithText:@"验证码已发送，请注意查收"];
                            [self runloopTime];
                        }else {
                            [TLToast showWithText:@"语音验证已发送，请注意接听"];
                        }
                        
                    
                        [phud hide:YES];
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
                else  if([[jsonDict objectForKey:@"resCode"] integerValue]==10134){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"请在倒计时结束后再尝试"];
                    });
                }else{
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


//[TLToast showWithText:@"请在倒计时结束后再尝试"];



//注册设置密码
-(void)regesterRequestSendToServer{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *kDeviceToken=@"";
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken]) {
            kDeviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken];  //推送的token
        }
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0010\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"password\":\"%@\",\"uniqueDeviceNumber\":\"%@\",\"deviceToken\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.textf_mobile.text,[util md5:self.textf_passWord.text],[OpenUDID value],kDeviceToken];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                 NSLog(@"注册返回信息：%@",jsonDict);
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10111) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [savelogObj saveLog:@"注册" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:4];
                        [phud hide:YES];
                        
                        [TLToast showWithText:@"注册成功" topOffset:220.0f duration:1.0];
                        
                        NSString *userIDStr = [NSString stringWithFormat:@"%ld",(long)[[jsonDict objectForKey:@"userID"]integerValue]];
                        NSString *tokenStr = [jsonDict objectForKey:@"token"];
                        
                        if (userIDStr) {
                            [[NSUserDefaults standardUserDefaults]setObject:userIDStr forKey:User_ID];
                        }
                        if (tokenStr) {
                            [[NSUserDefaults standardUserDefaults]setObject:tokenStr forKey:User_Token];
                        }
                        
                        
                        [[NSUserDefaults standardUserDefaults]setObject:self.textf_mobile.text forKey:User_Name];
                        [[NSUserDefaults standardUserDefaults]setObject:[util md5:self.textf_passWord.text] forKey:User_Password];
                        
                   
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"resgister_succeed" object:nil];
                        
                        
                        
                       [self dismiss];
                                             
                        if ([self.registerDelegate respondsToSelector:@selector(registerSucceedWithParemeters:)]) {
                            [self.registerDelegate  registerSucceedWithParemeters:nil];
                        }
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
-(void)resetPassWordSendToServer{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0024\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"password\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.textf_mobile.text,[util md5:self.textf_passWord.text]];
        
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
                        [[NSUserDefaults standardUserDefaults]setObject:[util md5:self.textf_passWord.text] forKey:User_Password];
                        [[NSUserDefaults standardUserDefaults]synchronize];
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
    self.textf_mobile.text=resgi_Number;
    

    
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
           
            [self addSubview:_voiceLab];
            [self addSubview: _voiceBtn];
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
                [self addSubview:_voiceLab];
                [self addSubview: _voiceBtn];
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
                [self addSubview:_voiceLab];
                [self addSubview: _voiceBtn];
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
                [self addSubview:_voiceLab];
                [self addSubview: _voiceBtn];
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




@end
