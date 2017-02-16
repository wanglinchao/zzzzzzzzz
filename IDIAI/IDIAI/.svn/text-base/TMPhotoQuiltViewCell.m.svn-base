//
//  TMQuiltView
//
//  Created by Bruno Virlet on 7/20/12.
//
//  Copyright (c) 2012 1000memories

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//


#import "TMPhotoQuiltViewCell.h"
#import "HexColor.h"
#import <QuartzCore/QuartzCore.h>

//修改为对外部模块不可见，避免重复定义 huangrun 20141124
//const CGFloat kTMPhotoQuiltViewMargin = 0;
static const CGFloat kTMPhotoQuiltViewMargin = 0;
//结束修改

@implementation TMPhotoQuiltViewCell

@synthesize photoView,bottom_bg,designer_photoView,topshadow_img;
@synthesize Label_designer,houseDesc,houseTAndAAndPOrS;


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index_id type:(NSInteger)type
{
    self = [super initWithReuseIdentifier:reuseIdentifier index:index_id];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if(type==0) {
            self.layer.cornerRadius=8;
            self.layer.masksToBounds=YES;
        }
        
        self.indexID=index_id;
        self.typeInteger = type;
        [self photoView];
        [self bottom_bg];
        [self designer_photoView];
        [self Label_designer];
        
        [self topshadow_img];  //图片头部加一定高度的阴影
        if(self.typeInteger==0) [self Lable_houseDesc];  //单图加描述
        [self Label_houseTAndAAndPOrS];
        
        [self _browseNumIV];
        [self _browseNumLabel];
        [self _collectIV];
        [self _collectNumLabel];
        
        //套图加数量
        if(self.typeInteger==1) {
            [self _pictureCountIV];
            [self _pictureCountLabel];
        }
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
        bottom_bg.backgroundColor=[UIColor clearColor];
        bottom_bg.contentMode = UIViewContentModeScaleAspectFill;
        bottom_bg.clipsToBounds = YES;
        [self addSubview:bottom_bg];
    }
    return bottom_bg;
}

- (UIImageView *)designer_photoView {
    if (!designer_photoView) {
        designer_photoView = [[UIImageView alloc] init];
        designer_photoView.userInteractionEnabled=YES;
        designer_photoView.contentMode = UIViewContentModeScaleAspectFill;
        designer_photoView.clipsToBounds = YES;
        if(self.typeInteger==0){
            designer_photoView.layer.cornerRadius=22.5;
             designer_photoView.layer.borderWidth = 1.5;  // 给图层添加一个有色边框
        }
        else{
            designer_photoView.layer.cornerRadius=27.5;  //将图层的边框设置为圆脚
             designer_photoView.layer.borderWidth = 1.5;  // 给图层添加一个有色边框
        }
        designer_photoView.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1.0].CGColor;
        designer_photoView.layer.masksToBounds=YES;   // 隐藏边界
//        designer_photoView.layer.shadowOffset = CGSizeMake(0, 3);  // 设置阴影的偏移量
//        designer_photoView.layer.shadowRadius = 10.0;  // 设置阴影的半径
//        designer_photoView.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
//        designer_photoView.layer.shadowOpacity = 0.9; // 设置阴影的不透明度
        [self addSubview:designer_photoView];
    }
    return designer_photoView;
}

- (UILabel *)Label_designer {
    if (!Label_designer) {
        Label_designer = [[UILabel alloc] init];
        Label_designer.font=[UIFont systemFontOfSize:15];
        Label_designer.backgroundColor = [UIColor clearColor];
        Label_designer.textColor =[UIColor colorWithHexString:@"#636569" alpha:1.0];
        if(self.typeInteger==0) Label_designer.textAlignment = NSTextAlignmentCenter;
        else Label_designer.textAlignment = NSTextAlignmentCenter;
        [bottom_bg addSubview:Label_designer];
    }
    return Label_designer;
}

- (UIImageView *)topshadow_img {
    if (!topshadow_img) {
        topshadow_img = [[UIImageView alloc] init];
        topshadow_img.userInteractionEnabled=YES;
        topshadow_img.image=[UIImage imageNamed:@"bg_action-bar_picture"];
        topshadow_img.alpha=0.3;
        [self addSubview:topshadow_img];
    }
    
    return topshadow_img;
}

