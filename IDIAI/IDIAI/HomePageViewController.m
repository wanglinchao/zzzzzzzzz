//
//  HomePageViewController.m
//  UTOP
//
//  Created by iMac on 14-11-21.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "HomePageViewController.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "HexColor.h"
#import "util.h"
#import "CityListViewController.h"
#import "MessageListVC.h"
#import "AutomaticLogin.h"
#import "WorkerListViewController.h"
#import "ParallaxHeaderView.h"
#import "MyhouseTypeVC.h"
#import "LoginView.h"
#import "EnterMobileNumView.h"
#import "HostViewController.h"
#import "IDIAIAppDelegate.h"
#import "DesignerHostViewController.h"
#import "KnowledgeViewController.h"
#import "UIImageView+OnlineImage.h"
#import "BannerInfoViewController.h"
#import "TLToast.h"
#import "SMPageControl.h"
#import "UserAgreementViewController.h"
#import "IDIAIAppDelegate.h"
#import "CityListObj.h"
#import "DQAlertView.h"
#import "AsyncImageView.h"
#import "DirectionMPMoviePlayerViewController.h"
#import "MainMessageViewController.h"
#import "GongZhangTuanMainViewController.h"
#import "JianliMainViewController.h"
#import "savelogObj.h"
#import "UIImageView+WebCache.h"
#import "LearnDecorViewController.h"
#import "SCGIFImageView.h"
#import "PersonalInfoViewController.h"
#import "UIImage+GIF.h"
#import "HuoDoneViewController.h"

#import "RZTransitionInteractionControllerProtocol.h"
#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZRectZoomAnimationController.h"
#import "RZTransitionsManager.h"
#import "RZTransitionsNavigationController.h"

#define kbutton_tag 100
#define kimageview_tag 1000
#define kuilable_tag 10000

@interface HomePageViewController ()<UIScrollViewDelegate,CityListDelegate,UIAlertViewDelegate,ParallaxHeaderViewDelegate,LoginViewDelegate,LoginViewDelegate,UIViewControllerTransitioningDelegate,
RZTransitionInteractionControllerDelegate,
RZRectZoomAnimationDelegate> {
    EAIntroView *_intro;
    UIButton *_enterBtn;
    UIButton *_protocolBtn;
    UIButton *_registerBtn;
    UIButton *_loginBtn;
    
    UIControl *_control;
    UIAlertView *_alertView;
    
    int _adCount;//广告某页标记
    UIImageView *_aDIV;//广告imageView
    UIActivityIndicatorView *_activityIndicatorView;//广告等待菊花
    int _adShowTime;//每页广告显示时间
    
    BOOL _isTap;
    int _tapCount;
    int _showCount;
    
}

@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , strong) NSTimer *adTimer;
@property (nonatomic , assign) float lastContentOffset; //判断UITableView的滑动值；
@property (nonatomic,assign)NSInteger dataoldcount;
@property (nonatomic,assign)NSInteger willIndexRow;
@property (nonatomic,assign)NSInteger endIndexRow;
@property (nonatomic, assign) CGPoint                           circleTransitionStartPoint;
@property (nonatomic, assign) CGRect                            transitionCellRect;
@property (nonatomic, strong) RZOverscrollInteractionController *presentOverscrollInteractor;
@property (nonatomic, strong) RZRectZoomAnimationController     *presentDismissAnimationController;
@property (nonatomic, strong) id<RZTransitionInteractionController> presentInteractionController;
@property (nonatomic, strong)UINavigationController *nav;
@end

@implementation HomePageViewController
@synthesize leftButton,rightButton;

- (void)customizeNavigationBar {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:NO animated:NO];
    
    delegate.nav.navigationBar.hidden = NO;
    delegate.nav.navigationBar.translucent = NO;
    
    UIColor *color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[delegate.nav navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    UIColor *color_ = [UIColor colorWithHexString:@"#B5B5B8" alpha:0.7];
    UIImage *image_ = [util imageWithColor:color_];
    delegate.nav.navigationBar.shadowImage = image_;
    
    UIImageView *nav_imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 50, 22)];
    nav_imageV.image=[UIImage imageNamed:@"ico_wtb"];
    self.tabBarController.navigationItem.titleView=nav_imageV;
    
    NSString *cityName_str=[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityName"];

    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 5, 100, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_xjt.png"] forState:UIControlStateNormal];
    [leftButton setTitle:cityName_str forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithHexString:@"#4D4D4D" alpha:1.0] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(15, 50, 10, 40);
    leftButton.titleEdgeInsets=UIEdgeInsetsMake(0, -20, 0, 50);
    leftButton.titleLabel.font=[UIFont systemFontOfSize:16];
    leftButton.titleLabel.textAlignment=NSTextAlignmentLeft;
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    NSMutableDictionary *dic =[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey];
    self.Cityname_location =[dic objectForKey:@"cityName"];
    self.Citycode_location =[dic objectForKey:@"cityCode"];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.tabBarController.navigationItem setLeftBarButtonItem:leftItem];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(5, 5, 80, 40)];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:Is_NewMessage]isEqualToString:@"yes"]){
        [rightButton setImage:[UIImage imageNamed:@"ic_xiaoxi_dian"] forState:UIControlStateNormal];
    }
    else{
        [rightButton setImage:[UIImage imageNamed:@"ic_xiaoxi"] forState:UIControlStateNormal];
    }
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 60, 0, -10);
    [rightButton addTarget:self
                   action:@selector(PressBarItemRight)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self.tabBarController.navigationItem setRightBarButtonItem:rightItem];

}

-(void)PressBarItemLeft{
    CityListViewController *cityVC=[[CityListViewController alloc]init];
    cityVC.delegate=self;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)PressBarItemRight{

    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]){
//    MessageListVC *messagevc=[[MessageListVC alloc]init];
//    messagevc.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:messagevc animated:YES];
        
        MainMessageViewController *mainMsgVC = [[MainMessageViewController alloc]init];
        mainMsgVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:mainMsgVC animated:YES];
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        mainMsgVC.fromVCStr = @"homeVC";
        [delegate.nav pushViewController:mainMsgVC animated:YES];
        
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:Is_NewMessage];
    [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
}

-(void)createTableviewHeader{
    
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(kMainScreenWidth, 70)];
    headerView.delegate=self;
    UIColor *color = [UIColor colorWithHexString:@"#33344D" alpha:1.0];
    UIImage *image = [util imageWithColor:color];
    headerView.headerImage = image;
    [mtableview_main setTableHeaderView:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    _geocodesearch.delegate = nil;
    _locService.delegate=nil;
    
//    view_big.frame = CGRectMake(0, kMainScreenHeight-64-49-30, kMainScreenWidth, kMainScreenHeight-64-49);//解决滑动活动栏同时点击功能模块进入并返回后活动栏位置显示错误问题 huangrun
//    view_big.backgroundColor=[UIColor clearColor];
    [view_big removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    _locService.delegate=self;
    _geocodesearch.delegate = self;
    
    [self showgiftImage];
    [self customizeNavigationBar];
    
    [self createView];
}

-(void)display_view{
    [self performSelectorOnMainThread:@selector(loadfinished) withObject:nil waitUntilDone:YES];
}

-(void)loadfinished{
    if(isOffsetChanged==NO)
        [UIView animateWithDuration:0.5 animations:^{
            mtableview_main.contentOffset=CGPointMake(0, 70);
            isOffsetChanged=YES;
        }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
       //加载引导页
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first_yd"]){
        [self showIntroWithCustomViewFromNib];
    }
    
//根据产品需求取消广告展示
/*********************************************************************************************************
    else  {
        NSDate *currentADDate = [[NSUserDefaults standardUserDefaults]objectForKey:kUDCurrentADDate];
 
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY/MM/dd"];
        NSString *dateSMS = [dateFormatter stringFromDate:currentADDate];
        NSDate *now = [NSDate date];
        NSString *dateNow = [dateFormatter stringFromDate:now];
        _aDIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _aDIV.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapADIV:)];
        _aDIV.userInteractionEnabled = YES;
        [_aDIV addGestureRecognizer:tapGR];
        
        if (kMainScreenHeight == 568) {
            _aDIV.image = [UIImage imageNamed:@"LaunchImage-700-568h"];   //4.0
        } else if (kMainScreenWidth == 375) {
            _aDIV.image = [UIImage imageNamed:@"LaunchImage-800-667h"];   //4.7
        } else if (kMainScreenWidth == 414) {
            _aDIV.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];   //5.5
        }else{
            _aDIV.image=[UIImage imageNamed:@"LaunchImage-700"];    //3.5
        }
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.frame = CGRectMake((kMainScreenWidth - _activityIndicatorView.bounds.size.width)/2, (kMainScreenHeight - _activityIndicatorView.bounds.size.height)/2, _activityIndicatorView.bounds.size.width, _activityIndicatorView.bounds.size.height);
        //[_aDIV addSubview:_activityIndicatorView];
        [_activityIndicatorView startAnimating];
//        [self.tabBarController.view.window addSubview:_aDIV];

        if ([dateSMS isEqualToString:dateNow]) {
            NSLog (@"当天");
            
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first_ad"]) {
                NSLog(@"第一次或不是第一次但当天内未成功请求");
                [self requestADPages];
            } else {
                NSLog(@"不是第一次");
                [_aDIV removeFromSuperview];
            }
        
        } else {
            NSLog (@"不是当天");
            [self requestADPages];
        }
        
        //     dateSMS = [dateFormatter stringFromDate:date];
        [[NSUserDefaults standardUserDefaults]setObject:now forKey:kUDCurrentADDate];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
*********************************************************************************************************/
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registersucceed:) name:@"resgister_succeed" object:nil];
    
    self.dataArray=[NSMutableArray arrayWithCapacity:0];
    self.adDataArray=[NSMutableArray arrayWithCapacity:0];
    
    isOffsetChanged=NO;
    mtableview_main=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-49) style:UITableViewStylePlain];
    mtableview_main.dataSource=self;
    mtableview_main.delegate=self;
    mtableview_main.showsHorizontalScrollIndicator=NO;
    mtableview_main.showsVerticalScrollIndicator=NO;
    mtableview_main.bounces=NO;
    mtableview_main.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mtableview_main];
    
  //  [self createTableviewHeader];
    
