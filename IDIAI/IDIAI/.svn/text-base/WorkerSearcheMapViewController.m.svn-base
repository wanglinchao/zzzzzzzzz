//
//  WorkerSearcheMapViewController.m
//  IDIAI
//
//  Created by iMac on 14-10-23.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "WorkerSearcheMapViewController.h"
#import "HexColor.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "WorkerListObj.h"
#import "WorkerListViewController.h"
#import "savelogObj.h"
#import "TLToast.h"
#import "util.h"
#import "HRCoreAnimationEffect.h"
#import "MBProgressHUD.h"
#import "OpenUDID.h"
#import "XiaoGongNewDetailViewController.h"

#define KButton_Call_Tag 10000
#define KGongZBtn_Tag 20000

@interface WorkerSearcheMapViewController ()<UIAlertViewDelegate>
{
    UIControl *_control;
    UIView *_dv;
    UIScrollView *_scr;
    NSMutableArray *type_array;//弹出层数据源
    
    MBProgressHUD *phud;
    UISegmentedControl *segmentedControl;
}

@property (strong, nonatomic) NSMutableArray *imageViewArray;

@end

@implementation WorkerSearcheMapViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"worker_refresh" object:nil];
}

- (void)customizeNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
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
    
    //导航右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 42, 42);
    [rightBtn setImage:[UIImage imageNamed:@"ic_fengge_2"] forState:UIControlStateNormal];
    //右移
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, -5);
    [rightBtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)PressBarItemLeft{
    [self dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)PressBarItemRight{
    [self show];
}
-(void)segmentAction:(UISegmentedControl *)Seg{
    if(Seg.selectedSegmentIndex==1){
        [self dismiss];
        WorkerListViewController *listVC=[[WorkerListViewController alloc]init];
//        listVC.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
//        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:listVC];
//        [self presentViewController:nav animated:NO completion:nil];
        [self.navigationController pushViewController:listVC animated:NO];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate=self;
    
    segmentedControl.selectedSegmentIndex=0;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
     _locService.delegate=nil;
    [_locService stopUserLocationService];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MobClick event:@"Click_fjxg"];   //友盟自定义事件,数量统计
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    [self customizeNavigationBar];
    
    [savelogObj saveLog:@"地图查看小工" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:25];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableview_notif:) name:@"worker_refresh" object:nil];
    
    self.data_array=[NSMutableArray arrayWithCapacity:0];
     type_array=[NSMutableArray arrayWithCapacity:0];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    [_mapView setZoomLevel:17];
    _mapView.showMapScaleBar = YES;
    _mapView.mapScaleBarPosition = CGPointMake(15, kMainScreenHeight-64-40);
    [self.view addSubview:_mapView];
    //默认地图中心点在成都天府广场
    CLLocationCoordinate2D centerPt = (CLLocationCoordinate2D){30.6637900000,104.0721620000};
    [_mapView setCenterCoordinate:centerPt animated:NO];
    
    _locService = [[BMKLocationService alloc]init];
    
    UIButton *dingwei_btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-60, kMainScreenHeight-64-58, 60, 60)];
    [dingwei_btn setImage:[UIImage imageNamed:@"ic_myselflocation"] forState:UIControlStateNormal];
    [dingwei_btn addTarget:self action:@selector(beginLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dingwei_btn];
    
    [self requestType];
}

-(void)createProgressView{
    if (!phud) {
        phud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:phud];
        phud.mode=MBProgressHUDModeIndeterminate;
        //self.pHUD.dimBackground=YES; //是否开启背景变暗
        phud.labelText = @"加载中...";
        phud.blur=NO;  //是否开启ios7毛玻璃风格
        phud.darkBlur=YES; //受blur限制（blur为YES时设置darkBlur才有用）
        [phud show:YES];
    }
    else{
        [phud show:YES];
    }
}

#pragma mark - createGongzhong
- (void)show {
    if(_control) {
        [self dismiss];
        return;
    }
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if(!_control)_control = [[UIControl alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kMainScreenHeight - 80, kMainScreenHeight - kTabBarHeight)];
    _control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
    [_control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [keywindow addSubview:_control];

    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+0.5, kMainScreenWidth , kMainScreenHeight - kNavigationBarHeight)];
    _dv.tag=101;
    _dv.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    [keywindow addSubview:_dv];
    [self createChioces];
    
    [HRCoreAnimationEffect animationPushRight:_dv];
}

