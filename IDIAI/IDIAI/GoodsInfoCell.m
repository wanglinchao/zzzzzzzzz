//
//  GoodsInfoCell.m
//  IDIAI
//
//  Created by iMac on 14-8-4.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GoodsInfoCell.h"
#import "HexColor.h"

@implementation GoodsInfoCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.lab_distance.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    self.shop_name.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*
#pragma mark 设置Cell的边框宽度
- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15;
    frame.size.width -= 2 * 15;
    [super setFrame:frame];
}
*/

@end
