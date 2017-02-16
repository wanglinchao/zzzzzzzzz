//
//  CheckSMScodeVC.m
//  IDIAI
//
//  Created by iMac on 14-7-1.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CheckSMScodeVC.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "util.h"
#import "SetpasswordVC.h"
#import "HexColor.h"
#import "TLToast.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "SetPayPsdViewController.h"
#import "AutomaticLogin.h"
#import "LoginView.h"

@interface CheckSMScodeVC ()
{
    MBProgressHUD *phud;
}

@property (strong, nonatomic) NetworkRequest *req;
@property (nonatomic,assign)BOOL isVerifyByVoice;//是否是语音验证
@end

@implementation CheckSMScodeVC
@synthesize check_Number,Req_typeSMS;

-(void)dealloc{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:NO];
    
    CGRect frame = CGRectMake(100, 29, 120, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = @"填写验证码";
    self.navigationItem.titleView=label;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    [leftButton addTarget:self
                   action:@selector(backTouched:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

-(void)viewWillAppear:(BOOL)animated{
    [[[self navigationController] navigationBar] setHidden:NO];
}
-(void)backTouched:(UIButton *)btn{
    [self.Textfield_input resignFirstResponder];
    
    UIAlertView *alview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码可能会有延迟，仍然返回吗" delegate:self cancelButtonTitle:@"等待" otherButtonTitles:@"返回", nil];
    [alview show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
    }
    else if(buttonIndex==1){
        [phud hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(IS_iOS7_8)
    self.edgesForExtendedLayout=UIRectEdgeNone;
     self.view.backgroundColor=[UIColor colorWithHexString:@"#E5E5E5" alpha:1.0];
    [self customizeNavigationBar];

   
    
    self.First_lab.textColor=[UIColor colorWithHexString:@"#926b58" alpha:1.0];
     self.Second_lab.textColor=[UIColor colorWithHexString:@"#926b58" alpha:1.0];
    self.Mobilenumber.textColor=[UIColor colorWithHexString:@"#926b58" alpha:1.0];
    self.Mobilenumber.text=check_Number;
    UIView *firstBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, kMainScreenWidth,50)];
    [self.view addSubview:firstBackGroundView];
    firstBackGroundView.layer.borderColor = [[UIColor colorWithHexString:@"#DBDBDB" alpha:1.0] CGColor];
    firstBackGroundView.layer.borderWidth = 1.0f;
    firstBackGroundView.backgroundColor = [UIColor whiteColor];
    UIImageView *imv_phone=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_shouji"]];
    imv_phone.frame=CGRectMake(10, 2.5, 30, 30);
    UIView *view_left_ss=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    view_left_ss.backgroundColor=[UIColor clearColor];
    [view_left_ss addSubview:imv_phone];
    
    self.Textfield_input=[[UITextField alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth-120, 50)];
    self.Textfield_input.backgroundColor=[UIColor whiteColor];
//    self.Textfield_input.layer.borderColor = [[UIColor colorWithHexString:@"#DBDBDB" alpha:1.0] CGColor];
//    self.Textfield_input.layer.borderWidth = 1.0f;
    self.Textfield_input.borderStyle=UITextBorderStyleNone;
    self.Textfield_input.textColor=[UIColor blackColor];
    self.Textfield_input.delegate=self;
    self.Textfield_input.keyboardType = UIKeyboardTypePhonePad;
    self.Textfield_input.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.Textfield_input.borderStyle = UITextBorderStyleNone;
    self.Textfield_input.returnKeyType = UIReturnKeyDone;
    self.Textfield_input.leftView=view_left_ss;
    self.Textfield_input.leftViewMode=UITextFieldViewModeAlways;
    self.Textfield_input.placeholder=@"请输入验证码";
    self.Textfield_input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Textfield_input.textColor=[UIColor blackColor];

    [firstBackGroundView addSubview:self.Textfield_input];
    
    UIView * voiceBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(firstBackGroundView.frame)+20, kMainScreenWidth, 40)];
    [self.view addSubview:voiceBackGroundView];
    voiceBackGroundView.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5" alpha:1.0];
    voiceBackGroundView.backgroundColor = [UIColor whiteColor];
    self.voiceLab = [[UILabel alloc]initWithFrame:CGRectMake(20,0,CGRectGetWidth(voiceBackGroundView.frame)-130,40)];
    [voiceBackGroundView addSubview:self.voiceLab];
    
    _voiceLab.text = @"收不到短信验证码请尝试";
    _voiceLab.font = [UIFont systemFontOfSize:17];
    _voiceLab.textColor = subHeadingColor;
    _voiceLab.backgroundColor = [UIColor clearColor];
        self.voiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_voiceLab.frame),0,100,40)];
    [voiceBackGroundView addSubview:self.voiceBtn];
    _voiceBtn.backgroundColor = [UIColor clearColor];
    [_voiceBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    _voiceBtn.tag =3;
    
    //        _voiceBtn setTitle:@"语音验证" forState:UIControlStateNormal
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc]initWithString:@"语音验证" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:emphasizeTextColor,NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [_voiceBtn setAttributedTitle:attrString forState:UIControlStateNormal];
    
    UIButton *btn_SMS = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_SMS.frame = CGRectMake(CGRectGetMaxX(self.Textfield_input.frame)+5,5,100,40);
    btn_SMS.tag =1;
    [btn_SMS setTitle:@"获取验证码" forState:UIControlStateNormal];
    btn_SMS.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn_SMS setTitleColor:[UIColor colorWithHexString:@"#ED6562" alpha:1.0]forState:UIControlStateNormal];
    //给按钮加一个白色的板框
    btn_SMS.layer.borderColor = [[UIColor colorWithHexString:@"#CA5A59" alpha:1.0] CGColor];
    btn_SMS.layer.borderWidth = 1.0f;
    //给按钮设置弧度,这里将按钮变成了圆形
    btn_SMS.layer.cornerRadius = 5.0f;
    btn_SMS.layer.masksToBounds = YES;
    btn_SMS.backgroundColor=[UIColor clearColor];
    [btn_SMS addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [firstBackGroundView addSubview:btn_SMS];
    
    UIButton *btn_Next = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Next.frame = CGRectMake(20,CGRectGetMaxY(voiceBackGroundView.frame)+20, kMainScreenWidth-40, 50);
    btn_Next.tag = 2;
    [btn_Next setTitle:@"下一步" forState:UIControlStateNormal];
    //给按钮加一个白色的板框
    btn_Next.layer.borderColor = [[UIColor colorWithHexString:@"#CA5A59" alpha:1.0] CGColor];
    btn_Next.layer.borderWidth = 1.0f;
    //给按钮设置弧度,这里将按钮变成了圆形
    btn_Next.layer.cornerRadius = 5.0f;
    btn_Next.layer.masksToBounds = YES;
    [btn_Next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_Next.backgroundColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    [btn_Next addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_Next];


}
#pragma mark -
#pragma mark - CircleProgressHUDDelegate
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
    if (btn.tag==3) {//语音验证
//        self.isVerifyByVoice =YES;
        if([self isConnectionAvailable]){
            self.gettingWay = 2;
            [self createProgressView];
            if([Req_typeSMS isEqualToString:@"resgister"])
                [self SendmobileNumToServer];
            else if ([Req_typeSMS isEqualToString:@"getVeriCode"]) {
//                [self NetworkRequestThree];
//            } else {
                [self NetworkRequestTwo];
            }
        }
        else
            [TLToast showWithText:@"无网络连接" bottomOffset:200.0f duration:1.0];
    } else if (btn.tag==2) {
//        self.isVerifyByVoice = NO;
        if ([self.Textfield_input.text length] == 6) {
            
            if([self isConnectionAvailable]){
               [self createProgressView];
               [self SendSMScodeToServer];
            }
            else
                [TLToast showWithText:@"无网络连接" bottomOffset:200.0f duration:1.0];
        }
        else{
             [TLToast showWithText:@"输入验证码错误" bottomOffset:200.0f duration:1.0];
        }

    }else if (btn.tag==1) {//短信验证
        [self.view endEditing:YES];
//         self.isVerifyByVoice = NO;
        if([self isConnectionAvailable]){
            self.gettingWay = 1;
            [self createProgressView];
            if([Req_typeSMS isEqualToString:@"resgister"])
                [self SendmobileNumToServer];
            else if ([Req_typeSMS isEqualToString:@"getVeriCode"]) {
//                [self NetworkRequestThree];
//            } else {
                [self NetworkRequestTwo];
            }
        }
        else
            [TLToast showWithText:@"无网络连接" bottomOffset:200.0f duration:1.0];
    }
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
                UIButton *btn=(UIButton *)[self.view viewWithTag:1];
                btn.enabled=YES;
                [btn setTitleColor:emphasizeTextColor forState:UIControlStateNormal];
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"（%ds）", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UIButton *btn=(UIButton *)[self.view viewWithTag:1];
                btn.enabled=NO;
                [btn setTitleColor:disableTextColor forState:UIControlStateDisabled];
                [btn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateDisabled];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}


