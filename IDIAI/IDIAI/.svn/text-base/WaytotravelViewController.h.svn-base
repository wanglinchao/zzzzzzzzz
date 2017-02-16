//
//  WaytotravelViewController.h
//  IDIAI
//
//  Created by iMac on 14-10-17.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface WaytotravelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BMKRouteSearchDelegate>
{
    UITableView *mtableview;
    BOOL ischanged;
    
    BMKRouteSearch* _routesearch;
    UIView *view_ts;
}

@property (nonatomic, strong) NSString *startingAdd;
@property (nonatomic, strong) NSString *endingAdd;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) NSString *wayType;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataPoint;
@property (nonatomic, assign) CLLocationCoordinate2D loctaionPt_self;
@property (nonatomic, assign) CLLocationCoordinate2D loctaionPt_shop;
@end
