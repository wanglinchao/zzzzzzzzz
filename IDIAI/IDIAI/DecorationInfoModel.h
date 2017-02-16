//
//  DecorationInfoModel.h
//  IDIAI
//
//  Created by Ricky on 14-12-11.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecorationInfoModel : NSObject

@property (assign,nonatomic) NSInteger resCode;
@property (strong,nonatomic) NSMutableArray *consultantList;
@property (assign,nonatomic) NSInteger currentPage;
@property (assign,nonatomic) NSInteger pageRow;
@property (assign,nonatomic) NSInteger totalRow;
@property (assign,nonatomic) NSInteger totalPage;

@end
