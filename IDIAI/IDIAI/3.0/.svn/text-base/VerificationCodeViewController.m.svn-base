//
//  VerificationCodeViewController.m
//  UTopGD
//
//  Created by Ricky on 15/9/19.
//  Copyright (c) 2015年 yangfan. All rights reserved.
//
//3.6.6已废弃 byzhangliang
#import "VerificationCodeViewController.h"
#import "HexColor.h"
#import "TLToast.h"
#import "savelogObj.h"
#import "util.h"
@interface VerificationCodeViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UITextField *phonetxf;
@property(nonatomic,strong)UITextField *vftxf;
@property(nonatomic,strong)UILabel *vflbl;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)int secondsCountDown;
@property(nonatomic,strong)UITapGestureRecognizer *hidekeyboard;
@end

@implementation VerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor colorWithHexString:@"F0EFF5"];
    [self initView];
    self.secondsCountDown = 60;//60秒倒计时
    self.hidekeyboard =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];

}
-(void)timeFireMethod{
    self.secondsCountDown--;
    self.vflbl.text =[NSString stringWithFormat:@"%ds",self.secondsCountDown];
    UIImageView *getimage =(UIImageView*)[self.view viewWithTag:100];
    getimage.userInteractionEnabled =NO;
    if(self.secondsCountDown==0){
        self.vflbl.text =@"重新发送";
        UIImageView *getimage =(UIImageView*)[self.view viewWithTag:100];
        getimage.userInteractionEnabled =YES;
        self.secondsCountDown = 60;
        [self.timer invalidate];
    }
}
-(void)viewWillAppear:(BOOL)animated{
//    if (self.isres ==YES) {
        UIButton *theBackButton = [[UIButton alloc] initWithFrame:[self BackButtonRect]];
        [theBackButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [theBackButton setImage:[UIImage imageNamed:@"ic_fanhui"] forState:UIControlStateNormal];
        //navigation item左移一点
        theBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc]initWithCustomView:theBackButton];
        self.navigationItem.leftBarButtonItem = backBarBtn;
//    }
}

- (CGRect)BackButtonRect
{
    //    CGRect rect = [self CustomNavgationBarRect];
    return CGRectMake(10, 6, 50, 34);
}
-(void)leftButtonPressed:(id)sender{
    [self.vftxf resignFirstResponder];
    [self.phonetxf resignFirstResponder];
    [self performSelector:@selector(showAlert) withObject:nil afterDelay:0.6];
}
-(void)showAlert{
    UIAlertView *aler =[[UIAlertView alloc] initWithTitle:@"验证码可能有延迟，确定返回？" message:@"" delegate:self cancelButtonTitle:@"等待" otherButtonTitles:@"返回", nil];
    [aler show];
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.timer invalidate];
}
    // Do any additional setup after loading the view.
