//
//  IDIAIAppDelegate.m
//  IDIAI
//
//  Created by iMac on 14-6-30.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAIAppDelegate.h"
#import "Reachability.h"
#import "JSONKit.h"
#import "util.h"
#import "OpenUDID.h"
#import "savelogObj.h"
#import "RNCachingURLProtocol.h"
#import "TLToast.h"
#import "MobClick.h"
#import "UMessage.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ShoppingMallViewController.h"
#import "OrderOfGoodsContentViewController.h"
#import "UPPaymentControl.h"
#import "SPKitExample.h"
#import "GeneralViewController.h"
#import "GuideViewController.h"
#import "AutomaticLogin.h"
#import <ALBBSDK/ALBBSDK.h>
@implementation IDIAIAppDelegate
@synthesize array_area_list,array_city_list;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [testTimer invalidate];
    [diaryTimer invalidate];
}
//获取程序崩溃的信息
void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    [savelogObj saveLog:[NSString stringWithFormat:@"崩溃日志：%@",reason] userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:18];  //保存崩溃日志
    
    NSLog(@"异常类型: %@ \n 崩溃的原因: %@ \n 当前调用栈信息: %@", name, reason, arr);
}
#pragma mark -  
#pragma mark - TencetnDelegate
-(void)tencentDidLogin{
    
}
-(void)tencentDidNotLogin:(BOOL)cancelled{
    
}
-(void)tencentDidNotNetWork{
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    // Override point for customization after application launch
    
    /*****************************阿里云旺**************************/
    //其实每个用户有两个IM帐号 一个与app帐户相关IM帐号，一个与设备唯一标识符相关的游客帐号。
    [[SPKitExample sharedInstance] callThisInDidFinishLaunching];
    
    /***** 获取并修改用户的UserAgent *****/
    UIWebView * webView = [[UIWebView alloc]init];
    NSString *secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *newUagent = [NSString stringWithFormat:@"%@ iPhone/trond/%@/%@/jssdkv=%d/sdk=%f",secretAgent,[[infoDictionary objectForKey:@"CFBundleIdentifier"] lowercaseString],[infoDictionary objectForKey:@"CFBundleShortVersionString"],jssdkVersion,SystemVersion];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:newUagent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];

    
    
    //自动登录
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:User_Name] length] && [[[NSUserDefaults standardUserDefaults]objectForKey:User_Password] length]) {
        [AutomaticLogin Automaticlogin:self];
    }else{
    
        //获取阿里云旺游客帐号。
        if (![[[NSUserDefaults standardUserDefaults]objectForKey:isHasYWVisitorAccount] isEqualToString:@"YES"]) {//没有IM游客帐号
            [self getYWVisitorAccount];
        }
        else{//有IM游客帐号
            [self LoginIMVistorAccountWithVistorAccount:[[NSUserDefaults standardUserDefaults]objectForKey:YWVisitorAccount]];
        }

    
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:ALiYW_IM_OpenOrCloseSound]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ALiYW_IM_OpenOrCloseSound];
    }
    //修改navBar字体大小文字颜色
    NSDictionary *attris = @{ NSFontAttributeName:[UIFont systemFontOfSize:19],
                              NSForegroundColorAttributeName:[UIColor blackColor] };
    [[UINavigationBar appearance] setTitleTextAttributes:attris];

    //无城市默认为成都
    if(![[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityName"] length]){
        [[NSUserDefaults standardUserDefaults] setObject:@{@"cityName":@"成都市",@"cityCode":@"510100"} forKey:cityCodeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

/*
    //禁止锁屏 (慎重使用本功能，因为非常耗电。)
    [UIApplication sharedApplication].idleTimerDisabled=YES;     // 不自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled=NO;      // 自动锁屏
*/
    
    //获取小白装修、商城、版本检测(安卓)的地址
    [self checkVersion];
   

    //iOS8及以上系统新的定位授权
    if([[[UIDevice currentDevice] systemVersion ] floatValue]>=8.0){
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];    // 定位精度
        
        //请求用户权限：分为：⓵只在前台开启定位 ⓶在后台也可定位，
        //注意：建议只请求⓵和⓶中的一个，如果两个权限都需要，只请求⓶即可，
        //⓵⓶这样的顺序，将导致bug：第一次启动程序后，系统将只请求⓵的权限，⓶的权限系统不会请求，只会在下一次启动应用时请求⓶
        if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];    //⓵只在前台开启定位
            //[locationManager requestAlwaysAuthorization];     //⓶在后台也可定位
        }
    }
    
    //向友盟注册
    //[MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithAppkey:KUMengAppKey reportPolicy:BATCH channelId:@"App Store"];
    
    //向新浪微博注册
   // [WeiboSDK enableDebugMode:YES];    //打开新浪微博sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [WeiboSDK registerApp:kSinaAppkey];
    
    //向微信注册
    [WXApi registerApp:kWeiXinAppID];
    
    //向qq注册
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppID andDelegate:self];
    
    //向百度地图注册
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:kBaiDuMapKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //监听程序的异常
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);

    //记录打开App日志
    [savelogObj saveLog:@"打开App" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:1];
    
    //缓存webview（加入友盟时，如果开启缓存，友盟会发送日志失败）
    //[NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    //自定义缓存
    ASIDownloadCache *Cache = [[ASIDownloadCache alloc] init];
    self.myCache=Cache;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    [self.myCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
//    [self.myCache setDefaultCachePolicy:ASIAskServerIfModifiedCachePolicy];
    [self.myCache setDefaultCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    
    //实时检测网络状况（实时）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];//将Appdelegate添加为网络是否可达的观测者
     hostReach = [Reachability reachabilityWithHostName:kTestNetWorkServerURL];//实例化网络可达性对象with所检测的网络
     [hostReach startNotifier];//开启通知
    
//    self.mainVC=[[MainTabBarViewController alloc]init];
//    self.nav = [[UINavigationController alloc]initWithRootViewController:self.mainVC];
//    [self.window setRootViewController:self.nav];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstTimeToOpenApp"]){

        GuideViewController *guidVC = [[GuideViewController alloc]init];
        self.window.rootViewController = guidVC;
         }else{
        MainTabBarViewController *mainVC=[[MainTabBarViewController alloc]init];
        self.nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
        [self.window setRootViewController:self.nav];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //获取日志操作类型
    [self GetlogOperationTypes];
   
    //发送日志
    if([[[savelogObj getLog] objectForKey:@"list"] count]){
        [savelogObj sendLogtoLServer];
    }
    testTimer= [NSTimer scheduledTimerWithTimeInterval:1800.0 target:self selector:@selector(sendlogtoserver) userInfo:nil repeats:YES];
    
    //检查论坛红点
    [self checkDiaryRedDot];
    diaryTimer= [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(checkDiaryRedDot) userInfo:nil repeats:YES];
    
   
    
    //友盟推送
    //[UMessage setLogEnabled:NO];    //打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [UMessage startWithAppkey:KUMengAppKey launchOptions:launchOptions];    //向友盟注册推送
    
    //register remoteNotification types (iOS 8.0以下)
    if ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] < 8){
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
    //register remoteNotification types （iOS 8.0及其以上版本）
     else {
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
    
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    
       UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];//角标、声音、横幅。

        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
     }

    return YES;
}

