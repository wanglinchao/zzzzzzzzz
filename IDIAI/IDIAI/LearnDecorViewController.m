//
//  LearnDecorViewController.m
//  IDIAI
//
//  Created by iMac on 15-7-3.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "LearnDecorViewController.h"
#import "TestBridge.h"
#import "IDIAIAppDelegate.h"
#import "savelogObj.h"
#import "NetworkRequest.h"
#import "JSONKit.h"

#import "WorkerSearcheMapViewController.h"

@interface LearnDecorViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    TestBridge *_bridge;
    
    UIActivityIndicatorView *activ;
    
//     NSString *_callNum;
}

@end

@implementation LearnDecorViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PushLearnToWorkerVC" object:nil];
}

-(void)backTouched:(UIButton *)btn{
    if([_webView canGoBack]) {
        [_webView goBack];
    }
    else{
        if([self.fromType isEqualToString:@"IWantDecor"]) [self.navigationController popViewControllerAnimated:NO];
        else [self.navigationController popViewControllerAnimated:NO];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [[[self navigationController] navigationBar] setHidden:YES];
    [self.tabBarController.navigationController setNavigationBarHidden:YES];
    IDIAIAppDelegate *delegate=(IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [[delegate.nav navigationBar] setHidden:YES];

    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.navigationController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);//修复底部有白条问题
}

-(void)viewWillDisappear:(BOOL)animated{
    [[[self navigationController] navigationBar] setHidden:NO];
    [self.tabBarController.navigationController setNavigationBarHidden:NO];
    IDIAIAppDelegate *delegate=(IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [[delegate.nav navigationBar] setHidden:NO];
}
-(void)PushLearnToWorkerVC:(NSNotification *)notif{
    
    WorkerSearcheMapViewController *searchvc=[[WorkerSearcheMapViewController alloc]init];
    searchvc.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:searchvc];
    [self presentViewController:nav animated:NO completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PushLearnToWorkerVC:) name:@"PushLearnToWorkerVC" object:nil];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    
    NSString *url=kUrlLearnDecorate;
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    //设置oc和js的桥接
    _bridge = [TestBridge bridgeForWebView:_webView webViewDelegate:self];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:req];
    
    activ=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activ.center= CGPointMake(kMainScreenWidth/2, kMainScreenHeight/2);
    [activ setHidesWhenStopped:YES]; //当旋转结束时隐藏
    [self.view addSubview:activ];
    
//    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 90, 40)];
//    [rightButton setImage:[UIImage imageNamed:@"btn_dianhua"] forState:UIControlStateNormal];
//    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 25, 0, -5);
//    [rightButton addTarget:self
//                    action:@selector(clickTelBtn:)
//          forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 15, 90, 40)];
    [leftButton setImage:[UIImage imageNamed:@"btn_dianhua"] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, -5)];
    [leftButton addTarget:self
                   action:@selector(callPhone:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(kMainScreenWidth-80, 20, 80, 40)];
    [rightButton setImage:[UIImage imageNamed:@"ic_chacha"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 30, 3, 5);
    [rightButton addTarget:self
                   action:@selector(backTouched:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
//    [self requestCallNum];
}

#pragma mark -
#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [activ startAnimating]; // 开始旋转
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [activ stopAnimating]; // 停止旋转
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [activ stopAnimating]; // 停止旋转
}

#pragma mark -
#pragma mark - CallPhone
-(void)callPhone:(UIButton *)sender{
    
    [savelogObj saveLog:@"联系客服" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:29];
    
//    if (_callNum) {
        UIWebView *callWebview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[callNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]]];
        callWebview.hidden = YES;
        // Assume we are in a view controller and have access to self.view
        [self.view addSubview:callWebview];
        
//    } else {
//        [self requestCallNum];
//    }
}

//#pragma mark - 获取电话号码
//- (void)requestCallNum {
//    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(parsingQueue, ^{
//        
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
//        
//        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
//        [postDict setObject:@"ID0036" forKey:@"cmdID"];
//        [postDict setObject:@"" forKey:@"token"];
//        [postDict setObject:@"" forKey:@"userID"];
//        [postDict setObject:@"iOS" forKey:@"deviceType"];
//        NSString *string=[postDict JSONString];
//        
//        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
//        [post setObject:string forKey:@"header"];
//        [post setObject:@"" forKey:@"body"];
//        
//        
//        NetworkRequest *req = [[NetworkRequest alloc] init];
//        [req setHttpMethod:PostMethod];
//        
//        [req sendToServerInBackground:^{
//            dispatch_async(parsingQueue, ^{
//                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
//                [request setResponseEncoding:NSUTF8StringEncoding];
//                NSString *respString = [request responseString];
//                NSDictionary *jsonDict = [respString objectFromJSONString];
//                NSLog(@"返回信息：%@",jsonDict);
//                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10361) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        _callNum = [jsonDict objectForKey:@"fbPhoneNumber"];
//                        NSLog(@"获取电话成功");
//                    });
//                }
//                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10369){
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSLog(@"获取电话失败");
//                    });
//                } else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                    });
//                }
//            });
//        }
//                          failedBlock:^{
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  
//                              });
//                          }
//                               method:url postDict:post];
//    });
//    
//}

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
