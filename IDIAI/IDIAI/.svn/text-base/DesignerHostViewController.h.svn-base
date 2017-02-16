//
//  DesignerHostViewController.h
//  IDIAI
//
//  Created by iMac on 15-3-18.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ViewPagerControllerSecond.h"
#import "DistrictView.h"
@interface DesignerHostViewController : ViewPagerControllerSecond{
    UIControl *_control;
    UIScrollView *_scr;
    UIView *_dv;
    NSArray *_dataArr;//弹出层数据源
    
    UITableView *mtableview_sub; //显示历史记录
    UIView *view_search_bg;
    UITextField *searchBar;
}
@property (nonatomic,assign) NSInteger picture_style;//效果图风格
@property (nonatomic,assign) NSInteger picture_doorModel;//效果图户型
@property (nonatomic,assign) NSInteger picture_price;//效果图报价
@property (nonatomic,assign) NSInteger picture_city;//效果图城市
@property (nonatomic,assign) NSInteger picture_kongjian;//效果图空间
@property (nonatomic,assign) NSInteger picture_experience;//效果图经验
@property (nonatomic,assign) NSInteger picture_level;//效果图等级
@property (nonatomic,assign) NSInteger picture_aut;//效果图认证
@property (nonatomic,strong) NSString *priceMin;//报价最低值
@property (nonatomic,strong) NSString *priceMax;//报价最大值

@property (nonatomic,assign) BOOL isShowSearchBar;
@property (nonatomic,strong) NSMutableArray *dataArray_history;  //历史记录

@end
