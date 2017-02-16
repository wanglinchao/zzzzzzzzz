//
//  MySubscribeContentViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-15.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MySubscribeContentViewController.h"
#import "SubscribeListModel.h"
#import "MySubscribeDetailViewController.h"
#import "IDIAIAppDelegate.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "AutomaticLogin.h"
#import "TLToast.h"
#import "savelogObj.h"

@interface MySubscribeContentViewController () <MySubscribeDetailDelegate, LoginViewDelegate>
{
   
    SubscribeListModel *_subcribeListModel;
    UIView *_cellBgView;
}

@end


@implementation MySubscribeContentViewController

@synthesize selected_mark;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    //修改navBar字体大小文字颜色
    NSDictionary *attris = @{ NSFontAttributeName:[UIFont systemFontOfSize:19],
                              NSForegroundColorAttributeName:[UIColor blackColor] };
    [[UINavigationBar appearance] setTitleTextAttributes:attris];
    [mtableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //修改navBar字体大小文字颜色
    NSDictionary *attris = @{ NSFontAttributeName:[UIFont systemFontOfSize:19],
                              NSForegroundColorAttributeName:[UIColor blackColor] };
    [[UINavigationBar appearance] setTitleTextAttributes:attris];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    dataArray =[[NSMutableArray alloc]initWithCapacity:0];
    self.currentPage=0;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-40) pullingDelegate:self];
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
    SubscribeListModel *subcribeListModel = [dataArray objectAtIndex:indexPath.row];
    if (subcribeListModel.bookStateId == 18) {
        float mark =0;
        if (subcribeListModel.remarks.length>0) {
            mark =26;
        }
        return 181+mark;
    } else {
        float mark =0;
        if (subcribeListModel.remarks.length>0) {
            mark =26;
        }
        return 181 - 35+mark;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mySubscribeContentCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MySubscribeContentCell" owner:self options:nil]lastObject];
        UILabel *subscribedatelbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width-20, 21)];
        subscribedatelbl.tag =108;
        subscribedatelbl.font =[UIFont systemFontOfSize:17];
        subscribedatelbl.textColor =[UIColor colorWithHexString:@"#575757"];
        [cell.contentView addSubview:subscribedatelbl];
        
        UILabel *remarklbl =[[UILabel alloc] initWithFrame:CGRectMake(30, 12, cell.contentView.frame.size.width-20, 21)];
        remarklbl.tag =107;
        remarklbl.font =[UIFont systemFontOfSize:17];
        remarklbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
        [cell.contentView addSubview:remarklbl];
    }
    
    _subcribeListModel = [dataArray objectAtIndex:indexPath.row];
    
    _cellBgView = [cell viewWithTag:10001];
    
    
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:101];
    nameLabel.text = _subcribeListModel.serviceProviderName;
    UILabel *statusLabel = (UILabel *)[cell viewWithTag:102];
    statusLabel.text = _subcribeListModel.bookState;
    UILabel *communityLabel = (UILabel *)[cell viewWithTag:103];
    communityLabel.text = _subcribeListModel.villageName;
    UILabel *areaLabel = (UILabel *)[cell viewWithTag:104];
    areaLabel.text = [NSString stringWithFormat:@"%ldm²",(long)_subcribeListModel.decorateArea];
    UILabel *roleNameLabel = (UILabel *)[cell viewWithTag:105];
    roleNameLabel.text = _subcribeListModel.servantRoleName;
    UIButton *bookStateBtn = (UIButton *)[cell viewWithTag:106];
    
    UILabel *subscribedatelbl =(UILabel *)[cell viewWithTag:108];
    subscribedatelbl.text =[NSString stringWithFormat:@"预约时间: %@",_subcribeListModel.bookDate];
    subscribedatelbl.frame =CGRectMake(nameLabel.frame.origin.x, areaLabel.frame.size.height+areaLabel.frame.origin.y+20, kMainScreenWidth-(nameLabel.frame.origin.x+20)*2, subscribedatelbl.frame.size.height);
    
    if (_subcribeListModel.remarks.length>0) {
        UILabel *remarklbl =(UILabel *)[cell viewWithTag:107];
        remarklbl.text =[NSString stringWithFormat:@"失败原因: %@",_subcribeListModel.remarks];
        remarklbl.frame =CGRectMake(nameLabel.frame.origin.x, subscribedatelbl.frame.size.height+subscribedatelbl.frame.origin.y+10, kMainScreenWidth-(nameLabel.frame.origin.x+20)*2, remarklbl.frame.size.height);
    }
