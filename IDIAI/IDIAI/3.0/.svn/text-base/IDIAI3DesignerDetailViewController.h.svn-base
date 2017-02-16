//
//  IDIAI3DesignerDetailViewController.h
//  IDIAI
//
//  Created by Ricky on 15/10/16.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignerInfoObj.h"
#import "CollapseClick.h"
#import "CustomScrollView3.h"
@interface IDIAI3DesignerDetailViewController : GeneralViewController<UITableViewDelegate,UITableViewDataSource,CollapseClickDelegate>{
    CollapseClick *myCollapseClick;
}
@property(nonatomic,strong)DesignerInfoObj *obj;
@property(nonatomic,assign)NSInteger designerID;
@property(nonatomic,strong)UITableView *table;
@property (nonatomic,assign) NSInteger selected_picture;
@property (nonatomic , strong) CustomScrollView3 *mainScorllView;
@property (nonatomic,strong) UILabel *lab_count;
@property (nonatomic,strong) UIButton *btn_shouc;
@property (nonatomic,strong) UIButton *btn_phone;

@property (nonatomic,strong) NSString *fromwhere;
@end
