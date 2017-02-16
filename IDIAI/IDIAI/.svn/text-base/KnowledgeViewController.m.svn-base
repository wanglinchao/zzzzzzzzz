//
//  KnowledgeViewController.m
//  IDIAI
//
//  Created by Ricky on 14-12-4.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "IDIAIAppDelegate.h"
#import "DecorateProcessVCViewController.h"
#import "util.h"

@interface KnowledgeViewController ()

@end

@implementation KnowledgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:kColorWithRGB(249, 249, 250)];
    
    CGRect frame = CGRectMake(100, 29, 120, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = @"装修知识";
    self.navigationItem.titleView=label;
    
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    [self.tabBarController.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    
    self.dataSource = self;
    self.delegate = self;
    
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

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerControllerSix *)viewPager {
    return 8;
}

- (UIView *)viewPager:(ViewPagerControllerSix *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = [NSString stringWithFormat:@"View %ld", (long)index];
    NSArray *titleArr = @[@"装修风水",@"装前准备",@"家装设计",@"装修指南",@"材料揭秘",@"验收方法",@"软装搭配",@"入住贴示"];
    label.text = [titleArr objectAtIndex:index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerControllerSix *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    DecorateProcessVCViewController *decor=[[DecorateProcessVCViewController alloc]init];
    decor.knowledge_type=@"1";
    decor.selected_id = index;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:decor];
    return nav;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerControllerSix *)viewPager valueForOption:(ViewPagerOption______)option withDefault:(CGFloat)value {
    switch (option) {
        case ViewPagerOptionStartFromSecondTab______:
            return self.selectedIndex;
            break;
        case ViewPagerOptionCenterCurrentTab______:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation______:
            return 1.0;
            break;
        case ViewPagerOptionTabOffset______:
            return 0.0;
        case ViewPagerOptionTabWidth______:
            return kMainScreenWidth/4.01;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerControllerSix *)viewPager colorForComponent:(ViewPagerComponent______)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator______:
            return kThemeColor; //[[UIColor greenColor] colorWithAlphaComponent:0.64];
            break;
        default:
            break;
    }
    
    return color;
}

- (void)viewPager:(ViewPagerControllerSix *)viewPager didChangeTabToIndex:(NSUInteger)index {
    
}

- (void)clickNavRightBtn:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:kNCShowEffectyPicType object:nil];
}

@end
