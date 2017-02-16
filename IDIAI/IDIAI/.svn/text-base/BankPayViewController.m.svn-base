//
//  BankPayViewController.m
//  IDIAI
//
//  Created by iMac on 15-7-6.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "BankPayViewController.h"
#import "TLToast.h"
#import "TestBridge.h"
#import "MBProgressHUD.h"

@interface BankPayViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
     TestBridge *_bridge;
    
    MBProgressHUD *phud;
}

@end

@implementation BankPayViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BankPaySucceed" object:nil];
}

- (void)customizeNavigationBar {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    [leftButton addTarget:self
                   action:@selector(backTouched:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
}
-(void)backTouched:(UIButton *)btn{
    
    NSArray *array=[self.navigationController viewControllers];
    if([array count]>=3)
        [self.navigationController popToViewController:[array objectAtIndex:[array count]-3] animated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNCUpdateOrderStatus object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewFromBankPay:) name:@"BankPaySucceed" object:nil];
    
    self.title=@"银行支付";
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithHexString:@"#F8F8FF" alpha:1.0];
    [self customizeNavigationBar];
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64)];
    _webView.delegate=self;
    _webView.backgroundColor=[UIColor whiteColor];
    _webView.scalesPageToFit=YES;
    [self.view addSubview:_webView];
    NSURL *url = [NSURL URLWithString:self.payUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [_webView loadRequest:request];
    
    //设置oc和js的桥接
    _bridge = [TestBridge bridgeForWebView:_webView webViewDelegate:self];
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

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self createProgressView];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [phud hide:YES];
}

-(void)popViewFromBankPay:(NSNotification *)notif{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BankPaySucceed" object:nil];
    
    NSArray *array=[self.navigationController viewControllers];
    if([array count]>=3){
        if ([array count]>=4) {
            [self.navigationController popToViewController:[array objectAtIndex:[array count]-4] animated:YES];
        }
            [self.navigationController popToViewController:[array objectAtIndex:[array count]-3] animated:YES];
    }
    else{
       [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNCUpdateOrderStatus object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
