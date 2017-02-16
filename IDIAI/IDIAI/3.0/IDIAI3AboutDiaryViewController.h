//
//  IDIAI3AboutDiaryViewController.h
//  IDIAI
//
//  Created by Ricky on 15/12/2.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@interface IDIAI3AboutDiaryViewController : GeneralViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>{
    BOOL isFirstInt;
}
@property (strong, nonatomic) PullingRefreshTableView *mtableview;
@property (assign, nonatomic) BOOL refreshing;
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger toUserId;
@property (nonatomic,assign) NSInteger toRoleId;
@property (nonatomic,assign) BOOL ismyDiary;
@end
