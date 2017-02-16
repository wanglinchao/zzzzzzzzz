//
//  GoodsShowinMapVC.h
//  IDIAI
//
//  Created by iMac on 14-8-5.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface GoodsShowinMapVC : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
}

@property (nonatomic, strong) NSString *lng_map;
@property (nonatomic, strong) NSString *lat_map;
@property (nonatomic, strong) NSString *title_string;
@property (nonatomic, strong) NSString *address_string;
@property (nonatomic, strong) NSString *nav_title;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, assign) CLLocationCoordinate2D loctaionPt;
@property (nonatomic, strong) NSString *location_address;
@property (nonatomic, strong) NSString *city_str;
@end
