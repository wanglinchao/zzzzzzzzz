//
//  HomePageViewController.h
//  UTOP
//
//  Created by iMac on 14-11-21.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "PullingRefreshTableView.h"
#import "EAIntroView.h"

@interface HomePageViewController : UIViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,EAIntroDelegate>

{
    UITableView *mtableview_main;
    PullingRefreshTableView *mtableview_sub;
    UIView *view_big;
    BOOL ischanged; //判读view是否滑出
    
    BOOL isOffsetChanged; //设置list的偏移量

    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;

}

@property (nonatomic,strong) NSString *Cityname_location;
@property (nonatomic,strong) NSString *Citycode_location;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *adDataArray;

-(void)PressBarItemRight;

@end
