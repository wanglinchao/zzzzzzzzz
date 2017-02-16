//
//  MyOrderDetailViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-21.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "util.h"
#import "UIButton+WebCache.h"
#import "AutomaticLogin.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "TLToast.h"
#import "OrderDetailModel.h"
#import "OrderPhaseModel.h"
#import "PayingConfirmViewController.h"
#import "IDIAIAppDelegate.h"
#import "MyOrderDetailConfirmViewController.h"
#import "InputPayPsdViewController.h"
#import "RefundViewController.h"
#import "AfterSaleViewController.h"
#import "CommentViewForGJS.h"
#import "IDIAIAppDelegate.h"
#import "savelogObj.h"

@interface MyOrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, CommentsViewDelegate, LoginViewDelegate> {
    UITableView *_theTableView;
    OrderDetailModel *_orderDetailModel;
    
    CommentViewForGJS *comment;
    CGFloat _height;//第一部分cell高度
    
//    NSString *_callNum;
}

@property (nonatomic,strong) UIButton *btn_phone;

@end

@implementation MyOrderDetailViewController

@synthesize myOrderModel = _myOrderModel;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNCUpdateOrderStatus object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    [self customizeNavigationBar];
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:NO animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
//        self.navigationController.navigationBar.translucent = NO;
    
    //导航右按钮
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 90, 40)];
    [rightButton setImage:[UIImage imageNamed:@"btn_dianhua"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 25, 0, -5);
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setFrame:CGRectMake(5, 5, 40, 40)];
//    [rightButton setImage:[UIImage imageNamed:@"ico_kefu"] forState:UIControlStateNormal];
//    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [rightButton addTarget:self
//                    action:@selector(PressBarItemRight:)
//          forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderStatus:) name:kNCUpdateOrderStatus object:nil];
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_theTableView];
    
    _height = 330;
    [self requestOrderDetail];
    
