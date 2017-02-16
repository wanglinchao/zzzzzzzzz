//
//  DesignerHostViewController.m
//  IDIAI
//
//  Created by iMac on 15-3-18.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DesignerHostViewController.h"
#import "util.h"
#import "TLToast.h"
#import "IDIAIAppDelegate.h"
#import "DesignerViewController.h"
#import "SearchSCXViewController.h"
#import "MyeffectypictureVC.h"
#import "HRCoreAnimationEffect.h"
#import "SearchListCell.h"


#define KHISTORY_SS_DESIGNER @"MyHistory_designer.plist"
#define KHISTORY_SS_CASEOGTAOTU @"MyHistory_caseOfTaotu.plist"

#define KStyleBtn_Tag 1100
#define KHuXingBtn_Tag 1200
#define KBaoJiaBtn_Tag 1300
#define KChengShiBtn_Tag 1400
#define KKongJianBtn_Tag 1500
#define KJingYanBtn_Tag 1600
#define KDengJiBtn_Tag 1700
#define KRenZhengBtn_Tag 1800
#define KPriceTF_Tag 1900
@interface DesignerHostViewController ()<ViewPagerDataSource,ViewPagerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)NSInteger oldcontrol;
@property(nonatomic,assign)BOOL isshow;
@end

@implementation DesignerHostViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:kColorWithRGB(249, 249, 250)];

    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
    appDelegate.nav.navigationBar.hidden = NO;
    
    //修改navBar字体大小文字颜色
    NSDictionary *attris = @{ NSFontAttributeName:[UIFont systemFontOfSize:19],
                              NSForegroundColorAttributeName:[UIColor whiteColor] };
    [self.navigationController.navigationBar setTitleTextAttributes:attris];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if(self.isShowSearchBar==YES) view_search_bg.hidden=NO;
    else view_search_bg.hidden=YES;
}

-(void)setIselect:(BOOL)iselect{
    [super setIselect:iselect];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"EffectypictureData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    view_search_bg.hidden=YES;
    mtableview_sub.hidden=YES;
}

