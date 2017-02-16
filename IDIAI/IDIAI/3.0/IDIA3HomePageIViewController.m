//
//  IDIA3HomePageIViewController.m
//  IDIAI
//
//  Created by Ricky on 15/10/14.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIA3HomePageIViewController.h"
#import "IDIAIAppDelegate.h"
#import "AutomaticLogin.h"
#import "util.h"
#import "Macros.h"
#import "LoginView.h"
#import "EnterMobileNumView.h"
#import "HexColor.h"
#import "CityListViewController.h"
#import "CityListObj.h"
#import "MainMessageViewController.h"
#import "LearnDecorViewController.h"
#import "KnowledgeViewController.h"
#import "MyeffectypictureVC.h"
#import "SeeEffectPictureViewController.h"
#import "CommonFreeViewController.h"
#import "MyhouseTypeVC.h"
#import "WorkerSearcheMapViewController.h"
#import "MyeffectypictureVC.h"
#import "GongzhangtuanViewController.h"
#import "JianliViewController.h"
#import "DecorateViewController.h"
#import "PersonalInfoViewController.h"
#import "TLToast.h"
#import "LZAutoScrollView.h"
#import "BannerInfoViewController.h"
#import "IDIAI3DiaryMainViewController.h"
#import "ShoppingMallViewController.h"
//#import <QuartzCore/QuartzCore.h>
@interface IDIA3HomePageIViewController ()<LoginViewDelegate,LoginViewDelegate,CityListDelegate,LZAutoScrollViewDelegate,CAAction>{
    EAIntroView *_intro;
    UIButton *_enterBtn;
    UIButton *_protocolBtn;
    UIButton *_registerBtn;
    UIButton *_loginBtn;
    
    LZAutoScrollView *autoScrollView;
}
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIImageView *envelopeimage;
@property (nonatomic,strong) UIView *envelopebackView;
@property (nonatomic,assign) int moneytag;
@property (nonatomic,strong) UIButton *closebtn;
@property (nonatomic,strong) UIButton *openbtn;
@property (nonatomic,strong) UIButton *showEnvelope;
@property (nonatomic,strong) UIImageView *monkeyimage;
@end