-(void)dismiss{
    [_control removeFromSuperview];
    _control=nil;
    _dv.frame=CGRectMake(0, kNavigationBarHeight+0.5, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight);
    [UIView animateWithDuration:.25 animations:^{
        _dv.frame=CGRectMake(kMainScreenWidth, kNavigationBarHeight+0.5, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight);
    } completion:^(BOOL finished) {
        if (finished) {
            [_dv removeFromSuperview];
            _dv=nil;
        }
    }];
}

-(void)createChioces{
    _scr=[[UIScrollView alloc] init];
    _scr.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    [_dv addSubview:_scr];
    
    UILabel *gongz_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
    gongz_lab.backgroundColor=[UIColor clearColor];
    gongz_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
    gongz_lab.font=[UIFont boldSystemFontOfSize:18];
    gongz_lab.text=@"工种";
    [_scr addSubview:gongz_lab];
    float width_=(kMainScreenWidth-40-60)/3;
    float heigth_=32;
    float space=0;
    for (int i=0; i<[type_array count]; i++) {
        UIButton *btn_style=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), CGRectGetMaxY(gongz_lab.frame)+10+(i/3)*(heigth_+15), width_, heigth_)];
        btn_style.tag=KGongZBtn_Tag+i;
        [btn_style setTitle:[[type_array objectAtIndex:i] objectForKey:@"jobscopeName"] forState:UIControlStateNormal];
        [btn_style setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
        [btn_style setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
        btn_style.titleLabel.font=[UIFont systemFontOfSize:15];
        if(self.selectedBtn==i) btn_style.selected=YES;
        else btn_style.selected=NO;
        //给按钮加一个红色的板框
        if(btn_style.selected==YES) btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
        else btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
        btn_style.layer.borderWidth = 1.0f;
        //给按钮设置弧度,这里将按钮变成了圆形
        btn_style.layer.cornerRadius = 5.0f;
        btn_style.layer.masksToBounds = YES;
        [btn_style addTarget:self action:@selector(ChoiceStyle:) forControlEvents:UIControlEventTouchUpInside];
        [_scr addSubview:btn_style];
        
        if(i==[type_array count]-1) space=CGRectGetMaxY(btn_style.frame);
    }
    
    _scr.frame=CGRectMake(0, 0, CGRectGetWidth(_dv.frame), CGRectGetHeight(_dv.frame)-kMainScreenWidth/8);
    _scr.contentSize=CGSizeMake(CGRectGetWidth(_scr.frame), space+30);
    
    UIButton *finished_Choice=[[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_scr.frame),kMainScreenWidth,kMainScreenWidth/8)];
    [finished_Choice setTitle:@"取消" forState:UIControlStateNormal];
    [finished_Choice setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateNormal];
    finished_Choice.titleLabel.font=[UIFont systemFontOfSize:16];
    finished_Choice.backgroundColor=[UIColor colorWithHexString:@"#E5E5E5" alpha:0.8];
    [finished_Choice addTarget:self action:@selector(ChoiceCancle) forControlEvents:UIControlEventTouchUpInside];
    [_dv addSubview:finished_Choice];
}

-(void)ChoiceStyle:(UIButton *)sender{
    //工种id
    for (int i=0; i<[type_array count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KGongZBtn_Tag+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
            self.type_id=[[type_array[i] objectForKey:@"jobscopeId"] integerValue];
            self.selectedBtn=i;
            [self dismiss];
            [self createProgressView];
            [self requestworkerlist];
            break;
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
}

-(void)ChoiceCancle{
    [self dismiss];
}

#pragma mark -
#pragma mark - others

-(void)reloadTableview_notif:(NSNotification *)notif{
    is_notif_bmk=YES;
    [self requestworkerlist];
}

//请求小工分类
-(void)requestType{
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
                 NSLog(@"message返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10281) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[jsonDict objectForKey:@"jobScopeList"];
                        if ([arr_ count]) {
                            if([type_array count]) [type_array removeAllObjects];
                            for(NSDictionary *dict in arr_){
                                if(![dict isEqual:[NSNull null]]) [type_array addObject:dict];
                            }
                    
                            [type_array insertObject:@{@"jobscopeName":@"全部",@"jobscopeId":@"-1"} atIndex:0];
                            self.type_id=[[[type_array objectAtIndex:0] objectForKey:@"jobscopeId"] integerValue];
                            
                            _mapView.showsUserLocation = NO;
                            _mapView.userTrackingMode = BMKUserTrackingModeNone;
                            _mapView.showsUserLocation = YES;
                            
                            [_locService startUserLocationService];
                        }
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                              });
                          }
                               method:url postDict:nil];
    });
}

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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0031\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"jobScopeId\":\"%ld\",\"userLongitudeLeft\":\"%@\",\"userLatitudeLeft\":\"%@\",\"userLongitudeRight\":\"%@\",\"userLatitudeRight\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.type_id,self.lng_left,self.lat_left,self.lng_right,self.lat_right];
        
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
                if (code==10311) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *arr_=[jsonDict objectForKey:@"workersList"];
                        if([self.data_array count]) [self.data_array removeAllObjects];
                        if ([arr_ count]) {
                            for(NSDictionary *dict in arr_)
                                [self.data_array addObject:[WorkerListObj objWithDict:dict]];
                        }
                        [phud hide:YES];
                        if(!is_notif_bmk)[self Loadthestickynotes];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [phud hide:YES];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                               [phud hide:YES];
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
        if(obj_.workerId >=0) str_called_id=[NSString stringWithFormat:@"%d",obj_.workerId];
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

