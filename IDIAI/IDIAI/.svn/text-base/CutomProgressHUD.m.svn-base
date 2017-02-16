//
//  CutomProgressHUD.m
//  IDIAI
//
//  Created by iMac on 14-7-11.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CutomProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "DDIndicator.h"

@implementation CutomProgressHUD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor lightGrayColor];
        
        DDIndicator *ind = [[DDIndicator alloc] initWithFrame:CGRectMake(20,20, 60, 60)];
        [self addSubview:ind];
        [ind startAnimating];
        
          //将图层的边框设置为圆脚
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        //给图层添加一个有色边框
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    return self;
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
