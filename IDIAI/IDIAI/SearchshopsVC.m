//
//  SearchshopsVC.m
//  IDIAI
//
//  Created by iMac on 14-8-5.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SearchshopsVC.h"
#import "HexColor.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "TMQuiltView.h"
#import "SearchShopCell.h"
#import "GoodsInfoVC.h"
#import "GoodscategoryVC.h"
#import "SearchgoodsObj.h"
#import "UIImageView+OnlineImage.h"
#import "CircleProgressHUD.h"
#import "savelogObj.h"

@interface SearchshopsVC ()<TMQuiltViewDataSource,TMQuiltViewDelegate,UITextFieldDelegate>
{
	TMQuiltView *qtmquitView;
    
    CircleProgressHUD *phud;
    UIImageView *imageview_bg;
    UILabel *label_bg;
}

@property (nonatomic,strong) UITextField *textf_input;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UIImageView *line_s;
@property (nonatomic, retain) UIImageView *line_t;

@end

@implementation SearchshopsVC
@synthesize progress_index,slider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:YES];
    
    UIImageView *nav_bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"导航条.png"]];
    nav_bg.frame=CGRectMake(0, 20, 320, 44);
    nav_bg.userInteractionEnabled=YES;
    [self.view addSubview:nav_bg];
    
    CGRect frame = CGRectMake(100, 29, 120, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    label.text =@"挑商家";
    [self.view addSubview:label];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(10, 25, 50, 28)];
    leftButton.tag=1;
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回键.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(backTouched:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(260, 28, 30, 30)];
    rightButton.tag=2;
    [rightButton setBackgroundImage:[UIImage imageNamed:@"分享展开按钮.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(backTouched:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:statusBarView];
}

-(void)viewWillAppear:(BOOL)animated{
    [[[self navigationController] navigationBar] setHidden:YES];
}


-(void)backTouched:(UIButton *)btn{
    if(btn.tag==1){
        [phud hide];
    [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag==2) {
        GoodscategoryVC *goodsvc=[[GoodscategoryVC alloc]init];
        goodsvc.entrance_type=@"search";
        [self.navigationController pushViewController:goodsvc animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
    [self customizeNavigationBar];
    [savelogObj saveLog:@"用户执行了商家搜索" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:16];
    
    [self createHeader];
    
    qtmquitView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 64+115,kMainScreenWidth, kMainScreenHeight-64-115)];
	qtmquitView.delegate = self;
	qtmquitView.dataSource = self;
    
    [self createHeaderView];
	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
	
	[self.view addSubview:qtmquitView];
    self.dataArray=[NSMutableArray arrayWithCapacity:0];
    
    [self loadImageviewBG];
    [self createProgressView];
    [self requestshopslist];
    
}

-(void)loadImageviewBG{
    if(!imageview_bg)
        imageview_bg=[[UIImageView alloc]initWithFrame:CGRectMake(40, 190, kMainScreenWidth-80, 200)];
    imageview_bg.tag=111;
    imageview_bg.hidden=YES;
    NSString *url_=[[NSBundle mainBundle]pathForResource:@"ic_moren" ofType:@"png"];
    imageview_bg.image=[UIImage imageWithContentsOfFile:url_];
    [self.view addSubview:imageview_bg];
    if (!label_bg)
        label_bg = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview_bg.frame.origin.y + imageview_bg.frame.size.height + 5, kMainScreenWidth, 21)];
    label_bg.textAlignment = NSTextAlignmentCenter;
    label_bg.font = [UIFont systemFontOfSize:13];
    label_bg.textColor = [UIColor lightGrayColor];
    label_bg.hidden = YES;
    label_bg.text = @"亲，没有找到匹配内容哟";
    [self.view addSubview:label_bg];

}

-(void)createProgressView{
    if(!phud)
        phud=[[CircleProgressHUD alloc]initWithFrame:CGRectMake(100, 180, 120, 120) title:nil];
    [phud show];
}

