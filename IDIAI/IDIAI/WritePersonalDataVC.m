//
//  WritePersonalDataVC.m
//  IDIAI
//
//  Created by iMac on 14-7-14.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "WritePersonalDataVC.h"
#import "HexColor.h"
#import "TLToast.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "PersonalInfoObj.h"
#import "savelogObj.h"
#import "AutomaticLogin.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "savelogObj.h"
#import "PersonalInfoViewController.h"
@interface WritePersonalDataVC ()<UITextViewDelegate,UIActionSheetDelegate,LoginViewDelegate>
{
    UITextView *textf;
    UIButton *btn_clear;
    UIButton *btn_select;
}

@property (strong, nonatomic) UILabel *uilabel;
@end

@implementation WritePersonalDataVC
@synthesize title_main,select_index,title_diplay,uilabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//
//- (void)customizeNavigationBar {
//    [[[self navigationController] navigationBar] setHidden:YES];
//    
//    UIImageView *nav_bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"导航条.png"]];
//    nav_bg.frame=CGRectMake(0, 20, 320, 44);
//    nav_bg.userInteractionEnabled=YES;
//    [self.view addSubview:nav_bg];
//    
//    CGRect frame = CGRectMake(100, 27, 120, 25);
//    UILabel *label = [[UILabel alloc] initWithFrame:frame];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont boldSystemFontOfSize:22.0];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
//    label.text = title_main;
//    [self.view addSubview:label];
//    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setFrame:CGRectMake(10, 25, 50, 28)];
//    leftButton.tag=1;
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回键.png"] forState:UIControlStateNormal];
//    [leftButton addTarget:self
//                    action:@selector(backTouched:)
//          forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:leftButton];
//    
//
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setFrame:CGRectMake(260, 26, 50, 28)];
//    rightButton.tag=2;
//    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor colorWithHexString:@"#6d2907" alpha:1.0] forState:UIControlStateNormal];
//    [rightButton addTarget:self
//                   action:@selector(backTouched:)
//         forControlEvents:UIControlEventTouchUpInside];
////    [self.view addSubview:rightButton];
//    
//    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//    statusBarView.backgroundColor=[UIColor blackColor];
//    [self.view addSubview:statusBarView];
//}

-(void)viewWillAppear:(BOOL)animated{
//    [[[self navigationController] navigationBar] setHidden:YES];
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
}
//-(void)backTouched:(UIButton *)btn{
//    if(btn.tag==1){
//    [self.view endEditing:YES];
//      [self.navigationController popViewControllerAnimated:YES];
//    }
//    else if(btn.tag==2){
//        [savelogObj saveLog:[NSString stringWithFormat:@"用户修改了%@",title_main] userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:6];
//        [self.view endEditing:YES];
//            if(textf.text.length>=2) {
//                if([title_main isEqualToString:@"昵称"]){
//                    if(textf.text.length<=30){
//                        if (textf.text.length>=2) {
//                            if( [self isPureInt:textf.text]||[self isPureFloat:textf.text])
//                                [TLToast showWithText:@"昵称不能是纯数字" bottomOffset:200.0f duration:1.0];
//                            else{
//                                UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
//                                selected_btn.enabled=NO;
//                                [self SendpersonalInfo];
//                            }
//                        }
//                        else [TLToast showWithText:@"请填写2～30位的昵称" bottomOffset:200.0f duration:1.0];
//                        
//                    }
//                    else [TLToast showWithText:@"请填写2～30位的昵称" bottomOffset:200.0f duration:1.0];
//                }
//                else if([title_main isEqualToString:@"地址"]){
//                    if(textf.text.length<=40){
//                        if (textf.text.length>=4) {
//                            UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
//                            selected_btn.enabled=NO;
//                            [self SendpersonalInfo];
//                        }
//                        else[TLToast showWithText:@"请填写4～40位的小区地址" bottomOffset:200.0f duration:1.0];
//                    }
//                    else [TLToast showWithText:@"请填写4～40位的小区地址" bottomOffset:200.0f duration:1.0];
//                }
//                else if([title_main isEqualToString:@"小区名称"]){
//                    if(textf.text.length<=30 && textf.text.length>=2){
//                        UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
//                        selected_btn.enabled=NO;
//                        [self SendpersonalInfo];
//                    }
//                    else [TLToast showWithText:@"请填写2～30位的小区名字" bottomOffset:200.0f duration:1.0];
//                }
//            }
//    else [TLToast showWithText:@"输入内容不能为空" bottomOffset:200.0f duration:1.0];
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = title_main;
    
