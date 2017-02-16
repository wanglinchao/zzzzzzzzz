//
//  MyOrderContentViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-21.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyOrderContentViewController.h"
#import "IDIAIAppDelegate.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "AutomaticLogin.h"
#import "TLToast.h"
#import "MyOrderModel.h"
#import "MyOrderDetailViewController.h"
#import "MyOrderDetailConfirmViewController.h"
#import "PayingConfirmViewController.h"
#import "RefundViewController.h"
#import "InputPayPsdViewController.h"
#import "AfterSaleViewController.h"
#import "CommentViewForGJS.h"
#import "savelogObj.h"

@interface MyOrderContentViewController () <LoginViewDelegate, CommentsViewDelegate>
{
    UIImageView *imageview_bg;
    UILabel *label_bg;
    MyOrderModel *_myOrderModel;
    CommentViewForGJS *comment;
    
    MyOrderModel *_myOrderModelForEvaluate;
}

@end

@implementation MyOrderContentViewController

@synthesize selected_mark;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [mtableview launchRefreshing];
//    [mtableview reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
   
//    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.nav setNavigationBarHidden:YES animated:NO];
    
    if ([self.fromVcNameStr isEqualToString:@"utopVCStatusBtn"]) {
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav setNavigationBarHidden:NO animated:NO];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"查看全部服务订单" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:67];
    
