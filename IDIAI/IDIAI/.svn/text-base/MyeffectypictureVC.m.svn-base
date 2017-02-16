//
//  MyeffectypictureVC.m
//  IDIAI
//
//  Created by iMac on 14-7-28.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyeffectypictureVC.h"
#import "HexColor.h"
#import "TMPhotoQuiltViewCell.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "CircleProgressHUD.h"
#import "MyeffectPictureObj.h"
#import "UIImageView+WebCache.h"
#import "EffectPictureInfo.h"
#import "savelogObj.h"
#import "util.h"
#import "HRCoreAnimationEffect.h"
#import "ViewPagerController.h"
#import "IDIAIAppDelegate.h"
#import "UIImageView+OnlineImage.h"
#import "EffectTAOTUPictureInfo.h"
#import "RNFullScreenScroll.h"
#import "UIViewController+RNFullScreenScroll.h"
#import "DesignerInfoObj.h"
#import "IDIAI3DesignerDetailViewController.h"
#import "DesignerViewController.h"
#import "SearchGJSView.h"
#import "CityListObj.h"

#define kcell_tag 100
#define KStyleBtn_Tag 1100
#define KHuXingBtn_Tag 1200
#define KBaoJiaBtn_Tag 1300
#define KChengShiBtn_Tag 1400
#define KSortBtn_Tag 1500
@interface MyeffectypictureVC ()<TMQuiltViewDataSource,TMQuiltViewDelegate,UITableViewDelegate, EffectPicInfoDelegate,SearchGJSViewDelegate>
{
     CircleProgressHUD *phud;
    
//    BOOL *_styleTag;//标记风格是否改变
    NSInteger _browseNum;//点击图酷详情浏览标记
    NSInteger _collectionNum;//点击图酷详情收藏标记
    
    UILabel *_browseTempLabel;
    
  
    
    SearchGJSView *searchVC;
    UIView *view_search_bg;
    UITextField *searchBar;
}
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) UIView *view_bg_style;

@property (nonatomic,strong)UIButton *btn_left;
@property (nonatomic,strong)UIButton *btn_right;

@end

@implementation MyeffectypictureVC
@synthesize picture_title,picture_type;
@synthesize images = _images,view_bg_style,qtmquitView;

-(void)dealloc{
    [qtmquitView setDelegate:nil];
    [qtmquitView setDataSource:nil];
    [_refreshFooterView setDelegate:nil];
    [_refreshHeaderView setDelegate:nil];
    _control=nil;
    if([self.dataArray count]){
        [self.dataArray removeAllObjects];
        self.dataArray=nil;
    }
    [qtmquitView removeFromSuperview];
    qtmquitView=nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)customizeNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"看作品",@" 找设计",nil];
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
}

//具体委托方法实例

-(void)segmentAction:(UISegmentedControl *)Seg{
    if(Seg.selectedSegmentIndex==0){
    
    }
    else{
        _btn_left.selected=NO;
        _btn_right.selected=NO;
        [self dismiss];
        Seg.selectedSegmentIndex=0;
        DesignerViewController *desigerVC=[[DesignerViewController alloc] init];
        [self.navigationController pushViewController:desigerVC animated:NO];
    }
}