//    [self createView];
    
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        _locService = [[BMKLocationService alloc]init];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用"
                                                        message:@"可在“设置->隐私->定位服务”中确认“定位服务”和“屋托邦”是否为开启状态"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    //自动登录
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:User_Name] length] && [[[NSUserDefaults standardUserDefaults]objectForKey:User_Password] length]) {
        [AutomaticLogin Automaticlogin:self];
    }
    
    //检查消息标识

    if(![[[NSUserDefaults standardUserDefaults]objectForKey:Is_NewMessage]isEqualToString:@"yes"]){
        [self checkMessage];
    }
    else{
        self.timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(requestmessge_second) userInfo:nil repeats:YES];
    }
    [NSTimer scheduledTimerWithTimeInterval:1800.0 target:self selector:@selector(requestmessge) userInfo:nil repeats:YES];
    
    [self requestCitylist];
    [self requestDistrictNOlist];
//    self.presentInteractionController = [[RZVerticalSwipeInteractionController alloc] init];
//    [self.presentInteractionController setNextViewControllerDelegate:self];
//    [self.presentInteractionController attachViewController:self withAction:RZTransitionAction_Present];
    
    self.presentDismissAnimationController = [[RZRectZoomAnimationController alloc] init];
    [self.presentDismissAnimationController setRectZoomDelegate:self];
    
    self.circleTransitionStartPoint = CGPointZero;
    self.transitionCellRect = CGRectZero;
    
    [[RZTransitionsManager shared] setAnimationController:self.presentDismissAnimationController
                                       fromViewController:[self class]
                                                forAction:RZTransitionAction_PresentDismiss
     ];
    
    [self setTransitioningDelegate:[RZTransitionsManager shared]];
}
-(void)showgiftImage{
    UIImageView *giftimage =(UIImageView *)[self.view viewWithTag:200000];
    if (giftimage) {
        [giftimage removeFromSuperview];
        giftimage =nil;
    }
    giftimage =[[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-52, Main_Screen_Height-64-49-52, 42, 42)];
    NSMutableArray *giftArray =[NSMutableArray array];
    for (int i=1; i<24; i++) {
        [giftArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"gift%d",i]]];
    }
    giftimage.animationImages = giftArray; //动画图片数组
    giftimage.animationDuration = 2; //执行一次完整动画所需的时长
    giftimage.animationRepeatCount = 0;  //动画重复次数
    [giftimage startAnimating];
    [self.view addSubview:giftimage];
    giftimage.tag =200000;
    giftimage.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActivityAciton:)];
    [giftimage addGestureRecognizer:tap];
}
#pragma mark -
#pragma mark - NSTimer

//检查消息标识(首次启动，当业务地址获得时以后会调用此函数)
-(void)requestmessge{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:Is_NewMessage]isEqualToString:@"yes"]){
        [self checkMessage];
    }
}

//检查消息标识(首次启动，当业务地址没有获得时调用此函数)
-(void)requestmessge_second{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:Is_NewMessage]isEqualToString:@"yes"]){
        [self.timer invalidate];
        self.timer=nil;
        [self checkMessage];
    }
}

//检查是否有新信息标识
-(void)checkMessage{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_date;
        if([[[NSUserDefaults standardUserDefaults] objectForKey:Message_date] length])
        {
            string_date = [[NSUserDefaults standardUserDefaults] objectForKey:Message_date];
        }
        else{
            string_date=@"";
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0005\",\"deviceType\":\"ios\",\"token\":\"\",\"userID\":\"\",\"cityCode\":\"%@\"}&body={\"timeStamp\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],string_date];
        
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                 NSLog(@"消息标识返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (code==10051) {
                        if([[jsonDict objectForKey:@"noticeSign"] integerValue]==1){
                            [rightButton setImage:[UIImage imageNamed:@"ic_xiaoxi_dian"] forState:UIControlStateNormal];
                            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:Is_NewMessage];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                        }
                    }
                    else if (code==10059) {
                    }
                });
                
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
#pragma mark - Others

-(void)createView{
//    ischanged=NO;
//    
//    view_big=[[UIView alloc]initWithFrame:CGRectMake(kMainScreenWidth - 20, 20, kMainScreenWidth, kMainScreenHeight-64-49)];
//    view_big.tag = 3111;
//    view_big.backgroundColor=[UIColor clearColor];
////    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [self.view addSubview:view_big];
//
//    mtableview_sub=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(30, 0,kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
//    mtableview_sub.pullingDelegate=self;
////    mtableview_sub.backgroundColor=[UIColor clearColor];
//        mtableview_sub.backgroundColor=[UIColor whiteColor];
//    mtableview_sub.dataSource=self;
//    mtableview_sub.delegate=self;
//    mtableview_sub.showsHorizontalScrollIndicator=NO;
//    mtableview_sub.showsVerticalScrollIndicator=NO;
//    mtableview_sub.headerOnly=YES;
//    [view_big addSubview:mtableview_sub];
//    
//    UIView *view_arrow=[[UIView alloc]initWithFrame:CGRectMake(0, 0,30, kMainScreenHeight)];
//    view_arrow.backgroundColor=[UIColor clearColor];
//    view_arrow.userInteractionEnabled=YES;
//    [view_big addSubview:view_arrow];
//    
//    UIImageView *im_arrow=[[UIImageView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight/2 - 64,22, 22)];
//    im_arrow.userInteractionEnabled=YES;
//    im_arrow.tag=11;
////    im_arrow.image=[UIImage imageNamed:@"ico_youhua.png"];
//    
//    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"JT_01_.png"],
//                         [UIImage imageNamed:@"JT_02_.png"],
//                         [UIImage imageNamed:@"JT_03_.png"],
//                         [UIImage imageNamed:@"JT_04_.png"],
//                         [UIImage imageNamed:@"JT_05_.png"],
//                         nil];
//    im_arrow.animationImages = gifArray; //动画图片数组
//    im_arrow.animationDuration = 1.5; //执行一次完整动画所需的时长
////    im_arrow.animationRepeatCount = 1;  //动画重复次数
//    [im_arrow startAnimating];
//
//    
//    im_arrow.userInteractionEnabled=YES;
//    [view_arrow addSubview:im_arrow];
//    
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapGesture:)];
//    tap.numberOfTapsRequired=1;
//    tap.numberOfTouchesRequired=1;
//    //[view_big addGestureRecognizer:tap];
//    
//    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(PanGesture:)];
//    pan.maximumNumberOfTouches=5;
//    pan.maximumNumberOfTouches=1;
//    [view_big addGestureRecognizer:pan];
    
