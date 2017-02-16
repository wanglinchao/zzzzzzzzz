//
//  BaseShoppingMallViewController.m
//  IDIAI
//
//  Created by iMac on 15-9-23.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "BaseShoppingMallViewController.h"
#import "IDIAIAppDelegate.h"
#import "ShoppingMallViewController.h"

@interface BaseShoppingMallViewController ()

@end

@implementation BaseShoppingMallViewController

-(void)viewDidAppear:(BOOL)animated{
    ShoppingMallViewController *shoppingMallVC = [[ShoppingMallViewController alloc]init];
    shoppingMallVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:shoppingMallVC animated:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.tabBarController.navigationController setNavigationBarHidden:YES];
    IDIAIAppDelegate *delegate=(IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [[delegate.nav navigationBar] setHidden:YES];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