- (void)backButtonPressed:(id)sender {
    [self dismiss];
    [phud hide];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:kColorWithRGB(249, 249, 250)];

    if(self.isShowSearchBar==YES) view_search_bg.hidden=NO;
    else view_search_bg.hidden=YES;
    
    [qtmquitView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    view_search_bg.hidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self customizeNavigationBar];
    
    //自定义返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"ic_fh.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    _browseTempLabel = [[UILabel alloc]init];
    
    if([picture_type isEqualToString:@"taotu"]){
        [savelogObj saveLog:@"查看装修方案" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:13];
        self.typeIdInteger=2;
    }
    else {
        [savelogObj saveLog:@"查看效果图" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:34];
        self.typeIdInteger=0;
    }
    
    [self createTopBtn];
    
    qtmquitView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-64-40)];
	qtmquitView.delegate = self;
	qtmquitView.dataSource = self;
    qtmquitView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    qtmquitView.showsHorizontalScrollIndicator=NO;
    qtmquitView.showsVerticalScrollIndicator=NO;
	[self.view addSubview:qtmquitView];
    
	//[qtmquitView reloadData];
    [self createHeaderView];
	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    
    self.dataArray=[NSMutableArray arrayWithCapacity:0];
    
    self.currentPage=0;
    self.searchContent=@"";
    _selected_mark=3;
    
    //风格
    NSInteger row_style=[[[NSUserDefaults standardUserDefaults]objectForKey:kUDEffectyTypeOfRow_Style] integerValue];
    if (row_style == 0) self.picture_style = -1;
    else self.picture_style=row_style;
    
    //户型
    NSInteger row_doorModel=[[[NSUserDefaults standardUserDefaults]objectForKey:kUDEffectyTypeOfRow_DoorModel] integerValue];
    if (row_doorModel == 0) self.picture_doorModel = -1;
    else self.picture_doorModel=11+row_doorModel;
    
    //报价
    NSInteger row_price=[[[NSUserDefaults standardUserDefaults]objectForKey:kUDEffectyTypeOfRow_Price] integerValue];
    if (row_price == 0) self.picture_price = -1;
    else self.picture_price=14+row_price;
    
    self.picture_city=0;
    /*存储城市code码*/
    _arr_cityCode=[NSMutableArray arrayWithCapacity:0];
    [_arr_cityCode addObject:@"-1"];
    
    [self requestPicturelist];
    
//    //设置全屏显示，隐藏导航栏
//    self.fullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:qtmquitView];
//    self.fullScreenScroll.isHideNavgationBar =YES;
    
    [self loadImageviewBG];
    
    [self createSearchTitle];
}

