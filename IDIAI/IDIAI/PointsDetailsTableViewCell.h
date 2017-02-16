//
//  PointsDetailsTableViewCell.h
//  IDIAI
//
//  Created by PM on 16/6/16.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointDetailsModel.h"
@interface PointsDetailsTableViewCell : UITableViewCell
@property(nonatomic,strong)PointDetailsModel * pointDetailsModel;
@property(nonatomic,strong)  UIButton * checkCDKEYBtn;;
@end
