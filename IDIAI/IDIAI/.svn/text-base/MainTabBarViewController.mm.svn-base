//
//  MainTabBarViewController.m
//  IDIAI
//
//  Created by iMac on 14-11-21.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "DecorateViewController.h"
#import "MyInfoViewController.h"
#import "util.h"
#import "ResgisterSMScodeVCViewController.h"
#include "LoginVC.h"
#import "HexColor.h"
#import "IDIAIAppDelegate.h"
#import "LoginVC.h"
#import "UtopViewController.h"
#import "GoodsInfoVC.h"
#import "ShoppingMallViewController.h"
#import "IDIAI3NewHomePageViewController.h"
#import "IDIAI3DiaryMainViewController.h"
#import "SelectedCaseViewController.h"

#define kCurrentVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

@interface MainTabBarViewController ()<UITabBarControllerDelegate,loggedDelegate>

@property (nonatomic , assign) NSInteger willSelectedIndex;

@end

@implementation MainTabBarViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotifcationForDiary object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displaySmallRedDot:) name:NotifcationForDiary object:nil];
    
    IDIAI3NewHomePageViewController *firstvc =[[IDIAI3NewHomePageViewController alloc] init];
    UINavigationController *nav_first=[[UINavigationController alloc]initWithRootViewController:firstvc];
    nav_first.interactivePopGestureRecognizer.delegate = nil;
    
    IDIAI3DiaryMainViewController *diaryMVC = [[IDIAI3DiaryMainViewController alloc]init];
    diaryMVC.isseven =YES;
    UINavigationController *navShoppingMallVC = [[UINavigationController alloc]initWithRootViewController:diaryMVC];
    navShoppingMallVC.interactivePopGestureRecognizer.delegate = nil;
    
    SelectedCaseViewController *selectedCase = [[SelectedCaseViewController alloc]init];
    UINavigationController *nav_selectedCase=[[UINavigationController alloc]initWithRootViewController:selectedCase];
    nav_selectedCase.interactivePopGestureRecognizer.delegate = nil;
    
    UtopViewController *fourvc = [[UtopViewController alloc]init];
    UINavigationController *nav_four=[[UINavigationController alloc]initWithRootViewController:fourvc];
    nav_four.interactivePopGestureRecognizer.delegate = nil;
    
    MyInfoViewController *fifthvc=[[MyInfoViewController alloc]init];
    UINavigationController *nav_fifth=[[UINavigationController alloc]initWithRootViewController:fifthvc];
    nav_fifth.interactivePopGestureRecognizer.delegate = nil;
    
    UITabBarItem *item_first=[[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"ic_shouye3_nor"] selectedImage:[UIImage imageNamed:@"ic_shouye3_s"]];
    UITabBarItem *item_second=[[UITabBarItem alloc]initWithTitle:@"论坛" image:[UIImage imageNamed:@"ic_riji_nor.png"] selectedImage:[UIImage imageNamed:@"ic_riji_pressed.png"]];
    UITabBarItem *item_three=[[UITabBarItem alloc]initWithTitle:@"案例" image:[UIImage imageNamed:@"ic_anli_nor.png"] selectedImage:[UIImage imageNamed:@"ic_anli_pressed.png"]];
    UITabBarItem *item_four=[[UITabBarItem alloc]initWithTitle:@"订单" image:[UIImage imageNamed:@"ic_dingdan_nor.png"] selectedImage:[UIImage imageNamed:@"ic_dingdan_s.png"]];
    UITabBarItem *item_fifth=[[UITabBarItem alloc]initWithTitle:@"我" image:[UIImage imageNamed:@"ic_me3_nor"] selectedImage:[UIImage imageNamed:@"ic_me3_s"]];
    nav_first.tabBarItem=item_first;
    navShoppingMallVC.tabBarItem = item_second;
    nav_selectedCase.tabBarItem = item_three;
    nav_four.tabBarItem=item_four;
    nav_fifth.tabBarItem = item_fifth;
    
    self.tabBar.tintColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
   // self.tabBar.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    self.tabBar.translucent = YES;
    self.delegate=self;
    self.hidesBottomBarWhenPushed =YES;

    self.viewControllers=@[nav_first,navShoppingMallVC,nav_selectedCase,nav_four,nav_fifth];
    self.selectedIndex=0;
}

#pragma mark - UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    self.willSelectedIndex=[tabBarController.tabBar.items indexOfObject:tabBarController.tabBar.selectedItem];
    if(self.willSelectedIndex==1) [self removeSmallRedDotFromTabBar];
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    if(tabBarController.selectedIndex==1){
//        IDIAI3DiaryMainViewController *diaryMVC = [[IDIAI3DiaryMainViewController alloc]init];
//        diaryMVC.hidesBottomBarWhenPushed = YES;
//        [viewController.navigationController pushViewController:diaryMVC animated:NO];
//    }
}

#pragma mark - LoginDelegate
-(void)logged:(NSDictionary *)dict{
    self.selectedIndex=self.willSelectedIndex;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)cancel{
    
}

#pragma mark - 论坛小红点
-(void)displaySmallRedDot:(NSNotification *)notif{
    [self addSmallRedDotToTabBar];
}
//添加小红点
- (void)addSmallRedDotToTabBar {
    UIImageView *dotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dian.png"]];
    dotImage.backgroundColor = [UIColor clearColor];
    dotImage.tag = 1001;
    CGRect tabFrame = self.tabBar.frame;
    CGFloat x = ceilf(0.34 * tabFrame.size.width);
    CGFloat y = ceilf(0.14 * tabFrame.size.height);
    dotImage.frame = CGRectMake(x, y, 8, 8);
    [self.tabBar addSubview:dotImage];
}
//移除小红点
-(void)removeSmallRedDotFromTabBar{
    UIImageView *dotImage = (UIImageView *)[self.tabBar viewWithTag:1001];
    [dotImage removeFromSuperview];
    dotImage = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