//    [mtableview_sub launchRefreshing];
}

//-(void)TapGesture:(UITapGestureRecognizer *)gesture{
//    [UIView animateWithDuration:0.20 animations:^{
//        if(ischanged==NO){
//            view_big.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-49+20);
//        }
//        else{
//            view_big.frame=CGRectMake(0, kMainScreenHeight-64-49-10, kMainScreenWidth, kMainScreenHeight-64-49+20);
//        }
//    }completion:^(BOOL finished){
//        [UIView animateWithDuration:0.08 animations:^{
//            if(ischanged==NO){
//              view_big.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-49+20);
//            }
//            else{
//                view_big.frame=CGRectMake(0, kMainScreenHeight-64-49-20, kMainScreenWidth, kMainScreenHeight-64-49+20);
//            }
//        }completion:^(BOOL finished){
//            ischanged=!ischanged;
//        }];
//    }];
//}
-(void)ActivityAciton:(UITapGestureRecognizer *)gesture{
    
    HuoDoneViewController *designervc=[[HuoDoneViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:designervc];
//    UINavigationController *colorVC = [self newColorVCWithColor];
    self.circleTransitionStartPoint = CGPointMake(Main_Screen_Width-52+21, Main_Screen_Height-64-49-52+21);
    self.transitionCellRect = CGRectMake(Main_Screen_Width-40, Main_Screen_Height-64-49-52+71, 2, 2);
//    colorVC.navigationBar.hidden =YES;
    // Present VC
    [nav setTransitioningDelegate:[RZTransitionsManager shared]];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - RZTransitionInteractorDelegate

- (UIViewController *)nextViewControllerForInteractor:(id<RZTransitionInteractionController>)interactor
{
    
    return [self newColorVCWithColor];
}
#pragma mark - New VC Helper Methods

- (UINavigationController *)newColorVCWithColor
{
//    if (!self.nav) {
        HuoDoneViewController *designervc=[[HuoDoneViewController alloc]init];
        self.nav =[[UINavigationController alloc] initWithRootViewController:designervc];
        // Present VC
        [self.nav setTransitioningDelegate:[RZTransitionsManager shared]];
//    }
    
    // TODO: Hook up next VC's dismiss transition
    return self.nav;
}
#pragma mark - RZRectZoomAnimationDelegate

- (CGRect)rectZoomPosition
{
    return self.transitionCellRect;
}

#pragma mark - RZCirclePushAnimationDelegate

- (CGPoint)circleCenter
{
    return self.circleTransitionStartPoint;
}

- (CGFloat)circleStartingRadius
{
    return 44;
}
//-(void)PanGesture:(UIPanGestureRecognizer *)gesture{
//    [savelogObj saveLog:@"查看活动列表" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:32];
//    
//    static BOOL is_uping=NO;
//    switch (gesture.state) {
//        case UIGestureRecognizerStateBegan:
//        {
//            NSLog(@"======UIGestureRecognizerStateBegan");
//            break;
//        }
//        case UIGestureRecognizerStateChanged:
//        {
//            /*
//             让view_big跟着手指移动
//             1.获取每次系统捕获到的手指移动的偏移量translation
//             2.根据偏移量translation算出当前view_big应该出现的位置
//             3.设置view_big的新frame
//             4.将translation重置为0（十分重要。一旦你完成上述的移动,否则translation每次都会叠加，很快你的view_big就会移除屏幕！）
//             */
//            CGPoint translation_ = [gesture translationInView:view_big];
//            if(translation_.x<0.0) {
//                is_uping=YES;
//                ischanged=NO;
//                view_big.backgroundColor=[UIColor clearColor];
//            }
//            else if(translation_.x>0.0){
//                is_uping=NO;
//                ischanged=YES;
//            }
//            
//            if(view_big.frame.origin.x>=0){
//                CGPoint translation = [gesture translationInView:view_big];
////                view_big.center = CGPointMake(view_big.center.x , gesture.view.center.y + translation.y);
//                view_big.center = CGPointMake(gesture.view.center.x + translation.x, view_big.center.y);
//                [gesture setTranslation:CGPointMake(0, 0) inView:view_big];
//                
////                float fa =fabs(gesture.view.center.x + translation.x-[UIScreen mainScreen].bounds.size.width/2);
//////                NSLog(@"%f",fa/[UIScreen mainScreen].bounds.size.width*[UIScreen mainScreen].scale);
////                IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
////                UIView *contai =[[delegate.window subviews] objectAtIndex:0];
////                contai.alpha =fa/[UIScreen mainScreen].bounds.size.width;
//////                NSLog(@"%@",[contai subview]);
////                if (fa/([UIScreen mainScreen].bounds.size.width)>0.8) {
////                    contai.frame =CGRectMake(([UIScreen mainScreen].bounds.size.width-contai.frame.size.width)/2, ([UIScreen mainScreen].bounds.size.height-contai.frame.size.height)/2, [UIScreen mainScreen].bounds.size.width*(fa/([UIScreen mainScreen].bounds.size.width)), [UIScreen mainScreen].bounds.size.height*(fa/([UIScreen mainScreen].bounds.size.width)));
////                }
//                
//                
////                const CGFloat viewWidth = view_big.frame.size.width;
//                
////                CABasicAnimation * inSwipeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
////                inSwipeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
////                inSwipeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(viewWidth, 0.0f, 0.0f)];
////                CABasicAnimation * inPositionAnimation = [CABasicAnimation animationWithKeyPath:@"zPosition"];
////                inPositionAnimation.fromValue = @-0.001;
////                inPositionAnimation.toValue = @-0.001;
////                inPositionAnimation.duration = 0.5;
////                
////                CAAnimationGroup * inAnimation = [CAAnimationGroup animation];
////                inAnimation.animations = @[inSwipeAnimation, inPositionAnimation];
////                inAnimation.duration = 0.5;
//                
////                CABasicAnimation * outOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
////                outOpacityAnimation.fromValue = @1.0f;
////                outOpacityAnimation.toValue = @0.0f;
////                
////                CABasicAnimation * outPositionAnimation = [CABasicAnimation animationWithKeyPath:@"zPosition"];
////                outPositionAnimation.fromValue = [NSNumber numberWithFloat:-(gesture.view.center.x + translation.x)/[UIScreen mainScreen].bounds.size.width];
////                outPositionAnimation.toValue = [NSNumber numberWithFloat:-(gesture.view.center.x + translation.x)/[UIScreen mainScreen].bounds.size.width];
////                outPositionAnimation.duration = 0.5;
////                
////                CABasicAnimation * outScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
////                outScaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
////                outScaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale((gesture.view.center.x + translation.x)/[UIScreen mainScreen].bounds.size.width, (gesture.view.center.x + translation.x)/[UIScreen mainScreen].bounds.size.width, 1.0f)];
////                outScaleAnimation.duration = 0.5;
////                
////                CAAnimationGroup * outAnimation = [CAAnimationGroup animation];
////                [outAnimation setAnimations:@[outOpacityAnimation, outPositionAnimation, outScaleAnimation]];
////                outAnimation.duration = 0.5;
////                
////                UIView * containerView = view_big;
////                UIView * fromView = mtableview_main;
////                //            UIView * toView = mtableview_sub;
////                
////                CATransform3D sublayerTransform = CATransform3DIdentity;
////                sublayerTransform.m34 = 1.0 / -1000.0f;
////                containerView.layer.sublayerTransform = sublayerTransform;
//                
//                //            UIView * wrapperView = [[UIView alloc] initWithFrame:fromView.frame];
//                //            wrapperView.backgroundColor =[UIColor purpleColor];
//                //            fromView.frame = fromView.bounds;
//                //            toView.frame = toView.bounds;
//                
//                //            wrapperView.autoresizesSubviews = YES;
//                //            wrapperView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//                //            [wrapperView addSubview:fromView];
//                //            [wrapperView addSubview:toView];
//                //            [containerView addSubview:wrapperView];
//                
//                //            toView.layer.doubleSided = NO;
//                //            fromView.layer.doubleSided = NO;
//                //            fromView.layer.shouldRasterize = YES;
//                //            toView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//                
//                //            [CATransaction setCompletionBlock:^{
//                //                fromView.layer.shouldRasterize = NO;
//                //                toView.layer.shouldRasterize = NO;
//                //                toView.layer.transform = CATransform3DIdentity;
//                //                fromView.layer.transform = CATransform3DIdentity;
//                //                containerView.layer.transform = CATransform3DIdentity;
//                //                
//                //                UIView * contextView = view_big;
//                //                fromView.frame = containerView.frame;
//                //                [contextView addSubview:fromView];
//                //                toView.frame = containerView.frame;
//                //                [contextView addSubview:toView];
//                //            }];
//                
//                //            [toView.layer addAnimation:inAnimation forKey:nil];
////                [fromView.layer addAnimation:outAnimation forKey:nil];
//            }
//            break;
//
//        }
//        case UIGestureRecognizerStateCancelled:
//        {
//            NSLog(@"======UIGestureRecognizerStateCancelled");
//            break;
//        }
//        case UIGestureRecognizerStateFailed:
//        {
//            NSLog(@"======UIGestureRecognizerStateFailed");
//            break;
//        }
//        case UIGestureRecognizerStatePossible:
//        {
//            NSLog(@"======UIGestureRecognizerStatePossible");
//            break;
//        }
//        case UIGestureRecognizerStateEnded:
//        {
//            /*
//             当手势结束后，view的减速缓冲效果
//             写的一个很简单的方法。它遵循如下策略：
//             计算速度向量的长度（i.e. magnitude）
//             如果长度小于200，则减少基本速度，否则增加它。
//             基于速度和滑动因子计算终点
//             确定终点在视图边界内
//             让视图使用动画到达最终的静止点
//             使用“Ease out“动画参数，使运动速度随着时间降低
//             */
//            //            CGPoint velocity = [gesture velocityInView:view_big];// 分别得出x，y轴方向的速度向量长度（velocity代表按照当前速度，每秒可移动的像素个数，分xy轴两个方向）
//            //            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));// 根据直角三角形的算法算出综合速度向量长度
//            //
//            //            // 如果长度小于200，则减少基本速度，否则增加它。
//            //            CGFloat slideMult = magnitude / 200;
//            //
//            //            NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
//            //            float slideFactor = 0.1 * slideMult; // Increase for more of a slide
//            //
//            //            // 基于速度和滑动因子计算终点
//            //            CGPoint finalPoint = CGPointMake(view_big.center.x,
//            //                                             view_big.center.y + (velocity.y * slideFactor));
//            //
//            //            // 确定终点在视图边界内
//            //            finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
//            //            finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
//            
//            
//            UIImageView *imv=(UIImageView *)[view_big viewWithTag:11];
//            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                if(is_uping){
////                    view_big.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-49+30);
//                    view_big.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-49);
////                    imv.image=[UIImage imageNamed:@"ico_youhua.png"];
//                    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"JT_01_.png"],
//                                         [UIImage imageNamed:@"JT_02_.png"],
//                                         [UIImage imageNamed:@"JT_03_.png"],
//                                         [UIImage imageNamed:@"JT_04_.png"],
//                                         [UIImage imageNamed:@"JT_05_.png"],
//                                         nil];
//                    imv.animationImages = gifArray; //动画图片数组
//                    imv.animationDuration = 1.5; //执行一次完整动画所需的时长
////                    imv.animationRepeatCount = 1;  //动画重复次数
//                    [imv startAnimating];
//
//
//                    view_big.backgroundColor=[UIColor clearColor];
//                    mtableview_sub.frame = CGRectMake(0, 0,kMainScreenWidth, kMainScreenHeight-64-49);
////                    [self.tabBarController.navigationController setNavigationBarHidden:YES animated:YES];
//                    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
//                    UIView *contai =[[delegate.window subviews] objectAtIndex:0];
//                    contai.alpha =1.0;
//                    //                NSLog(@"%@",[contai subview]);
//                    contai.frame =CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//                }
//                else {
//                    view_big.frame=CGRectMake(kMainScreenWidth - 20, 0, kMainScreenWidth, kMainScreenHeight-64-49);
////                    imv.image=[UIImage imageNamed:@"ico_youhua.png"];
//                    
//                    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"JT_01_.png"],
//                                         [UIImage imageNamed:@"JT_02_.png"],
//                                         [UIImage imageNamed:@"JT_03_.png"],
//                                         [UIImage imageNamed:@"JT_04_.png"],
//                                         [UIImage imageNamed:@"JT_05_.png"],
//                                         nil];
//                    imv.animationImages = gifArray; //动画图片数组
//                    imv.animationDuration = 1.5; //执行一次完整动画所需的时长
////                    imv.animationRepeatCount = 1;  //动画重复次数
//                    [imv startAnimating];
//
//                    //                NSLog(@"%f",fa/[UIScreen mainScreen].bounds.size.width*[UIScreen mainScreen].scale);
//                    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
//                    UIView *contai =[[delegate.window subviews] objectAtIndex:0];
//                    contai.alpha =1.0;
//                    //                NSLog(@"%@",[contai subview]);
//                    contai.frame =CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//                }
//            } completion:^(BOOL finised){
//                [UIView animateWithDuration:0.08 animations:^{
//                    if(is_uping){
//                        view_big.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-49);
////                        imv.image=[UIImage imageNamed:@"ico_youhua.png"];
////                        imv.transform=CGAffineTransformMakeRotation(M_PI);
//                        NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"JT_01_.png"],
//                                             [UIImage imageNamed:@"JT_02_.png"],
//                                             [UIImage imageNamed:@"JT_03_.png"],
//                                             [UIImage imageNamed:@"JT_04_.png"],
//                                             [UIImage imageNamed:@"JT_05_.png"],
//                                             nil];
//                        imv.animationImages = gifArray; //动画图片数组
//                        imv.animationDuration = 1.5; //执行一次完整动画所需的时长
////                        imv.animationRepeatCount = 1;  //动画重复次数
//                        [imv startAnimating];
//                        imv.transform = CGAffineTransformMakeRotation(M_PI);
//                        
//                        view_big.backgroundColor=[UIColor clearColor];
//                        mtableview_sub.frame = CGRectMake(0, 0,kMainScreenWidth, kMainScreenHeight);
//                        [self.view setNeedsLayout];
//                        [self.tabBarController.navigationController setNavigationBarHidden:YES animated:YES];
//                        self.navigationController.tabBarController.tabBar.alpha =0;
////                        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
////                        UIView *contai =[[delegate.window subviews] objectAtIndex:0];
////                        contai.alpha =1.0;
////                        //                NSLog(@"%@",[contai subview]);
////                        contai.frame =CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//                    }
//                    else {
//                        view_big.frame=CGRectMake(kMainScreenWidth - 20, 0, kMainScreenWidth, kMainScreenHeight-64-49);
////                        imv.image=[UIImage imageNamed:@"ico_youhua.png"];
////                        imv.transform=CGAffineTransformMakeRotation(M_PI*2);
//                        NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"JT_01_.png"],
//                                             [UIImage imageNamed:@"JT_02_.png"],
//                                             [UIImage imageNamed:@"JT_03_.png"],
//                                             [UIImage imageNamed:@"JT_04_.png"],
//                                             [UIImage imageNamed:@"JT_05_.png"],
//                                             nil];
//                        imv.animationImages = gifArray; //动画图片数组
//                        imv.animationDuration = 1.5; //执行一次完整动画所需的时长
////                        imv.animationRepeatCount = 1;  //动画重复次数
//                        [imv startAnimating];
//                        imv.transform = CGAffineTransformMakeRotation(M_PI *2);
//                        
//                        view_big.backgroundColor=[UIColor clearColor];
//                        mtableview_sub.frame = CGRectMake(20, 0,kMainScreenWidth + 20, kMainScreenHeight);
//                        [self.tabBarController.navigationController setNavigationBarHidden:NO animated:YES];
//                        self.navigationController.tabBarController.tabBar.alpha =1;
////                        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
////                        UIView *contai =[[delegate.window subviews] objectAtIndex:0];
////                        contai.alpha =1.0;
////                        //                NSLog(@"%@",[contai subview]);
////                        contai.frame =CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//                    }
//
//                }completion:^(BOOL finished){
//                    
//                }];
//            }];
//            
//            break;
//        }
//        default:{
//            NSLog(@"======Unknow gestureRecognizer");
//            break;
//        }
//    }
//}

//#pragma mark -
//#pragma mark - Request
//
////请求活动列表
//-(void)requestBannerlist{
//   // if([self.dataArray count]) [self.dataArray removeAllObjects];
//    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(parsingQueue, ^{
//        
//        NSString *string_token=@"";
//        NSString *string_userid=@"";
//        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
//            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
//            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
//        }
//        else{
//            string_token=@"";
//            string_userid=@"";
//        }
//        
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0040\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
//        
//        NetworkRequest *req = [[NetworkRequest alloc] init];
//        req.isCacheRequest=YES;
//        [req setHttpMethod:GetMethod];
//        
//        [req sendToServerInBackground:^{
//            dispatch_async(parsingQueue, ^{
//                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
//                [request setResponseEncoding:NSUTF8StringEncoding];
//                NSString *respString = [request responseString];
//                NSDictionary *jsonDict = [respString objectFromJSONString];
//                NSLog(@"活动返回信息：%@",jsonDict);
//                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
//                if (code==10401) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if([self.dataArray count])
//                            [self.dataArray removeAllObjects];
//                        NSArray *arr_=[jsonDict objectForKey:@"bannerList"];
//                        if([arr_ count]){
//                            for(NSDictionary *dict in arr_){
////                                if([[dict objectForKey:@"bannerWay"] integerValue]==2)
//                                    [self.dataArray addObject:dict];
////                                else continue;
//                            }
//                        }
//                        
//                        [mtableview_sub reloadData];
//                        [mtableview_sub tableViewDidFinishedLoading];
//            
//                    });
//                }
//                else{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [mtableview_sub tableViewDidFinishedLoading];
//
//                    });
//                }
//            });
//        }
//                          failedBlock:^{
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  [mtableview_sub tableViewDidFinishedLoading];
//                              });
//                          }
//                               method:url postDict:nil];
//    });
//    
//    
//}

//请求城市列表
-(void)requestCitylist{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0041\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"城市列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10411) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSArray *arr_=[jsonDict objectForKey:@"cityList"];
                        NSMutableArray *data_=[NSMutableArray arrayWithCapacity:0];
                        if ([arr_ count]) {
                            for(NSDictionary *dict in arr_){
                                [data_ addObject:[CityListObj objWithDict:dict]];
                            };
                        }
                        
                        IDIAIAppDelegate *delegate_=(IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                        delegate_.array_city_list=data_;
                        
                       if([delegate_.array_city_list count]) [_locService startUserLocationService];
                       else [_locService stopUserLocationService];
                        
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
                               method:url postDict:nil];
    });
    
    
}

