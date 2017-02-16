//
//  GongZhangTuanMainViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-20.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GongZhangTuanMainViewController.h"
#import "util.h"
#import "IDIAIAppDelegate.h"
#import "SearchGongZViewController.h"
#import "GongzhangtuanViewController.h"
#import "HRCoreAnimationEffect.h"
#import "SearchListCell.h"

#define KHISTORY_SS_GongZhang @"MyHistory_gongzhang.plist"
#define KJingYanBtn_Tag 1100
#define KTeSeBtn_Tag 1300
#define KRenZhengBtn_Tag 1600
@interface GongZhangTuanMainViewController () <ViewPagerDataSource, ViewPagerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,assign)BOOL isshow;
@end

@implementation GongZhangTuanMainViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
    
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:kColorWithRGB(249, 249, 250)];
    
    appDelegate.nav.navigationBar.hidden = NO;//zl
//
    //修改navBar字体大小文字颜色
    NSDictionary *attris = @{ NSFontAttributeName:[UIFont systemFontOfSize:19],
                              NSForegroundColorAttributeName:[UIColor blackColor] };
    [self.navigationController.navigationBar setTitleTextAttributes:attris];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if(self.isShowSearchBar==YES) view_search_bg.hidden=NO;
    else view_search_bg.hidden=YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    view_search_bg.hidden=YES;
    mtableview_sub.hidden=YES;
}

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view.
    self.picture_experience=-1;
    self.picture_aut =-1;
    self.picture_service=-1;
    self.dataSource = self;
    self.delegate = self;
    
    self.title = @"选工长";
    
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
    
    [super viewDidLoad];//一定要放在设置代理最后 不然有问题 huangrun
    int dance =8*kMainScreenWidth/320;
    UIButton *showbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    showbtn.frame =CGRectMake(kMainScreenWidth/5.0*4-dance, 0, kMainScreenWidth/5.0+dance, 44);
    showbtn.backgroundColor =[UIColor whiteColor];
    [showbtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label =[[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:16.0];
    label.text = @"筛选";
    label.frame =CGRectMake(0, (showbtn.frame.size.height-15)/2, 36, 15);
    [showbtn addSubview:label];
    UIImageView *image =[[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, 19, 8, 8)];
    image.image =[UIImage imageNamed:@"ic_shaixuan_n.png"];
    [showbtn addSubview:image];
    [self.tabsView addSubview:showbtn];
    
    [self createSearchView];   //创建搜索页
}

-(void)PressBarItemRight{
    [_control removeFromSuperview];
    _control=nil;
    [_dv removeFromSuperview];
    _dv=nil;
    
//    SearchGongZViewController *searchvc=[[SearchGongZViewController alloc]init];
//    [self.navigationController pushViewController:searchvc animated:YES];
    
    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path_ = [path_ objectAtIndex:0];
    NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:KHISTORY_SS_GongZhang];
    _dataArray_history=[NSMutableArray arrayWithContentsOfFile:_filename_];
    if (!_dataArray_history) {
        _dataArray_history=[NSMutableArray arrayWithCapacity:0];
    }
    if([_dataArray_history count]>15) [_dataArray_history removeObjectsInRange:NSMakeRange(15, [_dataArray_history count]-15)];
    
    view_search_bg.hidden=NO;
    mtableview_sub.hidden=NO;
    [searchBar becomeFirstResponder];
}

#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerControllerThird *)viewPager {
    return 4;
}

- (UIView *)viewPager:(ViewPagerControllerThird *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.0];
    label.text = [NSString stringWithFormat:@"View %u", (unsigned)index];
    if (index == 0) {
        label.text = @"口碑";
    } else if (index == 1) {
        label.text = @"预约";
    } else if (index == 2){
        label.text = @"工地";
    }else if (index ==3){
        label.text = @"收藏";
    }

    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    
    [label sizeToFit];
//    if (index ==4) {
//        UIView *view =[UIView new];
//        view.backgroundColor =[UIColor clearColor];
//        label.frame =CGRectMake((view.frame.size.width-30)/2, (view.frame.size.height-15)/2, 30, 15);
//        [view addSubview:label];
//        UIImageView *image =[[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, -4, 8, 8)];
//        image.image =[UIImage imageNamed:@"ic_shaixuan_n.png"];
//        [view addSubview:image];
//        return view;
//    }
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerControllerThird *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    GongzhangtuanViewController *gongzhangtuanVC = [[GongzhangtuanViewController alloc]init];
    gongzhangtuanVC.selected_mark =index + 1;
    gongzhangtuanVC.picture_experience =self.picture_experience;
    gongzhangtuanVC.picture_aut =self.picture_aut;
    gongzhangtuanVC.picture_service =self.picture_service;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:gongzhangtuanVC];
    return nav;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerControllerThird *)viewPager valueForOption:(ViewPagerOption__)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab__:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab__:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation__:
            return 1.0;
            break;
        case ViewPagerOptionTabWidth__:
            if(kMainScreenWidth<=320) return kMainScreenWidth/5.0;
            else return kMainScreenWidth/5.001;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerControllerThird *)viewPager colorForComponent:(ViewPagerComponent__)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator__:
            return [UIColor whiteColor];//kThemeColor;
            break;
        default:
            break;
    }
    
    return color;
}

