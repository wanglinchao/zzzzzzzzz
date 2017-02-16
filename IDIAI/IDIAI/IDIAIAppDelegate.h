//
//  IDIAIAppDelegate.h
//  IDIAI
//
//  Created by iMac on 14-6-30.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkRequest.h"
#import "ASIDownloadCache.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "BMapKit.h"
#import "MainTabBarViewController.h"


@class Reachability;
@interface IDIAIAppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,TencentSessionDelegate,QQApiInterfaceDelegate,WeiboSDKDelegate,UIAlertViewDelegate>
{
    BOOL isFirst_Reachability;
    Reachability  *hostReach;
    
    ASIDownloadCache *myCache;
    NSTimer *testTimer;    //发送日志定时器
    NSTimer *diaryTimer;    //检查论坛红点定时器
    
    TencentOAuth *_tencentOAuth;
    BMKMapManager* _mapManager;
    
    CLLocationManager *locationManager;
    NSString *updateMessage;
    NSString *updateurl;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)  NSDictionary *jsonDict;
@property (nonatomic,strong) ASIDownloadCache *myCache;
@property (nonatomic,strong) NSArray *array_area_list;
@property (nonatomic,strong) NSArray *array_city_list;

@property (strong, nonatomic) UINavigationController *nav;//此导航控制器可以作为一个临时控制器在特殊情况下使用（如自定义viewPager）
@property (strong, nonatomic) MainTabBarViewController *mainVC;

@end
