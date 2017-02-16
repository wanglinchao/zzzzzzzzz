//
//  MypieChartVC.h
//  IDIAI
//
//  Created by iMac on 14-7-22.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "GeneralWithBackBtnViewController.h"

@interface MypieChartVC : GeneralWithBackBtnViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIView *top_viewBG;
    UITableView *mtableview;
    FMDatabase *db;
}
@property (nonatomic,strong) UILabel *totalPrice_zj;
@property (nonatomic,strong) UILabel *totalPrice_jzck;
@property (nonatomic,strong) UILabel *totalPrice_zcck;
@property (nonatomic,strong) NSString *sql_string;
@property (nonatomic,strong) NSMutableArray *arr_get;
@property (nonatomic,strong) NSMutableArray *arr_type;
@property (nonatomic,strong) NSMutableDictionary *all_dictionary;
@property (nonatomic,strong) NSMutableArray *data_bottom;
@property (nonatomic,assign) float totalMoney;

@property (nonatomic,strong) NSString *provinceCode;
@property (nonatomic,strong) NSString *cityCode;
@property (nonatomic,strong) NSString *areaCode;

@property (copy, nonatomic) NSString *addressNameStr;
@property (copy, nonatomic) NSString *totalAreaStr;
@property (copy, nonatomic) NSString *decorationLevelStr;


@end
