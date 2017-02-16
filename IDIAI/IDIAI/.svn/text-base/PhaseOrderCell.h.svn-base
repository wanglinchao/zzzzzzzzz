//
//  PhaseOrderCell.h
//  IDIAI
//
//  Created by Ricky on 15/12/25.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewContractObject.h"
#import "NewOrderDetailObject.h"
#import "PreferentialObject.h"
@protocol PhaseOrderCellDelegate <NSObject>
-(void)touchContract;
@end
@interface PhaseOrderCell : UITableViewCell
@property(nonatomic,strong)NewOrderObject *orderObject;
@property(nonatomic,assign)BOOL isfirst;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,assign)double contractTotalFee;
@property(nonatomic,assign)double engineering;
@property(nonatomic,assign)int contractType;
@property(nonatomic,assign)NewOrderDetailObject *orderdetail;
@property (nonatomic, weak) id<PhaseOrderCellDelegate>delegate;
@property (nonatomic,strong)PreferentialObject *preferential;
-(CGFloat)getCellHeight;
@end