-(void)PressBarItemRight{
    [_control removeFromSuperview];
    _control=nil;
    [_dv removeFromSuperview];
    _dv=nil;
    
    if(!searchVC) searchVC=[[SearchGJSView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) historyData:@"MyHistory_caseOfTaotu.plist" fromName:@"看案例"];
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
    
    if(!searchVC) searchVC=[[SearchGJSView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) historyData:@"MyHistory_caseOfTaotu.plist" fromName:@"看案例"];
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
    self.currentPage=0;
    isrefreshing=YES;
    [self requestPicturelist];
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
    
    self.currentPage=0;
    isrefreshing=YES;
    [self requestPicturelist];
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
    if(!_control)_control = [[UIControl alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight+40, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight-40)];
    _control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
    [_control addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [keywindow addSubview:_control];
    
    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+40, kMainScreenWidth , 0)];
    _dv.tag=101;
    _dv.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    _dataArr = @[@"新作品",@"收藏数",@"浏览数"];
    [keywindow addSubview:_dv];
    
    UIView *lineTop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
    lineTop.backgroundColor=kColorWithRGB(245, 245, 245);
    [_dv addSubview:lineTop];
    
    //[HRCoreAnimationEffect animationPushDown:_dv];
    
    //动画设置位置
    _control.alpha=0.3;
    [UIView animateWithDuration:0.2 animations:^{
        _control.alpha=1.0;
        _dv.frame =  CGRectMake(0, kNavigationBarHeight+40, kMainScreenWidth, 150);
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
        if(_selected_mark == i+3) btn_sort.selected=YES;
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
    //排序id：3-5
    for (int i=0; i<[_dataArr count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KSortBtn_Tag+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
            _selected_mark=i+3;
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
    
    [self dismiss];
    _btn_left.selected=NO;
    self.currentPage=0;
    isrefreshing=YES;
    [self requestPicturelist];
}

#pragma mark - 选择风格

- (void)show {
//    if(_control) {
//        [self dismiss];
//        return;
//    }
    
    /*存储城市名字*/
    NSMutableArray *arr_city=[NSMutableArray arrayWithCapacity:0];
    [arr_city addObject:@"全国"];
    if([_arr_cityCode count]) [_arr_cityCode removeAllObjects];
    [_arr_cityCode addObject:@"-1"];
    IDIAIAppDelegate *appDelegate=(IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    if([appDelegate.array_city_list count]){
        for(CityListObj *obj in appDelegate.array_city_list){
            if(![obj.cityName isEqualToString:@"全国"]){
                [arr_city addObject:obj.cityName];
                [_arr_cityCode addObject:[NSString stringWithFormat:@"%@",obj.cityCode]];
            }
        }
    }
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if(!_control)_control = [[UIControl alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight+40, kMainScreenHeight - 80, kMainScreenHeight - kTabBarHeight)];
    _control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
    [_control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [keywindow addSubview:_control];
    
    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+40, kMainScreenWidth , kMainScreenHeight - kNavigationBarHeight-40)];
    _dv.tag=101;
    _dv.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    
    UIView *lineTop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
    lineTop.backgroundColor=kColorWithRGB(245, 245, 245);
    [_dv addSubview:lineTop];

    _dataArr = @[@[@"不限",@"现代简约",@"田园",@"欧式",@"中式",@"美式",@"地中海",@"东南亚",@"混搭",@"新古典",@"日式"],@[@"不限",@"小户型(<70㎡)",@"普通户型(70-120㎡)",@"大户型(>120㎡)"],@[@"不限",@"经济方案(<100元/㎡)",@"品质方案(100-200元/㎡)",@"奢华方案(>200元/㎡)"],arr_city];
    
    [keywindow addSubview:_dv];
    
   // [HRCoreAnimationEffect animationPushRight:_dv];
    
    //动画设置位置
    _control.alpha=0.3;
    [UIView animateWithDuration:0.2 animations:^{
        _control.alpha=1.0;
        _dv.frame =  CGRectMake(0, kNavigationBarHeight+40, kMainScreenWidth , kMainScreenHeight - kNavigationBarHeight -40);
        [self createChioces];
    }];
}
-(void)createChioces{
    _scr=[[UIScrollView alloc] init];
    _scr.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    [_dv addSubview:_scr];
    float width_=(kMainScreenWidth-40-60)/3;
    float heigth_=32;
    float space=0;

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
        if(self.picture_city == i) btn_chengshi.selected=YES;
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
    
    _scr.frame=CGRectMake(0, 1, CGRectGetWidth(_dv.frame), CGRectGetHeight(_dv.frame)-kMainScreenWidth/8);
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
    [_dv removeFromSuperview];
    _dv=nil;
}

-(void)hiddenView{
    _btn_left.selected=NO;
    _btn_right.selected=NO;
    [self dismiss];
}

-(void)ChoiceStyle:(UIButton *)sender{
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

-(void)ChoiceFinished{
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
            self.picture_city=i;
            break;
        }
        else continue;
    }

    [self dismiss];
    _btn_right.selected=NO;
    self.currentPage=0;
    isrefreshing=YES;
    [self requestPicturelist];
}

/******************************************************/


#pragma mark - 网络加载

-(void)requestPicturelist{
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSInteger cityCodeInteger = [kCityCode integerValue];
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        
        NSInteger cityCode =[_arr_cityCode[self.picture_city] integerValue];
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0121\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":%ld}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\",\"renderingsId\":\"%ld\",\"doorModelId\":\"%ld\",\"offerId\":\"%ld\",\"classificationId\":\"%ld\",\"cityCode\":\"%ld\",\"keyword\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,(long)cityCodeInteger,(long)self.currentPage+1,(long)self.picture_style,(long)self.picture_doorModel,(long)self.picture_price,(long)self.selected_mark,(long)cityCode,self.searchContent];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"图片库返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==11211) {
                    //得到总的页数
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                        self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                        if(isrefreshing==YES && [self.dataArray count]){
                            [self.dataArray removeAllObjects];
                            [qtmquitView reloadData];
                        }
                        
                        if([[jsonDict objectForKey:@"rendreingsList"] count]){
                            for (NSDictionary *dict in [jsonDict objectForKey:@"rendreingsList"]){
                                @autoreleasepool {
                                    [self.dataArray addObject:[MyeffectPictureObj objWithDict:dict]];
                                }
                            }
                            imageview_bg.hidden=YES;
                            label_bg.hidden=YES;
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden=NO;
                        }
                       [phud hide];
                        [self stopRequest];
                        [qtmquitView reloadData];
                        [self removeFooterView];
                        [self testFinishedLoadData];
                    });
                }
                else if (code==11219) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide];
                        [self stopRequest];
                        [qtmquitView reloadData];
                        [self removeFooterView];
                        [self testFinishedLoadData];
                        
                        if([self.dataArray count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden=YES;
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden=NO;
                        }
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide];
                        [self stopRequest];
                        [qtmquitView reloadData];
                        [self removeFooterView];
                        [self testFinishedLoadData];
                        
                        if([self.dataArray count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden=YES;
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden=NO;
                        }
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [phud hide];
                                  [self stopRequest];
                                  [qtmquitView reloadData];
                                  [self removeFooterView];
                                  [self testFinishedLoadData];
                                  
                                  if([self.dataArray count]){
                                      imageview_bg.hidden=YES;
                                      label_bg.hidden=YES;
                                  }
                                  else{
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden=NO;
                                  }
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[qtmquitView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)testFinishedLoadData{
	
    [self finishReloadingData];
    [self setFooterView];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:qtmquitView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:qtmquitView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(qtmquitView.contentSize.height, qtmquitView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              qtmquitView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         qtmquitView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [qtmquitView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
    imageview_bg.hidden=YES;
    label_bg.hidden=YES;
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
      
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data

        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.1];
    }
	
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
//	NSLog(@"刷新完成");
//    [self testFinishedLoadData];

    self.currentPage=0;
    isrefreshing=YES;
    [self requestPicturelist];
	
}
//加载调用的方法
-(void)getNextPageView
{
//	[qtmquitView reloadData];
//    [self removeFooterView];
//    [self testFinishedLoadData];
    if(self.totalPages>self.currentPage){
        isrefreshing=NO;
    [self requestPicturelist];
    }
    else{
        [phud hide];
        [self removeFooterView];
        [self testFinishedLoadData];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //huangrun
    if (scrollView.tag == 101) {
        return;
    }
    
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //huangrun
    if (scrollView.tag == 101) {
        return;
    }
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark -
#pragma mark - TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
	{
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    /****
    float height=0.0;
    if([self.dataArray count]){
        MyeffectPictureObj *obj=[self.dataArray objectAtIndex:indexPath.row];
        height=[obj.rendreingsHeight floatValue];
        if(height<1) height=360;
        //else height=height * 1.3;
    }
    if (self.typeIdInteger+1 == 3 || self.typeIdInteger+1 == 4) {
        return height/[self quiltViewNumberOfColumns:quiltView] + 20;
    }
    return height/[self quiltViewNumberOfColumns:quiltView];
     *****/
    if([picture_type isEqualToString:@"taotu"]) return kMainScreenWidth+120;
    else return 2*(kMainScreenWidth-20)/3+90;
}

- (CGFloat)quiltViewMargin:(TMQuiltView *)quilView marginType:(TMQuiltViewMarginType)marginType{
    if([picture_type isEqualToString:@"taotu"]) return 0;
    else return 0;
}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid=@"mycellid-0";
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:cellid];
    if (!cell) {
        if([self.dataArray count]){
            MyeffectPictureObj *obj=[self.dataArray objectAtIndex:indexPath.row];
            if (self.typeIdInteger+1 == 1 || self.typeIdInteger+1 == 2) {
                cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:cellid index:[obj.designerID integerValue] type:0];
            }
            else if (self.typeIdInteger+1 == 3 || self.typeIdInteger+1 == 4) {
                cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:cellid index:[obj.designerID integerValue] type:1];
            }
            else
                cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:cellid index:[obj.designerID integerValue] type:1];
        }
    }
    
    if([self.dataArray count]){
        MyeffectPictureObj *obj=[self.dataArray objectAtIndex:indexPath.row];
        NSString *placeter_image=[[NSBundle mainBundle]pathForResource:@"bg_taotubeijing@2x" ofType:@"png"];
        NSString *placeter_designer=[[NSBundle mainBundle]pathForResource:@"ic_touxiang_tk@2x" ofType:@"png"];
        
//        cell.photoView.image=[UIImage imageWithContentsOfFile:placeter_image];
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        if (obj.rendreingsPath.length) {
//            [manager downloadImageWithURL:[NSURL URLWithString:obj.rendreingsPath] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                if(image) {
//                    cell.photoView.image=[self imageWithImage:image scaledToSize:CGSizeMake(image.size.width*0.8, image.size.height*0.8)];
//                    //产生逐渐显示的效果
//                    cell.photoView.alpha=0.2;
//                    [UIView animateWithDuration:0.5 animations:^(){
//                        cell.photoView.alpha=1.0;
//                    }completion:^(BOOL finished){
//                        
//                    }];
//                }
//            }];
//        }
        
        [cell.photoView setOnlineImage:obj.rendreingsPath placeholderImage:[UIImage imageNamed:@"bg_taotubeijing"]];

        
        if([obj.designerID integerValue]!=0){
            cell.designer_photoView.hidden=NO;
            cell.Label_designer.hidden=NO;
            if (obj.designerImagePath.length>0) {
                [cell.designer_photoView setOnlineImage:obj.designerImagePath placeholderImage:[UIImage imageWithContentsOfFile:placeter_designer]];
            }else{
                cell.designer_photoView.image =[UIImage imageWithContentsOfFile:placeter_designer];
            }
            
            cell.designer_photoView.tag =1000+indexPath.row;
            if(self.typeIdInteger+1<=2) cell.Label_designer.text =obj.designerName;
            else cell.Label_designer.text =obj.collectionName;
            
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDesignerDetailAction:)];
            cell.designer_photoView.userInteractionEnabled =YES;
            [cell.designer_photoView addGestureRecognizer:tap];
        }
        else{
            NSString *icon=[[NSBundle mainBundle]pathForResource:@"platform_icon@2x" ofType:@"png"];
            cell.designer_photoView.image=[UIImage imageWithContentsOfFile:icon];;
            cell.Label_designer.text=@"屋托邦";
        }
     
        cell.collectIV.image = [UIImage imageNamed:@"ic_xingxing_picture"];
        if([obj.collectionNum integerValue]>=100000000) cell.collectNumLabel.text=[NSString stringWithFormat:@"%0.1f亿",[obj.collectionNum floatValue]/100000000];
        else if([obj.collectionNum integerValue]>=10000) cell.collectNumLabel.text=[NSString stringWithFormat:@"%0.1f万",[obj.collectionNum floatValue]/10000];
        else cell.collectNumLabel.text=[NSString stringWithFormat:@"%@",obj.collectionNum];
        if ([cell.collectNumLabel.text isEqualToString:@"(null)"]) {
             cell.collectNumLabel.text=@"0";
        }
        
        cell.browseNumIV.image = [UIImage imageNamed:@"ic_yanjing_picture"];
        if([obj.browserNum integerValue]>=100000000) cell.browseNumLabel.text=[NSString stringWithFormat:@"%0.1f亿",[obj.browserNum floatValue]/100000000];
        else if([obj.browserNum integerValue]>=10000) cell.browseNumLabel.text=[NSString stringWithFormat:@"%0.1f万",[obj.browserNum floatValue]/10000];
        else cell.browseNumLabel.text=[NSString stringWithFormat:@"%@",obj.browserNum];
        if ([cell.browseNumLabel.text isEqualToString:@"(null)"]) {
            cell.browseNumLabel.text=@"0";
        }
        cell.pictureCountIV.image = [UIImage imageNamed:@"ic_taotuyeshu"];
        cell.pictureCount.text=[NSString stringWithFormat:@"%ld",(long)[obj.collectionCount integerValue]+1];
        
        if (self.typeIdInteger+1 == 1 || self.typeIdInteger+1 == 2) {
            cell.houseDesc.text=obj.description_;
            cell.houseTAndAAndPOrS.text=obj.frameName;
        }
        else{
            cell.houseTAndAAndPOrS.text=[NSString stringWithFormat:@"%@  %@m²  %@元/m²",obj.doorModel,obj.buildingArea,obj.price];
        }
        
    }
    return cell;
}
-(void)showDesignerDetailAction:(UIGestureRecognizer *)sender{
    DesignerInfoObj *obj_=[[DesignerInfoObj alloc] init];
    MyeffectPictureObj *obj=[self.dataArray objectAtIndex:sender.view.tag-1000];
    obj_.designerID =obj.designerID;
    obj_.designerName =obj.designerName;
    //    DesignerInfoVC *infovc=[[DesignerInfoVC alloc]init];
    //    DesignerDetailViewController *infovc = [[DesignerDetailViewController alloc]init];
    //    infovc.obj = obj_;
    IDIAI3DesignerDetailViewController *infovc = [[IDIAI3DesignerDetailViewController alloc]init];
    infovc.obj = obj_;
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
    [appDelegate.nav pushViewController:infovc animated:YES];
//    [self.navigationController pushViewController:infovc animated:YES];
}
- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    MyeffectPictureObj *obj=[self.dataArray objectAtIndex:indexPath.row];
//    obj.browserNum  = [NSString stringWithFormat:@"%d",[obj.browserNum intValue]+1];
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView cellAtIndexPath:indexPath];
    __block MyeffectPictureObj *weakself=obj;
    if(self.typeIdInteger>=2){
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
        EffectTAOTUPictureInfo *effVC=[[EffectTAOTUPictureInfo alloc]init];
        effVC.obj_pic=obj;
      
        effVC.selectDone =^(MyeffectPictureObj *pic_obj){
            weakself=pic_obj;
            [quiltView reloadData];
        };
        [appDelegate.nav pushViewController:effVC animated:YES];//zl
//         [self.navigationController pushViewController:effVC animated:YES];
    }
    else{
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
        EffectPictureInfo *effvc=[[EffectPictureInfo alloc]init];
        effvc.obj_effect=obj;
        effvc.img_=cell.photoView.image;
        [appDelegate.nav pushViewController:effvc animated:YES];
//         [self.navigationController pushViewController:effvc animated:YES];
    }
}

