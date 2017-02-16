//
//  PointsDetailsContentViewController.m
//  IDIAI
//
//  Created by PM on 16/6/16.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PointsDetailsContentViewController.h"
#import "PointsDetailsTableViewCell.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "TLToast.h"
#import "PointDetailsModel.h"
#import "pointGoodsDetailsViewController.h"
#import "savelogObj.h"
#import "ZLCustomAlertView.h"
#define checkCDKEY_Button_Tag 1000
@interface PointsDetailsContentViewController ()
{
  

}

@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)BOOL isPullUp;
@property(nonatomic,strong)UIView * checkCDKEYView;//查看验证码alertView
@property(nonatomic,strong)UILabel *CDKEYTitleLabel;//验证码标题
@property(nonatomic,strong)UILabel *CDKEYLabel;//验证码label
@property(nonatomic,strong)UIView * maskView;
@end

@implementation PointsDetailsContentViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isRefresh ==YES) {
        [self.mtableview launchRefreshing];
    }
    self.isRefresh =YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"=============%@",self.parentViewController);
//    NSLog(@"=============%@",self.parentViewController.parentViewController);
    [savelogObj saveLog:@"查看积分详情信息" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:67];
    
        self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    //    [delegate.nav setNavigationBarHidden:YES animated:NO];
    
    self.currentPage=1;
    self.type =7;
    
    self.dataArray =[NSMutableArray array];
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-44-64) pullingDelegate:self];
    self.mtableview.backgroundColor=[UIColor clearColor];
    self.mtableview.dataSource=self;
    self.mtableview.delegate=self;
    self.mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.mtableview.tableHeaderView =backView;
    self.isRefresh =YES;
    [self.view addSubview:self.mtableview];
    [self loadImageviewBG];
    [self creatCDKEYViewAndMaskView];//创建自定义查看兑换码view
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//创建自定义查看兑换码view
- (void)creatCDKEYViewAndMaskView{
    
    self.maskView = [[UIView alloc]init];
    self.maskView.bounds = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.maskView.center = CGPointMake(kMainScreenWidth*0.5, kMainScreenHeight*0.5);
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    
    self.parentViewController.view.clipsToBounds = NO;
    self.maskView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewAndCustomAlertViewHide)];
    [self.maskView addGestureRecognizer:tapGesture1];
     self.maskView.hidden = YES;

    
    
    self.checkCDKEYView = [[UIView alloc]initWithFrame:CGRectMake((kMainScreenWidth-260)/2,kMainScreenHeight/2-35,260, 80)];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.checkCDKEYView];

    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewAndCustomAlertViewHide)];
    [self.checkCDKEYView  addGestureRecognizer:tapGesture];
    self.checkCDKEYView.userInteractionEnabled  = YES;
    _checkCDKEYView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    _checkCDKEYView.layer.cornerRadius = 10;
    [_checkCDKEYView clipsToBounds];
    
    self.CDKEYTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_checkCDKEYView.frame), CGRectGetHeight(_checkCDKEYView.frame)/2)];
    [self.checkCDKEYView addSubview:self.CDKEYTitleLabel];
    self.CDKEYTitleLabel.backgroundColor = [UIColor clearColor];
    self.CDKEYTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.CDKEYTitleLabel.text =@"兑换码";
    self.CDKEYTitleLabel.textColor = [UIColor blackColor];
    self.CDKEYTitleLabel.font = [UIFont systemFontOfSize:17 weight:1];
    
    self.CDKEYLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.CDKEYTitleLabel.frame),CGRectGetWidth(_checkCDKEYView.frame), CGRectGetHeight(_checkCDKEYView.frame)/2)];
    [self.checkCDKEYView addSubview:self.CDKEYLabel];
    self.CDKEYLabel.backgroundColor = [UIColor clearColor];
    self.CDKEYLabel.textColor = [UIColor blackColor];
    self.CDKEYLabel.textAlignment = NSTextAlignmentCenter;
    self.CDKEYLabel.font  = [UIFont systemFontOfSize:14];
    self.CDKEYLabel.text =@"";
    
    self.checkCDKEYView.hidden = YES;
    
   

}




-(void)presscheckCDKEYButton:(UIButton*)sender{
    
    
    PointDetailsModel * model = _dataArray[sender.tag -checkCDKEY_Button_Tag];
    self.CDKEYLabel.text = model.cashCode;
 
    [self maskViewAndCustomAlertViewShow];
    
    
}


-(void)maskViewAndCustomAlertViewShow{
   
    self.checkCDKEYView.hidden = NO;
    self.maskView.hidden = NO;
    self.maskView.alpha =0;
    self.checkCDKEYView.alpha = 0 ;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.maskView.alpha = 1;
        self.checkCDKEYView.alpha = 1;
    }];



}

