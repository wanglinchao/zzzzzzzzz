//
//  NewOrderDetailObject.h
//  IDIAI
//
//  Created by Ricky on 15/12/28.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
@interface NewOrderDetailObject : KVCObject
@property(nonatomic,strong)NSString *phaseOrderCode;//订单阶段编号,phaseType=1时，合同编号
@property(nonatomic,strong)NSString *phaseOrderName;//订单名称(/服务名称)
@property(nonatomic,assign)double phaseOrderFee;//阶段工程费用(元)
@property(nonatomic,assign)int phaseOrderState;//阶段状态
@property(nonatomic,assign)int phaseId;//订单阶段的Id(作为显示合,服，水，泥，油等等.....)
@property(nonatomic,assign)int phaseType;//1 是合同2 合同下面的项目
@property(nonatomic,strong)NSString *frOrderCode;//找补订单号
@property(nonatomic,assign)double makeUpFee;//找补金额(元)
@property(nonatomic,assign)double clearFee;//结算金额(元)
@property(nonatomic,strong)NSString *makeUpReason;//找补理由
@property(nonatomic,strong)NSString *phaseOrderStateName;//订单状态名称
@property(nonatomic,assign)int servantId;//服务商Id
@property(nonatomic,assign)double productProFee;//成品保护费(元)
@property(nonatomic,strong)NSString *ppDiscount;//成品保护优惠折扣
@property(nonatomic,assign)double platformSuperFee;//平台监理费(元)
@property(nonatomic,strong)NSString *psDiscount;//平台监理折扣优惠
@property(nonatomic,strong)NSString *phaseLastDate;//订单更新时间
@property(nonatomic,assign)int makeUpState;//找补订单状态
@property(nonatomic,assign)double waitePayment;//待付金额
@property(nonatomic,assign)double alreadyPayment;//已付金额
@property(nonatomic,assign)double mkAlreadyPayment;//找补单已付金额
@property(nonatomic,assign)double mkWaitePayment;//找补单未付金额
@property(nonatomic,assign)double originalOrderFee;//优惠前的金额
@end
