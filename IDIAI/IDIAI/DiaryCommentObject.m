//
//  DiaryCommentObject.m
//  IDIAI
//
//  Created by Ricky on 15/11/23.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DiaryCommentObject.h"

@implementation DiaryCommentObject
- (id)init
{
    self = [super init];
    if (self) {
        self.replyComments = [[KVCArray alloc] initWithClass:[DiaryReplyCommentObject class]];
    }
    return self;
}
@end
