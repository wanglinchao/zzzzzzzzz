//
//  JianliViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-26.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "JianliViewController.h"
#import "HexColor.h"
#import "util.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "UIImageView+OnlineImage.h"
#import "DesignerInfoVC.h"
#import "IDIAIAppDelegate.h"
#import "OpenUDID.h"
#import "savelogObj.h"
#import "Macros.h"
#import "SubscribePeopleViewController.h"
#import "SupervisorListObj.h"
#import "DesignerListCell.h"
#import "ForemanInfoViewController.h"
#import "LoginView.h"
#import "TLToast.h"
#import "SubscribeListModel.h"
#import "MySubscribeDetailViewController.h"
#import "JianliDetailViewController.h"
#import "IDIAI3JianLiDetailViewController.h"
#import "HRCoreAnimationEffect.h"
#import "SearchGJSView.h"

#define kButton_Booking 1000
#define KButtonTag_phone 10000
#define KUILabelTag_YuYueCount 100000
#define KJingYanBtn_Tag 1100
#define KDengJiBtn_Tag 1200
#define KTeSeBtn_Tag 1300
#define KRenZhengBtn_Tag 1600
#define KSortBtn_Tag 1700
#define KPriceTF_Tag 1900

@interface JianliViewController () <LoginViewDelegate,SearchGJSViewDelegate,UITextFieldDelegate>
{
  
    NSString *_bookIdStr;
    
    SearchGJSView *searchVC;
    UIView *view_search_bg;
    UITextField *searchBar;
}

@property (nonatomic,strong)UIImageView *slider_image;
@property (nonatomic,assign)NSInteger dataoldcount;
@property (nonatomic,assign)NSInteger willIndexRow;
@property (nonatomic,assign)NSInteger endIndexRow;

@property (nonatomic,strong)UIButton *btn_left;
@property (nonatomic,strong)UIButton *btn_right;

@end

@implementation JianliViewController

@synthesize selected_mark,dataArray;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:kColorWithRGB(249, 249, 250)];
    
    if(self.isShowSearchBar==YES) view_search_bg.hidden=NO;
    else view_search_bg.hidden=YES;
    
    [self.mtableview reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    view_search_bg.hidden=YES;
}

- (void)backButtonPressed:(id)sender {
    [self dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"查看监理列表" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:51];
    
    self.title=@"选监理";
    self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.view.backgroundColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"dissMiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
    
    //自定义返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"ic_fh.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    dataArray =[[NSMutableArray alloc]initWithCapacity:0];
    self.currentPage=0;
    self.searchContent=@"";
    
    self.picture_experience=-1;
    self.picture_aut =-1;
    self.picture_service=-1;
    self.picture_level =-1;
    self.priceMin_=@"";
    self.priceMax_=@"";
    selected_mark=1;
    [self createTopBtn];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-64-40) pullingDelegate:self];
    self.mtableview.backgroundColor=[UIColor colorWithHexString:@"#f1f0f6"];
    self.mtableview.dataSource=self;
    self.mtableview.delegate=self;
    self.mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [self.mtableview launchRefreshing];
    [self.view addSubview:self.mtableview];
    
    [self loadImageviewBG];
    
    [self createSearchTitle];
}

/*********搜索********/

-(void)PressBarItemRight{
    [_control removeFromSuperview];
    _control=nil;
    [_dv removeFromSuperview];
    _dv=nil;
    
    if(!searchVC) searchVC=[[SearchGJSView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) historyData:@"MyHistory_supersior.plist" fromName:@"监理"];
    searchVC.delegate=self;
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:searchVC];
}

-(void)createSearchTitle{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    view_search_bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    view_search_bg.backgroundColor=[UIColor whiteColor];
    [keywindow addSubview:view_search_bg];
    view_search_bg.hidden=YES;
    
    UIImageView *imv_ss=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_sousuo_s"]];
    imv_ss.frame=CGRectMake(10, 7.5, 15, 15);
    UIView *view_left_ss=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    view_left_ss.backgroundColor=[UIColor clearColor];
    [view_left_ss addSubview:imv_ss];
    
    searchBar=[[UITextField alloc]initWithFrame:CGRectMake(20, 27, kMainScreenWidth-90, 30)];
    searchBar.borderStyle=UITextBorderStyleRoundedRect;
    searchBar.backgroundColor =kColorWithRGB(233, 233, 236);
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
    searchBar.enabled=NO;
    
    UIButton *btn_search=[[UIButton alloc]initWithFrame:CGRectMake(0, 27, kMainScreenWidth-55, 30)];
    [btn_search addTarget:self action:@selector(tapSearch) forControlEvents:UIControlEventTouchUpInside];
    [view_search_bg addSubview:btn_search];
    
    UIButton *btn_cancle=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-55, 27, 50, 30)];
    [btn_cancle setTitle:@"取消" forState:UIControlStateNormal];
    [btn_cancle setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn_cancle.titleLabel.font=[UIFont systemFontOfSize:16];
    [btn_cancle addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [view_search_bg addSubview:btn_cancle];
}

-(void)tapSearch{
    view_search_bg.hidden=YES;
    [_control removeFromSuperview];
    _control=nil;
    [_dv removeFromSuperview];
    _dv=nil;
    
    if(!searchVC) searchVC=[[SearchGJSView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) historyData:@"MyHistory_supersior.plist" fromName:@"监理"];
    searchVC.delegate=self;
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:searchVC];
}

-(void)cancelSearch{
    [_control removeFromSuperview];
    _control=nil;
    [_dv removeFromSuperview];
    _dv=nil;
    
    self.isShowSearchBar=NO;
    view_search_bg.hidden=YES;
    _searchContent=@"";
    [self.mtableview launchRefreshing];
}

-(void)searchType:(NSString *)searchType searchContent:(NSString *)searchContent cancle:(NSString *)cancle{
    _btn_left.selected=NO;
    _btn_right.selected=NO;
    [searchVC removeFromSuperview];
    searchVC = nil;
    
    if([cancle isEqualToString:@"取消"]) {
        view_search_bg.hidden=YES;
        self.isShowSearchBar=NO;
    }
    else {
        view_search_bg.hidden=NO;
        self.isShowSearchBar=YES;
    }
    searchBar.text=searchContent;
    
    _searchContent=searchContent;
    [self.mtableview launchRefreshing];
}

