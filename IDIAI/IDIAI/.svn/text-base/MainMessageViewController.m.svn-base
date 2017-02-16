//
//  MainMessageViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-20.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MainMessageViewController.h"
#import "SystemMessageViewController.h"
#import "MyToDoViewController.h"
#import "MyMailMainViewController.h"
#import "IDIAIAppDelegate.h"
@interface MainMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MainMessageViewController

-(void)viewWillAppear:(BOOL)animated{
//    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
//    [appDelegate.nav setNavigationBarHidden:YES animated:NO];
//    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
//    
//    //修改navBar字体大小文字颜色
//    NSDictionary *attris = @{ NSFontAttributeName:[UIFont systemFontOfSize:19],
//                              NSForegroundColorAttributeName:[UIColor blackColor] };
//    [self.navigationController.navigationBar setTitleTextAttributes:attris];
}

- (void)viewDidLoad {
    [super viewDidLoad];//一定要放在最后 不然有问题 huangrun
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    self.title = @"消息";
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    
}

-(void)PressMyToDo{

        MyToDoViewController *myToDoVC = [[MyToDoViewController alloc]init];
        myToDoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myToDoVC animated:YES];
    
}
-(void)PressMyMail{
    
    MyMailMainViewController *myOrderVC = [[MyMailMainViewController alloc]init];
    myOrderVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:myOrderVC animated:YES];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
    return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSArray *cellImageArr = @[@[@"ic_xitongxiaoxi"],@[@"ic_daiban",@"ic_xinxiang_xiaoxi"]];
    NSArray *cellNameArr = @[@[@"系统消息"],@[@"待办",@"信箱"]];
    if(indexPath.section==0){
        
        cell.imageView.image = [UIImage imageNamed:[[cellImageArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        cell.textLabel.text = [[cellNameArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];;
    }else {
    
        cell.imageView.image = [UIImage imageNamed:[[cellImageArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        cell.textLabel.text = [[cellNameArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];;

    }
       cell.textLabel.font = [UIFont systemFontOfSize:14];
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        SystemMessageViewController * systemMessageVC = [[SystemMessageViewController alloc]init];
        systemMessageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:systemMessageVC animated:YES];
    }else {
        if(indexPath.row==1){
            [self PressMyToDo];
        }else{
            [self PressMyMail];
        }
    }
    
}



@end
