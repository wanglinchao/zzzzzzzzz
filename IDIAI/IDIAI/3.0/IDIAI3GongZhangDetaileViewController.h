//
//  IDIAI3GongZhangDetaileViewController.h
//  IDIAI
//
//  Created by Ricky on 15/10/27.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseClick.h"
#import "CustomScrollView3.h"
#import "GongzhangListObj.h"
@interface IDIAI3GongZhangDetaileViewController : GeneralViewController<UITableViewDelegate,UITableViewDataSource,CollapseClickDelegate>{
    CollapseClick *myCollapseClick;
}
@property(nonatomic,strong)GongzhangListObj *obj;
@property(nonatomic,assign)NSInteger gongZhangID;
@property(nonatomic,strong)UITableView *table;
@property (nonatomic,assign) NSInteger selected_picture;
@property (nonatomic , strong) CustomScrollView3 *mainScorllView;
@property (nonatomic,strong) UILabel *lab_count;
@property (nonatomic, strong) NSMutableArray *data_array;
@property (nonatomic,strong) UIButton *btn_shouc;
@property (nonatomic,strong) UIButton *btn_phone;

@property (nonatomic,strong) NSString *fromwhere;
@end
