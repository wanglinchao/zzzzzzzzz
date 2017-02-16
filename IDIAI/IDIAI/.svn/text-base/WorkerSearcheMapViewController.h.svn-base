//
//  WorkerSearcheMapViewController.h
//  IDIAI
//
//  Created by iMac on 14-10-23.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface WorkerSearcheMapViewController : GeneralViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    
    BOOL is_notif_bmk;
}

@property (nonatomic, strong) NSMutableArray *data_array;
@property (nonatomic, strong) NSString *lng_left;
@property (nonatomic, strong) NSString *lat_left;
@property (nonatomic, strong) NSString *lng_right;
@property (nonatomic, strong) NSString *lat_right;
@property (nonatomic, assign) NSInteger type_id;  //工种id
@property (nonatomic, assign) NSInteger selectedBtn;  //选中工种的序列号

@end
