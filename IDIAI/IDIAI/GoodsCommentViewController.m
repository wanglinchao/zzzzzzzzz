//
//  GoodsCommentViewController.m
//  IDIAI
//
//  Created by iMac on 15-6-12.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GoodsCommentViewController.h"
#import "IDIAIAppDelegate.h"
#import "MBProgressHUD.h"
#import "TLToast.h"

@interface GoodsCommentViewController ()<UIWebViewDelegate> {
    UIWebView *_webView;
    
    MBProgressHUD *phud;
}

@end

@implementation GoodsCommentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"评论列表";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.url = kUrlGoodsCommentDetail;
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -37, kMainScreenWidth, kMainScreenHeight-27)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadTheView
{
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
    
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSString *body = [NSString stringWithFormat: @"goodsId=%@&pageIndex=1&flag=false",self.goodsId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [_webView loadRequest: request];
}

- (void)backButtonPressed:(id)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
       // IDIAIAppDelegate *delegate=(IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [self.navigationController popViewControllerAnimated:YES];
       // [delegate.nav popViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
