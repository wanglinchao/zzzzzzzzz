//
//  AskingQuestionsViewController.m
//  IDIAI
//
//  Created by PM on 16/7/13.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "AskingQuestionsViewController.h"

@interface AskingQuestionsViewController ()

@end

@implementation AskingQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    
    
    
    
    
    //    if(selected_mark==1) self.mark_string=@"-1";
    //    else if(selected_mark==2) self.mark_string=@"1";
    //    else if(selected_mark==3) self.mark_string=@"2";
    //    else self.mark_string=@"3";
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
//    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-40)];
//    
//    _tableView.dataSource=self;
//    _tableView.delegate=self;
//    //    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
//    backView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//    _tableView.tableHeaderView =backView;
//    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
//    //[mtableview setFooterOnly:YES];         //只有上拉加载
//    
//    [self.view addSubview:_tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
