//
//  AskingQuestionsViewController.h
//  IDIAI
//
//  Created by PM on 16/7/13.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"

@interface AskingQuestionsViewController : GeneralWithBackBtnViewController

@property(nonatomic,strong)UITableView * tableView;
@property (copy, nonatomic) NSString *fromStr;
@end
