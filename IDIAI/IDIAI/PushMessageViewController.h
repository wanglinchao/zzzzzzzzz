//
//  PushMessageViewController.h
//  IDIAI
//
//  Created by Ricky on 15-1-20.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "PullingRefreshTableView.h"

@interface PushMessageViewController : GeneralWithBackBtnViewController <UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate> {
    
     PullingRefreshTableView *mtableview;
}

@property (nonatomic,strong)  NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) BOOL refreshing;

@end
