//
//  MoreCommentsViewController.h
//  IDIAI
//
//  Created by iMac on 15-2-10.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface MoreCommentsViewController : GeneralViewController<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    PullingRefreshTableView *mtableview;
    NSMutableArray *dataArray;
}

@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) BOOL refreshing;
@property (strong, nonatomic) NSString *role_id; //角色id
@property (strong, nonatomic) NSString *client_id; //客户id

@property (copy, nonatomic) NSString *fromVCStr;

@end
