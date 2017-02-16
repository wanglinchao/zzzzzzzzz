//
//  IDIA3HomePageIViewController.h
//  IDIAI
//
//  Created by Ricky on 15/10/14.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "PullingRefreshTableView.h"
#import "EAIntroView.h"
@interface IDIA3HomePageIViewController : UIViewController<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,EAIntroDelegate>{
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
}
@property (nonatomic,strong) NSString *Cityname_location;
@property (nonatomic,strong) NSString *Citycode_location;
@property (nonatomic,strong) NSMutableArray *data_array;
@end
