//
//  ShoppingCartOfShopModel.m
//  IDIAI
//
//  Created by Ricky on 15/5/15.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ShoppingCartOfShopModel.h"
#import "ShoppingCartOfGoodsModel.h"

@implementation ShoppingCartOfShopModel

- (NSDictionary *)objectClassInArray {
    return @{@"cartGoodsDetails":[ShoppingCartOfGoodsModel class]};
}

@end
