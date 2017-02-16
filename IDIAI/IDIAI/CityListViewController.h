//
//  CityListViewController.h
//  IDIAI
//
//  Created by iMac on 14-11-25.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHSectionSelectionView.h"
#import "DemoSectionItemSubclass.h"
#import "BMapKit.h"
@class CityListObj;

@protocol CityListDelegate;
@interface CityListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,CHSectionSelectionViewDataSource, CHSectionSelectionViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    NSMutableArray *sections; //索引
    NSMutableArray *cellData; //索引对应的城市列表
    
    UISearchBar *mySearchBar;
    NSMutableArray *searchResults;
    
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
}

@property (nonatomic, strong) UITableView *testTableView;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;
@property (nonatomic, strong) CHSectionSelectionView *selectionView;
@property (weak, nonatomic) id<CityListDelegate> delegate;

@end

@protocol CityListDelegate <NSObject>
- (void)didSelectedCity:(CityListObj *)obj;
@end