@implementation IDIA3HomePageIViewController
@synthesize leftButton,rightButton;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"resgister_succeed" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    _locService.delegate=nil;
    _geocodesearch.delegate = nil;
    
    [[NSUserDefaults  standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",leftButton.titleLabel.text] forKey:@"HomePageVCCity"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    _locService.delegate=self;
    _geocodesearch.delegate = self;
    [self customizeNavigationBar];
    int opennum =[[[NSUserDefaults standardUserDefaults] objectForKey:@"opennum"] intValue];
    if (opennum<5) {
        if (self.showEnvelope==nil) {
            self.showEnvelope =[UIButton buttonWithType:UIButtonTypeCustom];
            self.showEnvelope.backgroundColor =[UIColor clearColor];
            self.showEnvelope.frame =CGRectMake(kMainScreenWidth-71.5, kMainScreenHeight-49-64-77, 61.5, 77);
            [self.showEnvelope addTarget:self action:@selector(showEnvelopeAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.showEnvelope];
        }
        if (self.monkeyimage ==nil) {
            self.monkeyimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 23, 61.5, 54)];
            self.monkeyimage.image =[UIImage imageNamed:@"monkey.png"];
            [self.showEnvelope addSubview:self.monkeyimage];
        }else{
            self.monkeyimage.frame =CGRectMake(0, 23, 61.5, 54);
        }
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationRepeatCount:INFINITY];
        [UIView setAnimationRepeatAutoreverses:YES];
        self.monkeyimage.frame =CGRectMake(0, 0, 61.5, 54);
        [UIView commitAnimations];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registersucceed:) name:@"resgister_succeed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginAnimationAction:) name:@"beaginAnimation" object:nil];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor =[UIColor whiteColor];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first_yd"]){
        [self showIntroWithCustomViewFromNib];
    }
    [self createView];
    
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
    [NSTimer scheduledTimerWithTimeInterval:1800.0 target:self selector:@selector(requestmessge) userInfo:nil repeats:YES];
    
    self.data_array=[NSMutableArray array];
    [self requestBannerlist];
    [self requestCitylist];
    [self requestDistrictNOlist];
}
- (void)customizeNavigationBar {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:NO animated:NO];
    
    delegate.nav.navigationBar.hidden = NO;
    delegate.nav.navigationBar.translucent = NO;
    
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:kColorWithRGB(249, 249, 250)];
    
    UIImageView *nav_imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 52, 18)];
    nav_imageV.image =[UIImage imageNamed:@"ico_wtb3"];
    self.tabBarController.navigationItem.titleView=nav_imageV;
    
    NSString *cityName_str=[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityName"];
    
    if(!leftButton) leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
    if(!rightButton) rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(5, 5, 80, 40)];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:Is_NewMessage]isEqualToString:@"yes"]){
        [rightButton setImage:[UIImage imageNamed:@"ic_xiaoxi"] forState:UIControlStateNormal];
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
-(void)beginAnimationAction:(NSNotificationCenter *)sender{
    int opennum =[[[NSUserDefaults standardUserDefaults] objectForKey:@"opennum"] intValue];
    if (opennum<5) {
        if (self.showEnvelope==nil) {
            self.showEnvelope =[UIButton buttonWithType:UIButtonTypeCustom];
            self.showEnvelope.backgroundColor =[UIColor clearColor];
            self.showEnvelope.frame =CGRectMake(kMainScreenWidth-71.5, kMainScreenHeight-49-64-77, 61.5, 77);
            [self.showEnvelope addTarget:self action:@selector(showEnvelopeAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.showEnvelope];
        }
        if (self.monkeyimage ==nil) {
            self.monkeyimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 23, 61.5, 54)];
            self.monkeyimage.image =[UIImage imageNamed:@"monkey.png"];
            [self.showEnvelope addSubview:self.monkeyimage];
        }else{
            self.monkeyimage.frame =CGRectMake(0, 23, 61.5, 54);
        }
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationRepeatCount:INFINITY];
        [UIView setAnimationRepeatAutoreverses:YES];
        self.monkeyimage.frame =CGRectMake(0, 0, 61.5, 54);
        [UIView commitAnimations];
    }
}
-(void)PressBarItemLeft{
    CityListViewController *cityVC=[[CityListViewController alloc]init];
    cityVC.delegate=self;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)PressBarItemRight{
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]){
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:Is_NewMessage];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [rightButton setImage:[UIImage imageNamed:@"ic_xiaoxi"] forState:UIControlStateNormal];
        MainMessageViewController *mainMsgVC = [[MainMessageViewController alloc]init];
        mainMsgVC.hidesBottomBarWhenPushed = YES;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        mainMsgVC.fromVCStr = @"homeVC";
        [delegate.nav pushViewController:mainMsgVC animated:YES];
    }
    else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        self.view.tag=1;
        [login show];
    }
}
-(void)createView{
    if(!autoScrollView){
        autoScrollView = [[LZAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth,(kMainScreenHeight-113)/(736-113)*215)];
        autoScrollView.delegate = self;
        autoScrollView.images = @[@" "];
        autoScrollView.placeHolder = [UIImage imageNamed:@"ic_morentu"];
        autoScrollView.interval=3.0;
        autoScrollView.pageControlAligment=PageControlAligmentCenter;
        autoScrollView.isAutoScorll=NO;
        [autoScrollView createViews];
        [self.view addSubview:autoScrollView];
    }

    UIView *topfunction =[self createTopFunction];
    topfunction.frame =CGRectMake(0, autoScrollView.frame.origin.y+autoScrollView.frame.size.height, kMainScreenWidth, (kMainScreenHeight-113)/(736-113)*85);
    [self.view addSubview:topfunction];
    
    UIView *middleFunciton =[self createMiddleFunction];
    middleFunciton.frame =CGRectMake(0, topfunction.frame.origin.y+topfunction.frame.size.height, kMainScreenWidth, (kMainScreenHeight-113)/(736-113)*258);
    [self.view addSubview:middleFunciton];
    
    UIView *footFuncitonback =[self createFootFunction];
    footFuncitonback.frame =CGRectMake(0, middleFunciton.frame.origin.y+middleFunciton.frame.size.height, kMainScreenWidth, (kMainScreenHeight-113)/(736-113)*66);
    [self.view addSubview:footFuncitonback];
    
    
}
-(void)showEnvelopeAction:(id)sender{
    if (self.envelopeimage ==nil) {
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        self.envelopebackView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        self.envelopebackView.backgroundColor =[UIColor blackColor];
        self.envelopebackView.alpha =0.5;
        [keywindow addSubview:self.envelopebackView];
        
        self.envelopeimage =[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-(kMainScreenWidth-225)/2, kMainScreenHeight-(kMainScreenHeight-238)/2, 1, 1)];
        self.envelopeimage.image =[UIImage imageNamed:@"envelope.png"];
        self.envelopeimage.userInteractionEnabled =YES;
        [keywindow addSubview:self.envelopeimage];
        
        self.closebtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.closebtn setImage:[UIImage imageNamed:@"closeenvelope"] forState:UIControlStateNormal];
        [self.closebtn setImage:[UIImage imageNamed:@"closeenvelope"] forState:UIControlStateHighlighted];
        [self.closebtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        self.closebtn.frame =CGRectMake(kMainScreenWidth-17-35, 34, 35, 34);
        [keywindow addSubview:self.closebtn];
        
        self.openbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.openbtn.backgroundColor =[UIColor clearColor];
        [self.openbtn addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
        self.openbtn.frame =CGRectMake(95, 10, 100, 100);
        [self.envelopeimage addSubview:self.openbtn];
        
    }else{
        self.envelopeimage.frame =CGRectMake(kMainScreenWidth-(kMainScreenWidth-225)/2, kMainScreenHeight-(kMainScreenHeight-238)/2, 1, 1);
    }
    

    [UIView animateWithDuration:0.30 animations:^{
        self.envelopeimage.frame =CGRectMake((kMainScreenWidth-225*kMainScreenWidth/320)/2, (kMainScreenHeight-238*kMainScreenWidth/320)/2, 225*kMainScreenWidth/320, 238*kMainScreenWidth/320);
    } completion:^(BOOL finished) {
        //finished判断动画是否完成
        if (finished) {
            NSLog(@"finished");
            if (finished ==YES) {
                self.envelopeimage.transform = CGAffineTransformMakeScale(0.9, 0.9);
                [UIView animateWithDuration:0.5
                                      delay:0.0
                     usingSpringWithDamping:0.3
                      initialSpringVelocity:5
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     self.envelopeimage.transform = CGAffineTransformIdentity;
                                 }
                                 completion:nil];
            }
        }
    }];
    for (int i=0; i<7; i++) {
        UIImageView *money =[[UIImageView alloc] initWithFrame:CGRectMake(0, -91, 58, 91)];
        money.tag =1001+i;
        money.image =[UIImage imageNamed:@"money"];
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
//        money.backgroundColor =[UIColor redColor];
        [keywindow addSubview:money];
    }
    self.moneytag =0;

    //定时器
    NSTimer   *showTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                           target:self
                                                         selector:@selector(showMoney:)
                                                         userInfo:nil
                                                          repeats:YES];
    [showTimer fire];
}
-(void)closeAction:(id)sender{
    [self.openbtn removeFromSuperview];
    [self.envelopeimage removeFromSuperview];
    [self.envelopebackView removeFromSuperview];
    [self.closebtn removeFromSuperview];
    self.envelopeimage =nil;
    self.envelopebackView =nil;
    self.closebtn =nil;
    self.openbtn =nil;
    self.moneytag =0;
}
-(void)openAction:(id)sender{
    int opennum =0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"opennum"]) {
        opennum =[[[NSUserDefaults standardUserDefaults] objectForKey:@"opennum"] intValue];
    }
    opennum++;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",opennum] forKey:@"opennum"];
    if (opennum>=5) {
        self.showEnvelope.hidden =YES;
        self.monkeyimage.hidden =YES;
    }
    [self.openbtn removeFromSuperview];
    int num =random()%5;
    self.envelopeimage.image =[UIImage imageNamed:[NSString stringWithFormat:@"envelopeend%d",num]];
}
-(void)showMoney:(NSTimer *)theTimer{
    if (self.moneytag ==7) {
        [theTimer invalidate];
    }
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    UIImageView *money =(UIImageView *)[keywindow viewWithTag:1001+self.moneytag];
    float frameX =random()%320;
    money.frame =CGRectMake(frameX, -91, 58, 91);
    [UIView animateWithDuration:1.0 animations:^{
        money.frame =CGRectMake(frameX, kMainScreenHeight, 58, 91);
    } completion:^(BOOL finished) {
        //finished判断动画是否完成
        if (finished) {
            NSLog(@"finished");
            if (finished ==YES) {
                [money removeFromSuperview];
            }
        }
    }];
    self.moneytag++;
}

