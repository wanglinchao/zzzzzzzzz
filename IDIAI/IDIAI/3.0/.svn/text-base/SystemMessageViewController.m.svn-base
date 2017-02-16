//
//  SystemMessageViewController.m
//  IDIAI
//
//  Created by PM on 16/7/27.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "util.h"
#import "IDIAIAppDelegate.h"
#import "MessageListVC.h"
#import "PushMessageViewController.h"
@interface SystemMessageViewController ()<ViewPagerDataSource,ViewPagerDelegate>

@end

@implementation SystemMessageViewController

-(void)viewWillAppear:(BOOL)animated{
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
    [appDelegate.nav setNavigationBarHidden:YES animated:NO];
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    
    //修改navBar字体大小文字颜色
    NSDictionary *attris = @{ NSFontAttributeName:[UIFont systemFontOfSize:19],
                              NSForegroundColorAttributeName:[UIColor blackColor] };
    [self.navigationController.navigationBar setTitleTextAttributes:attris];
}

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    self.delegate = self;
    
    self.title = @"消息";
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [super viewDidLoad];//一定要放在最后 不然有问题 huangrun
    
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
        label.text = @"交易动态";
    } else {
        label.text = @"系统公告";
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor blackColor];
    
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerControllerFive *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == 0) {
        PushMessageViewController *pushMsgVC = [[PushMessageViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pushMsgVC];
        return nav;
    }
    else {
        MessageListVC *messageListVC = [[MessageListVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:messageListVC];
        return nav;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerControllerFive *)viewPager valueForOption:(ViewPagerOption____)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab____:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab____:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation____:
            return 1.0;
            break;
        case ViewPagerOptionTabWidth____:
            return kMainScreenWidth/2.0;
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
    
}

//- (void)clickNavRightBtn:(id)sender {
//    [[NSNotificationCenter defaultCenter]postNotificationName:kNCShowEffectyPicType object:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