-(void)sendlogtoserver{
    if([[[savelogObj getLog] objectForKey:@"list"] count]){
        [savelogObj sendLogtoLServer];
    }
}
//获取IM 游客帐号
-(void)getYWVisitorAccount{
    
    NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
    NSMutableDictionary * bodyDict = [NSMutableDictionary dictionary];
    NSUUID  *  identiferForVendor = [UIDevice currentDevice].identifierForVendor;
    NSString * uuid  =identiferForVendor.UUIDString;
//    NSString *str_uuid=[OpenUDID value];
    [bodyDict setObject:uuid forKey:@"deviceNo"];
    GeneralViewController * generalVC = [[GeneralViewController alloc]init];
    
    [generalVC sendRequestToServerUrl:^(id responseObject){
    
        if([[responseObject objectForKey:@"resCode"] integerValue]==10004){
            NSLog(@"获取云旺游客帐号参数不对！！");
            
        }
        else if ([[responseObject objectForKey:@"resCode"] integerValue]==10000){
             NSLog(@"获取云旺游客帐号成功！！");
             NSString  *  accountId = [responseObject  objectForKey:@"accountId"];
              NSString * hasYWVisitorAccount =@"YES";
            NSLog(@"accountId==========%@",accountId);
            [[NSUserDefaults standardUserDefaults]setObject:hasYWVisitorAccount forKey:isHasYWVisitorAccount];
            [[NSUserDefaults standardUserDefaults]setObject:accountId forKey:YWVisitorAccount];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self LoginIMVistorAccountWithVistorAccount:accountId];
   
                }
        else{
             NSLog(@"获取云旺游客帐号异常！！");
        }
        
    } failedBlock:^(id responseObject){
        
    }
                      RequestUrl:url CmdID:@"ID0376" PostDict:bodyDict RequestType:@"GET"];
    
}

