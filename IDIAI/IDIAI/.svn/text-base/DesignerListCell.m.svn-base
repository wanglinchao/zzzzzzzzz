//
//  DesignerListCell.m
//  IDIAI
//
//  Created by iMac on 14-12-1.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DesignerListCell.h"
#import "HexColor.h"

@implementation DesignerListCell

- (void)awakeFromNib {
    // Initialization code
//    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 89, kMainScreenWidth, 0.5)];
//    line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
//    [self addSubview:line];
    
    self.designer_photo.layer.masksToBounds = YES;
    self.designer_photo.layer.cornerRadius = 20.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 设置Cell的边框宽度
- (void)setFrame:(CGRect)frame {
    if (![self.fromVCStr isEqualToString:@"collectionVC"]){
    frame.origin.x += 10;
    frame.size.width -= 2 * 10;
    }
    [super setFrame:frame];
}

@end
