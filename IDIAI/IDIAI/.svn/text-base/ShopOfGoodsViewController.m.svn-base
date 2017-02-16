//
//  ShopOfGoodsViewController.m
//  IDIAI
//
//  Created by Ricky on 15/6/4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ShopOfGoodsViewController.h"
#import "TestBridge.h"
#import "GoodsDetailViewController.h"
#import "IDIAIAppDelegate.h"
#import "MBProgressHUD.h"
#import "TLToast.h"
#import "savelogObj.h"

@interface ShopOfGoodsViewController () <UIWebViewDelegate> {
    UIWebView *_webView;
    TestBridge *_bridge;
    
    NSInteger count;
    
    MBProgressHUD *phud;
}

@end

@implementation ShopOfGoodsViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGood" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVC:) name:@"pushVCGood" object:nil];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"查看商家" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:15];

    
    self.urlStr = kUrlShop;
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    //设置oc和js的桥接
    _bridge = [TestBridge bridgeForWebView:_webView webViewDelegate:self];
    
    [self loadTheView];
}

-(void)createProgressView{
    if (!phud) {
        phud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:phud];
        phud.mode=MBProgressHUDModeIndeterminate;
        //self.pHUD.dimBackground=YES; //是否开启背景变暗
        phud.labelText = @"";
        phud.blur=NO;  //是否开启ios7毛玻璃风格
        phud.darkBlur=YES; //受blur限制（blur为YES时设置darkBlur才有用）
        [phud show:YES];
    }
    else{
        [phud show:YES];
    }
}

-(void)pushVC:(NSNotification *)notif{
   
    NSInteger index=0;
    if(index==0){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGood" object:nil];
        GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
        if([self.fromWhere isEqualToString:@"no"]) vc.fromWhere=@"no";
        else vc.fromWhere=@"jsBridge";
        vc.goodsIdStr=[NSString stringWithFormat:@"%@",[notif object]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    index++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadTheView
{
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSString *body = [NSString stringWithFormat: @"shopId=%@",self.shopIdStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [_webView loadRequest: request];
}

- (void)backButtonPressed:(id)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGood" object:nil];
       // IDIAIAppDelegate *delegate=(IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        if([self.fromWhere isEqualToString:@"no"]) [self.navigationController popViewControllerAnimated:YES];
        else {
            [self.navigationController popViewControllerAnimated:YES];
           // [delegate.nav popViewControllerAnimated:YES];
        }
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self createProgressView];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [phud hide:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [phud hide:YES];
    [TLToast showWithText:@"加载失败" topOffset:220.0f duration:1.5];
}

@end