- (void)viewDidLoad {
    self.picture_style =-1;
    self.picture_doorModel =-1;
    self.picture_price =-1;
    self.picture_city =-1;
    self.picture_kongjian =-1;
    self.picture_experience =-1;
    self.picture_level =-1;
    self.picture_aut =-1;
    self.priceMin=@"";
    self.priceMax=@"";
    // Do any additional setup after loading the view.
    self.dataSource = self;
    self.delegate = self;
    self.isshow =NO;
    
    self.title = @"选设计师";
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"案例",@"设计师",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0, 0, 90, 25);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor lightGrayColor];
    segmentedControl.layer.cornerRadius=12.5;
    segmentedControl.layer.masksToBounds=YES;
    segmentedControl.layer.borderWidth=1.0;
    segmentedControl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    self.navigationItem.titleView=segmentedControl;
    //导航右按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(5, 5, 40, 40)];
    [rightButton setImage:[UIImage imageNamed:@"ic_ss_2.png"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
//    self.iselect =YES;
    
    [super viewDidLoad];//一定要放在最后 不然有问题 huangrun
    
    UIButton *showbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    int dance =0;
    if (self.iselect==YES) {
        dance =8;
    }
    showbtn.frame =CGRectMake(kMainScreenWidth/4*3-dance, 0, kMainScreenWidth/4+dance, 44);
    showbtn.backgroundColor =[UIColor whiteColor];
    [showbtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label =[[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:16.0];
    label.text = @"筛选";
    label.frame =CGRectMake(0, (showbtn.frame.size.height-15)/2, 36, 15);
    [showbtn addSubview:label];
    UIImageView *image =[[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, 18, 8, 8)];
    image.image =[UIImage imageNamed:@"ic_shaixuan_n.png"];
    [showbtn addSubview:image];
    [self.tabsView addSubview:showbtn];
    
    if (self.iselect ==YES) {
        for (UINavigationController *nav in self.contents) {
            if ([nav isKindOfClass:[UINavigationController class]]) {
                DesignerViewController *gongzhangtuanVC =[nav.viewControllers objectAtIndex:0];
                gongzhangtuanVC.picture_style =self.picture_style;
                gongzhangtuanVC.picture_kongjian =self.picture_kongjian;
                gongzhangtuanVC.picture_experience =self.picture_experience;
                gongzhangtuanVC.picture_city =self.picture_city;
                gongzhangtuanVC.picture_level =self.picture_level;
                gongzhangtuanVC.picture_aut =self.picture_aut;
                [gongzhangtuanVC.mtableview launchRefreshing];
            }
        }
    }else{
        for (UINavigationController *nav in self.contents) {
            if ([nav isKindOfClass:[UINavigationController class]]) {
                MyeffectypictureVC *gongzhangtuanVC =[nav.viewControllers objectAtIndex:0];
                gongzhangtuanVC.picture_style =self.picture_style;
                gongzhangtuanVC.picture_doorModel =self.picture_doorModel;
                gongzhangtuanVC.picture_price =self.picture_price;
                gongzhangtuanVC.picture_city =self.picture_city;
                [gongzhangtuanVC refreshView];
            }
        }
    }
    
    
    [self createSearchView];   //创建搜索页
}

-(void)PressBarItemRight{
    [_control removeFromSuperview];
    _control=nil;
    [_dv removeFromSuperview];
    _dv=nil;
    
//    SearchSCXViewController *searchvc=[[SearchSCXViewController alloc]init];
//    [self.navigationController pushViewController:searchvc animated:YES];
    
    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path_ = [path_ objectAtIndex:0];
    NSString* _filename_;
    if (self.iselect ==YES)
        _filename_ = [doc_path_ stringByAppendingPathComponent:KHISTORY_SS_DESIGNER];
    else
        _filename_ = [doc_path_ stringByAppendingPathComponent:KHISTORY_SS_CASEOGTAOTU];
    _dataArray_history=[NSMutableArray arrayWithContentsOfFile:_filename_];
    if (!_dataArray_history) {
        _dataArray_history=[NSMutableArray arrayWithCapacity:0];
    }
    if([_dataArray_history count]>15) [_dataArray_history removeObjectsInRange:NSMakeRange(15, [_dataArray_history count]-15)];
    
    view_search_bg.hidden=NO;
    mtableview_sub.hidden=NO;
    [searchBar becomeFirstResponder];
}
-(void)segmentAction:(UISegmentedControl *)Seg{
    [_control removeFromSuperview];
    _control=nil;
    [_dv removeFromSuperview];
    _dv=nil;
    
    int count =0;
    self.picture_style =-1;
    self.picture_doorModel =-1;
    self.picture_price =-1;
    self.picture_city =-1;
    self.picture_kongjian =-1;
    self.picture_experience =-1;
    self.picture_level =-1;
    self.picture_aut =-1;
    self.priceMin=@"";
    self.priceMax=@"";
    if (Seg.selectedSegmentIndex==0) {
        self.iselect =NO;
        [self reloadData];
        count =4;
    }else{
        self.iselect =YES;
        [self reloadData];
        count =5;
    }
    int dance =0;
    if (self.iselect==YES) {
        dance =8*kMainScreenWidth/320;
    }
    UIButton *showbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    showbtn.frame =CGRectMake(kMainScreenWidth/count*(count-1)-dance, 0, kMainScreenWidth/count+dance, 44);
    showbtn.backgroundColor =[UIColor whiteColor];
    [showbtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label =[[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:16.0];
    label.text = @"筛选";
    label.frame =CGRectMake(0, (showbtn.frame.size.height-15)/2, 36, 15);
    [showbtn addSubview:label];
    UIImageView *image =[[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, 18, 8, 8)];
    image.image =[UIImage imageNamed:@"ic_shaixuan_n.png"];
    [showbtn addSubview:image];
    [self.tabsView addSubview:showbtn];
    
    if (self.iselect ==YES) {
        for (UINavigationController *nav in self.contents) {
            if ([nav isKindOfClass:[UINavigationController class]]) {
                DesignerViewController *gongzhangtuanVC =[nav.viewControllers objectAtIndex:0];
                gongzhangtuanVC.picture_style =self.picture_style;
                gongzhangtuanVC.picture_kongjian =self.picture_kongjian;
                gongzhangtuanVC.picture_experience =self.picture_experience;
                gongzhangtuanVC.picture_city =self.picture_city;
                gongzhangtuanVC.picture_level =self.picture_level;
                gongzhangtuanVC.picture_aut =self.picture_aut;
                [gongzhangtuanVC.mtableview launchRefreshing];
            }
        }
    }else{
        for (UINavigationController *nav in self.contents) {
            if ([nav isKindOfClass:[UINavigationController class]]) {
                MyeffectypictureVC *gongzhangtuanVC =[nav.viewControllers objectAtIndex:0];
                gongzhangtuanVC.picture_style =self.picture_style;
                gongzhangtuanVC.picture_doorModel =self.picture_doorModel;
                gongzhangtuanVC.picture_price =self.picture_price;
                gongzhangtuanVC.picture_city =self.picture_city;
                [gongzhangtuanVC refreshView];
            }
        }
    }
    
}
#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerControllerSecond *)viewPager {
    if (self.iselect ==NO) {
         return 3;
    }else{
       return 4;
    }
    
}

- (UIView *)viewPager:(ViewPagerControllerSecond *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.0];
    label.text = [NSString stringWithFormat:@"View %u", (unsigned)index];
    if (self.iselect ==NO) {
        if (index == 0) {
            label.text = @"最新";
        } else if (index == 1) {
            label.text = @"收藏";
        } else if (index == 2){
            label.text = @"浏览";
        }
//        if (index ==3) {
//            UIView *view =[UIView new];
//            view.backgroundColor =[UIColor clearColor];
//            label.frame =CGRectMake((view.frame.size.width-30)/2, (view.frame.size.height-15)/2, 30, 15);
//            [view addSubview:label];
//            UIImageView *image =[[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, -4, 8, 8)];
//            image.image =[UIImage imageNamed:@"ic_shaixuan_n.png"];
//            [view addSubview:image];
//            return view;
//        }
    }else{
        if (index == 0) {
            label.text = @"口碑";
        } else if (index == 1) {
            label.text = @"预约";
        } else if (index == 2){
            label.text = @"浏览";
        }else if (index ==3){
            label.text = @"收藏";
        }
        if (index ==4) {
            UIView *view =[UIView new];
            view.backgroundColor =[UIColor clearColor];
            label.frame =CGRectMake((view.frame.size.width-30)/2, (view.frame.size.height-15)/2, 30, 15);
            [view addSubview:label];
            UIImageView *image =[[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, 10, 8, 8)];
            image.image =[UIImage imageNamed:@"ic_shaixuan_n.png"];
            [view addSubview:image];
            return view;
        }
    }
    
//    } else {
//        label.text = @"墙绘";
//    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerControllerSecond *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (self.iselect ==NO) {
        MyeffectypictureVC *effectVC=[[MyeffectypictureVC alloc]init];
        effectVC.picture_type=@"taotu";
        effectVC.selected_mark=index+3;
        effectVC.picture_style =self.picture_style;
        effectVC.picture_doorModel =self.picture_doorModel;
        effectVC.picture_price =self.picture_price;
        effectVC.picture_city =self.picture_city;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:effectVC];
        return nav;
    }else{
        DesignerViewController *desigervc = [[DesignerViewController alloc]init];
        desigervc.selected_mark=index+1;
        desigervc.picture_style =self.picture_style;
        desigervc.picture_kongjian =self.picture_kongjian;
        desigervc.picture_experience =self.picture_experience;
        desigervc.picture_city =self.picture_city;
        desigervc.picture_level =self.picture_level;
        desigervc.picture_aut =self.picture_aut;
        desigervc.priceMin_ =self.priceMin;
        desigervc.priceMax_ =self.priceMax;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:desigervc];
        return nav;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerControllerSecond *)viewPager valueForOption:(ViewPagerOption_)option withDefault:(CGFloat)value {
    
    if (self.iselect ==NO) {
        switch (option) {
            case ViewPagerOptionStartFromSecondTab_:
                return 0.0;
                break;
            case ViewPagerOptionCenterCurrentTab_:
                return 0.0;
                break;
            case ViewPagerOptionTabLocation_:
                return 1.0;
                break;
            case ViewPagerOptionTabWidth_:
            {
                if(kMainScreenWidth<=320) return kMainScreenWidth/4.0;
                else return kMainScreenWidth/4.001;
            }  //如果是iPhone 6 以下写4 在背景不是白色的情况下 会出现细线
                break;
            default:
                break;
        }
    }else{
        switch (option) {
            case ViewPagerOptionStartFromSecondTab_:
                return 0.0;
                break;
            case ViewPagerOptionCenterCurrentTab_:
                return 0.0;
                break;
            case ViewPagerOptionTabLocation_:
                return 1.0;
                break;
            case ViewPagerOptionTabWidth_:
            {
                if(kMainScreenWidth<=320) return kMainScreenWidth/5.0;
                else return kMainScreenWidth/5.001;
            }  //如果是iPhone 6 以下写4 在背景不是白色的情况下 会出现细线
                break;
            default:
                break;
        }
    }
    
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerControllerSecond *)viewPager colorForComponent:(ViewPagerComponent_)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator_:
            return [UIColor whiteColor];//kThemeColor;
//            return [UIColor colorWithHexString:@"#F0B236" alpha:1.0];
            break;
        default:
            break;
    }
    
    return color;
}

- (void)viewPager:(ViewPagerControllerSecond *)viewPager didChangeTabToIndex:(NSUInteger)index {
    
}

- (void)clickNavRightBtn:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:kNCShowEffectyPicType object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)PressBarItemLeft {
    if (self.isshow ==NO) {
        [searchBar resignFirstResponder];
        UIColor *color = [UIColor whiteColor];
        UIImage *image = [util imageWithColor:color];
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage=[util imageWithColor:[UIColor colorWithHexString:@"#E0E0E0" alpha:1.0]];
        [self dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismiss];
    }
    
}
#pragma mark - 选择风格

