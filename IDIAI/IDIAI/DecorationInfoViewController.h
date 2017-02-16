//
//  DecorationInfoViewController.h
//  IDIAI
//
//  Created by Ricky on 14-11-27.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "PullingRefreshTableView.h"

@interface DecorationInfoViewController : GeneralWithBackBtnViewController <UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate> {
    PullingRefreshTableView *mtableview;
}

@property (assign, nonatomic) BOOL refreshing;
@property (nonatomic,strong)  NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数

@property (nonatomic,strong)  NSString *fromType;

@end
