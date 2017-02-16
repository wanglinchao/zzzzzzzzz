//
//  SetpasswordVC.m
//  IDIAI
//
//  Created by iMac on 14-7-1.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SetpasswordVC.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "util.h"
#import "HexColor.h"
#import "TLToast.h"
#import "savelogObj.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "TLToast.h"
#import "savelogObj.h"
#import "SPKitExample.h"
#import "SPContactManager.h"
@interface SetpasswordVC ()  //<MBProgressHUDDelegate>
{
    MBProgressHUD *phud;
}

@end

@implementation SetpasswordVC
@synthesize pwd_Number,Req_typepwd;


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
    
//    UIColor *color = [UIColor colorWithHexString:@"#EF6562" alpha:1.0];
//    UIImage *image = [util imageWithColor:color];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    CGRect frame = CGRectMake(100, 29, 120, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    if([Req_typepwd isEqualToString:@"resgister"])
    label.text = @"确认注册";
    else
        label.text = @"设置新密码";
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
-(void)backTouched:(UIButton *)btn{
    [phud hide:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(IS_iOS7_8)
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithHexString:@"#E5E5E5" alpha:1.0];
    [self customizeNavigationBar];
  
    UIButton *btn_SMS = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_SMS.frame = CGRectMake(20, 180, kMainScreenWidth-40, 50);
    btn_SMS.tag = 1;
    if([Req_typepwd isEqualToString:@"resgister"])
    [btn_SMS setTitle:@"注册" forState:UIControlStateNormal];
    else
    [btn_SMS setTitle:@"确定" forState:UIControlStateNormal];
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
    
    UIImageView *imv_key=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_key"]];
    imv_key.frame=CGRectMake(10, 2.5, 25, 25);
    UIView *view_left_key=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    view_left_key.backgroundColor=[UIColor clearColor];
    [view_left_key addSubview:imv_key];
    
    UIImageView *imv_key_=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_key"]];
    imv_key_.frame=CGRectMake(10, 2.5, 25, 25);
    UIView *view_left_key_=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    view_left_key_.backgroundColor=[UIColor clearColor];
    [view_left_key_ addSubview:imv_key_];
    
    self.Textfield_first=[[UITextField alloc]initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 50)];
    self.Textfield_first.backgroundColor=[UIColor whiteColor];
    self.Textfield_first.layer.borderColor = [[UIColor colorWithHexString:@"#DBDBDB" alpha:1.0] CGColor];
    self.Textfield_first.layer.borderWidth = 1.0f;
    self.Textfield_first.borderStyle=UITextBorderStyleNone;
    self.Textfield_first.textColor=[UIColor blackColor];
    self.Textfield_first.delegate=self;
    self.Textfield_first.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.Textfield_first.borderStyle = UITextBorderStyleNone;
    self.Textfield_first.returnKeyType = UIReturnKeyDone;
    self.Textfield_first.leftView=view_left_key;
    self.Textfield_first.leftViewMode=UITextFieldViewModeAlways;
    self.Textfield_first.placeholder=@"请输入密码";
    self.Textfield_first.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Textfield_first.secureTextEntry = YES;
    [self.view addSubview:self.Textfield_first];
    
    self.Textfield_second=[[UITextField alloc]initWithFrame:CGRectMake(0, 89, kMainScreenWidth, 50)];
    self.Textfield_second.backgroundColor=[UIColor whiteColor];
    self.Textfield_second.layer.borderColor = [[UIColor colorWithHexString:@"#DBDBDB" alpha:1.0] CGColor];
    self.Textfield_second.layer.borderWidth = 1.0f;
    self.Textfield_second.borderStyle=UITextBorderStyleNone;
    self.Textfield_second.textColor=[UIColor blackColor];
    self.Textfield_second.delegate=self;
    self.Textfield_second.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.Textfield_second.borderStyle = UITextBorderStyleNone;
    self.Textfield_second.returnKeyType = UIReturnKeyDone;
    self.Textfield_second.leftView=view_left_key_;
    self.Textfield_second.leftViewMode=UITextFieldViewModeAlways;
    self.Textfield_second.placeholder=@"再次确认";
    self.Textfield_second.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.Textfield_second.secureTextEntry = YES;
    [self.view addSubview:self.Textfield_second];
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
    if([util checkKey:self.Textfield_first.text]){
        if(self.Textfield_first.text.length>=6&&self.Textfield_first.text.length<=16)
        {
            if ([self.Textfield_first.text isEqualToString:self.Textfield_second.text]) {
                
                if([self isConnectionAvailable]){
                    [self createProgressView];
                    if([Req_typepwd isEqualToString:@"resgister"]){
                        [savelogObj saveLog:@"用户执行了注册操作" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:4];
                     [self NetworkRequestOne];
                    }
                    else{
                        [savelogObj saveLog:@"用户执行了重置密码操作" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:19];
                        [self NetworkRequestTwo];
                    }
                }
                else
                    [TLToast showWithText:@"无网络连接" bottomOffset:200.0f duration:1.0];
            }
            else{
                [TLToast showWithText:@"前后密码不一致，请重新输入" bottomOffset:200.0f duration:1.0];
            }
        }
        else
        {
            [TLToast showWithText:@"密码只能设置6-16位的字母和数字" bottomOffset:200.0f duration:1.0];
        }
    }
}

