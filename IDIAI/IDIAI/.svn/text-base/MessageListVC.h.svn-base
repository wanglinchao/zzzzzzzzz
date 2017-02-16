//
//  MessageListVC.h
//  IDIAI
//
//  Created by iMac on 14-7-4.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface MessageListVC : GeneralWithBackBtnViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    PullingRefreshTableView *mtableview;
    BOOL isFirstInt;
}
@property (nonatomic,strong)  NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) BOOL refreshing;

@end
