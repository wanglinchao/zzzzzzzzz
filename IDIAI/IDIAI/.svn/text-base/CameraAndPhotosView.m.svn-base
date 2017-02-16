//
//  CameraAndPhotosView.m
//  IDIAI
//
//  Created by iMac on 14-7-14.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CameraAndPhotosView.h"
#import "HexColor.h"

@implementation CameraAndPhotosView
@synthesize photo_Button,camera_Button,back_Button;
@synthesize camera_Lab,photo_Lab,delegate;

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
    UIImageView *view_camerabg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 170)];
    view_camerabg.image=[UIImage imageNamed:@"拍照图片背景.png"];
    view_camerabg.userInteractionEnabled=YES;
    [self addSubview:view_camerabg];
    
    photo_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [photo_Button setFrame:CGRectMake(50, 60,60, 60)];
    photo_Button.tag=1;
    [photo_Button setBackgroundImage:[UIImage imageNamed:@"照片选择按钮1.png"] forState:UIControlStateNormal];
    [photo_Button setBackgroundImage:[UIImage imageNamed:@"照片选择按钮.png"] forState:UIControlStateHighlighted];
    [photo_Button addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [view_camerabg addSubview:photo_Button];
    
    camera_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [camera_Button setFrame:CGRectMake(210, 60,60, 60)];
    camera_Button.tag=2;
    [camera_Button setBackgroundImage:[UIImage imageNamed:@"拍照按钮.png"] forState:UIControlStateNormal];
    [camera_Button setBackgroundImage:[UIImage imageNamed:@"拍照点击效果.png"] forState:UIControlStateHighlighted];
    [camera_Button addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [view_camerabg addSubview:camera_Button];
    
    back_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [back_Button setFrame:CGRectMake(140, 20,40, 30)];
    back_Button.tag=3;
    [back_Button setBackgroundImage:[UIImage imageNamed:@"向下按钮.png"] forState:UIControlStateNormal];
    [back_Button addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [view_camerabg addSubview:back_Button];
    
    photo_Lab = [[UILabel alloc] initWithFrame: CGRectMake(50, 120, 60, 30)];
    photo_Lab.backgroundColor = [UIColor clearColor];
    photo_Lab.font = [UIFont boldSystemFontOfSize:22.0];
    photo_Lab.textAlignment = NSTextAlignmentCenter;
    photo_Lab.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    photo_Lab.text =@"照片";
    [self addSubview:photo_Lab];
    
    camera_Lab = [[UILabel alloc] initWithFrame: CGRectMake(210, 120, 60, 30)];
    camera_Lab.backgroundColor = [UIColor clearColor];
    camera_Lab.font = [UIFont boldSystemFontOfSize:22.0];
    camera_Lab.textAlignment = NSTextAlignmentCenter;
    camera_Lab.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    camera_Lab.text =@"拍照";
    [self addSubview:camera_Lab];
}

#pragma mark -
#pragma mark - Public Methods

- (void)show {
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
      [keywindow addSubview:control];
      [keywindow addSubview:self];
}

-(void)pressbtn:(UIButton *)btn{
    [delegate CameraAndPhotoCustom:self clickedButtonAtIndex:btn.tag];
    
    self.frame=CGRectMake(0, kMainScreenHeight-170, 320, 170);
    [UIView animateWithDuration:.25 animations:^{
        self.frame=CGRectMake(0, kMainScreenHeight, 320, 170);
    } completion:^(BOOL finished) {
        if (finished) {
            [control removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}
-(void)dismiss{
    self.frame=CGRectMake(0, kMainScreenHeight-170, 320, 170);
    [UIView animateWithDuration:.25 animations:^{
        self.frame=CGRectMake(0, kMainScreenHeight, 320, 170);
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
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
