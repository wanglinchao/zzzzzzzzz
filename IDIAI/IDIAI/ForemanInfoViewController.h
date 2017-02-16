//
//  ForemanInfoViewController.h
//  IDIAI
//
//  Created by iMac on 14-10-23.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForemanObj.h"
#import "GongzhangListObj.h"

@interface ForemanInfoViewController : GeneralViewController<UITableViewDataSource, UITableViewDelegate>{
    UITableView *mtableview;
    BOOL is_open_first;
    BOOL is_open_second;
    BOOL is_change;
}

@property (nonatomic,strong) GongzhangListObj *obj_gz;
@property (nonatomic,strong) NSString *formanid;
@property (nonatomic,strong) NSMutableArray *data_array;
@property (nonatomic,strong) NSMutableArray *dataArray_pl;
@property (nonatomic,strong) UILabel *lab_count;
@property (nonatomic,assign) NSInteger selected_picture;
@property (nonatomic,assign) NSInteger count_first;
@property (nonatomic,assign) NSInteger count_second;
@property (nonatomic,strong) NSString *designer_id;
@property (nonatomic,strong) NSString *picture_id;

@end