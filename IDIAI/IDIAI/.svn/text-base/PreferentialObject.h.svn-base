//
//  PreferentialObject.h
//  IDIAI
//
//  Created by Ricky on 16/3/14.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
@interface PreferentialObject : KVCObject
@property(nonatomic,strong)NSString *couponsName;//劵名称
@property(nonatomic,strong)NSString *endDate;//有限期
@property(nonatomic,strong)NSString *couponValue;//0：优惠券；显示的是金额值 1：折扣券；显示的是折扣值 2：礼品券；显示的是有好礼
@property(nonatomic,strong)NSString *couponDesc;//优惠卷描述
@property(nonatomic,assign)int couponId;//主键Id
@property(nonatomic,assign)int couponState;//状态；1 可用 2 已使用 3-已过期
@property(nonatomic,assign)int couponType;//券类型：0：优惠券；1：折扣券；2：礼品券
@property(nonatomic,assign)int sucId;//用户优惠券ID
@property(nonatomic,strong)NSString *beginDate;//有效期起始时间
@property(nonatomic,assign)int ownType;//1 平台卷  2 第三方卷
@property(nonatomic,assign)int exitState;//1 工程和监理优惠 2 工程、设计师、监理优惠 3 平台监理费优惠
@end
