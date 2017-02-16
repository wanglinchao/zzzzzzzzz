//
//  ShoppingMallViewController.m
//  IDIAI
//
//  Created by Ricky on 15/6/1.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ShoppingMallViewController.h"
#import "GoodsDetailViewController.h"
#import "TestBridge.h"
#import "IDIAIAppDelegate.h"
#import "ShoppingCartViewController2.h"
#import "savelogObj.h"
#import "NJKWebViewProgressView.h"
@interface ShoppingMallViewController (){
    UIWebView *_webView;
    TestBridge *_bridge;
    
    UIActivityIndicatorView *actIndicView;
    BOOL isSendToken;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property(nonatomic,strong)UIButton *closeButton;
@end

@implementation ShoppingMallViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGoodFromMall" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGouWuChe" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetBrandShop" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlickingSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backedVC" object:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGoodFromMall" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGouWuChe" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backedVC" object:nil];
    [_progressView removeFromSuperview];
    _progressProxy=nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVCGoodFromMall:) name:@"pushVCGoodFromMall" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVCGouWuChe:) name:@"pushVCGouWuChe" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backedVC:) name:@"backedVC" object:nil];
}

#pragma mark -
#pragma mark - 通知

-(void)pushVCGoodFromMall:(NSNotification *)notif{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGoodFromMall" object:nil];
    GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
    vc.goodsIdStr=[notif object];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pushVCGouWuChe:(NSNotification *)notif{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGouWuChe" object:nil];
    ShoppingCartViewController2 *vc=[[ShoppingCartViewController2 alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)GetBrandShop:(NSNotification *)notif{
    NSString *urlBrand=[notif object];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlBrand]];
    [_webView loadRequest:req];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithHexString:@"#F0F0F5" alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetBrandShop:) name:@"GetBrandShop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FlickingSucceed:) name:@"FlickingSucceed" object:nil];
    
    [savelogObj saveLog:@"进入商城" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:73];
    
    //加载背景头部图片
    UIImageView *top_imv_bg=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-(kMainScreenWidth/2+20))/2, 15, kMainScreenWidth/2+20, 80)];
    top_imv_bg.image=[UIImage imageNamed:@"Mall_top_beijing"];
    top_imv_bg.contentMode=UIViewContentModeScaleAspectFit;
    top_imv_bg.clipsToBounds=YES;
    [self.view addSubview:top_imv_bg];
    
    NSString *string_token=@"";
    NSString *string_userid=@"";
    NSString *string_citycode =@"";
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
        string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
        
        string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        string_citycode = [[NSUserDefaults standardUserDefaults]objectForKey:cityCodeKey];
    }
    
    NSString *url=kUrlShoppingMall;
    NSString *urlMain = [NSString stringWithFormat:@"%@?userId=%@&token=%@",url,string_userid,string_token];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    _webView.backgroundColor=[UIColor clearColor];
//    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
   
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.5f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, 44, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.navigationController.navigationBar addSubview:_progressView];
    [_progressView setProgress:0.0 animated:YES];
    
    //设置oc和js的桥接
    _bridge = [TestBridge bridgeForWebView:_webView webViewDelegate:_progressProxy];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlMain]];
    [_webView loadRequest:req];
   
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    leftButton.tag=1;
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateHighlighted];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    [leftButton setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateHighlighted];
//    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    
    [leftButton addTarget:self
                   action:@selector(PressbackTouched)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem =leftItem;
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setFrame:CGRectMake(0, 0, 80, 40)];
    self.closeButton.tag=1;
    self.closeButton.hidden =YES;
    [self.closeButton setImage:[UIImage imageNamed:@"ic_close.png"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"ic_close.png"] forState:UIControlStateHighlighted];
    self.closeButton.imageEdgeInsets=UIEdgeInsetsMake(0, 60, 0, 0);
    [self.closeButton setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateHighlighted];
    
    [self.closeButton addTarget:self
                    action:@selector(closeAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    self.navigationItem.rightBarButtonItem =leftItem1;
}
-(void)PressbackTouched{
    if ([_webView canGoBack]) {
        [_webView goBack];
        self.closeButton.hidden =NO;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)closeAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backedVC:(NSNotification *)notif{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [actIndicView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    [actIndicView stopAnimating];
    if(isSendToken==NO) [self setUserID];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [actIndicView stopAnimating];
}

-(void)setUserID{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
        NSString* js = [NSString stringWithFormat:@"setUserId('%@','%@','index');",
                        [[NSUserDefaults standardUserDefaults]objectForKey:User_ID],
                        [[NSUserDefaults standardUserDefaults]objectForKey:User_Token]];
        [_webView stringByEvaluatingJavaScriptFromString:js];
        isSendToken=YES;
    }
}

-(void)FlickingSucceed:(NSNotification *)notif{
    NSString* js = [NSString stringWithFormat:@"setSweepCode('%@');",[notif object]];
    [_webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