//    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
//    if ([self.fromVcNameStr isEqualToString:@"utopVC"]) {
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.title = @"我的订单";
//    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateOrderStatus:) name:kNCUpdateOrderStatus object:nil];
    
    dataArray =[[NSMutableArray alloc]initWithCapacity:0];
    self.currentPage=0;
    
    //    if(selected_mark==1) self.mark_string=@"-1";
    //    else if(selected_mark==2) self.mark_string=@"1";
    //    else if(selected_mark==3) self.mark_string=@"2";
    //    else self.mark_string=@"3";
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-40) pullingDelegate:self];
    if ([self.fromVcNameStr isEqualToString:@"utopVC"]) {
        mtableview.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64);
    }
    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [mtableview launchRefreshing];
    [self.view addSubview:mtableview];
    
    [self loadImageviewBG];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     _myOrderModel = [dataArray objectAtIndex:indexPath.row];
    if (_myOrderModel.orderState == 3 || _myOrderModel.orderState == 15) return 160;
    else return 190;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"myOrderContentCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        if ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] == 7) {
             cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderContentCellForIos7" owner:self options:nil]lastObject];
        } else {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderContentCell" owner:self options:nil]lastObject];
        }
    }
    
    _myOrderModel = [dataArray objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:101];
    nameLabel.text = _myOrderModel.servantName;
    UILabel *statusLabel = (UILabel *)[cell viewWithTag:102];
    statusLabel.text = _myOrderModel.stateName;
    UILabel *communityLabel = (UILabel *)[cell viewWithTag:103];
    communityLabel.text = _myOrderModel.userCommunityName;
    
    UILabel *peroidLabel = (UILabel *)[cell viewWithTag:104];
    peroidLabel.text = _myOrderModel.orderPhraseName;
    
    UILabel *moneyLabel = (UILabel *)[cell viewWithTag:105];
    if (_myOrderModel.orderState == 3 || _myOrderModel.orderState == 15 || _myOrderModel.orderState == 17){
        float wantorderTotalFee = _myOrderModel.orderTotalFee/100;//数据返回单位为分 转换为元
        moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",wantorderTotalFee];
    }   //订单已完成显示总金额
    else{
        float wantOrderPhaseFee = _myOrderModel.orderPhraseFee/100;//数据返回单位为分 转换为元
        moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",wantOrderPhaseFee];
    }   //订单进行中显示阶段金额
    
    UILabel *orderDateLabel = (UILabel *)[cell viewWithTag:106];
    orderDateLabel.text = [NSString stringWithFormat:@"订单日期：%@",_myOrderModel.createTime];
    
    UIButton *firstBtn = (UIButton *)[cell viewWithTag:107];
    firstBtn.layer.masksToBounds = YES;
    firstBtn.layer.cornerRadius = 3;
    
    firstBtn.hidden = YES;
    
    //配置按钮左
    if (_myOrderModel.orderState == 1) {
        firstBtn.hidden = NO;
        [firstBtn setTitle:@"确认订单" forState:UIControlStateNormal];
        [firstBtn addTarget:self action:@selector(requestConfirmOrderOrConfirmPaying:) forControlEvents:UIControlEventTouchUpInside];
    } else if (_myOrderModel.orderState == 2 || _myOrderModel.orderState == 3 || _myOrderModel.orderState == 4 || _myOrderModel.orderState == 6 || _myOrderModel.orderState == 8 || _myOrderModel.orderState == 9 || _myOrderModel.orderState == 12 || _myOrderModel.orderState == 14 || _myOrderModel.orderState == 16 || _myOrderModel.orderState == 23) {
    } else if (_myOrderModel.orderState == 7) {
        firstBtn.hidden = NO;
        [firstBtn setTitle:@"确认付款" forState:UIControlStateNormal];
        [firstBtn addTarget:self action:@selector(requestConfirmOrderOrConfirmPaying:) forControlEvents:UIControlEventTouchUpInside];
    } else if (_myOrderModel.orderState == 17) {
        firstBtn.hidden = NO;
        [firstBtn setTitle:@"评论" forState:UIControlStateNormal];
        [firstBtn addTarget:self action:@selector(myappraise:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *secondBtn = (UIButton *)[cell viewWithTag:108];
    secondBtn.layer.masksToBounds = YES;
    secondBtn.layer.cornerRadius = 3;
    secondBtn.layer.borderColor = kThemeColor.CGColor;
    secondBtn.layer.borderWidth = 1;
    
    secondBtn.hidden = YES;
    
    //配置按钮右
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
    
    UIButton *thirdBtn = (UIButton *)[cell viewWithTag:109];
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MyOrderModel *myOrderModel = [dataArray objectAtIndex:indexPath.row];
    if (myOrderModel.orderState == 1) {
        MyOrderDetailConfirmViewController *myOrderDetailConfirmVC = [[MyOrderDetailConfirmViewController alloc]init];
        myOrderDetailConfirmVC.orderIDStr = myOrderModel.orderCode;
    myOrderDetailConfirmVC.orderStateInteger = myOrderModel.orderState;
        myOrderDetailConfirmVC.sourceVC = @"myOrderContentVC";
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.nav pushViewController:myOrderDetailConfirmVC animated:YES];
    } else {
    MyOrderDetailViewController *myOrderDetailVC = [[MyOrderDetailViewController alloc]init];
    myOrderDetailVC.orderIDStr = myOrderModel.orderCode;
        myOrderDetailVC.orderStateInteger = myOrderModel.orderState;
        myOrderDetailVC.myOrderModel = myOrderModel;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.nav pushViewController:myOrderDetailVC animated:YES];
    }
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=0;
        [self requestOrderlist];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestOrderlist];
        }
        else{
            
            [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            mtableview.reachedTheEnd = YES;  //是否加载到底了
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=YES;
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    //NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    //创建一个NSDataFormatter显示刷新时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

//上拉加载  Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (mtableview.contentOffset.y<-60) {
        mtableview.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [mtableview tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [mtableview tableViewDidEndDragging:scrollView];
}

-(void)DisPlayLoginView{
    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    login.delegate=self;
    [login show];
    return;
}

#pragma mark - 请求订单列表
-(void)requestOrderlist{
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
        
        NSString *typeString = [NSString stringWithFormat:@"%ld",(long)self.typeInteger];
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0110\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"orderType\":\"%@\",\"requestRow\":\"10\",\"currentPage\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],typeString, (long)self.currentPage+1];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"订单列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                //token为空或验证未通过处理 huangrun
                if (kResCode == 10002 || kResCode == 10003) {
                    self.view.tag = 1002;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading];
                        [self performSelector:@selector(DisPlayLoginView) withObject:nil afterDelay:0.5];
                    });
                }
                else if (code==101101) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[jsonDict objectForKey:@"orderInfoList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue]; 
                            if(self.refreshing==YES) [dataArray removeAllObjects];
                            for(NSDictionary *dict in arr_){
                                //                                [dataArray addObject:[DesignerInfoObj objWithDict:dict]];
                                [dataArray addObject:[MyOrderModel objectWithKeyValues:dict]];
                            }
                        }
                        if([dataArray count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [mtableview tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [mtableview tableViewDidFinishedLoading];
                        }
                        
                        [mtableview reloadData];
                        
                    });
                }
                else if (code==101102) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading];
                        [TLToast showWithText:@"订单类型错误"];
                        if(![dataArray count])
                            imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                        [mtableview reloadData];
                    });
                }
                else if (code==101109){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading];
                        [TLToast showWithText:@"系统异常"];
                        if(![dataArray count])
                            imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                        [mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [mtableview tableViewDidFinishedLoading];
                                  if(![dataArray count])
                                      imageview_bg.hidden=NO;
                                  label_bg.hidden = NO;
                                  [mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

-(void)loadImageviewBG{
    UIImage *image_failed = [UIImage imageNamed:@"ic_moren"];
    if(!imageview_bg)
        imageview_bg=[[UIImageView alloc] initWithImage:image_failed ];
    imageview_bg.frame=CGRectMake((kMainScreenWidth-image_failed.size.width)/2, (kMainScreenHeight-64-40-image_failed.size.height - 26)/2, image_failed.size.width, image_failed.size.height);
    imageview_bg.tag=111;
    imageview_bg.hidden=YES;
    [self.view addSubview:imageview_bg];
    if (!label_bg)
        label_bg = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview_bg.frame.origin.y + imageview_bg.frame.size.height + 5, kMainScreenWidth, 21)];
    label_bg.textAlignment = NSTextAlignmentCenter;
    label_bg.font = [UIFont systemFontOfSize:13];
    label_bg.textColor = [UIColor lightGrayColor];
    label_bg.hidden = YES;
    label_bg.text = @"亲，没有找到匹配内容哟";
    [self.view addSubview:label_bg];
}

