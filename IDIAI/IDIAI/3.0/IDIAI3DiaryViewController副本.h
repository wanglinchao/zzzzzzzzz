//
//  IDIAI3DiaryViewController.h
//  IDIAI
//
//  Created by Ricky on 15/11/16.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@interface IDIAI3DiaryViewController : GeneralViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>{
    BOOL isFirstInt;
}
@property (strong, nonatomic) PullingRefreshTableView *mtableview;
@property (assign, nonatomic) BOOL refreshing;
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger labelId;
@property (nonatomic,assign) BOOL ismyDiary;
@end