//    [self requestCallNum];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (_orderDetailModel.orderState == 3 || _orderDetailModel.orderState == 15)_height = 270;
        else _height = 330;
        
        return _height;
    } else {
        return 200;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"MyOrderDetailCell";
    static NSString *CellIdentifier2 = @"MyOrderDetailCell2";
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderDetailCell" owner:self options:nil]lastObject];
        }
        
        UILabel *businessNameLabel = (UILabel *)[cell viewWithTag:101];
        businessNameLabel.text = _orderDetailModel.servantName;
        
        UILabel *orderStateNameLabel = (UILabel *)[cell viewWithTag:102];
        orderStateNameLabel.text = _orderDetailModel.orderStateName;
        
        UILabel *orderNumLabel = (UILabel *)[cell viewWithTag:103];
        orderNumLabel.text = _orderDetailModel.orderCode;
        UILabel *orderDateLabel = (UILabel *)[cell viewWithTag:104];
        orderDateLabel.text = _orderDetailModel.createTime;
        
        UILabel *orderTypeLabel = (UILabel *)[cell viewWithTag:105];
        NSString *orderTypeStr;
        if (_orderDetailModel.orderType == 1) {
            orderTypeStr = @"设计服务";
        } else if (_orderDetailModel.orderType == 4) {
            orderTypeStr = @"施工服务";
        } else if (_orderDetailModel.orderType == 6) {
            orderTypeStr = @"监理服务";
        }
        orderTypeLabel.text = orderTypeStr;
        
        UILabel *communityNameLabel = (UILabel *)[cell viewWithTag:106];
        communityNameLabel.text = _orderDetailModel.userCommunityName;
        
        UILabel *orderTaskLabel = (UILabel *)[cell viewWithTag:107];
        orderTaskLabel.text = _orderDetailModel.nowPhaseName;
        
        UILabel *orderMoney = (UILabel *)[cell viewWithTag:108];
        if (_myOrderModel.orderState == 3 || _myOrderModel.orderState == 15 || _myOrderModel.orderState == 17)
            orderMoney.text = [NSString stringWithFormat:@"￥%.2f",self.myOrderModel.orderTotalFee/100];
        else
            orderMoney.text = [NSString stringWithFormat:@"￥%.2f",_orderDetailModel.nowPhaseFee/100];
        
        UIButton *orderContractBtn = (UIButton *)[cell viewWithTag:109];
        [orderContractBtn addTarget:self action:@selector(checkContract:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *firstBtn = (UIButton *)[cell viewWithTag:110];
        firstBtn.layer.masksToBounds = YES;
        firstBtn.layer.cornerRadius = 3;
        firstBtn.hidden = YES;
       
        //配置按钮一
        if (_myOrderModel.orderState == 1) {
            firstBtn.hidden = NO;
            [firstBtn setTitle:@"确认订单" forState:UIControlStateNormal];
            [firstBtn addTarget:self action:@selector(requestConfirmOrderOrConfirmPaying:) forControlEvents:UIControlEventTouchUpInside];
        } else if (_myOrderModel.orderState == 2 || _myOrderModel.orderState == 3 || _myOrderModel.orderState == 4 || _myOrderModel.orderState == 6|| _myOrderModel.orderState == 8 || _myOrderModel.orderState == 9 || _myOrderModel.orderState == 14 || _myOrderModel.orderState == 16 || _myOrderModel.orderState == 23) {
            firstBtn.hidden = YES;
        } else if (_myOrderModel.orderState == 7) {
            firstBtn.hidden = NO;
            [firstBtn setTitle:@"确认付款" forState:UIControlStateNormal];
            [firstBtn addTarget:self action:@selector(requestConfirmOrderOrConfirmPaying:) forControlEvents:UIControlEventTouchUpInside];
        } else if (_myOrderModel.orderState == 12) {
            firstBtn.hidden = YES;
//            _height = 280;
        } else if (_myOrderModel.orderState == 17) {
            firstBtn.hidden = NO;
            [firstBtn setTitle:@"评论" forState:UIControlStateNormal];
            [firstBtn addTarget:self action:@selector(myappraise) forControlEvents:UIControlEventTouchUpInside];
        }

        
        UIButton *secondBtn = (UIButton *)[cell viewWithTag:111];
        secondBtn.layer.masksToBounds = YES;
        secondBtn.layer.cornerRadius = 3;
        secondBtn.layer.borderColor = kThemeColor.CGColor;
        secondBtn.layer.borderWidth = 1;
        secondBtn.hidden = YES;
        
        //配置按钮二
        if (_myOrderModel.orderState == 1) {
            secondBtn.hidden = NO;
            [secondBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [secondBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        } else if (_myOrderModel.orderState == 2) {
            secondBtn.hidden = NO;
            [secondBtn setTitle:@"立即托管" forState:UIControlStateNormal];
            [secondBtn addTarget:self action:@selector(gotoPayingConfirmPage:) forControlEvents:UIControlEventTouchUpInside];
        } else if (_myOrderModel.orderState == 4 || _myOrderModel.orderState == 6 || _myOrderModel.orderState == 9 || _myOrderModel.orderState == 16) {
            secondBtn.hidden = NO;
            [secondBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            [secondBtn addTarget:self action:@selector(gotoRefundVC:) forControlEvents:UIControlEventTouchUpInside];
        } else if (_myOrderModel.orderState == 7) {
            secondBtn.hidden = NO;
            [secondBtn setTitle:@"拒绝付款" forState:UIControlStateNormal];
            [secondBtn addTarget:self action:@selector(requestRefusePaying:) forControlEvents:UIControlEventTouchUpInside];
        } else if (_myOrderModel.orderState == 3 || _myOrderModel.orderState == 8 || _myOrderModel.orderState == 23) {
            secondBtn.hidden = YES;
        } else if (_myOrderModel.orderState == 12 || _myOrderModel.orderState == 14) {
            secondBtn.hidden = NO;
            [secondBtn setTitle:@"取消退款" forState:UIControlStateNormal];
            [secondBtn addTarget:self action:@selector(requestCancelRefund:) forControlEvents:UIControlEventTouchUpInside];
        } else if (_myOrderModel.orderState == 17) {
            secondBtn.hidden = NO;
            [secondBtn setTitle:@"申请售后" forState:UIControlStateNormal];
            [secondBtn addTarget:self action:@selector(gotoAfterSaleVC:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIButton *thirdBtn = (UIButton *)[cell viewWithTag:112];
        thirdBtn.layer.masksToBounds = YES;
        thirdBtn.layer.cornerRadius = 3;
        thirdBtn.layer.borderColor = kThemeColor.CGColor;
        thirdBtn.layer.borderWidth = 1;
        thirdBtn.hidden = YES;
        
        //配置按钮三
        if (_myOrderModel.orderState == 7) {
            thirdBtn.hidden = NO;
            [thirdBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            [thirdBtn addTarget:self action:@selector(gotoRefundVC:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderDetailCell2" owner:self options:nil]lastObject];
        }
        
            if (_orderDetailModel.orderPhase.count == 4) {
                
                OrderPhaseModel *orderPhaseModel1 = [_orderDetailModel.orderPhase objectAtIndex:0];
                
                UIImageView *stepOneIV = (UIImageView *)[cell viewWithTag:1001];
                UILabel *stepOneNameLabel = (UILabel *)[cell viewWithTag:1002];
                UILabel *stepOneMoneyLabel = (UILabel *)[cell viewWithTag:1003];
                if (orderPhaseModel1.state == 0) {
                    stepOneIV.image = [UIImage imageNamed:@"ic_one_no.png"];
                } else if (orderPhaseModel1.state == 1) {
                    stepOneIV.image = [UIImage imageNamed:@"ic_one_ing.png"];
                } else if (orderPhaseModel1.state == 2) {
                    stepOneIV.image = [UIImage imageNamed:@"ic_one_end.png"];
                }
                stepOneNameLabel.text = orderPhaseModel1.phraseName;
                stepOneMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",orderPhaseModel1.phraseFee/100];

                
                OrderPhaseModel *orderPhaseModel2 = [_orderDetailModel.orderPhase objectAtIndex:1];
                UIImageView *stepTwoIV = (UIImageView *)[cell viewWithTag:1004];
                UILabel *stepTwoNameLabel = (UILabel *)[cell viewWithTag:1005];
                UILabel *stepTwoMoneyLabel = (UILabel *)[cell viewWithTag:1006];
                if (orderPhaseModel2.state == 0) {
                    stepTwoIV.image = [UIImage imageNamed:@"ic_two_no.png"];
                } else if (orderPhaseModel2.state == 1) {
                    stepTwoIV.image = [UIImage imageNamed:@"ic_two_ing.png"];
                } else if (orderPhaseModel2.state == 2) {
                    stepTwoIV.image = [UIImage imageNamed:@"ic_two_end.png"];
                }
                stepTwoNameLabel.text = orderPhaseModel2.phraseName;
                stepTwoMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",orderPhaseModel2.phraseFee/100];
                
                OrderPhaseModel *orderPhaseModel3 = [_orderDetailModel.orderPhase objectAtIndex:2];
                
                UIImageView *stepThreeIV = (UIImageView *)[cell viewWithTag:1007];
                UILabel *stepThreeNameLabel = (UILabel *)[cell viewWithTag:1008];
                UILabel *stepThreeMoneyLabel = (UILabel *)[cell viewWithTag:1009];
                
                if (orderPhaseModel3.state == 0) {
                    stepThreeIV.image = [UIImage imageNamed:@"ic_san_no.png"];
                } else if (orderPhaseModel3.state == 1) {
                    stepThreeIV.image = [UIImage imageNamed:@"ic_san_ing.png"];
                } else if (orderPhaseModel3.state == 2) {
                    stepThreeIV.image = [UIImage imageNamed:@"ic_san_end.png"];
                }
                stepThreeNameLabel.text = orderPhaseModel3.phraseName;
                stepThreeMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",orderPhaseModel3.phraseFee/100];
                
                OrderPhaseModel *orderPhaseModel4 = [_orderDetailModel.orderPhase objectAtIndex:3];
                
                UIImageView *stepFourIV = (UIImageView *)[cell viewWithTag:1010];
                UILabel *stepFourNameLabel = (UILabel *)[cell viewWithTag:1011];
                UILabel *stepFourMoneyLabel = (UILabel *)[cell viewWithTag:1012];
                
                if (orderPhaseModel4.state == 0) {
                    stepFourIV.image = [UIImage imageNamed:@"ic_four_no.png"];
                } else if (orderPhaseModel4.state == 1) {
                    stepFourIV.image = [UIImage imageNamed:@"ic_four_ing.png"];
                } else if (orderPhaseModel4.state == 2) {
                    stepFourIV.image = [UIImage imageNamed:@"ic_four_end.png"];
                }
                stepFourNameLabel.text = orderPhaseModel4.phraseName;
                stepFourMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",orderPhaseModel4.phraseFee/100];
                

            } else if (_orderDetailModel.orderPhase.count == 2) {
                
                OrderPhaseModel *orderPhaseModel1 = [_orderDetailModel.orderPhase objectAtIndex:0];
                
                UIImageView *stepOneIV = (UIImageView *)[cell viewWithTag:1001];
                UILabel *stepOneNameLabel = (UILabel *)[cell viewWithTag:1002];
                UILabel *stepOneMoneyLabel = (UILabel *)[cell viewWithTag:1003];
                if (orderPhaseModel1.state == 0) {
                    stepOneIV.image = [UIImage imageNamed:@"ic_one_no.png"];
                } else if (orderPhaseModel1.state == 1) {
                    stepOneIV.image = [UIImage imageNamed:@"ic_one_ing.png"];
                } else if (orderPhaseModel1.state == 2) {
                    stepOneIV.image = [UIImage imageNamed:@"ic_one_end.png"];
                }
                stepOneNameLabel.text = orderPhaseModel1.phraseName;
                stepOneMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",orderPhaseModel1.phraseFee/100];
                
                
                OrderPhaseModel *orderPhaseModel2 = [_orderDetailModel.orderPhase objectAtIndex:1];
                UIImageView *stepTwoIV = (UIImageView *)[cell viewWithTag:1004];
                UILabel *stepTwoNameLabel = (UILabel *)[cell viewWithTag:1005];
                UILabel *stepTwoMoneyLabel = (UILabel *)[cell viewWithTag:1006];
                if (orderPhaseModel2.state == 0) {
                    stepTwoIV.image = [UIImage imageNamed:@"ic_two_no.png"];
                } else if (orderPhaseModel2.state == 1) {
                    stepTwoIV.image = [UIImage imageNamed:@"ic_two_ing.png"];
                } else if (orderPhaseModel2.state == 2) {
                    stepTwoIV.image = [UIImage imageNamed:@"ic_two_end.png"];
                }
                stepTwoNameLabel.text = orderPhaseModel2.phraseName;
                stepTwoMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",orderPhaseModel2.phraseFee/100];
                
                UIImageView *stepThreeIV = (UIImageView *)[cell viewWithTag:1007];
                UILabel *stepThreeNameLabel = (UILabel *)[cell viewWithTag:1008];
                UILabel *stepThreeMoneyLabel = (UILabel *)[cell viewWithTag:1009];
                
                UIImageView *stepFourIV = (UIImageView *)[cell viewWithTag:1010];
                UILabel *stepFourNameLabel = (UILabel *)[cell viewWithTag:1011];
                UILabel *stepFourMoneyLabel = (UILabel *)[cell viewWithTag:1012];
                
                UIView *lineView2 = (UIView *)[cell viewWithTag:1014];
                UIView *lineView3 = (UIView *)[cell viewWithTag:1015];
                
                stepThreeIV.hidden = YES;
                stepThreeNameLabel.hidden = YES;
                stepThreeMoneyLabel.hidden = YES;
                stepFourIV.hidden = YES;
                stepFourNameLabel.hidden = YES;
                stepFourMoneyLabel.hidden = YES;
                
                lineView2.hidden = YES;
                lineView3.hidden = YES;
            }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

//请求订单详情
-(void)requestOrderDetail{
    [self startRequestWithString:@"加载中..."];
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0111\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"orderCode\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.orderIDStr];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"发送收藏量返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                if (kResCode == 10002 || kResCode == 10003) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    });
                }
                else if (code==101111) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _orderDetailModel = [OrderDetailModel objectWithKeyValues:jsonDict];
                        [_theTableView reloadData];
                    });
                } else if (code == 101112) {
                    [self stopRequest];
                    [TLToast showWithText:@"查询无此订单"];
                }
                else if (code == 101119){
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [TLToast showWithText:@"数据加载失败"];
                    });
                }
            });
        }
                          failedBlock:^{
                              [self stopRequest];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:nil];
    });
    
}

