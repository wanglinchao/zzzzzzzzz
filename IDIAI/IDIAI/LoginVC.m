//
//  LoginVC.m
//  IDIAI
//
//  Created by iMac on 14-7-1.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "LoginVC.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "util.h"
#import "HexColor.h"
#import "ResgisterSMScodeVCViewController.h"
#import "TLToast.h"
#import "savelogObj.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "PersonalInfoObj.h"

@interface LoginVC ()
{
    MBProgressHUD *phud;
}


@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:NO];
    
    UIColor *color = [UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor blackColor];
    lab_nav_title.text=@"登录";
    self.navigationItem.titleView = lab_nav_title;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.tag=2;
    [rightButton setFrame:CGRectMake(5, 5, 40, 40)];
    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(btnPressed:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}

-(void)PressBarItemLeft{
    [phud hide:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [[[self navigationController] navigationBar] setHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithHexString:@"#E5E5E5" alpha:1.0];
    [self customizeNavigationBar];
    
    UIButton *btn_SMS = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_SMS.frame = CGRectMake(20, 180, kMainScreenWidth-40, 50);
    btn_SMS.tag = 1;
    [btn_SMS setTitle:@"登录" forState:UIControlStateNormal];
    //给按钮加一个白色的板框
    btn_SMS.layer.borderColor = [[UIColor colorWithHexString:@"#CA5A59" alpha:1.0] CGColor];
    btn_SMS.layer.borderWidth = 1.0f;
    //给按钮设置弧度,这里将按钮变成了圆形
    btn_SMS.layer.cornerRadius = 5.0f;
    btn_SMS.layer.masksToBounds = YES;
    [btn_SMS setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_SMS.backgroundColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    [btn_SMS addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_SMS];
    
    
    UIButton *btn_password = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_password.frame = CGRectMake(kMainScreenWidth-100, 240, 90, 20);
    btn_password.tag = 3;
    [btn_password setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [btn_password setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
    [btn_password addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_password];
    
    UIImageView *imv_phone=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_shouji"]];
    imv_phone.frame=CGRectMake(10, 2.5, 30, 30);
    UIView *view_left_ss=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    view_left_ss.backgroundColor=[UIColor clearColor];
    [view_left_ss addSubview:imv_phone];
    
    UIImageView *imv_key=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_key"]];
    imv_key.frame=CGRectMake(13, 4, 25, 25);
    UIView *view_left_key=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    view_left_key.backgroundColor=[UIColor clearColor];
    [view_left_key addSubview:imv_key];
    
    self.MobileNumber=[[UITextField alloc]initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 50)];
    self.MobileNumber.backgroundColor=[UIColor whiteColor];
    self.MobileNumber.layer.borderColor = [[UIColor colorWithHexString:@"#DBDBDB" alpha:1.0] CGColor];
    self.MobileNumber.layer.borderWidth = 1.0f;
    self.MobileNumber.borderStyle=UITextBorderStyleNone;
    self.MobileNumber.textColor=[UIColor blackColor];;
     self.MobileNumber.delegate=self;
    self.MobileNumber.keyboardType = UIKeyboardTypePhonePad;
    self.MobileNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.MobileNumber.placeholder=@"请输入手机号";
    self.MobileNumber.borderStyle = UITextBorderStyleNone;
    self.MobileNumber.returnKeyType = UIReturnKeyNext;
    self.MobileNumber.leftView=view_left_ss;
    self.MobileNumber.leftViewMode=UITextFieldViewModeAlways;
    self.MobileNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.MobileNumber];
    
    self.Password=[[UITextField alloc]initWithFrame:CGRectMake(0, 89, kMainScreenWidth, 50)];
    self.Password.backgroundColor=[UIColor whiteColor];
    self.Password.layer.borderColor = [[UIColor colorWithHexString:@"#DBDBDB" alpha:1.0] CGColor];
    self.Password.layer.borderWidth = 1.0f;
    self.Password.borderStyle=UITextBorderStyleNone;
    self.Password.textColor=[UIColor blackColor];
     self.Password.delegate=self;
    self.Password.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.Password.placeholder=@"请输入密码";
    self.Password.borderStyle = UITextBorderStyleNone;
    self.Password.returnKeyType = UIReturnKeyDone;
    self.Password.leftView=view_left_key;
    self.Password.leftViewMode=UITextFieldViewModeAlways;
    self.Password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Password.secureTextEntry = YES;
    [self.view addSubview:self.Password];
}

-(void)createProgressView{
        if (!phud) {
            phud = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:phud];
            phud.mode=MBProgressHUDModeIndeterminate;
            //self.pHUD.dimBackground=YES; //是否开启背景变暗
            phud.labelText = @"数据加载中...";
            phud.blur=NO;  //是否开启ios7毛玻璃风格
            phud.darkBlur=YES; //受blur限制（blur为YES时设置darkBlur才有用）
            [phud show:YES];
        }
        else{
            [phud show:YES];
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
-(void)btnPressed:(UIButton *)btn{
    [self.view endEditing:YES];
    if (btn.tag==1) {
        [savelogObj saveLog:@"用户执行了登录操作" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:5];
        if([util checkTel:self.MobileNumber.text]){
            if([util checkKey:self.Password.text]){
                if([self.Password.text length]>=6 && self.Password.text.length <= 16){
                    if([self isConnectionAvailable]){
                        [self createProgressView];
                       [self RequestLogin];
                    }
                    else
                        [TLToast showWithText:@"无网络连接" bottomOffset:200.0f duration:1.0];
                    
                }
                else{
                    [TLToast showWithText:@"密码为6-16位" bottomOffset:220.0f duration:1.0];
                }
            }
        }
    }
    else if (btn.tag==2) {
        ResgisterSMScodeVCViewController *resgi=[[ResgisterSMScodeVCViewController alloc]init];
        resgi.resgi_Number=self.MobileNumber.text;
        resgi.Req_type=@"resgister";
        [self.navigationController pushViewController:resgi animated:YES];
    }
    else if (btn.tag==3){
        [savelogObj saveLog:@"用户执行了忘记密码操作" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:19];
        ResgisterSMScodeVCViewController *resgi=[[ResgisterSMScodeVCViewController alloc]init];
        resgi.resgi_Number=self.MobileNumber.text;
        resgi.Req_type=@"resetpwd";
        [self.navigationController pushViewController:resgi animated:YES];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
//    self.phoneNumberTextField.text=@"";
//    self.pwdTextField.text=@"";
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
        NSString *string=[postDict JSONString];
    
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
       [postDict02 setObject:self.MobileNumber.text forKey:@"loginName"];
        [postDict02 setObject:[util md5:self.Password.text] forKey:@"password"];
        [postDict02 setObject:@"1" forKey:@"httpver"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken]) {
            [postDict02 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken] forKey:@"deviceToken"];  //推送的token
        }
        if ([OpenUDID value].length) [postDict02 setObject:[OpenUDID value] forKey:@"uniqueDeviceNumber"];   //设备唯一标识
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
                NSLog(@"返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[jsonDict objectForKey:@"resCode"] integerValue]==10121) {
                        
                        [[NSUserDefaults standardUserDefaults] setObject:self.MobileNumber.text forKey:User_Name];
                        [[NSUserDefaults standardUserDefaults] setObject:[util md5:self.Password.text] forKey:User_Password];
                        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:User_Token];
                        [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Token] forKey:User_Token];//huangrun 20141219
                        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[jsonDict objectForKey:User_ID]] forKey:User_ID];
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
//                            NSData *photo_data = UIImageJPEGRepresentation(image, 0.5);
//                            NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
//                            [photo_data writeToFile:aPath atomically:YES];
                            [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_logo] forKey:User_logo];
                        }
                        if(![[jsonDict objectForKey:User_Addrss] isEqual:[NSNull null]])
                        [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:User_Addrss] forKey:User_Addrss];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        //个人信息中区域
                        if(![[jsonDict objectForKey:@"areaCode"] isEqual:[NSNull null]])
                        if(![[jsonDict objectForKey:@"areaCode"]isEqual:[NSNull null]])[[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:@"areaCode"] forKey:kUDUserDistrict];
                        [[NSUserDefaults standardUserDefaults] synchronize];

                        [phud hide:YES];
                        if ([self.delegate respondsToSelector:@selector(logged:)]) {
                            [self.delegate logged:jsonDict];
                        }
                    }
                    else if([[jsonDict objectForKey:@"resCode"] integerValue]==10122){
                        [phud hide:YES];
                        [TLToast showWithText:@"用户名不存在" bottomOffset:220.0f duration:1.0];

                    }
                    else if([[jsonDict objectForKey:@"resCode"] integerValue]==10123){
                        [phud hide:YES];
                        [TLToast showWithText:@"密码错误，请重新输入" bottomOffset:220.0f duration:1.0];

                    }
                    else if([[jsonDict objectForKey:@"resCode"] integerValue]==10129){
                        [phud hide:YES];
                        [TLToast showWithText:@"登录失败" bottomOffset:220.0f duration:1.0];
                    }
                    else {
                        [phud hide:YES];
                        [TLToast showWithText:@"登录失败" bottomOffset:220.0f duration:1.0];
                    }
                    
                });
            });
        }
                               failedBlock:^{
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [phud hide:YES];
                                      [TLToast showWithText:@"登录失败" bottomOffset:220.0f duration:1.0];
                                   });
                               }
                                    method:url postDict:post];
    });
    
}

-(void)alertviewCustom:(UIView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

#pragma mark -
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
