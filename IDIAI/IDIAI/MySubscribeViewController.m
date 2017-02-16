//
//  MySubscribeViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-15.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MySubscribeViewController.h"
#import "MySubscribeContentViewController.h"
#import "IDIAIAppDelegate.h"
#import "util.h"

@interface MySubscribeViewController () <ViewPagerDataSource, ViewPagerDelegate>


@end

@implementation MySubscribeViewController

-(void)viewWillAppear:(BOOL)animated{

    UIImage *image = [util imageWithColor:[UIColor whiteColor]];//zl
//
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
    [appDelegate.nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [appDelegate.nav setNavigationBarHidden:YES animated:NO];

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
//
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [util imageWithColor:[UIColor colorWithHexString:@"#E0E0E0" alpha:1.0]];
    

    self.navigationController.view.backgroundColor = [UIColor clearColor];
    UIToolbar* blurredView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -20, kMainScreenWidth, 64)];
    //    [blurredView setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar insertSubview:blurredView atIndex:0];
    //修改navBar字体大小文字颜色
    NSDictionary *attris = @{ NSFontAttributeName:[UIFont systemFontOfSize:19],
                              NSForegroundColorAttributeName:[UIColor blackColor] };
    [self.navigationController.navigationBar setTitleTextAttributes:attris];
    
           [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];

}

- (void)viewDidLoad {
    //一定要放在viewDidLoad之后 huangrun
    self.dataSource = self;
    self.delegate = self;
   
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"我的预约";
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 4;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = [NSString stringWithFormat:@"View %ld", (long)index];
    if (index == 0) {
        label.text = @"全部";
    } else if (index == 1) {
        label.text = @"设计师";
    } else if (index == 2){
        label.text = @"工长";
    } else {
        label.text = @"监理";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    MySubscribeContentViewController *mySubscribeContentVC = [[MySubscribeContentViewController alloc]init];
    if (index == 0) {
        mySubscribeContentVC.typeInteger = -1;
    } else if (index == 1) {
    mySubscribeContentVC.typeInteger = 1;
    } else if (index == 2) {
        mySubscribeContentVC.typeInteger = 4;
    } else if (index == 3) {
        mySubscribeContentVC.typeInteger = 6;
    }
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mySubscribeContentVC];
    return nav;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
            
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

-(void)PressBarItemRight{
   
}


@end
