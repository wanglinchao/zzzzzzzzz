//
//  ContractDetailCell.h
//  IDIAI
//
//  Created by Ricky on 15/12/24.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewContractDetailObject.h"
#import "PreferentialObject.h"
@protocol ContractDetailCellDelegate <NSObject>
-(void)touchComment;
-(void)touchButton:(UIButton *)button;
@end
@interface ContractDetailCell : UITableViewCell
@property(nonatomic,strong)NewContractDetailObject *contractDetail;
@property(nonatomic,strong)NSString *orderCode;
@property (nonatomic, weak) id<ContractDetailCellDelegate>delegate;
@property(nonatomic,assign)int couponNum;
@property(nonatomic,strong)PreferentialObject *preferential;
-(CGFloat)getCellHeight;
@end