//请求当前城市下区县列表
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
                NSLog(@"行政区号：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10421) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *arr_=[jsonDict objectForKey:@"countyList"];
                        IDIAIAppDelegate *delegate_=(IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                        delegate_.array_area_list=arr_;
                    });
                }
                else if (code==10429) {
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
                               method:url postDict:nil];
    });
    
}

#pragma mark -
#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(tableView==mtableview_main) {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 20)];
    view.backgroundColor=[UIColor clearColor];
    return view;
    }
    else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.1)];
        view.backgroundColor=[UIColor clearColor];
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(tableView==mtableview_main) return 0.1f;
    else return 15.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(tableView==mtableview_main) return (kMainScreenHeight-64-49)/3;

    else return 200;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==mtableview_main) return 3;
    else return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView==mtableview_main) return 1;
    else return [self.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==mtableview_main){
    NSString *cellid=[NSString stringWithFormat:@"cellid_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if(indexPath.row==0){
        cell.backgroundColor=[UIColor colorWithHexString:@"#F0B236" alpha:1.0];
        UIImage *left=[UIImage imageNamed:@"ico_sheji"];
        UIImageView *imv_left = (UIImageView *)[cell viewWithTag:10001];
        if (imv_left == nil)
        imv_left=[[UIImageView alloc]initWithFrame:CGRectMake(25, ((kMainScreenHeight-64-49)/3-left.size.height)/2, left.size.width, left.size.height)];
        imv_left.tag = 10001;
        imv_left.image=[UIImage imageNamed:@"ico_sheji"];
        [cell addSubview:imv_left];
        
        UIImageView *imv_right = (UIImageView *)[cell viewWithTag:10002];
        if (imv_right == nil)
        imv_right =[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-125, ((kMainScreenHeight-64-49)/3-20)/2, 80, 20)];
        imv_right.tag = 10002;
        imv_right.image=[UIImage imageNamed:@"ic_sheji_"];
        [cell addSubview:imv_right];
        
        UIImageView *cell1IV = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-115, (kMainScreenHeight-64-49)/3-6, 75, 6)];
        cell1IV.image = [UIImage imageNamed:@"bg_biaoqian_cailiaohui"];
        [cell addSubview:cell1IV];
    }
    else if(indexPath.row==1) {
        cell.backgroundColor=[UIColor colorWithHexString:@"#12B1A5" alpha:1.0];
    //    UIImage *left=[UIImage imageNamed:@"ic_gongzhang_.png"];
        UIImageView *imv_left = (UIImageView *)[cell viewWithTag:10001];
        imv_left=[[UIImageView alloc]initWithFrame:CGRectMake(45, ((kMainScreenHeight-64-49)/3-20)/2, 60, 20)];
        imv_left.tag = 10001;
        imv_left.image=[UIImage imageNamed:@"ic_gongzhang_.png"];
        [cell addSubview:imv_left];
        
        UIImageView *imv_right = (UIImageView *)[cell viewWithTag:10002];
        UIImage *right=[UIImage imageNamed:@"ico_xiaogeng"];
        imv_right=[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-135, ((kMainScreenHeight-64-49)/3-right.size.height)/2, right.size.width, right.size.height)];
        imv_right.tag = 10002;
        imv_right.image=[UIImage imageNamed:@"ico_xiaogeng"];
        [cell addSubview:imv_right];
        
        UIImageView *cell1IV = [[UIImageView alloc]initWithFrame:CGRectMake(40, (kMainScreenHeight-64-49)/3-6, 75, 6)];
        cell1IV.image = [UIImage imageNamed:@"bg_biaoqian_gzt"];
        [cell addSubview:cell1IV];
    }
    else if(indexPath.row==2) {
        cell.backgroundColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
        UIImage *left=[UIImage imageNamed:@"ico_xuanjianli.png"];
        UIImageView *imv_left = (UIImageView *)[cell viewWithTag:10001];
        imv_left=[[UIImageView alloc]initWithFrame:CGRectMake(25, ((kMainScreenHeight-64-49)/3-left.size.height)/2,  left.size.width,  left.size.height)];
        imv_left.tag = 10001;
        imv_left.image=[UIImage imageNamed:@"ico_xuanjianli.png"];
        [cell addSubview:imv_left];
        
        UIImageView *imv_right = (UIImageView *)[cell viewWithTag:10002];
        imv_right=[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-110, ((kMainScreenHeight-64-49)/3-20)/2, 60, 20)];
        imv_right.tag = 10002;
        imv_right.image=[UIImage imageNamed:@"ic_jianli_.png"];
        [cell addSubview:imv_right];

        }
    return cell;
    }
    else{
         NSString *cellid=[NSString stringWithFormat:@"cell_smallid%ld_%ld",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
           // cell.backgroundColor=[UIColor clearColor];
        }
        if([self.dataArray count]){
        UIImageView *banner=(UIImageView *)[cell.contentView viewWithTag:kimageview_tag+indexPath.section];
        if(!banner) {
            banner=[[UIImageView alloc]initWithFrame:CGRectMake(0, -2, kMainScreenWidth, 200)];
            banner.image=[UIImage imageNamed:@"bg_morentu_xq"];
        }
        banner.tag=kimageview_tag+indexPath.section;
        banner.clipsToBounds = YES;
        banner.contentMode=UIViewContentModeRedraw;
        [cell.contentView addSubview:banner];

        dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(parsingQueue, ^{
            UIImage *img;
            if([[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"] length]>1){
//                NSLog(@"banner ==========%@",[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"] substringFromIndex:([[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"] length]-3)]);
//                NSLog(@"%d",[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"] length]-3)]);
                if ([[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"] substringFromIndex:([[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"] length]-3)] isEqualToString:@"gif"]) {
                    img =[UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"]]]];
                }else{
                    img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"]]]];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if(img.size.height) banner.image=img;
            });
        });
        
        UILabel *theme=(UILabel *)[cell.contentView viewWithTag:kuilable_tag+indexPath.section];
//        if(!theme) theme=[[UILabel alloc]initWithFrame:CGRectMake(10, 170, kMainScreenWidth-20, 20)];
            if(!theme) theme=[[UILabel alloc]initWithFrame:CGRectMake(10, 170, kMainScreenWidth-20, 20)];//新需求 上移
        theme.tag=kuilable_tag+indexPath.section;
        theme.textAlignment=NSTextAlignmentLeft;
        theme.font=[UIFont systemFontOfSize:15];
        theme.textColor=[UIColor blackColor];

        if(![[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerName"]isEqual:[NSNull null]])
            theme.text=[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerName"];
        else
            theme.text=@"";
        [cell.contentView addSubview:theme];
            
        if([[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerType"] integerValue]==2){
            UIButton *btn_video=(UIButton *)[cell.contentView viewWithTag:kuilable_tag*2+indexPath.section];
            if(!btn_video) btn_video=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 160)];
            btn_video.tag=kuilable_tag*2+indexPath.section;
            [btn_video setImage:[UIImage imageNamed:@"ic_bofang"] forState:UIControlStateNormal];
            [btn_video setImage:[UIImage imageNamed:@"ic_bofang_pressed"] forState:UIControlStateHighlighted];
            [btn_video addTarget:self action:@selector(PlayVideo:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn_video];
          }
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==mtableview_main){
        if (indexPath.row==0) {
            
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
            DesignerHostViewController *designervc=[[DesignerHostViewController alloc]init];
            designervc.hidesBottomBarWhenPushed=YES;
            [appDelegate.nav pushViewController:designervc animated:YES];
        }
        else if(indexPath.row==1){
            GongZhangTuanMainViewController *gongzhangtuanMVC = [[GongZhangTuanMainViewController alloc]init];
            gongzhangtuanMVC.hidesBottomBarWhenPushed = YES;
            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.nav pushViewController:gongzhangtuanMVC animated:YES];
        }
        else if (indexPath.row==2){
//            SupervisorViewController *supervisorVC = [[SupervisorViewController alloc]init];
            JianliMainViewController *supervisorVC = [[JianliMainViewController alloc]init];
            supervisorVC.hidesBottomBarWhenPushed = YES;
            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.nav pushViewController:supervisorVC animated:YES];
        } 
      
    }
    else{
        if([[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"isValid"] integerValue]==1){
            if([[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerType"] integerValue]==1){
                if(![[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerDetailUrl"] isEqual:[NSNull null]]){
                    BannerInfoViewController *bannervc=[[BannerInfoViewController alloc]init];
                    bannervc.url=[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerDetailUrl"];
                    bannervc.hidesBottomBarWhenPushed=YES;
                    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
                    [self.tabBarController.navigationController setNavigationBarHidden:NO animated:YES];
                    self.navigationController.tabBarController.tabBar.alpha =1;
                    UIView *contai =[[appDelegate.window subviews] objectAtIndex:0];
                    [appDelegate.window bringSubviewToFront:contai];
                    [appDelegate.nav pushViewController:bannervc animated:YES];
                }
                else{
                   [TLToast showWithText:@"亲，暂时无活动详情" topOffset:200.0f duration:1.5];
                }
            }
            else{
//                DirectionMPMoviePlayerViewController *playerView = [[DirectionMPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerDetailUrl"]]];
//                playerView.view.frame = self.view.frame;//全屏播放（全屏播放不可缺）
//                playerView.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;//全屏播放（全屏播放不可缺）
//                [[NSNotificationCenter defaultCenter] addObserver:self
//                                                         selector:@selector(myMovieFinishedCallback:)
//                                                             name:MPMoviePlayerPlaybackDidFinishNotification
//                                                           object:playerView];
//                [playerView.moviePlayer play];
//                [self presentMoviePlayerViewControllerAnimated:playerView];
            }
        }
        else{
            [TLToast showWithText:@"亲，此活动已结束" topOffset:200.0f duration:1.5];
        }
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView!=mtableview_main) {
        UIImageView *banner=(UIImageView *)[cell.contentView viewWithTag:kimageview_tag+indexPath.section];
        float oldY =banner.frame.origin.y;
        float width = banner.frame.size.width;
        float height = banner.frame.size.height;
        NSLog(@"%lu",(unsigned long)self.dataArray.count);
        NSLog(@"will =%ld",(long)indexPath.section);
        //    if (indexPath.section!=dataArray.count-16) {
        
        
        //    if (self.isrequst ==NO) {
        if (self.dataoldcount==self.dataArray.count) {
            NSInteger max =MAX(self.willIndexRow, self.endIndexRow);
            NSInteger min =MIN(self.willIndexRow, self.endIndexRow);
            if (min ==0&&max==0) {
                min =0;
                if ((int)Main_Screen_Height%200>0) {
                    max =Main_Screen_Height/200-2;
                }else {
                    max =Main_Screen_Height/200-1;
                }
            }
            if (indexPath.section>max||indexPath.section<min) {
                
                banner.frame =CGRectMake(banner.frame.size.width/2-(Main_Screen_Width-20)/2, banner.frame.origin.y+banner.frame.size.height/2-(banner.frame.size.height-50)/2, Main_Screen_Width-20, banner.frame.size.height-50);
                [UIView beginAnimations:@"showcell" context:NULL];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDuration:0.3];
                banner.frame =CGRectMake(0, oldY, width, height);
                [UIView commitAnimations];
                self.willIndexRow =indexPath.section;
            }
            
        }
        if (indexPath.section<self.dataArray.count) {
            self.dataoldcount =self.dataArray.count;
        }
        
        //    }
        
        //    }
    }
    
    
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    //    float oldY =cell.frame.origin.y;
    //    float width = cell.frame.size.width;
    //    float height = cell.frame.size.height;
    NSLog(@"End=%ld",(long)indexPath.section);
    self.endIndexRow =indexPath.section;
    //    if (indexPath.section>self.endIndexRow) {
    //        cell.frame =CGRectMake(cell.frame.size.width/2, cell.frame.origin.y+cell.frame.size.height/2, 50, 50);
    //        [UIView beginAnimations:@"showcell" context:NULL];
    //        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //        [UIView setAnimationDelegate:self];
    //        [UIView setAnimationDuration:0.25];
    //        cell.frame =CGRectMake(0, oldY, width+20, height);
    //        [UIView commitAnimations];
    //    }
}
-(void)PlayVideo:(UIButton *)btn{
    
    DirectionMPMoviePlayerViewController *playerView = [[DirectionMPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:btn.tag-kuilable_tag*2] objectForKey:@"bannerDetailUrl"]]];
    playerView.view.frame = self.view.frame;//全屏播放（全屏播放不可缺）
    playerView.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;//全屏播放（全屏播放不可缺）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerView];
    [playerView.moviePlayer play];
    [self presentMoviePlayerViewControllerAnimated:playerView];
}


// When the movie is done, release the controller.
-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    DirectionMPMoviePlayerViewController* theMovie = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    
    [theMovie removeFromParentViewController];
}

//#pragma mark -
//#pragma mark - PullingRefreshTableViewDelegate
//
////加载数据方法
//- (void)loadData
//{
//    [self requestBannerlist];
//}
//
////下拉刷新
//- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
//    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
//    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
//}
//
////刷新完成时间
//- (NSDate *)pullingTableViewRefreshingFinishedDate{
//    //NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
//    //创建一个NSDataFormatter显示刷新时间
//    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
//    df.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSString *dateStr = [df stringFromDate:[NSDate date]];
//    NSDate *date = [df dateFromString:dateStr];
//    return date;
//}
//
////上拉加载  Implement this method if headerOnly is false
//- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
//    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
//    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
//}

#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView ==mtableview_main)
    {
//        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
//        [(ParallaxHeaderView *)mtableview_main.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
    else{
//    if (mtableview_sub.contentOffset.y<-60) {
//        mtableview_sub.reachedTheEnd = NO;  //是否加载到底了
//    }
//    //手指开始拖动方法
    [mtableview_sub tableViewDidScroll:scrollView];
    }
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView==mtableview_sub) {
       [mtableview_sub tableViewDidEndDragging:scrollView];
    }
//    }else{
//       if (scrollView.contentOffset.y<self.lastContentOffset){
//           
//           [UIView animateWithDuration:0.5 animations:^{
////               mtableview_main.contentOffset=CGPointMake(0, 0);//暂时禁用 20150320
//       }];
//        [(ParallaxHeaderView *)mtableview_main.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
//       //向上
//       }
//       else if (scrollView.contentOffset.y>self.lastContentOffset){
//           [UIView animateWithDuration:0.5 animations:^{
////               mtableview_main.contentOffset=CGPointMake(0, 70); //暂时禁用 huangrun
//           }];
//           [(ParallaxHeaderView *)mtableview_main.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
//        //向下
//       }
//   }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//   if(scrollView==mtableview_main)
//   self.lastContentOffset = scrollView.contentOffset.y;
//    
}

#pragma mark -
#pragma mark - ParallaxHeaderViewDelegate

-(void)deselectedItem:(NSInteger)index_selected{
//    if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]){
//        LoginVC *loginvc=[[LoginVC alloc] init];
//        loginvc.delegate=self;
//        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:loginvc];
//        [self presentViewController:nav animated:YES completion:nil];
//    }
//    else{
    
        if (index_selected==0) {
            HostViewController *hostVC = [[HostViewController alloc]init];
            hostVC.hidesBottomBarWhenPushed = YES;
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
            [appDelegate.nav pushViewController:hostVC animated:YES];
            //            [self.navigationController pushViewController:hostVC animated:YES];
        } else if (index_selected==1) {
            KnowledgeViewController *knowledgeVC = [[KnowledgeViewController alloc]init];
            knowledgeVC.hidesBottomBarWhenPushed = YES;
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
            [appDelegate.nav pushViewController:knowledgeVC animated:YES];
        } else if (index_selected == 2) {
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]) {
                LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                login.delegate=self;
                [login show];
                return;
            }

            MyhouseTypeVC *myHouseTypeVC = [[MyhouseTypeVC alloc]init];
            myHouseTypeVC.hidesBottomBarWhenPushed = YES;
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
            [appDelegate.nav pushViewController:myHouseTypeVC animated:YES];
        } else {
            
        }
//    }
}

#pragma mark -
#pragma mark - CityListDelegate

-(void)didSelectedCity:(CityListObj *)obj{
    if (![obj.cityName isEqualToString:self.self.Cityname_location] && self.self.Cityname_location) {
        [self dismissViewControllerAnimated:YES completion:^{
            if(obj){
                self.Citycode_location=obj.cityCode;
                self.Cityname_location =obj.cityName;
                UIAlertView *alerv=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"是否切换当前城市为%@",obj.cityName] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                alerv.tag =100000;
                [alerv show];
                
            }
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            self.Citycode_location=obj.cityCode;
            self.Cityname_location =obj.cityName;
            [leftButton setTitle:self.Cityname_location forState:UIControlStateNormal];
            
            [[NSUserDefaults standardUserDefaults] setObject:@{@"cityName":self.Cityname_location,@"cityCode":self.Citycode_location} forKey:cityCodeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self requestDistrictNOlist];
        }];
        
    }
}

