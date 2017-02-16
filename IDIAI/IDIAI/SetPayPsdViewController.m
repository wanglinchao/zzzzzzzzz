//
//  SetPayPsdViewController.m
//  IDIAI
//
//  Created by Ricky on 15-2-2.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SetPayPsdViewController.h"
#import "NSStringAdditions.h"
#import "TLToast.h"
#import "util.h"
#import "AutomaticLogin.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "HRCoreAnimationEffect.h"

#define kPRBGColor [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:.7]

@interface SetPayPsdViewController () <UITableViewDataSource, UITableViewDelegate,LoginViewDelegate> {
    UITableView *_theTableView;
    UITextField *_payPsdTF;
    UITextField *_confirmPayPsdTF;
}

@end

@implementation SetPayPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置屋托邦平台支付密码";
    _theTableView = [[UITableView alloc]initWithFrame:kTableViewFrame style:UITableViewStyleGrouped];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    [self.view addSubview:_theTableView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    UIButton *nextStepBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextStepBtn.frame = CGRectMake(10, 10, kMainScreenWidth - 20, 40);
    [nextStepBtn addTarget: self action:@selector(clickDoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepBtn setTitle:@"完成" forState:UIControlStateNormal];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PsdManagerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"ic_mm.png"];
    if (indexPath.row == 0) {
        _payPsdTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 2, kMainScreenWidth - 80, 44)];
        _payPsdTF.secureTextEntry = YES;
        _payPsdTF.placeholder = @"请输入屋托邦平台支付密码";
        [cell.contentView addSubview:_payPsdTF];
    } else {
        _confirmPayPsdTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 2, kMainScreenWidth - 80, 44)];
        _confirmPayPsdTF.secureTextEntry = YES;
        _confirmPayPsdTF.placeholder = @"请确认屋托邦平台支付密码";
        [cell.contentView addSubview:_confirmPayPsdTF];
    }
    
    return cell;
}

- (void)clickDoneBtn:(id)sender {
    if ([NSString isEmptyOrWhitespace:_payPsdTF.text]) {
        [TLToast showWithText:@"请输入屋托邦平台支付密码"];
        return;
    } else if (_payPsdTF.text.length < 6 || _payPsdTF.text.length > 16) {
        [TLToast showWithText:@"支付密码由6～20位的英文字母、数字或符号组成"];
        return;
    } else if ([NSString isEmptyOrWhitespace:_confirmPayPsdTF.text]) {
        [TLToast showWithText:@"请确认屋托邦平台支付密码"];
        return;
    } else if (_confirmPayPsdTF.text.length < 6 || _confirmPayPsdTF.text.length > 16) {
        [TLToast showWithText:@"支付密码由6～20位的英文字母、数字或符号组成"];
        return;
    } else if (![_payPsdTF.text isEqualToString:_confirmPayPsdTF.text]) {
        [TLToast showWithText:@"确认密码与支付密码必须一致"];
        return;
    }
    NSString *md5PayPsdStr = [util md5:_payPsdTF.text];
    if ([md5PayPsdStr isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:User_Password]]){
            [TLToast showWithText:@"登录密码与支付密码不能相同"];
            return;
        }
    [_payPsdTF resignFirstResponder];
    [_confirmPayPsdTF resignFirstResponder];
    [self requestSetPayPsd:_payPsdTF.text];
}

#pragma mark - 设置支付密码
-(void)requestSetPayPsd:(NSString *)payPsdStr {
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
        [postDict setObject:@"ID0130" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSString *md5PayPsdStr = [util md5:payPsdStr];
        NSDictionary *bodyDic = @{@"payPassword":md5PayPsdStr};
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
                    
                    if (kResCode == 101301) {
                        [self stopRequest];
                        [TLToast showWithText:@"操作成功"];
                        if ([self.fromStr isEqualToString:@"contract"]) {
                            UIViewController *backcontroller =[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-4];
                            [self.navigationController popToViewController:backcontroller animated:YES];
                            return;
                        }
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } else if (kResCode == 101302) {
                        [self stopRequest];
                        [TLToast showWithText:@"屋托邦平台支付密码不符合要求"];
                    } else if (kResCode == 101309) {
                        [TLToast showWithText:@"操作异常"];
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
