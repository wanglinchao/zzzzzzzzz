//
//  ResgisterSMScodeVCViewController.m
//  IDIAI
//
//  Created by iMac on 14-7-3.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ResgisterSMScodeVCViewController.h"
#import "CheckSMScodeVC.h"
#import "HexColor.h"
#import "util.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "TLToast.h"
#import "savelogObj.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "UseragreementView.h"

@interface ResgisterSMScodeVCViewController ()
{
    MBProgressHUD *phud;
}

@end

@implementation ResgisterSMScodeVCViewController
@synthesize resgi_Number,Req_type;

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
    
    CGRect frame = CGRectMake(100, 29, 120, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    if([Req_type isEqualToString:@"resgister"]) label.text = @"注册";
    else label.text=@"修改密码";
    self.navigationItem.titleView = label;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.tag=1;
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
    if(btn.tag==1){
        [phud hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([self.previousVCName isEqualToString:@"homePageVC"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [self.Next_btn setBackgroundImage:[UIImage imageNamed:@"下一步及登录按钮点击效果.png"] forState:UIControlStateHighlighted];
    UIButton *btn_Next = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Next.frame = CGRectMake(20, 150, kMainScreenWidth-40, 50);
    btn_Next.tag = 1;
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
    
    UIImageView *imv_phone=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_shouji"]];
    imv_phone.frame=CGRectMake(10, 2.5, 30, 30);
    UIView *view_left_ss=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    view_left_ss.backgroundColor=[UIColor clearColor];
    [view_left_ss addSubview:imv_phone];
    
    self.Textfield_input=[[UITextField alloc]initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 50)];
    self.Textfield_input.backgroundColor=[UIColor whiteColor];
    self.Textfield_input.layer.borderColor = [[UIColor colorWithHexString:@"#DBDBDB" alpha:1.0] CGColor];
    self.Textfield_input.layer.borderWidth = 1.0f;
    self.Textfield_input.borderStyle=UITextBorderStyleNone;
    self.Textfield_input.textColor=[UIColor blackColor];
    self.Textfield_input.text=resgi_Number;
    self.Textfield_input.delegate=self;
    self.Textfield_input.placeholder=@"请输入手机号";
    self.Textfield_input.keyboardType = UIKeyboardTypePhonePad;
    self.Textfield_input.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.Textfield_input.borderStyle = UITextBorderStyleNone;
    self.Textfield_input.returnKeyType = UIReturnKeyDone;
    self.Textfield_input.leftView=view_left_ss;
    self.Textfield_input.leftViewMode=UITextFieldViewModeAlways;
    self.Textfield_input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.Textfield_input];
}

-(void)btnPressed:(UIButton *)btn{
    [self.view endEditing:YES];
    [savelogObj saveLog:@"用户获取短信验证码" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:3];
    if([util checkTel:self.Textfield_input.text]){
        if([self isConnectionAvailable]){
            [self createProgressView];
            if([Req_type isEqualToString:@"resgister"]) [self NetworkRequestOne];
            else [self NetworkRequestTwo];
        }
        else
            [TLToast showWithText:@"无网络连接" bottomOffset:200.0f duration:1.0];
    }
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

//向服务器发送手机号注册
-(void)NetworkRequestOne{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0008\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.Textfield_input.text];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req cancelRequest];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"返回信息：%@",jsonDict);
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10091) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CheckSMScodeVC *checkvc=[[CheckSMScodeVC alloc]init];
                        checkvc.check_Number=self.Textfield_input.text;
                        checkvc.Req_typeSMS=Req_type;
                        [self.navigationController pushViewController:checkvc animated:YES];
                       [phud hide:YES];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10092){
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [phud hide:YES];
                        [TLToast showWithText:@"手机号码已经注册过" bottomOffset:200.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10093){
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [phud hide:YES];
                        [TLToast showWithText:@"不是有效手机号码" bottomOffset:200.0f duration:1.0];
                    });
                }
                else if ([[jsonDict objectForKey:@"resCode"] integerValue]==10094) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CheckSMScodeVC *checkvc=[[CheckSMScodeVC alloc]init];
                        checkvc.check_Number=self.Textfield_input.text;
                        checkvc.Req_typeSMS=Req_type;
                        [self.navigationController pushViewController:checkvc animated:YES];
                         [phud hide:YES];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10099){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"连接服务器失败" bottomOffset:200.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"连接服务器失败" bottomOffset:200.0f duration:1.0];
                    });
                }

                
            });
        }
                               failedBlock:^{
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                        [phud hide:YES];
                                    [TLToast showWithText:@"连接服务器失败" bottomOffset:200.0f duration:1.0];
                                   });
                               }
                                    method:url postDict:nil];
    });
    
}

//向服务器发送手机号修改密码
-(void)NetworkRequestTwo{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0023\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.Textfield_input.text];
        
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
                        CheckSMScodeVC *checkvc=[[CheckSMScodeVC alloc]init];
                        checkvc.check_Number=self.Textfield_input.text;
                        checkvc.Req_typeSMS=Req_type;
                        [self.navigationController pushViewController:checkvc animated:YES];
                        [phud hide:YES];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10132){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"手机号码未注册" bottomOffset:200.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10139){
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [phud hide:YES];
                        [TLToast showWithText:@"连接服务器失败" bottomOffset:200.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"连接服务器失败" bottomOffset:200.0f duration:1.0];
                    });
                }
                
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [phud hide:YES];
                                  [TLToast showWithText:@"连接服务器失败" bottomOffset:200.0f duration:1.0];
                              });
                          }
                               method:url postDict:nil];
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



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
