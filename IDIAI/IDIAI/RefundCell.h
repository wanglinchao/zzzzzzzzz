//
//  RefundCell.h
//  IDIAI
//
//  Created by Ricky on 16/1/4.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundListModel.h"
#import "AfterSaleListModel.h"
@protocol RefundCellDelegate <NSObject>
-(void)touchCancle:(RefundListModel *)refund;
-(void)touchAfterCancle:(AfterSaleListModel *)after;
@end
@interface RefundCell : UITableViewCell
@property(nonatomic,strong)RefundListModel *refund;
@property(nonatomic,strong)AfterSaleListModel *after;
@property (nonatomic, weak) id<RefundCellDelegate>delegate;
@end