/*********************************************************/

-(void)createTopBtn{
    _btn_left=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth/2, 40)];
    _btn_left.backgroundColor=[UIColor whiteColor];
    [_btn_left setTitle:@"排序" forState:UIControlStateNormal];
    [_btn_left setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btn_left setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateSelected];
    [_btn_left setImage:[UIImage imageNamed:@"ic_jianatou_down"] forState:UIControlStateNormal];
    [_btn_left setImage:[UIImage imageNamed:@"ic_jianatou_up"] forState:UIControlStateSelected];
    _btn_left.imageEdgeInsets=UIEdgeInsetsMake(0, CGRectGetWidth(_btn_left.frame)/2+26, 0, CGRectGetWidth(_btn_left.frame)/2-46);
    [_btn_left addTarget:self action:@selector(TapActionSliderLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_left];
    
    _btn_right=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth/2, 0, kMainScreenWidth/2, 40)];
    _btn_right.backgroundColor=[UIColor whiteColor];
    [_btn_right setTitle:@"筛选" forState:UIControlStateNormal];
    [_btn_right setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btn_right setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateSelected];
    [_btn_right setImage:[UIImage imageNamed:@"ic_shaixuan_n"] forState:UIControlStateNormal];
    [_btn_right setImage:[UIImage imageNamed:@"ic_shaixuan_s"] forState:UIControlStateSelected];
    _btn_right.imageEdgeInsets=UIEdgeInsetsMake(0, CGRectGetWidth(_btn_right.frame)/2+26, 0, CGRectGetWidth(_btn_right.frame)/2-46);
    [_btn_right addTarget:self action:@selector(TapActionSliderRight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_right];
}

-(void)TapActionSliderLeft{
    _btn_left.selected=!_btn_left.selected;
    _btn_right.selected=NO;
    
    if(_btn_left.selected==YES) {
        [_control removeFromSuperview];
        _control=nil;
        [_dv removeFromSuperview];
        _dv=nil;
        [self createSortView];
    }
    else [self dismiss];
}

-(void)TapActionSliderRight{
    _btn_left.selected=NO;
    _btn_right.selected=!_btn_right.selected;
    
    if(_btn_right.selected==YES) {
        [_control removeFromSuperview];
        _control=nil;
        [_dv removeFromSuperview];
        _dv=nil;
        [self show];
    }
    else [self dismiss];
}

#pragma mark - 排序

-(void)createSortView{
    //    if(_control) {
    //        [self dismiss];
    //        return;
    //    }
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if(!_control)_control = [[UIControl alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight+40.5, kMainScreenHeight - 80, kMainScreenHeight - kNavigationBarHeight-40)];
    _control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
    [_control addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [keywindow addSubview:_control];
    
    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+40.5, kMainScreenWidth , 0)];
    _dv.tag=101;
    _dv.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    _dataArr = @[@"口碑值",@"预约数",@"浏览数",@"收藏数"];
    [keywindow addSubview:_dv];
    
    //[HRCoreAnimationEffect animationPushDown:_dv];
    
    //动画设置位置
    _control.alpha=0.3;
    [UIView animateWithDuration:0.2 animations:^{
        _control.alpha=1.0;
        _dv.frame =  CGRectMake(0, kNavigationBarHeight+40.5, kMainScreenWidth, 150);
    }completion:^(BOOL finished){
        [self createSortBtn];
    }];
}