-(void)initView{
    UIImageView *phoneImage =[[UIImageView alloc] initWithFrame:CGRectMake(11, 18, kMainScreenWidth-22, 41)];
    //    nameImage.image =[UIImage imageNamed:@"bg_dibu.png"];
    phoneImage.backgroundColor =[UIColor whiteColor];
    phoneImage.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
    phoneImage.layer.borderWidth = 1;
    phoneImage.layer.masksToBounds = YES;
    phoneImage.layer.cornerRadius = 5;
//    if (self.type!=0) {
//        phoneImage.hidden =YES;
//    }
    [self.view addSubview:phoneImage];
    
    UILabel *phonehead =[[UILabel alloc] initWithFrame:CGRectMake(22, 31, 42, 14)];
    phonehead.text =@"手机号";
    phonehead.textColor =[UIColor blackColor];
    phonehead.textAlignment =NSTextAlignmentRight;
    phonehead.font =[UIFont systemFontOfSize:14];
//    if (self.type!=0) {
//        phonehead.hidden =YES;
//    }
    [self.view addSubview:phonehead];
    
    self.phonetxf =[[UITextField alloc] initWithFrame:CGRectMake(phonehead.frame.size.width+phonehead.frame.origin.x+20, phonehead.frame.origin.y, phoneImage.frame.size.width-110-phonehead.frame.size.width+phonehead.frame.origin.x+20, 14)];
    self.phonetxf.placeholder =@"请输入手机号";
    self.phonetxf.delegate =self;
    self.phonetxf.font =[UIFont systemFontOfSize:14];
    self.phonetxf.keyboardType =UIKeyboardTypeNumberPad;
//    if (self.type!=0) {
//        self.phonetxf.hidden =YES;
//    }
    [self.view addSubview:self.phonetxf];
    
    UIImageView *vfImage =[[UIImageView alloc] initWithFrame:CGRectMake(11, phoneImage.frame.size.height+phoneImage.frame.origin.y+10, (kMainScreenWidth-22-12)/11*7, 41)];
//    if (self.type!=0) {
//        vfImage.frame =CGRectMake(11, 18+64, (kMainScreenWidth-22-12)/11*7, 41);
//    }
    //    nameImage.image =[UIImage imageNamed:@"bg_dibu.png"];
    vfImage.backgroundColor =[UIColor whiteColor];
    vfImage.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
    vfImage.layer.borderWidth = 1;
    vfImage.layer.masksToBounds = YES;
    vfImage.layer.cornerRadius = 5;
    vfImage.userInteractionEnabled =YES;
    [self.view addSubview:vfImage];
    
    self.vftxf =[[UITextField alloc] initWithFrame:CGRectMake(10, 13, vfImage.frame.size.width-20, 14)];
    self.vftxf.placeholder =@"请输入验证码";
    self.vftxf.delegate =self;
    self.vftxf.font =[UIFont systemFontOfSize:14];
//    self.vftxf.textAlignment =NSTextAlignmentCenter;
    self.vftxf.keyboardType =UIKeyboardTypeNumberPad;
    [vfImage addSubview:self.vftxf];
    
    UIImageView *getvfImage =[[UIImageView alloc] initWithFrame:CGRectMake(vfImage.frame.origin.x+vfImage.frame.size.width+10, vfImage.frame.origin.y, (kMainScreenWidth-22-12)/11*4, 41)];
    //    nameImage.image =[UIImage imageNamed:@"bg_dibu.png"];
    getvfImage.backgroundColor =[UIColor whiteColor];
    getvfImage.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
    getvfImage.layer.borderWidth = 1;
    getvfImage.layer.masksToBounds = YES;
    getvfImage.layer.cornerRadius = 5;
    getvfImage.userInteractionEnabled =YES;
    getvfImage.tag =100;
    [self.view addSubview:getvfImage];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getVFCoder:)];
    [getvfImage addGestureRecognizer:tap];
    
    self.vflbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 13, getvfImage.frame.size.width-20, 14)];
    self.vflbl.text =@"获取验证码";
    self.vflbl.font =[UIFont systemFontOfSize:14];
    self.vflbl.textColor =[UIColor redColor];
    self.vflbl.textAlignment =NSTextAlignmentCenter;
    [getvfImage addSubview:self.vflbl];
    
    UIButton *completebtn =[UIButton buttonWithType:UIButtonTypeCustom];
    completebtn.frame =CGRectMake(11, getvfImage.frame.size.height+getvfImage.frame.origin.y+96, kMainScreenWidth-22, 40);
    [completebtn setBackgroundColor:kThemeColor];
    completebtn.layer.cornerRadius = 5;
    completebtn.layer.masksToBounds = YES;
    [completebtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    if (self.type==0) {
        [completebtn setTitle:@"立即预约" forState:UIControlStateNormal];
    }else{
        [completebtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    [self.view addSubview:completebtn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)nextAction:(id)sender{
    if (self.vftxf.text.length ==0) {
        [phud hide:YES];
        [TLToast showWithText:@"请输入验证码" topOffset:220.0f duration:1.0];
        return;
    }
    if([util checkTel:self.phonetxf.text]==NO){
        return;
    }
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
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
        
        
//        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
//        [postDict setObject:@"ID0009" forKey:@"cmdID"];
//        [postDict setObject:string_token forKey:@"token"];
//        [postDict setObject:string_userid forKey:@"userID"];
//        [postDict setObject:@"ios" forKey:@"deviceType"];
//        [postDict setObject:kCityCode forKey:@"cityCode"];
//        
//        NSString *string=[postDict JSONString];
//        NSDictionary *bodyDic = @{@"userMobile":self.phonetxf.text,@"smsCode":self.vftxf.text};
//        NSString *string02=[bodyDic JSONString];
//        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
//        [post setObject:string forKey:@"header"];
//        [post setObject:string02 forKey:@"body"];
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0009\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"userMobile\":\"%@\",\"smsCode\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.phonetxf.text,self.vftxf.text];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
//        NetworkRequest *req = [[NetworkRequest alloc] init];
//        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setTimeOutSeconds:15];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                // NSLog(@"login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (kResCode == 10101) {
                        [self stopRequest];
                        [self startRequestWithString:@"加载中..."];
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
                            [postDict setObject:@"ID0260" forKey:@"cmdID"];
                            [postDict setObject:string_token forKey:@"token"];
                            [postDict setObject:string_userid forKey:@"userID"];
                            [postDict setObject:@"ios" forKey:@"deviceType"];
                            [postDict setObject:kCityCode forKey:@"cityCode"];
                            
                            NSString *string=[postDict JSONString];
                            NSDictionary *bodyDic = @{@"userName":self.userName,@"userMobile":self.phonetxf.text,@"provinceCode":self.provinceCode,@"cityCode":self.cityCode,@"areaCode":self.areaCode,@"serviceType":self.serviceType};
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
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (kResCode == 102601) {
                                            [self stopRequest];
                                            self.vflbl.text =@"重新发送";
                                            UIImageView *getimage =(UIImageView*)[self.view viewWithTag:100];
                                            getimage.userInteractionEnabled =YES;
                                            self.secondsCountDown = 60;
                                            [self.timer invalidate];
                                            [phud hide:YES];
                                            [TLToast showWithText:@"申请成功" topOffset:220.0f duration:1.0];
                                            [self.navigationController popToRootViewControllerAnimated:YES];

                                        } else {
                                            [self stopRequest];
                                            [phud hide:YES];
                                            [TLToast showWithText:@"申请失败" topOffset:220.0f duration:1.0];

                                        }
                                    });
                                });
                            }
                                              failedBlock:^{
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self stopRequest];
                                                      [phud hide:YES];
                                                      [TLToast showWithText:@"申请失败" topOffset:220.0f duration:1.0];

                                                  });
                                              }
                                                   method:url postDict:post];
                        });
                    } else {
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"请输入正确的手机验证码" topOffset:220.0f duration:1.0];

                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:nil];
    });
