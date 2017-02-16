//
//  PointRuleViewController.m
//  IDIAI
//
//  Created by PM on 16/6/18.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PointRuleViewController.h"
#define headFont [UIFont systemFontOfSize:18]
@interface PointRuleViewController ()
@property(nonatomic,strong)UIWebView * webView;
@end

@implementation PointRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"积分规则";
     self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
     [self.view addSubview:_webView];

    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _webView.scalesPageToFit = YES;
    
    NSURLRequest * req =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:pointRuleUrl]];
    
     [_webView loadRequest:req];
    
   
                           
    
    
    
    
    
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)goToTop{

// [self.textView scrollsToTop];


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
