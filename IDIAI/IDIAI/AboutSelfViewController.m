//
//  AboutSelfViewController.m
//  UTopSP
//
//  Created by iMac on 15-7-29.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "AboutSelfViewController.h"
#import "UserAgreementViewController.h"
#import "Macros.h"
#import "HexColor.h"
#import "util.h"
#define kCurrentVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

@interface AboutSelfViewController ()

@end

@implementation AboutSelfViewController

- (void)customizeNavigationBar {
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:20];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor blackColor];
    lab_nav_title.text=@"关于我们";
    self.navigationItem.titleView = lab_nav_title;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    leftButton.tag=1;
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 50);
    
    [leftButton addTarget:self
                   action:@selector(PressbackTouched)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
}

-(void)PressbackTouched{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    [self customizeNavigationBar];
    
    [self CreateThings];
}

-(void)CreateThings{
    
    UIScrollView *mainView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    mainView.showsHorizontalScrollIndicator=NO;
    mainView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:mainView];
    
    float height=30;
    
    UIImageView *appLogo=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-66)/2, height, 65, 65)];
    appLogo.image=[UIImage imageNamed:@"ic_guanyu"];
    [mainView addSubview:appLogo];
    
    height+=75;
    
    UILabel *appName=[[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-160)/2, height, 160, 20)];
    appName.font=[UIFont systemFontOfSize:14];
    appName.textAlignment=NSTextAlignmentCenter;
    appName.backgroundColor=[UIColor clearColor];
    appName.textColor=[UIColor darkGrayColor];
    appName.text=[NSString stringWithFormat:@"屋托邦 v%@", kCurrentVersion];
    [mainView addSubview:appName];
    
    height+=60;
    
    UIView *topLine=[[UIView alloc]initWithFrame:CGRectMake(20, height, kMainScreenWidth-20, 0.5)];
    topLine.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
    [mainView addSubview:topLine];
    
    UILabel *codeTitle=[[UILabel alloc]initWithFrame:CGRectMake(25, height, 100, 50)];
    codeTitle.font=[UIFont systemFontOfSize:17];
    codeTitle.textAlignment=NSTextAlignmentLeft;
    codeTitle.backgroundColor=[UIColor clearColor];
    codeTitle.textColor=[UIColor darkGrayColor];
    codeTitle.text=@"用户协议";
    [mainView addSubview:codeTitle];
    
    UIImageView *jiantouLogo1=[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-35, height+10, 30, 30)];
    jiantouLogo1.image=[UIImage imageNamed:@"ic_jiantou"];
    [mainView addSubview:jiantouLogo1];
    
    UIButton *codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeButton setFrame:CGRectMake(0, height, kMainScreenWidth, 50)];
    [codeButton addTarget:self
                   action:@selector(clickProtocolBtn:)
         forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:codeButton];
    
    height+=50;
    
    UIView *centerLine=[[UIView alloc]initWithFrame:CGRectMake(20, height, kMainScreenWidth-20, 0.5)];
    centerLine.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
    [mainView addSubview:centerLine];
    
    UILabel *websiteTitle=[[UILabel alloc]initWithFrame:CGRectMake(25, height, 100, 50)];
    websiteTitle.font=[UIFont systemFontOfSize:17];
    websiteTitle.textAlignment=NSTextAlignmentLeft;
    websiteTitle.backgroundColor=[UIColor clearColor];
    websiteTitle.textColor=[UIColor darkGrayColor];
    websiteTitle.text=@"产品官网";
    [mainView addSubview:websiteTitle];
    
    UIImageView *jiantouLogo2=[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-33, height+10, 30, 30)];
    jiantouLogo2.image=[UIImage imageNamed:@"ic_jiantou"];
    [mainView addSubview:jiantouLogo2];
    
    UIButton *websiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [websiteButton setFrame:CGRectMake(0, height, kMainScreenWidth, 50)];
    [websiteButton addTarget:self
                      action:@selector(clickOfficialWebsiteBtn:)
         forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:websiteButton];
    
    height+=50;
    
    UIView *bottomLine=[[UIView alloc]initWithFrame:CGRectMake(20, height, kMainScreenWidth-20, 0.5)];
    bottomLine.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
    [mainView addSubview:bottomLine];
    
    height+=17;
    
    UILabel * attentionTitle=[[UILabel alloc]initWithFrame:CGRectMake(25, height, 100, 20)];
    attentionTitle.font=[UIFont systemFontOfSize:17];
    attentionTitle.textAlignment=NSTextAlignmentLeft;
    attentionTitle.backgroundColor=[UIColor clearColor];
    attentionTitle.textColor=[UIColor darkGrayColor];
    attentionTitle.text=@"关注我们";
    [mainView addSubview:attentionTitle];
    
    height+=40;
    
    UIImageView *weixinLogo=[[UIImageView alloc]initWithFrame:CGRectMake(40*kMainScreenWidth/320, height, 80, 80)];
    weixinLogo.image=[UIImage imageNamed:@"ic_weixin_about"];
    [mainView addSubview:weixinLogo];
    
    UIImageView *weiboLogo=[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-(80+40*kMainScreenWidth/320), height, 80, 80)];
    weiboLogo.image=[UIImage imageNamed:@"ic_weibo_about"];
    [mainView addSubview:weiboLogo];
    
    height+=90;
    
    UILabel * topWeixinTitle=[[UILabel alloc]initWithFrame:CGRectMake(weixinLogo.frame.origin.x, height, 80, 20)];
    topWeixinTitle.font=[UIFont systemFontOfSize:15];
    topWeixinTitle.textAlignment=NSTextAlignmentCenter;
    topWeixinTitle.backgroundColor=[UIColor clearColor];
    topWeixinTitle.textColor=[UIColor darkGrayColor];
    topWeixinTitle.text=@"微信关注";
    [mainView addSubview:topWeixinTitle];
    
    UILabel * topWeiboTitle=[[UILabel alloc]initWithFrame:CGRectMake(weiboLogo.frame.origin.x, height, 80, 20)];
    topWeiboTitle.font=[UIFont systemFontOfSize:15];
    topWeiboTitle.textAlignment=NSTextAlignmentCenter;
    topWeiboTitle.backgroundColor=[UIColor clearColor];
    topWeiboTitle.textColor=[UIColor darkGrayColor];
    topWeiboTitle.text=@"微博关注";
    [mainView addSubview:topWeiboTitle];
    
    height+=20;
    
    UILabel * bottomWeixinTitle=[[UILabel alloc]initWithFrame:CGRectMake(weixinLogo.frame.origin.x-5, height, 90, 20)];
    bottomWeixinTitle.font=[UIFont systemFontOfSize:16];
    bottomWeixinTitle.textAlignment=NSTextAlignmentCenter;
    bottomWeixinTitle.backgroundColor=[UIColor clearColor];
    bottomWeixinTitle.textColor=[UIColor darkGrayColor];
    bottomWeixinTitle.text=@"\"装修微刊\"";
