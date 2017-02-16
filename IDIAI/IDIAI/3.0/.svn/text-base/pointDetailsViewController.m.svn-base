//
//  pointDetailsViewController.m
//  IDIAI
//
//  Created by PM on 16/6/15.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "pointDetailsViewController.h"
#import "util.h"
#import "PointsDetailsContentViewController.h"
#import "savelogObj.h"

@interface pointDetailsViewController ()

@end

@implementation pointDetailsViewController
@synthesize fromIndex;
-(void)viewWillAppear:(BOOL)animated{
    
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    
    [savelogObj saveLog:@"查看积分详情" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:66];
    
    self.dataSource = self;
    self.delegate = self;

    self.title = @"积分明细";
    
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
//设置每一页的view
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = [NSString stringWithFormat:@"View %lu", (unsigned long)index];
   
    if (index == 0) {
        label.text = @"全部";
    } else if (index == 1) {
        label.text = @"收入";
    } else {
        label.text = @"支出";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    PointsDetailsContentViewController *pointsDetailsContentVC =[[PointsDetailsContentViewController alloc] init];
    
    if (index == 0) {
        
        pointsDetailsContentVC.typeInteger = 0;
        pointsDetailsContentVC.pointVC = self;
        return pointsDetailsContentVC;
        
    } else if (index == 1) {
        
        pointsDetailsContentVC.typeInteger =1;
        pointsDetailsContentVC.pointVC = self;
        return pointsDetailsContentVC;
    } else {
        
        pointsDetailsContentVC.typeInteger = 2;
        pointsDetailsContentVC.pointVC = self;
        return pointsDetailsContentVC;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:{
            if (fromIndex ==0) {
                return 0;
            }else if (fromIndex ==1){
                return 1;
            }else if (fromIndex ==2){
                return 0;
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
  
}

@end
