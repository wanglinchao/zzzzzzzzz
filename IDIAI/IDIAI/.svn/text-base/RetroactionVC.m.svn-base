//
//  RetroactionVC.m
//  IDIAI
//
//  Created by iMac on 14-7-15.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "RetroactionVC.h"
#import "HexColor.h"
#import "TLToast.h"
#import "CircleProgressHUD.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "util.h"

@interface RetroactionVC ()<UITextFieldDelegate,UITextViewDelegate>
{
    CircleProgressHUD *phud;
    
//    NSString *_callNum;
}

@end

@implementation RetroactionVC



- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:YES];
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    
    UIImageView *nav_bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"导航条.png"]];
    nav_bg.frame=CGRectMake(0, 20, 320, 44);
    nav_bg.userInteractionEnabled=YES;
    [self.view addSubview:nav_bg];
    
    CGRect frame = CGRectMake(100, 27, 120, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    label.text = @"意见反馈";
    [self.view addSubview:label];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(10, 25, 50, 28)];
    leftButton.tag=1;
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回键.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(PressbackTouched)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:statusBarView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];

}



-(void)PressbackTouched{
    [phud hide];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"意见反馈";
    self.index = 4;
    
    if(IS_iOS7_8)
    self.textfield_input.delegate=self;
    self.textfield_input.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textfield_input.keyboardType=UIKeyboardTypePhonePad;
    self.textview_input.returnKeyType=UIReturnKeyDone;
    self.textview_input.delegate=self;
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 90, 40)];
    [rightButton setImage:[UIImage imageNamed:@"btn_dianhua"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 25, 0, -5);
    [rightButton addTarget:self
                    action:@selector(clickCallBtn:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];


    [self.btn_tj addTarget:self
                   action:@selector(PressTJ)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self configViewBorder];
//    [self requestCallNum];
}

#pragma mark -
#pragma mark - CircleProgressHUDDelegate
-(void)createProgressView{
    if(!phud)
        phud=[[CircleProgressHUD alloc]initWithFrame:CGRectMake(100, 180, 120, 120) title:nil];
    [phud show];
}

//向服务器发送反馈内容
-(void)SendContentToServer{
    if (self.textview_input.text.length>200) {
        [TLToast showWithText:@"反馈内容最多输入200字"];
        return;
    }
    [self startRequestWithString:@"发送中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
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
        
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0015" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"iOS" forKey:@"deviceType"];
        NSString *string=[postDict JSONString];
        
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)self.index] forKey:@"moodID"];
        [postDict02 setObject:self.textview_input.text forKey:@"content"];
        [postDict02 setObject:self.textfield_input.text forKey:@"contact"];
        [postDict02 setObject:@"1" forKey:@"feedType"];
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
                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10181) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide];
                        [TLToast showWithText:@"反馈发送成功" bottomOffset:200.0f duration:1.0];
                        self.textfield_input.text=@"";
                        self.textview_input.text=@"";

                        [self.textfield_input resignFirstResponder];
                        [self.textview_input resignFirstResponder];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10182){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide];
                        [TLToast showWithText:@"内容不符合要求" bottomOffset:200.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10183){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide];
                        [TLToast showWithText:@"用户输入的联系方式不符合要求" bottomOffset:200.0f duration:1.0];
                    });
                }
                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10189){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide];
                        [TLToast showWithText:@"连接服务器异常" bottomOffset:200.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide];
                        [TLToast showWithText:@"连接服务器异常" bottomOffset:200.0f duration:1.0];
                    });
                }
            });
        }
                               failedBlock:^{
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self stopRequest];
                                       [phud hide];
                                       [TLToast showWithText:@"连接服务器异常" bottomOffset:200.0f duration:1.0];
                                   });
                               }
                                    method:url postDict:post];
    });
    
}


#pragma mark -
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGPoint center = self.view.center;
    center.y -= 140;
    self.view.center = center;
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGPoint center = self.view.center;
    center.y += 140;
    self.view.center = center;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}
-(void)PressTJ{
    if(self.textview_input.text.length>0){
        if(self.textfield_input.text.length<12){
//            [self createProgressView];
            [self SendContentToServer];
        }
        else
            [TLToast showWithText:@"联系方式不能高于11位" bottomOffset:200.0f duration:1.0];
    }
    else{
       [TLToast showWithText:@"请填写反馈内容" bottomOffset:200.0f duration:1.0];
    }
}


- (IBAction)clickCallBtn:(id)sender {
//    if (_callNum) {
        NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",callNumber];
        UIWebView *callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
        [self.view addSubview:callWebview];
//    } else {
//        [self requestCallNum];
//    }
}

#pragma mark - 设置view边框属性

- (void)configViewBorder {
 
    //提交
    self.btn_tj.layer.masksToBounds = YES;
    self.btn_tj.layer.cornerRadius = 3;
}

//#pragma mark - 获取电话号码
//- (void)requestCallNum {
//    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(parsingQueue, ^{
//        
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
//        
//        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
//        [postDict setObject:@"ID0036" forKey:@"cmdID"];
//        [postDict setObject:@"" forKey:@"token"];
//        [postDict setObject:@"" forKey:@"userID"];
//        [postDict setObject:@"iOS" forKey:@"deviceType"];
//        NSString *string=[postDict JSONString];
//        
//        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
//        [post setObject:string forKey:@"header"];
//        [post setObject:@"" forKey:@"body"];
//        
//        
//        NetworkRequest *req = [[NetworkRequest alloc] init];
//        [req setHttpMethod:PostMethod];
//        
//        [req sendToServerInBackground:^{
//            dispatch_async(parsingQueue, ^{
//                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
//                [request setResponseEncoding:NSUTF8StringEncoding];
//                NSString *respString = [request responseString];
//                NSDictionary *jsonDict = [respString objectFromJSONString];
//               // NSLog(@"1---返回信息：%@",jsonDict);
//                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10361) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        _callNum = [jsonDict objectForKey:@"fbPhoneNumber"];
//                        NSLog(@"获取电话成功");
//                    });
//                }
//                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10369){
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSLog(@"获取电话失败");
//                    });
//                } else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                    });
//                }
//            });
//        }
//                          failedBlock:^{
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                 
//                              });
//                          }
//                               method:url postDict:post];
//    });
//    
//
//}

@end
