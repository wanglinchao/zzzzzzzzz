//
//  AddressManageModel.m
//  IDIAI
//
//  Created by Ricky on 15/5/12.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "AddressManageModel.h"

@implementation AddressManageModel



- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self.ID = [value integerValue];
    }
 
}






@end