//    [mainView addSubview:bottomWeixinTitle];
    
    UILabel * bottomWeiboTitle=[[UILabel alloc]initWithFrame:CGRectMake(weiboLogo.frame.origin.x-30, height, 140, 20)];
    bottomWeiboTitle.font=[UIFont systemFontOfSize:16];
    bottomWeiboTitle.textAlignment=NSTextAlignmentCenter;
    bottomWeiboTitle.backgroundColor=[UIColor clearColor];
    bottomWeiboTitle.textColor=[UIColor darkGrayColor];
    bottomWeiboTitle.text=@"\"屋托邦装修App\"";
//    [mainView addSubview:bottomWeiboTitle];
    
    height+=60;
    
    float companyHeight=0;
    if(height<kMainScreenHeight-64-60) companyHeight=kMainScreenHeight-64-60;
    else companyHeight=height;
    
    UILabel * signCompany=[[UILabel alloc]initWithFrame:CGRectMake(10, companyHeight, kMainScreenWidth-20, 20)];
    signCompany.font=[UIFont systemFontOfSize:15];
    signCompany.textAlignment=NSTextAlignmentCenter;
    signCompany.backgroundColor=[UIColor clearColor];
    signCompany.textColor=[UIColor lightGrayColor];
    CGSize labelsize1 = [util calHeightForLabel:@"© 2014 Trond  Technology (SiChuan) Co.,Ltd. All rights reserved." width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:15]];
    signCompany.text=@"© 2014 Trond  Technology (SiChuan) Co.,Ltd. All rights reserved.";
    signCompany.frame =CGRectMake(signCompany.frame.origin.x, signCompany.frame.origin.y, labelsize1.width, labelsize1.height);
    signCompany.numberOfLines =0;
    [mainView addSubview:signCompany];
    
    height+=labelsize1.height;
    
    UILabel * signCompany_=[[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-220)/2, companyHeight+labelsize1.height, 220, 20)];
    signCompany_.font=[UIFont systemFontOfSize:15];
    signCompany_.textAlignment=NSTextAlignmentCenter;
    signCompany_.backgroundColor=[UIColor clearColor];
    signCompany_.textColor=[UIColor lightGrayColor];
    signCompany_.text=@"All rights reserved";
//    [mainView addSubview:signCompany_];
    
    if(height<kMainScreenHeight-64-60) height+=100;
    else height+=40;
    
    mainView.contentSize=CGSizeMake(kMainScreenWidth, height);
}

- (void)clickProtocolBtn:(id)sender {
    UserAgreementViewController *userAgreementVC = [[UserAgreementViewController alloc]init];
    userAgreementVC.previousVCName = @"aboutUsVC";
    [self.navigationController pushViewController:userAgreementVC animated:YES];
}

- (void)clickOfficialWebsiteBtn:(id)sender {
    NSString *urlStr = @"HTTP://TROND.CN";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
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