//    private static final int NEW_STATUS = 18; // 新预约
//    private static final int SUC_STATUS = 19; // 成功
//    private static final int REF_STATUS = 20;// 已拒绝
//    private static final int OUT_STATUS = 21;// 已过期
//    private static final int CAN_STATUS = 22;// 已取消
    if (_subcribeListModel.bookStateId == 18) {
        [bookStateBtn setTitle:@"取消" forState:UIControlStateNormal];
    } else {
        [bookStateBtn removeFromSuperview];
    }
    [bookStateBtn addTarget:self action:@selector(clickBookStateBtn:) forControlEvents:UIControlEventTouchUpInside];
    bookStateBtn.tag = indexPath.row + 1000;
    bookStateBtn.layer.masksToBounds = YES;
    bookStateBtn.layer.cornerRadius = 3;
    bookStateBtn.layer.borderColor = [UIColor colorWithHexString:@"#ef6562" alpha:1.0].CGColor;
    bookStateBtn.layer.borderWidth = 1;
    [bookStateBtn setBackgroundColor:[UIColor whiteColor]];
    [bookStateBtn setTitleColor:[UIColor colorWithHexString:@"ef6562"] forState:UIControlStateNormal];
    [bookStateBtn setTitleColor:[UIColor colorWithHexString:@"ef6562"] forState:UIControlStateHighlighted];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]) {
        MySubscribeDetailViewController *mySubscribeDetailVC = [[MySubscribeDetailViewController alloc]init];
        SubscribeListModel *subcribeListModel = [dataArray objectAtIndex:indexPath.row];
        mySubscribeDetailVC.delegate = self;
        mySubscribeDetailVC.subscribeListModel = subcribeListModel;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.nav pushViewController:mySubscribeDetailVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=0;
        [self requestSubcribelist];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestSubcribelist];
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

#pragma mark - 请求预约列表
-(void)requestSubcribelist{
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
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0106\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"bookType\":\"%@\",\"requestRow\":\"10\",\"currentPage\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],typeString, self.currentPage+1];
       
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"预约列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                //token为空或验证未通过处理 huangrun
                if (kResCode == 10002 || kResCode == 10003) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                         [mtableview tableViewDidFinishedLoading];
                        [self performSelector:@selector(DisPlayLoginView) withObject:nil afterDelay:0.5];
                    });
                }
                else if (code==10601) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[jsonDict objectForKey:@"rendreingsList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            if(self.refreshing==YES) [dataArray removeAllObjects];
                            for(NSDictionary *dict in arr_){
//                                [dataArray addObject:[DesignerInfoObj objWithDict:dict]];
                                [dataArray addObject:[SubscribeListModel objectWithKeyValues:dict]];
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
                else if (code==10609) {
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
                else{
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



- (void)clickBookStateBtn:(UIButton *)btn {
    SubscribeListModel *subscribeListModel = [dataArray objectAtIndex:btn.tag - 1000];
    if (subscribeListModel.bookStateId == 18) {
        //取消
        NSString *bookIDStr = [NSString stringWithFormat:@"%ld",(long)subscribeListModel.id];
        [self requestCancelSubcribe:subscribeListModel];
    }
}

#pragma mark - 取消预约
-(void)requestCancelSubcribe:(SubscribeListModel *)bookIdStr {
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
        [postDict setObject:@"ID0108" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"bookId":[NSString stringWithFormat:@"%d",(int)bookIdStr.id]};
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
                 NSLog(@"login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 10701) {
                        [savelogObj saveLog:@"取消预约" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:56];
                        
                        [self stopRequest];
                        bookIdStr.bookStateId =22;
                        bookIdStr.bookState =@"已取消";
                        [mtableview launchRefreshing];
                        [mtableview reloadData];
                        [TLToast showWithText:@"取消预约成功"];
                    } else if (kResCode == 10709) {
                        [self stopRequest];
                        [TLToast showWithText:@"取消预约失败"];
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

- (void)stateBtnDidClick:(MySubscribeDetailViewController *)mySubscribeDetailVC {
    [mtableview reloadData];
}

#pragma mark -
#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.nav dismissViewControllerAnimated:YES completion:^{
//        [self requestSubcribelist];
//    }];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav dismissViewControllerAnimated:YES completion:^{
        [self requestSubcribelist];
    }];
}

-(void)cancel{
    [mtableview tableViewDidFinishedLoading];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
