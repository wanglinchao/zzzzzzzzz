//
//  SearchShopCell.m
//  IDIAI
//
//  Created by iMac on 14-8-5.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SearchShopCell.h"
#import "HexColor.h"
#import <QuartzCore/QuartzCore.h>

//修改为对外部模块不可见，避免重复定义 huangrun 20141124
//const CGFloat kTMPhotoQuiltViewMargin = 0;
static const CGFloat kTMPhotoQuiltViewMargin = 0;
//结束修改

@implementation SearchShopCell
@synthesize photoView,bottom_bg;
@synthesize Label_designer;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index_id
{
    self = [super initWithReuseIdentifier:reuseIdentifier index:index_id];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.indexID=index_id;
        [self photoView];
        [self bottom_bg];
        [self Label_designer];
    }
    return self;
}

- (UIImageView *)photoView {
    if (!photoView) {
        photoView = [[UIImageView alloc] init];
        photoView.userInteractionEnabled=YES;
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        [self addSubview:photoView];
    }
    return photoView;
}
- (UIImageView *)bottom_bg {
    if (!bottom_bg) {
        bottom_bg = [[UIImageView alloc] init];
        bottom_bg.userInteractionEnabled=YES;
        bottom_bg.backgroundColor=[UIColor blackColor];
        bottom_bg.alpha=0.55;
        bottom_bg.contentMode = UIViewContentModeScaleAspectFill;
        bottom_bg.clipsToBounds = YES;
        [self addSubview:bottom_bg];
    }
    return bottom_bg;
}


- (UILabel *)Label_designer {
    if (!Label_designer) {
        Label_designer = [[UILabel alloc] init];
        Label_designer.font=[UIFont systemFontOfSize:16];
        Label_designer.backgroundColor = [UIColor clearColor];
        Label_designer.textColor =[UIColor whiteColor];
        Label_designer.textAlignment = NSTextAlignmentCenter;
        [bottom_bg addSubview:Label_designer];
    }
    return Label_designer;
}


- (void)layoutSubviews {
    bottom_bg.frame = CGRectInset(CGRectMake(0, self.bounds.size.height-35, self.bounds.size.width, 35), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
    photoView.frame = CGRectInset(CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
     Label_designer.frame = CGRectMake(17,7.5,100,20);
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
