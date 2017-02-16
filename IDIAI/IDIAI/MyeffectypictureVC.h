//
//  MyeffectypictureVC.h
//  IDIAI
//
//  Created by iMac on 14-7-28.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "GeneralWithBackBtnViewController.h"
#import "TMQuiltView.h"

@interface MyeffectypictureVC : GeneralWithBackBtnViewController <EGORefreshTableDelegate, UINavigationBarDelegate>
{
	//EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
    BOOL isrefreshing;
    
    UIControl *_control;
    UIScrollView *_scr;
    UIView *_dv;
    NSArray *_dataArr;//弹出层数据源
}
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (nonatomic,assign) NSInteger picture_style;//效果图风格
@property (nonatomic,assign) NSInteger picture_doorModel;//效果图户型
@property (nonatomic,assign) NSInteger picture_price;//效果图报价
@property (nonatomic,assign) NSInteger picture_city;//效果图城市
@property (nonatomic,strong) NSMutableArray *arr_cityCode;//城市的code

@property (nonatomic,strong) NSString *picture_type;
@property (nonatomic,strong) NSString *picture_title;
@property (nonatomic, assign) NSInteger typeIdInteger;//分类id
@property (nonatomic,assign) NSInteger selected_mark;
@property (strong, nonatomic) NSString *searchContent; //搜索内容
@property (nonatomic, retain) TMQuiltView *qtmquitView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isShowSearchBar;

-(void)refreshView;

@end