////获取验证码倒计时(含语音验证)
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
//                    UIButton *btn=(UIButton *)[self.view viewWithTag:3];
//                    btn.enabled=YES;
//                     NSAttributedString *  attStr =  [[NSAttributedString alloc]initWithString:@"重新发送" attributes:@{NSForegroundColorAttributeName:emphasizeTextColor,NSFontAttributeName:[UIFont systemFontOfSize:18]}];
//                    [btn setAttributedTitle:attStr forState:UIControlStateNormal];
//                    
//                    UIButton *btn1=(UIButton *)[self.view viewWithTag:1];
//                    btn1.enabled=YES;//开起语音验证
//                    
//                }else{
//                    UIButton *btn=(UIButton *)[self.view viewWithTag:1];
//                   btn.enabled=YES;
//                    [btn setTitle:@"重新发送" forState:UIControlStateNormal];
//                    
//                    UIButton *btn1=(UIButton *)[self.view viewWithTag:3];
//                    btn1.enabled=YES;//开起短信验证
//                    
//                }
//                
//            });
//        }else{
//            
//            NSString *strTime = [NSString stringWithFormat:@"重新发送(%ds)", timeout];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                if (self.isVerifyByVoice==YES) {//语音验证
//                    UIButton *btn=(UIButton *)[self.view viewWithTag:3];
//                    btn.enabled=NO;
//                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
//                    NSAttributedString *  attStr =  [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",strTime] attributes:@{NSForegroundColorAttributeName:emphasizeTextColor,NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//                    [btn setAttributedTitle:attStr forState:UIControlStateDisabled];
//                    UIButton *btn1=(UIButton *)[self.view viewWithTag:1];
//                    btn1.enabled=NO;//禁用验证码按钮
////
//                }else{
//                    UIButton *btn=(UIButton *)[self.view viewWithTag:1];
//                    btn.enabled=NO;
//                    [btn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateDisabled];
//                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
//                    UIButton *btn1=(UIButton *)[self.view viewWithTag:3];
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
//

