//
//  OfficialWebsiteViewController.m
//  IDIAI
//
//  Created by Ricky on 14-12-24.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "OfficialWebsiteViewController.h"

@interface OfficialWebsiteViewController ()

@end

@implementation OfficialWebsiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"产品官网";
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
//    NSString *urlStr = @"http://qttecx.com";
    NSString *urlStr = @"http://192.168.3.22:8080/activity/scratchcard/userinfo";
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