- (void)stateBtnDidClick:(MyOrderContentViewController *)mySubscribeDetailVC {
    [mtableview reloadData];
}


#pragma mark - 确认、拒绝订单与确定付款
-(void)requestConfirmOrderOrConfirmPaying:(UIButton *)sender {
    
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview]superview]superview];
    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
    MyOrderModel *myOrderModel = [dataArray objectAtIndex:indexPath.row];
    
    NSString *actionTypeStr;
    if (myOrderModel.orderState == 1) {
        actionTypeStr = @"2";
    } else {
        actionTypeStr = @"";
    }
    
    NSString *secretKeyStr;
    
    if (myOrderModel.orderState == 7) {
        [savelogObj saveLog:@"确认付款" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:62];
        
        InputPayPsdViewController *inputPayPsdVC = [[InputPayPsdViewController alloc]init];
        inputPayPsdVC.myOrderModel = myOrderModel;
        inputPayPsdVC.fromStr = @"orderDetailOfGoodsVC";
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav pushViewController:inputPayPsdVC animated:YES];
        return;

    } else if (myOrderModel.orderState == 8) {
        
    } else {
         secretKeyStr = @"";
    }
    
    //确认订单（合同）记日志
    if(myOrderModel.orderState == 1) [savelogObj saveLog:@"确认订单（合同）" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:59];
    
    
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
        NSDictionary *bodyDic = @{@"orderCode":myOrderModel.orderCode,@"actionType":actionTypeStr,@"secretKey":secretKeyStr};
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
                        self.view.tag = 1002;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [login show];
                            return;
                        });
                    }
                    
                    if (kResCode == 11301) {
                        [mtableview launchRefreshing];
                        [TLToast showWithText:@"订单确认成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNCUpdateOrderStatus object:nil];
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

- (void)gotoPayingConfirmPage:(id)sender {
    
    [savelogObj saveLog:@"立即托管" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:61];
    
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview]superview]superview];
    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
    MyOrderModel *myOrderModel = [dataArray objectAtIndex:indexPath.row];
    
    PayingConfirmViewController *payingConfirmVC = [[PayingConfirmViewController alloc]init];
    payingConfirmVC.serviceNameStr = myOrderModel.orderPhraseName;
    payingConfirmVC.moneyFloat = myOrderModel.orderPhraseFee;
    payingConfirmVC.orderNo = myOrderModel.orderCodePhase;
    payingConfirmVC.fromStr=@"orderDetailOfGoodsVC";
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.nav pushViewController:payingConfirmVC animated:YES];
}