//想服务器发送验证码
-(void)SendSMScodeToServer{
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        if ([self.sourceVCStr isEqualToString:@"inputLoginPsdVC"]) {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Name]) {
                check_Number = [[NSUserDefaults standardUserDefaults]objectForKey:User_Name];
            }
        }
        
    NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0009\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"smsCode\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],check_Number,self.Textfield_input.text];
        
        self.req = [[NetworkRequest alloc] init];
        [self.req setHttpMethod:GetMethod];
        
        [self.req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[self.req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                //NSLog(@"返回信息：%@",jsonDict);
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10101) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if ([self.sourceVCStr isEqualToString:@"inputLoginPsdVC"]) {
                            SetPayPsdViewController *setPayPsdVC = [[SetPayPsdViewController alloc]init];
                            setPayPsdVC.fromStr =self.fromStr;
                            [self.navigationController pushViewController:setPayPsdVC animated:YES];
                             [phud hide:YES];
                        } else {
                        
                        SetpasswordVC *setpwdvc=[[SetpasswordVC alloc]init];
                        setpwdvc.pwd_Number=check_Number;
                        setpwdvc.Req_typepwd=Req_typeSMS;
                        [self.navigationController pushViewController:setpwdvc animated:YES];
                        [phud hide:YES];
                        }
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10102){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"请输入正确的手机验证码" bottomOffset:200.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10103){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                           [TLToast showWithText:@"验证码已失效" bottomOffset:200.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10109){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"验证失败" bottomOffset:200.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"验证失败" bottomOffset:200.0f duration:1.0];
                    });
                }
            });
        }
                               failedBlock:^{
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self stopRequest];
                                       [phud hide:YES];
                                       [TLToast showWithText:@"验证失败" bottomOffset:200.0f duration:1.0];
                                   });
                               }
                                    method:url postDict:nil];
    });
    
}

