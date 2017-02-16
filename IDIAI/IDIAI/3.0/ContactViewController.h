//
//  ContactViewController.h
//  IDIAI
//
//  Created by Ricky on 16/5/16.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHSectionSelectionView.h"
#import "DemoSectionItemSubclass.h"
#import "GeneralWithBackBtnViewController.h"
@interface ContactViewController : GeneralWithBackBtnViewController<UITableViewDataSource, UITableViewDelegate,CHSectionSelectionViewDataSource, CHSectionSelectionViewDelegate>{
    NSMutableArray *sections; //索引
    NSMutableArray *cellData; //索引对应的城市列表
}
@property (nonatomic, strong) UITableView *testTableView;
@property (nonatomic, strong) CHSectionSelectionView *selectionView;
typedef void (^SelectBlock)(NSMutableArray *selectContactArray);
@property (nonatomic, copy) SelectBlock selectDone;
@property (nonatomic,strong)NSMutableArray *selectlist;
@end