//IM游客帐号登录
-(void)LoginIMVistorAccountWithVistorAccount:(NSString*)vistorAccount{
    SPKitExample * spKitExample = [SPKitExample sharedInstance];
    __weak typeof(spKitExample) weakSPKitExample = spKitExample;
    [[SPKitExample sharedInstance]callThisAfterISVAccountLoginSuccessWithYWLoginId:vistorAccount passWord:IMUserPassword preloginedBlock:^{
       
        
    } successBlock:^{
                         weakSPKitExample.whichAccountLoginSuccess = IMVisitorAccountLoginSucccess;
                        
    } failedBlock:^(NSError * error) {
//                         [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:isIMVistorAccountLoginSuccesed];
    }];

}



#pragma mark - 检查论坛红点
-(void)checkDiaryRedDot{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
        [header setObject:@"ID0344" forKey:@"cmdID"];
        [header setObject:@"" forKey:@"token"];
        [header setObject:@"" forKey:@"userID"];
        [header setObject:@"iOS" forKey:@"deviceType"];
        [header setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
        NSString *string_header=[header JSONString];
        
        //设置消息时间点
        NSString *timeStamp=@"";
        if([[NSUserDefaults standardUserDefaults] objectForKey:DiaryTimeStamp]) timeStamp=[[NSUserDefaults standardUserDefaults] objectForKey:DiaryTimeStamp];
        NSMutableDictionary *body = [[NSMutableDictionary alloc] init];
        [body setObject:timeStamp forKey:DiaryTimeStamp];
        [body setObject:@(7) forKey:@"roleId"];
        NSString *string_body=[body JSONString];
        
        NSMutableDictionary *postDict= [[NSMutableDictionary alloc] init];
        [postDict setObject:string_header forKey:@"header"];
        [postDict setObject:string_body forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"论坛红点：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[jsonDict objectForKey:@"resCode"] integerValue]==103441) {
                            if([[jsonDict objectForKey:@"resultCode"] integerValue]==1) [[NSNotificationCenter defaultCenter]postNotificationName:NotifcationForDiary object:nil];
                        }
                    });
                });
            }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                              });
                          }
                               method:url postDict:postDict];
    });
}

#pragma mark - 网络监测
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    //没有连接到网络就弹出提示
    if (status == NotReachable && isFirst_Reachability==YES) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                        message:@"网络未连接，请打开网络设置"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        alert.tag=102;
//        [alert show];
       
    }
    else if(status == ReachableViaWiFi && isFirst_Reachability==YES) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                        message:@"网络模式切换为WiFi"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        alert.tag=102;
