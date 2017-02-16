//
//  ForemanSiteObject.m
//  UTopGD
//
//  Created by Ricky on 15/9/17.
//  Copyright (c) 2015年 yangfan. All rights reserved.
//

#import "ForemanSiteObject.h"

@implementation ForemanSiteObject
- (id)init
{
    self = [super init];
    if (self) {
        self.foremanSitesPics = [[KVCArray alloc] initWithClass:[ForemanSitesPic class]];
    }
    return self;
}
@end
