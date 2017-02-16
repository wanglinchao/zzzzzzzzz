//
//  NewContractObject.m
//  IDIAI
//
//  Created by Ricky on 15/12/21.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "NewContractObject.h"

@implementation NewContractObject
- (id)init
{
    self = [super init];
    if (self) {
        self.phaseOrders = [[KVCArray alloc] initWithClass:[NewOrderObject class]];
    }
    return self;
}
@end
