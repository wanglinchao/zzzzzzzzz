//
//  DiaryCommentObject.h
//  IDIAI
//
//  Created by Ricky on 15/11/23.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
#import "DiaryReplyCommentObject.h"
@interface DiaryCommentObject :KVCObject
@property(nonatomic,assign)int userId;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *logo;
@property(nonatomic,assign)int floor;
@property(nonatomic,strong)NSString *commentContext;
@property(nonatomic,assign)int commentId;
@property(nonatomic,strong)NSString *commentDate;
@property(nonatomic,strong)KVCArray *replyComments;
@property(nonatomic,assign)int roleId;

@end
