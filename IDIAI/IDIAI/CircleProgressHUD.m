//
//  CircleProgressHUD.m
//  IDIAI
//
//  Created by iMac on 14-7-11.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CircleProgressHUD.h"

@implementation CircleProgressHUD

- (id)initWithFrame:(CGRect)frame title:(NSString *)title{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        control = [[UIControl alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64)];
        control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.02];
        
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"crl_bg.png"]];
        imageview.frame = CGRectMake(0, 0, 120, 120);
        [self addSubview:imageview];
        
        [self createAnmation];
    }
    return self;
}

-(void)createAnmation{
    UIImageView* animView= [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    animView.animationImages = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"crl_0.png"],
                                [UIImage imageNamed:@"crl_1.png"],
                                [UIImage imageNamed:@"crl_2.png"],
                                [UIImage imageNamed:@"crl_3.png"],
                                [UIImage imageNamed:@"crl_4.png"],
                                [UIImage imageNamed:@"crl_5.png"],[UIImage imageNamed:@"crl_6.png"],[UIImage imageNamed:@"crl_7.png"],nil];
    
    animView.animationDuration = 0.7;
    animView.animationRepeatCount = 0;
    [animView startAnimating];
    [self addSubview:animView];
    
}

- (void)show {
        self.alpha = 1.0;
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview:control];
        [keywindow addSubview:self];
}

-(void)hide{
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.2, 0.2);
    } completion:^(BOOL finished) {
        if (finished) {
            [control removeFromSuperview];
            control=nil;
            [self removeFromSuperview];
        }
    }];
    
}

//- (void)show {
//    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
//        [keywindow addSubview:control];
//        [keywindow addSubview:self];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
