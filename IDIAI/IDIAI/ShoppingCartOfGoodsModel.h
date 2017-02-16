//
//  ShoppingCartOfGoodsModel.h
//  IDIAI
//
//  Created by Ricky on 15/5/15.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartOfGoodsModel : NSObject

@property (copy, nonatomic) NSString *goodsColor;

@property (assign, nonatomic) NSInteger goodsCount;

@property (assign, nonatomic) NSInteger goodsId;

@property (copy, nonatomic) NSString *goodsModel;

@property (copy, nonatomic) NSString *goodsName;

@property (assign, nonatomic) CGFloat goodsPrice;

@property (copy, nonatomic) NSString *goodsUrl;

@property (assign, nonatomic) NSInteger shipFee;

@property (assign, nonatomic) NSInteger shopId;

@property (assign, nonatomic) NSInteger orderDetailId;

@property (assign, nonatomic) NSInteger isExistApplyingAfterSale;

@property (assign, nonatomic) NSInteger isExistApplyingRefund;

@property (assign, nonatomic) NSInteger cartId;

@property (assign, nonatomic) BOOL isSelect;


@end
