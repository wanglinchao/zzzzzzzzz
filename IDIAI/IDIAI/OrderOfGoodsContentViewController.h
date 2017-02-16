//
//  OrderOfGoodsViewController.h
//  IDIAI
//
//  Created by Ricky on 15/5/7.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"

@interface OrderOfGoodsContentViewController : GeneralWithBackBtnViewController

@property (assign, nonatomic) NSInteger index;

@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) BOOL refreshing;
@property (assign, nonatomic) NSInteger selected_mark; //选择的标签
@property (strong, nonatomic) NSString *mark_string; //选择的标签对应的内容

@property (copy, nonatomic) NSString *fromVcNameStr;

@end