//    if (self.type ==0) {
//        [HomePageParser getValidationVFCoder:@"ID0009" userMobile:self.phonetxf.text smsCode:self.vftxf.text theBlock:^(id user, NSError *error) {
//            if (!error) {
//                [HomePageParser postApply:@"ID0260" userName:self.userName userMobile:self.phonetxf.text provinceCode:self.provinceCode cityCode:self.cityCode areaCode:self.areaCode serviceType:self.serviceType theBlock:^(id user, NSError *error) {
//                    if (!error) {
//                        self.vflbl.text =@"重新发送";
//                        UIImageView *getimage =(UIImageView*)[self.view viewWithTag:100];
//                        getimage.userInteractionEnabled =YES;
//                        self.secondsCountDown = 60;
//                        [self.timer invalidate];
//                        [phud hide:YES];
//                        [TLToast showWithText:@"申请成功" topOffset:220.0f duration:1.0];
//                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    }else{
//                        [phud hide:YES];
//                        [TLToast showWithText:@"申请失败" topOffset:220.0f duration:1.0];
//                    }
//                }];
//            }else{
//                [phud hide:YES];
//                [TLToast showWithText:@"请输入正确的手机验证码" topOffset:220.0f duration:1.0];
//            }
//        }];
//    }
}
-(void)createProgressView{
    if (!phud) {
        phud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:phud];
        phud.mode=MBProgressHUDModeIndeterminate;
        //self.pHUD.dimBackground=YES; //是否开启背景变暗
        // phud.labelText = @"数据加载中...";
        //        phud.blur=NO;  //是否开启ios7毛玻璃风格
        //        phud.darkBlur=YES; //受blur限制（blur为YES时设置darkBlur才有用）
        [phud show:YES];
    }
    else{
        [phud show:YES];
    }
}

-(void)getVFCoder:(UIGestureRecognizer *)sender{
    UIImageView *getvfImage =(UIImageView *)sender.view;
    getvfImage.userInteractionEnabled =NO;
    if([util checkTel:self.phonetxf.text]==NO){
        getvfImage.userInteractionEnabled =YES;
        return;
    }
    if(![util isConnectionAvailable]){
        [TLToast showWithText:@"无网络连接" topOffset:200.0f duration:1.0];
        return;
    }
    [self createProgressView];
    [self startRequestWithString:@"加载中..."];
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
        [postDict setObject:@"ID0264" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *bodyDic = @{@"mobile":self.phonetxf.text};
        NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:bodyDic
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:nil];
        NSString *str1 =[[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:str forKey:@"header"];
        [post setObject:str1 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setTimeOutSeconds:15];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                 NSLog(@"返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (kResCode == 102641) {
                        [self stopRequest];
                        [phud hide:YES];
                        [TLToast showWithText:@"获取验证码成功" topOffset:220.0f duration:1.0];
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
                        getvfImage.userInteractionEnabled =YES;
                    } else {
                        [self stopRequest];
                        [phud hide:YES];
                        getvfImage.userInteractionEnabled =YES;
                        [TLToast showWithText:@"提交申请失败"];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [phud hide:YES];
                                  [TLToast showWithText:@"获取验证码失败" topOffset:220.0f duration:1.0];
                                  getvfImage.userInteractionEnabled =YES;
                              });
                          }
                               method:url postDict:post];
    });
//    [HomePageParser postVFCoder:@"ID0264" mobile:self.phonetxf.text theBlock:^(id user, NSError *error) {
//            if (!error) {
//                [phud hide:YES];
//                [TLToast showWithText:@"获取验证码成功" topOffset:220.0f duration:1.0];
//                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
//                getvfImage.userInteractionEnabled =YES;
//            }else{
//                [phud hide:YES];
//                [TLToast showWithText:@"获取验证码失败" topOffset:220.0f duration:1.0];
//                getvfImage.userInteractionEnabled =YES;
//            }
//        }];
    
}
-(void)hideAction:(id)sender{
    [self.phonetxf resignFirstResponder];
    [self.vftxf resignFirstResponder];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.view addGestureRecognizer:self.hidekeyboard];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view removeGestureRecognizer:self.hidekeyboard];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.phonetxf resignFirstResponder];
    [self.vftxf resignFirstResponder];
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==alertView.cancelButtonIndex) {
        
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