-(void)Loadthestickynotes{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    for (int i=0; i<[self.data_array count]; i++) {
        WorkerListObj *obj=[self.data_array objectAtIndex:i];
        BMKPointAnnotation *item = [[BMKPointAnnotation alloc] init];
        item.coordinate = (CLLocationCoordinate2D) {obj.workerLatitude,obj.workerLongitude};
        item.title =@"                     ";
        [_mapView addAnnotation:item];
    }
}

#pragma mark -
#pragma mark - BMKmapDelegate

//当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    [savelogObj saveLog:@"查看工长详情" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:25];
    
    NSInteger index_ = [_mapView.annotations indexOfObject:view.annotation]; //获取当前大头针的编号
    if(index_<1000){
        WorkerListObj *obj_=[self.data_array objectAtIndex:index_];
//    WorkerInfoViewController *workinvc=[[WorkerInfoViewController alloc]init];
        XiaoGongNewDetailViewController *workinvc = [[XiaoGongNewDetailViewController alloc]init];
        workinvc.obj=obj_;
    [self.navigationController pushViewController:workinvc animated:YES];
    }
}

//地图区域改变完成后会调用此接口
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    BMKCoordinateRegion point=[_mapView convertRect:_mapView.bounds toRegionFromView:_mapView];
    self.lat_left=[NSString stringWithFormat:@"%f", point.center.latitude+(point.span.latitudeDelta/2)];
    self.lng_left=[NSString stringWithFormat:@"%f", point.center.longitude-(point.span.longitudeDelta/2)];
    self.lat_right=[NSString stringWithFormat:@"%f", point.center.latitude-(point.span.latitudeDelta/2)];
    self.lng_right=[NSString stringWithFormat:@"%f", point.center.longitude+(point.span.longitudeDelta/2)];
    if(mapView.zoomLevel>=13) {
        is_notif_bmk=NO;
        [self createProgressView];
        [self requestworkerlist];
    }
    else{
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        if([array count]) [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        if([array count])[_mapView removeOverlays:array];
        [TLToast showWithText:@"当前地图比例尺超过2km，无法查询小工信息" topOffset:200.0f duration:1.5];
    }
}