-(void)createSortBtn{
    float width_=(kMainScreenWidth-40-60)/3;
    float heigth_=32;
    for (int i=0; i<[_dataArr count]; i++) {
        UIButton *btn_sort=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), 20+(i/3)*(heigth_+15), width_, heigth_)];
        btn_sort.tag=KSortBtn_Tag+i;
        [btn_sort setTitle:[_dataArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn_sort setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
        [btn_sort setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
        btn_sort.titleLabel.font=[UIFont systemFontOfSize:16];
        if(selected_mark == i+1) btn_sort.selected=YES;
        //给按钮加一个红色的板框
        if(btn_sort.selected==YES) btn_sort.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
        else btn_sort.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
        btn_sort.layer.borderWidth = 1.0f;
        //给按钮设置弧度,这里将按钮变成了圆形
        btn_sort.layer.cornerRadius = 5.0f;
        btn_sort.layer.masksToBounds = YES;
        [btn_sort addTarget:self action:@selector(sortBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_dv addSubview:btn_sort];
    }
}

-(void)sortBtn:(UIButton *)sender{
    //排序id：1-4
    for (int i=0; i<[_dataArr count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KSortBtn_Tag+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
            selected_mark=i+1;
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
    
    _btn_left.selected=NO;
    [self dismiss];
    [self.mtableview launchRefreshing];
}

#pragma mark - 选择风格
- (void)show {
//    if(_control) {
//        [self dismiss];
//        return;
//    }
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if(!_control)_control = [[UIControl alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight+40.5, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight-40)];
    _control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
    [_control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [keywindow addSubview:_control];
    
    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+40.5, kMainScreenWidth , 0)];
    _dv.tag=101;
    _dv.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    _dataArr = @[@[@"不限",@"1~3年",@"3~5年",@"5~10年",@"10~20年",@"20年以上"],@[@"不限",@"全程指导",@"质量把关",@"方案审核",@"预算审核",@"图纸审核",@"实时反馈"],@[@"不限",@"新晋监理",@"优秀监理",@"资深监理"],@[@"不限",@"实名"]];
    [keywindow addSubview:_dv];
    
    //[HRCoreAnimationEffect animationPushRight:_dv];
    
    //动画设置位置
    _control.alpha=0.3;
    [UIView animateWithDuration:0.2 animations:^{
        _control.alpha=1.0;
        _dv.frame =  CGRectMake(0, kNavigationBarHeight+40.5, kMainScreenWidth , kMainScreenHeight - kNavigationBarHeight -40);
        [self createChioces];
    }];
}
-(void)createChioces{
    _scr=[[UIScrollView alloc] init];
    _scr.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    [_dv addSubview:_scr];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [_scr addGestureRecognizer:tap];
    
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
        else if(i==self.picture_service-29 && i!=0) btn_tese.selected=YES;
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
    
    UILabel *dengji_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, space+20, 100, 20)];
    dengji_lab.backgroundColor=[UIColor clearColor];
    dengji_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
    dengji_lab.font=[UIFont boldSystemFontOfSize:18];
    dengji_lab.text=@"等级";
    [_scr addSubview:dengji_lab];
    space=CGRectGetMaxY(dengji_lab.frame);
    for (int i=0; i<[[_dataArr objectAtIndex:2] count]; i++) {
        UIButton *btn_dengji=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), space+10+(i/3)*(heigth_+15), width_, heigth_)];
        btn_dengji.tag=KDengJiBtn_Tag+i;
        [btn_dengji setTitle:[[_dataArr objectAtIndex:2] objectAtIndex:i] forState:UIControlStateNormal];
        [btn_dengji setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
        [btn_dengji setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
        btn_dengji.titleLabel.font=[UIFont systemFontOfSize:16];
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
        
        if(i==[[_dataArr objectAtIndex:2] count]-1) space=CGRectGetMaxY(btn_dengji.frame);
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
        if(i==0 && self.picture_aut==-1) btn_renzheng.selected=YES;
        else if(self.picture_aut==9 && i!=0) btn_renzheng.selected=YES;
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
        if(i==0) tf_.text=self.priceMin_;
        else if (i==1) tf_.text=self.priceMax_;
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

-(void)hiddenView{
    _btn_left.selected=NO;
    _btn_right.selected=NO;
    [self dismiss];
}

-(void)dismiss{
    [_control removeFromSuperview];
    _control=nil;
    [_dv removeFromSuperview];
    _dv=nil;
}

-(void)ChoiceTeSe:(UIButton *)sender{
    //风格id：-1和1-11
    for (int i=0; i<[[_dataArr firstObject] count]; i++) {
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
-(void)ChoiceDengJi:(UIButton *)sender{
    //风格id：-1和1-11
    for (int i=0; i<[[_dataArr firstObject] count]; i++) {
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

-(void)ChoiceJingYan:(UIButton *)sender{
    //户型id：-1和1-11
    for (int i=0; i<[[_dataArr objectAtIndex:1] count]; i++) {
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
    for (int i=0; i<[[_dataArr objectAtIndex:1] count]; i++) {
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
            else self.picture_service=29+i;
            break;
        }
        else continue;
    }
    for (int i=0; i<[[_dataArr objectAtIndex:2] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KDengJiBtn_Tag+i];
        if(btn.selected==YES){
            //空间id：-1和36-46
            if(i==0) self.picture_level=-1;
            else self.picture_level=i;
            break;
        }
        else continue;
    }
    
    for (int i=0; i<[[_dataArr objectAtIndex:3] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KRenZhengBtn_Tag+i];
        if(btn.selected==YES){
            //空间id：-1和36-46
            if(i==0) self.picture_aut=-1;
            else self.picture_aut=9;
            break;
        }
        else continue;
    }
    UITextField *tf_min=(UITextField *)[_scr viewWithTag:KPriceTF_Tag];
    UITextField *tf_max=(UITextField *)[_scr viewWithTag:KPriceTF_Tag+1];
    self.priceMin_=tf_min.text;
    self.priceMax_=tf_max.text;
    if([self.priceMin_ integerValue]<0 || [self.priceMin_ integerValue]>10000){
        [TLToast showWithText:@"最低报价范围0-10000"];
        return;
    }
    else if([self.priceMax_ integerValue]<0 || [self.priceMax_ integerValue]>10000){
        [TLToast showWithText:@"最高报价范围0-10000"];
        return;
    }
    else if([self.priceMin_ integerValue]>[self.priceMax_ integerValue]){
        [TLToast showWithText:@"最低报价不能大于最高报价"];
        return;
    }
    
    _btn_right.selected=NO;
    [self dismiss];
    [self.mtableview launchRefreshing];
}

-(void)tapView:(UIGestureRecognizer *)gesture{
    for(int i=0;i<2;i++){
        UITextField *tf=(UITextField *)[_scr viewWithTag:KPriceTF_Tag+i];
        [tf resignFirstResponder];
    }
}

/***********************************************************************/



-(void)requestForemanlist{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0267\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"sortType\":\"%ld\",\"keyword\":\"%@\",\"experience\":\"%ld\",\"currentPage\":\"%ld\",\"featuresId\":\"%ld\",\"qualificationRating\":\"%ld\",\"auth\":\"%ld\",\"priceMin\":\"%@\",\"priceMax\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)selected_mark,self.searchContent,(long)self.picture_experience,(long)self.currentPage+1,(long)self.picture_service,(long)self.picture_level,(long)self.picture_aut,self.priceMin_,self.priceMax_];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"监理列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==102671) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(self.refreshing==YES && [dataArray count]) [dataArray removeAllObjects];
                        NSArray *arr_=[jsonDict objectForKey:@"supervisorList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                [dataArray addObject:[SupervisorListObj objWithDict:dict]];
                            }
                        }
                        if([dataArray count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [self.mtableview tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [self.mtableview tableViewDidFinishedLoading];
                        }
                        
                        [self.mtableview reloadData];
                        
                    });
                }
                else if (code==10469) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mtableview tableViewDidFinishedLoading];
                        if(![dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [self.mtableview reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mtableview tableViewDidFinishedLoading];
                        if(![dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [self.mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self.mtableview tableViewDidFinishedLoading];
                                  if(![dataArray count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [self.mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

#pragma mark -UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
        view.backgroundColor=[UIColor clearColor];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 10;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    view.backgroundColor=[UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 166;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycellid";
    DesignerListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"DesignerListCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_libiao"]];
        //        cell.backgroundView.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
        //        cell.backgroundView.layer.borderWidth = 1;
        //        cell.backgroundView.layer.masksToBounds = YES;
        //        cell.backgroundView.layer.cornerRadius = 20;
        //        cell.backgroundView.backgroundColor =[UIColor lightGrayColor];
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = YES;
        
    }
    
    if([dataArray count]){
        SupervisorListObj *obj=[dataArray objectAtIndex:indexPath.section];
        
        UIImageView *photo=(UIImageView *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section];
        if(!photo) photo=[[UIImageView alloc]initWithFrame:CGRectMake(14, 15, 45, 45)];
        photo.tag=KButtonTag_phone*2+indexPath.section;
        photo.layer.cornerRadius=22;
        photo.clipsToBounds=YES;
        [photo setOnlineImage:obj.supervisorLogoUrl placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
        [cell addSubview:photo];
        
        if((![obj.mobileNo length])) cell.designer_phone.hidden=YES;
        CGSize size_name=[util calHeightForLabel:obj.nickName width:80 font:[UIFont systemFontOfSize:18]];
        cell.designer_name.text=obj.nickName;
        cell.designer_name.frame =CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_name.frame.origin.y, 80, cell.designer_name.frame.size.height);
        if(obj.experience==nil)
            cell.designer_express.text=[NSString stringWithFormat:@"经验 %@",@"暂无"];
        else
            cell.designer_express.text=[NSString stringWithFormat:@"经验 %@",obj.experience];
        cell.designer_express.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
        //[cell.designer_photo setOnlineImage:obj.designerIconPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
        cell.designer_express.frame =CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+8, cell.designer_express.frame.size.width, cell.designer_express.frame.size.height);

        float width_=0;
        if([obj.authzs count]){
            for(int i=0;i<[obj.authzs count];i++){
                NSDictionary *dict=[obj.authzs objectAtIndex:i];
                UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(cell.designer_name.frame.origin.x+size_name.width+i*34+5, 17, 29, 13)];
                
//                UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(cell.designer_name.frame.origin.x+cell.designer_name.text.length*15+i*34+5, 17, 29, 13)];
//                if (cell.designer_name.text.length*15>61) {
//                    image_rz.frame =CGRectMake(cell.designer_name.frame.origin.x+61+i*34+5, 17, 29, 13);
//                }
                
                image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_new_%@",[dict objectForKey:@"authzId"]]];
                [cell.contentView addSubview:image_rz];
               
                if(i==[obj.authzs count]-1) width_+=CGRectGetMaxX(image_rz.frame);
            }
        }
        
        UIImageView *image_zl=[[UIImageView alloc]initWithFrame:CGRectMake(width_+5, 17, 29, 13)];
        image_zl.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_zlpj_jl_%@",obj.qualificationRating]];
        [cell.contentView addSubview:image_zl];
        
        UILabel *offerlbl=(UILabel *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section+2];
        if(!offerlbl) offerlbl =[[UILabel alloc] initWithFrame:CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+cell.designer_express.frame.size.height+4, cell.designer_express.frame.size.width, 14)];
        offerlbl.font =[UIFont systemFontOfSize:14];
        offerlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
        offerlbl.tag =KButtonTag_phone*2+indexPath.section+2;
        offerlbl.textColor =[UIColor lightGrayColor];
        offerlbl.text =[NSString stringWithFormat:@"报价 %@-%@元/㎡",obj.priceMin,obj.priceMax];
        [cell addSubview:offerlbl];
        
        UILabel *credibilitylbl=(UILabel *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section+1];
        if(!credibilitylbl) credibilitylbl=[[UILabel alloc]initWithFrame:CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+cell.designer_express.frame.size.height+26, 30, 14)];
        credibilitylbl.tag=KButtonTag_phone*2+indexPath.section+1;
        credibilitylbl.font =[UIFont systemFontOfSize:14];
        credibilitylbl.text=@"口碑";
        credibilitylbl.textColor =[UIColor lightGrayColor];
        [cell addSubview:credibilitylbl];
        
        UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(15, credibilitylbl.frame.size.height+credibilitylbl.frame.origin.y+10, kMainScreenWidth-50, 1)];
        footline.backgroundColor =[UIColor colorWithHexString:@"#f1f0f6"];
        [cell addSubview:footline];
        
        cell.view_star.frame =CGRectMake(credibilitylbl.frame.size.width+credibilitylbl.frame.origin.x+5, credibilitylbl.frame.origin.y-4, cell.view_star.frame.size.width, cell.view_star.frame.size.height);
        cell.score_start.frame =CGRectMake(cell.view_star.frame.origin.x+cell.view_star.frame.size.width-10, cell.view_star.frame.origin.y, cell.score_start.frame.size.width, cell.score_start.frame.size.height);
        cell.score_start.textColor =[UIColor colorWithHexString:@"#ef6562"];
//        if(selected_mark!=2){
            NSInteger srat_full=0;
            NSInteger srat_half=0;
            if([obj.supervisorLevel integerValue]<[obj.supervisorLevel floatValue]){
                srat_full=[obj.supervisorLevel integerValue];
                srat_half=1;
            }
            else if([obj.supervisorLevel integerValue]==[obj.supervisorLevel floatValue]){
                srat_full=[obj.supervisorLevel integerValue];
                srat_half=0;
            }
            cell.score_start.text =[NSString  stringWithFormat:@"%.1f",[obj.supervisorLevel floatValue]];
            for(int i=0;i<5;i++){
                if (i <srat_full) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
                    [cell.view_star addSubview:imageView];
                }
                else if (i==srat_full && srat_half!=0) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
                    [cell.view_star addSubview:imageView];
                    
                }
                else {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
                    [cell.view_star addSubview:imageView];
                    
                }
            }
            cell.image_collect.hidden=YES;
            cell.image_brower.hidden=YES;
//        }
//        else{
//            cell.view_star.hidden=YES;
//        }
        
        UIImageView *img_dhua=(UIImageView *)[cell viewWithTag:KButtonTag_phone*3+indexPath.section];
        if(!img_dhua) img_dhua=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3+((kMainScreenWidth-20)/4-40)/2+13*kMainScreenWidth/414, 17, 40, 20)];
        img_dhua.tag=KButtonTag_phone*3+indexPath.section;
        if([obj.state integerValue]==1) img_dhua.image=[UIImage imageNamed:@"bt_yuyue_nor.png"];
        else img_dhua.image=[UIImage imageNamed:@"btn_yuyue_no1"];
        [cell addSubview:img_dhua];
        
        if([obj.state integerValue]==1){
            UIButton *btn_phone=(UIButton *)[cell viewWithTag:kButton_Booking+indexPath.section];
            if(!btn_phone) btn_phone=[[UIButton alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3, 17, (kMainScreenWidth-20)/4, 110)];
            btn_phone.tag=kButton_Booking+indexPath.section;
            [btn_phone addTarget:self action:@selector(pressbtnToGZYYUE:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn_phone];
        }
        
        UILabel *yuyue_lab=(UILabel *)[cell viewWithTag:KUILabelTag_YuYueCount+indexPath.section];
        if(!yuyue_lab) yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(18, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25, 80, 13)];
        if (selected_mark ==2) {
            yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(18, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25,80, 13)];
        }
        yuyue_lab.tag=KUILabelTag_YuYueCount+indexPath.section;
        yuyue_lab.backgroundColor=[UIColor clearColor];
        yuyue_lab.textAlignment=NSTextAlignmentLeft;
        yuyue_lab.font=[UIFont systemFontOfSize:13];
        yuyue_lab.textColor=[UIColor lightGrayColor];
        int length =0;
        
        if([obj.appointmentNum integerValue]>=100000000) {yuyue_lab.text=[NSString stringWithFormat:@"%.1f亿",[obj.appointmentNum floatValue]/100000000.0];
            length =(int)yuyue_lab.text.length -1;
        }
        else if([obj.appointmentNum integerValue]>=10000){ yuyue_lab.text=[NSString stringWithFormat:@"%.1f万",[obj.appointmentNum floatValue]/10000.0];
            length =(int)yuyue_lab.text.length -1;
        }
        else {
            if ([obj.appointmentNum isEqualToString:@"(null)"]) {
                obj.appointmentNum =@"0";
            }
            yuyue_lab.text=[NSString stringWithFormat:@"%@",obj.appointmentNum];
            length =(int)yuyue_lab.text.length;
        }
        yuyue_lab.frame =CGRectMake(((kMainScreenWidth-50)/3-length*13)/2, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25,length*13, 13);
        //        yuyue_lab.backgroundColor =[UIColor redColor];
        yuyue_lab.textAlignment =NSTextAlignmentCenter;
        [cell addSubview:yuyue_lab];
        
        UILabel *yuyue_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(yuyue_lab.frame.origin.x, yuyue_lab.frame.origin.y+yuyue_lab.frame.size.height+9, MAX(length*13, 36), 11)];
        if (length*13<36) {
            yuyue_foot_lab.frame =CGRectMake(yuyue_lab.frame.origin.x+yuyue_lab.frame.size.width/2-33/2, yuyue_foot_lab.frame.origin.y, yuyue_foot_lab.frame.size.width, yuyue_foot_lab.frame.size.height);
        }
        yuyue_foot_lab.textAlignment =NSTextAlignmentCenter;
        yuyue_foot_lab.text =@"预约数";
        yuyue_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
        yuyue_foot_lab.font =[UIFont systemFontOfSize:12];
        //        yuyue_foot_lab.backgroundColor =[UIColor purpleColor];
        [cell addSubview:yuyue_foot_lab];
        
        cell.designer_phone.hidden=YES;
        cell.lab_brower.frame =CGRectMake(yuyue_lab.frame.origin.x+yuyue_lab.frame.size.width-length/2*13+100+(5-length)*13, yuyue_lab.frame.origin.y, 0, 13);
        cell.lab_brower.backgroundColor=[UIColor clearColor];
        cell.lab_brower.textAlignment=NSTextAlignmentCenter;
        cell.lab_brower.font=[UIFont systemFontOfSize:13];
        cell.lab_brower.textColor=[UIColor lightGrayColor];
        length =0;

        if([obj.browsePoints integerValue]>=100000000){
            cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f亿",[obj.browsePoints floatValue]/100000000];
            length =(int)cell.lab_brower.text.length-1;
        }
        else if([obj.browsePoints integerValue]>=10000){ cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f万",[obj.browsePoints floatValue]/10000];
            length =(int)cell.lab_brower.text.length-1;
        }
        else{
            if ([obj.browsePoints isEqualToString:@"(null)"]) {
                obj.browsePoints =@"0";
            }
            cell.lab_brower.text=obj.browsePoints;
            length =(int)cell.lab_brower.text.length;;
        }
        
        cell.lab_brower.frame =CGRectMake((kMainScreenWidth-20)/3*1+((kMainScreenWidth-50)/3-length*13)/2, yuyue_lab.frame.origin.y, length*13, 13);
        UILabel *brower_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(cell.lab_brower.frame.origin.x, cell.lab_brower.frame.origin.y+cell.lab_brower.frame.size.height+9, MAX(length*13, 36), 11)];
        if (length*13<36) {
            brower_foot_lab.frame =CGRectMake(cell.lab_brower.frame.origin.x+cell.lab_brower.frame.size.width/2-36/2, brower_foot_lab.frame.origin.y, brower_foot_lab.frame.size.width, brower_foot_lab.frame.size.height);
        }
        brower_foot_lab.textAlignment =NSTextAlignmentCenter;
        brower_foot_lab.text =@"浏览数";
        brower_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
        brower_foot_lab.font =[UIFont systemFontOfSize:12];
        //        brower_foot_lab.backgroundColor =[UIColor purpleColor];
        [cell addSubview:brower_foot_lab];
        cell.lab_collect.frame =CGRectMake((cell.lab_brower.frame.origin.x+cell.lab_brower.frame.size.width-length/2*13+80+(5-length)*13)*kMainScreenWidth/375, cell.lab_brower.frame.origin.y, 0, 13);
        cell.lab_collect.backgroundColor=[UIColor clearColor];
        cell.lab_collect.textAlignment=NSTextAlignmentCenter;
        cell.lab_collect.font=[UIFont systemFontOfSize:13];
        cell.lab_collect.textColor=[UIColor lightGrayColor];
        length =0;
        if([obj.collectPoints integerValue]>=100000000) {cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f亿",[obj.collectPoints floatValue]/100000000];
            length =(int)cell.lab_collect.text.length-1;
        }
        else if([obj.collectPoints integerValue]>=10000) {cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f万",[obj.collectPoints floatValue]/10000];
            length =(int)cell.lab_collect.text.length-1;
        }
        else{
            if ([obj.collectPoints isEqualToString:@"(null)"]) {
                obj.collectPoints =@"0";
            }
            cell.lab_collect.text=obj.collectPoints;
            length =(int)cell.lab_collect.text.length;
        };
        cell.lab_collect.frame =CGRectMake((kMainScreenWidth-20)/3*2+((kMainScreenWidth-50)/3-length*13)/2, cell.lab_brower.frame.origin.y, length*13, 13);
        
        UILabel *collect_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(cell.lab_collect.frame.origin.x, cell.lab_collect.frame.origin.y+cell.lab_collect.frame.size.height+9, MAX(length*13, 36), 11)];
        if (length*13<36) {
            collect_foot_lab.frame =CGRectMake(cell.lab_collect.frame.origin.x+cell.lab_collect.frame.size.width/2-36/2, collect_foot_lab.frame.origin.y, collect_foot_lab.frame.size.width, collect_foot_lab.frame.size.height);
        }
        collect_foot_lab.textAlignment =NSTextAlignmentCenter;
        collect_foot_lab.text =@"收藏数";
        collect_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
        collect_foot_lab.font =[UIFont systemFontOfSize:12];
        //        collect_foot_lab.backgroundColor =[UIColor purpleColor];
        [cell addSubview:collect_foot_lab];
        
        //        if([obj.state integerValue]==1){
        //            cell.designer_phone.tag=kButton_phone+indexPath.row;
        //            [cell.designer_phone addTarget:self action:@selector(pressbtnTodesigner:) forControlEvents:UIControlEventTouchUpInside];
        //        }
        //        else{
        //            cell.designer_phone.hidden=YES;
        //        }
    }
    
    return cell;
