//
//  IDIAI3EngineerSupportControlViewController.m
//  IDIAI
//
//  Created by iMac on 16/2/22.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3EngineerSupportControlViewController.h"

@interface IDIAI3EngineerSupportControlViewController ()
@property(nonatomic,strong)UIWebView * webView;
@end

@implementation IDIAI3EngineerSupportControlViewController


- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"施工节点控制";
    self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.view.backgroundColor=[UIColor whiteColor];
    self.view.backgroundColor = [UIColor lightGrayColor];

    [self createView];
}

-(void)createView{
//    self.title = @"积分规则";

    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    [self.view addSubview:_webView];
    
    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _webView.scalesPageToFit = YES;
    
    NSURLRequest * req =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:constructDetail]];
    
    [_webView loadRequest:req];
//    UIScrollView *scr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
//    [self.view addSubview:scr];
//    
//    float height=0;
//    for(int i=2;i<=10;i++){
//        NSString *Path=[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"gong-d_%d",i] ofType:@"jpg"];
//        UIImage *img=[[UIImage alloc]initWithContentsOfFile:Path];
//        UIImageView *imageView_=[[UIImageView alloc]initWithFrame:CGRectMake(0, height, kMainScreenWidth, img.size.height*kMainScreenWidth/img.size.width)];
//        imageView_.image=img;
//        [scr addSubview:imageView_];
//        
//        height+=img.size.height*kMainScreenWidth/ img.size.width;
//    }
//    
//    scr.contentSize=CGSizeMake(kMainScreenWidth, height);
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
