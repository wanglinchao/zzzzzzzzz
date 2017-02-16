//
//  DiaryReplyObject.h
//  IDIAI
//
//  Created by Ricky on 15/11/25.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
@interface DiaryReplyObject : KVCObject
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *logo;
@property(nonatomic,strong)NSString *commentContext;
@property(nonatomic,assign)NSInteger commentId;
@property(nonatomic,strong)NSString *commentDate;
@property(nonatomic,strong)NSString *firstPicPath;
@property(nonatomic,assign)NSInteger commentType;
@property(nonatomic,assign)NSInteger diaryId;
@property(nonatomic,assign)NSInteger roleId;
//userId	Int;
//nickName	String
//logo	String
//commentContext	String
//commentId	Int
//CommentDate	date
//firstPicPath	String
//commentType	Int
@end