- (void)picDidCollect:(EffectPictureInfo *)effectPicInfo collectNum:(NSInteger)collectNum cell:(UITableViewCell *)cell {
    
    _collectionNum += 1;
    
    if (self.typeIdInteger == -1 || self.typeIdInteger == 2) {
        ((TMPhotoQuiltViewCell *)cell).collectIV.image = [UIImage imageNamed:@"ic_shoucangliang"];
     
        ((TMPhotoQuiltViewCell *)cell).collectNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_collectionNum];
    } else if (self.typeIdInteger == 1) {
        ((TMPhotoQuiltViewCell *)cell).collectIV.image = [UIImage imageNamed:@"ic_liulanliang"];
        _collectionNum = [((TMPhotoQuiltViewCell *)cell).collectNumLabel.text integerValue];
        _collectionNum  = _collectionNum + 1;
        ((TMPhotoQuiltViewCell *)cell).collectNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_collectionNum];
    } else if (self.typeIdInteger == 3) {
        ((TMPhotoQuiltViewCell *)cell).collectIV.image = [UIImage imageNamed:@"ic_shoucangliang"];
        
        ((TMPhotoQuiltViewCell *)cell).collectNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_collectionNum];
        ((TMPhotoQuiltViewCell *)cell).browseNumIV.image = [UIImage imageNamed:@"ic_liulanliang"];
        _browseNum = [((TMPhotoQuiltViewCell *)cell).browseNumLabel.text integerValue];
        _browseNum  = _browseNum + 1;
        ((TMPhotoQuiltViewCell *)cell).browseNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_browseNum];
    }

}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
