//
//  BusinessInfoVC.h
//  IDIAI
//
//  Created by iMac on 14-7-30.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodslistObj.h"

@protocol BusinessInfoVCDelegate;
@interface BusinessInfoVC : GeneralViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mtableview;
    BOOL is_open_first;
    BOOL is_open_second;
    BOOL is_change;
    
    BOOL is_login_px;
    BOOL is_pj_star;
    id<BusinessInfoVCDelegate>delegate;
}
@property (weak, nonatomic) id<BusinessInfoVCDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *data_array;
@property (nonatomic,strong) UILabel *lab_count;
@property (nonatomic,strong) GoodslistObj *obj;
@property (nonatomic,assign) NSInteger selected_picture;
@property (nonatomic,assign) NSInteger count_first;
@property (nonatomic,assign) NSInteger count_second;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger totalPage;

@end

@protocol BusinessInfoVCDelegate <NSObject>
- (void)reloadThing:(NSString *)string ;
@end