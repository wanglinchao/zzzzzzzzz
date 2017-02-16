//
//  MyToDoObject.m
//  IDIAI
//
//  Created by Ricky on 16/5/23.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyToDoObject.h"

@implementation MyToDoObject
- (id)init
{
    self = [super init];
    if (self) {
        self.phaseTodoInfos = [[KVCArray alloc] initWithClass:[MyToDoInfoObject class]];
    }
    return self;
}
@end
