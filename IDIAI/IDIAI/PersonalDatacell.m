//
//  PersonalDatacell.m
//  IDIAI
//
//  Created by iMac on 14-7-14.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PersonalDatacell.h"
#import "HexColor.h"

@implementation PersonalDatacell

- (void)awakeFromNib
{
    // Initialization code
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59, 320, 2)];
    line.image=[UIImage imageNamed:@"细分割线.png"];
    [self addSubview:line];
    
    self.Lab_first.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    self.Lab_second.textColor=[UIColor colorWithHexString:@"#6d2900" alpha:0.58];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
