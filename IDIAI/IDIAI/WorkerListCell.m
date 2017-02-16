//
//  WorkerListCell.m
//  IDIAI
//
//  Created by iMac on 14-10-30.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "WorkerListCell.h"
#import "HexColor.h"

@implementation WorkerListCell

- (void)awakeFromNib
{
    // Initialization code
//    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 89.5, kMainScreenWidth-20, 0.5)];
//    line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
//    [self addSubview:line];
    
    self.photo_image.layer.cornerRadius=20;
    self.photo_image.layer.masksToBounds=YES;
    self.photo_image.clipsToBounds = YES;
    self.name_lab.textColor=[UIColor blackColor];
    self.distance_lab.textColor=[UIColor grayColor];
    [self.btn_phone setImage:[UIImage imageNamed:@"bt_calldianji"] forState:UIControlStateHighlighted];
    [self.btn_phone setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
    [self.btn_phone setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 2, 50)];
    //[self.btn_phone setTitleEdgeInsets:UIEdgeInsetsMake(2, 10, 2, 5)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 设置Cell的边框宽度
- (void)setFrame:(CGRect)frame {
    if (![self.fromVCStr isEqualToString:@"collectionVC"]){
        frame.origin.x += 10;
        frame.size.width -= 2 * 10;
    }
    else{
        frame.origin.x -= 0;
        frame.size.width+=60;
        [super setFrame:frame];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
        frame.origin.x -= self.offsetX;
        [super setFrame:frame];
        [UIView commitAnimations];
    }
    
    [super setFrame:frame];
}

@end
