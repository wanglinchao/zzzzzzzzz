//
//  IDIAI3DiaryMainViewController.m
//  IDIAI
//
//  Created by Ricky on 15/11/16.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3DiaryMainViewController.h"
#import "util.h"
#import "IDIAIAppDelegate.h"
#import "JianliViewController.h"
#import "SearchSupersiorViewController.h"
#import "HRCoreAnimationEffect.h"
#import "SearchListCell.h"
#import "TLToast.h"
#import "IDIAI3DiaryViewController.h"
#import "IDIAI3AddDiaryViewController.h"
#import "LoginView.h"
#define KHISTORY_SS_JianLi @"MyHistory_supersior.plist"
#define KJingYanBtn_Tag 1100
#define KDengJiBtn_Tag 1200
#define KTeSeBtn_Tag 1300
#define KRenZhengBtn_Tag 1600
#define KPriceTF_Tag 1900
@interface IDIAI3DiaryMainViewController ()<ViewPagerDataSource, ViewPagerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,assign)BOOL isshow;
@property(nonatomic,strong)UIImageView *arrowimage;
@property(nonatomic,strong)UILabel *titlelbl;
@property(nonatomic,assign)NSInteger isstyle;
@property(nonatomic,assign)NSInteger selectcount;
@end

@implementation IDIAI3DiaryMainViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:NO animated:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if(self.isShowSearchBar==YES) view_search_bg.hidden=NO;
    else view_search_bg.hidden=YES;
    self.navigationController.view.frame =CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    
    UILabel *titleNav=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleNav.font=[UIFont systemFontOfSize:19];
    titleNav.textColor=[UIColor darkTextColor];
    titleNav.textAlignment=NSTextAlignmentCenter;
    titleNav.text=@"装修论坛";
    self.tabBarController.navigationItem.titleView=titleNav;
    
    //导航右按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(5, 5, 40, 40)];
    [rightButton setImage:[UIImage imageNamed:@"ic_xieriji.png"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self.tabBarController.navigationItem setRightBarButtonItem:rightItem];
    [self.tabBarController.navigationItem setLeftBarButtonItem:nil];
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
    self.dataSource = self;
    self.delegate = self;
    
//    self.tabBarController.title = @"日记";
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [super viewDidLoad];//一定要放在设置代理最后 不然有问题 huangrun
    
    UIButton *showbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    showbtn.frame =CGRectMake(kMainScreenWidth-40, 0, 40, 44);
    showbtn.backgroundColor =[UIColor whiteColor];
    [showbtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label =[[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:16.0];
    label.text = @"筛选";
    label.frame =CGRectMake(0, (showbtn.frame.size.height-15)/2, 36, 15);
//    [showbtn addSubview:label];
    self.arrowimage =[[UIImageView alloc] initWithFrame:CGRectMake((showbtn.frame.size.width-13)/2, (showbtn.frame.size.height-7)/2, 13, 7)];
    self.arrowimage.image =[UIImage imageNamed:@"ic_xiangxia.png"];
    self.arrowimage.tag =100000;
    [showbtn addSubview:self.arrowimage];
   
    
    UIImageView *lineimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 1, showbtn.frame.size.height-20)];
    lineimage.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    [showbtn addSubview:lineimage];
    [self.view addSubview:showbtn];
    
    [self createSearchView];   //创建搜索页
}

-(void)PressBarItemRight{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:User_Token]) {
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
    IDIAI3AddDiaryViewController *adddiary =[[IDIAI3AddDiaryViewController alloc] init];
    adddiary.title =@"写帖子";
    adddiary.hidesBottomBarWhenPushed =YES;
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.nav pushViewController:adddiary animated:YES];
    
}

#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerControllerSeven *)viewPager {
    return 10;
}

- (UIView *)viewPager:(ViewPagerControllerSeven *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    if (index == 0) {
        label.text = @"全部";
    } else if (index == 1) {
        label.text = @"装前准备";
    } else if (index == 2){
        label.text = @"前期设计";
    }else if (index ==3){
        label.text = @"主体拆改";
    }else if (index ==4){
        label.text = @"水电改造";
    }else if (index==5){
        label.text = @"泥木施工";
    }else if (index==6){
        label.text = @"墙面地板";
    }else if (index==7){
        label.text = @"成品安装";
    }else if (index==8){
        label.text = @"软饰搭配";
    }else if (index==9){
        label.text = @"经验总结";
    }

    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8;
    label.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
    label.layer.borderWidth = 1;
    label.frame =CGRectMake(0, 0, 72, 22);
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerControllerSeven *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    IDIAI3DiaryViewController *supervisorVC = [[IDIAI3DiaryViewController alloc]init];
    supervisorVC.labelId =index;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:supervisorVC];
