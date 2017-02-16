//
//  RefundListModel.h
//  IDIAI
//
//  Created by Ricky on 15-2-4.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
@interface RefundListModel : KVCObject

//@property (copy, nonatomic) NSString *createAt;
//@property (copy, nonatomic) NSString *orderCode;
//@property (assign, nonatomic) NSInteger orderState;
//@property (copy, nonatomic) NSString *orderStateView;
//@property (copy, nonatomic) NSString *phaseName;
//@property (assign, nonatomic) float refundFee;
//@property (assign, nonatomic) NSInteger refundFeeView;
//@property (copy, nonatomic) NSString *refundId;
//@property (assign, nonatomic) NSInteger refundState;
//@property (copy, nonatomic) NSString *refundStateView;
//@property (assign, nonatomic) NSInteger servantId;
//@property (copy, nonatomic) NSString *servantName;
//@property (assign, nonatomic) NSInteger servantRoleId;
//@property (copy, nonatomic) NSString *userCommunityName;
//@property (assign, nonatomic) NSInteger userId;
//@property (copy, nonatomic) NSString *userImageURL;
//@property (copy, nonatomic) NSString *userMobile;
//@property (copy, nonatomic) NSString *userName;
@property(nonatomic,strong)NSString *phaseOrderCode;//订单编号(原阶段编号)
@property(nonatomic,strong)NSString *userName;//业主姓名
@property(nonatomic,assign)double refundFee;//退款金额(元)
@property(nonatomic,strong)NSString *phaseOrderName;//订单名称(原施工阶段)
@property(nonatomic,strong)NSString *orderStateView;//原订单状态
@property(nonatomic,assign)int refundId;//拒绝单id
@property(nonatomic,strong)NSString *userMobile;//业主电话
@property(nonatomic,assign)int refundState;//退款单状态id
@property(nonatomic,strong)NSString *userLogo;//业主头像,字节码
@property(nonatomic,strong)NSString *refundStateName;//退款单状态名称
@property(nonatomic,strong)NSString *updateDate;//最后更新时间



@end
