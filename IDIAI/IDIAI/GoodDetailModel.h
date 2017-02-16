//
//  GoodDetailModel.h
//  IDIAI
//
//  Created by PM on 16/6/15.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "BaseModel.h"

@interface GoodDetailModel : BaseModel

@property(nonatomic,assign)NSInteger cashStatus;//是否可兑换状态 1 是 0 否
@property(nonatomic,assign)NSInteger pgId;// 积分商品ID
@property(nonatomic,assign)double pgPrice;//商品价格
@property(nonatomic,copy)NSString * pgName;//商品名称
@property(nonatomic,copy)NSString * pgImgPath;//商品图片地址
@property(nonatomic,assign)NSInteger pgNumber;//兑换商品所需积分
@property(nonatomic,copy)NSString * pgDesc;//商品描述
@property(nonatomic,copy)NSString * pgStatus;//1 上架 0 下架
@property(nonatomic,copy)NSString * cityCodes;//所属城市编码，多个用“，”隔开
@end
