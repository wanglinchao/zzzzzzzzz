//
//  MessageListCell.m
//  IDIAI
//
//  Created by iMac on 14-7-7.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MessageListCell.h"
#import "HexColor.h"

@implementation MessageListCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.title_lab.textColor=[UIColor blackColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 设置Cell的边框宽度
- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15;
    frame.size.width -= 2 * 15;
    [super setFrame:frame];
}

@end
