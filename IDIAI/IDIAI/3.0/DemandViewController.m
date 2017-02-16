//
//  DemandViewController.m
//  IDIAI
//
//  Created by Ricky on 16/3/18.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DemandViewController.h"

@interface DemandViewController ()<UIWebViewDelegate>

@end

@implementation DemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (iOS_7_Above) {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    UIWebView *webView_=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    webView_.delegate=self;
    [self.view addSubview:webView_];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"indexusp" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView_ loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
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
