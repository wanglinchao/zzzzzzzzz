//
//  NewContractDetailObject.m
//  IDIAI
//
//  Created by Ricky on 15/12/24.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "NewContractDetailObject.h"

@implementation NewContractDetailObject
- (id)init
{
    self = [super init];
    if (self) {
        self.attactmentsPaths = [[KVCArray alloc] initWithClass:[ContractAttchmentObject class]];
    }
    return self;
}
@end