#pragma mark -
#pragma mark - LoginDelegate

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict{
   // NSLog(@"登录回调函数：%d",buttonIndex);
    if(self.view.tag==1){
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:Is_NewMessage];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [rightButton setImage:[UIImage imageNamed:@"ic_xiaoxi"] forState:UIControlStateNormal];
            MainMessageViewController *mainMsgVC = [[MainMessageViewController alloc]init];
            mainMsgVC.hidesBottomBarWhenPushed = YES;
            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.nav pushViewController:mainMsgVC animated:YES];
        }];
    }
    else if (self.view.tag==2){
        if(kUrlLearnDecorate){
            LearnDecorViewController *learnVC=[[LearnDecorViewController alloc]init];
            learnVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:learnVC animated:NO];
        }
    }
    [_intro hideWithFadeOutDuration:1];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_yd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //huangrun
    [self performSelector:@selector(dismissLoginVC) withObject:nil afterDelay:.5];
}

- (void)dismissLoginVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - BMKGeoCodeSearchDelegate

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        [_locService stopUserLocationService];
        
        self.Cityname_location =[NSString stringWithFormat:@"%@",result.addressDetail.city];
        NSLog(@"%@",self.Cityname_location);
        //将定位城市与开通城市比较
        IDIAIAppDelegate *delegate_=(IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        if([delegate_.array_city_list count]){
            BOOL is_city_kt=NO;
            for(CityListObj *obj in delegate_.array_city_list){
                if([obj.cityName isEqualToString:self.Cityname_location]) {
                    is_city_kt=YES;
                    if(![[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityName"] isEqualToString:self.Cityname_location]){
                        self.Citycode_location=obj.cityCode;
                        UIAlertView *alerv=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"已定位到您当前所在城市为%@，是否切换？",self.Cityname_location] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                        alerv.tag =100000;
                        [alerv show];
                    }
                    break;
                }
                else continue;
            }

            if(is_city_kt==NO){
                UIAlertView *alerv=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"当前定位“%@”暂未开通“屋托邦”，默认切换为成都",self.Cityname_location] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alerv.tag =100000;
                [alerv show];
                [[NSUserDefaults standardUserDefaults] setObject:@{@"cityName":@"成都市",@"cityCode":@"510100"} forKey:cityCodeKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [leftButton setTitle:@"成都市" forState:UIControlStateNormal];
            }
        }
        else{
            [self requestCitylist];
        }
    }
    else{
      [_locService stopUserLocationService];  
    }
}