//    self.isstyle =;
    return nav;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerControllerSeven *)viewPager valueForOption:(ViewPagerOption___)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab___:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab___:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation___:
            return 1.0;
            break;
        case ViewPagerOptionTabWidth___:
            if(kMainScreenWidth<=320) return (kMainScreenWidth-40)/3.5;
            else return (kMainScreenWidth-40)/3.501;
//            if(kMainScreenWidth<=320) return kMainScreenWidth/2;
//            else return kMainScreenWidth/2;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerControllerSeven *)viewPager colorForComponent:(ViewPagerComponent___)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator___:
            return [UIColor whiteColor];//kThemeColor;
            break;
        default:
            break;
    }
    
    return color;
}

- (void)viewPager:(ViewPagerControllerSeven *)viewPager didChangeTabToIndex:(NSUInteger)index {
    self.isstyle =index;
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
    self.arrowimage.image =[UIImage imageNamed:@"ic_xiangshang.png"];
//    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if(!_control)_control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kMainScreenHeight - 64, kMainScreenHeight - kTabBarHeight)];
    _control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
    [_control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_control];
    [self.view insertSubview:_control atIndex:1];
    //    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(80, kNavigationBarHeight+0.5, kMainScreenWidth - 80, kMainScreenHeight - kNavigationBarHeight)];
    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(0, -106, kMainScreenWidth , 150)];
    _dv.tag=101;
    _dv.backgroundColor=[UIColor colorWithHexString:@"#f7f7fa" alpha:0.9];
    _dataArr = @[@"全部",@"装前准备",@"前期设计",@"主体拆改",@"水电改造",@"泥木施工",@"墙面地板",@"成品安装",@"软饰搭配",@"经验总结"];
    [self.view addSubview:_dv];
    [self.view insertSubview:_dv atIndex:2];
    [self createChioces];
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.25f]; //动画时长
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //在这里写你的代码.
    _dv.frame =CGRectMake(0, 44, _dv.frame.size.width, _dv.frame.size.height);
    [UIView commitAnimations];
    if (self.titlelbl==nil) {
        self.titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth-40, 44)];
        self.titlelbl.backgroundColor =[UIColor whiteColor];
        self.titlelbl.font =[UIFont systemFontOfSize:13.0f];
        self.titlelbl.text =@"    共10个标签";
        self.titlelbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
        [self.view addSubview:self.titlelbl];
    }
