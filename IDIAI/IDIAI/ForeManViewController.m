//
//  ForeManViewController.m
//  IDIAI
//
//  Created by iMac on 14-10-23.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ForeManViewController.h"
#import "HexColor.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "ForemanInfoViewController.h"
#import "ForemanObj.h"
#import "CircleProgressHUD.h"
#import "UIImageView+OnlineImage.h"
#import "UIViewController+TopBarMessage.h"
#import "ForemanListCell.h"
#import "OpenUDID.h"

#define kButton_Tag 100
@interface ForeManViewController ()
{
    CircleProgressHUD *phud;
}

@end

@implementation ForeManViewController
@synthesize foreman_type;

-(void)dealloc{
    [mtableview setDelegate:nil];
    [mtableview setDataSource:nil];
    self.dataArray=nil;
}

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:YES];
    
    UIImageView *nav_bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"导航条.png"]];
    nav_bg.frame=CGRectMake(0, 20, 320, 44);
    nav_bg.userInteractionEnabled=YES;
    [self.view addSubview:nav_bg];
    
    CGRect frame = CGRectMake(100, 29, 120, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    label.text =@"工长问答";
    [self.view addSubview:label];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(10, 25, 50, 28)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回键.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(backTouched:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:statusBarView];
}

-(void)backTouched:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [phud hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
    [self customizeNavigationBar];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.dataArray=[NSMutableArray arrayWithCapacity:0];
    self.currentPage=0;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) pullingDelegate:self];
    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    [mtableview setHeaderOnly:YES];          //只有下拉刷新
    //    [mtableview setFooterOnly:YES];          //只有上拉加载
    [self.view addSubview:mtableview];
    [mtableview launchRefreshing];
    
    //展现提示语
    NSDictionary *topBarConfig = @{kDXTopBarBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8], kDXTopBarTextColor : [UIColor blackColor], kDXTopBarIcon : [UIImage imageNamed:@"圈圈.png"], kDXTopBarTextFont : [UIFont boldSystemFontOfSize:15.0]};
    NSString *message_notice=@"亲，您在装修中遇到的任何疑问或困难，都可以直接向屋托邦中的资深工长寻求帮助。";
    [self showTopMessage:message_notice topBarConfig:topBarConfig dismissDelay:2.0 withTapBlock:^{
    }];
}

-(void)createProgressView{
    if(!phud)
        phud=[[CircleProgressHUD alloc]initWithFrame:CGRectMake(100, 180, 120, 120) title:nil];
    [phud show];
}

//发送记录呼叫电话信息
-(void)requestRecordCallinfo:(ForemanObj *)obj{
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
        [postDict01 setObject:@"ID0032" forKey:@"cmdID"];
        [postDict01 setObject:string_token forKey:@"token"];
        [postDict01 setObject:string_userid forKey:@"userID"];
        [postDict01 setObject:@"ios" forKey:@"deviceType"];
        NSString *string01=[postDict01 JSONString];
        
        //获取日期时间
        NSDate *senddate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *locationDate=[dateformatter stringFromDate:senddate];
        //获取主叫号码
        NSString *str_calling;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Mobile] length]>2) str_calling=[[NSUserDefaults standardUserDefaults]objectForKey:User_Mobile];
        else str_calling=@"";
        //获取主叫号码编号
        NSString *str_calling_id;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]) str_calling_id=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        else str_calling_id=@"";
        //获取被叫号码
        NSString *str_called;
        if([obj.foremanMobile length]>2) str_called=obj.foremanMobile;
        else str_called=@"";
        //获取被叫号码编号
        NSString *str_called_id;
        if(obj.foremanId >=0) str_called_id=[NSString stringWithFormat:@"%d",obj.foremanId];
        else str_called_id=@"";
        //获取设备编号
        NSString *str_uuid=[OpenUDID value];
        
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:str_called forKey:@"calledPhone"];
        [postDict02 setObject:str_called_id forKey:@"calledId"];
        [postDict02 setObject:str_uuid forKey:@"mobileUUID"];
        [postDict02 setObject:str_calling_id forKey:@"callingId"];
        [postDict02 setObject:str_calling forKey:@"callingPhone"];
        [postDict02 setObject:locationDate forKey:@"callingDate"];
        [postDict02 setObject:@"4" forKey:@"calledIdenttityType"];
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
              //  NSLog(@"电话记录：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10321) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
                else if (code==10329) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                              });
                          }
                               method:url postDict:req_dict];
    });
    
    
}

