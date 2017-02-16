//
//  MyhouseTypeVC.h
//  IDIAI
//
//  Created by iMac on 14-7-16.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralWithBackBtnViewController.h"
#import "TPKeyboardAvoidingTableView.h"

@interface MyhouseTypeVC : GeneralWithBackBtnViewController<UITableViewDataSource,UITableViewDelegate>
{
    TPKeyboardAvoidingTableView *mtableview;
    BOOL is_scroll;

    NSMutableArray *arr_Province; //省市区数组
}

@property (nonatomic,strong) NSString *provinceCode;
@property (nonatomic,strong) NSString *cityCode;
@property (nonatomic,strong) NSString *areaCode;
@property (nonatomic,strong) NSString *provinceName;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *areaName;

@property (nonatomic,strong) NSString *villageName;

@property (nonatomic,strong) NSMutableArray *data_Array;
@property (nonatomic,strong) NSMutableArray *data_Array2;//装修风格和档次用
@property (nonatomic,strong) NSMutableArray *data_Array_bottom;
@property (nonatomic,strong) NSMutableArray *data_Array_bottom2;//装修风格和档次用

@property (nonatomic,assign) float totale_area;

@property (nonatomic,strong) NSMutableArray *first_Array;
@property (nonatomic,strong) NSMutableArray *second_Array;
@property (nonatomic,strong) NSMutableArray *three_Array;
@property (nonatomic,strong) NSMutableArray *fourth_Array;
@property (nonatomic,strong) NSMutableArray *fifth_Array;

@property (nonatomic,assign) NSInteger index_selected;

@end
