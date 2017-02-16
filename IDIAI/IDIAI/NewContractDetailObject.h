//
//  NewContractDetailObject.h
//  IDIAI
//
//  Created by Ricky on 15/12/24.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
#import "ContractAttchmentObject.h"
@interface NewContractDetailObject : KVCObject
@property(nonatomic,assign)int contractType;//合同类型
@property(nonatomic,strong)NSString *userName;//甲方名称
@property(nonatomic,strong)NSString *userPhoneNo;//甲方电话
@property(nonatomic,assign)int userId;//甲方id
@property(nonatomic,strong)NSString *servantName;//乙方名称
@property(nonatomic,strong)NSString *servantPhoneNo;//乙方电话
@property(nonatomic,assign)int servantId;//乙方id
@property(nonatomic,assign)double contractTotalFee;//合同订单总额（单位元）
@property(nonatomic,assign)double orderFee;//订单总额(除管理费的)（元）
@property(nonatomic,assign)int duration;//工期(单位：天)
@property(nonatomic,strong)NSString *userAddr;//地址
@property(nonatomic,strong)NSString *userCommunityName;//小区名称
@property(nonatomic,strong)NSString *houseArea;//住房面积
@property(nonatomic,assign)double productProFee;//成品保护费
@property(nonatomic,strong)NSString *ppDiscount;//成品保护优惠折扣
@property(nonatomic,assign)double platformSuperFee;//平台监理费
@property(nonatomic,strong)NSString *psDiscount;//平台监理折扣优惠
@property(nonatomic,strong)NSString *companyName;//公司名称,第三方的公司
@property(nonatomic,strong)NSString *companyTel;//公司电话
@property(nonatomic,strong)NSString *state;//合同状态
@property(nonatomic,strong)NSString *effectiveTime;//合同签订时间
@property(nonatomic,strong)NSString *stateName;//合同状态名称
@property(nonatomic,strong)NSString *remark;//合同描述
@property(nonatomic,strong)KVCArray *attactmentsPaths;//合同附件
@property(nonatomic,assign)double originalTotalFee;//合同总额（元）
@property(nonatomic,strong)NSString *sysSupervisorName;//平台监理名称
@property(nonatomic,strong)NSString *attChangeStateName;//变更合同附件状态名称
@property(nonatomic,strong)NSString *changeReason;//变更理由
@property(nonatomic,strong)NSString *refuseReason;//拒绝理由
@property(nonatomic,assign)int attChangeState;//变更合同附件状态
@property(nonatomic,assign)int superType;//6:第三方监理 9：平台监理
@property(nonatomic,assign)int contractId;//合同id;
//sysSupervisorName	Sring
//superType	Int
//attactmentsPaths	List<ContractAttchment>
//attChangeState	Int
//attChangeStateName	String
//changeReason	String
//refuseReson	Strign
@end
