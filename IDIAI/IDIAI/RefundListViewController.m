//
//  RefundAndAfterSaleViewController.m
//  IDIAI
//
//  Created by Ricky on 15-2-4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "RefundListViewController.h"
#import "IDIAIAppDelegate.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "AutomaticLogin.h"
#import "TLToast.h"
#import "RefundListModel.h"
#import "MyOrderDetailViewController.h"
#import "MyOrderDetailConfirmViewController.h"
#import "PayingConfirmViewController.h"
#import "RefundListModel.h"
#import "RefundViewController.h"
#import "RefundDetailViewController.h"
#import "savelogObj.h"
#import "RefundCell.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#define IS_iOS8 [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue]
@interface RefundListViewController ()<RefundDetailVCDelegate,LoginViewDelegate,RefundCellDelegate> {
  
    RefundListModel *_refundListModel;
}

@end

@implementation RefundListViewController

@synthesize selected_mark;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    //    [mtableview launchRefreshing];
    //    [mtableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"查看服务退款列表" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:70];
    
    self.navigationController.navigationBar.hidden = YES;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateRefundStatus:) name:kNCUpdateRefundStatus object:nil];
    
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
    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    mtableview.tableHeaderView =backView;
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
    RefundListModel *refund =[dataArray objectAtIndex:indexPath.row];
   if (refund.refundState == 29||refund.refundState==32||refund.refundState ==27) return 220;
   else return 185;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid=[NSString stringWithFormat:@"mycellid_%d_%d_1",(int)indexPath.section,(int)indexPath.row];
    RefundCell *cell = (RefundCell*)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[RefundCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellid];
    }
    cell.refund =[dataArray objectAtIndex:indexPath.row];
    cell.delegate =self;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;

//    if (self.fromStr) {
//        if (cell==nil) {
//
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"RefundOrAfterSaleContentOfGoodsCell" owner:self options:nil]lastObject];
//        }
//        
//        UIImageView *shopHeadIV = (UIImageView *)[cell viewWithTag:101];
//
//        UILabel *shopNameLabel = (UILabel *)[cell viewWithTag:102];
//        
//        UILabel *statusLabel = (UILabel *)[cell viewWithTag:103];
//        
//        UIImageView *goodsHeadIV = (UIImageView *)[cell viewWithTag:104];
//        
//        UILabel *goodsNameLabel = (UILabel *)[cell viewWithTag:105];
//        
//        UILabel *guigeLabel = (UILabel *)[cell viewWithTag:106];
//        
//        UILabel *dealMoneyLabel = (UILabel *)[cell viewWithTag:107];
//        
//        UILabel *refundMoneyLabel = (UILabel *)[cell viewWithTag:108];
//        refundMoneyLabel.hidden = YES;
//        
//        UILabel *timeLabel = (UILabel *)[cell viewWithTag:109];
//        
//    } else {
//    
//    if (cell==nil) {
//        if ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] == 7) {
//            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderContentCellForIos7" owner:self options:nil]lastObject];
//        } else {
//            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderContentCell" owner:self options:nil]lastObject];
//        }
//    }
//    
//    _refundListModel = [dataArray objectAtIndex:indexPath.row];
//    
//    UILabel *nameLabel = (UILabel *)[cell viewWithTag:101];
//    nameLabel.text = _refundListModel.servantName;
//    UILabel *statusLabel = (UILabel *)[cell viewWithTag:102];
//    statusLabel.text = _refundListModel.refundStateView;
//    UILabel *communityLabel = (UILabel *)[cell viewWithTag:103];
//    communityLabel.text = _refundListModel.userCommunityName;
//    
//    UILabel *peroidLabel = (UILabel *)[cell viewWithTag:104];
//    peroidLabel.text = _refundListModel.phaseName;
//    
//    UILabel *moneyLabel = (UILabel *)[cell viewWithTag:105];
//    float wantOrderPhaseFee = _refundListModel.refundFee/100;//数据返回单位为分 转换为元
//    moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",wantOrderPhaseFee];
//    
//    UILabel *orderDateLabel = (UILabel *)[cell viewWithTag:106];
//    orderDateLabel.text = [NSString stringWithFormat:@"创建日期：%@",_refundListModel.createAt];
//    
//    UIButton *firstBtn = (UIButton *)[cell viewWithTag:107];
//    firstBtn.hidden = YES;
//    
//    UIButton *secondBtn = (UIButton *)[cell viewWithTag:108];
//    secondBtn.layer.masksToBounds = YES;
//    secondBtn.layer.cornerRadius = 3;
//    secondBtn.layer.borderColor = kThemeColor.CGColor;
//    secondBtn.layer.borderWidth = 1;
//    
//    [secondBtn addTarget:self action:@selector(gotoRefundVC:) forControlEvents:UIControlEventTouchUpInside];
//    if (_refundListModel.refundState == 27) {
//        secondBtn.hidden=NO;
//        [secondBtn setTitle:@"取消退款" forState:UIControlStateNormal];
//    } else {
//        secondBtn.hidden=YES;
//    }
//        
//    }
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        RefundListModel *refundListModel = [dataArray objectAtIndex:indexPath.row];
        
        RefundDetailViewController *refundDetailVC = [[RefundDetailViewController alloc]init];
        refundDetailVC.refundIDStr = [NSString stringWithFormat:@"%d",refundListModel.refundId];
        refundDetailVC.delegate=self;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.nav pushViewController:refundDetailVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
    
}
#pragma mark -
#pragma mark - RefundCellDelegate
-(void)touchCancle:(RefundListModel *)refund{
    [self requestCancelRefund:[NSString stringWithFormat:@"%d",refund.refundId]];
}
#pragma mark -
#pragma mark - RefundDetailVCDelegate