-(void)requestforemanTypelist{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0035\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%d\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,self.currentPage+1];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"message返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10351) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *arr_=[jsonDict objectForKey:@"foremanList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            if(self.refreshing==YES) [self.dataArray removeAllObjects];
                            for(NSDictionary *dict in arr_){
                                [self.dataArray addObject:[ForemanObj objWithDict:dict]];
                            }
                        }
                        [mtableview reloadData];

                        [mtableview tableViewDidFinishedLoading];
                        [phud hide];
                    });
                }
                else if (code==10359) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mtableview tableViewDidFinishedLoading];
                        [phud hide];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [mtableview tableViewDidFinishedLoading];
                        [phud hide];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                 [mtableview tableViewDidFinishedLoading];
                                  [phud hide];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

#pragma mark -
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycellid";
    ForemanListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ForemanListCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if([self.dataArray count]){
    ForemanObj *obj=[self.dataArray objectAtIndex:indexPath.row];
    cell.name_lab.text=obj.nickName;
    cell.express_lab.text=obj.foremanExperience;
    [cell.photo_inage setOnlineImage:obj.foremanIconPath placeholderImage:[UIImage imageNamed:@"地板默认图片ios.png"]];
    if([obj.foremanAuthents_arr count]){
        for(int i=0;i<[obj.foremanAuthents_arr count];i++){
            NSDictionary *dict=[obj.foremanAuthents_arr objectAtIndex:i];
            UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(140+i*40, 10, 35, 32)];
            image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"rz_%@.png",[dict objectForKey:@"authzId"]]];
            [cell addSubview:image_rz];
        }
    }
    
    NSInteger srat_full=0;
    NSInteger srat_half=0;
    if([obj.foremanLevel integerValue]<[obj.foremanLevel floatValue]){
        srat_full=[obj.foremanLevel integerValue];
        srat_half=1;
    }
    else if([obj.foremanLevel integerValue]==[obj.foremanLevel floatValue]){
        srat_full=[obj.foremanLevel integerValue];
        srat_half=0;
    }
        
    for(int i=0;i<5;i++){
        if (i <srat_full) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 2, 20, 20)];
            [imageView setImage:[UIImage imageNamed:@"stars_0.png"]];
            [cell.view_ addSubview:imageView];
            
        }
        else if (i==srat_full && srat_half!=0) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 2, 20, 20)];
            [imageView setImage:[UIImage imageNamed:@"stars_1.png"]];
            [cell.view_ addSubview:imageView];
            
        }
        else {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 2, 20, 20)];
            [imageView setImage:[UIImage imageNamed:@"stars_2.png"]];
            [cell.view_ addSubview:imageView];
            
        }
      }
        cell.btn_call.tag=kButton_Tag+indexPath.row;
        [cell.btn_call addTarget:self action:@selector(pressbtnToforeman:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ForemanObj *obj_=[self.dataArray objectAtIndex:indexPath.row];
    ForemanInfoViewController *foreinfovc=[[ForemanInfoViewController alloc]init];
//    foreinfovc.delegate=self;
    // foreinfovc.obj=obj_;
    [self.navigationController pushViewController:foreinfovc animated:YES];
   [self performSelector:@selector(deselct:) withObject:tableView afterDelay:0.2f];
}

-(void)deselct:(UITableView *)sender{
    [sender deselectRowAtIndexPath:[sender indexPathForSelectedRow] animated:YES];
}

- (void)reload_foreman_Thing:(NSString *)string {
    self.currentPage-=1;
    [self requestforemanTypelist];
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        self.currentPage=0;
        [self requestforemanTypelist];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestforemanTypelist];
        }
        else{
             [phud hide];
            [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            mtableview.reachedTheEnd = YES;  //是否加载到底了
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=YES;
    [self createProgressView];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

//上拉加载  Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=NO;
    [self createProgressView];
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

#pragma mark -
#pragma mark - UIButton

-(void)pressbtnToforeman:(UIButton *)btn{
 
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    ForemanObj *obj=[self.dataArray objectAtIndex:btn.tag-kButton_Tag];
    [self requestRecordCallinfo:obj];
    if ([osVersion floatValue] >= 3.1) {
        UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[obj.foremanMobile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]]];
        webview.hidden = YES;
        // Assume we are in a view controller and have access to self.view
        [self.view addSubview:webview];
        
    }else {
        // On 3.0 and below, dial as usual
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[obj.foremanMobile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [mtableview setDelegate:nil];
    [mtableview setDataSource:nil];
    self.dataArray=nil;
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