- (UILabel *)Lable_houseDesc {
    if (!houseDesc) {
        houseDesc = [[UILabel alloc] init];
        houseDesc.font=[UIFont systemFontOfSize:14];
        houseDesc.backgroundColor = [UIColor clearColor];
        houseDesc.textColor =[UIColor colorWithHexString:@"#CCCCCC" alpha:1.0];
        houseDesc.textAlignment = NSTextAlignmentRight;
        [bottom_bg addSubview:houseDesc];
    }
    
    return houseDesc;
}

- (UILabel *)Label_houseTAndAAndPOrS {
    if (!houseTAndAAndPOrS) {
        houseTAndAAndPOrS = [[UILabel alloc] init];
        houseTAndAAndPOrS.font=[UIFont systemFontOfSize:14];
        houseTAndAAndPOrS.backgroundColor = [UIColor clearColor];
        houseTAndAAndPOrS.textColor =[UIColor colorWithHexString:@"#CCCCCC" alpha:1.0];
        if(self.typeInteger==0) houseTAndAAndPOrS.textAlignment = NSTextAlignmentRight;
        else houseTAndAAndPOrS.textAlignment = NSTextAlignmentCenter;
        [bottom_bg addSubview:houseTAndAAndPOrS];
    }
    
    return houseTAndAAndPOrS;
}

- (UIImageView *)_collectIV {
    if (!self.collectIV) {
        self.collectIV = [[UIImageView alloc] init];
        self.collectIV.userInteractionEnabled=YES;
        self.collectIV.contentMode = UIViewContentModeScaleAspectFill;
//        self.collectIV.layer.cornerRadius=20;
//        self.collectIV.layer.masksToBounds=YES;
//        self.collectIV.clipsToBounds = YES;
        [self addSubview:self.collectIV];
    }
    return self.collectIV;
}

- (UILabel *)_collectNumLabel {
    if (!self.collectNumLabel) {
        self.collectNumLabel = [[UILabel alloc]init];
        self.collectNumLabel.font=[UIFont systemFontOfSize:15];
        self.collectNumLabel.backgroundColor = [UIColor clearColor];
        self.collectNumLabel.textAlignment = NSTextAlignmentLeft;
        self.collectNumLabel.textColor=[UIColor whiteColor];
        [self addSubview:self.collectNumLabel];
    }
    return self.collectNumLabel;
}

- (UIImageView *)_browseNumIV {
    if (!self.browseNumIV) {
        self.browseNumIV = [[UIImageView alloc] init];
        self.browseNumIV.userInteractionEnabled=YES;
        self.browseNumIV.contentMode = UIViewContentModeScaleAspectFill;
//        self.browseNumIV.layer.cornerRadius=20;
//        self.browseNumIV.layer.masksToBounds=YES;
//        self.browseNumIV.clipsToBounds = YES;
        [self addSubview:self.browseNumIV];
    }
    return self.browseNumIV;
}

- (UILabel *)_browseNumLabel {
    if (!self.browseNumLabel) {
        self.browseNumLabel = [[UILabel alloc]init];
        self.browseNumLabel.font=[UIFont systemFontOfSize:15];
        self.browseNumLabel.backgroundColor = [UIColor clearColor];
        self.browseNumLabel.textAlignment = NSTextAlignmentLeft;
        self.browseNumLabel.textColor=[UIColor whiteColor];
        [self addSubview:self.browseNumLabel];
    }
    return self.browseNumLabel;

}

- (UIImageView *)_pictureCountIV {
    if (!self.pictureCountIV) {
        self.pictureCountIV = [[UIImageView alloc] init];
        self.pictureCountIV.userInteractionEnabled=YES;
        self.pictureCountIV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.pictureCountIV];
    }
    return self.pictureCountIV;
    
}

- (UILabel *)_pictureCountLabel {
    if (!self.pictureCount) {
        self.pictureCount = [[UILabel alloc]init];
        self.pictureCount.font=[UIFont systemFontOfSize:15];
        self.pictureCount.backgroundColor = [UIColor clearColor];
        self.pictureCount.textAlignment = NSTextAlignmentLeft;
       // self.pictureCount.layer.cornerRadius=14;
       // self.pictureCount.clipsToBounds=YES;
        self.pictureCount.textColor=[UIColor whiteColor];
        [self addSubview:self.pictureCount];
    }
    return self.pictureCount;
}

