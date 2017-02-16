//
//  DesignerViewController.h
//  IDIAI
//
//  Created by iMac on 14-12-1.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface DesignerViewController : GeneralWithBackBtnViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    UITableView *mtableview_sub;
    
    UIControl *_control;
    UIView *_dv;
    UIScrollView *_scr;
    NSArray *_dataArr;//弹出层数据源
    
    BOOL isFirstInt;
}

@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) BOOL refreshing;
@property (strong, nonatomic) NSString *searchContent; //搜索内容
@property (assign, nonatomic) NSInteger selected_mark; //选择的标签
@property (strong, nonatomic) PullingRefreshTableView *mtableview;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (assign, nonatomic) NSInteger selectBtnTag;//选择的预约按钮
@property (nonatomic,strong) NSMutableArray *arr_cityCode;//城市的code
@property (nonatomic,assign) NSInteger picture_style;
@property (nonatomic,assign) NSInteger picture_kongjian;//效果图空间
@property (nonatomic,assign) NSInteger picture_experience;//效果图经验
@property (nonatomic,assign) NSInteger picture_city;//效果图城市
@property (nonatomic,assign) NSInteger picture_level;//效果图等级
@property (nonatomic,assign) NSInteger picture_aut;//效果图认证
@property (nonatomic,strong) NSString *priceMin_;//报价最低值
@property (nonatomic,strong) NSString *priceMax_;//报价最大值
@property (nonatomic,assign) BOOL isShowSearchBar;

-(void)dismiss;
- (void)show;
@end
