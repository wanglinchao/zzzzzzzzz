//
//  WorkerListViewController.m
//  IDIAI
//
//  Created by iMac on 14-10-23.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "WorkerListViewController.h"
#import "HexColor.h"
#import "util.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "WorkerInfoViewController.h"
#import "WorkerSearcheMapViewController.h"
#import "WorkerListObj.h"
#import "UIImageView+WebCache.h"
#import "EmptyClearTableViewCell.h"
#import "ListviewWorker.h"
#import "SearchWorkerViewController.h"
#import "OpenUDID.h"
#import "IDIAIAppDelegate.h"
#import "XiaoGongNewDetailViewController.h"
#import "savelogObj.h"
#import "HRCoreAnimationEffect.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

#define SECTION_BTN_TAG_BEGIN   1000
#define SECTION_IV_TAG_BEGIN    3000
#define KAreaOrGongzType_TAG    4000
#define KButtonTag_phone 100000
#define KAuthzs_Image_Tag 200000

@interface WorkerListViewController ()<DropDownChooseWorkerDelegate>{
  
    UISegmentedControl *segmentedControl;
    
    UIControl *_control;
    UIView *_dv;
    UIScrollView *_scr;
    NSArray *_dataArr;//弹出层数据源
    NSInteger currentExtendSection;
}

@property (nonatomic, retain) UIView *view_bg_style;

@end

@implementation WorkerListViewController
@synthesize view_bg_style;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"worker_refresh" object:nil];
}

- (void)customizeNavigationBar {
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:kColorWithRGB(249, 249, 250)];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"地图",@"列表",nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0, 0, 90, 25);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor lightGrayColor];
    segmentedControl.layer.cornerRadius=12.5;
    segmentedControl.layer.masksToBounds=YES;
    segmentedControl.layer.borderWidth=1.0;
    segmentedControl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    segmentedControl.selectedSegmentIndex=1;
    self.navigationItem.titleView=segmentedControl;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 25, 80, 30)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 65);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setImage:[UIImage imageNamed:@"ic_ss_2"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 20, 0, -10);
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

-(void)PressBarItemLeft{
    [self removeChioceView];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)PressBarItemRight{
    [self removeChioceView];
    SearchWorkerViewController *searchvc=[[SearchWorkerViewController alloc]init];
    searchvc.lat_=self.lat;
    searchvc.lng_=self.lng;
    [self.navigationController pushViewController:searchvc animated:YES];
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    if(Seg.selectedSegmentIndex==0){
        [self removeChioceView];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)removeChioceView{
    [_control removeFromSuperview];
    _control=nil;
    [_dv removeFromSuperview];
    _dv=nil;
    currentExtendSection=-1;
    for(int i=0;i<3;i++){
        UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:(SECTION_IV_TAG_BEGIN +i)];
        [currentIV setImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    IDIAIAppDelegate *delegate=(IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:YES animated:NO];
   
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if(IS_iOS7_8)
        self.automaticallyAdjustsScrollViewInsets = NO;

    [self customizeNavigationBar];
    
    [mtableview reloadData];
    
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:[UIToolbar class]]) {
            [view removeFromSuperview];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    _locService.delegate=nil;
    [_locService stopUserLocationService];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.edgesForExtendedLayout=UIRectEdgeNone;
     self.view.backgroundColor=[UIColor whiteColor];
    
    [savelogObj saveLog:@"查看小工列表" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:20];
   
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableview_notif:) name:@"worker_refresh" object:nil];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    IDIAIAppDelegate *delegate_=(IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.dataArray_fenlei =[[NSMutableArray alloc]initWithCapacity:0];
    self.dataArray_paixu =[NSMutableArray arrayWithObjects:@{@"starName":@"星级",@"starId":@"1"},@{@"starName":@"距离",@"starId":@"2"},@{@"starName":@"热度",@"starId":@"3"}, nil];
    self.dataArray_quyu =[NSMutableArray arrayWithArray:delegate_.array_area_list];

    
    self.currentPage=0;
    self.sort_number=@"1";
    self.DistrictNO=@"-1";
    self.type_id_=@"-1";
    self.searchContent=@"";
    
    [self createHeafer];
    
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0,40, kMainScreenWidth, kMainScreenHeight-64-40) style:UITableViewStyleGrouped];
    mtableview.pullingDelegate=self;
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    [mtableview setHeaderOnly:YES];          //只有下拉刷新
    //    [mtableview setFooterOnly:YES];         //只有上拉加载
    [self.view addSubview:mtableview];

    if([self.dataArray_quyu count]) {
        NSDictionary *dict_=[NSDictionary dictionaryWithObjects:@[@"-1",@"不限"] forKeys:@[@"areaCode",@"areaName"]];
        [self.dataArray_quyu insertObject:dict_ atIndex:0]; //插入某城市不限范围
        [self requestworkerTypelist];
    }
    else [self requestDistrictNOlist];
    
    [self loadImageviewBG];
}