//    static NSString *cellid=@"mycellid";
//    DesignerListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
//    if (cell==nil) {
//        cell=[[[NSBundle mainBundle]loadNibNamed:@"DesignerListCell" owner:nil options:nil]lastObject];
//        cell.backgroundColor=[UIColor clearColor];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_libiao"]];
//    }
//    
//    if([dataArray count]){
//        SupervisorListObj *obj=[dataArray objectAtIndex:indexPath.section];
//        
//        NSString *nameStr;
//        if (obj.nickName.length > 7) {
//            nameStr = [obj.nickName stringByReplacingCharactersInRange:NSMakeRange(8, obj.nickName.length - 8) withString:@"..."];
//        } else {
//            nameStr = obj.nickName;
//        }
//        
//        CGSize size_name=[util calHeightForLabel:nameStr width:170 font:[UIFont systemFontOfSize:17]];
//        cell.designer_name.text=nameStr;
//        if(obj.experience==nil)
//            cell.designer_express.text=[NSString stringWithFormat:@"从业经验：%@",@"暂无"];
//        else
//            cell.designer_express.text=[NSString stringWithFormat:@"从业经验：%@",obj.experience];
//        // [cell.designer_photo setOnlineImage:obj.foremanIconPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over"]];
//        if([obj.authzs count]){
//            for(int i=0;i<[obj.authzs count];i++){
//                NSDictionary *dict=[obj.authzs objectAtIndex:i];
//                UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(25+size_name.width+i*20, 15, 15, 15)];
//                image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_s_%@.png",[dict objectForKey:@"authzId"]]];
//                [cell addSubview:image_rz];
//            }
//        }
//        if(selected_mark==1){
//            NSInteger srat_full=0;
//            NSInteger srat_half=0;
//            if([obj.supervisorLevel integerValue]<[obj.supervisorLevel floatValue]){
//                srat_full=[obj.supervisorLevel integerValue];
//                srat_half=1;
//            }
//            else if([obj.supervisorLevel integerValue]==[obj.supervisorLevel floatValue]){
//                srat_full=[obj.supervisorLevel integerValue];
//                srat_half=0;
//            }
//            for(int i=0;i<5;i++){
//                if (i <srat_full) {
//                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 5, 15, 15)];
//                    [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
//                    [cell.view_star addSubview:imageView];
//                    
//                }
//                else if (i==srat_full && srat_half!=0) {
//                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 5, 15, 15)];
//                    [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
//                    [cell.view_star addSubview:imageView];
//                    
//                }
//                else {
//                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 5, 15, 15)];
//                    [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
//                    [cell.view_star addSubview:imageView];
//                    
//                }
//            }
//            cell.image_collect.hidden=YES;
//            cell.image_brower.hidden=YES;
//        }
//        else{
//            cell.view_star.hidden=YES;
//            if([obj.collectPoints integerValue]>=100000000) cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f亿",[obj.collectPoints floatValue]/100000000];
//            else if([obj.collectPoints integerValue]>=10000) cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f万",[obj.collectPoints floatValue]/10000];
//            else cell.lab_collect.text=obj.collectPoints;
//            
//            if([obj.browsePoints integerValue]>=100000000) cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f亿",[obj.browsePoints floatValue]/100000000];
//            else if([obj.browsePoints integerValue]>=10000) cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f万",[obj.browsePoints floatValue]/10000];
//            else cell.lab_brower.text=obj.browsePoints;
//        }
//        
//        UIImageView *photo=(UIImageView *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section];
//        if(!photo) photo=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3+((kMainScreenWidth-20)/4-50)/2-5, 15, 50, 50)];
//        photo.tag=KButtonTag_phone*2+indexPath.section;
//        photo.layer.cornerRadius=25;
//        photo.clipsToBounds=YES;
//        [photo setOnlineImage:obj.supervisorLogoUrl placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
//        [cell addSubview:photo];
//        
//        UIImageView *img_dhua=(UIImageView *)[cell viewWithTag:KButtonTag_phone*3+indexPath.section];
//        if(!img_dhua) img_dhua=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3+((kMainScreenWidth-20)/4-40)/2-2, 75, 40, 20)];
//        img_dhua.tag=KButtonTag_phone*3+indexPath.section;
//        if([obj.state integerValue]==1) img_dhua.image=[UIImage imageNamed:@"bt_yuyue_nor.png"];
//        else img_dhua.image=[UIImage imageNamed:@"btn_yuyue_no"];
//        [cell addSubview:img_dhua];
//        
//        if([obj.state integerValue]==1){
//            UIButton *btn_phone=(UIButton *)[cell viewWithTag:kButton_Booking+indexPath.section];
//            if(!btn_phone) btn_phone=[[UIButton alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3, 0, (kMainScreenWidth-20)/4, 110)];
//            btn_phone.tag=kButton_Booking+indexPath.section;
//            [btn_phone addTarget:self action:@selector(pressbtnToGZYYUE:) forControlEvents:UIControlEventTouchUpInside];
//            [cell addSubview:btn_phone];
//        }
//        
//        UILabel *yuyue_lab=(UILabel *)[cell viewWithTag:KUILabelTag_YuYueCount+indexPath.section];
//        if(!yuyue_lab) yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 85, kMainScreenWidth/2+20, 20)];
//        if (selected_mark ==1) {
//            yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 59, kMainScreenWidth/2+20, 20)];
//        }
//        yuyue_lab.tag=KUILabelTag_YuYueCount+indexPath.section;
//        yuyue_lab.backgroundColor=[UIColor clearColor];
//        yuyue_lab.textAlignment=NSTextAlignmentLeft;
//        yuyue_lab.font=[UIFont systemFontOfSize:15];
//        yuyue_lab.textColor=[UIColor lightGrayColor];
//        
//        if([obj.appointmentNum integerValue]>=100000000) yuyue_lab.text=[NSString stringWithFormat:@"预  约  数：%.1f亿",[obj.appointmentNum floatValue]/100000000.0];
//        else if([obj.appointmentNum integerValue]>=10000) yuyue_lab.text=[NSString stringWithFormat:@"预  约  数：%.1f万",[obj.appointmentNum floatValue]/10000.0];
//        else yuyue_lab.text=[NSString stringWithFormat:@"预  约  数：%@",obj.appointmentNum];
//        [cell addSubview:yuyue_lab];
//        
//        cell.designer_phone.hidden=YES;
//        //        if([obj.state integerValue]==1){
//        //        cell.designer_phone.tag=kButton_Booking+indexPath.section;
//        //        [cell.designer_phone addTarget:self action:@selector(pressbtnToGZYYUE:) forControlEvents:UIControlEventTouchUpInside];
//        //        }
//        //        else{
//        //            cell.designer_phone.hidden=YES;
//        //        }
//    }
//    
//    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SupervisorListObj *obj_=[dataArray objectAtIndex:indexPath.section  ];
    //    ForemanInfoViewController *infovc=[[ForemanInfoViewController alloc]init];
