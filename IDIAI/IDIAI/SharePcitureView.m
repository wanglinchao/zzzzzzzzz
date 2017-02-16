//
//  SharePcitureView.m
//  IDIAI
//
//  Created by iMac on 15-3-5.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SharePcitureView.h"

@implementation SharePcitureView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor blackColor];
        control = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
        [control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}
-(void)setIsdiary:(BOOL)isdiary{
    _isdiary =isdiary;
    if (self.isdiary==YES) {
        self.backgroundColor =[UIColor whiteColor];
    }
    [self createCamerabg];
}
-(void)createCamerabg{
    NSArray *img_arr=[NSArray arrayWithObjects:@"ic_weixin",@"ic_pengyouquan",@"ic_xinlangweibo",@"ic_qqkongjian", nil];
     NSArray *title_arr=[NSArray arrayWithObjects:@"微信好友",@"朋友圈",@"微博",@"QQ空间 ", nil];
    for (int i=0; i<[img_arr count]; i++) {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth/[img_arr count]*i, 67, kMainScreenWidth/[img_arr count], 20)];
        lab.backgroundColor=[UIColor clearColor];
        if (self.isdiary ==NO) {
            lab.textColor=[UIColor whiteColor];
        }else{
            lab.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
        }
        
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:13];
        lab.text=[title_arr objectAtIndex:i];
        [self addSubview:lab];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth/[img_arr count]*i, 10, kMainScreenWidth/[img_arr count], 80)];
        btn.tag=1000+i;
        [btn setImage:[UIImage imageNamed:[img_arr objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(10, (kMainScreenWidth/[img_arr count]-[UIImage imageNamed:[img_arr objectAtIndex:i]].size.width)/2-15, [UIImage imageNamed:[img_arr objectAtIndex:i]].size.height-5, (kMainScreenWidth/[img_arr count]-[UIImage imageNamed:[img_arr objectAtIndex:i]].size.width)/2-15)];
        [btn addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

#pragma mark -
#pragma mark - Public Methods

- (void)show {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:control];
    [keywindow addSubview:self];
}

-(void)pressbtn:(UIButton *)btn{
    [delegate SharePicCustomclickedButtonAtIndex:btn.tag-1000];
    
    self.frame=CGRectMake(0, kMainScreenHeight-100, kMainScreenWidth, 100);
    [UIView animateWithDuration:.25 animations:^{
        self.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 100);
    } completion:^(BOOL finished) {
        if (finished) {
            [control removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}
-(void)dismiss{
    self.frame=CGRectMake(0, kMainScreenHeight-100, kMainScreenWidth, 100);
    [UIView animateWithDuration:.25 animations:^{
        self.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 100);
    } completion:^(BOOL finished) {
        if (finished) {
            [control removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
