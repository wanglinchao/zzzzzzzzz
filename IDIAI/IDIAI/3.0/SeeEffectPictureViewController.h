//
//  SeeEffectPictureViewController.h
//  IDIAI
//
//  Created by iMac on 15/10/20.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface SeeEffectPictureViewController : GeneralWithBackBtnViewController<EGORefreshTableDelegate, UINavigationBarDelegate>
{
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
    BOOL isrefreshing;
    
    UIControl *_control;
    UIView *_dv;
    UIScrollView *_scr;
    NSArray *_dataArr;//弹出层数据源
}
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (nonatomic,assign) NSInteger picture_style;//效果图风格
@property (nonatomic,assign) NSInteger picture_kongjian;//效果图空间

@property (nonatomic,strong) NSString *picture_title;
@property (nonatomic, assign) NSInteger typeIdInteger;//分类id


@end