//    JianliDetailViewController *infovc = [[JianliDetailViewController alloc]init];
    IDIAI3JianLiDetailViewController *infovc =[[IDIAI3JianLiDetailViewController alloc] init];
    //    infovc.formanid=obj_.foremanId;
    infovc.obj=obj_;
   
    [self.navigationController pushViewController:infovc animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    float oldY =cell.frame.origin.y;
    float width = cell.frame.size.width;
    float height = cell.frame.size.height;
    NSLog(@"%lu",(unsigned long)dataArray.count);
    NSLog(@"will =%ld",(long)indexPath.section);
    if (self.dataoldcount==dataArray.count) {
        NSInteger max =MAX(self.willIndexRow, self.endIndexRow);
        NSInteger min =MIN(self.willIndexRow, self.endIndexRow);
        if (min ==0&&max==0) {
            min =0;
            if ((int)Main_Screen_Height%110>0) {
                max =Main_Screen_Height/110-2;
            }else {
                max =Main_Screen_Height/110-1;
            }
        }
        if (indexPath.section>max||indexPath.section<min) {
            cell.frame =CGRectMake(cell.frame.size.width/2-(Main_Screen_Width-50)/2, cell.frame.origin.y+cell.frame.size.height/2-(cell.frame.size.height-20)/2, Main_Screen_Width-50, cell.frame.size.height-20);
            [UIView beginAnimations:@"showcell" context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.3];
            cell.frame =CGRectMake(0, oldY, width+20, height);
            [UIView commitAnimations];
            self.willIndexRow =indexPath.section;
        }
        
    }
    if (indexPath.section<dataArray.count) {
        self.dataoldcount =dataArray.count;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"End=%ld",(long)indexPath.section);
    self.endIndexRow =indexPath.section;
}
#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=0;
        [self requestForemanlist];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestForemanlist];
        }
        else{
            
            [self.mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            self.mtableview.reachedTheEnd = YES;  //是否加载到底了
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=YES;
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    //NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    //创建一个NSDataFormatter显示刷新时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

//上拉加载  Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.mtableview.contentOffset.y<-60) {
        self.mtableview.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [self.mtableview tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.mtableview tableViewDidEndDragging:scrollView];
}

#pragma mark -UIButton

-(void)pressbtnToGZYYUE:(UIButton *)sender{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]) {
        self.selected_btn=sender.tag;
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
    
    SupervisorListObj *obj=[dataArray objectAtIndex:sender.tag-kButton_Booking];
    
    //    SubscribeViewController *subscribeVC = [[SubscribeViewController alloc]initWithNibName:@"SubscribeViewController" bundle:nil];
    //    subscribeVC.businessIDStr = [NSString stringWithFormat:@"%@",obj.foremanId];
    //    subscribeVC.servantRoleIdStr = @"4";
    //    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    //    [appDelegate.nav pushViewController:subscribeVC animated:YES];
    [self requestCheckSubcribeStatus:obj.supervisorId];
    
}


