//
//  HostViewController.m
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import "HostViewController.h"
#import "MyeffectypictureVC.h"
#import "util.h"
#import "DistrictView.h"
#import "IDIAIAppDelegate.h"

@interface HostViewController () <ViewPagerDataSource, ViewPagerDelegate> {
    
    MyeffectypictureVC *_myEffectyPicVC;
    
    NSString *_theTestStr;
}


@end

@implementation HostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
//    [[[self navigationController] navigationBar] setHidden:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [[[self navigationController] navigationBar] setHidden:NO];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    UIColor *color = kThemeColor;
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
//    
    appDelegate.nav.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    
    self.dataSource = self;
    self.delegate = self;
    
    self.title = @"图酷";
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //导航右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 42, 42);
    [rightBtn setImage:[UIImage imageNamed:@"ic_fengge"] forState:UIControlStateNormal];
    //右移
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    [rightBtn addTarget:self action:@selector(clickNavRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
    label.text = [NSString stringWithFormat:@"View %i", index];
    if (index == 0) {
        label.text = @"最新图酷";
    } else if (index == 1) {
        label.text = @"推荐图酷";
    } else if (index == 2){
        label.text = @"最新套图";
    } else {
        label.text = @"推荐套图";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    _myEffectyPicVC = [[MyeffectypictureVC alloc]init];
    _myEffectyPicVC.typeIdInteger = index;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_myEffectyPicVC];
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

- (void)clickNavRightBtn:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:kNCShowEffectyPicType object:nil];
}

- (void)backButtonPressed:(id)sender {
 //   [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUDEffectyTypeOfRow_Style];   //jiangt
    [self.navigationController popViewControllerAnimated:YES];
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    for (UIView *view in keywindow.subviews) {
        if ([view isKindOfClass:[DistrictView class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIControl class]]) {
            [view removeFromSuperview];
        }
    }

}

@end