-(void)NetworkRequestOne{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *kDeviceToken=@"";
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken]) {
            kDeviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:kUDDeviceToken];  //推送的token
        }
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0010\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"password\":\"%@\",\"uniqueDeviceNumber\":\"%@\",\"deviceToken\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],pwd_Number,[util md5:self.Textfield_first.text],[OpenUDID value],kDeviceToken];
        
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
                        [phud hide:YES];
                        [TLToast showWithText:@"注册成功" bottomOffset:220.0f duration:1.0];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        NSString *userIDStr = [NSString stringWithFormat:@"%d",[[jsonDict objectForKey:@"userID"]integerValue]];
                        NSString *tokenStr = [jsonDict objectForKey:@"token"];
                        
                        if (userIDStr) {
                            [[NSUserDefaults standardUserDefaults]setObject:userIDStr forKey:User_ID];
                        }
                        if (tokenStr) {
                             [[NSUserDefaults standardUserDefaults]setObject:tokenStr forKey:User_Token];
                        }
                        
                        [[NSUserDefaults standardUserDefaults]setObject:pwd_Number forKey:User_Name];
                        [[NSUserDefaults standardUserDefaults]setObject:[util md5:self.Textfield_first.text] forKey:User_Password];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"resgister_succeed" object:nil];
                    });
                   
                     NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
                    NSMutableDictionary *bDict =[[NSMutableDictionary alloc]init];
                    [bDict  setObject:pwd_Number forKey:@"userMobile"];
                    [ZLNetWorkRequest sendRequestToServerUrl:^(id responseObject) {
                        if (kResCode1==10000) {
                            NSString * serviceAccount = [responseObject objectForKey:@"serviceAccount"];
                            YWPerson * person = [[YWPerson alloc]initWithPersonLongId:serviceAccount];
                            [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] addContact:person withResultBlock:^(NSError *error, YWPerson *person) {
                                
                            }];
                        }
                        
                    } failedBlock:^(id responseObject) {
                        
                    } RequestUrl:url CmdID:@"ID0377" PostDict:bDict RequestType:@"GET"];

                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10112){
                    dispatch_async(dispatch_get_main_queue(), ^{
                          [phud hide:YES];
                        [TLToast showWithText:@"注册失败" bottomOffset:220.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10119){
                    dispatch_async(dispatch_get_main_queue(), ^{
                          [phud hide:YES];
                        [TLToast showWithText:@"设置密码失败" bottomOffset:220.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"设置密码失败" bottomOffset:220.0f duration:1.0];
                    });
                }

            });
        }
                               failedBlock:^{
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                         [phud hide:YES];
                                       [TLToast showWithText:@"设置密码失败" bottomOffset:220.0f duration:1.0];
                                   });
                               }
                                    method:url postDict:nil];
    });
    
}

-(void)NetworkRequestTwo{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0024\",\"token\":\"\",\"userID\":\"\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"password\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],pwd_Number,[util md5:self.Textfield_first.text]];
        
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
                        [phud hide:YES];
                        [TLToast showWithText:@"重置密码成功" bottomOffset:220.0f duration:1.0];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10142){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"重置密码失败" bottomOffset:220.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10149){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"连接服务器异常" bottomOffset:220.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide:YES];
                        [TLToast showWithText:@"连接服务器异常" bottomOffset:220.0f duration:1.0];
                    });
                }
                
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                 [phud hide:YES];
                                  [TLToast showWithText:@"连接服务器异常" bottomOffset:220.0f duration:1.0];
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

@end