- (void)show {
    if(_control) {
        [self dismiss];
        return;
    }
    self.isshow =YES;
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if(!_control)_control = [[UIControl alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kMainScreenHeight - 80, kMainScreenHeight - kTabBarHeight)];
    _control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
    [_control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [keywindow addSubview:_control];
    
    //    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(80, kNavigationBarHeight+0.5, kMainScreenWidth - 80, kMainScreenHeight - kNavigationBarHeight)];
    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+0.5, kMainScreenWidth , kMainScreenHeight - kNavigationBarHeight)];
    _dv.tag=101;
    _dv.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    if (self.iselect ==YES) {
        _dataArr = @[@[@"不限",@"现代简约",@"田园",@"欧式",@"中式",@"美式",@"地中海",@"东南亚",@"混搭",@"新古典",@"日式"],@[@"不限",@"住宅",@"别墅",@"办公室",@"酒店",@"样板间",@"商业空间"],@[@"不限",@"1~3年",@"3~5年",@"5~10年",@"10~20年",@"20年以上"],@[@"同城",@"全国"],@[@"不限",@"新锐设计师",@"优秀设计师",@"精英设计师"],@[@"不限",@"实名"]];
    }else{
        _dataArr = @[@[@"不限",@"现代简约",@"田园",@"欧式",@"中式",@"美式",@"地中海",@"东南亚",@"混搭",@"新古典",@"日式"],@[@"不限",@"小户型(<70㎡)",@"普通户型(70-120㎡)",@"大户型(>120㎡)"],@[@"不限",@"经济方案(<100元/㎡)",@"品质方案(100-200元/㎡)",@"奢华方案(>200元/㎡)"],@[@"同城",@"全国"]];
    }
    
    [keywindow addSubview:_dv];
    [self createChioces];
    
    [HRCoreAnimationEffect animationPushRight:_dv];
}
-(void)createChioces{
    _scr=[[UIScrollView alloc] init];
    _scr.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    [_dv addSubview:_scr];
    float width_=(kMainScreenWidth-40-60)/3;
    float heigth_=32;
    float space=0;
    if (self.iselect ==YES) {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        tap.numberOfTapsRequired=1;
        tap.numberOfTouchesRequired=1;
        [_scr addGestureRecognizer:tap];
        
        UILabel *style_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
        style_lab.backgroundColor=[UIColor clearColor];
        style_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
        style_lab.font=[UIFont boldSystemFontOfSize:18];
        style_lab.text=@"风格";
        [_scr addSubview:style_lab];
        for (int i=0; i<[[_dataArr firstObject] count]; i++) {
            UIButton *btn_style=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), CGRectGetMaxY(style_lab.frame)+10+(i/3)*(heigth_+15), width_, heigth_)];
            btn_style.tag=KStyleBtn_Tag+i;
            [btn_style setTitle:[[_dataArr firstObject] objectAtIndex:i] forState:UIControlStateNormal];
            [btn_style setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
            [btn_style setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
            btn_style.titleLabel.font=[UIFont systemFontOfSize:16];
            if(i==0 && self.picture_style==-1) btn_style.selected=YES;
            else if(i==self.picture_style && i!=0) btn_style.selected=YES;
            //给按钮加一个红色的板框
            if(btn_style.selected==YES) btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            else btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn_style.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            btn_style.layer.cornerRadius = 5.0f;
            btn_style.layer.masksToBounds = YES;
            [btn_style addTarget:self action:@selector(ChoiceStyle:) forControlEvents:UIControlEventTouchUpInside];
            [_scr addSubview:btn_style];
            
            if(i==[[_dataArr firstObject] count]-1) space=CGRectGetMaxY(btn_style.frame);
        }
        
        UILabel *huxing_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, space+20, 100, 20)];
        huxing_lab.backgroundColor=[UIColor clearColor];
        huxing_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
        huxing_lab.font=[UIFont boldSystemFontOfSize:18];
        huxing_lab.text=@"擅长空间";
        [_scr addSubview:huxing_lab];
        space=CGRectGetMaxY(huxing_lab.frame);
        for (int i=0; i<[[_dataArr objectAtIndex:1] count]; i++) {
            UIButton *btn_huxing=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), space+10+(i/3)*(heigth_+15), width_, heigth_)];
            btn_huxing.tag=KKongJianBtn_Tag+i;
            [btn_huxing setTitle:[[_dataArr objectAtIndex:1] objectAtIndex:i] forState:UIControlStateNormal];
            [btn_huxing setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
            [btn_huxing setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
            btn_huxing.titleLabel.font=[UIFont systemFontOfSize:16];
            if(i==0 && self.picture_kongjian==-1) btn_huxing.selected=YES;
            else if(i==self.picture_kongjian-17 && i!=0) btn_huxing.selected=YES;
            //给按钮加一个红色的板框
            if(btn_huxing.selected==YES) btn_huxing.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            else btn_huxing.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn_huxing.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            btn_huxing.layer.cornerRadius = 5.0f;
            btn_huxing.layer.masksToBounds = YES;
            [btn_huxing addTarget:self action:@selector(ChoiceKongjian:) forControlEvents:UIControlEventTouchUpInside];
            [_scr addSubview:btn_huxing];
            
            if(i==[[_dataArr objectAtIndex:1] count]-1) space=CGRectGetMaxY(btn_huxing.frame);
        }
        
        UILabel *baojia_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, space+20, 100, 20)];
        baojia_lab.backgroundColor=[UIColor clearColor];
        baojia_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
        baojia_lab.font=[UIFont boldSystemFontOfSize:18];
        baojia_lab.text=@"经验";
        [_scr addSubview:baojia_lab];
        space=CGRectGetMaxY(baojia_lab.frame);
        for (int i=0; i<[[_dataArr objectAtIndex:2] count]; i++) {
            UIButton *btn_baojia=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), space+10+(i/3)*(heigth_+15), width_, heigth_)];
            btn_baojia.tag=KJingYanBtn_Tag+i;
            [btn_baojia setTitle:[[_dataArr objectAtIndex:2] objectAtIndex:i] forState:UIControlStateNormal];
            [btn_baojia setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
            [btn_baojia setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
            btn_baojia.titleLabel.font=[UIFont systemFontOfSize:13];
            if(i==0 && self.picture_experience==-1) btn_baojia.selected=YES;
            else if(i==self.picture_experience-1 && i!=0) btn_baojia.selected=YES;
            //给按钮加一个红色的板框
            if(btn_baojia.selected==YES) btn_baojia.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            else btn_baojia.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn_baojia.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            btn_baojia.layer.cornerRadius = 5.0f;
            btn_baojia.layer.masksToBounds = YES;
            [btn_baojia addTarget:self action:@selector(ChoiceJingYan:) forControlEvents:UIControlEventTouchUpInside];
            [_scr addSubview:btn_baojia];
            
            if(i==[[_dataArr objectAtIndex:2] count]-1) space=CGRectGetMaxY(btn_baojia.frame);
        }
        
        UILabel *chengshi_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, space+20, 100, 20)];
        chengshi_lab.backgroundColor=[UIColor clearColor];
        chengshi_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
        chengshi_lab.font=[UIFont boldSystemFontOfSize:18];
        chengshi_lab.text=@"城市";
        [_scr addSubview:chengshi_lab];
        width_=(kMainScreenWidth-40-60)/3;
        space=CGRectGetMaxY(chengshi_lab.frame);
        for (int i=0; i<[[_dataArr objectAtIndex:3] count]; i++) {
            UIButton *btn_chengshi=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), space+10+(i/3)*(heigth_+15), width_, heigth_)];
            btn_chengshi.tag=KChengShiBtn_Tag+i;
            [btn_chengshi setTitle:[[_dataArr objectAtIndex:3] objectAtIndex:i] forState:UIControlStateNormal];
            [btn_chengshi setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
            [btn_chengshi setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
            btn_chengshi.titleLabel.font=[UIFont systemFontOfSize:13];
            if(i==0 && self.picture_city==-1) btn_chengshi.selected=YES;
            else if(self.picture_city!=-1 && i!=0) btn_chengshi.selected=YES;
            //给按钮加一个红色的板框
            if(btn_chengshi.selected==YES) btn_chengshi.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            else btn_chengshi.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn_chengshi.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            btn_chengshi.layer.cornerRadius = 5.0f;
            btn_chengshi.layer.masksToBounds = YES;
            [btn_chengshi addTarget:self action:@selector(ChoiceChengShi:) forControlEvents:UIControlEventTouchUpInside];
            [_scr addSubview:btn_chengshi];
            
            if(i==[[_dataArr objectAtIndex:3] count]-1) space=CGRectGetMaxY(btn_chengshi.frame);
        }
        
        UILabel *dengji_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, space+20, 100, 20)];
        dengji_lab.backgroundColor=[UIColor clearColor];
        dengji_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
        dengji_lab.font=[UIFont boldSystemFontOfSize:18];
        dengji_lab.text=@"等级";
        [_scr addSubview:dengji_lab];
        width_=(kMainScreenWidth-40-60)/3;
        space=CGRectGetMaxY(dengji_lab.frame);
        for (int i=0; i<[[_dataArr objectAtIndex:4] count]; i++) {
            UIButton *btn_dengji=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), space+10+(i/3)*(heigth_+15), width_, heigth_)];
            btn_dengji.tag=KDengJiBtn_Tag+i;
            [btn_dengji setTitle:[[_dataArr objectAtIndex:4] objectAtIndex:i] forState:UIControlStateNormal];
            [btn_dengji setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
            [btn_dengji setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
            btn_dengji.titleLabel.font=[UIFont systemFontOfSize:13];
            if(i==0 && self.picture_level==-1) btn_dengji.selected=YES;
            else if(i==self.picture_level && i!=0) btn_dengji.selected=YES;
            //给按钮加一个红色的板框
            if(btn_dengji.selected==YES) btn_dengji.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            else btn_dengji.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn_dengji.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            btn_dengji.layer.cornerRadius = 5.0f;
            btn_dengji.layer.masksToBounds = YES;
            [btn_dengji addTarget:self action:@selector(ChoiceDengJi:) forControlEvents:UIControlEventTouchUpInside];
            [_scr addSubview:btn_dengji];
            
            if(i==[[_dataArr objectAtIndex:4] count]-1) space=CGRectGetMaxY(btn_dengji.frame);
        }
        
        UILabel *renzheng_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, space+20, 100, 20)];
        renzheng_lab.backgroundColor=[UIColor clearColor];
        renzheng_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
        renzheng_lab.font=[UIFont boldSystemFontOfSize:18];
        renzheng_lab.text=@"认证";
        [_scr addSubview:renzheng_lab];
        width_=(kMainScreenWidth-40-60)/3;
        space=CGRectGetMaxY(renzheng_lab.frame);
        for (int i=0; i<[[_dataArr lastObject] count]; i++) {
            UIButton *btn_renzheng=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), space+10+(i/3)*(heigth_+15), width_, heigth_)];
            btn_renzheng.tag=KRenZhengBtn_Tag+i;
            [btn_renzheng setTitle:[[_dataArr lastObject] objectAtIndex:i] forState:UIControlStateNormal];
            [btn_renzheng setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
            [btn_renzheng setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
            btn_renzheng.titleLabel.font=[UIFont systemFontOfSize:13];
            if(i==0 && self.picture_aut==-1) btn_renzheng.selected=YES;
            else if(self.picture_aut==8 && i!=0) btn_renzheng.selected=YES;
            //给按钮加一个红色的板框
            if(btn_renzheng.selected==YES) btn_renzheng.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            else btn_renzheng.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn_renzheng.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            btn_renzheng.layer.cornerRadius = 5.0f;
            btn_renzheng.layer.masksToBounds = YES;
            [btn_renzheng addTarget:self action:@selector(ChoiceRenZheng:) forControlEvents:UIControlEventTouchUpInside];
            [_scr addSubview:btn_renzheng];
            
            if(i==[[_dataArr lastObject] count]-1) space=CGRectGetMaxY(btn_renzheng.frame);
        }
        
        UILabel *price_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, space+20, 100, 20)];
        price_lab.backgroundColor=[UIColor clearColor];
        price_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
        price_lab.font=[UIFont boldSystemFontOfSize:18];
        price_lab.text=@"报价";
        [_scr addSubview:price_lab];
        width_=(kMainScreenWidth-40-60)/3;
        space=CGRectGetMaxY(price_lab.frame);
        for (int i=0; i<2; i++) {
            UITextField *tf_=[[UITextField alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), space+10+(i/3)*(heigth_+15), width_, heigth_)];
            tf_.tag=KPriceTF_Tag+i;
            tf_.delegate=self;
            tf_.borderStyle=UITextBorderStyleRoundedRect;
            tf_.layer.cornerRadius=5;
            tf_.layer.masksToBounds=YES;
            tf_.layer.borderWidth=1.0;
            tf_.layer.borderColor=[UIColor colorWithHexString:@"#D2D2D5" alpha:1.0].CGColor;
            tf_.backgroundColor=[UIColor colorWithHexString:@"#F1F0F6" alpha:1.0];
            tf_.keyboardType=UIKeyboardTypeNumberPad;
            tf_.returnKeyType=UIReturnKeyDone;
            tf_.font=[UIFont systemFontOfSize:13];
            tf_.textColor=[UIColor darkGrayColor];
            if(i==0) tf_.text=self.priceMin;
            else if (i==1) tf_.text=self.priceMax;
            [_scr addSubview:tf_];
            
            if(i==1){
                space=CGRectGetMaxY(tf_.frame);
                
                UIView *line=[[UIView alloc]initWithFrame:CGRectMake(20+width_+5, CGRectGetMidY(tf_.frame)-1, 20, 2.0)];
                line.backgroundColor=[UIColor colorWithHexString:@"#ADADB0" alpha:0.5];
                [_scr addSubview:line];
                
                UILabel *danwei=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tf_.frame)+10, CGRectGetMinY(tf_.frame), 60, 32)];
                danwei.backgroundColor=[UIColor clearColor];
                danwei.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
                danwei.font=[UIFont systemFontOfSize:16];
                danwei.text=@"元/m²";
                [_scr addSubview:danwei];
            }
        }

    }else{
        UILabel *style_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
        style_lab.backgroundColor=[UIColor clearColor];
        style_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
        style_lab.font=[UIFont boldSystemFontOfSize:18];
        style_lab.text=@"风格";
        [_scr addSubview:style_lab];
        
        for (int i=0; i<[[_dataArr firstObject] count]; i++) {
            UIButton *btn_style=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), CGRectGetMaxY(style_lab.frame)+10+(i/3)*(heigth_+15), width_, heigth_)];
            btn_style.tag=KStyleBtn_Tag+i;
            [btn_style setTitle:[[_dataArr firstObject] objectAtIndex:i] forState:UIControlStateNormal];
            [btn_style setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
            [btn_style setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
            btn_style.titleLabel.font=[UIFont systemFontOfSize:16];
            if(i==0 && self.picture_style==-1) btn_style.selected=YES;
            else if(i==self.picture_style && i!=0) btn_style.selected=YES;
            //给按钮加一个红色的板框
            if(btn_style.selected==YES) btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            else btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn_style.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            btn_style.layer.cornerRadius = 5.0f;
            btn_style.layer.masksToBounds = YES;
            [btn_style addTarget:self action:@selector(ChoiceStyle:) forControlEvents:UIControlEventTouchUpInside];
            [_scr addSubview:btn_style];
            
            if(i==[[_dataArr firstObject] count]-1) space=CGRectGetMaxY(btn_style.frame);
        }
        
        UILabel *huxing_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, space+20, 100, 20)];
        huxing_lab.backgroundColor=[UIColor clearColor];
        huxing_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
        huxing_lab.font=[UIFont boldSystemFontOfSize:18];
        huxing_lab.text=@"户型";
        [_scr addSubview:huxing_lab];
        width_=(kMainScreenWidth-40-30)/2;
        space=CGRectGetMaxY(huxing_lab.frame);
        for (int i=0; i<[[_dataArr objectAtIndex:1] count]; i++) {
            UIButton *btn_huxing=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%2), space+10+(i/2)*(heigth_+15), width_, heigth_)];
            btn_huxing.tag=KHuXingBtn_Tag+i;
            [btn_huxing setTitle:[[_dataArr objectAtIndex:1] objectAtIndex:i] forState:UIControlStateNormal];
            [btn_huxing setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
            [btn_huxing setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
            btn_huxing.titleLabel.font=[UIFont systemFontOfSize:15];
            if(i==0 && self.picture_doorModel==-1) btn_huxing.selected=YES;
            else if(i==self.picture_doorModel-11 && i!=0) btn_huxing.selected=YES;
            //给按钮加一个红色的板框
            if(btn_huxing.selected==YES) btn_huxing.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            else btn_huxing.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn_huxing.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            btn_huxing.layer.cornerRadius = 5.0f;
            btn_huxing.layer.masksToBounds = YES;
            [btn_huxing addTarget:self action:@selector(ChoiceHuXing:) forControlEvents:UIControlEventTouchUpInside];
            [_scr addSubview:btn_huxing];
            
            if(i==[[_dataArr objectAtIndex:1] count]-1) space=CGRectGetMaxY(btn_huxing.frame);
        }
        
        UILabel *baojia_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, space+20, 100, 20)];
        baojia_lab.backgroundColor=[UIColor clearColor];
        baojia_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
        baojia_lab.font=[UIFont boldSystemFontOfSize:18];
        baojia_lab.text=@"报价";
        [_scr addSubview:baojia_lab];
        width_=(kMainScreenWidth-40-30)/2;
        space=CGRectGetMaxY(baojia_lab.frame);
        for (int i=0; i<[[_dataArr objectAtIndex:2] count]; i++) {
            UIButton *btn_baojia=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%2), space+10+(i/2)*(heigth_+15), width_, heigth_)];
            btn_baojia.tag=KBaoJiaBtn_Tag+i;
            [btn_baojia setTitle:[[_dataArr objectAtIndex:2] objectAtIndex:i] forState:UIControlStateNormal];
            [btn_baojia setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
            [btn_baojia setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
            btn_baojia.titleLabel.font=[UIFont systemFontOfSize:13];
            if(i==0 && self.picture_price==-1) btn_baojia.selected=YES;
            else if(i==self.picture_price-14 && i!=0) btn_baojia.selected=YES;
            //给按钮加一个红色的板框
            if(btn_baojia.selected==YES) btn_baojia.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            else btn_baojia.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn_baojia.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            btn_baojia.layer.cornerRadius = 5.0f;
            btn_baojia.layer.masksToBounds = YES;
            [btn_baojia addTarget:self action:@selector(ChoiceBaoJia:) forControlEvents:UIControlEventTouchUpInside];
            [_scr addSubview:btn_baojia];
            
            if(i==[[_dataArr objectAtIndex:2] count]-1) space=CGRectGetMaxY(btn_baojia.frame);
        }
        
        UILabel *chengshi_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, space+20, 100, 20)];
        chengshi_lab.backgroundColor=[UIColor clearColor];
        chengshi_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
        chengshi_lab.font=[UIFont boldSystemFontOfSize:18];
        chengshi_lab.text=@"城市";
        [_scr addSubview:chengshi_lab];
        width_=(kMainScreenWidth-40-60)/3;
        space=CGRectGetMaxY(chengshi_lab.frame);
        for (int i=0; i<[[_dataArr lastObject] count]; i++) {
            UIButton *btn_chengshi=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), space+10+(i/3)*(heigth_+15), width_, heigth_)];
            btn_chengshi.tag=KChengShiBtn_Tag+i;
            [btn_chengshi setTitle:[[_dataArr lastObject] objectAtIndex:i] forState:UIControlStateNormal];
            [btn_chengshi setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
            [btn_chengshi setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
            btn_chengshi.titleLabel.font=[UIFont systemFontOfSize:13];
            if(i==0 && self.picture_city==-1) btn_chengshi.selected=YES;
            else if(i!=0&&self.picture_city!=-1) btn_chengshi.selected=YES;
            //给按钮加一个红色的板框
            if(btn_chengshi.selected==YES) btn_chengshi.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            else btn_chengshi.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn_chengshi.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            btn_chengshi.layer.cornerRadius = 5.0f;
            btn_chengshi.layer.masksToBounds = YES;
            [btn_chengshi addTarget:self action:@selector(ChoiceChengShi:) forControlEvents:UIControlEventTouchUpInside];
            [_scr addSubview:btn_chengshi];
            
            if(i==[[_dataArr lastObject] count]-1) space=CGRectGetMaxY(btn_chengshi.frame);
        }
    }
    
    
    _scr.frame=CGRectMake(0, 0, CGRectGetWidth(_dv.frame), CGRectGetHeight(_dv.frame)-kMainScreenWidth/8);
    _scr.contentSize=CGSizeMake(CGRectGetWidth(_scr.frame), space+30);
    
    UIButton *finished_Choice=[[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_scr.frame),kMainScreenWidth,kMainScreenWidth/8)];
    [finished_Choice setTitle:@"确定" forState:UIControlStateNormal];
    [finished_Choice setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateNormal];
    finished_Choice.titleLabel.font=[UIFont systemFontOfSize:16];
    finished_Choice.backgroundColor=[UIColor colorWithHexString:@"#E5E5E5" alpha:0.8];
    [finished_Choice addTarget:self action:@selector(ChoiceFinished) forControlEvents:UIControlEventTouchUpInside];
    [_dv addSubview:finished_Choice];
}
-(void)dismiss{
    [_control removeFromSuperview];
    _control=nil;
    self.isshow =NO;
    //_dv.frame=CGRectMake(80, kNavigationBarHeight+0.5, kMainScreenWidth - 80, kMainScreenHeight - kNavigationBarHeight);
    _dv.frame=CGRectMake(0, kNavigationBarHeight+0.5, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight);
    [UIView animateWithDuration:.25 animations:^{
        //        _dv.frame=CGRectMake(kMainScreenWidth, kNavigationBarHeight+0.5, kMainScreenWidth - 80, kMainScreenHeight - kNavigationBarHeight);
        _dv.frame=CGRectMake(kMainScreenWidth, kNavigationBarHeight+0.5, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight);
    } completion:^(BOOL finished) {
        if (finished) {
            [_dv removeFromSuperview];
            _dv=nil;
        }
    }];
}
-(void)ChoiceStyle:(UIButton *)sender{
    //风格id：-1和1-11
    if (self.iselect ==YES) {
        for (int i=0; i<[[_dataArr firstObject] count]; i++) {
            UIButton *btn=(UIButton *)[_dv viewWithTag:KStyleBtn_Tag+i];
            if(sender.tag==btn.tag){
                btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
                btn.selected=YES;
            }
            else{
                btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
                btn.selected=NO;
            }
        }
    }else{
        for (int i=0; i<[[_dataArr firstObject] count]; i++) {
            UIButton *btn=(UIButton *)[_dv viewWithTag:KStyleBtn_Tag+i];
            if(sender.tag==btn.tag){
                btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
                btn.selected=YES;
            }
            else{
                btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
                btn.selected=NO;
            }
        }
    }
    
}
-(void)ChoiceHuXing:(UIButton *)sender{
    //户型id：-1和1-11
    for (int i=0; i<[[_dataArr objectAtIndex:1] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KHuXingBtn_Tag+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
}
-(void)ChoiceBaoJia:(UIButton *)sender{
    //户型id：-1和1-11
    for (int i=0; i<[[_dataArr objectAtIndex:2] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KBaoJiaBtn_Tag+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
}
-(void)ChoiceChengShi:(UIButton *)sender{
    //户型id：-1和1-11
    for (int i=0; i<[[_dataArr objectAtIndex:3] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KChengShiBtn_Tag+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
}
-(void)ChoiceKongjian:(UIButton *)sender{
    //户型id：-1和1-11
    for (int i=0; i<[[_dataArr objectAtIndex:1] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KKongJianBtn_Tag+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
}
-(void)ChoiceJingYan:(UIButton *)sender{
    //户型id：-1和1-11
    for (int i=0; i<[[_dataArr objectAtIndex:2] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KJingYanBtn_Tag+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
}
-(void)ChoiceDengJi:(UIButton *)sender{
    //户型id：-1和1-11
    for (int i=0; i<[[_dataArr objectAtIndex:4] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KDengJiBtn_Tag+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
}
-(void)ChoiceRenZheng:(UIButton *)sender{
    //户型id：-1和1-11
    for (int i=0; i<[[_dataArr objectAtIndex:5] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KRenZhengBtn_Tag+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
}
-(void)ChoiceFinished{
    if (self.iselect ==NO) {
        for (int i=0; i<[[_dataArr firstObject] count]; i++) {
            UIButton *btn=(UIButton *)[_dv viewWithTag:KStyleBtn_Tag+i];
            if(btn.selected==YES){
                //风格id：-1和1-11
                if(i==0) self.picture_style=-1;
                else self.picture_style=i;
                break;
            }
            else continue;
        }
        for (int i=0; i<[[_dataArr objectAtIndex:1] count]; i++) {
            UIButton *btn=(UIButton *)[_dv viewWithTag:KHuXingBtn_Tag+i];
            if(btn.selected==YES){
                //空间id：-1和36-46
                if(i==0) self.picture_doorModel=-1;
                else self.picture_doorModel=11+i;
                break;
            }
            else continue;
        }
        for (int i=0; i<[[_dataArr objectAtIndex:2] count]; i++) {
            UIButton *btn=(UIButton *)[_dv viewWithTag:KBaoJiaBtn_Tag+i];
            if(btn.selected==YES){
                //空间id：-1和36-46
                if(i==0) self.picture_price=-1;
                else self.picture_price=14+i;
                break;
            }
            else continue;
        }
        for (int i=0; i<[[_dataArr objectAtIndex:3] count]; i++) {
            UIButton *btn=(UIButton *)[_dv viewWithTag:KChengShiBtn_Tag+i];
            if(btn.selected==YES){
                //空间id：-1和36-46
                if(i==0) self.picture_city=-1;
                else self.picture_city=i;
                break;
            }
            else continue;
        }
    }else{
        for (int i=0; i<[[_dataArr firstObject] count]; i++) {
            UIButton *btn=(UIButton *)[_dv viewWithTag:KStyleBtn_Tag+i];
            if(btn.selected==YES){
                //风格id：-1和1-11
                if(i==0) self.picture_style=-1;
                else self.picture_style=i;
                break;
            }
            else continue;
        }
        for (int i=0; i<[[_dataArr objectAtIndex:1] count]; i++) {
            UIButton *btn=(UIButton *)[_dv viewWithTag:KKongJianBtn_Tag+i];
            if(btn.selected==YES){
                //空间id：-1和36-46
                if(i==0) self.picture_kongjian=-1;
                else self.picture_kongjian=17+i;
                break;
            }
            else continue;
        }
        for (int i=0; i<[[_dataArr objectAtIndex:2] count]; i++) {
            UIButton *btn=(UIButton *)[_dv viewWithTag:KJingYanBtn_Tag+i];
            if(btn.selected==YES){
                //空间id：-1和36-46
                if(i==0) self.picture_experience=-1;
                else self.picture_experience=1+i;
                break;
            }
            else continue;
        }
        for (int i=0; i<[[_dataArr objectAtIndex:3] count]; i++) {
            UIButton *btn=(UIButton *)[_dv viewWithTag:KChengShiBtn_Tag+i];
            if(btn.selected==YES){
                //空间id：-1和36-46
                if(i==0) self.picture_city=-1;
                else self.picture_city=i;
                break;
            }
            else continue;
        }
        for (int i=0; i<[[_dataArr objectAtIndex:4] count]; i++) {
            UIButton *btn=(UIButton *)[_dv viewWithTag:KDengJiBtn_Tag+i];
            if(btn.selected==YES){
                //空间id：-1和36-46
                if(i==0) self.picture_level=-1;
                else self.picture_level=i;
                break;
            }
            else continue;
        }
        for (int i=0; i<[[_dataArr objectAtIndex:5] count]; i++) {
            UIButton *btn=(UIButton *)[_dv viewWithTag:KRenZhengBtn_Tag+i];
            if(btn.selected==YES){
                //空间id：-1和36-46
                if(i==0) self.picture_aut=-1;
                else self.picture_aut=8;
                break;
            }
            else continue;
        }
        
        UITextField *tf_min=(UITextField *)[_scr viewWithTag:KPriceTF_Tag];
        UITextField *tf_max=(UITextField *)[_scr viewWithTag:KPriceTF_Tag+1];
        self.priceMin=tf_min.text;
        self.priceMax=tf_max.text;
        
        if([self.priceMin integerValue]<0 || [self.priceMin integerValue]>10000){
            [TLToast showWithText:@"最低报价范围0-10000"];
            return;
        }
        else if([self.priceMax integerValue]<0 || [self.priceMax integerValue]>10000){
            [TLToast showWithText:@"最高报价范围0-10000"];
            return;
        }
        else if([self.priceMin integerValue]>[self.priceMax integerValue]){
            [TLToast showWithText:@"最低报价不能大于最高报价"];
            return;
        }
        
    }
    
    [self RequestData];
}

-(void)RequestData{
    [self dismiss];
    if (self.iselect ==YES) {
        for (UINavigationController *nav in self.contents) {
            if ([nav isKindOfClass:[UINavigationController class]]) {
                DesignerViewController *desigerVC =[nav.viewControllers objectAtIndex:0];
                desigerVC.picture_style =self.picture_style;
                desigerVC.picture_kongjian =self.picture_kongjian;
                desigerVC.picture_experience =self.picture_experience;
                desigerVC.picture_city =self.picture_city;
                desigerVC.picture_level =self.picture_level;
                desigerVC.picture_aut =self.picture_aut;
                desigerVC.priceMin_=self.priceMin;
                desigerVC.priceMax_=self.priceMax;
                desigerVC.searchContent=searchBar.text;
                if([desigerVC.dataArray count]) {
                    [desigerVC.dataArray removeAllObjects];
                    [desigerVC.mtableview reloadData];
                }
                [desigerVC.mtableview launchRefreshing];
            }
        }
    }else{
        for (UINavigationController *nav in self.contents) {
            if ([nav isKindOfClass:[UINavigationController class]]) {
                MyeffectypictureVC *effectVC =[nav.viewControllers objectAtIndex:0];
                effectVC.picture_style =self.picture_style;
                effectVC.picture_doorModel =self.picture_doorModel;
                effectVC.picture_price =self.picture_price;
                effectVC.picture_city =self.picture_city;
                effectVC.searchContent=searchBar.text;
                if([effectVC.dataArray count]) {
                    [effectVC.dataArray removeAllObjects];
                    [effectVC.qtmquitView reloadData];
                }
                [effectVC refreshView];
            }
        }
    }
}

#pragma mark - KeyBord

- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat kbSize = rect.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        _scr.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-kbSize);
        mtableview_sub.frame=CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64-kbSize);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    //CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //CGFloat kbSize = rect.size.height;
    //MJLog(@"willHide---键盘高度：%f",kbSize);
    
    [UIView animateWithDuration:duration animations:^{
        _scr.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-kMainScreenWidth/8);
        mtableview_sub.frame=CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64);
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

-(void)tapView:(UIGestureRecognizer *)gesture{
    for(int i=0;i<2;i++){
        UITextField *tf=(UITextField *)[_scr viewWithTag:KPriceTF_Tag+i];
        [tf resignFirstResponder];
    }
}

#pragma mark - 创建搜索

-(void)createSearchView{
    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path_ = [path_ objectAtIndex:0];
    NSString* _filename_;
    if (self.iselect ==YES)
        _filename_ = [doc_path_ stringByAppendingPathComponent:KHISTORY_SS_DESIGNER];
    else
        _filename_ = [doc_path_ stringByAppendingPathComponent:KHISTORY_SS_CASEOGTAOTU];
    _dataArray_history=[NSMutableArray arrayWithContentsOfFile:_filename_];
    if (!_dataArray_history) {
        _dataArray_history=[NSMutableArray arrayWithCapacity:0];
    }
    if([_dataArray_history count]>15) [_dataArray_history removeObjectsInRange:NSMakeRange(15, [_dataArray_history count]-15)];
    [searchBar becomeFirstResponder];
    
    mtableview_sub=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    mtableview_sub.backgroundColor=[UIColor whiteColor];
    mtableview_sub.delegate=self;
    mtableview_sub.dataSource=self;
    mtableview_sub.separatorStyle=UITableViewCellSeparatorStyleNone;
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.window addSubview:mtableview_sub];
    
    [self createUITextField];
    mtableview_sub.hidden=YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_dataArray_history count]==indexPath.row) return kMainScreenHeight-64-200;
    else return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([_dataArray_history count]<=15) return [_dataArray_history count]+1;
    else return 15+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycellid_";
    SearchListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SearchListCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    for(id btn in cell.subviews) {
        if([btn isKindOfClass:[UIButton class]])[btn removeFromSuperview];
    }
    
    if([_dataArray_history count]!=indexPath.row){
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 49.5, kMainScreenWidth-40, 0.5)];
        line.backgroundColor=[UIColor lightGrayColor];
        line.alpha=0.6;
        [cell addSubview:line];
        
        cell.ser_his_lab.hidden=NO;
        cell.ser_his_lab.text=[_dataArray_history objectAtIndex:indexPath.row];
    }
    else {
        cell.ser_his_lab.hidden=YES;
        if([_dataArray_history count]){
            UIButton *clear_btn=[UIButton buttonWithType:UIButtonTypeCustom];
            clear_btn.frame=CGRectMake((kMainScreenWidth-20-134)/2, 100, 134, 31);
            [clear_btn setTitle:@"清除历史" forState:UIControlStateNormal];
            [clear_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            clear_btn.titleLabel.font=[UIFont systemFontOfSize:15];
            //给按钮加一个白色的板框
            clear_btn.layer.borderColor = [[UIColor redColor] CGColor];
            clear_btn.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            clear_btn.layer.cornerRadius = 4.0f;
            clear_btn.layer.masksToBounds = YES;
            [clear_btn addTarget:self action:@selector(pressClear_btn) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:clear_btn];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_dataArray_history count]!=indexPath.row){
        [searchBar resignFirstResponder];
        view_search_bg.hidden=NO;
        mtableview_sub.hidden=YES;
        self.isShowSearchBar=YES;
        searchBar.text=[_dataArray_history objectAtIndex:indexPath.row];

        BOOL isDefault=YES;
        if(searchBar.text.length){
            for(int i=0;i<[_dataArray_history count];i++){
                NSString *str=[_dataArray_history objectAtIndex:i];
                if([str isEqualToString:searchBar.text]) {
                    [_dataArray_history exchangeObjectAtIndex:0 withObjectAtIndex:i];
                    isDefault=NO;
                    break;
                }
            }
            if(isDefault==YES) {
                if([_dataArray_history count]>=15) [_dataArray_history removeObjectsInRange:NSMakeRange(14, [_dataArray_history count]-14)];
                [_dataArray_history insertObject:searchBar.text atIndex:0];
            }
            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* doc_path = [path objectAtIndex:0];
            NSString* _filename_;
            if (self.iselect ==YES)
                _filename_ = [doc_path stringByAppendingPathComponent:KHISTORY_SS_DESIGNER];
            else
                _filename_ = [doc_path stringByAppendingPathComponent:KHISTORY_SS_CASEOGTAOTU];
            [_dataArray_history writeToFile:_filename_ atomically:NO];
        }
        
        [self RequestData];
    }
}

#pragma mark -
#pragma mark -  Others

-(void)createUITextField{
    view_search_bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    view_search_bg.backgroundColor=[UIColor whiteColor];
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.window addSubview:view_search_bg];
    
    UIImageView *imv_ss=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_sousuo_s"]];
    imv_ss.frame=CGRectMake(10, 7.5, 15, 15);
    UIView *view_left_ss=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    view_left_ss.backgroundColor=[UIColor clearColor];
    [view_left_ss addSubview:imv_ss];
    
    searchBar=[[UITextField alloc]initWithFrame:CGRectMake(20, 27, kMainScreenWidth-90, 30)];
    searchBar.borderStyle=UITextBorderStyleRoundedRect;
    searchBar.backgroundColor =kColorWithRGB(233, 233, 236);
    searchBar.delegate=self;
    searchBar.placeholder=@"请输入搜索内容";
    searchBar.returnKeyType=UIReturnKeySearch;
    searchBar.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    searchBar.font=[UIFont systemFontOfSize:15];
    searchBar.tintColor=kColorWithRGB(192, 192, 196);
    searchBar.clearsOnBeginEditing=YES;
    searchBar.clearButtonMode=UITextFieldViewModeWhileEditing;
    searchBar.leftView=view_left_ss;
    searchBar.leftViewMode=UITextFieldViewModeAlways;
    [view_search_bg addSubview:searchBar];
    
    UIButton *btn_cancle=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-55, 27, 50, 30)];
    [btn_cancle setTitle:@"取消" forState:UIControlStateNormal];
    [btn_cancle setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn_cancle.titleLabel.font=[UIFont systemFontOfSize:16];
    [btn_cancle addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [view_search_bg addSubview:btn_cancle];
    
    view_search_bg.hidden=YES;
}

#pragma mark -
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField !=searchBar) {
        return YES;
    }
    view_search_bg.hidden=NO;
    mtableview_sub.hidden=NO;
    self.isShowSearchBar=YES;
    [mtableview_sub reloadData];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [searchBar resignFirstResponder];
    view_search_bg.hidden=NO;
    mtableview_sub.hidden=YES;
    self.isShowSearchBar=YES;
    
    BOOL isDefault=YES;
    if(textField.text.length){
        for(int i=0;i<[_dataArray_history count];i++){
            NSString *str=[_dataArray_history objectAtIndex:i];
            if([str isEqualToString:textField.text]) {
                [_dataArray_history exchangeObjectAtIndex:0 withObjectAtIndex:i];
                isDefault=NO;
                break;
            }
        }
        if(isDefault==YES) {
            if([_dataArray_history count]>=15) [_dataArray_history removeObjectsInRange:NSMakeRange(14, [_dataArray_history count]-14)];
            [_dataArray_history insertObject:textField.text atIndex:0];
        }
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename_;
        if (self.iselect ==YES)
            _filename_ = [doc_path stringByAppendingPathComponent:KHISTORY_SS_DESIGNER];
        else
            _filename_ = [doc_path stringByAppendingPathComponent:KHISTORY_SS_CASEOGTAOTU];
        [_dataArray_history writeToFile:_filename_ atomically:NO];
        
        [self RequestData];
    }
    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField.enablesReturnKeyAutomatically ==NO) {
//         textField.returnKeyType=UIReturnKeySearch;
//    }
//    return YES;
//}
#pragma mark - UIButton

-(void)pressClear_btn{
    if([_dataArray_history count]){
        [_dataArray_history removeAllObjects];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename_;
        if (self.iselect ==YES)
            _filename_ = [doc_path stringByAppendingPathComponent:KHISTORY_SS_DESIGNER];
        else
            _filename_ = [doc_path stringByAppendingPathComponent:KHISTORY_SS_CASEOGTAOTU];
        [_dataArray_history writeToFile:_filename_ atomically:NO];
    }
    [mtableview_sub reloadData];
}

-(void)cancelSearch{
    view_search_bg.hidden=YES;
    mtableview_sub.hidden=YES;
    self.isShowSearchBar=NO;
    [searchBar resignFirstResponder];
    
    if (self.iselect ==YES) {
        for (UINavigationController *nav in self.contents) {
            if ([nav isKindOfClass:[UINavigationController class]]) {
                DesignerViewController *desigerVC =[nav.viewControllers objectAtIndex:0];
                desigerVC.picture_style =self.picture_style;
                desigerVC.picture_kongjian =self.picture_kongjian;
                desigerVC.picture_experience =self.picture_experience;
                desigerVC.picture_city =self.picture_city;
                desigerVC.picture_level =self.picture_level;
                desigerVC.picture_aut =self.picture_aut;
                desigerVC.priceMin_=self.priceMin;
                desigerVC.priceMax_=self.priceMax;
                desigerVC.searchContent=@"";
                if([desigerVC.dataArray count]) {
                    [desigerVC.dataArray removeAllObjects];
                    [desigerVC.mtableview reloadData];
                }
                [desigerVC.mtableview launchRefreshing];
            }
        }
    }else{
        for (UINavigationController *nav in self.contents) {
            if ([nav isKindOfClass:[UINavigationController class]]) {
                MyeffectypictureVC *effectVC =[nav.viewControllers objectAtIndex:0];
                effectVC.picture_style =self.picture_style;
                effectVC.picture_doorModel =self.picture_doorModel;
                effectVC.picture_price =self.picture_price;
                effectVC.picture_city =self.picture_city;
                effectVC.searchContent=@"";
                if([effectVC.dataArray count]) {
                    [effectVC.dataArray removeAllObjects];
                    [effectVC.qtmquitView reloadData];
                }
                [effectVC refreshView];
            }
        }
    }
}

@end
