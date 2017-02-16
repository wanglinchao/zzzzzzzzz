//
//  InputLoginPsdViewController.m
//  IDIAI
//
//  Created by Ricky on 15-2-2.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "InputLoginPsdViewController.h"
#import "CheckSMScodeVC.h"
#import "NSStringAdditions.h"
#import "TLToast.h"
#import "util.h"
#import "AutomaticLogin.h"
//#import "LoginVC.h"
#import "LoginView.h"

@interface InputLoginPsdViewController () <UITableViewDataSource, UITableViewDelegate, LoginViewDelegate> {
    UITableView *_theTableView;
    UITextField *_loginPsdTF;
}

@end

@implementation InputLoginPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"输入登录密码";
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    _theTableView = [[UITableView alloc]initWithFrame:kTableViewWithTabBarFrame style:UITableViewStyleGrouped];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    [self.view addSubview:_theTableView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    UIButton *nextStepBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextStepBtn.frame = CGRectMake(10, 10, kMainScreenWidth - 20, 40);
    [nextStepBtn addTarget: self action:@selector(clickNextStepBtn:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextStepBtn.backgroundColor = kThemeColor;
    nextStepBtn.layer.masksToBounds = YES;
    nextStepBtn.layer.cornerRadius = 3;
    [bottomView addSubview:nextStepBtn];
    _theTableView.tableFooterView = bottomView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"inputLoginPsdCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"ic_mm.png"];
    _loginPsdTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 2, kMainScreenWidth - 80, 44)];
    _loginPsdTF.secureTextEntry = YES;
    _loginPsdTF.placeholder = @"请输入登录密码";
    [cell.contentView addSubview:_loginPsdTF];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

- (void)clickNextStepBtn:(id)sender {
    if ([NSString isEmptyOrWhitespace:_loginPsdTF.text]) {
        [TLToast showWithText:@"请输入登录密码"];
        return;
    }
    [_loginPsdTF resignFirstResponder];
    [self requestVerifyLoginPsd:_loginPsdTF.text];
}

#pragma mark - 验证登录密码
-(void)requestVerifyLoginPsd:(NSString *)psdStr {
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
        [postDict setObject:@"ID0144" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSString *md5LoginPsdStr = [util md5:psdStr];
        NSDictionary *bodyDic = @{@"password":md5LoginPsdStr,@"isSendMsg":@(9)};
        
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
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 101441) {
                        [self stopRequest];
                            CheckSMScodeVC *checkvc=[[CheckSMScodeVC alloc]init];
                            checkvc.Req_typeSMS=@"getVeriCode";
                        checkvc.check_Number = [[NSUserDefaults standardUserDefaults]objectForKey:User_Name];
                        checkvc.psdStr = psdStr;
                        checkvc.fromStr =self.fromStr;
                        checkvc.sourceVCStr = @"inputLoginPsdVC";
                            [self.navigationController pushViewController:checkvc animated:YES];
    
                    } else if (kResCode == 101442) {
                        [self stopRequest];
                        [TLToast showWithText:@"请填写正确的登录密码"];
                    } else if (kResCode == 101449) {
                        [self stopRequest];
                        [TLToast showWithText:@"系统异常"];
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
                               method:url postDict:post];
    });
    
}




@end