#pragma mark - 查看合同
- (void)checkContract:(id)sender {
    MyOrderDetailConfirmViewController *myOrderDetailConfirmVC = [[MyOrderDetailConfirmViewController alloc]init];
    myOrderDetailConfirmVC.orderIDStr = self.orderIDStr;
    [self.navigationController pushViewController:myOrderDetailConfirmVC animated:YES];
}

#pragma mark - 确认、拒绝订单与确定付款
-(void)requestConfirmOrderOrConfirmPaying:(UIButton *)sender {
    
    NSString *actionTypeStr;
    if (_orderDetailModel.orderState == 1) {
        actionTypeStr = @"2";
    } else {
        actionTypeStr = @"";
    }
    
    NSString *secretKeyStr;
    
    if (_myOrderModel.orderState == 7) {
        [savelogObj saveLog:@"确认付款" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:62];
        
        InputPayPsdViewController *inputPayPsdVC = [[InputPayPsdViewController alloc]init];
        inputPayPsdVC.myOrderModel = _myOrderModel;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        inputPayPsdVC.sourceVC = @"detailVC";
        [delegate.nav pushViewController:inputPayPsdVC animated:YES];
        return;
        
    } else if (_myOrderModel.orderState == 8) {
        
    } else {
        secretKeyStr = @"";
    }
    
    //确认订单（合同）记日志
    if(_orderDetailModel.orderState == 1) [savelogObj saveLog:@"确认订单（合同）" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:59];
    
    
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
        NSDictionary *bodyDic = @{@"orderCode":_myOrderModel.orderCode,@"actionType":actionTypeStr,@"secretKey":secretKeyStr};
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
                    if (kResCode == 10002 || kResCode == 10003) {
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 11301) {
                        [self requestOrderDetail];
                        [TLToast showWithText:@"确认成功"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNCUpdateOrderStatus object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else if (kResCode == 11302) {
                        [TLToast showWithText:@"确认失败"];
                    } else if (kResCode == 11303) {
                        [TLToast showWithText:@"请输入或设置支付密码"];
                    }else if (kResCode == 11305) {
                        [TLToast showWithText:@"支付密码不正确"];
                    }else{
                        [TLToast showWithText:@"订单确认失败"];
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

- (void)gotoPayingConfirmPage:(id)sender {
    
    [savelogObj saveLog:@"立即托管" userID:[NSString stringWithFormat:@"%ld ",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:61];
    
    PayingConfirmViewController *payingConfirmVC = [[PayingConfirmViewController alloc]init];
    payingConfirmVC.serviceNameStr = _myOrderModel.orderPhraseName;
    payingConfirmVC.moneyFloat = _myOrderModel.orderPhraseFee;
    payingConfirmVC.orderNo = _myOrderModel.orderCodePhase;
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.nav pushViewController:payingConfirmVC animated:YES];
}

- (void)gotoRefundVC:(id)sender {
    RefundViewController *refundVC = [[RefundViewController alloc]initWithNibName:@"RefundViewController" bundle:nil];
    refundVC.orderIDStr = _myOrderModel.orderCode;
    refundVC.moneyFloat = _myOrderModel.orderPhraseFee;
    refundVC.sourceVCStr = @"detailVC";
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav pushViewController:refundVC animated:YES];
}

- (void)updateOrderStatus:(NSNotification *)notification {
    [self requestOrderDetail];
}

#pragma mark 申请售后
- (void)gotoAfterSaleVC:(id)sender {
    AfterSaleViewController *afterSaleVC = [[AfterSaleViewController alloc]initWithNibName:@"AfterSaleViewController" bundle:nil];
    afterSaleVC.orderIDStr = _myOrderModel.orderCode;
    afterSaleVC.serviceProviderIdStr = _myOrderModel.servantId;
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.nav pushViewController:afterSaleVC animated:YES];
}

-(void)myappraise{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]){
        NSArray *arr_;
        if(_orderDetailModel.orderType==1) arr_=@[@"服务态度",@"设计水平",@"沟通能力"];
        else if(_orderDetailModel.orderType==4) arr_=@[@"服务态度",@"施工质量",@"进度控制"];
        else if(_orderDetailModel.orderType==6) arr_=@[@"服务态度",@"专业技能",@"沟通能力"];
        comment=[[CommentViewForGJS alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245) title:arr_];
        comment.delegate=self;
        [UIView animateWithDuration:.25 animations:^{
            comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245);
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
        [comment show];
    }
    else{

        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
    
}

#pragma mark -
#pragma mark - KeyBord
- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat kbSize = rect.size.height;
    NSLog(@"will---键盘高度：%f",kbSize);
    
    [UIView animateWithDuration:duration animations:^{
        comment.frame=CGRectMake(0, kMainScreenHeight-245-kbSize, kMainScreenWidth, 245);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245);
    } completion:^(BOOL finished) {
        if (finished) {
            [comment dismiss];
        }
    }];
    
}

