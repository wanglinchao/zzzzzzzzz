//
//  CouponMainViewController.h
//  IDIAI
//
//  Created by Ricky on 16/3/16.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ViewPageEightController.h"
#import "ViewPagerController.h"
#import "NewContractDetailObject.h"
#import "PreferentialObject.h"
@interface CouponMainViewController : ViewPagerController
@property(nonatomic,strong)NewContractDetailObject *contract;
@property(nonatomic,strong)NSString *orderCode;
typedef void (^SelectBlock)(PreferentialObject *preferential);
@property (nonatomic, copy) SelectBlock selectDone;
@property(nonatomic,assign)int couponNum; //可用的优惠卷数量
@property(nonatomic,assign)int noCouponNum; //不可用的优惠卷数量
@property(nonatomic,assign)int orderType;
@property(nonatomic,strong)NSString *objIds;
@property(nonatomic,strong)NSString *totalFee;
@property(nonatomic,assign)int selectcouponId;
@end