//发送记录呼叫电话信息
-(void)requestRecordCallinfo:(ForemanObj *)obj_{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *postDict01 = [[NSMutableDictionary alloc] init];
        [postDict01 setObject:@"ID0032" forKey:@"cmdID"];
        [postDict01 setObject:string_token forKey:@"token"];
        [postDict01 setObject:string_userid forKey:@"userID"];
        [postDict01 setObject:@"ios" forKey:@"deviceType"];
        [postDict01 setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
        NSString *string01=[postDict01 JSONString];
        
        //获取日期时间
        NSDate *senddate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *locationDate=[dateformatter stringFromDate:senddate];
        //获取主叫号码
        NSString *str_calling;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Mobile] length]>2) str_calling=[[NSUserDefaults standardUserDefaults]objectForKey:User_Mobile];
        else str_calling=@"";
        //获取主叫号码编号
        NSString *str_calling_id;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]) str_calling_id=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        else str_calling_id=@"";
        //获取被叫号码
        NSString *str_called;
        if([obj_.foremanMobile length]>2) str_called=obj_.foremanMobile;
        else str_called=@"";
        //获取被叫号码编号
        NSString *str_called_id;
        if(obj_.foremanId >=0) str_called_id=[NSString stringWithFormat:@"%@",obj_.foremanMobile];
        else str_called_id=@"";
        //获取设备编号
        NSString *str_uuid=[OpenUDID value];
        
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:str_called forKey:@"calledPhone"];
        [postDict02 setObject:str_called_id forKey:@"calledId"];
        [postDict02 setObject:str_uuid forKey:@"mobileUUID"];
        [postDict02 setObject:str_calling_id forKey:@"callingId"];
        [postDict02 setObject:str_calling forKey:@"callingPhone"];
        [postDict02 setObject:locationDate forKey:@"callingDate"];
        [postDict02 setObject:@"1" forKey:@"calledIdenttityType"];
        NSString *string02=[postDict02 JSONString];
        
        NSMutableDictionary *req_dict= [[NSMutableDictionary alloc] init];
        [req_dict setObject:string01 forKey:@"header"];
        [req_dict setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"电话记录：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10321) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
                else if (code==10329) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                              });
                          }
                               method:url postDict:req_dict];
    });
    
    
}

