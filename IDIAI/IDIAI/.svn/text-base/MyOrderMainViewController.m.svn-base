//
//  MyOrderMainViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-21.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyOrderMainViewController.h"
#import "IDIAIAppDelegate.h"
#import "util.h"
//#import "MyOrderContentViewController.h"
#import "DynamicViewController.h"
#import "MyOrderSpecifiedViewController.h"
#import "savelogObj.h"
#import "IDIAI3ContractViewController.h"
@interface MyOrderMainViewController ()

@end

@implementation MyOrderMainViewController
@synthesize fromIndex;

-(void)viewWillAppear:(BOOL)animated{
//    UIColor *color = kThemeColor;
//    UIImage *image = [util imageWithColor:color];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:YES animated:NO];

    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    
    [savelogObj saveLog:@"进入服务订单" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:66];
    
    //一定要放在viewDidLoad之后 huangrun
    self.dataSource = self;
    self.delegate = self;
    
    // Do any additional setup after loading the view.

    self.title = @"我的订单";
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
    }
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 3;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = [NSString stringWithFormat:@"View %i", index];

    if (index == 0) {
        label.text = @"进行中";
    } else if (index == 1) {
        label.text = @"已完成";
    } else {
        label.text = @"全部";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
//    MyOrderContentViewController *myOrderContentVC = [[MyOrderContentViewController alloc]init];
    IDIAI3ContractViewController *myOrderContentVC =[[IDIAI3ContractViewController alloc] init];
//    DynamicViewController *dynamicVC = [[DynamicViewController alloc]init];
//    MyOrderSpecifiedViewController *myOrderSpecifiedVC = [[MyOrderSpecifiedViewController alloc]init];
//    if (index == 0) {
//        myOrderContentVC.typeInteger = -1;
//    } else if (index == 1) {`
//        myOrderContentVC.typeInteger = 1;
//    } else if (index == 2) {
//        myOrderContentVC.typeInteger = 4;
//    } else if (index == 3) {
//        myOrderContentVC.typeInteger = 6;
//    }

    if (index == 0) {
        
        myOrderContentVC.typeInteger = 1;

//        [nav.navigationBar setTintColor:[UIColor whiteColor]];
        return myOrderContentVC;
    } else if (index == 1) {
        myOrderContentVC.typeInteger =2;

        return myOrderContentVC;
    } else {
        myOrderContentVC.typeInteger = -1;

        return myOrderContentVC;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:{
            if (fromIndex ==1) {
                return 0;
            }else if (fromIndex ==2){
                return 1;
            }else if (fromIndex ==0){
                return 2;
            }
        }
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
            case ViewPagerOptionTabWidth:
            return kMainScreenWidth/3;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return kThemeColor; //[[UIColor greenColor] colorWithAlphaComponent:0.64];
            break;
        default:
            break;
    }
    
    return color;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    //    for (UIViewController *controller in viewPager.childViewControllers) {
    //
    //    }
}


@end
