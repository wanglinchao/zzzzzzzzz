//
//  SearchSCXViewController.h
//  IDIAI
//
//  Created by iMac on 14-12-1.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface SearchSCXViewController : GeneralViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    PullingRefreshTableView *mtableview;
    UITableView *mtableview_sub;
}
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) BOOL refreshing;
@property (nonatomic,strong) NSMutableArray *dataArray;  //搜索列表
@property (nonatomic,strong) NSMutableArray *dataArray_history;  //历史记录
@property (nonatomic,assign) NSInteger selected_mark;

@property (assign, nonatomic) NSInteger selectBtnTag;//选择的预约按钮

@end
