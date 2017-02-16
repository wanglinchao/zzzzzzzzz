//
//  CollectDesignerCell.m
//  IDIAI
//
//  Created by iMac on 14-8-12.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CollectDesignerCell.h"
#import "HexColor.h"

@implementation CollectDesignerCell

- (void)awakeFromNib
{
    // Initialization code
//    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 98, 320, 5)];
//    line.image=[UIImage imageNamed:@"粗分割线.png"];
//    [self addSubview:line];
//    
//    self.lab_designer.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    
    self.designer_photo.layer.masksToBounds = YES;
    self.designer_photo.layer.cornerRadius = 20.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 设置Cell的边框宽度
- (void)setFrame:(CGRect)frame {
    frame.origin.x -= 0;
    frame.size.width+=60;
    [super setFrame:frame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    frame.origin.x -= self.offsetX;
    [super setFrame:frame];
    [UIView commitAnimations];
}

@end
