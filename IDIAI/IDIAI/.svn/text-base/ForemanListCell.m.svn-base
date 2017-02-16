//
//  ForemanListCell.m
//  IDIAI
//
//  Created by iMac on 14-10-30.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ForemanListCell.h"
#import "HexColor.h"
#import <QuartzCore/QuartzCore.h>
#import "util.h"

@implementation ForemanListCell

- (void)awakeFromNib
{
    // Initialization code
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 99, kMainScreenWidth, 0.5)];
    line.image=[util imageWithColor:[UIColor colorWithHexString:@"#CCCCCC" alpha:0.5]];
    [self addSubview:line];
    
    self.photo_inage.layer.masksToBounds=YES;
    self.photo_inage.layer.cornerRadius=29.5;
    self.photo_inage.clipsToBounds = YES;
    self.photo_inage.contentMode = UIViewContentModeScaleToFill;
    self.name_lab.textColor=[UIColor colorWithHexString:@"#252525" alpha:1.0];
    self.express_lab.textColor=[UIColor colorWithHexString:@"#252525" alpha:0.8];
    self.desc_exp_lab.textColor=[UIColor colorWithHexString:@"#252525" alpha:0.8];
    [self.btn_call setImage:[UIImage imageNamed:@"bt_calldianji"] forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
