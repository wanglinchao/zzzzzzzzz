//
//  GoodscategoryVC.h
//  IDIAI
//
//  Created by iMac on 14-7-31.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@protocol GoodscategoryVCDelegate;
@interface GoodscategoryVC : UIViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    PullingRefreshTableView *mtableview;
}
@property (weak, nonatomic) id<GoodscategoryVCDelegate> delegate;
@property (nonatomic,strong)  NSMutableArray *dataArray;

@property (nonatomic,strong)  NSString *entrance_type;

@end

@protocol GoodscategoryVCDelegate <NSObject>
- (void)selectedThing:(NSString *)string Title:(NSString *)title;
@end