-(void)maskViewAndCustomAlertViewHide{
    
    
    self.maskView.alpha =1;
    self.checkCDKEYView.alpha = 1 ;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.maskView.alpha = 0;
        self.checkCDKEYView.alpha = 0;
    }];

    self.checkCDKEYView.hidden = YES;
    self.maskView.hidden = YES;
}




#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
     return 104;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"MYPOINTGOODSCELL";
    PointsDetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell==nil) {
        cell =[[PointsDetailsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }

    cell.pointDetailsModel = _dataArray[indexPath.row];
    [cell.checkCDKEYBtn addTarget:self action:@selector(presscheckCDKEYButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.checkCDKEYBtn.tag =checkCDKEY_Button_Tag+indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中

//    PointDetailsModel* model = _dataArray[indexPath.row];

//    if (model.pointType==1) {
//        pointGoodsDetailsViewController * pGVC = [[pointGoodsDetailsViewController alloc]init];
//        pGVC.pgId = model.pgId;
//        [self.pointVC.navigationController pushViewController:pGVC animated:YES];
//   
//    }

}




#pragma mark - 请求积分列表


-(void)requestPointDetails{
    if(![util isConnectionAvailable]){
        [TLToast showWithText:@"无网络连接" topOffset:200.0f duration:1.0];
        return;
    }
    
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token;
        NSString *string_userid;
        NSString *string_citycode;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
            string_citycode = [[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        
//        NSString *typeString = [NSString stringWithFormat:@"%ld",(long)self.type];
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cityCode\":\"%@\",\"cmdID\":\"ID0371\",\"userID\":\"%@\",\"token\":\"%@\",\"deviceType\":\"ios\"}&body={\"currentPage\":%ld,\"requestRow\":\"10\",\"type\":%ld}",kDefaultUpdateVersionServerURL,string_citycode,string_userid,string_token,(long)self.currentPage,(long)self.typeInteger];
//        http://192.168.3.36:8081/idas/dispatch/dispatch.action?header={"cityCode":"510100","cmdID":"ID0371","userID":"1","token":"019610fd12f54005bf551e6c27731f5f","deviceType":"anz"}&body={"currentPage":1,"requestRow":10,"type":0}
        NSLog(@"++++++++++++++++!!!!!!!!!!!!!!!%ld",self.currentPage);
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"积分明细返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                //token为空或验证未通过处理 huangrun
                if (kResCode == 10002) {
                    self.view.tag = 1002;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_mtableview tableViewDidFinishedLoading];
                        [self performSelector:@selector(DisPlayLoginView) withObject:nil afterDelay:0.5];
                    });
                }
                else if (code==103711) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *arr_=[jsonDict objectForKey:@"userPointsDetailList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            if(self.refreshing==YES) [_dataArray removeAllObjects];
                            for(NSDictionary *dict in arr_){
                                //                                [dataArray addObject:[DesignerInfoObj objWithDict:dict]];
                                [_dataArray addObject:[PointDetailsModel objectWithKeyValues:dict]];
                            }
                        }
                        if([_dataArray count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [_mtableview tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [_mtableview tableViewDidFinishedLoading];
                        }
                        
                        [_mtableview reloadData];
                        [_mtableview tableViewDidFinishedLoading];
                        
                    });
                }
                else if (code==103719) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_mtableview tableViewDidFinishedLoading];
                        [TLToast showWithText:@"操作失败"];
                        if(![_dataArray count])
                            imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                        [_mtableview reloadData];
                    });
                }
                
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  [_mtableview tableViewDidFinishedLoading];
                                  if(![_dataArray count])
                                      imageview_bg.hidden=NO;
                                  label_bg.hidden = NO;
                                  [_mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}



#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=1;
        [self requestPointDetails];
    }
    else {
        if(self.totalPages>self.currentPage){
            self.currentPage +=1;
            [self requestPointDetails];
        }
        else{
            
            [self.mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            self.mtableview.reachedTheEnd = YES;  //是否加载到底了
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=YES;
    
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
    if(isFirstInt==YES){
        self.refreshing=NO;
        [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
    }
    else {
        [self.mtableview tableViewDidFinishedLoading];
        isFirstInt=!isFirstInt;
    }
}
#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.mtableview.contentOffset.y<-30) {
        self.mtableview.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [self.mtableview tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.mtableview tableViewDidEndDragging:scrollView];
}


-(void)DisPlayLoginView{
    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    login.delegate=self;
    [login show];
    return;
}

@end