#pragma mark -
#pragma mark - comments

-(void)didFinishedComments:(NSString *)comment_title star:(NSArray *)star_arr{
    
    [UIView animateWithDuration:.35 animations:^{
        comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245);
    } completion:^(BOOL finished) {
        if (finished) {
            [comment dismiss];
        }
    }];

    [self requestEvaluationOfStar:comment_title star:star_arr];
}

//评价
-(void)requestEvaluationOfStar:(NSString *)title star:(NSArray *)star_arr{
    [self startRequestWithString:@"评价中..."];
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
        
        NSMutableDictionary *postDict01 = [[NSMutableDictionary alloc] init];
        [postDict01 setObject:@"ID0004" forKey:@"cmdID"];
        [postDict01 setObject:string_token forKey:@"token"];
        [postDict01 setObject:string_userid forKey:@"userID"];
        [postDict01 setObject:@"ios" forKey:@"deviceType"];
        [postDict01 setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
        NSString *string01=[postDict01 JSONString];
        
        NSString *orderTypeStr = [NSString stringWithFormat:@"%ld",(long)_myOrderModel.orderType];
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:[NSString stringWithFormat:@"%@",_myOrderModel.servantId] forKey:@"objectId"];
        [postDict02 setObject:title forKey:@"objectString"];
        [postDict02 setObject:orderTypeStr forKey:@"objectTypeId"];
        NSInteger firstStar=[star_arr[0] integerValue];
        if(firstStar%2==0)
            [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)firstStar/2] forKey:@"objectLevel"];
        else
            [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",firstStar/2+0.5] forKey:@"objectLevel"];
        NSInteger secondStar=[star_arr[1] integerValue];
        if(secondStar%2==0)
            [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)secondStar/2] forKey:@"professionalLevel"];
        else
            [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",secondStar/2+0.5] forKey:@"professionalLevel"];
        NSInteger thirdStar=[star_arr[2] integerValue];
        if(thirdStar%2==0)
            [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)thirdStar/2] forKey:@"customerServiceLevel"];
        else
            [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",thirdStar/2+0.5] forKey:@"customerServiceLevel"];
        NSString *string02=[postDict02 JSONString];
        
        NSMutableDictionary *req_dict= [[NSMutableDictionary alloc] init];
        [req_dict setObject:string01 forKey:@"header"];
        [req_dict setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"评星：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (code==10041) {
                        [self stopRequest];
                        [comment dismiss];
                        [TLToast showWithText:@"评价成功，感谢您的支持" bottomOffset:220.0f duration:1.0];
                    }
                    else if (code==10042){
                        [self stopRequest];
                        [TLToast showWithText:@"亲，不符合评价的规则" bottomOffset:220.0f duration:1.0];
                    }
                    else if (code==10043){
                        [self stopRequest];
                        [TLToast showWithText:@"亲，评价的内容过长" bottomOffset:220.0f duration:1.0];
                    }
                    else if (code==10049){
                        [self stopRequest];
                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                    }
                    else{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                    }
                });
            });
        }
                failedBlock:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                        });
                    }
                        method:url postDict:req_dict];
    });
}



