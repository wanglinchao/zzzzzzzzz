//
//  MySeverOrderViewController.m
//  IDIAI
//
//  Created by PM on 16/7/26.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MySeverOrderViewController.h"
#import "MyOrderMainViewController.h"
#import "MySubscribeViewController.h"
#import "RefundAndAfterSaleMainViewController.h"

@interface MySeverOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MySeverOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    // Do any additional setup after loading the view.
}

- (void)createUI{
     self.title =@"我的服务订单";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 90, 40)];
    [_rightButton setImage:[UIImage imageNamed:@"btn_dianhua"] forState:UIControlStateNormal];
     _rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 25, 0, -5);
    [_rightButton addTarget:self
                     action:@selector(PressBarItemRight)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];

    self.tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)PressBarItemRight{
    NSString *serviceNumber = serviceNumber=[@"400-888-7372" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",serviceNumber]]]];
    webview.hidden = YES;
    // Assume we are in a view controller and have access to self.view
    [self.view addSubview:webview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSArray *cellImageArr = @[@"ic_wodeyuyue_dingdan",@"ic_fuwudingdan_d",@"ic_tuikunshouhou_d"];
    NSArray *cellNameArr = @[@"我的预约",@"服务订单",@"服务售后"];
    cell.imageView.image = [UIImage imageNamed:[cellImageArr objectAtIndex:indexPath.row]];
    cell.textLabel.text = [cellNameArr objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self showSubscribe];
    }else if(indexPath.row==1){
        [self showOrderMain];
    }else{
        [self showSales];
    }

}



-(void)showSubscribe{
 
        MySubscribeViewController *mySubcribeVC = [[MySubscribeViewController alloc]init];
        mySubcribeVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:mySubcribeVC animated:YES];
    
}

-(void)showOrderMain{
        MyOrderMainViewController *myOrderVC = [[MyOrderMainViewController alloc]init];
        myOrderVC.hidesBottomBarWhenPushed=YES;
        myOrderVC.fromIndex =1;
        [self.navigationController pushViewController:myOrderVC animated:YES];
    
}

-(void)showSales{
        RefundAndAfterSaleMainViewController *refundAndAfterSaleVC = [[RefundAndAfterSaleMainViewController alloc] init];
        refundAndAfterSaleVC = [[RefundAndAfterSaleMainViewController alloc]init];
        refundAndAfterSaleVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:refundAndAfterSaleVC animated:YES];
  

}
@end
