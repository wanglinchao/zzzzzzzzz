//
//  MyOrderContentViewController.h
//  IDIAI
//
//  Created by Ricky on 15-1-21.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "PullingRefreshTableView.h"

@interface MyOrderSpecifiedViewController : GeneralWithBackBtnViewController <UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate> {
    PullingRefreshTableView *mtableview;
    UITableView *mtableview_sub;
    NSMutableArray *dataArray;
}

@property (copy, nonatomic) NSString *typeStr; //类型 待托管 施工中 待付款 待评价 

@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) BOOL refreshing;

@property (assign, nonatomic) NSInteger selected_mark; //选择的标签
@property (strong, nonatomic) NSString *mark_string; //选择的标签对应的内容

@property (strong, nonatomic) NSString *fromVcNameStr;

@end