#pragma mark -LoginDelegate

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
    [appDelegate.nav dismissViewControllerAnimated:YES completion:^{
        GongzhangListObj *obj=[dataArray objectAtIndex:self.selected_btn-kButton_Booking];
        
        SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
        subscribeVC.businessIDStr = [NSString stringWithFormat:@"%@",obj.foremanId];
        subscribeVC.servantRoleIdStr = @"6";
        [appDelegate.nav pushViewController:subscribeVC animated:YES];
    }];
//    __weak typeof(self) weakself = self;
//    [weakself.navigationController dismissViewControllerAnimated:YES completion:^{
//        GongzhangListObj *obj=[dataArray objectAtIndex:self.selected_btn-kButton_Booking];
//        
//                SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
//                subscribeVC.businessIDStr = [NSString stringWithFormat:@"%@",obj.foremanId];
//                subscribeVC.servantRoleIdStr = @"6";
//        [weakself.navigationController pushViewController:subscribeVC animated:YES];
//    }];
}

-(void)cancel{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 检查预约状态
-(void)requestCheckSubcribeStatus:(NSString *)designerIdStr {
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
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
        
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0131" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        NSString *string=[postDict JSONString];
        
        NSDictionary *bodyDic = @{@"businessID":designerIdStr,@"servantRoleId":@"6"};
        NSString *string02=[bodyDic JSONString];
        
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setTimeOutSeconds:15];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                // NSLog(@"login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 101311) {
                        [self stopRequest];
                        SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
                        subscribeVC.businessIDStr = designerIdStr;
                        subscribeVC.servantRoleIdStr = @"6";
                        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
                        [appDelegate.nav pushViewController:subscribeVC animated:YES];
//                        [self.navigationController pushViewController:subscribeVC animated:YES];
                        
                    } else if (kResCode == 101319) {
                        [self stopRequest];
                        [TLToast showWithText:@"检查预约状态失败"];
                    } else if (kResCode == 101312) {
                        [self stopRequest];
                        _bookIdStr = [jsonDict objectForKey:@"bookId"];
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"亲，您已预约该监理" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
                        alertView.delegate = self;
                        [alertView show];
                    }
                    
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:post];
    });
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    } else {
        [self requestSubcribeDetail:_bookIdStr];
    }
}