#pragma mark -
#pragma mark - UIButton

-(void)reloadTableview_notif:(NSNotification *)notif{
     self.currentPage-=1;
    [self requestworkerTypelist];
}

#pragma mark -
#pragma mark -ListviewWorker

-(void)chooseAtSection:(NSInteger)section indexId:(NSString *)index_id{
    self.searchContent=@"";
    if(section==0) self.DistrictNO=index_id;
    if(section==1) self.type_id_=index_id;
    if(section==2) self.sort_number=index_id;
    if([self.dataArray count])[self.dataArray removeAllObjects];
    [mtableview reloadData];
    [mtableview launchRefreshing];
    
}

//请求小工分类
-(void)requestworkerTypelist{
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

        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0028\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"phaseId\":\"%d\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],4];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                 // NSLog(@"message返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10281) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[jsonDict objectForKey:@"jobScopeList"];
                        if ([arr_ count]) {
                            for(NSDictionary *dict in arr_){
                                if(![dict isEqual:[NSNull null]]) [self.dataArray_fenlei addObject:dict];
                            }
                        }
                        [self.dataArray_fenlei insertObject:@{@"jobscopeName":@"全部",@"jobscopeId":@"-1"} atIndex:0];
                        
/********
                        ListviewWorker *listview=[[ListviewWorker alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40) array_name:@[@"区域",@"分类",@"排序"] type:1];
                        listview.delegate=self;
                        listview.array_data_first=self.dataArray_quyu;
                        listview.array_data_second=self.dataArray_fenlei;
                        listview.array_data_three=@[@"星级",@"距离",@"热度"];
                        listview.mSuperView=self.view;
                        [self.view addSubview:listview];
********/

                        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
                            _locService = [[BMKLocationService alloc]init];
                            _locService.delegate=self;
                            [_locService startUserLocationService];
                            
                        }else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用"
                                                                            message:@"可在“设置->隐私->定位服务”中确认“定位服务”和“屋托邦”是否为开启状态"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                            [alert show];
                            self.lng=@"";
                            self.lat=@"";
                            [mtableview launchRefreshing];
                        }

                        
                    });
                }
                else if (code==10289) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                       imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                imageview_bg.hidden=NO;
                                  label_bg.hidden = NO;
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

//请求行政区域列表
-(void)requestDistrictNOlist{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0042\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                //NSLog(@"行政区号：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10421) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *arr_=[jsonDict objectForKey:@"countyList"];
                        if([self.dataArray_quyu count]) [self.dataArray_quyu removeAllObjects];
                        if ([arr_ count]) {
                            for(NSDictionary *dict in arr_){
                                [self.dataArray_quyu addObject:dict];
                            }
                            NSDictionary *dict_=[NSDictionary dictionaryWithObjects:@[@"-1",@"不限"] forKeys:@[@"areaCode",@"areaName"]];
                            [self.dataArray_quyu insertObject:dict_ atIndex:0]; //插入某城市不限范围
                            
                        }
                        
                        [self requestworkerTypelist];
                    });
                }
                else if (code==10429) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                            imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  imageview_bg.hidden=NO;
                                  label_bg.hidden = NO;
                              });
                          }
                               method:url postDict:nil];
    });
    
}


