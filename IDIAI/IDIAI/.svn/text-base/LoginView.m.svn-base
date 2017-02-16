//
//  LoginView.m
//  IDIAI
//
//  Created by iMac on 15-4-7.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "LoginView.h"
#import "HexColor.h"
#import "EnterMobileNumView.h"
#import "util.h"
#import "TLToast.h"
#import "savelogObj.h"
#import "Reachability.h"
#import "savelogObj.h"

#import "SPTabBarViewController.h"
#define kAlertWidth frame.size.width
#define kAlertHeight frame.size.height

@interface LoginView ()
@property(nonatomic,strong)UIButton *btn_resigis;//注册按钮
@property(nonatomic,strong)UIButton *btn_longin;//登录按钮
@end

@implementation LoginView
@synthesize mobile_Number;

-(id)initWithFrame:(CGRect)frame leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle display:(NSInteger)display dismiss:(NSInteger)dismiss
{
    self=[super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        control = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.45];
        [control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
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
        
        _btn_resigis = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_resigis.frame = CGRectMake(0, 105, self.frame.size.width/2, 40);
        _btn_resigis.tag = 10;
        [_btn_resigis setTitle:rigthTitle forState:UIControlStateNormal];
        [_btn_resigis setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btn_resigis addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_resigis];
        
        _btn_longin = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_longin.frame = CGRectMake(self.frame.size.width/2, 105,self.frame.size.width/2, 40);
        _btn_longin.tag = 11;
        [_btn_longin setTitle:leftTitle forState:UIControlStateNormal];
        [_btn_longin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btn_longin addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_longin];
        
        _btn_longin.enabled=NO;
        _btn_resigis.enabled =NO;
        
        UIButton * btn_forgetpwd = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_forgetpwd.frame = CGRectMake(self.frame.size.width-85, 60, 80, 40);
        btn_forgetpwd.tag = 12;
        [btn_forgetpwd setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [btn_forgetpwd setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
        btn_forgetpwd.titleLabel.font=[UIFont systemFontOfSize:13];
        btn_forgetpwd.titleEdgeInsets=UIEdgeInsetsMake(20, 0, 5, 0);
        [btn_forgetpwd addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_forgetpwd];
        
        self.textf_mobile=[[UITextField alloc]initWithFrame:CGRectMake(30, 10, self.frame.size.width-60, 30)];
     
        [self.textf_mobile setBorderStyle:UITextBorderStyleNone]; //外框类型
        if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Name]) {
            self.textf_mobile.text =[[NSUserDefaults standardUserDefaults]objectForKey:User_Name];
        }else{
            self.textf_mobile.placeholder = @"请输入手机号"; //默认显示的字
        }
        
        self.textf_mobile.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textf_mobile.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        //self.textf.returnKeyType = UIReturnKeyDone;
        self.textf_mobile.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        self.textf_mobile.tintColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
        self.textf_mobile.keyboardType=UIKeyboardTypeNumberPad;
        [self addSubview:self.textf_mobile];
        //注册通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldWordChanged) name:UITextFieldTextDidChangeNotification object:nil];
        
        self.textf_pwd=[[UITextField alloc]initWithFrame:CGRectMake(30, 60, self.frame.size.width-110, 30)];
        [self.textf_pwd setBorderStyle:UITextBorderStyleNone]; //外框类型
        self.textf_pwd.placeholder = @"请输入登录密码"; //默认显示的字
        self.textf_pwd.secureTextEntry = YES; //密码
        self.textf_pwd.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textf_pwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //self.textf.returnKeyType = UIReturnKeyDone;
        self.textf_pwd.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        self.textf_pwd.tintColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
        [self addSubview:self.textf_pwd];
        
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
        //注册
    if (sender.tag==10){
        [control removeFromSuperview];
        [self dismiss];
        EnterMobileNumView *entermob=[[EnterMobileNumView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-100)/2, kMainScreenWidth-60, 231.5)leftButtonTitle:@"取消" rightButtonTitle:@"提交" display:1 dismiss:2];
        entermob.resgi_Number=self.textf_mobile.text;
        entermob.Req_type=@"resgister";
        entermob.fromResgi=@"YES";
        entermob.delegate_mobile=self.delegate;
        entermob.registerDelegate = self.delegate;
        [entermob show];
    } //登录
    else if(sender.tag==11){
        [savelogObj saveLog:@"用户执行了登录操作" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:5];
        if([util checkTel:self.textf_mobile.text]){
            if([util checkKey:self.textf_pwd.text]){
                if([self.textf_pwd.text length]>=6 && self.textf_pwd.text.length <= 16){
                    if([self isConnectionAvailable]){
                        [self createProgressView];
                        [self RequestLogin];
                    }
                    else
                        [TLToast showWithText:@"无网络连接" topOffset:220.0f duration:1.0];
                    
                }
                else{
                        [TLToast showWithText:@"密码为6-16位" topOffset:220.0f duration:1.0];
                }
            }
        }
    }
    else{
        //忘记密码
        [savelogObj saveLog:@"忘记密码：点击" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:19];
        
        [control removeFromSuperview];
        [self dismiss];
        EnterMobileNumView *entermob=[[EnterMobileNumView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-100)/2, kMainScreenWidth-60, 231.5)leftButtonTitle:@"取消" rightButtonTitle:@"提交" display:1 dismiss:2];
        entermob.resgi_Number=self.textf_mobile.text;
        entermob.Req_type=@"resetpwd";
        entermob.fromResgi=@"YES";
        entermob.delegate_mobile=self.delegate;
        [entermob show];
    }
}