#pragma mark - 预约详情
-(void)requestSubcribeDetail:(NSString *)bookIdStr {
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
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
        
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0107" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"bookId":bookIdStr};
        NSString *string02=[bodyDic JSONString];
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setTimeOutSeconds:15];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                // NSLog(@"login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 101071) {
                        [self stopRequest];
                        SubscribeListModel *model = [SubscribeListModel objectWithKeyValues:[jsonDict objectForKey:@"BookBean"]];
                        
                        MySubscribeDetailViewController *mySubscribeDetailVC = [[MySubscribeDetailViewController alloc]init];
                        SubscribeListModel *subcribeListModel = model;
                        //                        mySubscribeDetailVC.delegate = self;
                        mySubscribeDetailVC.subscribeListModel = subcribeListModel;
                        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                        [delegate.nav pushViewController:mySubscribeDetailVC animated:YES];
                        
                    } else if (kResCode == 101079) {
                        [self stopRequest];
                        [TLToast showWithText:@"查询失败"];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:post];
    });
    
}

#pragma mark - KeyBord

- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat kbSize = rect.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        _scr.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-104-kbSize);
        _dv.frame=CGRectMake(0, 104, kMainScreenWidth, kMainScreenHeight-104-kbSize);
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
        _scr.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-104-kMainScreenWidth/8);
        _dv.frame=CGRectMake(0, 104, kMainScreenWidth, kMainScreenHeight-104);
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

@end
