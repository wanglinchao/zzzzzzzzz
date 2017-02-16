//
//  SearchListCell.m
//  IDIAI
//
//  Created by iMac on 15-3-18.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SearchListCell.h"

@implementation SearchListCell

- (void)awakeFromNib {
    // Initialization code
    
    self.ser_his_lab.textColor=[UIColor colorWithHexString:@"#898989" alpha:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 设置Cell的边框宽度
- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.size.width -= 2 * 10;
    [super setFrame:frame];
}

@end
