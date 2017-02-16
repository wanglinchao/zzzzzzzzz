//
//  DecorateProcessVCViewController.h
//  IDIAI
//
//  Created by iMac on 14-7-15.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "GeneralViewController.h"

@interface DecorateProcessVCViewController : GeneralViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    PullingRefreshTableView *mtableview;
    
}
@property (nonatomic,strong) NSMutableArray *data_Array;
@property (nonatomic,strong) NSString *knowledge_type;
@property (nonatomic,assign) NSInteger currentPage; //当前页数
@property (nonatomic,assign) NSInteger totalPages;  //总页数
@property (assign, nonatomic) BOOL refreshing;
@property (assign,nonatomic) NSInteger selected_id;


@end