#pragma mark -
#pragma mark - BMKLocationServiceDelegate

-(void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
      if (userLocation.location.coordinate.latitude >0 && userLocation.location.coordinate.longitude >0) {
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
        BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag) NSLog(@"反geo检索发送成功");
        else NSLog(@"反geo检索发送失败");
    }
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==100000) {
        if (buttonIndex!=alertView.cancelButtonIndex) {
            [leftButton setTitle:self.Cityname_location forState:UIControlStateNormal];
            
            [[NSUserDefaults standardUserDefaults] setObject:@{@"cityName":self.Cityname_location,@"cityCode":self.Citycode_location} forKey:cityCodeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self requestDistrictNOlist];
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
        else{
            NSMutableDictionary *dic =[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey];
            self.Cityname_location =[dic objectForKey:@"cityName"];
            self.Citycode_location =[dic objectForKey:@"cityCode"];
            
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
    }else if (alertView.tag ==100001) {
        if (buttonIndex ==alertView.cancelButtonIndex) {
            if(kUrlLearnDecorate){
                LearnDecorViewController *learnVC=[[LearnDecorViewController alloc]init];
                learnVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:learnVC animated:NO];
            }
        }else{
            PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc]init];
            personalInfoVC.hidesBottomBarWhenPushed = YES;
            personalInfoVC.isHomePage =YES;
            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.nav pushViewController:personalInfoVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showIntroWithCustomViewFromNib {
    EAIntroPage *page1 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage1"];
    UIColor *color1 = [UIColor whiteColor];
    page1.bgImage = [util imageWithColor:color1];
    
    EAIntroPage *page2 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage2"];
    UIColor *color2 = [UIColor whiteColor];
    page2.bgImage = [util imageWithColor:color2];
    
    EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage3"];
    UIColor *color3 = [UIColor whiteColor];
    page3.bgImage = [util imageWithColor:color3];
    
    _intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    [_intro setDelegate:self];
    _intro.swipeToExit = NO;
    _intro.showSkipButtonOnlyOnLastPage = YES;
    _intro.skipButton.hidden = YES;
    
    _enterBtn = (UIButton *)[page3.pageView viewWithTag:101];
    if (_enterBtn) {
        [_enterBtn setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(pressToEnter:) forControlEvents:UIControlEventTouchUpInside];
    }
    _loginBtn = (UIButton *)[page3.pageView viewWithTag:102];
    if (_loginBtn) {
        _loginBtn.layer.cornerRadius = 5.0f;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.backgroundColor=[UIColor colorWithHexString:@"#EF6562" alpha:0.9];
        [_loginBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    _registerBtn = (UIButton *)[page3.pageView viewWithTag:103];
    if (_registerBtn) {
        _registerBtn.layer.borderColor = [UIColor colorWithHexString:@"#EF6562" alpha:1.0].CGColor;
        _registerBtn.layer.borderWidth = 1.0;
        _registerBtn.layer.cornerRadius = 5.0f;
        _registerBtn.layer.masksToBounds = YES;
        [_registerBtn setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(clickRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIButton *selectProtocolBtn = (UIButton *)[page3.pageView viewWithTag:104];
    if (selectProtocolBtn) {
        [selectProtocolBtn setImage:[UIImage imageNamed:@"ic_y_xianzi_not"] forState:UIControlStateNormal];
        [selectProtocolBtn setImage:[UIImage imageNamed:@"ic_y_xianzi"] forState:UIControlStateSelected];
            [selectProtocolBtn addTarget:self action:@selector(pressToEnter:) forControlEvents:UIControlEventTouchUpInside];
    }
    _protocolBtn = (UIButton *)[page3.pageView viewWithTag:105];
    if (_protocolBtn) {
        [_protocolBtn setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
        [_protocolBtn addTarget:self action:@selector(pressToEnter:) forControlEvents:UIControlEventTouchUpInside];
    }
    UILabel *agreeLable = (UILabel *)[page3.pageView viewWithTag:106];
    if(agreeLable){
        agreeLable.textColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    }

    [_intro showInView:self.tabBarController.navigationController.view animateDuration:0];

}

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");

}

-(void)pressToEnter:(UIButton *)btn{
    if (btn.tag==104) {
        UIButton *button=btn;
        if (button.selected==YES) {

            button.selected=NO;
            
            _enterBtn.hidden = YES;
            
            _registerBtn.hidden = YES;
           
            _loginBtn.hidden = YES;
        }
        else{
           
            button.selected=YES;
            
            _enterBtn.hidden = NO;
            
//            _registerBtn.hidden = NO;
//            _loginBtn.hidden = NO;
        }
    }
    
    if (btn.tag == 101) {
        DQAlertView *alertView = [[DQAlertView alloc]initWithTitle:nil message:@"注册以后才能享受更好的装修服务！" delegate:self cancelButtonTitle:@"进入" otherButtonTitles:@"注册", nil];
        [alertView.cancelButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        [alertView.otherButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        alertView.tag = 1001;
        alertView.shouldDismissOnOutsideTapped = YES;
        [alertView show];

    }
    
    if (btn.tag == 102) {
        
    }
    
    if (btn.tag == 103) {
        
    }
    
    if (btn.tag==105) {
        UserAgreementViewController *userAgreementVC = [[UserAgreementViewController alloc]init];
        UINavigationController *navUserAgreementVC = [[UINavigationController alloc]initWithRootViewController:userAgreementVC];
        [self presentViewController:navUserAgreementVC animated:YES completion:nil];
    }
}

- (void)clickRegisterBtn:(id)sender {
    
    EnterMobileNumView *entermob=[[EnterMobileNumView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-100)/2, kMainScreenWidth-60, 100)leftButtonTitle:@"取消" rightButtonTitle:@"下一步" display:1 dismiss:2];
    entermob.Req_type=@"resgister";
    entermob.fromResgi=@"NO";
    [entermob show];
}

- (void)clickLoginBtn:(id)sender {
    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    login.delegate=self;
    self.view.tag=2;
    [login show];
}

-(void)registersucceed:(NSNotification *)notification {
    [_intro hideWithFadeOutDuration:1];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_yd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //自动登录
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:User_Name] length] && [[[NSUserDefaults standardUserDefaults]objectForKey:User_Password] length]) {
        [AutomaticLogin Automaticlogin:self];
    }
    UIAlertView *aler =[[UIAlertView alloc] initWithTitle:@"注册成功" message:@"注册成功，请立即完善个人资料" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    aler.tag=100001;
    [aler show];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"resgister_succeed" object:nil];
}

#pragma mark - DQAlertView delegate

- (void)cancelButtonClickedOnAlertView:(DQAlertView *)alertView {
    NSLog(@"OK Clicked");
    [alertView dismiss];
    [_intro hideWithFadeOutDuration:1];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_yd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(kUrlLearnDecorate){
        LearnDecorViewController *learnVC=[[LearnDecorViewController alloc]init];
        learnVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:learnVC animated:NO];
    }
}

- (void)otherButtonClickedOnAlertView:(DQAlertView *)alertView {
    NSLog(@"Cancel Clicked");
    [self clickRegisterBtn:nil];
}

#pragma mark - 请求广告页
- (void)requestADPages {
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0043\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,kCityCode];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"广告返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10431) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([self.adDataArray count]) [self.adDataArray removeAllObjects];
                        NSArray *arr_=[jsonDict objectForKey:@"ads"];
                        if([arr_ count]){
                            for(NSDictionary *dict in arr_){
                                [self.adDataArray addObject:dict];
                            }
                            _adCount = 0;
                            _adShowTime = 0;
                            if (self.adDataArray.count) {
                                if (self.adDataArray.count == 1) {
                                    NSLog(@"一张广告");
                                    //                                        _adShowTime = 3;
                                } else if (self.adDataArray.count == 2) {
                                    NSLog(@"两张广告");
                                    //                                        _adShowTime = 3;
                                } else if (self.adDataArray.count == 3) {
                                    NSLog(@"三张广告");
                                    //                                        _adShowTime = 2;
                                } else {
                                    NSLog(@"超过4张广告");
                                    NSMutableArray *adArr = [NSMutableArray arrayWithCapacity:3];
                                    for (int i = 0; i < self.adDataArray.count; i++) {
                                        if (i < 3) {
                                            [adArr addObject:[self.adDataArray objectAtIndex:i]];
                                        }
                                    }
                                    [self.adDataArray removeAllObjects];
                                    self.adDataArray = [adArr mutableCopy];
                                    //                                        _adShowTime = 2;
                                }
                                _adShowTime = 2;//新需求确定的 huangrun
                                self.adTimer = [NSTimer
                                                scheduledTimerWithTimeInterval:_adShowTime target:self selector:@selector(showADPages) userInfo:nil repeats:YES];
                                
                                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"first_ad"];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                                
                            } else {
                                NSLog(@"没广告");
                                [self removeADIV2];
                            }
                        } else {
                            NSLog(@"没广告");
                            [self removeADIV2];
                        }
                        
                        //                            [mtableview_sub reloadData];
                        //                            [mtableview_sub tableViewDidFinishedLoading];
                        
                    });
                } else if (code == 10439) {
                    NSLog(@"获取广告失败");
                    [self removeADIV2];
                } else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                            [mtableview_sub tableViewDidFinishedLoading];
                        [self removeADIV2];
                        
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  //                                      [mtableview_sub tableViewDidFinishedLoading];
                                  [self removeADIV2];
                              });
                          }
                               method:url postDict:nil];
    });
}

