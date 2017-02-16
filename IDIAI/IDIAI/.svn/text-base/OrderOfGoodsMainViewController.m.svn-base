//
//  OrderOfGoodsMainViewController.m
//  IDIAI
//
//  Created by Ricky on 15/5/7.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "OrderOfGoodsMainViewController.h"
#import "util.h"
#import "IDIAIAppDelegate.h"
#import "OrderOfGoodsContentViewController.h"
#import "savelogObj.h"

@interface OrderOfGoodsMainViewController () <ViewPagerDataSource, ViewPagerDelegate>

@end

@implementation OrderOfGoodsMainViewController

-(void)viewWillAppear:(BOOL)animated{
    //    UIColor *color = kThemeColor;
    //    UIImage *image = [util imageWithColor:color];
    //    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    //    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    
    [savelogObj saveLog:@"进入商品订单" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:86];
    
    //一定要放在viewDidLoad之后 huangrun
    self.dataSource = self;
    self.delegate = self;
    
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"商品订单";
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerControllerFive *)viewPager {
    return 2;
}

- (UIView *)viewPager:(ViewPagerControllerFive *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = [NSString stringWithFormat:@"View %ld", (long)index];
    if (index == 0) {
        label.text = @"全部";
    } else if (index == 1) {
        label.text = @"已完成";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerControllerFive *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    OrderOfGoodsContentViewController *orderOfGoodsContentVC = [[OrderOfGoodsContentViewController alloc]init];
    orderOfGoodsContentVC.index = index;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:orderOfGoodsContentVC];
    return nav;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerControllerFive *)viewPager valueForOption:(ViewPagerOption____)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab____:
            if ([self.fromSecondTabStr isEqualToString:@"true"]) {
                return 1.0;
            }
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab____:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation____:
            return 1.0;
            break;
        case ViewPagerOptionTabWidth____:
            return kMainScreenWidth/2;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerControllerFive *)viewPager colorForComponent:(ViewPagerComponent____)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator____:
            return kThemeColor; //[[UIColor greenColor] colorWithAlphaComponent:0.64];
            break;
        default:
            break;
    }
    return color;
}

- (void)viewPager:(ViewPagerControllerFive *)viewPager didChangeTabToIndex:(NSUInteger)index {
    //    for (UIViewController *controller in viewPager.childViewControllers) {
    //
    //    }
}

@end