- (void)layoutSubviews {
    
    if (self.typeInteger == 0) {
        photoView.frame = CGRectInset(CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-90), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        topshadow_img.frame = CGRectInset(CGRectMake(0, 0, self.bounds.size.width, 50), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        bottom_bg.frame = CGRectInset(CGRectMake(0, self.bounds.size.height-90, self.bounds.size.width, 90), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        designer_photoView.frame = CGRectInset(CGRectMake(20,bottom_bg.frame.origin.y+10,45,45), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        Label_designer.frame = CGRectMake(0,60,85,20);
        
        houseDesc.frame = CGRectMake(90,20,self.bounds.size.width-110,20);
        houseTAndAAndPOrS.frame = CGRectMake(130,50,self.bounds.size.width-150,20);
        
        self.browseNumIV.frame = CGRectInset(CGRectMake(105,16,13,13), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        self.browseNumLabel.frame =CGRectMake(123,15,65,15);
        self.browseNumLabel.textAlignment = NSTextAlignmentLeft;
        
        self.collectIV.frame =CGRectInset(CGRectMake(19,15.5,13,13), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        self.collectNumLabel.frame =  CGRectMake(37, 15, 65, 15);
        self.collectNumLabel.textAlignment = NSTextAlignmentLeft;
        
        UIView *view_line=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.8, self.frame.size.width, 1.0)];
        view_line.backgroundColor=[UIColor colorWithHexString:@"#DAD8DE" alpha:0.6];
        [self addSubview:view_line];
        
    } else if (self.typeInteger == 1) {
        photoView.frame = CGRectInset(CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-120), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        topshadow_img.frame = CGRectInset(CGRectMake(0, 0, self.bounds.size.width, 50), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        bottom_bg.frame = CGRectInset(CGRectMake(0, self.bounds.size.height-120, self.bounds.size.width, 120), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        designer_photoView.frame = CGRectInset(CGRectMake((self.bounds.size.width-55)/2,bottom_bg.frame.origin.y-30,55,55), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        Label_designer.frame = CGRectMake(20,35,self.bounds.size.width-40,15);
        
        houseTAndAAndPOrS.frame = CGRectMake(10,60,self.bounds.size.width-20,20);
        
        self.browseNumIV.frame =CGRectInset(CGRectMake(105,16,13,13), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        //CGRectInset(CGRectMake((self.bounds.size.width-130)/2+83,55,13,13), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);   bt jiangt
        self.browseNumLabel.frame =CGRectMake(123,15,65,15);
        //CGRectMake((self.bounds.size.width-130)/2+101,54,40,15);   bt jiangt
        self.browseNumLabel.textAlignment = NSTextAlignmentLeft;
        
        self.collectIV.frame =CGRectInset(CGRectMake(19,15.5,13,13), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
        //CGRectInset(CGRectMake((self.bounds.size.width-130)/2+20,54,13,13), kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);    bt jiangt
        self.collectNumLabel.frame =  CGRectMake(37, 15, 65, 15);
        // CGRectMake((self.bounds.size.width-130)/2+38, 53, 40, 15);   bt jiangt
        self.collectNumLabel.textAlignment = NSTextAlignmentLeft;
        
        self.pictureCountIV.frame=CGRectMake(self.bounds.size.width-55, 18, 10, 10);
        self.pictureCount.frame=CGRectMake(self.bounds.size.width-40, 15, 40, 15);
        
        UIView *view_line=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.8, self.frame.size.width, 1.0)];
        view_line.backgroundColor=[UIColor colorWithHexString:@"#D4D3D4" alpha:0.6];
        [self addSubview:view_line];
    }
    
}

#pragma mark 设置Cell的边框宽度
- (void)setFrame:(CGRect)frame {
    if(self.typeInteger==1){
        frame.origin.x -= 0;
        frame.size.width += 2 * 0;
    }
    else{
        frame.origin.x -= 8;
        frame.size.width += 2 * 8;
    }
    [super setFrame:frame];
}

@end
