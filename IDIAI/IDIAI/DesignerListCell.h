//
//  DesignerListCell.h
//  IDIAI
//
//  Created by iMac on 14-12-1.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignerListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *designer_photo;
@property (weak, nonatomic) IBOutlet UILabel *designer_name;
@property (weak, nonatomic) IBOutlet UILabel *designer_express;
@property (weak, nonatomic) IBOutlet UIView *view_star;
@property (weak, nonatomic) IBOutlet UIButton *designer_phone;
@property (weak, nonatomic) IBOutlet UILabel *lab_collect;
@property (weak, nonatomic) IBOutlet UILabel *lab_brower;
@property (weak, nonatomic) IBOutlet UIImageView *image_collect;
@property (weak, nonatomic) IBOutlet UIImageView *image_brower;
@property (weak, nonatomic) IBOutlet UILabel *score_start;

@property (copy, nonatomic) NSString *fromVCStr;

@end
