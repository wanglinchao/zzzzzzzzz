//
//  InputPayPsdViewController.m
//  IDIAI
//
//  Created by Ricky on 15-2-2.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "InputPayPsdViewController.h"
#import "NSStringAdditions.h"
#import "TLToast.h"
#import "util.h"
#import "IDIAIAppDelegate.h"
#import "LoginView.h"
#import "InputLoginPsdViewController.h"
#import "CustomPromptView.h"
@interface InputPayPsdViewController () <UITableViewDataSource, UITableViewDelegate, LoginViewDelegate>{
    UITableView *_theTableView;
    UITextField *_payPsdTF;
    CustomPromptView *customPromp;
}

@end

@implementation InputPayPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.title = @"收银台";
    
    if ([self.fromStr isEqualToString:@"orderDetailOfGoodsVC"]) {
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.nav setNavigationBarHidden:NO animated:NO];
    }
    
    _theTableView = [[UITableView alloc]initWithFrame:kTableViewFrame style:UITableViewStylePlain];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    [self.view addSubview:_theTableView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    UIButton *nextStepBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextStepBtn.frame = CGRectMake(10, 10, kMainScreenWidth - 20, 40);
    [nextStepBtn addTarget: self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepBtn setTitle:@"提交" forState:UIControlStateNormal];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier  = @"inputPayPsdCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:101];
        if (nameLabel == nil)
            nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, cell.frame.size.width, cell.frame.size.height)];
        nameLabel.tag = 101;
        nameLabel.text =self.myOrderModel.orderPhraseName;
        
        UILabel *moneyLabel = (UILabel *)[cell viewWithTag:102];
        if (moneyLabel == nil)
            moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, nameLabel.frame.origin.y + nameLabel.frame.size.height, cell.frame.size.width, cell.frame.size.height)];
        moneyLabel.tag = 102;
        moneyLabel.text = [NSString stringWithFormat:@"支付金额:￥%.2f",self.myOrderModel.orderPhraseFee/100];
        moneyLabel.textColor = kThemeColor;
        
        if ([self.sourceVC isEqualToString:@"orderDetailOfGoodsVC"]) {
            moneyLabel.text = [NSString stringWithFormat:@"支付金额:￥%.2f",_detailModel.orderTotalMoney];
            moneyLabel.frame = CGRectMake(10,30,  kMainScreenWidth-20, 30);
        }
        else{
           nameLabel.frame = CGRectMake(10, 20, kMainScreenWidth-20, 20);
           moneyLabel.frame = CGRectMake(10, 50, kMainScreenWidth-20, 20);
        }
        
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:moneyLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 1) {
        _payPsdTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 2, kMainScreenWidth - 20, 44)];
        _payPsdTF.secureTextEntry = YES;
        _payPsdTF.placeholder = @"请输入屋托邦平台支付密码";
        _payPsdTF.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:_payPsdTF];
    } else {
        UIButton *setPayPwdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        setPayPwdBtn.frame = CGRectMake(kMainScreenWidth - 150, 0, 150, 44);
        [setPayPwdBtn setTitle:@"设置屋托邦平台支付密码" forState:UIControlStateNormal];
        [setPayPwdBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        setPayPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [setPayPwdBtn addTarget:self action:@selector(gotoSetPayPwd:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:setPayPwdBtn];
    }
  
    return cell;
}

- (void)clickSubmitBtn:(id)sender {
    if ([NSString isEmptyOrWhitespace:_payPsdTF.text]) {
        [TLToast showWithText:@"请输入屋托邦平台支付密码"];
        return;
    }
    if ([self.sourceVC isEqualToString:@"orderDetailOfGoodsVC"])
        [self requestConfirmDeliveryOfGoods];
    else
        [self requestLeftHandleOrder:nil];
}

#pragma mark - 确定付款
-(void)requestLeftHandleOrder:(UIButton *)sender {
    
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
        [postDict setObject:@"ID0113" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSString *md5PayPsdStr = [util md5:_payPsdTF.text];
        NSDictionary *bodyDic = @{@"orderCode":self.myOrderModel.orderCode?self.myOrderModel.orderCode:self.orderDetailModel.orderCode,@"actionType":@"8",@"secretKey":md5PayPsdStr};
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

//                    11301:操作成功
//                    11302:操作失败
//                    11303:未输入支付密码11304:状态必须为付款中
//                    11305:支付密码输入错误
//                    11306:支付密码未设置
//                    11307:已经连续5次错误
                    
                    
                    if (kResCode == 11301) {
                        [TLToast showWithText:@"确定付款成功"];
                        if ([self.sourceVC isEqualToString:@"detailVC"]) {
                            NSArray * ctrlArray = self.navigationController.viewControllers;
                            [self.navigationController popToViewController:[ctrlArray objectAtIndex:0] animated:YES];
                        } else {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNCUpdateOrderStatus object:nil];
                        
                    } else if (kResCode == 11302) {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"操作失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"操作失败"];
                    } else if (kResCode == 11303) {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"未输入屋托邦平台支付密码";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"未输入屋托邦平台支付密码"];
                    } else if (kResCode == 11304) {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"状态必须为付款中";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"状态必须为付款中"];
                    } else if (kResCode == 11305) {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"支付密码不正确";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"支付密码不正确"];
                    } else if (kResCode == 11306) {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"屋托邦平台支付密码未设置";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"屋托邦平台支付密码未设置"];
                    } else if (kResCode == 11307) {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"已连续5次错误,请24小时后支付或重置屋托邦平台支付密码";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"已连续5次错误,请24小时后支付或重置屋托邦平台支付密码"];
                    } else {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"操作失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"操作失败"];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                  customPromp.contenttxt =@"操作失败";
                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                  [customPromp addGestureRecognizer:tap];
                                  [customPromp show];
//                                  [TLToast showWithText:@"操作失败"];
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

#pragma mark - 确认收货
- (void)requestConfirmDeliveryOfGoods {
    
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
        [postDict setObject:@"ID0206" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSString *md5PayPsdStr = [util md5:_payPsdTF.text];
        NSString *orderIdStr = [NSString stringWithFormat:@"%ld",(long)_detailModel.orderId];
        NSDictionary *bodyDic = @{@"orderId":orderIdStr,@"orderCode":_detailModel.orderCode,@"secretKey":md5PayPsdStr};
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
                        self.view.tag = 1002;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [login show];
                            
                        });
                        
                        return;
                    }
                    
                    if (kResCode == 102061) {
                        [self stopRequest];
                        [TLToast showWithText:@"确认收货成功"];
                        if ([self.fromStr isEqualToString:@"orderDetailOfGoodsVC"]) {
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            NSArray * ctrlArray = self.navigationController.viewControllers;
                            [self.navigationController popToViewController:[ctrlArray objectAtIndex:1] animated:YES];
                        }
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNCUpdateOrderStatus object:nil];
                        
                    } else if (kResCode == 102062) {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"操作失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"未输入屋托邦平台支付密码"];
                    } else if (kResCode == 102063) {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"操作失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"状态必须为付款中"];
                    } else if (kResCode == 102065) {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"屋托邦平台支付密码输入错误";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"屋托邦平台支付密码输入错误"];
                    } else if (kResCode == 102064) {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"操作失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"屋托邦平台支付密码未设置"];
                    } else if (kResCode == 102066) {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"已连续5次错误,请24小时后支付或重置屋托邦平台支付密码";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"已连续5次错误,请24小时后支付或重置屋托邦平台支付密码"];
                    } else  {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"确认收货失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"确认收货失败"];
                    }
                    
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                  customPromp.contenttxt =@"操作失败";
                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                  [customPromp addGestureRecognizer:tap];
                                  [customPromp show];
//                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:post];
    });
}

- (void)gotoSetPayPwd:(UIButton *)btn {
    InputLoginPsdViewController *inputLoginPsdVC = [[InputLoginPsdViewController alloc]init];
    [self.navigationController pushViewController:inputLoginPsdVC animated:YES];
}
-(void)hideAction:(id)sender{
    [customPromp dismiss];
}
@end
