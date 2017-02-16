//
//  IDIAI3NewHomePageViewController.h
//  IDIAI
//
//  Created by iMac on 16/2/17.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "PullingRefreshTableView.h"

@interface IDIAI3NewHomePageViewController : UIViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    
    PullingRefreshTableView *mtableview;
}
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) NSString *Cityname_location;
@property (nonatomic,strong) NSString *Citycode_location;
@property (nonatomic,strong) NSMutableArray *data_array;   //banner的数据
@property (nonatomic,strong) NSMutableArray *recom_array;   //首页推荐信息的数据

@end
