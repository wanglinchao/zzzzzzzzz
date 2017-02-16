//
//  EmptyClearTableViewCell.m
//  IDIAI
//
//  Created by iMac on 15/10/21.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "EmptyClearTableViewCell.h"

@implementation EmptyClearTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 设置Cell的边框宽度
- (void)setFrame:(CGRect)frame {
    frame.origin.x -= 0;
   // frame.size.width+=60;
    [super setFrame:frame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    frame.origin.x -= self.offsetX;
    [super setFrame:frame];
    [UIView commitAnimations];
}

@end
