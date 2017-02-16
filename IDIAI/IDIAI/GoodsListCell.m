//
//  GoodsListCell.m
//  IDIAI
//
//  Created by iMac on 14-11-28.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GoodsListCell.h"
#import "HexColor.h"

@implementation GoodsListCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 249.5, kMainScreenWidth, 0.5)];
    line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
    [self addSubview:line];
    
    self.lab_distance.textColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//#pragma mark 设置Cell的边框宽度
//- (void)setFrame:(CGRect)frame {
//    frame.origin.x += 15;
//    frame.size.width -= 2 * 15;
//    [super setFrame:frame];
//}

@end