//        [alert show];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:IMInitStatus] isEqualToString:@"NO"]) {
            [[SPKitExample sharedInstance]callThisInDidFinishLaunching];
        }

        if(![[[NSUserDefaults standardUserDefaults]objectForKey:Log_OperationType] count]) {
            //获取日志操作类型
            [self GetlogOperationTypes];
        }
//        //获取小白装修、商城、版本检测(安卓)的地址
//        if(!kUrlLearnDecorate) [self RequestMallAndDecorIpUrl];
    }
    else if (status == kReachableViaWWAN && isFirst_Reachability==YES){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                        message:@"网络模式切换为2G/3G/4G"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        alert.tag=102;
//        [alert show];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:IMInitStatus] isEqualToString:@"NO"]) {
            [[SPKitExample sharedInstance]callThisInDidFinishLaunching];
        }

        if(![[[NSUserDefaults standardUserDefaults]objectForKey:Log_OperationType] count]) {
            //获取日志操作类型
            [self GetlogOperationTypes];
        }
//        //获取小白装修、商城、版本检测(安卓)的地址
//        if(!kUrlLearnDecorate) [self RequestMallAndDecorIpUrl];
    }
    else {
        isFirst_Reachability=YES;
    }
}

#pragma -mark 检查版本更新
-(void)checkVersion{

    NSString *version =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
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
        
        NSString *url=[NSString stringWithFormat:@"%@?header={\"cmdID\":\"\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"version\":\"%@\",\"appID\":\"utop\"}",checkVersionUrl,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],version];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"版本信息：%@",jsonDict);
                
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                updateMessage =[jsonDict objectForKey:@"updateMessage"];
                updateurl =[jsonDict objectForKey:@"updateUrl"];
                if (code==10074) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"版本升级提醒" message:[jsonDict objectForKey:@"updateMessage"] delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles: nil];
                        alert.tag =100;
                        [alert show];
                    });
                }
                else if (code==10075) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"版本升级提醒" message:[jsonDict objectForKey:@"updateMessage"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新",nil];
                        alert.tag =101;
                        [alert show];
                    });
                }
                else{
                    NSLog(@"code===%ld",code);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                              });
                          }
                               method:url postDict:nil];
    });




}


#pragma mark -
#pragma mark -获取日志操作类型

