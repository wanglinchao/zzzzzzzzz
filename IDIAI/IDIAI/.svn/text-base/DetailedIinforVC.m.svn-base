//
//  DetailedIinforVC.m
//  IDIAI
//
//  Created by iMac on 14-7-7.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DetailedIinforVC.h"
#import "JSONKit.h"
#import "CircleProgressHUD.h"
#import "HexColor.h"
#import "util.h"
#import "IDIAIAppDelegate.h"
#import "savelogObj.h"
#import "UIImageView+LBBlurredImage.h"

@interface DetailedIinforVC ()
{
    CircleProgressHUD *phud;
  
}
@end

@implementation DetailedIinforVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"get" object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=[UIColor clearColor];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getString:) name:@"get" object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self customizeNavigationBar];
}

- (void)customizeNavigationBar {
    UIImageView *BarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    BarView.userInteractionEnabled=YES;
    [BarView setImageToBlur:[util imageWithColor:[UIColor whiteColor]]
                 blurRadius:kLBBlurredImageDefaultBlurRadius
            completionBlock:^(NSError *error){
            }];
    [self.view addSubview:BarView];
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(BarView.frame)-60, 20, 120, 44)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor darkGrayColor];
    lab_nav_title.text=@"消息详情";
    [BarView addSubview:lab_nav_title];
    
    UIView *line_bar=[[UIView alloc]initWithFrame:CGRectMake(0, 63.5, kMainScreenWidth, 0.5)];
    line_bar.backgroundColor=[UIColor colorWithHexString:@"#838B8B" alpha:0.6];
    [BarView addSubview:line_bar];
 
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(8, 24, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 50);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    [BarView addSubview:leftButton];
}

-(void)PressBarItemLeft{
    if ([webview canGoBack]) [webview goBack];
    else {
        [phud hide];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)createProgressView{
    if(!phud)
        phud=[[CircleProgressHUD alloc]initWithFrame:CGRectMake(100, 180, 120, 120) title:nil];
    [phud show];
}

-(void)loadImageviewBG{
    if(!imageview_bg)
    imageview_bg=[[UIImageView alloc]initWithFrame:CGRectMake(40, 150, kMainScreenWidth-80, 200)];
    imageview_bg.hidden=YES;
    imageview_bg.image=[UIImage imageNamed:@"ic_moren@2x.png"];
    [self.view addSubview:imageview_bg];
    if (!label_bg)
        label_bg = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview_bg.frame.origin.y + imageview_bg.frame.size.height + 5, kMainScreenWidth, 21)];
    label_bg.textAlignment = NSTextAlignmentCenter;
    label_bg.font = [UIFont systemFontOfSize:13];
    label_bg.textColor = [UIColor lightGrayColor];
    label_bg.hidden = YES;
    label_bg.text = @"亲，没有找到匹配内容哟";
    [self.view addSubview:label_bg];
}

-(void)getString:(NSNotification *)notif{
//    [self createProgressView];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[notif object]]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [savelogObj saveLog:@"查看消息详情" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:17];

    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64)];
    webview.backgroundColor=[UIColor clearColor];
    webview.delegate=self;
    webview.scalesPageToFit=YES;
    [self.view addSubview:webview];
    [self loadImageviewBG];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

#pragma mark -
#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //[self createProgressView];
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [imageview_bg removeFromSuperview];
    imageview_bg=nil;
    [label_bg removeFromSuperview];
    label_bg = nil;
    [phud hide];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [phud hide];
    imageview_bg.hidden=NO;
    label_bg.hidden = NO;
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

@end
