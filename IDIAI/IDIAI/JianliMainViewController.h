//
//  JianliMainViewController.h
//  IDIAI
//
//  Created by Ricky on 15-4-8.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerControllerFourth.h"

@interface JianliMainViewController : ViewPagerControllerFourth{
    UIControl *_control;
    UIView *_dv;
    UIScrollView *_scr;
    NSArray *_dataArr;//弹出层数据源
    
    UITableView *mtableview_sub; //显示历史记录
    UIView *view_search_bg;
    UITextField *searchBar;
}
@property (nonatomic,assign) NSInteger picture_experience;//效果图经验
@property (nonatomic,assign) NSInteger picture_service;//效果图特色服务
@property (nonatomic,assign) NSInteger picture_aut;//效果图认证
@property (nonatomic,assign) NSInteger picture_level;//效果图等级
@property (nonatomic,strong) NSString *priceMin;//报价最低值
@property (nonatomic,strong) NSString *priceMax;//报价最大值
@property (nonatomic,assign) BOOL isShowSearchBar;
@property (nonatomic,strong) NSMutableArray *dataArray_history;  //历史记录
@end
