//
//  WorkerListViewController.h
//  IDIAI
//
//  Created by iMac on 14-10-23.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
//#import "BMKLocationService.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface WorkerListViewController : GeneralViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,BMKLocationServiceDelegate>
{
    PullingRefreshTableView *mtableview;
    BMKLocationService *_locService;
    
    BOOL isFirstInt;
    BOOL isRegreingLocation; //刷新重新定位
}

@property (nonatomic,strong)  NSMutableArray *dataArray_quyu;
@property (nonatomic,strong)  NSMutableArray *dataArray_fenlei;
@property (nonatomic,strong)  NSMutableArray *dataArray_paixu;
@property (assign, nonatomic) BOOL refreshing;
@property (nonatomic,strong)  NSMutableArray *dataArray; //列表数据存放
@property (nonatomic,strong) NSString *type_id_; //工种类型id
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *sort_number; //排序类型
@property (nonatomic, strong) NSString *DistrictNO; //区域类型
@property (nonatomic, strong) NSString *searchContent; //搜索内容
@property (nonatomic, assign) NSInteger selected_cell; 
@end
