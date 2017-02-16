//
//  PsdManageViewController.m
//  IDIAI
//
//  Created by Ricky on 15-2-2.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PsdManageViewController.h"
#import "ModifyPsdViewController.h"
#import "InputLoginPsdViewController.h"
#import "util.h"

@interface PsdManageViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_theTableView;
}

@end

@implementation PsdManageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    UIColor *color = [UIColor colorWithHexString:@"#EF6562" alpha:1.0];
//    UIImage *image = [util imageWithColor:color];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = image;
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"密码管理";
    _theTableView = [[UITableView alloc]initWithFrame:kTableViewWithTabBarFrame style:UITableViewStyleGrouped];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    [self.view addSubview:_theTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PsdManagerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *titleArr = @[@"修改登录密码", @"设置支付密码"];
    NSArray *imgArr = @[@"ic_mm.png",@"ic_zhifumima.png"];
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[imgArr objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ModifyPsdViewController *modifyPsdVC = [[ModifyPsdViewController alloc]init];
        [self.navigationController pushViewController:modifyPsdVC animated:YES];
    } else {
        InputLoginPsdViewController *inputLoginPsdVC = [[InputLoginPsdViewController alloc]init];
        [self.navigationController pushViewController:inputLoginPsdVC animated:YES];
    }
}

@end
