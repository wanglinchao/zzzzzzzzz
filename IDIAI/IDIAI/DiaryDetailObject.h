//
//  DiaryDetailObject.h
//  IDIAI
//
//  Created by Ricky on 15/11/23.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVCObject.h"
@interface DiaryDetailObject : KVCObject
@property(nonatomic,assign)int userId;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *logo;
@property(nonatomic,assign)int roleId;
@property(nonatomic,strong)NSString *diaryTitle;
@property(nonatomic,strong)NSString *diaryContext;
@property(nonatomic,strong)KVCArray *picPaths;
@property(nonatomic,assign)int pointNumber;
@property(nonatomic,assign)int commentNumber;
@property(nonatomic,strong)NSString *releaseDate;
@property(nonatomic,assign)int diaryId;
@property(nonatomic,strong)NSString *diaryLableTitle;
@property(nonatomic,assign)int isPoint;
@property(nonatomic,assign)int diaryType;
@end
