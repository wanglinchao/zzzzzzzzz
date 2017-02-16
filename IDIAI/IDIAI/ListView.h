//
//  ListView.h
//  IDIAI
//
//  Created by iMac on 14-11-27.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownChooseDelegate;
@interface ListView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentExtendSection;     //当前展开的section ，默认－1时，表示都没有展开
}
@property (nonatomic, strong) UIView *mSuperView;
@property (nonatomic, strong) UIView *mTableBaseView;  //覆盖的防止触摸到别的视图上的视图
@property (nonatomic, strong) UITableView *mTableView_left;
@property (nonatomic, strong) UITableView *mTableView_right;
@property (nonatomic, assign) NSInteger selected_type; //选择中得按钮编号
@property (nonatomic, strong) NSArray *array_data_first;
@property (nonatomic, strong) NSArray *array_data_second;
@property (nonatomic, strong) NSArray *array_data_three;
@property (nonatomic, assign) NSInteger selected_cell_first; //选中得cell编号
@property (nonatomic, assign) NSInteger selected_cell_second_left; //选中得cell编号
@property (nonatomic, assign) NSInteger selected_cell_second_right; //选中得cell编号
@property (nonatomic, assign) NSInteger selected_cell_three; //选中得cell编号
@property (nonatomic, assign) id<DropDownChooseDelegate>delegate;

- (id)initWithFrame:(CGRect)frame  array_name:(NSArray *)arr_name type:(NSInteger)type_;

@end

@protocol DropDownChooseDelegate <NSObject>
-(void) chooseAtSection:(NSInteger)section indexId:(NSString *)index_id;
@end