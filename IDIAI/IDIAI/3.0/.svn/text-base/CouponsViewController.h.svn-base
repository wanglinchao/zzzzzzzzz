//
//  CouponsViewController.h
//  IDIAI
//
//  Created by Ricky on 16/3/16.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewContractDetailObject.h"
#import "PreferentialObject.h"
@interface CouponsViewController : GeneralWithBackBtnViewController
@property(nonatomic,strong)NewContractDetailObject *contract;
@property(nonatomic,strong)NSString *orderCode;
@property(nonatomic,strong)NSString *type;
typedef void (^SelectBlock)(PreferentialObject *preferential);
@property (nonatomic, copy) SelectBlock selectDone;
@property (nonatomic,assign)int orderType;
@property (nonatomic,assign)NSString *objIds;
@property (nonatomic,strong)NSString *totalFee;
@property(nonatomic,assign)int selectcouponId;
@end
