//
//  IDIAI3AddDiaryViewController.m
//  IDIAI
//
//  Created by PM on 16/7/13.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3AddDiaryViewController.h"
#import "IDIAIAppDelegate.h"
#import "util.h"
#import "WriteDiaryViewController.h"
@interface IDIAI3AddDiaryViewController ()<ViewPagerDataSource,ViewPagerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)WriteDiaryViewController * currentVC;
@property(nonatomic,strong)NSMutableArray * boolArray;//储存返回时检测是否给用户提醒的bool值
@property(nonatomic,assign)NSInteger contentVCNumber;
@end

@implementation IDIAI3AddDiaryViewController

-(void)viewWillAppear:(BOOL)animated{
   
    
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
    if ([self.fromStr isEqualToString:@"IDIAI3DiaryViewController"]) {
        [appDelegate.nav setNavigationBarHidden:YES animated:NO];//zl
    }else {
      [appDelegate.nav setNavigationBarHidden:NO animated:NO];//zl
    }
    
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
//    [self.theBackButton addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.theRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.theRightBtn setTitleColor:mainHeadingColor forState:UIControlStateNormal];
    [self.theRightBtn setTitle:@"发布" forState:UIControlStateNormal];
    self.theRightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.theRightBtn addTarget:self action:@selector(releaseNewDiaryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.theRightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
}

- (void)viewDidLoad {
    //一定要放在viewDidLoad之后 huangrun
    self.dataSource = self;
    self.delegate = self;
    
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"写帖子";
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [super viewDidLoad];
    self.boolArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popViewController) name:@"popToLastViewController" object:@"123"];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(makeSureGoBackDerectlyOrAlerUserBeforeThat:) name:@"alertNotification" object:nil];
    
#warning  //位置不要改变，这需要在调用(UIViewController *)viewPager:(ViewPagerControllerFive *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index 后才有效
    
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
    label.font = [UIFont systemFontOfSize:17.0];
    label.text = [NSString stringWithFormat:@"View %i", index];
    if (index == 0) {
        label.text = @"写帖子";
    } else if (index == 1) {
        label.text = @"提问";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerControllerFive *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    if (index == 0) {
        WriteDiaryViewController * writeDiaryVC = [[WriteDiaryViewController alloc]init];
        UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:writeDiaryVC];
//        if (self.fromStr)
//            writeDiaryVC.fromStr = self.fromStr;
        
        writeDiaryVC.diaryType1 = 1;
        writeDiaryVC.useType = 1;//utop
        return navi;
    } else {
        WriteDiaryViewController * writeDiaryVC = [[WriteDiaryViewController alloc]init];
        UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:writeDiaryVC];
//        if (self.fromStr)
//            writeDiaryVC.fromStr = self.fromStr;
        writeDiaryVC.diaryType1 = 2;
        writeDiaryVC.useType = 1;//utop
        return navi;
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
            break;
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
         NSLog(@"self.content======%@",[self viewControllerAtIndex:index]);
     UINavigationController *  navi   =  (UINavigationController*) [self viewControllerAtIndex:index];
    
    NSArray * viewControllers =navi.viewControllers;
    UIViewController * currrentVC = [viewControllers firstObject];
        if ([currrentVC isKindOfClass:[WriteDiaryViewController class]]) {
            WriteDiaryViewController * writeDiaryVC  = (WriteDiaryViewController*)currrentVC;
            self.currentVC =writeDiaryVC;
        }
}
-(void)makeSureGoBackDerectlyOrAlerUserBeforeThat:(NSNotification*)notity{
    
              self.contentVCNumber=0;
        for (id object in self.contents) {
            if ([object isKindOfClass:[NSNull class]]) {
            }else{
                self.contentVCNumber+=1;
            }
        }
    
    NSDictionary * dict =notity.userInfo;
    NSNumber * boolNumber = dict[@"weatherAlert"];
     NSLog(@"self.content=========%@",self.contents);
        if (self.contentVCNumber==1) {
            BOOL  weatherAlert = [boolNumber boolValue];
            if (weatherAlert==YES) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你的帖子尚在编辑，是否确定返回？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [self.boolArray addObject:boolNumber];
            if (self.boolArray.count==2) {
                BOOL weatherAlert1 =[[self.boolArray firstObject] boolValue];
                BOOL weatherAlert2 =[[self.boolArray  lastObject] boolValue];
                if (weatherAlert1==NO&&weatherAlert2==NO) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你的帖子尚在编辑，是否确定返回？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                }
            }
        }
}


-(void)releaseNewDiaryBtnPressed:(UIButton*)sender{
    sender.enabled = NO;
    [self.currentVC releaseNewDiary:sender];

}
- (void)backButtonPressed:(id)sender{
    if (self.boolArray.count!=0) {
        [self.boolArray removeAllObjects];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"goBackCheck" object:nil userInfo:@{@"sender":@[sender]}];
}

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark -UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}




@end
