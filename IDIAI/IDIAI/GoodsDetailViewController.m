//
//  GoodsDetailViewController.m
//  IDIAI
//
//  Created by Ricky on 15/6/4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "TestBridge.h"
#import "ShopOfGoodsViewController.h"
#import "ShoppingCartViewController2.h"
#import "GoodsCommentViewController.h"
#import "IDIAIAppDelegate.h"
#import "MBProgressHUD.h"
#import "TLToast.h"

@interface GoodsDetailViewController () <UIWebViewDelegate> {
    
    TestBridge *_bridge;
    UIWebView *_webView;
    BOOL isSendToken;
    NSInteger count;
    
    MBProgressHUD *phud;
}


@end

@implementation GoodsDetailViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCShop" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGouWuChe" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGoodsComment" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVCShop:) name:@"pushVCShop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVCGouWuChe:) name:@"pushVCGouWuChe" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVCGoodsComment:) name:@"pushVCGoodsComment" object:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"商品详情";
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.urlStr = kUrlGoodsDetail;
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
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

-(void)pushVCShop:(NSNotification *)notif{
    NSLog(@"商品详情111111111");
    NSInteger index=0;
    if(index==0){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCShop" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGouWuChe" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGoodsComment" object:nil];
        ShopOfGoodsViewController *vc=[[ShopOfGoodsViewController alloc]init];
        vc.shopIdStr=[notif object];
        if([self.fromWhere isEqualToString:@"no"]) vc.fromWhere=@"no";
        else vc.fromWhere=@"jsBridge";
        [self.navigationController pushViewController:vc animated:YES];
    }
    index++;
}

-(void)pushVCGouWuChe:(NSNotification *)notif{
    NSInteger index=0;
    if(index==0){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCShop" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGouWuChe" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGoodsComment" object:nil];
        ShoppingCartViewController2 *vc=[[ShoppingCartViewController2 alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    index++;
}

-(void)pushVCGoodsComment:(NSNotification *)notif{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCShop" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGouWuChe" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGoodsComment" object:nil];
    GoodsCommentViewController *vc=[[GoodsCommentViewController alloc]init];
    vc.goodsId=[notif object];
    [self.navigationController pushViewController:vc animated:YES];
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

    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSString *body ;
    if([self.type isEqualToString:@"jsBridge"])
        body = [NSString stringWithFormat: @"goodsId=%@&userId=%@&isFrom=cart",self.goodsIdStr,string_userid];
    else
        body = [NSString stringWithFormat: @"goodsId=%@&userId=%@",self.goodsIdStr,string_userid];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [_webView loadRequest: request];
}

- (void)backButtonPressed:(id)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCShop" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGouWuChe" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCGoodsComment" object:nil];
      //  IDIAIAppDelegate *delegate=(IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
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
    if(isSendToken==NO) [self setUserID];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [phud hide:YES];
    [TLToast showWithText:@"加载失败" topOffset:220.0f duration:1.5];
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
@end
