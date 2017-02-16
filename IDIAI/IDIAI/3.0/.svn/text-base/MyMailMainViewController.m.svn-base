//
//  MyMailMainViewController.m
//  IDIAI
//
//  Created by Ricky on 16/5/11.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyMailMainViewController.h"
#import "MyMailViewController.h"
#import "AddMailViewController.h"
@interface MyMailMainViewController ()

@end

@implementation MyMailMainViewController

- (void)viewDidLoad {
    
    //一定要放在viewDidLoad之后 huangrun
    self.dataSource = self;
    self.delegate = self;
    
    // Do any additional setup after loading the view.
    
    self.title = @"信箱";
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
    }
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(5, 5, 40, 40)];
    [rightButton setImage:[UIImage imageNamed:@"ic_xieriji.png"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight)
          forControlEvents:UIControlEventTouchUpInside];
    //        rightButton.backgroundColor =[UIColor redColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [super viewDidLoad];
    [self requestNewMessage];
    // Do any additional setup after loading the view.
}
-(void)PressBarItemRight{
    AddMailViewController *addmail =[[AddMailViewController alloc] init];
    [self.navigationController pushViewController:addmail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    //    UIColor *color = kThemeColor;
    //    UIImage *image = [util imageWithColor:color];
    //    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    //    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    //    [delegate.nav setNavigationBarHidden:YES animated:NO];
    
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
}
#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 2;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18.0];
    label.text = [NSString stringWithFormat:@"View %i", index];
    //    if (index == 0) {
    //        label.text = @"全部";
    //    } else if (index == 1) {
    //        label.text = @"设计师";
    //    } else if (index == 2){
    //        label.text = @"工长";
    //    } else {
    //        label.text = @"监理";
    //    }
    if (index == 0) {
        label.text = @"收信箱";
    } else if (index == 1) {
        label.text = @"发信箱";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    //    MyOrderContentViewController *myOrderContentVC = [[MyOrderContentViewController alloc]init];
    MyMailViewController *myMailContentVC =[[MyMailViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:myMailContentVC];
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
        
        myMailContentVC.actionType = 1;
        
        //        [nav.navigationBar setTintColor:[UIColor whiteColor]];
        return nav;
    } else if (index == 1) {
        myMailContentVC.actionType =2;
        
        return nav;
    } else {
//        myMailContentVC.typeInteger = -1;
        
        return nav;
    }
}
#pragma mark - 请求新消息列表
-(void)requestNewMessage{
    //    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token;
        NSString *string_userid;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0367\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"新消息列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==103671) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        [self stopRequest];
                        
                        self.title = [NSString stringWithFormat:@"信箱（%@）",[jsonDict objectForKey:@"mailBoxPrompNum"]];
                    });
                }
                else if (code==103679) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        [self stopRequest];
                        //                        self.mailBoxPrompNum =@"0";
                        //                        self.toadyDaiBanPrompNum =@"0";
                        //                        [_theTableView reloadData];
                    });
                }
                else if (code==101009){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        [self stopRequest];
                        //                        self.mailBoxPrompNum =@"0";
                        //                        self.toadyDaiBanPrompNum =@"0";
                        //                        [_theTableView reloadData];
                    });
                }else if (code ==10002){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        [self stopRequest];
                        //                        self.mailBoxPrompNum =@"0";
                        //                        self.toadyDaiBanPrompNum =@"0";
                        //                        [_theTableView reloadData];
                        //                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        //                        login.delegate=self;
                        //                        [login show];
                        
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  //                                  [self stopRequest];
                                  //                                  [TLToast showWithText:@"系统异常"];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}
#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:{
            return 0;
        }
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        case ViewPagerOptionTabWidth:
            return kMainScreenWidth/2;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