- (void)viewPager:(ViewPagerControllerThird *)viewPager didChangeTabToIndex:(NSUInteger)index {
    
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
    _dataArr = @[@[@"不限",@"1~3年",@"3~5年",@"5~10年",@"10~20年",@"20年以上"],@[@"不限",@"免费设计",@"担保交易",@"延期赔付"],@[@"不限",@"实名认证",@"工艺认证",@"质量认证"]];
    [keywindow addSubview:_dv];
    [self createChioces];
    
    [HRCoreAnimationEffect animationPushRight:_dv];
}
-(void)createChioces{
    _scr=[[UIScrollView alloc] init];
    _scr.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    [_dv addSubview:_scr];
    
    UILabel *jingyan_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
    jingyan_lab.backgroundColor=[UIColor clearColor];
    jingyan_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
    jingyan_lab.font=[UIFont boldSystemFontOfSize:18];
    jingyan_lab.text=@"经验";
    [_scr addSubview:jingyan_lab];
    float width_=(kMainScreenWidth-40-60)/3;
    float heigth_=32;
    float space=0;
    for (int i=0; i<[[_dataArr firstObject] count]; i++) {
        UIButton *btn_jingyan=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), CGRectGetMaxY(jingyan_lab.frame)+10+(i/3)*(heigth_+15), width_, heigth_)];
        btn_jingyan.tag=KJingYanBtn_Tag+i;
        [btn_jingyan setTitle:[[_dataArr firstObject] objectAtIndex:i] forState:UIControlStateNormal];
        [btn_jingyan setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
        [btn_jingyan setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
        btn_jingyan.titleLabel.font=[UIFont systemFontOfSize:16];
        if(i==0 && self.picture_experience==-1) btn_jingyan.selected=YES;
        else if(i==self.picture_experience-1 && i!=0) btn_jingyan.selected=YES;
        //给按钮加一个红色的板框
        if(btn_jingyan.selected==YES) btn_jingyan.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
        else btn_jingyan.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
        btn_jingyan.layer.borderWidth = 1.0f;
        //给按钮设置弧度,这里将按钮变成了圆形
        btn_jingyan.layer.cornerRadius = 5.0f;
        btn_jingyan.layer.masksToBounds = YES;
        [btn_jingyan addTarget:self action:@selector(ChoiceJingYan:) forControlEvents:UIControlEventTouchUpInside];
        [_scr addSubview:btn_jingyan];
        
        if(i==[[_dataArr firstObject] count]-1) space=CGRectGetMaxY(btn_jingyan.frame);
    }
    
    UILabel *tese_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, space+20, 100, 20)];
    tese_lab.backgroundColor=[UIColor clearColor];
    tese_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
    tese_lab.font=[UIFont boldSystemFontOfSize:18];
    tese_lab.text=@"特色服务";
    [_scr addSubview:tese_lab];
    space=CGRectGetMaxY(tese_lab.frame);
    for (int i=0; i<[[_dataArr objectAtIndex:1] count]; i++) {
        UIButton *btn_tese=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), space+10+(i/3)*(heigth_+15), width_, heigth_)];
        btn_tese.tag=KTeSeBtn_Tag+i;
        [btn_tese setTitle:[[_dataArr objectAtIndex:1] objectAtIndex:i] forState:UIControlStateNormal];
        [btn_tese setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
        [btn_tese setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
        btn_tese.titleLabel.font=[UIFont systemFontOfSize:16];
        if(i==0 && self.picture_service==-1) btn_tese.selected=YES;
        else if(i==self.picture_service-26 && i!=0) btn_tese.selected=YES;
        //给按钮加一个红色的板框
        if(btn_tese.selected==YES) btn_tese.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
        else btn_tese.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
        btn_tese.layer.borderWidth = 1.0f;
        //给按钮设置弧度,这里将按钮变成了圆形
        btn_tese.layer.cornerRadius = 5.0f;
        btn_tese.layer.masksToBounds = YES;
        [btn_tese addTarget:self action:@selector(ChoiceTeSe:) forControlEvents:UIControlEventTouchUpInside];
        [_scr addSubview:btn_tese];
        
        if(i==[[_dataArr objectAtIndex:1] count]-1) space=CGRectGetMaxY(btn_tese.frame);
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
        btn_renzheng.titleLabel.font=[UIFont systemFontOfSize:16];
        if(self.picture_aut==-1 && i==0) btn_renzheng.selected=YES;
        else if(self.picture_aut==6 && i==1) btn_renzheng.selected=YES;
        else if (self.picture_aut==7 && i==2) btn_renzheng.selected=YES;
        else if (self.picture_aut==11 && i==3)btn_renzheng.selected=YES;
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
-(void)ChoiceTeSe:(UIButton *)sender{
    //风格id：-1和1-11
    for (int i=0; i<[[_dataArr objectAtIndex:1] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KTeSeBtn_Tag+i];
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
    for (int i=0; i<[[_dataArr objectAtIndex:0] count]; i++) {
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
-(void)ChoiceRenZheng:(UIButton *)sender{
    //户型id：-1和1-11
    for (int i=0; i<[[_dataArr objectAtIndex:2] count]; i++) {
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
    for (int i=0; i<[[_dataArr firstObject] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KJingYanBtn_Tag+i];
        if(btn.selected==YES){
            //风格id：-1和1-11
            if(i==0) self.picture_experience=-1;
            else self.picture_experience=i+1;
            [[NSUserDefaults standardUserDefaults]setInteger:self.picture_experience forKey:kUDEffectyTypeOfRow_Style];
            [[NSUserDefaults standardUserDefaults]synchronize];
            break;
        }
        else continue;
    }
    for (int i=0; i<[[_dataArr objectAtIndex:1] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KTeSeBtn_Tag+i];
        if(btn.selected==YES){
            //空间id：-1和36-46
            if(i==0) self.picture_service=-1;
            else self.picture_service=26+i;
            break;
        }
        else continue;
    }
    for (int i=0; i<[[_dataArr objectAtIndex:2] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KRenZhengBtn_Tag+i];
        if(btn.selected==YES){
            //空间id：-1和36-46
            if(i==0) self.picture_aut=-1;
            else if (i==1) self.picture_aut=6;
            else if (i==2) self.picture_aut=7;
            else if (i==3) self.picture_aut=11;
            break;
        }
        else continue;
    }
    
    [self RequestData];
}

-(void)RequestData{
    [self dismiss];
    for (UINavigationController *nav in self.contents) {
        if ([nav isKindOfClass:[UINavigationController class]]) {
            GongzhangtuanViewController *gongzhangtuanVC =[nav.viewControllers objectAtIndex:0];
            gongzhangtuanVC.picture_experience =self.picture_experience;
            gongzhangtuanVC.picture_aut =self.picture_aut;
            gongzhangtuanVC.picture_service =self.picture_service;
            gongzhangtuanVC.searchContent=searchBar.text;
            if([gongzhangtuanVC.dataArray count]) {
                [gongzhangtuanVC.dataArray removeAllObjects];
                [gongzhangtuanVC.mtableview reloadData];
            }
            [gongzhangtuanVC.mtableview launchRefreshing];
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

#pragma mark - 创建搜索

-(void)createSearchView{
    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path_ = [path_ objectAtIndex:0];
    NSString* _filename_  = [doc_path_ stringByAppendingPathComponent:KHISTORY_SS_GongZhang];
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
            NSString* _filename_ = [doc_path stringByAppendingPathComponent:KHISTORY_SS_GongZhang];
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
        NSString* _filename_  = [doc_path stringByAppendingPathComponent:KHISTORY_SS_GongZhang];
        [_dataArray_history writeToFile:_filename_ atomically:NO];
        
        [self RequestData];
    }
    return YES;
}

#pragma mark - UIButton

-(void)pressClear_btn{
    if([_dataArray_history count]){
        [_dataArray_history removeAllObjects];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename_ = [doc_path stringByAppendingPathComponent:KHISTORY_SS_GongZhang];
        [_dataArray_history writeToFile:_filename_ atomically:NO];
    }
    [mtableview_sub reloadData];
}

-(void)cancelSearch{
    view_search_bg.hidden=YES;
    mtableview_sub.hidden=YES;
    self.isShowSearchBar=NO;
    [searchBar resignFirstResponder];
    
    for (UINavigationController *nav in self.contents) {
        if ([nav isKindOfClass:[UINavigationController class]]) {
            GongzhangtuanViewController *gongzhangtuanVC =[nav.viewControllers objectAtIndex:0];
            gongzhangtuanVC.picture_experience =self.picture_experience;
            gongzhangtuanVC.picture_aut =self.picture_aut;
            gongzhangtuanVC.picture_service =self.picture_service;
            gongzhangtuanVC.searchContent=@"";
            if([gongzhangtuanVC.dataArray count]) {
                [gongzhangtuanVC.dataArray removeAllObjects];
                [gongzhangtuanVC.mtableview reloadData];
            }
            [gongzhangtuanVC.mtableview launchRefreshing];
        }
    }
}

@end
