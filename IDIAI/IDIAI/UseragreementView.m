//
//  UseragreementView.m
//  IDIAI
//
//  Created by iMac on 14-7-15.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "UseragreementView.h"
#import "HexColor.h"

@implementation UseragreementView
@synthesize title_Lab,back_Button;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        control = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
        [control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        [self createCamerabg];
    }
    return self;
}

-(void)createCamerabg{
    UIImageView *view_camerabg=[[UIImageView alloc]initWithFrame:CGRectMake(-4, 0, kMainScreenWidth-12, 50)];
    view_camerabg.image=[UIImage imageNamed:@"用户协议标题栏.png"];
    view_camerabg.userInteractionEnabled=YES;
    [self addSubview:view_camerabg];
    
    
    back_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [back_Button setFrame:CGRectMake(260, 10,30, 30)];
    [back_Button setBackgroundImage:[UIImage imageNamed:@"用户协议关闭图标.png"] forState:UIControlStateNormal];
    [back_Button addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [view_camerabg addSubview:back_Button];
    
    title_Lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 100, 30)];
    title_Lab.backgroundColor = [UIColor clearColor];
    title_Lab.font = [UIFont boldSystemFontOfSize:22.0];
    title_Lab.textAlignment = NSTextAlignmentCenter;
    title_Lab.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    title_Lab.text =@"用户协议";
    [view_camerabg addSubview:title_Lab];
    
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0,43, kMainScreenWidth-20, self.frame.size.height-30)];
    webview.backgroundColor=[UIColor whiteColor];
    //webview.scalesPageToFit=YES;
    [self addSubview:webview];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"protocol" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
}

#pragma mark -
#pragma mark - Public Methods

- (void)show {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:control];
    [keywindow addSubview:self];
}

-(void)pressbtn:(UIButton *)btn{
    [control removeFromSuperview];
    self.frame=CGRectMake(10, kMainScreenHeight-270, kMainScreenWidth-20, 270);
    [UIView animateWithDuration:.25 animations:^{
        self.frame=CGRectMake(10, kMainScreenHeight, kMainScreenWidth-20, 270);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)dismiss{
     [control removeFromSuperview];
    self.frame=CGRectMake(10, kMainScreenHeight-270, kMainScreenWidth-20, 270);
    [UIView animateWithDuration:.25 animations:^{
        self.frame=CGRectMake(10, kMainScreenHeight, kMainScreenWidth-20, 270);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            control=nil;
           
        }
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
