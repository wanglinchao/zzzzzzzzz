//
//  WaytomapViewController.h
//  IDIAI
//
//  Created by iMac on 14-10-20.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface WaytomapViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    UIView *view_big;
    BOOL ischanged;
}
@property(nonatomic,strong) BMKTransitRouteLine *plan_trans;
@property(nonatomic,strong) BMKDrivingRouteLine *plan_drive;
@property(nonatomic,strong) BMKWalkingRouteLine *plan_walk;
@property(nonatomic,strong) NSString *tranvel_type;
@property (nonatomic, strong) NSArray *data_Arr;

@end
