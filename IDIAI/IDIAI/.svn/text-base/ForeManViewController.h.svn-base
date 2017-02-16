//
//  ForeManViewController.h
//  IDIAI
//
//  Created by iMac on 14-10-23.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface ForeManViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    PullingRefreshTableView *mtableview;
}

@property (assign, nonatomic) BOOL refreshing;
@property (nonatomic,strong)  NSMutableArray *dataArray;
@property (nonatomic,strong) NSString *foreman_type;
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数

@end
