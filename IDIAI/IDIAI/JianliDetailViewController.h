//
//  DesingerDetailViewController.h
//  IDIAI
//
//  Created by Ricky on 15-3-6.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupervisorListObj.h"
#import "CustomScrollView.h"
#import "MyeffectPictureObj.h"
#import "PullingRefreshTableView.h"
@interface JianliDetailViewController : GeneralViewController <UITableViewDataSource, UITableViewDelegate,PullingRefreshTableViewDelegate>

@property (nonatomic,strong) SupervisorListObj *obj;

@property (assign, nonatomic) NSInteger numberStart;
@property (strong, nonatomic) UIView *startView;
@property (strong, nonatomic) NSMutableArray *imageViewArray;

@property (nonatomic,assign) NSInteger selected_picture;
@property (nonatomic , strong) CustomScrollView *mainScorllView;
@property (nonatomic,strong) UILabel *lab_count;

@property (nonatomic,strong) UIButton *btn_shouc;
@property (nonatomic,strong) UIButton *btn_phone;

@property (nonatomic,strong) NSMutableArray *dataArray_pl;

@property (nonatomic, strong) NSMutableArray *data_array;

@property (copy, nonatomic) NSString *fromVCStr;

@property (copy, nonatomic) NSString *fromJianliStr;

@end
