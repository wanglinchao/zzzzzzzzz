//
//  GongzhangtuanViewController.h
//  IDIAI
//
//  Created by Ricky on 15-1-20.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "PullingRefreshTableView.h"

@interface GongzhangtuanViewController : GeneralWithBackBtnViewController <UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    UIControl *_control;
    UIView *_dv;
    UIScrollView *_scr;
    NSArray *_dataArr;//弹出层数据源
}

@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) BOOL refreshing;
@property (strong, nonatomic) NSString *searchContent; //搜索内容
@property (assign, nonatomic) NSInteger selected_mark; //选择的标签

@property (assign, nonatomic) NSInteger selected_btn; //选择的预约按钮
@property (nonatomic,assign) NSInteger picture_experience;//效果图经验
@property (nonatomic,assign) NSInteger picture_service;//效果图特色服务
@property (nonatomic,assign) NSInteger picture_aut;//效果图认证
@property (nonatomic,strong) PullingRefreshTableView *mtableview;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isShowSearchBar;

@end