-(void)createHeader{
    UIView *top_view=[[UIView alloc]initWithFrame:CGRectMake(20, 64, kMainScreenWidth-40, 120)];
    top_view.backgroundColor=[UIColor clearColor];
    [self.view addSubview:top_view];
    
    UIImageView *imv_text=[[UIImageView alloc]initWithFrame:CGRectMake(0,10 , 280, 40)];
    imv_text.image=[UIImage imageNamed:@"搜索商家输入框.png"];
    imv_text.userInteractionEnabled=YES;
    [top_view addSubview:imv_text];
    
    self.textf_input=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, 240, 40)];
    self.textf_input.textColor=[UIColor colorWithHexString:@"#926b58" alpha:1.0];
    self.textf_input.delegate=self;
    self.textf_input.placeholder=@"商品";
    self.textf_input.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textf_input.borderStyle = UITextBorderStyleNone;
    self.textf_input.returnKeyType = UIReturnKeySearch;
    self.textf_input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [top_view addSubview:self.textf_input];
    
    UIButton *btn_search = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_search setFrame:CGRectMake(245,16 , 30, 30)];
    [btn_search setBackgroundImage:[UIImage imageNamed:@"搜索商家图标.png"] forState:UIControlStateNormal];
    [btn_search addTarget:self
                   action:@selector(presssearch)
         forControlEvents:UIControlEventTouchUpInside];
    [top_view addSubview:btn_search];
    
    NSArray *arr_name=[NSArray arrayWithObjects:@"木工材料",@"贴砖材料",@"墙面地板",@"厨卫灯具", nil];
    for (int i=0; i<[arr_name count]; i++) {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake((65+8)*i, 60, 65, 20)];
        lab.text=[arr_name objectAtIndex:i];
        lab.font=[UIFont systemFontOfSize:13];
        lab.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];
        lab.textAlignment=NSTextAlignmentCenter;
        [top_view addSubview:lab];
    }
    
    UIImageView *slider_bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"slider_bg.png"]];
    slider_bg.frame=CGRectMake(0, 90, kMainScreenWidth-40, 20);
    [top_view addSubview:slider_bg];
    
    UIImageView *line_f=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"slider_color.png"]];
    line_f.frame=CGRectMake(1, 90, 2, 18);
    [top_view addSubview:line_f];
    self.line_s=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"slider_color.png"]];
    self.line_s.frame=CGRectMake(93, 90, 2, 18);
    self.line_s.hidden=YES;
    [top_view addSubview:self.line_s];
    self.line_t=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"slider_color.png"]];
    self.line_t.frame=CGRectMake(185, 90, 2, 18);
    self.line_t.hidden=YES;
    [top_view addSubview:self.line_t];
    
    slider=[[UISlider alloc]initWithFrame:CGRectMake(-1, 89, kMainScreenWidth-39, 21)];
    if([progress_index integerValue]-5==0) slider.value=0.0;
    if([progress_index integerValue]-5==1) slider.value=0.33333333;
    if([progress_index integerValue]-5==2) slider.value=0.66666667;
    if([progress_index integerValue]-5==3) slider.value=1.0;
    slider.minimumValue=0.0;
    slider.maximumValue=1.0;
    [slider setThumbImage:[UIImage imageNamed:@"slider_btn.png"] forState:UIControlStateNormal];
    [slider setMinimumTrackImage:[UIImage imageNamed:@"slider_color.png"] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage imageNamed:@"track.png"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderchanged) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(sliderchangedleave) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(sliderchangedout) forControlEvents:UIControlEventTouchUpOutside];
    [top_view addSubview:slider];
    
}

-(void)sliderchanged{
    if(slider.value<0.33333333){
        self.line_s.hidden=YES;
        self.line_t.hidden=YES;
    }
    if(slider.value>0.33333333 && slider.value<0.66666667){
        self.line_s.hidden=NO;
        self.line_t.hidden=YES;
    }
    if(slider.value>0.66666667){
        self.line_s.hidden=NO;
        self.line_t.hidden=NO;
    }
}
-(void)sliderchangedleave{
    if(slider.value<=0.16666667) {
        slider.value=0.0;
        progress_index=@"5";
    }
    if(slider.value>0.16666667 && slider.value<0.5) {
        slider.value=0.33333333;
        progress_index=@"6";
    }
    if(slider.value>=0.5 && slider.value<0.833) {
        slider.value=0.66666667;
        progress_index=@"7";
    }
    if(slider.value>=0.833) {
        slider.value=1.0;
        progress_index=@"8";
    }
    [self createProgressView];
    [self requestshopslist];
    [savelogObj saveLog:@"用户执行了商家搜索" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:16];
}
-(void)sliderchangedout{
    if(slider.value<=0.16666667) {
        slider.value=0.0;
        progress_index=@"5";
    }
    if(slider.value>0.16666667 && slider.value<0.5) {
        slider.value=0.33333333;
        progress_index=@"6";
    }
    if(slider.value>=0.5 && slider.value<0.833) {
        slider.value=0.66666667;
        progress_index=@"7";
    }
    if(slider.value>=0.833) {
        slider.value=1.0;
        progress_index=@"8";
    }
    [self createProgressView];
    [self requestshopslist];
    [savelogObj saveLog:@"用户执行了商家搜索" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:16];
}

