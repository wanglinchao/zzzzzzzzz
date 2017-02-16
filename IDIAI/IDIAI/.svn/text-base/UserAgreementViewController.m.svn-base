//
//  UserAgreementViewController.m
//  IDIAI
//
//  Created by Ricky on 14-11-24.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()

@end

@implementation UserAgreementViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    //导航栏颜色
//    self.navigationController.navigationBar.barTintColor = kThemeColor;
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    
    self.title = @"用户协议";
    
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    webview.backgroundColor=[UIColor whiteColor];
    //webview.scalesPageToFit=YES;
    [self.view addSubview:webview];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:cooperationAgreement]];
    [webview loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重写
- (void)backButtonPressed:(id)sender {
    if ([self.previousVCName isEqualToString:@"aboutUsVC"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