#pragma mark - 显示广告页

- (void)showADPages {
    [_activityIndicatorView stopAnimating];
//    [_aDIV removeFromSuperview];
    if (self.adDataArray.count) {
    NSString *urlStr = [[self.adDataArray objectAtIndex:_adCount]objectForKey:@"bannerUrl"];
    [self.tabBarController.view.window addSubview:_aDIV];
      
    [_aDIV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:_aDIV.image];
    _aDIV.clipsToBounds = YES;
    _aDIV.contentMode = UIViewContentModeScaleToFill;
        
    }
    
//    if (_adCount == self.adDataArray.count - 1)
    [self performSelector:@selector(removeADIV) withObject:nil afterDelay:0];
    _showCount ++;
    if (_showCount == 3) {
            [self.adTimer invalidate];
    }
}

- (void)removeADIV {
    self.tabBarController.view.userInteractionEnabled = YES;
    if (_adCount == self.adDataArray.count - 1) {
        if (!_isTap) {
        [self performSelector:@selector(removeADIV2) withObject:nil afterDelay:2];
        } else {
             [self performSelector:@selector(removeADIV2) withObject:nil afterDelay:2];
            _tapCount ++;
            if (_tapCount == 2) {
                [_aDIV removeFromSuperview];
                [self.adTimer invalidate];

            }
        }
    }
//    [_aDIV removeFromSuperview];
//    [self.adTimer invalidate];
    
    if (_adCount < self.adDataArray.count - 1) {
        _adCount++;
    }
}

- (void)tapADIV:(UITapGestureRecognizer *)tapGR {
    _isTap = YES;
    [self showADPages];
}


- (void)removeADIV2 {
    [_aDIV removeFromSuperview];
}


@end
