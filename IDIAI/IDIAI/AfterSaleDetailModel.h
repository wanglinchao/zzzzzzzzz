//
//  AfterSaleDetailModel.h
//  IDIAI
//
//  Created by Ricky on 15-2-10.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AfterSaleDetailModel : NSObject

//@property (copy, nonatomic) NSString *afterCreateTime;
//@property (assign, nonatomic) NSInteger afterServiceId;
//@property (strong, nonatomic) NSDictionary *afterServiceOrderInfo;
//@property (copy, nonatomic) NSString *afterServiceReason;
//@property (assign, nonatomic) NSInteger afterServiceState;
//@property (copy, nonatomic) NSString *afterServiceStateName;
//@property (strong, nonatomic) NSArray *proofCharts;
//@property (copy, nonatomic) NSString *servantName;
//@property (assign, nonatomic) NSInteger servantRoleId;
@property (strong, nonatomic) NSString *csReason;//申请售后原因
@property (assign, nonatomic) int csState;//售后单状态值
@property (strong, nonatomic) NSString *csStateName;//售后单状态名称
@property (strong, nonatomic) NSString *csCreateTime;//售后申请时间
@property (strong, nonatomic) NSString *phaseOrderCode;//订单编号（原阶段编号）
@property (strong, nonatomic) NSString *phaseOrderDate;//订单日期
@property (assign, nonatomic) double phaseOrderFee;//订单金额(元)
@property (strong, nonatomic) NSString *phaseOrderName;//订单名称
@property (strong, nonatomic) NSString *orderCode;//合同编号（原订单号）
@property (strong, nonatomic) NSString *proofCharts;//认证图片信息,多张用逗号隔开
@property (strong, nonatomic) NSString *userCommunityName;//业主小区名称
@property (strong, nonatomic) NSString *userMobile;//服务商电话
@property (strong, nonatomic) NSString *userName;//服务商名称
@property (assign, nonatomic) int userType;//服务商角色
@end
