//
//  CollectPictureCell.m
//  IDIAI
//
//  Created by iMac on 14-8-13.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CollectPictureCell.h"
#import "HexColor.h"

//修改为对外部模块不可见，避免重复定义 huangrun 20141124
//const CGFloat kTMPhotoQuiltViewMargin = 0;
static const CGFloat kTMPhotoQuiltViewMargin = 0;
//结束修改

@implementation CollectPictureCell

@synthesize photoView,bottom_bg,image_collect;
@synthesize image_love,lab_love;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index_id
{
    self = [super initWithReuseIdentifier:reuseIdentifier index:index_id];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.indexID=index_id;
        [self photoView];
        [self bottom_bg];
        [self image_collect];
        [self image_love];
        [self lab_love];
        
        [self _browseNumIV];
        [self _browseNumLabel];
        
        [self _collectIV];
        [self _collectNumLabel];
        
//        static BOOL wobblesLeft = NO;
//        CGFloat rotation = (3 * M_PI) / 180.0;//抖动效果
//        CGAffineTransform wobbleLeft = CGAffineTransformMakeRotation(rotation);
//        CGAffineTransform wobbleRight = CGAffineTransformMakeRotation(-rotation);
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.15];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationRepeatCount:99999999];
//        self.transform = wobblesLeft ? wobbleRight : wobbleLeft;
//        wobblesLeft = !wobblesLeft;
//        [UIView commitAnimations];
        
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
//        bottom_bg.image=[UIImage imageNamed:@"效果图下方背景条.png"];
        bottom_bg.contentMode = UIViewContentModeScaleAspectFill;
        bottom_bg.clipsToBounds = YES;
        [self addSubview:bottom_bg];
    }
    return bottom_bg;
}

- (UIImageView *)image_collect {
    if (!image_collect) {
        image_collect = [[UIImageView alloc] init];
        image_collect.userInteractionEnabled=YES;
        [bottom_bg addSubview:image_collect];
    }
    return image_collect;
}

- (UIImageView *)image_love {
    if (!image_love) {
        image_love = [[UIImageView alloc] init];
        image_love.userInteractionEnabled=YES;
        [bottom_bg addSubview:image_love];
    }
    return image_love;
}

- (UILabel *)lab_love {
    if (!lab_love) {
        lab_love = [[UILabel alloc] init];
        lab_love.font=[UIFont systemFontOfSize:14];
        lab_love.backgroundColor = [UIColor clearColor];
        lab_love.textColor =[UIColor colorWithHexString:@"#6d2907" alpha:1.0];
        lab_love.textAlignment = NSTextAlignmentLeft;
        [bottom_bg addSubview:lab_love];
    }
    return lab_love;
}

- (UIImageView *)_collectIV {
    if (!self.collectIV) {
        self.collectIV = [[UIImageView alloc] init];
        self.collectIV.userInteractionEnabled=YES;
        self.collectIV.contentMode = UIViewContentModeScaleToFill;
        //        self.collectIV.layer.cornerRadius=20;
        //        self.collectIV.layer.masksToBounds=YES;
        //        self.collectIV.clipsToBounds = YES;
        [bottom_bg addSubview:self.collectIV];
    }
    return self.collectIV;
}

- (UILabel *)_collectNumLabel {
    if (!self.collectNumLabel) {
        self.collectNumLabel = [[UILabel alloc]init];
        self.collectNumLabel.font=[UIFont systemFontOfSize:12];
        self.collectNumLabel.backgroundColor = [UIColor clearColor];
        self.collectNumLabel.textAlignment = NSTextAlignmentLeft;
        [bottom_bg addSubview:self.collectNumLabel];
    }
    return self.collectNumLabel;
}

- (UIImageView *)_browseNumIV {
    if (!self.browseNumIV) {
        self.browseNumIV = [[UIImageView alloc] init];
        self.browseNumIV.userInteractionEnabled=YES;
        self.browseNumIV.contentMode = UIViewContentModeScaleToFill;
        //        self.browseNumIV.layer.cornerRadius=20;
        //        self.browseNumIV.layer.masksToBounds=YES;
        //        self.browseNumIV.clipsToBounds = YES;
        [bottom_bg addSubview:self.browseNumIV];
    }
    return self.browseNumIV;
}

- (UILabel *)_browseNumLabel {
    if (!self.browseNumLabel) {
        self.browseNumLabel = [[UILabel alloc]init];
        self.browseNumLabel.font=[UIFont systemFontOfSize:12];
        self.browseNumLabel.backgroundColor = [UIColor clearColor];
        self.browseNumLabel.textAlignment = NSTextAlignmentLeft;
        [bottom_bg addSubview:self.browseNumLabel];
    }
    return self.browseNumLabel;
    
}


- (void)layoutSubviews {
//    if(self.indexID!=0){
        bottom_bg.frame = CGRectInset(CGRectMake(-5, self.bounds.size.height-53, self.bounds.size.width + 10, 60), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
//    photoView.frame = CGRectInset(CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height - 51), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        photoView.frame = CGRectInset(CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);//20150304
//        image_collect.frame = CGRectInset(CGRectMake(10,12,30,30), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
//        image_love.frame = CGRectInset(CGRectMake(45,20,40,15), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
//        lab_love.frame = CGRectMake(120,20,30,15);
    
    self.collectIV.frame = CGRectInset(CGRectMake(90,17,20,20), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
    self.collectNumLabel.frame = CGRectMake(120,20,30,15);
    self.collectNumLabel.textAlignment = NSTextAlignmentLeft;
    
    self.browseNumIV.frame = CGRectInset(CGRectMake(10,17,20,20), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
    self.browseNumLabel.frame = CGRectMake(45, 20, 30, 15);
    self.browseNumLabel.textAlignment = NSTextAlignmentLeft;

//    }
//    else{
//        photoView.frame = CGRectInset(CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
//    }
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
