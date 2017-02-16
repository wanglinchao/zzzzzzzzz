//
//  WorkerListCell.h
//  IDIAI
//
//  Created by iMac on 14-10-30.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkerListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo_image;
@property (weak, nonatomic) IBOutlet UIView *view_star;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@property (weak, nonatomic) IBOutlet UILabel *distance_lab;
@property (weak, nonatomic) IBOutlet UIButton *btn_phone;
@property (weak, nonatomic) IBOutlet UIImageView *image_collect;
@property (weak, nonatomic) IBOutlet UIImageView *image_brower;
@property (weak, nonatomic) IBOutlet UILabel *lab_collect;
@property (weak, nonatomic) IBOutlet UILabel *lab_borwer;
@property (weak, nonatomic) IBOutlet UIView *view_bg;

@property (copy, nonatomic) NSString *fromVCStr;

@property (assign, nonatomic) float offsetX;

@end