#pragma mark - 申请退款
- (void)gotoRefundVC:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview]superview]superview];
    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
    MyOrderModel *myOrderModel = [dataArray objectAtIndex:indexPath.row];
    
    RefundViewController *refundVC = [[RefundViewController alloc]initWithNibName:@"RefundViewController" bundle:nil];
    refundVC.orderIDStr = myOrderModel.orderCode;
    refundVC.moneyFloat = myOrderModel.orderPhraseFee;
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.nav pushViewController:refundVC animated:YES];
}

- (void)updateOrderStatus:(NSNotification *)notification {
    [mtableview launchRefreshing];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNCUpdateOrderStatus object:nil];
}

#pragma mark 申请售后
- (void)gotoAfterSaleVC:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview]superview]superview];
    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
    MyOrderModel *myOrderModel = [dataArray objectAtIndex:indexPath.row];
    
    AfterSaleViewController *afterSaleVC = [[AfterSaleViewController alloc]initWithNibName:@"AfterSaleViewController" bundle:nil];
    afterSaleVC.orderIDStr = myOrderModel.orderCode;
    afterSaleVC.serviceProviderIdStr = myOrderModel.servantId;
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.nav pushViewController:afterSaleVC animated:YES];
}

-(void)myappraise:(UIButton *)sender {
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]){
//        [self.view becomeFirstResponder];
        
        UITableViewCell *cell;
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
            cell= (UITableViewCell *)sender.superview.superview.superview;
        else
            cell= (UITableViewCell *)sender.superview.superview.superview.superview;
        
        NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
        _myOrderModelForEvaluate = [dataArray objectAtIndex:indexPath.row];
        NSArray *arr_;
        if(_myOrderModelForEvaluate.orderType==1) arr_=@[@"服务态度",@"设计水平",@"沟通能力"];
        else if(_myOrderModelForEvaluate.orderType==4) arr_=@[@"服务态度",@"施工质量",@"进度控制"];
        else if(_myOrderModelForEvaluate.orderType==6) arr_=@[@"服务态度",@"专业技能",@"沟通能力"];
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
        self.view.tag = 1002;
        dispatch_async(dispatch_get_main_queue(), ^{
            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
            login.delegate=self;
            [login show];
        });
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
        
        
        NSString *orderTypeStr = [NSString stringWithFormat:@"%ld",(long)_myOrderModelForEvaluate.orderType];
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:[NSString stringWithFormat:@"%@",_myOrderModelForEvaluate.servantId] forKey:@"objectId"];
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
                if (code==10041) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [self stopRequest];
                        [comment dismiss];
                        [TLToast showWithText:@"评价成功，感谢您的支持" bottomOffset:220.0f duration:1.0];
                        [mtableview launchRefreshing];
                    });
                }
                else if (code==10042) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，不符合评价的规则" bottomOffset:220.0f duration:1.0];
                    });
                }
                else if (code==10043) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，评价的内容过长" bottomOffset:220.0f duration:1.0];
                        
                    });
                }
                
                else if (code==10049) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                    });
                }
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
//    if (self.view.tag == 1001) {
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
//    } else if (self.view.tag == 1002) {
//        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate.nav dismissViewControllerAnimated:YES completion:^{
//            [self requestOrderlist];
//        }];
//       
//    }
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    if (self.view.tag == 1001) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.view becomeFirstResponder];
            NSArray *arr_;
            if(_myOrderModelForEvaluate.orderType==1) arr_=@[@"服务态度",@"设计水平",@"沟通能力"];
            else if(_myOrderModelForEvaluate.orderType==4) arr_=@[@"服务态度",@"施工质量",@"进度控制"];
            else if(_myOrderModelForEvaluate.orderType==6) arr_=@[@"服务态度",@"专业技能",@"沟通能力"];
            comment=[[CommentViewForGJS alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 260) title:arr_];
            comment.delegate=self;
            [UIView animateWithDuration:.25 animations:^{
                comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 260);
            } completion:^(BOOL finished) {
                if (finished) {
                    
                }
            }];
            [comment show];
        }];
    } else if (self.view.tag == 1002) {
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav dismissViewControllerAnimated:YES completion:^{
            [self requestOrderlist];
        }];
        
    }
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 拒绝付款
-(void)requestRefusePaying:(UIButton *)sender {
    [savelogObj saveLog:@"拒绝付款" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:63];
    
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview]superview]superview];
    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
    MyOrderModel *myOrderModel = [dataArray objectAtIndex:indexPath.row];
    
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
        NSDictionary *bodyDic = @{@"orderCode":[NSString stringWithFormat:@"%@",myOrderModel.orderCode]};
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
                        self.view.tag = 1002;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [login show];
                            
                        });
                        return;
                    }
                    
                    if (kResCode == 10211) {
                        [self stopRequest];
                        [mtableview launchRefreshing];
                        [TLToast showWithText:@"拒绝付款成功"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNCUpdateOrderStatus object:nil];
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
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview]superview]superview];
    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
    MyOrderModel *myOrderModel = [dataArray objectAtIndex:indexPath.row];
    
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
        NSDictionary *bodyDic = @{@"refundId":[NSString stringWithFormat:@"%@",myOrderModel.refundId]};
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
                        self.view.tag = 1002;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [login show];
                            
                        });
                        return;
                    }
                    
                    if (kResCode == 10211) {
                        [self stopRequest];
                        [mtableview launchRefreshing];
                        [TLToast showWithText:@"取消退款成功"];
                    } else if (kResCode == 10219) {
                        [self stopRequest];
                        [TLToast showWithText:@"取消退款失败"];
                    } else {
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

#pragma mark - 取消订单
- (void)cancelOrder:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview]superview]superview];
    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
    MyOrderModel *myOrderModel = [dataArray objectAtIndex:indexPath.row];
    
    NSString *actionTypeStr;
    if (myOrderModel.orderState == 1) {
        actionTypeStr = @"3";
    } else {
        actionTypeStr = @"";
    }
    
    NSString *secretKeyStr;
    
    if (myOrderModel.orderState == 7) {
        [savelogObj saveLog:@"确认付款" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:62];
        
        InputPayPsdViewController *inputPayPsdVC = [[InputPayPsdViewController alloc]init];
        inputPayPsdVC.myOrderModel = myOrderModel;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav pushViewController:inputPayPsdVC animated:YES];
        return;
        
    } else if (myOrderModel.orderState == 8) {
        
    } else {
        secretKeyStr = @"";
    }
    
    //取消订单（合同）记日志
    if(myOrderModel.orderState == 1) [savelogObj saveLog:@"取消订单（合同）" userID:[NSString stringWithFormat:@"%ld ",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:60];
    
    
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
        NSDictionary *bodyDic = @{@"orderCode":[NSString stringWithFormat:@"%@",myOrderModel.orderCode],@"actionType":actionTypeStr,@"secretKey":secretKeyStr};
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
                        self.view.tag = 1002;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [login show];
                            
                        });

                        return;
                    }
                
                    if (kResCode == 11301) {
                        [mtableview launchRefreshing];
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

//#pragma mark -
//#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//-(void)cancel{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

@end