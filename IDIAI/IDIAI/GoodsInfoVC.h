//
//  GoodsInfoVC.h
//  IDIAI
//
//  Created by iMac on 14-7-31.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
//#import "BMKMapView.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
//#import "BMKLocationService.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "GoodscategoryVC.h"
#import "BusinessInfoVC.h"

@interface GoodsInfoVC : UIViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,BMKLocationServiceDelegate,GoodscategoryVCDelegate,BusinessInfoVCDelegate>
{
    PullingRefreshTableView *mtableview;
    
    BMKLocationService *_locService;
    
    BOOL isFirstInt;
    
    BOOL isrefreshLocation;
}

@property (nonatomic,strong)  NSMutableArray *dataArray;
@property (nonatomic,strong)  NSMutableArray *dataArray_quyu;
@property (nonatomic,strong)  NSMutableArray *dataArray_fenlei;
@property (nonatomic,strong)  NSMutableArray *dataArray_paixu;
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) BOOL refreshing;
@property (assign, nonatomic) BOOL is_delegate;
@property (assign, nonatomic) BOOL is_loadorrefering;
@property (assign, nonatomic) BOOL is_first_load;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *search_content;
@property (nonatomic, strong) NSString *business_id;
@property (nonatomic, strong) NSString *requestArea;
@property (nonatomic, strong) NSString *title_lab;

@end
