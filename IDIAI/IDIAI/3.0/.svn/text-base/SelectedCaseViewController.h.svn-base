//
//  SelectedCaseViewController.h
//  IDIAI
//
//  Created by iMac on 16/4/5.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralViewController.h"
#import "PullingRefreshTableView.h"

@interface SelectedCaseViewController : GeneralViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    PullingRefreshTableView *mtableview;
    NSMutableArray *dataArray;
    BOOL isFirstInt;
}

@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) BOOL refreshing;

@property (nonatomic,strong) NSString *shareUrl;//分享的url
@property (nonatomic,assign) NSInteger picture_style;//效果图风格
@property (nonatomic,assign) NSInteger picture_doorModel;//效果图户型
@property (nonatomic,assign) NSInteger picture_price;//效果图报价
@property (nonatomic,assign) NSInteger picture_city;//效果图城市
@property (nonatomic,strong) NSMutableArray *arr_cityCode;//城市的code

@end