-(void)GetlogOperationTypes{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0025" forKey:@"cmdID"];
        [postDict setObject:@"" forKey:@"token"];
        [postDict setObject:@"" forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
        NSString *string=[postDict JSONString];
        
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        NSString *string02=[postDict02 JSONString];
        
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"日志类型：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[jsonDict objectForKey:@"resCode"] integerValue]==10250) {
                        if([[jsonDict objectForKey:@"list"] count]){
                            NSMutableArray *arr_=[NSMutableArray arrayWithCapacity:0];
                            for(NSString *str in [jsonDict objectForKey:@"list"])
                                if([str integerValue]<=91) [arr_ addObject:str];
                            [[NSUserDefaults standardUserDefaults]setObject:arr_ forKey:Log_OperationType];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                        }
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  
                              });
                          }
                               method:url postDict:post];
    });
    
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {//推送alertView
        if (buttonIndex == 0) {
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        } else {
//            [(HomePageViewController *)[[[self.mainVC.viewControllers firstObject]childViewControllers]firstObject]PressBarItemRight];
        }
        
    } else if (alertView.tag == 1002) {
        if (buttonIndex == 0) {
            ShoppingMallViewController *shoppingMallVC = [[self.mainVC viewControllers]objectAtIndex:1];
            OrderOfGoodsContentViewController *orderOfGoodsContentVC = [[OrderOfGoodsContentViewController alloc]init];
            orderOfGoodsContentVC.index = 0;
            orderOfGoodsContentVC.fromVcNameStr = @"utopVCStatusBtn";
            orderOfGoodsContentVC.hidesBottomBarWhenPushed=YES;
            [shoppingMallVC.navigationController pushViewController:orderOfGoodsContentVC animated:YES];
        } else if (buttonIndex == 1) {
            self.mainVC.selectedIndex = 1;
        }
    }else if (alertView.tag ==100){
        if (buttonIndex ==0) {
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"版本升级提醒" message:updateMessage delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:nil];
            alert.tag =100;
            [alert show];
            NSString *sPappIDStr = @"953425586";
            NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", sPappIDStr];
            NSURL *iTunesURL = [NSURL URLWithString:[iTunesString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            if([[UIApplication sharedApplication] canOpenURL:iTunesURL]) [[UIApplication sharedApplication] openURL:iTunesURL];
        }
        
    }else if (alertView.tag ==101){
        if (buttonIndex ==0) {
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }else{
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
            NSString *sPappIDStr = @"953425586";
            NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", sPappIDStr];
            NSURL *iTunesURL = [NSURL URLWithString:[iTunesString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            if([[UIApplication sharedApplication] canOpenURL:iTunesURL]) [[UIApplication sharedApplication] openURL:iTunesURL];
        }
    }

}

#pragma mark -

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    return [WXApi handleOpenURL:url delegate:self]|[QQApiInterface handleOpenURL:url delegate:self]|[WeiboSDK handleOpenURL:url delegate:self];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"REMOTE_NOTIFICATION_SIMULATOR_NOT_SUPPORTED_NSERROR_DESCRIPTION"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1234567890" forKey:kUDDeviceToken];
    }
    NSLog(@"Register Remote Notifications error:{%@}",error);
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *string =[url absoluteString];
    if ([string hasPrefix:@"wxb02708519e0220ae"])
    {
        return [WXApi handleOpenURL:url delegate:self]|[QQApiInterface handleOpenURL:url delegate:self]|[WeiboSDK handleOpenURL:url delegate:self];
    }
    else if ([string hasPrefix:@"qttecx.utop"]) {
        //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给SDK  if([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
           // NSLog(@"result = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"]integerValue] == 9000) {
//                [TLToast showWithText:@"支付成功"];
                
                //以下获取返回信息中的指定值
                NSString *resultStr = [resultDic objectForKey:@"result"];
                NSArray *resultStringArray =[resultStr componentsSeparatedByString:NSLocalizedString(@"&", nil)];
                for (NSString *str in resultStringArray)
                {
                    NSString *newstring = nil;
                    newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
                    for (int i = 0 ; i < [strArray count] ; i++)
                    {
                        NSString *st = [strArray objectAtIndex:i];
                        if ([st isEqualToString:@"subject"])
                        {
                           // NSLog(@"%@",[strArray objectAtIndex:1]);
                            if ([[strArray objectAtIndex:1]isEqualToString:@"商城"]) {
                                //2.0的商城的支付
                                
//                                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"商品购买成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"查看订单",@"确定", nil];
//                                alertView.tag = 1002;
//                                [alertView show];
                                
                                [[NSNotificationCenter defaultCenter]postNotificationName:kNCShoppingMallPaySuccess object:nil];
                                
                            }
                            else if ([[strArray objectAtIndex:1] rangeOfString:@"阶段："].length){
                                //1.0的工长、监理、设计师的支付
                                [[NSNotificationCenter defaultCenter]postNotificationName:kNCUpdateOrderStatus object:nil];
                            }
                            else {
                                //2.0的商城的支付
                                [[NSNotificationCenter defaultCenter]postNotificationName:kNCShoppingMallPaySuccess object:nil];
                            }
                        }
                    }
                }
                
            }
            else {
//                [TLToast showWithText:@"支付失败"];
            }
        }];
        
        //支付宝钱包快登授权返回 authCode
        if ([url.host isEqualToString:@"platformapi"]){
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                if ([[resultDic objectForKey:@"resultStatus"]integerValue] == 9000) {
                    //[TLToast showWithText:@"支付成功"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNCUpdateOrderStatus object:nil];
                } else {
                    //[TLToast showWithText:@"支付失败"];
                }
                
            }];
        }
        
        
    }else if ([string hasPrefix:@"UPPayDemo"]){
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                
                //判断签名数据是否存在
                if(data == nil){
                    //如果没有签名数据，建议商户app后台查询交易结果
                    return;
                }
                
                //数据从NSDictionary转换为NSString
                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                   options:0
                                                                     error:nil];
                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                
                
                
                //验签证书同后台验签证书
                //此处的verify，商户需送去商户后台做验签
