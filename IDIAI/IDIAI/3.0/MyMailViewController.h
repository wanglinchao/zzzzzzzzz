//
//  MyMailViewController.h
//  IDIAI
//
//  Created by Ricky on 16/5/11.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@interface MyMailViewController : GeneralViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>{
    BOOL isFirstInt;
}
@property (strong, nonatomic) PullingRefreshTableView *mtableview;
@property (assign, nonatomic) BOOL refreshing;
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) NSInteger actionType;

@end
