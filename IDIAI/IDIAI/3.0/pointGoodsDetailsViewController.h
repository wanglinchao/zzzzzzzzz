//
//  GoodsDetailsViewController.h
//  IDIAI
//
//  Created by PM on 16/6/15.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "GoodDetailModel.h"
@interface pointGoodsDetailsViewController : GeneralWithBackBtnViewController
@property(nonatomic,assign)NSInteger pgId;//积分商品ID
@property(nonatomic,strong)GoodDetailModel * goodsDetailModel;

@end