//向服务器发送手机号来获取短信验证码
-(void)SendmobileNumToServer{
    [self startRequestWithString:@"获取中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0008\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"gettingWay\":%ld}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],check_Number,(long)self.gettingWay];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
               // NSLog(@"返回信息：%@",jsonDict);
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10091) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                       [phud hide:YES];
                    
                        if (self.gettingWay==1) {
                            [TLToast showWithText:@"验证码已发送，请注意查收"];
                            [self runloopTime];
                        }else {
                            //                                [self runloopTime];
                            [TLToast showWithText:@"语音验证已发送，请注意接听"];
                        }

                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10093){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"不是有效手机号" bottomOffset:200.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10092){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"手机号码已经注册过" bottomOffset:200.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10099){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                       [phud hide:YES];
                        [TLToast showWithText:@"连接服务器失败" bottomOffset:200.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10094){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"请在倒计时结束后再尝试"];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                 [phud hide:YES];
                                  [TLToast showWithText:@"获取验证码失败" bottomOffset:200.0f duration:1.0];
                              });
                          }
                               method:url postDict:nil];
    });

}

//向服务器发送手机号获取修改密码验证码
-(void)NetworkRequestTwo{
    [self startRequestWithString:@"获取中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0023\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"gettingWay\":%ld}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],check_Number,(long)self.gettingWay];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req cancelRequest];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                //NSLog(@"返回信息：%@",jsonDict);
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10131) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                        
                        if (self.gettingWay==1) {
                            [TLToast showWithText:@"验证码已发送，请注意查收"];
                            [self runloopTime];
                        }else {
                            [TLToast showWithText:@"语音验证已发送，请注意接听"];
                        }
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10132){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"手机号码未注册" bottomOffset:200.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10139){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"连接服务器失败" bottomOffset:200.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10134){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"请在倒计时结束后再尝试"];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"连接服务器失败" bottomOffset:200.0f duration:1.0];
                    });
                }
                
            });
        }
                          failedBlock:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"连接服务器失败" bottomOffset:200.0f duration:1.0];
                              });
                          }
                               method:url postDict:nil];
    });
    
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

//向服务器发送获取修改支付密码的手机验证码
-(void)NetworkRequestThree{
    [self startRequestWithString:@"获取中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSString *string_token;
        NSString *string_userid;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0144" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSString *md5LoginPsdStr = [util md5:self.psdStr];
        NSMutableDictionary*bodyDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"password":md5LoginPsdStr}];
        [bodyDic  setObject:[NSNumber numberWithInteger:self.gettingWay] forKey: @"gettingWay"];
        NSString *string02=[bodyDic JSONString];
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setTimeOutSeconds:15];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                // NSLog(@"login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopRequest];
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 101441) {
                           [phud hide:YES];
                        
                            if (self.gettingWay==1) {
                                [TLToast showWithText:@"验证码已发送，请注意查收"];
                                [self runloopTime];
                            }else {

                                [TLToast showWithText:@"语音验证已发送，请注意接听"];
                                
                            }
                        
                        
                    } else if (kResCode == 101442) {
                                                [phud hide:YES];
                        [TLToast showWithText:@"密码验证未通过"];
                    } else if (kResCode == 101449) {
                                                [phud hide:YES];
                        [TLToast showWithText:@"系统异常"];
                    }
                    
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [phud hide:YES];
                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:post];
    });
    
}

#pragma mark -
#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
     [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