#pragma mark -
#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.view becomeFirstResponder];
//        comment=[[CommentsView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 260)];
//        comment.delegate=self;
//        [UIView animateWithDuration:.25 animations:^{
//            comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 260);
//        } completion:^(BOOL finished) {
//            if (finished) {
//                
//            }
//        }];
//        [comment show];
//    }];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.view becomeFirstResponder];
        NSArray *arr_;
        if(_orderDetailModel.orderType==1) arr_=@[@"服务态度",@"设计水平",@"沟通能力"];
        else if(_orderDetailModel.orderType==4) arr_=@[@"服务态度",@"施工质量",@"进度控制"];
        else if(_orderDetailModel.orderType==6) arr_=@[@"服务态度",@"专业技能",@"沟通能力"];
        comment=[[CommentViewForGJS alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245) title:arr_];
        comment.delegate=self;
        [UIView animateWithDuration:.25 animations:^{
            comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 260);
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
        [comment show];
    }];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 拒绝付款
-(void)requestRefusePaying:(UIButton *)sender {
    [savelogObj saveLog:@"拒绝付款" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:63];
    
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
        [postDict setObject:@"ID0118" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"orderCode":_myOrderModel.orderCode};
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
                    
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 10211) {
                        [self stopRequest];
                        [self requestOrderDetail];
                        [TLToast showWithText:@"拒绝付款成功"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNCUpdateOrderStatus object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else if (kResCode == 10219) {
                        [self stopRequest];
                        [TLToast showWithText:@"拒绝付款失败"];
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

#pragma mark - 取消退款
-(void)requestCancelRefund:(UIButton *)sender {
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
        [postDict setObject:@"ID0143" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"refundId":[NSString stringWithFormat:@"%@",_myOrderModel.refundId]};
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
                    
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 10211) {
                        [self stopRequest];
                        [self requestOrderDetail];
                        [TLToast showWithText:@"取消退款成功"];
                    } else if (kResCode == 10219) {
                        [self stopRequest];
                        [TLToast showWithText:@"取消退款失败"];
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


-(void)createPhone{
    self.btn_phone = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_phone.frame=CGRectMake(kMainScreenWidth-50, kMainScreenHeight-250, 50, 50);
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh_mor.png"] forState:UIControlStateNormal];
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh.png"] forState:UIControlStateHighlighted];
    self.btn_phone.tag=1003;
    [self.btn_phone addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn_phone ];
    
    UIPanGestureRecognizer *pan_search = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragToSearch:)];
    [pan_search setMinimumNumberOfTouches:1];
    [pan_search setMaximumNumberOfTouches:1];
    [self.btn_phone addGestureRecognizer:pan_search];
}

- (void)dragToSearch:(UIPanGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gr locationInView:self.view];
        self.btn_phone.center = point;
        if (gr.state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:0.18 animations:^{
                if (point.x<(kMainScreenWidth/2)) self.btn_phone.frame=CGRectMake(0, point.y-25, 50, 50);
                else self.btn_phone.frame=CGRectMake(kMainScreenWidth-50, point.y-25, 50, 50);
                
                if(point.y<25){
                    if(point.x<50) self.btn_phone.frame=CGRectMake(0, 0, 50, 50);
                    else self.btn_phone.frame=CGRectMake(point.x-50, 0, 50, 50);
                }
            }];
        }
    }
}

