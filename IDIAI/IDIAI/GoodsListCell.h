//
//  GoodsListCell.h
//  IDIAI
//
//  Created by iMac on 14-11-28.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *lab_distance;
@property (weak, nonatomic) IBOutlet UIImageView *image_big;
@property (weak, nonatomic) IBOutlet UILabel *lab_collect;
@property (weak, nonatomic) IBOutlet UILabel *lab_brower;
@property (weak, nonatomic) IBOutlet UIImageView *image_collect;
@property (weak, nonatomic) IBOutlet UIImageView *image_brower;

@end