-(UIView *)createFootFunction{
    UIView *footFuncitonback =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, (kMainScreenHeight-113)/(736-113)*66)];
    footFuncitonback.backgroundColor =kColorWithRGB(246,245,249);
    for (int i=0; i<3; i++) {
        UIButton *footbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        footbtn.frame =CGRectMake(kMainScreenWidth/414*47+kMainScreenWidth/414*116*i, 0, kMainScreenWidth/414*81, (kMainScreenHeight-113)/(736-113)*66);
        [footFuncitonback addSubview:footbtn];
        UIImageView *footimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, (kMainScreenHeight-113)/(736-113)*20, kMainScreenWidth/414*28, (kMainScreenHeight-113)/(736-113)*28)];
        UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(footimage.frame.origin.x+footimage.frame.size.width, footimage.frame.origin.y+(kMainScreenHeight-113)/(736-113)*4, kMainScreenWidth/414*65, (kMainScreenHeight-113)/(736-113)*20)];
        titlelbl.textAlignment =NSTextAlignmentLeft;
        titlelbl.textColor =[UIColor colorWithHexString:@"#4d4d4d"];
        titlelbl.font =[UIFont systemFontOfSize:(kMainScreenHeight-113)/(736-113)*15];
        [footbtn addSubview:footimage];
        [footbtn addSubview:titlelbl];
        [footbtn addTarget:self action:@selector(footAction:) forControlEvents:UIControlEventTouchUpInside];
        footbtn.tag =200+i;
        
        if (i==0) {
            footimage.image =[UIImage imageNamed:@"ic_yanfang.png"];
            titlelbl.text =@"免费验房";
        }else if (i ==1){
            footimage.image =[UIImage imageNamed:@"ic_baojia.png"];
            titlelbl.text =@"智能报价";
        }else if (i ==2){
            footimage.image =[UIImage imageNamed:@"ic_daikuan.png"];
            titlelbl.text =@"申请贷款";
        }
    }
    return footFuncitonback;
}
-(void)footAction:(UIButton *)sender{
    if (sender.tag ==200) {
        CommonFreeViewController *common =[[CommonFreeViewController alloc] init];
        common.type =0;
         IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.nav pushViewController:common animated:YES];
    }else if (sender.tag ==202){
        CommonFreeViewController *common =[[CommonFreeViewController alloc] init];
        common.type =2;
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.nav pushViewController:common animated:YES];
    }else{
        MyhouseTypeVC *myHouseTypeVC = [[MyhouseTypeVC alloc]init];
        myHouseTypeVC.hidesBottomBarWhenPushed = YES;
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.nav pushViewController:myHouseTypeVC animated:YES];
    }
}
-(UIView *)createMiddleFunction{
    UIView *middleFuncitonback =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, (kMainScreenHeight-113)/(736-113)*258)];
    middleFuncitonback.backgroundColor =[UIColor whiteColor];
    int x =0;
    int heightcount =0;
    for (int i=0; i<4; i++) {
        UIButton *funbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        if (i>1) {
            heightcount =1;
        }
        if (i==2) {
            x =0;
        }
        funbtn.frame =CGRectMake(kMainScreenWidth/414*207.5*x, (kMainScreenHeight-113)/(736-113)*128.5*heightcount, kMainScreenWidth/414*207, (kMainScreenHeight-113)/(736-113)*128.5);
        [middleFuncitonback addSubview:funbtn];
        funbtn.tag =300+i;
        funbtn.imageView.contentMode=UIViewContentModeScaleAspectFill;
        funbtn.imageView.clipsToBounds=YES;
        [funbtn addTarget:self action:@selector(middleAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [funbtn setImage:[UIImage imageNamed:@"Ic_shejifangan.png"] forState:UIControlStateNormal];
            [funbtn setImage:[UIImage imageNamed:@"Ic_shejifangan_s.png"] forState:UIControlStateHighlighted];
        }else if (i==1){
            [funbtn setImage:[UIImage imageNamed:@"Ic_zhuangxiushigong.png"] forState:UIControlStateNormal];
            [funbtn setImage:[UIImage imageNamed:@"Ic_zhuangxiushigong_s.png"] forState:UIControlStateHighlighted];
        }else if (i==2){
            [funbtn setImage:[UIImage imageNamed:@"Ic_zhuangxiuguanjia.png"] forState:UIControlStateNormal];
            [funbtn setImage:[UIImage imageNamed:@"Ic_zhuangxiuguanjia_s.png"] forState:UIControlStateHighlighted];
        }else{
//            [funbtn setImage:[UIImage imageNamed:@"Ic_yuyuezhaobiao.png"] forState:UIControlStateNormal];
//            [funbtn setImage:[UIImage imageNamed:@"Ic_yuyuezhaobiao_s.png"] forState:UIControlStateHighlighted];
            [funbtn setImage:[UIImage imageNamed:@"homeshangcheng.png"] forState:UIControlStateNormal];
            [funbtn setImage:[UIImage imageNamed:@"homeshangcheng_s.png"] forState:UIControlStateHighlighted];
        }
        x++;
    }
    return middleFuncitonback;
}