//请求小工列表
-(void)requestworkerlist{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0030\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"jobScopeId\":\"%@\",\"keyword\":\"%@\",\"currentPage\":\"%ld\",\"requestRow\":\"15\",\"sortType\":\"%@\",\"userLongitude\":\"%@\",\"userLatitude\":\"%@\",\"requestArea\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.type_id_,self.searchContent,(long)self.currentPage+1,self.sort_number,self.lng,self.lat,self.DistrictNO];
    
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"小工列表：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10301) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[jsonDict objectForKey:@"workersList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            if(self.refreshing==YES) [self.dataArray removeAllObjects];
                            for(NSDictionary *dict in arr_){
                                [self.dataArray addObject:[WorkerListObj objWithDict:dict]];
                            }
                        }
                        
                        
                        if([self.dataArray count]){
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
                else if (code==10309) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                         [mtableview tableViewDidFinishedLoading];
                        if(![self.dataArray count]) {
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
                        if(![self.dataArray count]) {
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
                                  if(![self.dataArray count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                   [mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

//发送记录呼叫电话信息
-(void)requestRecordCallinfo:(WorkerListObj *)obj_{
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
        [postDict01 setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
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
        if([obj_.phoneNumber length]>2) str_called=obj_.phoneNumber;
        else str_called=@"";
        //获取被叫号码编号
        NSString *str_called_id;
        if(obj_.workerId >=0) str_called_id=[NSString stringWithFormat:@"%ld",(long)obj_.workerId];
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
        [postDict02 setObject:@"3" forKey:@"calledIdenttityType"];
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
                NSLog(@"电话记录：返回信息：%@",jsonDict);
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


#pragma mark -
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.sort_number integerValue]==3)return 110;
    else return 90;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycellid";
    EmptyClearTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"EmptyClearTableViewCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
        
    if([self.dataArray count]){
        WorkerListObj *obj=[self.dataArray objectAtIndex:indexPath.section];
        
        float height=90;
        if([self.sort_number integerValue]==3) height=110;
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, height)];
        view.backgroundColor=[UIColor whiteColor];
        view.layer.cornerRadius=5;
        [cell addSubview:view];
        
        UIImageView *UserLogo=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 50, 50)];
        UserLogo.contentMode=UIViewContentModeScaleAspectFill;
        UserLogo.layer.cornerRadius=25;
        UserLogo.layer.masksToBounds=YES;
        [UserLogo sd_setImageWithURL:[NSURL URLWithString:obj.workerIconPath] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
        [cell addSubview:UserLogo];
        
        CGSize size_name=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",obj.nickName] width:kMainScreenWidth-170 font:[UIFont systemFontOfSize:17]];
        UILabel *UserName=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, 10, size_name.width, 17)];
        UserName.backgroundColor=[UIColor clearColor];
        UserName.textAlignment=NSTextAlignmentLeft;
        UserName.textColor=[UIColor blackColor];
        UserName.font=[UIFont systemFontOfSize:17];
        UserName.text=obj.nickName;
        [cell addSubview:UserName];
        
        //[self createAuthzs:cell Rect:UserName.frame Obj:obj];
        
        if([obj.authentication_arr count]){
            for(int i=0;i<[obj.authentication_arr count];i++){
                NSDictionary *dict=[obj.authentication_arr objectAtIndex:i];
                UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserName.frame)+i*34, 11, 29, 13)];
                image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_new_%@",[dict objectForKey:@"authzId"]]];
                [cell addSubview:image_rz];
            }
        }
        
        if([self.sort_number integerValue]==3){
            UILabel *Collects=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, CGRectGetMaxY(UserName.frame)+7, kMainScreenWidth-CGRectGetMaxX(UserLogo.frame)-80, 20)];
            Collects.backgroundColor=[UIColor clearColor];
            Collects.textAlignment=NSTextAlignmentLeft;
            Collects.textColor=[UIColor lightGrayColor];
            Collects.font=[UIFont systemFontOfSize:14];
            [cell addSubview:Collects];
            
            UILabel *Browers=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, CGRectGetMaxY(Collects.frame)+5, kMainScreenWidth-CGRectGetMaxX(UserLogo.frame)-80, 20)];
            Browers.backgroundColor=[UIColor clearColor];
            Browers.textAlignment=NSTextAlignmentLeft;
            Browers.textColor=[UIColor lightGrayColor];
            Browers.font=[UIFont systemFontOfSize:14];
            [cell addSubview:Browers];
            
            if([obj.workerCollect integerValue]>=100000000) Collects.text=[NSString stringWithFormat:@"收藏量  %0.1f亿",[obj.workerCollect floatValue]/100000000];
            else if([obj.workerCollect integerValue]>=10000) Collects.text=[NSString stringWithFormat:@"收藏量  %0.1f万",[obj.workerCollect floatValue]/10000];
            else Collects.text=[NSString stringWithFormat:@"收藏量  %@",obj.workerCollect];
            
            if([obj.workerBrower integerValue]>=100000000) Browers.text=[NSString stringWithFormat:@"浏览量  %0.1f亿",[obj.workerBrower floatValue]/100000000];
            else if([obj.workerBrower integerValue]>=10000) Browers.text=[NSString stringWithFormat:@"浏览量  %0.1f万",[obj.workerBrower floatValue]/10000];
            else Browers.text=[NSString stringWithFormat:@"浏览量  %@",obj.workerBrower];
            
            UILabel *Distance=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, CGRectGetMaxY(Browers.frame)+3, kMainScreenWidth-CGRectGetMaxX(UserLogo.frame)-80, 20)];
            Distance.backgroundColor=[UIColor clearColor];
            Distance.textAlignment=NSTextAlignmentLeft;
            Distance.textColor=[UIColor lightGrayColor];
            Distance.font=[UIFont systemFontOfSize:14];
            Distance.text=[NSString stringWithFormat:@"距离    %.1fkm",obj.distance];
            [cell addSubview:Distance];
        }
        else{
            UILabel *Distance=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, CGRectGetMaxY(UserName.frame)+8, kMainScreenWidth-CGRectGetMaxX(UserLogo.frame)-80, 20)];
            Distance.backgroundColor=[UIColor clearColor];
            Distance.textAlignment=NSTextAlignmentLeft;
            Distance.textColor=[UIColor lightGrayColor];
            Distance.font=[UIFont systemFontOfSize:14];
            Distance.text=[NSString stringWithFormat:@"距离    %.1fkm",obj.distance];
            [cell addSubview:Distance];
        
            UILabel *MouthWord=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, CGRectGetMaxY(Distance.frame)+5, 40, 20)];
            MouthWord.backgroundColor=[UIColor clearColor];
            MouthWord.textAlignment=NSTextAlignmentLeft;
            MouthWord.textColor=[UIColor lightGrayColor];
            MouthWord.font=[UIFont systemFontOfSize:14];
            MouthWord.text=@"口碑   ";
            [cell addSubview:MouthWord];
            
            NSInteger srat_full=0;
            NSInteger srat_half=0;
            if([obj.workerLevel integerValue]<[obj.workerLevel floatValue]){
                srat_full=[obj.workerLevel integerValue];
                srat_half=1;
            }
            else if([obj.workerLevel integerValue]==[obj.workerLevel floatValue]){
                srat_full=[obj.workerLevel integerValue];
                srat_half=0;
            }
            
            for(int i=0;i<5;i++){
                if (i <srat_full) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(MouthWord.frame) + i * 18, CGRectGetMinY(MouthWord.frame)+1, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
                    [cell addSubview:imageView];
                    
                }
                else if (i==srat_full && srat_half!=0) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(MouthWord.frame) + i * 18, CGRectGetMinY(MouthWord.frame)+1, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
                    [cell addSubview:imageView];
                    
                }
                else {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(MouthWord.frame) + i * 18, CGRectGetMinY(MouthWord.frame)+1, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
                    [cell addSubview:imageView];
                    
                }
            }
        }
        
        UIButton *btn_phone=(UIButton *)[cell viewWithTag:KButtonTag_phone+indexPath.section];
        if(!btn_phone) btn_phone=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-60, 10, 50, 40)];
        btn_phone.tag=KButtonTag_phone+indexPath.section;
        [btn_phone setImage:[UIImage imageNamed:@"ic_dianhua"] forState:UIControlStateNormal];
        [btn_phone addTarget:self action:@selector(CallPhone:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_phone];
        
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==mtableview){
        WorkerListObj *obj_=[self.dataArray objectAtIndex:indexPath.section];
        XiaoGongNewDetailViewController *workerinfovc = [[XiaoGongNewDetailViewController alloc]init];
        workerinfovc.obj=obj_;
        workerinfovc.fromVCStr=@" ";
        [self.navigationController pushViewController:workerinfovc animated:YES];
        
        [self performSelector:@selector(deselct:) withObject:tableView afterDelay:0.2f];
    }
}

