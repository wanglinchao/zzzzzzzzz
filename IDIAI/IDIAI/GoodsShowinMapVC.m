//
//  GoodsShowinMapVC.m
//  IDIAI
//
//  Created by iMac on 14-8-5.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GoodsShowinMapVC.h"
#import "HexColor.h"
#import "WaytotravelViewController.h"
#import "TLToast.h"
#import "util.h"
#import "OpenUDID.h"

#define kButtonTag 100

@interface GoodsShowinMapVC ()<UIAlertViewDelegate>

@end

@implementation GoodsShowinMapVC
@synthesize lat_map,lng_map,phoneNumber,city_str;
@synthesize title_string,address_string,nav_title,location_address;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[[self navigationController] navigationBar] setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
     _locService.delegate=self;
    _geocodesearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil;
     _locService.delegate=nil;
    [_locService stopUserLocationService];
}

-(void)backTouched:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self loadViewMore];
}

-(void)loadViewMore{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    [_mapView setZoomLevel:17];
    _mapView.showMapScaleBar = YES;
    _mapView.mapScaleBarPosition = CGPointMake(15, kMainScreenHeight-100);
    _mapView.delegate = self;
    
    if(title_string==nil) title_string=@"暂无";
    if(address_string==nil) address_string=@"暂无";
    BMKPointAnnotation *item = [[BMKPointAnnotation alloc] init];
    item.coordinate = (CLLocationCoordinate2D) {[lat_map floatValue],[lng_map floatValue]};
    item.title =[NSString stringWithFormat:@"%@",address_string];
    //item.subtitle =[NSString stringWithFormat:@"简介：%@",title_string];
    [_mapView addAnnotation:item];
    [_mapView setCenterCoordinate:item.coordinate animated:YES];
    [_mapView selectAnnotation:[_mapView.annotations firstObject] animated:YES];
    [self.view addSubview:_mapView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 20, 70, 50)];
    [leftButton setImage:[UIImage imageNamed:@"bt_back"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"bt_back_pressed"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self
                   action:@selector(backTouched:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        _locService = [[BMKLocationService alloc]init];
        [_locService startUserLocationService];
    }else {
        if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用"
                                                            message:@"GPS定位尚未打开，请在设置中开启定位"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"设置",nil];
            [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用"
                                                            message:@"GPS定位尚未打开，请在设置中开启定位"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    
    UIView *imgView_bottom=[[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-50, kMainScreenWidth, 50)];
    imgView_bottom.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:imgView_bottom];
    
    NSArray *title_arr=[NSArray arrayWithObjects:@"步行",@"驾车",@"公交", nil];
    NSArray *arr_image_normal=[NSArray arrayWithObjects:@"ic_buxing",@"ic_jiache",@"ic_chengche", nil];
    NSArray *arr_image_selected=[NSArray arrayWithObjects:@"ic_buxing_pressed",@"ic_jiache_pressed",@"ic_chengche_pressed", nil];
    for (int i=0; i<3; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        if(i==0) btn.frame=CGRectMake(20,0, 50, 50);
        else if (i==1) btn.frame=CGRectMake(kMainScreenWidth/2-25,0, 50, 50);
        else if (i==2) btn.frame=CGRectMake(kMainScreenWidth-68,0, 50, 50);
        btn.tag=kButtonTag+i;
        [btn setImage:[UIImage imageNamed:[arr_image_normal objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[arr_image_selected objectAtIndex:i]] forState:UIControlStateHighlighted];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 8, 20, 8)];
        [btn addTarget:self action:@selector(Clickonthedrivescheme:) forControlEvents:UIControlEventTouchUpInside];
        [imgView_bottom addSubview:btn];
        
        UILabel *label = [[UILabel alloc] init];
        if(i==0) label.frame=CGRectMake(20,30, 50, 15);
        else if (i==1) label.frame=CGRectMake(kMainScreenWidth/2-25,30, 50, 15);
        else if (i==2) label.frame=CGRectMake(kMainScreenWidth-68,30, 50, 15);
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#EF6562" alpha:1.0];
        label.text =[title_arr objectAtIndex:i];
        [imgView_bottom addSubview:label];
    }
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(kMainScreenWidth-60,kMainScreenHeight-115, 50, 50);
    btn.tag=kButtonTag+3;
    [btn setImage:[UIImage imageNamed:@"ic_myselflocation"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Clickonthedrivescheme:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==alertView.cancelButtonIndex){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    else{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

-(void)Clickonthedrivescheme:(UIButton *)btn{
      if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        if([util isConnectionAvailable]){
        if (btn.tag==kButtonTag){
            if(location_address.length>=1){
                WaytotravelViewController *wayvc=[[WaytotravelViewController alloc]init];
                wayvc.startingAdd=location_address;
                wayvc.endingAdd=address_string;
                wayvc.currentCity=city_str;
                wayvc.loctaionPt_self=self.loctaionPt;
                wayvc.loctaionPt_shop=(CLLocationCoordinate2D) {[lat_map floatValue],[lng_map floatValue]};
                wayvc.wayType=@"步行";
                [self.navigationController pushViewController:wayvc animated:YES];
            }
            else  {
                [TLToast showWithText:@"正在获取位置，请稍后..." topOffset:200.0f duration:1.5];
                if(!_locService){_locService = [[BMKLocationService alloc]init];
                    _locService.delegate=self;
                }
                [_locService startUserLocationService];
                _mapView.showsUserLocation = NO;
                _mapView.userTrackingMode = BMKUserTrackingModeNone;
                _mapView.showsUserLocation = YES;
            }
        }
        else if (btn.tag==kButtonTag+1){
            if(location_address.length>=1){
                WaytotravelViewController *wayvc=[[WaytotravelViewController alloc]init];
                wayvc.startingAdd=location_address;
                wayvc.endingAdd=address_string;
                wayvc.currentCity=city_str;
                wayvc.loctaionPt_self=self.loctaionPt;
                wayvc.loctaionPt_shop=(CLLocationCoordinate2D) {[lat_map floatValue],[lng_map floatValue]};
                wayvc.wayType=@"驾车";
                [self.navigationController pushViewController:wayvc animated:YES];
            }
            else{
                [TLToast showWithText:@"正在获取位置，请稍后..." topOffset:200.0f duration:1.5];
                if(!_locService){_locService = [[BMKLocationService alloc]init];
                    _locService.delegate=self;
                }
                [_locService startUserLocationService];
                _mapView.showsUserLocation = NO;
                _mapView.userTrackingMode = BMKUserTrackingModeNone;
                _mapView.showsUserLocation = YES;
            }
        }
        else if (btn.tag==kButtonTag+2){
            if(location_address.length>=1){
                WaytotravelViewController *wayvc=[[WaytotravelViewController alloc]init];
                wayvc.startingAdd=location_address;
                wayvc.endingAdd=address_string;
                wayvc.currentCity=city_str;
                wayvc.loctaionPt_self=self.loctaionPt;
                wayvc.loctaionPt_shop=(CLLocationCoordinate2D) {[lat_map floatValue],[lng_map floatValue]};
                wayvc.wayType=@"公交";
                [self.navigationController pushViewController:wayvc animated:YES];
            }
            else {
                [TLToast showWithText:@"正在获取位置，请稍后..." topOffset:200.0f duration:1.5];
                if(!_locService){_locService = [[BMKLocationService alloc]init];
                    _locService.delegate=self;
                }
                [_locService startUserLocationService];
                _mapView.showsUserLocation = NO;
                _mapView.userTrackingMode = BMKUserTrackingModeNone;
                _mapView.showsUserLocation = YES;
            }
        }
        else if(btn.tag==kButtonTag+3){
            if(self.loctaionPt.latitude>0.0 && self.loctaionPt.longitude>0.0)
                [_mapView setCenterCoordinate:self.loctaionPt animated:YES];
            else{
                [TLToast showWithText:@"正在获取位置，请稍后..." topOffset:200.0f duration:1.5];
                if(!_locService){_locService = [[BMKLocationService alloc]init];
                _locService.delegate=self;
                }
                [_locService startUserLocationService];
                _mapView.showsUserLocation = NO;
                _mapView.userTrackingMode = BMKUserTrackingModeNone;
                _mapView.showsUserLocation = YES;
            }
        }
      else{
          [TLToast showWithText:@"无网络，请确认网络连接是否正常..." topOffset:200.0f duration:1.5];
        }
        }
      }
    
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用"
                                                        message:@"可在“设置->隐私->定位服务”中确认“定位服务”和“屋托邦”是否为开启状态"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark - BMKMapViewDelegate

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    [mapView deselectAnnotation:[mapView.annotations firstObject] animated:YES];
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
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		// 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
         annotationView.image = [UIImage imageNamed:@"ic_clhdw_"];   //把大头针换成别的图片
    }
	
    // 设置位置
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
	annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
  
 /*
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = CGRectMake(0, 0, 25, 25);
    [callBtn setImage:[UIImage imageNamed:@"bt_call_nor"] forState:UIControlStateNormal];
    [callBtn setImage:[UIImage imageNamed:@"bt_calldianji"] forState:UIControlStateHighlighted];
    [callBtn addTarget:self action:@selector(callPressed) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = callBtn;
 */
    
    return annotationView;
}


-(void)callPressed{
    [self requestRecordCallinfo];
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    NSString *serviceNumber=[phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
//发送记录呼叫电话信息
-(void)requestRecordCallinfo{
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
        if([phoneNumber length]>2) str_called=phoneNumber;
        else str_called=@"";
        //获取被叫号码编号
        NSString *str_called_id;
        if([phoneNumber integerValue] >=0) str_called_id=[NSString stringWithFormat:@"%@",phoneNumber];
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
        [postDict02 setObject:@"2" forKey:@"calledIdenttityType"];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark - BMKGeoCodeSearchDelegate

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
      //  BMKPoiInfo *info=[result.poiList objectAtIndex:0];
        NSString* showmeg;
        showmeg = [NSString stringWithFormat:@"%@%@",result.addressDetail.district,result.addressDetail.streetName];
        location_address=showmeg; //详细地址（区县及以下）
        city_str=result.addressDetail.city; //所在城市
        
        [_locService stopUserLocationService];
        
        [TLToast showWithText:@"定位成功" topOffset:200.0f duration:1.5];
    }
}

#pragma mark -
#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [_mapView updateLocationData:userLocation];
    if (userLocation.location.coordinate.latitude >0 && userLocation.location.coordinate.longitude >0) {
        self.loctaionPt=userLocation.location.coordinate;
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = self.loctaionPt;
        BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag) NSLog(@"反geo检索发送成功");
        else NSLog(@"反geo检索发送失败");
    }
}

@end