-(void)middleAction:(UIButton*)sender{
    if (sender.tag ==300) {
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
        MyeffectypictureVC *effectvc=[[MyeffectypictureVC alloc]init];
        effectvc.picture_type=@"taotu"; 
        effectvc.hidesBottomBarWhenPushed=YES;
        [appDelegate.nav pushViewController:effectvc animated:YES];
    }else if (sender.tag ==301){
        GongzhangtuanViewController *gongzhangtuanVC = [[GongzhangtuanViewController alloc]init];
        gongzhangtuanVC.hidesBottomBarWhenPushed = YES;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav pushViewController:gongzhangtuanVC animated:YES];
    }else if (sender.tag ==302){
        JianliViewController *supervisorVC = [[JianliViewController alloc]init];
        supervisorVC.hidesBottomBarWhenPushed = YES;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav pushViewController:supervisorVC animated:YES];
    }else{
        ShoppingMallViewController *shoppingMallVC = [[ShoppingMallViewController alloc]init];
        shoppingMallVC.hidesBottomBarWhenPushed=YES;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav pushViewController:shoppingMallVC animated:YES];

//        DecorateViewController *decorateVC = [[DecorateViewController alloc]init];
//        decorateVC.hidesBottomBarWhenPushed = YES;
//        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate.nav pushViewController:decorateVC animated:YES];
    }
}
-(UIView *)createTopFunction{
    UIView *topFuncitonback =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, (kMainScreenHeight-113)/(736-113)*85)];
    topFuncitonback.backgroundColor =kColorWithRGB(246,245,249);
    for (int i=0; i<4; i++) {
//        UIButton *topbtn =[[UIButton alloc] initWithFrame:CGRectMake(47*kMainScreenWidth/414+kMainScreenWidth/414*91*i, 0, kMainScreenWidth/414*44, (kMainScreenHeight-113)/(736-113)*85)];
//        NSLog(@"%f",(kMainScreenWidth-40-44*5)/4);
//        NSLog(@"%f",kMainScreenWidth);
        UIButton *topbtn =[[UIButton alloc] initWithFrame:CGRectMake(20*kMainScreenWidth/414+kMainScreenWidth/414*(44+(414-40-44*4)/3)*i, 0, kMainScreenWidth/414*44, (kMainScreenHeight-113)/(736-113)*85)];
        [topbtn addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
        [topFuncitonback addSubview:topbtn];
        UIImageView *btnimage =[[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth/414*44-26)/2+2, (kMainScreenHeight-113)/(736-113)*16, (kMainScreenHeight-113)/(736-113)*26, (kMainScreenHeight-113)/(736-113)*26)];
        UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(-9, btnimage.frame.origin.y+btnimage.frame.size.height+(kMainScreenHeight-113)/(736-113)*3, kMainScreenWidth/414*65, (kMainScreenHeight-113)/(736-113)*20)];
        titlelbl.textAlignment =NSTextAlignmentCenter;
        titlelbl.textColor =[UIColor colorWithHexString:@"#4d4d4d"];
        titlelbl.font =[UIFont systemFontOfSize:(kMainScreenHeight-113)/(736-113)*15];
        [topbtn addSubview:btnimage];
        [topbtn addSubview:titlelbl];
        topbtn.tag =100+i;
