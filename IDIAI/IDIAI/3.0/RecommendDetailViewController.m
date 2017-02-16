//
//  RecommendDetailViewController.m
//  IDIAI
//
//  Created by Ricky on 16/2/29.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "RecommendDetailViewController.h"
#import "TestBridge.h"
#import "savelogObj.h"
#import "NJKWebViewProgressView.h"
#import "TLToast.h"
#import "IDIAI3DesignerDetailViewController.h"
#import "IDIAI3GongZhangDetaileViewController.h"
#import "IDIAI3JianLiDetailViewController.h"
#import "EffectTAOTUPictureInfo.h"
#import "IDIAI3DiaryDetaileViewController.h"
#import "BuidlDetailViewController.h"

@interface RecommendDetailViewController (){
    UIWebView *_webView;
    TestBridge *_bridge;
    
    UIActivityIndicatorView *actIndicView;
    BOOL isSendToken;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@end

@implementation RecommendDetailViewController

- (void)backButtonPressed:(id)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithHexString:@"#F0F0F5" alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetBrandShop:) name:@"GetBrandShop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FlickingSucceed:) name:@"FlickingSucceed" object:nil];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    _webView.backgroundColor=[UIColor clearColor];
    //_webView.delegate = self;
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
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:req];
    
    // Do any additional setup after loading the view.
}
-(void)FlickingSucceed:(NSNotification *)notif{
    NSString* js = [NSString stringWithFormat:@"setSweepCode('%@');",[notif object]];
    [_webView stringByEvaluatingJavaScriptFromString:js];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCDetaileViewController" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetBrandShop" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FlickingSucceed" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushVCDetaileViewController" object:nil];
    [_progressView removeFromSuperview];
    _progressProxy=nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVCDetaileViewController:) name:@"pushVCDetaileViewController" object:nil];
}
#pragma mark -
#pragma mark - 通知

-(void)pushVCDetaileViewController:(NSNotification *)notif{
    NSArray *array =[NSArray arrayWithArray:notif.object];
    NSInteger indexType=[[array objectAtIndex:1] integerValue];
    NSInteger contentId=[[array objectAtIndex:0] integerValue];
    if(indexType==1){
        /*设计师*/
        IDIAI3DesignerDetailViewController *Designerinfovc = [[IDIAI3DesignerDetailViewController alloc]init];
        Designerinfovc.designerID = contentId;
        [self.navigationController pushViewController:Designerinfovc animated:YES];
    }
    else if (indexType==2){
        /*工长*/
        IDIAI3GongZhangDetaileViewController *gzinfovc =[[IDIAI3GongZhangDetaileViewController alloc] init];
        gzinfovc.gongZhangID=contentId;
        [self.navigationController pushViewController:gzinfovc animated:YES];
    }
    else if (indexType==3){
        /*监理*/
        IDIAI3JianLiDetailViewController *jlinfovc =[[IDIAI3JianLiDetailViewController alloc] init];
        jlinfovc.jianliID=contentId;
        [self.navigationController pushViewController:jlinfovc animated:YES];
    }
    else if (indexType==4){
        /*案例*/
        EffectTAOTUPictureInfo *effVC=[[EffectTAOTUPictureInfo alloc]init];
        effVC.taotuID=contentId;
//        effVC.type_into=1;
        effVC.selectDone =^(MyeffectPictureObj *obj_pic){
            
        };
        [self.navigationController pushViewController:effVC animated:YES];
    }
    else if (indexType==5){
        /*日记*/
        IDIAI3DiaryDetaileViewController *detail =[[IDIAI3DiaryDetaileViewController alloc] init];
        detail.title =@"帖子详情";
        detail.diaryId =[NSString stringWithFormat:@"%d",(int)contentId];
        detail.type =7;
        detail.ismyDiary =NO;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (indexType==6){
        /*工地*/
        BuidlDetailViewController *buidldetail =[[BuidlDetailViewController alloc] init];
        buidldetail.title =@"工地详情";
        buidldetail.foremanSitesId =[NSString stringWithFormat:@"%d",(int)contentId];
        [self.navigationController pushViewController:buidldetail animated:YES];
    }
    else if (indexType==8){
        /*商品*/
        RecommendDetailViewController *recommend =[[RecommendDetailViewController alloc] init];
        recommend.title =@"商品详情";
        recommend.url =[NSString stringWithFormat:@"%@utopMall/wap/goods/goodsDetail?goodsId=%d",[[NSUserDefaults standardUserDefaults] objectForKey:@"hostNameShop"],(int)contentId];
        [self.navigationController pushViewController:recommend animated:YES];
    }
    else if (indexType==9){
        /*品牌*/
        RecommendDetailViewController *recommend =[[RecommendDetailViewController alloc] init];
        recommend.title =@"品牌";
        recommend.url =[NSString stringWithFormat:@"%@utopMall/wap/brand/more?brandId=%d",[[NSUserDefaults standardUserDefaults] objectForKey:@"hostNameShop"],(int)contentId];
        [self.navigationController pushViewController:recommend animated:YES];
    }
}

-(void)GetBrandShop:(NSNotification *)notif{
    NSString *urlBrand=[notif object];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlBrand]];
    [_webView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    //    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if(isSendToken==NO) [self setUserID];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
