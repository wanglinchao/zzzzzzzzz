//
//  PointsDetailsContentViewController.h
//  IDIAI
//
//  Created by PM on 16/6/16.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralViewController.h"
#import "PullingRefreshTableView.h"
#import "pointDetailsViewController.h"
@interface PointsDetailsContentViewController : GeneralViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>{
    BOOL isFirstInt;
}
@property (strong, nonatomic) PullingRefreshTableView *mtableview;
@property (assign, nonatomic) BOOL refreshing;
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (nonatomic,assign) NSInteger type;
@property (assign, nonatomic) NSInteger typeInteger;
@property (copy, nonatomic) NSString *typeStr;
@property(nonatomic,weak)pointDetailsViewController * pointVC;
@end