- (void)pressbtn:(UIButton *)sender {
    
    [savelogObj saveLog:@"联系客服" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:29];
    
    NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",kServiceTel];//临时打客服电话 待后台添加服务商字段后再修改 huangrun
    UIWebView *callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
    [self.view addSubview:callWebview];
}

#pragma mark - 取消订单
- (void)cancelOrder:(UIButton *)sender {
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"是否取消订单?" message:@"取消订单需与卖家协商，确定取消该订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    
}

- (void)PressBarItemRight:(id)sender {
//    if (_callNum) {
        NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",callNumber];
        UIWebView *callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
        [self.view addSubview:callWebview];
//    } else {
//        [self requestCallNum];
//    }
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
//                //NSLog(@"返回信息：%@",jsonDict);
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

#pragma mark -AlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString *actionTypeStr;
        if (self.orderStateInteger == 1) {
            actionTypeStr = @"3";
        } else {
            actionTypeStr = @"";
        }
        
        NSString *secretKeyStr;
        
        if (self.orderStateInteger == 7) {
            [savelogObj saveLog:@"确认付款" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:62];
            
            InputPayPsdViewController *inputPayPsdVC = [[InputPayPsdViewController alloc]init];
            inputPayPsdVC.myOrderModel = self.myOrderModel;
            inputPayPsdVC.sourceVC = @"detailVC";
            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.nav pushViewController:inputPayPsdVC animated:YES];
            return;
            
        } else if (self.orderStateInteger == 8) {
            
        } else {
            secretKeyStr = @"";
        }
        
        //取消订单（合同）记日志
        if(self.orderStateInteger == 1) [savelogObj saveLog:@"取消订单（合同）" userID:[NSString stringWithFormat:@"%ld ",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:60];
        
        
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
            NSDictionary *bodyDic = @{@"orderCode":self.myOrderModel.orderCode,@"actionType":actionTypeStr,@"secretKey":secretKeyStr};
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
                        if (kResCode == 10002 || kResCode == 10003) {
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [login show];
                            return;
                        }
                        
                        if (kResCode == 11301) {
                            [self requestOrderDetail];
                            [TLToast showWithText:@"订单确认成功"];
                        } else if (kResCode == 11302) {
                            [TLToast showWithText:@"订单确认失败"];
                        } else if (kResCode == 11303) {
                            [TLToast showWithText:@"请输入或设置支付密码"];
                        }else if (kResCode == 11305) {
                            [TLToast showWithText:@"支付密码不正确"];
                        }else{
                            [TLToast showWithText:@"订单确认失败"];
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
}
@end