-(void)deselct:(UITableView *)sender{
    [sender deselectRowAtIndexPath:[sender indexPathForSelectedRow] animated:YES];
}
-(void)createAuthzs:(UITableViewCell *)cell Rect:(CGRect)rect Obj:(WorkerListObj *)obj{
    //获取要显示的资历评级
    NSMutableArray *_zlpj=[NSMutableArray array];
    NSArray *arr_zlpj=[[NSUserDefaults standardUserDefaults]objectForKey:@"zl"];
    if([arr_zlpj count]){
        for(NSDictionary *dict in arr_zlpj)
            [_zlpj addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"qId"]]];
    }
    //获取要显示的认证
    NSMutableArray *_rz=[NSMutableArray array];
    NSArray *arr_rz=obj.authentication_arr;
    if([arr_rz count]){
        for(NSDictionary *dict in arr_rz)
            [_rz addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"authzId"]]];
    }
    
    UIView *bg_rz=[[UIView alloc] init];
    bg_rz.backgroundColor=[UIColor clearColor];
    [cell addSubview:bg_rz];
    
    NSInteger totalCount=[_zlpj count]+[_rz count];
    //清除认证图标
    for(int i=0; i<totalCount; i++){
        //创建认证
        UIImageView *image_rz=(UIImageView *)[bg_rz viewWithTag:KAuthzs_Image_Tag+i];
        if(image_rz) {
            [image_rz removeFromSuperview];
            image_rz=nil;
        }
    }
    
    float width=0;
    for(int i=0;i<[_zlpj count];i++){
        //创建资历
        UIImageView *image_rz=(UIImageView *)[bg_rz viewWithTag:KAuthzs_Image_Tag+i];
        if(!image_rz) image_rz=[[UIImageView alloc]init];
        image_rz.frame =CGRectMake(40*i, 0, 35, 18);
        image_rz.tag=KAuthzs_Image_Tag+i;
        image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_zlpj_%@.png",_zlpj[i]]];
        [bg_rz addSubview:image_rz];
        
        if(i==[_zlpj count]-1) width=CGRectGetMaxX(image_rz.frame)+5;
    }
    
    for(int i=0;i<[_rz count];i++){
        //创建认证
        UIImageView *image_rz=(UIImageView *)[bg_rz viewWithTag:KAuthzs_Image_Tag+[_zlpj count]+i];
        if(!image_rz) image_rz=[[UIImageView alloc]init];
        image_rz.frame =CGRectMake(width+40*i, 0, 35, 18);
        image_rz.tag=KAuthzs_Image_Tag+[_zlpj count]+i;
        image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_new_%@.png",_rz[i]]];
        [bg_rz addSubview:image_rz];
        
        if(i==[_rz count]-1) width=CGRectGetMaxX(image_rz.frame)+5;
    }
    
    bg_rz.frame=CGRectMake(CGRectGetMaxX(rect)+5, CGRectGetMinY(rect) ,width, 20);
}

