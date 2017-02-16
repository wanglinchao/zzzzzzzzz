//
//  MyToDoViewController.h
//  IDIAI
//
//  Created by Ricky on 16/5/10.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralWithBackBtnViewController.h"
#import "PullingRefreshTableView.h"
@interface MyToDoViewController : GeneralWithBackBtnViewController<UITableViewDelegate,UITableViewDataSource,   PullingRefreshTableViewDelegate>{
    BOOL isFirstInt;
}
@property (strong, nonatomic) PullingRefreshTableView *mtableview;
@property (assign, nonatomic) BOOL refreshing;
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@end
