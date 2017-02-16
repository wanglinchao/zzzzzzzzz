//
//  DiaryObject.m
//  IDIAI
//
//  Created by Ricky on 15/11/18.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DiaryObject.h"

@implementation DiaryObject
- (id)init
{
    self = [super init];
    if (self) {
        self.picPaths = [[KVCArray alloc] initWithClass:[NSString class]];
    }
    return self;
}
@end