//    //导航右按钮
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 50, 30);
//    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(clickNavRightBtn:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
//    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [self customizeNavigationBar];
    
    UIImageView *imageview_bg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 280, 160)];
    imageview_bg.userInteractionEnabled=YES;
    imageview_bg.image=[UIImage imageNamed:@"输入框.png"];
//    [self.view addSubview:imageview_bg];
    
    textf=[[UITextView alloc]initWithFrame:CGRectMake(0, 30, kMainScreenWidth, 140)];
//    textf.backgroundColor=[UIColor clearColor];
    textf.returnKeyType=UIReturnKeyDone;
    textf.font=[UIFont systemFontOfSize:17];
    textf.scrollEnabled=YES;
    textf.delegate=self;
    if([title_diplay isEqualToString:@"填写你的昵称"] ||[title_diplay isEqualToString:@"填写地址"] || [title_diplay isEqualToString:@"填写小区名称"]) title_diplay=@"";
    textf.text=[NSString stringWithFormat:@"%@",title_diplay];
    [self.view addSubview:textf];
        
    uilabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 38, kMainScreenWidth - 10, 20)];
    if(title_diplay.length==0)
    uilabel.text = [NSString stringWithFormat:@"请填写您的%@",title_main];
    uilabel.font=[UIFont systemFontOfSize:17];
    uilabel.enabled = NO;//lable必须设置为不可用
    uilabel.textAlignment=NSTextAlignmentLeft;
    uilabel.textColor=[UIColor blackColor];
    uilabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:uilabel];
    
    UIButton *makeSureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    makeSureBtn.frame = CGRectMake(10, CGRectGetMaxY(textf.frame)+30, kMainScreenWidth - 20, 44);
    makeSureBtn.layer.cornerRadius = 6;
    [makeSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    makeSureBtn.backgroundColor = kThemeColor;
    [makeSureBtn addTarget:self action:@selector(clickmakeSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:makeSureBtn];
}

////发送个人信息
//-(void)SendpersonalInfo{
//    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(parsingQueue, ^{
//        
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
//        
//        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
//        [postDict setObject:@"ID0017" forKey:@"cmdID"];
//        [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] forKey:@"token"];
//        [postDict setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
//        [postDict setObject:@"iOS" forKey:@"deviceType"];
//        [postDict setObject:kCityCode forKey:@"cityCode"];
//        NSString *string=[postDict JSONString];
//        
//        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
//        if(select_index==1) {
//            if(textf.text.length>=1)
//            [postDict02 setObject:textf.text forKey:@"nickName"];
//            else
//            [postDict02 setObject:@"" forKey:@"nickName"];
//        }
//        else {
//            [postDict02 setObject:@"" forKey:@"nickName"];
//        }
//
//        if(select_index==4) {
//            if(textf.text.length>=1)
//            [postDict02 setObject:textf.text forKey:@"userAddress"];
//            else
//            [postDict02 setObject:@"" forKey:@"userAddress"];
//        }
//        else{
//            [postDict02 setObject:@"" forKey:@"userAddress"];
//        }
//        
//        if(select_index==5) {
//            if(textf.text.length>=1)
//                [postDict02 setObject:textf.text forKey:@"villageName"];
//            else
//                [postDict02 setObject:@"" forKey:@"villageName"];
//        }
//        else{
//            [postDict02 setObject:@"" forKey:@"villageName"];
//        }
//        
//        [postDict02 setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:User_ID]] forKey:@"userID"];
//        [postDict02 setObject:@"" forKey:@"userLogo"];
//        [postDict02 setObject:@"" forKey:@"sex"];
//        
//        [postDict02 setObject:@"" forKey:@"provinceName"];
//        [postDict02 setObject:@"" forKey:@"provinceCode"];
//        [postDict02 setObject:@"" forKey:@"cityName"];
//        [postDict02 setObject:@"" forKey:@"cityCode"];
//        [postDict02 setObject:@"" forKey:@"areaName"];
//        [postDict02 setObject:@"" forKey:@"areaCode"];
//        
//        NSString *string02=[postDict02 JSONString];
//        
//        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
//        [post setObject:string forKey:@"header"];
//        [post setObject:string02 forKey:@"body"];
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
//               // NSLog(@"返回信息：%@",jsonDict);
//                
//                //token为空或验证未通过处理 huangrun
//                if (kResCode == 10002 || kResCode == 10003) {
//                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
//                    login.delegate=self;
//                    [login show];
//                    return;
//                }
//                
//                
//                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10191) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [savelogObj saveLog:@"个人信息修改" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:6];
//                        
//                        UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
//                        selected_btn.enabled=YES;
//                     [TLToast showWithText:[NSString stringWithFormat:@"设置%@成功",title_main] bottomOffset:200.0f duration:1.0];
//                        if([title_main isEqualToString:@"昵称"])
//                        [[NSUserDefaults standardUserDefaults]setObject:textf.text forKey:User_nickName];
//                        else if([title_main isEqualToString:@"地址"])
//                            [[NSUserDefaults standardUserDefaults]setObject:textf.text forKey:User_Addrss];
//                        else if([title_main isEqualToString:@"小区名称"])
//                            [[NSUserDefaults standardUserDefaults]setObject:textf.text forKey:User_Village];
//                        [[NSUserDefaults standardUserDefaults]synchronize];
//                        [self.navigationController popViewControllerAnimated:YES];
//                    });
//                }
//                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10199){
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
//                        selected_btn.enabled=YES;
//                        [TLToast showWithText:[NSString stringWithFormat:@"设置%@失败",title_main] bottomOffset:200.0f duration:1.0];
//                    });
//                }
//                else{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
//                        selected_btn.enabled=YES;
//                       [TLToast showWithText:[NSString stringWithFormat:@"设置%@失败",title_main] bottomOffset:200.0f duration:1.0];
//                    });
//                }
//            });
//        }
//                               failedBlock:^{
//                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                       UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
//                                       selected_btn.enabled=YES;
//                                       [TLToast showWithText:[NSString stringWithFormat:@"设置%@失败",title_main] bottomOffset:200.0f duration:1.0];
//                                   });
//                               }
//                                    method:url postDict:post];
//    });
//    
//}

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

-(void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        uilabel.text = [NSString stringWithFormat:@"请填写您的%@",title_main];
    }else{
        uilabel.text = @"";
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//判断是否为整形：

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//
//- (void)clickNavRightBtn:(UIButton *)btn {
//    [savelogObj saveLog:[NSString stringWithFormat:@"用户修改了%@",title_main] userID:[NSString stringWithFormat:@" %ld",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:6];
//    [self.view endEditing:YES];
//    if(textf.text.length>=1) {
//        if([title_main isEqualToString:@"昵称"]){
//            if(textf.text.length<=30){
//                if (textf.text.length>=2) {
//                    if( [self isPureInt:textf.text]||[self isPureFloat:textf.text])
//                        [TLToast showWithText:@"昵称不能是纯数字" bottomOffset:200.0f duration:1.0];
//                    else{
//                        UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
//                        selected_btn.enabled=NO;
//                        [self SendpersonalInfo];
//                    }
//                }
//                else[TLToast showWithText:@"请填写2～30位的昵称" bottomOffset:200.0f duration:1.0];
//            }
//            else [TLToast showWithText:@"请填写2～30位的昵称" bottomOffset:200.0f duration:1.0];
//        }
//        else if([title_main isEqualToString:@"地址"]){
//            if(textf.text.length<=40){
//                if (textf.text.length>=4) {
//                    UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
//                    selected_btn.enabled=NO;
//                    [self SendpersonalInfo];
//                }
//                else[TLToast showWithText:@"请填写4～40位的小区地址" bottomOffset:200.0f duration:1.0];
//                
//            }
//            else [TLToast showWithText:@"请填写4～40位的小区地址" bottomOffset:200.0f duration:1.0];
//        }
//        else if([title_main isEqualToString:@"小区名称"]){
//            if(textf.text.length<=30 && textf.text.length>=2){
//                UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
//                selected_btn.enabled=NO;
//                [self SendpersonalInfo];
//            }
//            else [TLToast showWithText:@"请填写2～30字的小区名称" bottomOffset:200.0f duration:1.0];
//        }
//    }
//    else [TLToast showWithText:@"输入内容不能为空" bottomOffset:200.0f duration:1.0];
//
//}

- (void)clickmakeSureBtn:(id)sender{

    [self.view endEditing:YES];
    if(textf.text.length>=1) {
        if([title_main isEqualToString:@"昵称"]){
            if(textf.text.length<=30){
                if (textf.text.length>=2) {
                    if( [self isPureInt:textf.text]||[self isPureFloat:textf.text])
                        [TLToast showWithText:@"昵称不能是纯数字" bottomOffset:200.0f duration:1.0];
                    else{
                        UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
                        selected_btn.enabled=NO;
                        //                    [self SendpersonalInfo];
                        NSArray  * array  = self.navigationController.viewControllers;
                        if(array.count >1){
                        NSObject * VC  = [array objectAtIndex:array.count -2];
                            
                            if([VC isKindOfClass:[PersonalInfoViewController class]]){
                            
                                PersonalInfoViewController * personInfoVC  = VC;
                                personInfoVC.nickName = textf.text;
                                personInfoVC.nickNameIsChanged = YES;
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            
                        
                        }
                        
                    }
                }
                else[TLToast showWithText:@"请填写2～30位的昵称" bottomOffset:200.0f duration:1.0];
            }
            else [TLToast showWithText:@"请填写2～30位的昵称" bottomOffset:200.0f duration:1.0];
        }
        else if([title_main isEqualToString:@"地址"]){
            if(textf.text.length<=40){
                if (textf.text.length>=4) {
                    UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
                    selected_btn.enabled=NO;
                    
                    NSArray  * array  = self.navigationController.viewControllers;
                    if(array.count >1){
                        NSObject * VC  = [array objectAtIndex:array.count -2];
                        
                        if([VC isKindOfClass:[PersonalInfoViewController class]]){
                            
                            PersonalInfoViewController * personInfoVC  = VC;
                            personInfoVC.address= textf.text;
                            personInfoVC.addressIsChanged = YES;
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                        
                    }
                }
                else[TLToast showWithText:@"请填写4～40位的小区地址" bottomOffset:200.0f duration:1.0];
                
            }
            else [TLToast showWithText:@"请填写4～40位的小区地址" bottomOffset:200.0f duration:1.0];
        }
        else if([title_main isEqualToString:@"小区名称"]){
            if(textf.text.length<=30 && textf.text.length>=2){
                UIButton *selected_btn=(UIButton *)[self.view viewWithTag:2];
                selected_btn.enabled=NO;
                NSArray  * array  = self.navigationController.viewControllers;
                if(array.count >1){
                    NSObject * VC  = [array objectAtIndex:array.count -2];
                    
                    if([VC isKindOfClass:[PersonalInfoViewController class]]){
                        
                        PersonalInfoViewController * personInfoVC  = VC;
                        personInfoVC.xiaoQu = textf.text;
                        personInfoVC.xiaoquIsChanged = YES;
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                }
            }
            else [TLToast showWithText:@"请填写2～30字的小区名称" bottomOffset:200.0f duration:1.0];
        }
    }
    else [TLToast showWithText:@"输入内容不能为空" bottomOffset:200.0f duration:1.0];

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