//                if([self verify:sign]) {
//                    //支付成功且验签成功，展示支付成功提示
//                }
//                else {
//                    //验签失败，交易结果数据被篡改，商户app后台查询交易结果
//                }
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
            }
        }];
    }
    
    BOOL isHandledByALBBSDK=[[ALBBSDK sharedInstance] handleOpenURL:url];//处理其他app跳转到自己的app，如果百川处理过会返回YES
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [testTimer invalidate];
    [diaryTimer invalidate];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    //发送日志
    if([[[savelogObj getLog] objectForKey:@"list"] count]){
        [savelogObj sendLogtoLServer];
    }
    testTimer= [NSTimer scheduledTimerWithTimeInterval:1800.0 target:self selector:@selector(sendlogtoserver) userInfo:nil repeats:YES];
    diaryTimer= [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(checkDiaryRedDot) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beaginAnimation" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
//    [[NSFileManager defaultManager] removeItemAtPath:aPath3 error:nil];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Token];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_ID];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Addrss];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_Mobile];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_sex];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_nickName];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:Log_OperationType];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUDUserDistrict];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUDEffectyTypeOfRow_Style];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUDEffectyTypeOfRow_DoorModel];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUDEffectyTypeOfRow_Price];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_ProvinceName];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_CityName];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_AreaName];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_ProvinceCode];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_CityCode];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:User_AreaCode];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:ALiYW_Service_MobileNO];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark -
#pragma mark - SinaWB_Delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
      //  NSLog(@"1111111111111");
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
        NSString *strMsg = nil;
        if (0 == response.statusCode){
            strMsg = @"分享信息成功";
            [TLToast showWithText:strMsg bottomOffset:220.0 duration:1.5];
        }
        else if (-1 == response.statusCode) {
            strMsg = @"你取消了分享";
            [TLToast showWithText:strMsg bottomOffset:220.0 duration:1.5];
        }
        else if (-2 == response.statusCode){
            strMsg = @"分享信息失败";
            [TLToast showWithText:strMsg bottomOffset:220.0 duration:1.5];
        }

    }
}

#pragma mark -
#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        
    }
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
        NSString *strMsg = nil;
        if (0 == resp.errCode){
            strMsg = @"分享信息成功";
            [TLToast showWithText:strMsg bottomOffset:220.0 duration:1.5];
        }
        else if (-2 == resp.errCode) {
            strMsg = @"你取消了分享";
            [TLToast showWithText:strMsg bottomOffset:220.0 duration:1.5];
        }
        else if (-3 == resp.errCode){
            strMsg = @"分享信息失败";
          [TLToast showWithText:strMsg bottomOffset:220.0 duration:1.5];
        }
        
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = @"支付结果：失败！";
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
//        [alert release];
    }
}


- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark 友盟推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"推送注册成功设备号为%@",deviceTokenStr);
    [[NSUserDefaults standardUserDefaults]setObject:deviceTokenStr forKey:kUDDeviceToken];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您收到一条推送消息"
                                                            message:[NSString stringWithFormat:@"%@", alert]
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"查看",nil];
        alertView.tag = 1001;
        [alertView show];
    } else {
//        [(HomePageViewController *)[[[self.mainVC.viewControllers firstObject] childViewControllers] firstObject] PressBarItemRight];
    }

}



@end