//    [HRCoreAnimationEffect animationPushDown:_dv];
}
-(void)createChioces{
    _scr=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _dv.frame.size.width, _dv.frame.size.height)];
    _scr.backgroundColor=[UIColor clearColor];
    [_dv addSubview:_scr];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [_scr addGestureRecognizer:tap];
    
    float width_=72;
    float heigth_=22;
    int countx =0;
    int county =0;
    for (int i=0; i<[_dataArr count]; i++) {
        UIButton *btn_jingyan=[[UIButton alloc]initWithFrame:CGRectMake(15+((kMainScreenWidth-30-72*3)/2+72)*countx, 15+(heigth_+11)*county, width_, heigth_)];
        btn_jingyan.tag=KJingYanBtn_Tag+i;
        [btn_jingyan setTitle:[_dataArr  objectAtIndex:i] forState:UIControlStateNormal];
        [btn_jingyan setTitleColor:[UIColor colorWithHexString:@"#ef6562" alpha:1.0] forState:UIControlStateSelected];
        [btn_jingyan setTitleColor:[UIColor colorWithHexString:@"#a0a0a0" alpha:1.0] forState:UIControlStateNormal];
        btn_jingyan.backgroundColor =[UIColor whiteColor];
        btn_jingyan.titleLabel.font=[UIFont systemFontOfSize:13];
        //给按钮加一个红色的板框
        if (self.isstyle ==i) {
            btn_jingyan.selected =YES;
        }
        btn_jingyan.layer.masksToBounds = YES;
        btn_jingyan.layer.cornerRadius = 10;
        btn_jingyan.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
        btn_jingyan.layer.borderWidth = 1;
        [btn_jingyan addTarget:self action:@selector(ChoiceJingYan:) forControlEvents:UIControlEventTouchUpInside];
        [_scr addSubview:btn_jingyan];
        countx++;
        if (countx%3==0&&countx!=0) {
            countx=0;
            county++;
        }
    }
    
    
}
-(void)ChoiceJingYan:(UIButton *)sender{
    //户型id：-1和1-11
    sender.selected =!sender.selected;
    for (int i=0; i<[_dataArr count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KJingYanBtn_Tag+i];
        if(sender.tag==btn.tag){
            self.isstyle =i;
            self.tabsView.contentOffset =CGPointMake(i*self.tabWidth, 0);
            [self selectTabViewtag:i];
            [self dismiss];
        }else{
            btn.selected =NO;
        }
    }
}
-(void)dismiss{
    [_control removeFromSuperview];
    _control=nil;
    self.isshow =NO;
    self.arrowimage.image =[UIImage imageNamed:@"ic_xiangxia.png"];
    //_dv.frame=CGRectMake(80, kNavigationBarHeight+0.5, kMainScreenWidth - 80, kMainScreenHeight - kNavigationBarHeight);
    if (self.titlelbl) {
        [self.titlelbl removeFromSuperview];
        self.titlelbl =nil;
    }
    _dv.frame=CGRectMake(0, 44, _dv.frame.size.width, _dv.frame.size.height);
    [UIView animateWithDuration:.25 animations:^{
        //        _dv.frame=CGRectMake(kMainScreenWidth, kNavigationBarHeight+0.5, kMainScreenWidth - 80, kMainScreenHeight - kNavigationBarHeight);
        _dv.frame=CGRectMake(0, -96, kMainScreenWidth , 140);
    } completion:^(BOOL finished) {
        if (finished) {
            [_dv removeFromSuperview];
            _dv=nil;
        }
    }];
}


-(void)RequestData{
    [self dismiss];
    for (UINavigationController *nav in self.contents) {
        if ([nav isKindOfClass:[UINavigationController class]]) {
            JianliViewController *jianliVC =[nav.viewControllers objectAtIndex:0];
//            jianliVC.picture_experience =self.picture_experience;
//            jianliVC.picture_aut =self.picture_aut;
//            jianliVC.picture_service =self.picture_service;
//            jianliVC.picture_level =self.picture_level;
//            jianliVC.priceMin_ =self.priceMin;
//            jianliVC.priceMax_ =self.priceMax;
            jianliVC.searchContent=searchBar.text;
            if([jianliVC.dataArray count]) {
                [jianliVC.dataArray removeAllObjects];
                [jianliVC.mtableview reloadData];
            }
            [jianliVC.mtableview launchRefreshing];
        }
    }
}

-(void)tapView:(UIGestureRecognizer *)gesture{
    for(int i=0;i<2;i++){
        UITextField *tf=(UITextField *)[_scr viewWithTag:KPriceTF_Tag+i];
        [tf resignFirstResponder];
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
    NSString* _filename_  = [doc_path_ stringByAppendingPathComponent:KHISTORY_SS_JianLi];
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
            NSString* _filename_ = [doc_path stringByAppendingPathComponent:KHISTORY_SS_JianLi];
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
        NSString* _filename_  = [doc_path stringByAppendingPathComponent:KHISTORY_SS_JianLi];
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
        NSString* _filename_ = [doc_path stringByAppendingPathComponent:KHISTORY_SS_JianLi];
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
            JianliViewController *jianliVC =[nav.viewControllers objectAtIndex:0];
//            jianliVC.picture_experience =self.picture_experience;
//            jianliVC.picture_aut =self.picture_aut;
//            jianliVC.picture_service =self.picture_service;
//            jianliVC.picture_level =self.picture_level;
            jianliVC.searchContent=@"";
            if([jianliVC.dataArray count]) {
                [jianliVC.dataArray removeAllObjects];
                [jianliVC.mtableview reloadData];
            }
            [jianliVC.mtableview launchRefreshing];
        }
    }
}
@end