-(void)requestshopslist{
    [self.dataArray removeAllObjects];
    
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *string_token;
        NSString *string_userid;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length] &&[[NSUserDefaults standardUserDefaults] objectForKey:User_ID]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0002\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"phaseID\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],progress_index];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
              //  NSLog(@"message返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10021) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *array=[jsonDict objectForKey:@"businessList"];
                        if([array count]){
                            for(NSDictionary *dict in array){
                                [self.dataArray addObject:[SearchgoodsObj objWithDict:dict]];
                            }
                        }
                        [phud hide];
                        imageview_bg.hidden=YES;
                        label_bg.hidden = YES;
                        [self testFinishedLoadData];
                        [qtmquitView reloadData];
                    });
                }
                else if (code==10029) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide];
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [qtmquitView reloadData];
                        [self testFinishedLoadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide];
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [qtmquitView reloadData];
                       [self testFinishedLoadData];
                        
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [phud hide];
                                  if(![self.dataArray count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [qtmquitView reloadData];
                                [self testFinishedLoadData];
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
    //[self setFooterView];
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
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
        [self createProgressView];
        imageview_bg.hidden=YES;
        label_bg.hidden = YES;
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
    [self createProgressView];
    [self requestshopslist];
}
//加载调用的方法
-(void)getNextPageView
{
   
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
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
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    SearchShopCell *cell = (SearchShopCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[SearchShopCell alloc] initWithReuseIdentifier:@"SearchShopCell" index:indexPath.row];
    }
    if([self.dataArray count]){
        SearchgoodsObj *obj=[self.dataArray objectAtIndex:indexPath.row];
        [cell.photoView setOnlineImage:obj.businessTypeLogoPath placeholderImage:[UIImage imageNamed:@"设计师图集默认图片.png"]];
        cell.Label_designer.text=obj.businessTypeName;
    }
    return cell;
}


#pragma mark - TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
	
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
	{
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0/[self quiltViewNumberOfColumns:quiltView];
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    SearchgoodsObj *obj=[self.dataArray objectAtIndex:indexPath.row];
    GoodsInfoVC *goodvc=[[GoodsInfoVC alloc]init];
    goodvc.business_id=obj.businessTypeId;
    goodvc.search_content=@"";
    goodvc.title_lab=obj.businessTypeName;
    [self.navigationController pushViewController:goodvc animated:YES];
}

#pragma mark -
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIWindow *keywindow=[[UIApplication sharedApplication] keyWindow];
    UIControl *ctr=(UIControl *)[keywindow viewWithTag:88];
    [ctr removeFromSuperview];
    ctr=nil;
    
    [savelogObj saveLog:@"用户执行了商家搜索" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:16];
    [self.view endEditing:YES];
    if(textField.text.length){
    GoodsInfoVC *goodvc=[[GoodsInfoVC alloc]init];
    goodvc.business_id=@"";
    goodvc.search_content=textField.text;
    goodvc.title_lab=self.textf_input.text;
    [self.navigationController pushViewController:goodvc animated:YES];
    textField.text=@"";
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIControl *control=[[UIControl alloc]initWithFrame:self.view.bounds];
    [control addTarget:self action:@selector(tapControl) forControlEvents:UIControlEventTouchUpInside];
    control.tag=88;
    UIWindow *keywindow=[[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:control];
    
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)tapControl{
    UIWindow *keywindow=[[UIApplication sharedApplication] keyWindow];
    UIControl *ctr=(UIControl *)[keywindow viewWithTag:88];
    [ctr removeFromSuperview];
    ctr=nil;
    [self.view endEditing:YES];
}

-(void)presssearch{
    UIWindow *keywindow=[[UIApplication sharedApplication] keyWindow];
    UIControl *ctr=(UIControl *)[keywindow viewWithTag:88];
    [ctr removeFromSuperview];
    ctr=nil;
    
    [savelogObj saveLog:@"用户执行了商家搜索" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:16];
    [self.view endEditing:YES];
    if(self.textf_input.text.length){
        GoodsInfoVC *goodvc=[[GoodsInfoVC alloc]init];
        goodvc.business_id=@"";
        goodvc.search_content=self.textf_input.text;
        goodvc.title_lab=self.textf_input.text;
        [self.navigationController pushViewController:goodvc animated:YES];
        self.textf_input.text=@"";
    }
 
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