//根据anntation生成对应的标注View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"testMark";
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorPurple;
		// 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
         annotationView.image = [UIImage imageNamed:@"ic_gzdingwei"];   //把大头针换成别的图片
    }
	
    // 设置位置
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
	annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    //获取当前大头针的编号
    NSInteger index_ = [_mapView.annotations indexOfObject:annotation];
    WorkerListObj *obj=[self.data_array objectAtIndex:index_];
    
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 240, 60)];
    popView.backgroundColor=[UIColor clearColor];
   //设置弹出气泡图片
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dingweitanchukuang"]];
    image.frame = CGRectMake(0, 0, 240, 60);
    [popView addSubview:image];
    //自定义显示的内容
    CGSize size=[util calHeightForLabel:obj.nickName width:100 font:[UIFont systemFontOfSize:14]];
    UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, size.width, 20)];
    driverName.text = obj.nickName;
    driverName.backgroundColor = [UIColor clearColor];
    driverName.font = [UIFont systemFontOfSize:14];
    driverName.textColor = [UIColor blackColor];
    driverName.numberOfLines=0;
    driverName.textAlignment = NSTextAlignmentLeft;
    driverName.lineBreakMode=NSLineBreakByTruncatingTail;
    [popView addSubview:driverName];
    
    //加载认证图标
    if([obj.authentication_arr count]){
        for(int i=0;i<[obj.authentication_arr count];i++){
            NSDictionary *dict=[obj.authentication_arr objectAtIndex:i];
            UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(driverName.frame)+5+i*34, 8, 29, 13)];
            image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_new_%@.png",[dict objectForKey:@"authzId"]]];
            [popView addSubview:image_rz];
        }
    }
    
    //加载星级（0-10,0表示无星级）
    NSInteger star_level=0;
    if([obj.workerLevel integerValue]<[obj.workerLevel floatValue])
        star_level=[obj.workerLevel integerValue]*2+1;
    else
        star_level=[obj.workerLevel integerValue]*2;
    
    _imageViewArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*18, 27, 15, 15)];
            [self.imageViewArray addObject:imageView];
            [popView addSubview:imageView];
        }
    }
    [self numberStartReLoad:star_level];
    
    UIView *line=[[UIView alloc]init];
    if([obj.authentication_arr count]>1) line.frame=CGRectMake(10+size.width+20*[obj.authentication_arr count]+20, 10, 0.5, 30);
    else line.frame=CGRectMake(10+size.width+60, 10, 0.5, 30);
    line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
    [popView addSubview:line];
    
    //设置右视图
    if(index_<[self.data_array count]){
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         if([obj.authentication_arr count]>1) callBtn.frame = CGRectMake(10+size.width+20*[obj.authentication_arr count]+20, 10, 30, 30);
        else callBtn.frame = CGRectMake(10+size.width+65, 10, 30, 30);
        callBtn.tag=KButton_Call_Tag+index_;
        [callBtn setImage:[UIImage imageNamed:@"ic_dianhua"] forState:UIControlStateNormal];
        [callBtn setImage:[UIImage imageNamed:@"bt_calldianji"] forState:UIControlStateHighlighted];
        [callBtn addTarget:self action:@selector(callPressed:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:callBtn];
    }
    
    if([obj.authentication_arr count]>1) popView.frame=CGRectMake(0, 0, 10+size.width+20*[obj.authentication_arr count]+15+40, 60);
    else  popView.frame=CGRectMake(0, 0, 10+size.width+100, 60);
    if([obj.authentication_arr count]>1) image.frame=CGRectMake(0, 0, 10+size.width+20*[obj.authentication_arr count]+15+40, 60);
    else image.frame=CGRectMake(0, 0, 10+size.width+100, 60);
    
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    if([obj.authentication_arr count]>1) pView.frame = CGRectMake(0, 0, 10+size.width+20*[obj.authentication_arr count]+15+40, 60);
    else pView.frame = CGRectMake(0, 0, 10+size.width+100, 60);
    annotationView.paopaoView=pView;
 
    
    return annotationView;
}

- (void)numberStartReLoad:(NSInteger)number {
    int fullNum = (int)number/2;
    int halfNum = number%2;
    int emptyNum = 5 - fullNum -halfNum;
    NSMutableArray *starArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            if (fullNum != 0 ) {
                fullNum --;
                [starArray addObject:@"0"];
            }else if(fullNum == 0 &&halfNum != 0)
            {
                halfNum --;
                [starArray addObject:@"1"];
            }
            else if(fullNum == 0 &&halfNum == 0 &&emptyNum!= 0)
            {
                emptyNum --;
                [starArray addObject:@"2"];
            }
            if (self.imageViewArray.count) {
            UIImageView *imageView = [self.imageViewArray objectAtIndex:i];
            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_xing_%@",[starArray objectAtIndex:i]]]];
            } else {
                return;
            }
        }
    }
}

-(void)callPressed:(UIButton *)sender{
    [MobClick event:@"Click_fjxg_gz"];   //友盟自定义事件,数量统计
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    WorkerListObj *obj=[self.data_array objectAtIndex:sender.tag-KButton_Call_Tag];
    [self requestRecordCallinfo:obj];
    NSString *serviceNumber=[obj.phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([osVersion floatValue] >= 3.1) {
        UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",serviceNumber]]]];
        webview.hidden = YES;
        // Assume we are in a view controller and have access to self.view
        [self.view addSubview:webview];
        
    }else {
        // On 3.0 and below, dial as usual
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", serviceNumber]]];
    }
}

-(void)beginLocation{
    [_locService startUserLocationService];
}

#pragma mark -
#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [_mapView updateLocationData:userLocation];
    if (userLocation.location.coordinate.latitude >0 && userLocation.location.coordinate.longitude >0) {
        CLLocationCoordinate2D centerPt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
        [_mapView setCenterCoordinate:centerPt animated:NO];
        [_locService stopUserLocationService];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didFailToLocateUserWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用"
                                                    message:@"没获取到用户当前位置，请开启定位并在主页左上角刷新地理位置"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==alertView.cancelButtonIndex) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    else{
        if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
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