//登录请求
-(void)RequestLogin{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0011" forKey:@"cmdID"];
        [postDict setObject:@"" forKey:@"token"];
        [postDict setObject:@"" forKey:@"userID"];
        [postDict setObject:@"iOS" forKey:@"deviceType"];
        [postDict setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
        [postDict setObject:@"1" forKey:@"httpver"];
        NSString *string=[postDict JSONString];
        
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:self.textf_mobile.text forKey:@"loginName"];
        [postDict02 setObject:[util md5:self.textf_pwd.text] forKey:@"password"];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken]) {
            [postDict02 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken] forKey:@"deviceToken"];   //推送的token
        }
        if ([OpenUDID value].length) [postDict02 setObject:[OpenUDID value] forKey:@"uniqueDeviceNumber"]; //设备唯一标识
        NSString *string02=[postDict02 JSONString];
        
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"登录返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[jsonDict objectForKey:@"resCode"] integerValue]==10121) {
                        /*************************IM登录****************************/
                        [[SPKitExample sharedInstance]callThisInDidFinishLaunching];
                        
                        //app 一启动便登录IM游客帐号。 1 游客帐号登录成功  当App用户帐号登录后————>退出IM游客帐号—————>登录用户IM帐号
                        //                         2 游客帐号未登录成功 当App用户帐号登录后————>直接登录用户IM帐号
                        SPKitExample  *spKitExample   =  [SPKitExample sharedInstance];
                        __weak typeof(spKitExample) weakSpKitExample=spKitExample;
                        __weak typeof(self) weakSelf=self;
                        if ([[SPKitExample sharedInstance].whichAccountLoginSuccess isEqualToString:IMVisitorAccountLoginSucccess]) {
                            [[[SPKitExample sharedInstance].ywIMKit.IMCore getLoginService] asyncLogoutWithCompletionBlock:^(NSError *aError, NSDictionary *aResult) {
                                if (aError==nil) {
                                    weakSpKitExample.whichAccountLoginSuccess=@"";
                                    [weakSpKitExample callThisAfterISVAccountLoginSuccessWithYWLoginId:weakSelf.textf_mobile.text passWord:IMUserPassword preloginedBlock:^{
                                        
                                    } successBlock:^{
                                        weakSpKitExample.whichAccountLoginSuccess=IMAppAccountLoginSucccess;
                                        /******判断联系人列表中是否已经添加了客服为好友*****/
                                        util * utilObj = [[util alloc]init];
                                        [utilObj DetermineWhetherIsCustomerService];
                                        
                                    } failedBlock:^(NSError * error) {
                                        NSLog(@"error1====%@",error);
                                    }];
                                }else{//退出游客帐号未成功
                                    
                                    NSLog(@"error2====%@",aError);
                                }
                            }];
                            
                        }else{
                            [[SPKitExample sharedInstance]callThisAfterISVAccountLoginSuccessWithYWLoginId:weakSelf.textf_mobile.text passWord:IMUserPassword preloginedBlock:^{
                                
                            } successBlock:^{
                                weakSpKitExample.whichAccountLoginSuccess = IMAppAccountLoginSucccess;
                                /******判断联系人列表中是否已经添加了客服为好友*****/
                                util * utilObj = [[util alloc]init];
                                [utilObj DetermineWhetherIsCustomerService];
                                
//                                [SPTabBarViewController changeIsIMLoginOutByOthersTo:NO];
                            } failedBlock:^(NSError *error) {
                                NSLog(@"error3====%@",error);
                                
                            }];
                            
                        }
                       
                        
                        
                         [savelogObj saveLog:@"用户登录" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:5];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:self.textf_mobile.text forKey:User_Name];
                        [[NSUserDefaults standardUserDefaults] setObject:[util md5:self.textf_pwd.text] forKey:User_Password];
                        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:User_Token];
                        [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Token] forKey:User_Token];//huangrun 20141219
                        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[jsonDict objectForKey:User_ID]] forKey:User_ID];
                        
             
                        
                        if(![[jsonDict objectForKey:User_ProvinceName] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:User_ProvinceName] forKey:User_ProvinceName];
                        if(![[jsonDict objectForKey:User_CityName] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:User_CityName] forKey:User_CityName];
                        if(![[jsonDict objectForKey:User_AreaName] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:User_AreaName] forKey:User_AreaName];
                        if(![[jsonDict objectForKey:User_ProvinceCode] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:User_ProvinceCode] forKey:User_ProvinceCode];
                        if(![[jsonDict objectForKey:User_CityCode] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:User_CityCode] forKey:User_CityCode];
                        if(![[jsonDict objectForKey:User_AreaCode] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:User_AreaCode] forKey:User_AreaCode];
                        
                        
                        if(![[jsonDict objectForKey:User_nickName] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_nickName] forKey:User_nickName];
                        if(![[jsonDict objectForKey:User_Mobile] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Mobile] forKey:User_Mobile];
                        if(![[jsonDict objectForKey:User_sex] isEqual:[NSNull null]]){
                            if([[jsonDict objectForKey:User_sex] integerValue]==1)
                                [[NSUserDefaults standardUserDefaults]setObject:@"男" forKey:User_sex];
                            else
                                [[NSUserDefaults standardUserDefaults]setObject:@"女" forKey:User_sex];
                        }
                        if([[jsonDict objectForKey:User_logo]length]>10){
                            
//                            UIImage *image=[UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[[jsonDict objectForKey:@"userLogo"] stringByReplacingOccurrencesOfString:@"\n" withString:@""]  options:NSDataBase64DecodingIgnoreUnknownCharacters]];
//                            UIImage * image = [UIImage imageWithContentsOfFile:[jsonDict objectForKey:@"userLogo"]];
//                            NSData *photo_data = UIImageJPEGRepresentation(image, 0.5);
//                            NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
//                            [photo_data writeToFile:aPath atomically:YES];
                            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_logo] forKey:User_logo];
                            
                        }
                        if(![[jsonDict objectForKey:User_Addrss] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Addrss] forKey:User_Addrss];
                        
                        if(![[jsonDict objectForKey:User_Village] isEqual:[NSNull null]])
                            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Village] forKey:User_Village];
                        
                        [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:7] forKey:User_roleId];
                        
                        
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        //个人信息中区域
                        if(![[jsonDict objectForKey:@"areaCode"] isEqual:[NSNull null]])
                            if(![[jsonDict objectForKey:@"areaCode"]isEqual:[NSNull null]])[[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:@"areaCode"] forKey:kUDUserDistrict];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [phud hide:YES];
                        
                        
                        [self dismiss];
                        
                        if([self.delegate respondsToSelector:@selector(LoginViewDelegateClickedAtIndex:inputInfo:)])
                            [self.delegate LoginViewDelegateClickedAtIndex:0 inputInfo:nil];
                    
                    }
                    else if([[jsonDict objectForKey:@"resCode"] integerValue]==10122){
                        [phud hide:YES];
                        [TLToast showWithText:@"该手机号尚未注册" topOffset:220.0f duration:1.0];
                        
                    }
                    else if([[jsonDict objectForKey:@"resCode"] integerValue]==10123){
                        [phud hide:YES];
                        [TLToast showWithText:@"请输入正确的登录密码" topOffset:220.0f duration:1.0];
                        
                    }
                    else if([[jsonDict objectForKey:@"resCode"] integerValue]==10129){
                        [phud hide:YES];
                        [TLToast showWithText:@"登录失败" topOffset:220.0f duration:1.0];
                    }
                    else {
                        [phud hide:YES];
                        [TLToast showWithText:@"登录失败" topOffset:220.0f duration:1.0];
                    }
                    
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [phud hide:YES];
                                  [TLToast showWithText:@"登录失败" topOffset:220.0f duration:1.0];
                              });
                          }
                               method:url postDict:post];
    });
    
}




- (YWConversationListViewController *)exampleMakeConversationListControllerWithSelectItemBlock:(YWConversationsListDidSelectItemBlock)aSelectItemBlock
{
  
    YWConversationListViewController *result = [[SPKitExample sharedInstance].ywIMKit makeConversationListViewController];
    [result setDidSelectItemBlock:aSelectItemBlock];
    
    return result;
}


#pragma mark -
#pragma mark - Public Methods

- (void)show {
    self.textf_mobile.text=mobile_Number;
    
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
//输入框文字改变
-(void)textFieldWordChanged{
    if ([self.textf_mobile.text length]&&[self.textf_pwd.text length]) {//登录注册按钮变红
        _btn_longin.enabled=YES;
        _btn_resigis.enabled =YES;
        [_btn_longin setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
        [_btn_resigis setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
    }else{//登录注册按钮变灰
        _btn_longin.enabled=NO;
        _btn_resigis.enabled =NO;
        [_btn_longin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btn_resigis setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }
}

//检测网络的类型或有无网络连接
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:kTestNetWorkServerURL];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
        case kReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
    }
    return isExistenceNetwork;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