-(void)stateBtnDidClick:(RefundDetailViewController *)myOrderDetailVC{
    self.refreshing=YES;
    self.currentPage=0;
    [self requestRefundList];
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=0;
        [self requestRefundList];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestRefundList];
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

#pragma mark - 请求退款列表
-(void)requestRefundList{
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
        
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0145\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%d\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"], self.currentPage+1];
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0329\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%d\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"], self.currentPage+1];

        
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
                if (code == 10002 || code == 10003) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading];
                        [self performSelector:@selector(DisPlayLoginView) withObject:nil afterDelay:0.5];
                    });
                }
                else if (code==103291) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[jsonDict objectForKey:@"refunds"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            if(self.refreshing==YES) [dataArray removeAllObjects];
                            for(NSDictionary *dict in arr_){
                                //                                [dataArray addObject:[DesignerInfoObj objWithDict:dict]];
                                [dataArray addObject:[RefundListModel objectWithKeyValues:dict]];
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
                else if (code==103299) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading];
                        [TLToast showWithText:@"查询错误"];
                        if(![dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [mtableview tableViewDidFinishedLoading];
                                  if(![dataArray count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

#pragma mark - 取消退款
-(void)requestCancelRefund:(NSString *)refundID {
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
        
        
        NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
        [headerDict setObject:@"ID0316" forKey:@"cmdID"];
        [headerDict setObject:string_token forKey:@"token"];
        [headerDict setObject:string_userid forKey:@"userID"];
        [headerDict setObject:@"ios" forKey:@"deviceType"];
        [headerDict setObject:kCityCode forKey:@"cityCode"];
        NSString *string=[headerDict JSONString];
        
        NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
        [bodyDict setObject:[NSNumber numberWithInt:[refundID intValue]] forKey:@"refundId"];
        NSString *string02=[bodyDict JSONString];
        
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
                 NSLog(@"取消退款：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 103161) {
                        [self stopRequest];
                        self.refreshing=YES;
                        self.currentPage=0;
                        [mtableview launchRefreshing];
                        [TLToast showWithText:@"取消退款成功"];
                    } else if (kResCode == 103169) {
                        [self stopRequest];
                        [TLToast showWithText:@"取消退款失败"];
                    }
                    else{
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


- (void)updateRefundStatus:(NSNotification *)notification {
    [mtableview launchRefreshing];
    [mtableview reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNCUpdateRefundStatus object:nil];
}

- (void)gotoRefundVC:(UIButton *)sender {
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)sender.superview.superview.superview;
    else
        cell= (UITableViewCell *)sender.superview.superview.superview.superview;
    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
    RefundListModel *refundListModel = [dataArray objectAtIndex:indexPath.row];
    
//    [self requestCancelRefund:refundListModel.refundId];
}

#pragma mark -
#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.nav dismissViewControllerAnimated:YES completion:^{
//        [self requestRefundList];
//    }];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav dismissViewControllerAnimated:YES completion:^{
        [self requestRefundList];
    }];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