#pragma mark -Btn

-(void)CallPhone:(UIButton *)btn{
    
    [savelogObj saveLog:@"打电话--小工" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:48];

    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    WorkerListObj *obj=[self.dataArray objectAtIndex:btn.tag-KButtonTag_phone];
    [self requestRecordCallinfo:obj];
    if ([osVersion floatValue] >= 3.1) {
        UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[obj.phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]]];
        webview.hidden = YES;
        // Assume we are in a view controller and have access to self.view
        [self.view addSubview:webview];
        
    }else {
        // On 3.0 and below, dial as usual
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[obj.phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    }
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        self.currentPage=0;
        [self requestworkerlist];
    }
    else {
        if(self.totalPages>self.currentPage){
           
            [self requestworkerlist];
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
    if(self.lng.length<1 && self.lat.length<1){
        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
            isRegreingLocation = YES;
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate=self;
            [_locService startUserLocationService];
        }
        else{
            self.refreshing=YES;
            imageview_bg.hidden=YES;
            label_bg.hidden = YES;
            [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
        }
    }
    else{
        self.refreshing=YES;
        imageview_bg.hidden=YES;
        label_bg.hidden = YES;
        [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
    }
}

//上拉加载  Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    if(self.lng.length<1 && self.lat.length<1){
        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
            isRegreingLocation = YES;
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate=self;
            [_locService startUserLocationService];
        }
        else{
            if(isFirstInt==YES){
                self.refreshing=NO;
                imageview_bg.hidden=YES;
                label_bg.hidden = YES;
                [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
            }
            else {
                [mtableview tableViewDidFinishedLoading];
                isFirstInt=!isFirstInt;
            }
        }
    }
    else{
        if(isFirstInt==YES){
            self.refreshing=NO;
            imageview_bg.hidden=YES;
            label_bg.hidden = YES;
            [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
        }
        else {
            [mtableview tableViewDidFinishedLoading];
            isFirstInt=!isFirstInt;
        }
    }
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
    if(scrollView==mtableview){
    if (mtableview.contentOffset.y<-30) {
        mtableview.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [mtableview tableViewDidScroll:scrollView];
    }
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView==mtableview){
    [mtableview tableViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark -BMKUserLocation
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation.location.coordinate.longitude>0.0 && userLocation.location.coordinate.latitude>0.0) {
        self.lng = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
        self.lat = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
        [_locService stopUserLocationService];
        if(isRegreingLocation==YES) {
            isRegreingLocation=NO;
            [self requestworkerlist];
        }
        else [mtableview launchRefreshing];
    }
}

-(void)didFailToLocateUserWithError:(NSError *)error{
    [_locService stopUserLocationService];
    self.lng=@"";
    self.lat=@"";
    [mtableview launchRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didStopLocatingUser{
    
}

#pragma mark -
#pragma mark - 创建弹出框

-(void)createHeafer{
    for (int i=0; i<3; i++) {
        UIButton *sectionBtn=(UIButton *)[self.view viewWithTag:SECTION_BTN_TAG_BEGIN+i];
        if(!sectionBtn) sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake((kMainScreenWidth/3)*i, 1, kMainScreenWidth/3, 40)];
        //if(!sectionBtn) sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake((kMainScreenWidth-240)/2+80*i-10, 1, 80, 40)];
        sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
        [sectionBtn addTarget:self action:@selector(sectionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [sectionBtn  setTitle:@[@"区域",@"工种",@"排序"][i] forState:UIControlStateNormal];
        [sectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        sectionBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [sectionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 22)];
        //sectionBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        sectionBtn.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:sectionBtn];
        
        UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sectionBtn.frame)-25, CGRectGetMidY(sectionBtn.frame)-2.5, 10, 5)];
        [sectionBtnIv setImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
        [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
        sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
        [self.view addSubview: sectionBtnIv];
    }
    
    UIView *line_bottom=[[UIView alloc]initWithFrame:CGRectMake(0, 39.5, kMainScreenWidth, 0.5)];
    line_bottom.backgroundColor=[UIColor colorWithHexString:@"#E0E0E0" alpha:0.5];
    [self.view addSubview:line_bottom];
    
    currentExtendSection = -1;
}

-(void)sectionBtnTouch:(UIButton *)btn{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    
    UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:(SECTION_IV_TAG_BEGIN +currentExtendSection)];
    [currentIV setImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
    
    if (currentExtendSection == section) {
        [currentIV setImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
        [self dismiss];
    }else{
        [_control removeFromSuperview];
        _control=nil;
        [_dv removeFromSuperview];
        _dv=nil;
        
        currentExtendSection = section;
        currentIV = (UIImageView *)[self.view viewWithTag:SECTION_IV_TAG_BEGIN + currentExtendSection];
        [currentIV setImage:[UIImage imageNamed:@"ic_jiantoushaixuan_s"]];
        [self show];
    }
}

- (void)show {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if(!_control)_control = [[UIControl alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight+40, kMainScreenHeight - 80, kMainScreenHeight - kNavigationBarHeight -40)];
    _control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
    [_control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [keywindow addSubview:_control];
    
    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+40, kMainScreenWidth , 0)];
    _dv.tag=101;
    _dv.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    [keywindow addSubview:_dv];
    
   // [HRCoreAnimationEffect animationCubeFromRight:_dv];
    
    //动画设置位置
    _control.alpha=0.3;
    [UIView animateWithDuration:0.3 animations:^{
        _control.alpha=1.0;
        _dv.frame =  CGRectMake(0, kNavigationBarHeight+40, kMainScreenWidth , kMainScreenHeight - kNavigationBarHeight -40);
        [self createChioces];
    }];
}

-(void)dismiss{
    if (currentExtendSection != -1) {
        currentExtendSection = -1;
    
        [UIView animateWithDuration:0.3 animations:^{
            _control.alpha=0.3;
            _scr.frame=CGRectMake(0, 0, kMainScreenWidth , 0);
            _dv.frame=CGRectMake(0, kNavigationBarHeight+40, kMainScreenWidth , 0);
        } completion:^(BOOL finished) {
            if (finished) {
                [_control removeFromSuperview];
                _control=nil;
                [_scr removeFromSuperview];
                _scr=nil;
                [_dv removeFromSuperview];
                _dv=nil;
            }
        }];
    }
}

-(void)createChioces{
    _scr=[[UIScrollView alloc] init];
    _scr.backgroundColor=[UIColor clearColor];
    [_dv addSubview:_scr];
    
    if(currentExtendSection==0) _dataArr=[NSArray arrayWithArray:self.dataArray_quyu];
    else if (currentExtendSection==1) _dataArr=[NSArray arrayWithArray:self.dataArray_fenlei];
    else _dataArr=[NSArray arrayWithArray:self.dataArray_paixu];
    
    float width_=(kMainScreenWidth-40-60)/3;
    float heigth_=32;
    float space=0;
    for (int i=0; i<[_dataArr count]; i++) {
        UIButton *btn_style=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), 20+10+(i/3)*(heigth_+15), width_, heigth_)];
        btn_style.tag=KAreaOrGongzType_TAG+i;
        if(currentExtendSection==0)
            [btn_style setTitle:[[_dataArr objectAtIndex:i]objectForKey:@"areaName"] forState:UIControlStateNormal];
        else if (currentExtendSection==1)
            [btn_style setTitle:[[_dataArr objectAtIndex:i]objectForKey:@"jobscopeName"] forState:UIControlStateNormal];
        else
             [btn_style setTitle:[[_dataArr objectAtIndex:i]objectForKey:@"starName"] forState:UIControlStateNormal];
        [btn_style setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
        [btn_style setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
        btn_style.titleLabel.font=[UIFont systemFontOfSize:16];
        if(currentExtendSection==0 && [[_dataArr[i] objectForKey:@"areaCode"]isEqualToString:self.DistrictNO]) {
            btn_style.selected=YES;
            btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
        }
        else if(currentExtendSection==1 && [[_dataArr[i] objectForKey:@"jobscopeId"] integerValue]==[self.type_id_ integerValue]) {
            btn_style.selected=YES;
            btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
        }
        else if(currentExtendSection==2 && [[_dataArr[i] objectForKey:@"starId"]isEqualToString:self.sort_number]) {
            btn_style.selected=YES;
            btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
        }
        else{
            btn_style.selected=NO;
            btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
        }
        //给按钮加一个红色的板框
        btn_style.layer.borderWidth = 1.0f;
        //给按钮设置弧度,这里将按钮变成了圆形
        btn_style.layer.cornerRadius = 5.0f;
        btn_style.layer.masksToBounds = YES;
        [btn_style addTarget:self action:@selector(ChoiceStyle:) forControlEvents:UIControlEventTouchUpInside];
        [_scr addSubview:btn_style];
        
        if(i==[_dataArr count]-1) space=CGRectGetMaxY(btn_style.frame);
    }
    
    _scr.frame=CGRectMake(0, 0, CGRectGetWidth(_dv.frame), CGRectGetHeight(_dv.frame));
    _scr.contentSize=CGSizeMake(CGRectGetWidth(_scr.frame), space+30);
}

-(void)ChoiceStyle:(UIButton *)sender{
    for (int i=0; i<[_dataArr count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KAreaOrGongzType_TAG+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
            
            //改变选择卡得颜色和文字
            for (int j=0; j<3; j++) {
                UIButton *sectionBtn=(UIButton *)[self.view viewWithTag:SECTION_BTN_TAG_BEGIN+j];
                UIImageView *currentIV= (UIImageView *)[self.view viewWithTag:SECTION_IV_TAG_BEGIN +j];
                [currentIV setImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
                
                if(currentExtendSection==j  && j==0) {
                    [sectionBtn setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateNormal];
                    [sectionBtn setTitle:[_dataArr[i] objectForKey:@"areaName"] forState:UIControlStateNormal];
                }
                else if(currentExtendSection==j && j==1) {
                    [sectionBtn setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateNormal];
                    [sectionBtn setTitle:[_dataArr[i] objectForKey:@"jobscopeName"] forState:UIControlStateNormal];
                }
                else if(currentExtendSection==j && j==2) {
                    [sectionBtn setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateNormal];
                    [sectionBtn setTitle:[_dataArr[i] objectForKey:@"starName"] forState:UIControlStateNormal];
                    
                }
                else [sectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            
            //获取选中的id发送服务器
            if(currentExtendSection==0) self.DistrictNO=[_dataArr[i] objectForKey:@"areaCode"];
            if(currentExtendSection==1) self.type_id_=[_dataArr[i] objectForKey:@"jobscopeId"];
            if(currentExtendSection==2) self.sort_number=[_dataArr[i] objectForKey:@"starId"];
            [self dismiss];
            self.searchContent=@"";
            if([self.dataArray count])[self.dataArray removeAllObjects];
            [mtableview reloadData];
            [mtableview launchRefreshing];
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
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
