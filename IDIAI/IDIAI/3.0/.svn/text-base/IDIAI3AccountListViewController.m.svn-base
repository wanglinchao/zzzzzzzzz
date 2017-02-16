//
//  IDIAI3AccountListViewController.m
//  IDIAI
//
//  Created by Ricky on 15/11/27.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3AccountListViewController.h"
#import "AccountObject.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "KVCObject.h"
#import "DCObjectMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "IDIAI3AccountDetailViewController.h"
#import "LoginView.h"
@interface IDIAI3AccountListViewController ()
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isrefulis;
@end

@implementation IDIAI3AccountListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    [self requestAccountlist];
//    [self.mtableview reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"账户明细";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    self.currentPage=1;
    self.dataArray =[NSMutableArray array];
//    for (int i=0; i<15; i++) {
//        AccountObject *account =[[AccountObject alloc] init];
//        account.expenditureType =@"贷款消费";
//        account.expenditureDate =@"2015.5.6";
//        account.balance =@"10.05";
//        account.money =@"-0.05";
//        account.orderNo =@"x938384938493834";
//        account.remark =@"装修消费";
//        [self.dataArray addObject:account];
//    }
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) pullingDelegate:self];
    self.mtableview.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
    self.mtableview.dataSource=self;
    self.mtableview.delegate=self;
    self.mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [self.mtableview launchRefreshing];
    [self.view addSubview:self.mtableview];
    // Do any additional setup after loading the view.
}
-(void)requestAccountlist{
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
        NSString *url =[NSString string];
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0275\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"mobile\":\"%@\",\"requestRow\":15,\"currentPage\":%ld}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],[[NSUserDefaults standardUserDefaults] objectForKey:User_Mobile],(long)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"账户明细列表返回信息：%@",jsonDict);
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
                if (code==102751) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self stopRequest];
                        if(self.refreshing==YES && [self.dataArray count]) [self.dataArray removeAllObjects];
                        NSArray *arr_=[jsonDict objectForKey:@"accountDetails"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[AccountObject class]];
                                AccountObject *item = [parser parseDictionary:dict];
                                [self.dataArray addObject:item];
                            }
                        }
                        if([self.dataArray count]){

                            [self.mtableview tableViewDidFinishedLoading];
                        }
                        else{
                            [self.mtableview tableViewDidFinishedLoading];
                        }
                        [self.mtableview reloadData];
                        //                        self.isrequst =NO;
                    });
                }
                else if (code==102753) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self stopRequest];
                        [self.mtableview tableViewDidFinishedLoading];
                        if(![self.dataArray count]) {

                        }
                        [self.mtableview reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self stopRequest];
                        [self.mtableview tableViewDidFinishedLoading];
                        if(![self.dataArray count]) {

                        }
                        [self.mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                   [self stopRequest];
                                  [self.mtableview tableViewDidFinishedLoading];
                                  if(![self.dataArray count]) {

                                  }
                                  [self.mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}
- (void)PressBarItemLeft {
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier1 = @"designerDetailCell1";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (!cell1) {
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        UILabel *typelbl =[[UILabel alloc] initWithFrame:CGRectMake(19, 11, (kMainScreenWidth-49)/2, 15)];
        typelbl.textColor =[UIColor colorWithHexString:@"#575757"];
        typelbl.font =[UIFont systemFontOfSize:15];
        typelbl.tag =100;
        [cell1 addSubview:typelbl];
        
        UILabel *datelbl =[[UILabel alloc] initWithFrame:CGRectMake(19+(kMainScreenWidth-49)/2, 14, (kMainScreenWidth-49)/2, 12)];
        datelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
        datelbl.font =[UIFont systemFontOfSize:12];
        datelbl.tag =101;
        datelbl.textAlignment =NSTextAlignmentRight;
        [cell1 addSubview:datelbl];
        
        UILabel *balancelbl =[[UILabel alloc] initWithFrame:CGRectMake(19, typelbl.frame.origin.y+typelbl.frame.size.height+10, (kMainScreenWidth-49)/2, 12)];
        balancelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
        balancelbl.font =[UIFont systemFontOfSize:12];
        balancelbl.tag =102;
        [cell1 addSubview:balancelbl];
        
        UILabel *moneylbl =[[UILabel alloc] initWithFrame:CGRectMake(19+(kMainScreenWidth-49)/2, typelbl.frame.origin.y+typelbl.frame.size.height+7, (kMainScreenWidth-49)/2, 15)];
        moneylbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
        moneylbl.font =[UIFont boldSystemFontOfSize:15];
        moneylbl.tag =103;
        moneylbl.textAlignment =NSTextAlignmentRight;
        [cell1 addSubview:moneylbl];
        
        UIImageView *image =[[UIImageView alloc] initWithFrame:CGRectMake(0, 52, kMainScreenWidth, 1)];
        image.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        [cell1 addSubview:image];
    }
    AccountObject*account =[self.dataArray objectAtIndex:indexPath.row];
    UILabel *typelbl =(UILabel *)[cell1 viewWithTag:100];
    typelbl.text =account.recordType;
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [formatter1 dateFromString:account.expenditureDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *replasestr =[formatter stringFromDate:date];
    UILabel *datelbl =(UILabel *)[cell1 viewWithTag:101];
    datelbl.text =replasestr;
    
    UILabel *balancelbl =(UILabel *)[cell1 viewWithTag:102];
    balancelbl.text =[NSString stringWithFormat:@"余额:  %@",account.balance];
    
    UILabel *moneylbl =(UILabel *)[cell1 viewWithTag:103];
    if ([account.expenditureType integerValue]==1) {
        moneylbl.text =[NSString stringWithFormat:@"+%@",account.money];
    }else{
        moneylbl.text =[NSString stringWithFormat:@"-%@",account.money];
    }
    
    
    cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell1.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IDIAI3AccountDetailViewController *detaile =[[IDIAI3AccountDetailViewController alloc] init];
    detaile.accountObject =[self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detaile animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=1;
        [self requestAccountlist];
    }
    else {
        if(self.totalPages>self.currentPage){
            self.currentPage +=1;
            [self requestAccountlist];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
