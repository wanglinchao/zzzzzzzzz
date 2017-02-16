//
//  NewContractObject.h
//  IDIAI
//
//  Created by Ricky on 15/12/21.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
#import "NewOrderObject.h"
@interface NewContractObject : KVCObject
@property(nonatomic,strong)NSString *orderCode;
@property(nonatomic,strong)NSString *orderFee;
@property(nonatomic,assign)int orderType;
@property(nonatomic,strong)NSString *orderLastDate;
@property(nonatomic,strong)KVCArray *phaseOrders;
@property(nonatomic,assign)int orderState;
@property(nonatomic,assign)int servantId;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *userLogo;
@property(nonatomic,strong)NSString *orderStateName;
@property(nonatomic,strong)NSString *userMobile;
@property(nonatomic,assign)int isChangeAttchment;
@property(nonatomic,assign)int superviorId;
@end
