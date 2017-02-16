//
//  DecorateViewController.h
//  UTOP
//
//  Created by iMac on 14-11-21.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralViewController.h"
#import "PullingRefreshTableView.h"

@interface DecorateViewController : GeneralWithBackBtnViewController <UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSMutableArray *arr_Province; //省市区数组
}

@property (nonatomic,strong) NSString *provinceCode;
@property (nonatomic,strong) NSString *cityCode;
@property (nonatomic,strong) NSString *areaCode;
@property (nonatomic,strong) NSString *provinceName;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *areaName;

@end
