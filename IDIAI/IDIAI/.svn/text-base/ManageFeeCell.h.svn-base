//
//  ManageFeeCell.h
//  IDIAI
//
//  Created by Ricky on 15/12/25.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewContractObject.h"
#import "PreferentialObject.h"
@interface ManageFeeCell : UITableViewCell
@property(nonatomic,strong)NewOrderObject *orderObject;
@property(nonatomic,assign)double productProFee;//成品保护费
@property(nonatomic,strong)NSString *ppDiscount;//成品保护优惠折扣
@property(nonatomic,assign)double platformSuperFee;//平台监理费
@property(nonatomic,strong)NSString *psDiscount;//平台监理折扣优惠
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)PreferentialObject *prefertial;
@property(nonatomic,assign)double contractTotalFee;
-(CGFloat)getCellHeight;
@end
