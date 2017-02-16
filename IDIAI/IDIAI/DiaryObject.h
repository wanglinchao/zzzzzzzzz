//
//  DiaryObject.h
//  IDIAI
//
//  Created by Ricky on 15/11/18.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
@interface DiaryObject : KVCObject
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *logo;
@property(nonatomic,strong)NSString *roleId;
@property(nonatomic,strong)NSString *diaryTitle;
@property(nonatomic,strong)NSString *diaryContext;
@property(nonatomic,strong)KVCArray *picPaths;
@property(nonatomic,strong)NSString *pointNumber;
@property(nonatomic,strong)NSString *commentNumber;
@property(nonatomic,strong)NSString *releaseDate;
@property(nonatomic,strong)NSString *diaryId;
@property(nonatomic,assign)NSInteger isPoint;
@property(nonatomic,assign)NSInteger diaryType;
@end