//        if (i==0) {
////            topbtn.backgroundColor =[UIColor redColor];
//            btnimage.image =[UIImage imageNamed:@"ic_zhuangxiuzhishi.png"];
//            titlelbl.text =@"装修知识";
//        }else if (i ==1){
////            topbtn.backgroundColor =[UIColor orangeColor];
//            btnimage.image =[UIImage imageNamed:@"ic_xiaoguotu.png"];
//            titlelbl.text =@"看效果图";
//        }else if (i ==2){
//            btnimage.image =[UIImage imageNamed:@"ic_zhuangriji.png"];
//            titlelbl.text =@"日记广场";
////            topbtn.backgroundColor =[UIColor blueColor];
//            
//        }else if (i==3){
//            btnimage.image =[UIImage imageNamed:@"ic_zaijiangondi.png"];
//            titlelbl.text =@"在建工地";
////            topbtn.backgroundColor =[UIColor purpleColor];
//        }else{
////            topbtn.backgroundColor =[UIColor blackColor];
//            btnimage.image =[UIImage imageNamed:@"ic_fjxiaogong.png"];
//            titlelbl.text =@"附近小工";
//        }
        if (i==0) {
            //            topbtn.backgroundColor =[UIColor redColor];
            btnimage.image =[UIImage imageNamed:@"ic_zhuangxiuzhishi.png"];
            titlelbl.text =@"装修知识";
        }else if (i ==1){
            //            topbtn.backgroundColor =[UIColor orangeColor];
            btnimage.image =[UIImage imageNamed:@"ic_xiaoguotu.png"];
            titlelbl.text =@"看效果图";
        }else  if (i==2){
            btnimage.image =[UIImage imageNamed:@"ic_zaijiangondi.png"];
            titlelbl.text =@"在建工地";
            //            topbtn.backgroundColor =[UIColor purpleColor];
        }else{
            //            topbtn.backgroundColor =[UIColor blackColor];
            btnimage.image =[UIImage imageNamed:@"ic_fjxiaogong.png"];
            titlelbl.text =@"附近小工";
        }

    }
    return topFuncitonback;
}
-(void)topAction:(UIButton *)sender{
//    if (sender.tag ==100) {
//        KnowledgeViewController *knowledgeVC = [[KnowledgeViewController alloc]init];
//        knowledgeVC.hidesBottomBarWhenPushed = YES;
//        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
//        [appDelegate.nav pushViewController:knowledgeVC animated:YES];
//    }else if (sender.tag ==101){
//        SeeEffectPictureViewController *effectVC=[[SeeEffectPictureViewController alloc]init];
//        effectVC.hidesBottomBarWhenPushed = YES;
//        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
//        [appDelegate.nav pushViewController:effectVC animated:YES];
//    }else if (sender.tag ==102){
//        IDIAI3DiaryMainViewController *diaryMVC = [[IDIAI3DiaryMainViewController alloc]init];
//        diaryMVC.hidesBottomBarWhenPushed = YES;
//        diaryMVC.isseven =YES;
//        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate.nav pushViewController:diaryMVC animated:YES];
//    }
//    else if (sender.tag ==103){
//        [self openUTopGDApp];
//        
//    }else if (sender.tag ==104){
//        WorkerSearcheMapViewController *workMapVC = [[WorkerSearcheMapViewController alloc]init];
//        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//        workMapVC.hidesBottomBarWhenPushed = YES;
//        [delegate.nav pushViewController:workMapVC animated:YES];
//    }
    if (sender.tag ==100) {
        KnowledgeViewController *knowledgeVC = [[KnowledgeViewController alloc]init];
        knowledgeVC.hidesBottomBarWhenPushed = YES;
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.nav pushViewController:knowledgeVC animated:YES];
    }else if (sender.tag ==101){
        SeeEffectPictureViewController *effectVC=[[SeeEffectPictureViewController alloc]init];
        effectVC.hidesBottomBarWhenPushed = YES;
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.nav pushViewController:effectVC animated:YES];
    }
    else if (sender.tag ==102){
        [self openUTopGDApp];
        
    }else if (sender.tag ==103){
        WorkerSearcheMapViewController *workMapVC = [[WorkerSearcheMapViewController alloc]init];
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        workMapVC.hidesBottomBarWhenPushed = YES;
        [delegate.nav pushViewController:workMapVC animated:YES];
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
        _enterBtn.layer.masksToBounds = YES;
        _enterBtn.layer.cornerRadius = 10;
        _enterBtn.layer.borderColor =[UIColor colorWithHexString:@"#FF4565"].CGColor;
        _enterBtn.layer.borderWidth = 1;
        [_enterBtn setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(pressToEnter:) forControlEvents:UIControlEventTouchUpInside];
    }
    _loginBtn = (UIButton *)[page3.pageView viewWithTag:102];
    if (_loginBtn) {
        _loginBtn.layer.cornerRadius = 5.0f;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.backgroundColor=[UIColor colorWithHexString:@"#EF6562" alpha:0.9];
        [_loginBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.hidden =YES;
    }
    _registerBtn = (UIButton *)[page3.pageView viewWithTag:103];
    if (_registerBtn) {
        _registerBtn.layer.borderColor = [UIColor colorWithHexString:@"#EF6562" alpha:1.0].CGColor;
        _registerBtn.layer.borderWidth = 1.0;
        _registerBtn.layer.cornerRadius = 5.0f;
        _registerBtn.layer.masksToBounds = YES;
        [_registerBtn setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(clickRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
        _registerBtn.hidden =YES;
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
-(void)pressToEnter:(UIButton *)btn{
    if (btn.tag==104) {
        UIButton *button=btn;
        if (button.selected==YES) {
            button.selected=NO;
            _enterBtn.hidden = YES;
            
        }
        else{
            button.selected=YES;
            _enterBtn.hidden = NO;
//            _registerBtn.hidden = NO;
//            _loginBtn.hidden = NO;
        }
    }
    _registerBtn.hidden = YES;
    _loginBtn.hidden = YES;
    if (btn.tag == 101) {
        [_intro hideWithFadeOutDuration:1];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_yd"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //if(kUrlLearnDecorate){
            LearnDecorViewController *learnVC=[[LearnDecorViewController alloc]init];
            learnVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:learnVC animated:NO];
        //}
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
- (void)clickLoginBtn:(id)sender {
    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    login.delegate=self;
    self.view.tag=2;
    [login show];
}
- (void)clickRegisterBtn:(id)sender {
    
    EnterMobileNumView *entermob=[[EnterMobileNumView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-100)/2, kMainScreenWidth-60, 100)leftButtonTitle:@"取消" rightButtonTitle:@"下一步" display:1 dismiss:2];
    entermob.Req_type=@"resgister";
    entermob.fromResgi=@"NO";
    [entermob show];
}

#pragma mark -
#pragma mark - 检查消息标识

//检查消息标识
-(void)requestmessge{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:Is_NewMessage]isEqualToString:@"yes"]){
        [self checkMessage];
    }
}

//检查是否有新信息标识
-(void)checkMessage{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_date=@"";
        if([[[NSUserDefaults standardUserDefaults] objectForKey:Message_date] length])
            string_date = [[NSUserDefaults standardUserDefaults] objectForKey:Message_date];
        
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
                    else {
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

#pragma mark - 请求当前城市下区县列表
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

#pragma mark - 请求城市列表
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

#pragma mark - LoginDelegate
-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict{
    if(self.view.tag==1){
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:Is_NewMessage];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [rightButton setImage:[UIImage imageNamed:@"ic_xiaoxi"] forState:UIControlStateNormal];
        MainMessageViewController *mainMsgVC = [[MainMessageViewController alloc]init];
        mainMsgVC.hidesBottomBarWhenPushed = YES;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav pushViewController:mainMsgVC animated:YES];
    }
    else if (self.view.tag==2){
      //  if(kUrlLearnDecorate){
            LearnDecorViewController *learnVC=[[LearnDecorViewController alloc]init];
            learnVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:learnVC animated:NO];
       // }
    }
    [_intro hideWithFadeOutDuration:1];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_yd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 注册
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

#pragma mark - 请求活动列表
-(void)requestBannerlist{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0040\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"活动返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (code==10401) {
                         if([self.data_array count]) [self.data_array removeAllObjects];
                         NSArray *arr_=[jsonDict objectForKey:@"bannerList"];
                         NSMutableArray *arr_images=[NSMutableArray array];
                         if([arr_ count]){
                             for(NSDictionary *dict in arr_){
                                 if([[dict objectForKey:@"bannerWay"] integerValue]==2){
                                    [self.data_array addObject:dict];
                                    [arr_images addObject:[dict objectForKey:@"bannerUrl"]];
                                 }
                                else continue;
                             }
                             autoScrollView.images = arr_images;
                             if([arr_images count]>1) autoScrollView.isAutoScorll=YES;
                             else if([arr_images count]==1)[autoScrollView stopScroll];
                             [autoScrollView ajustImageViewContent];
                         }
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

#pragma mark - 活动被点击

-(void)imageClicked:(NSInteger)index{
    [MobClick event:@"Click_banner"];   //友盟自定义事件,数量统计
    if(index<[self.data_array count]){
        NSDictionary *dict=[self.data_array objectAtIndex:index];
        if([[dict objectForKey:@"bannerType"] integerValue]==1){
            if([[dict objectForKey:@"bannerDetailUrl"] length]){
                BannerInfoViewController *bannervc=[[BannerInfoViewController alloc]init];
                bannervc.url=[dict objectForKey:@"bannerDetailUrl"];
                bannervc.hidesBottomBarWhenPushed=YES;
                IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
                [appDelegate.nav pushViewController:bannervc animated:YES];
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
    }
    else if (alertView.tag==100001){
        if (buttonIndex ==alertView.cancelButtonIndex) {
            //if(kUrlLearnDecorate){
                LearnDecorViewController *learnVC=[[LearnDecorViewController alloc]init];
                learnVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:learnVC animated:NO];
           // }
        }else{
            PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc]init];
            personalInfoVC.hidesBottomBarWhenPushed = YES;
            personalInfoVC.isHomePage =YES;
            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.nav pushViewController:personalInfoVC animated:YES];
        }
    }
    else if (alertView.tag==100002){
        if (buttonIndex!=alertView.cancelButtonIndex) [self downloadUTopGDApp];
        else [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

#pragma mark - 调起屋托邦看工地App
/*
 注意：URL Schemes必填， URL identifier选填。
 另外，URL Schemes建议都小写，因为之后接收到数据的时候，不区分大小写，都是转为小写。
 规定的格式是：URL Schemes://URL identifier ，其中(URL identifier可不填写)
 */
- (void)openUTopGDApp {
    NSString *UrlSchemes =@"qttecx.utopgd://";
    NSURL *urlApp = [NSURL URLWithString:[UrlSchemes stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([[UIApplication sharedApplication] canOpenURL:urlApp])
        [[UIApplication sharedApplication] openURL:urlApp];
    else{
        UIAlertView *alv=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您尚未安装“屋托邦看工地”，是否立即前往下载安装？" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"立即", nil];
        alv.tag=100002;
        [alv show];
    }
}

#pragma mark - 下载屋托邦看工地App
- (void)downloadUTopGDApp {
    NSString *sPappIDStr = @"1044950732";
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", sPappIDStr];
    NSURL *iTunesURL = [NSURL URLWithString:[iTunesString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([[UIApplication sharedApplication] canOpenURL:iTunesURL]) [[UIApplication sharedApplication] openURL:iTunesURL];
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
