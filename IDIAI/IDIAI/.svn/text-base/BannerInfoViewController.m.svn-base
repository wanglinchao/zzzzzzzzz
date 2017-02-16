//
//  BannerInfoViewController.m
//  IDIAI
//
//  Created by iMac on 14-12-10.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "BannerInfoViewController.h"
#import "HexColor.h"
#import "util.h"
#import "savelogObj.h"
#import "TestBridge.h"

@interface BannerInfoViewController ()<UIWebViewDelegate>
{
    UIActivityIndicatorView *activ;
    TestBridge *_bridge;
    UIWebView *webview;
}
@end

@implementation BannerInfoViewController
@synthesize url;


-(void)customizeNavigationBar {
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor blackColor];
    lab_nav_title.text=@"详情";
    self.navigationItem.titleView = lab_nav_title;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, -5, 0, 55);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

-(void)PressBarItemLeft{
    if([webview canGoBack]) [webview goBack];
    else [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self customizeNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [savelogObj saveLog:@"查看活动详情" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:33];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    webview.delegate=self;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    webview.scalesPageToFit=YES;
    [self.view addSubview:webview];
    
    //设置oc和js的桥接
    _bridge = [TestBridge bridgeForWebView:webview webViewDelegate:self];
    
    activ=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activ.center= CGPointMake(kMainScreenWidth/2, (kMainScreenHeight-64)/2);//只能设置中心，不能设置大小
    [self.view addSubview:activ];
    [activ setHidesWhenStopped:YES]; //当旋转结束时隐藏
}

#pragma mark -
#pragma mark -UIWebviewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [activ startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [activ stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [activ stopAnimating];
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
