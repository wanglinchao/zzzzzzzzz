//
//  WaytotravelViewController.m
//  IDIAI
//
//  Created by iMac on 14-10-17.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "WaytotravelViewController.h"
#import "HexColor.h"
#import "util.h"
#import "WaytomapViewController.h"
#import "WaytoTrvelCell.h"
#import "savelogObj.h"
#import "MBProgressHUD.h"

#define kButtonTag 100

@interface WaytotravelViewController ()
{
    MBProgressHUD *phud;
}

@property (nonatomic, strong) UIView *view_header;
@property (nonatomic, strong) UILabel *start_lab;
@property (nonatomic, strong) UILabel *end_lab;
@property (nonatomic, strong) UIImageView *image_loction_start;
@property (nonatomic, strong) UIImageView *image_loction__end;

@end

@implementation WaytotravelViewController
@synthesize startingAdd,endingAdd,wayType,currentCity;
@synthesize image_loction__end,image_loction_start;
@synthesize loctaionPt_self,loctaionPt_shop;

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:NO];
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor darkGrayColor];
    lab_nav_title.text=@"出行方式";
    self.navigationItem.titleView = lab_nav_title;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillDisappear:(BOOL)animated {
    _routesearch.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithHexString:@"#F0F0F0" alpha:1.0];
    [self customizeNavigationBar];
    
    [savelogObj saveLog:@"商家路径规划" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:26];
    
    _routesearch = [[BMKRouteSearch alloc]init];
    
    self.dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.dataPoint=[[NSMutableArray alloc]initWithCapacity:0];
    mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.delegate=self;
    mtableview.dataSource=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [mtableview setSeparatorInset:UIEdgeInsetsMake( 0, 0, 0, 0)];
    [self.view addSubview:mtableview];
    
    ischanged=YES;
    [self createHeaderView];
    
    if([wayType isEqualToString:@"公交"]) {
        [self onClickBusSearch];
    }
    else if([wayType isEqualToString:@"步行"]){
        [self onClickWalkSearch];
    }
    else if([wayType isEqualToString:@"驾车"]){
        [self onClickDriveSearch];
    }
}

-(void)createHeaderView{
    self.view_header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 150)];
    self.view_header.backgroundColor=[UIColor clearColor];
    mtableview.tableHeaderView=self.view_header;
    
    image_loction_start=[[UIImageView alloc]initWithFrame:CGRectMake(14, 17, 20, 20)];
    image_loction_start.image=[UIImage imageNamed:@"ic_weizhi"];
    [self.view_header addSubview:image_loction_start];
    UIImageView *image_top_=[[UIImageView alloc]initWithFrame:CGRectMake(18, 36, 10, 30)];
    image_top_.image=[UIImage imageNamed:@"ic_qzweizhi_list"];
    [self.view_header addSubview:image_top_];
    image_loction__end=[[UIImageView alloc]initWithFrame:CGRectMake(18, 70, 10, 10)];
    image_loction__end.image=[UIImage imageNamed:@"ic_dt_yuandian"];
    [self.view_header addSubview:image_loction__end];
    
    self.start_lab=[[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-220)/2-3, 5, 220, 40)];
    self.start_lab.backgroundColor=[UIColor clearColor];
    self.start_lab.font=[UIFont systemFontOfSize:15];
    self.start_lab.text=startingAdd;
    self.start_lab.textColor=[UIColor blackColor];
    self.start_lab.textAlignment=NSTextAlignmentLeft;
    self.start_lab.lineBreakMode=NSLineBreakByTruncatingMiddle;
    [self.view_header addSubview:self.start_lab];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(50, 50, kMainScreenWidth-120, 1)];
    line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:1.0];
    [self.view_header addSubview:line];
    
    self.end_lab=[[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-220)/2, 55, 220, 40)];
    self.end_lab.backgroundColor=[UIColor clearColor];
    self.end_lab.font=[UIFont systemFontOfSize:15];
    self.end_lab.text=endingAdd;
    self.end_lab.textColor=[UIColor grayColor];
    self.end_lab.textAlignment=NSTextAlignmentLeft;
    self.end_lab.lineBreakMode=NSLineBreakByTruncatingMiddle;
    [self.view_header addSubview:self.end_lab];
    
    UIButton *btn_qh=[UIButton buttonWithType:UIButtonTypeCustom];
    btn_qh.frame=CGRectMake(kMainScreenWidth-40, 32, 35, 35);
    [btn_qh setBackgroundImage:[UIImage imageNamed:@"ic_jiaohuanweizhi"] forState:UIControlStateNormal];
    [btn_qh setBackgroundImage:[UIImage imageNamed:@"ic_jiaohuanweizhi_pressed"] forState:UIControlStateHighlighted];
    [btn_qh addTarget:self action:@selector(pressbtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view_header addSubview:btn_qh];
    //方式线
    UIView *line_top=[[UIView alloc]initWithFrame:CGRectMake(0, 97, kMainScreenWidth, 0.5)];
    line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
    [self.view_header addSubview:line_top];
    
    UIView *view_small=[[UIView alloc]initWithFrame:CGRectMake(0, 100, kMainScreenWidth, 50)];
    view_small.backgroundColor=[UIColor colorWithWhite:1.0 alpha:1.0];
    [self.view_header addSubview:view_small];
    
    NSArray *arr_btn=[NSArray arrayWithObjects:@"步行",@"驾车",@"公交", nil];
    for (int i=0; i<[arr_btn count]; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(kMainScreenWidth/3*i,110, kMainScreenWidth/3, 30);
        btn.backgroundColor=[UIColor clearColor];
        btn.tag=kButtonTag+i;
        [btn setTitle:[arr_btn objectAtIndex:i] forState:UIControlStateNormal];
        if([wayType isEqualToString:@"步行"] && i==0)
           [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        else if([wayType isEqualToString:@"驾车"] && i==1)
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        else if([wayType isEqualToString:@"公交"] && i==2)
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        else[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(ClickontheWaycheme:) forControlEvents:UIControlEventTouchUpInside];
        [self.view_header addSubview:btn];
    }

    UIView *line_bottom=[[UIView alloc]initWithFrame:CGRectMake(0, 150, kMainScreenWidth, 0.5)];
    line_bottom.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
    [self.view_header addSubview:line_bottom];
    
    [self loadPrompt];
}

//显示加载提示
-(void)loadPrompt{
    /*
    if(!view_ts)
        view_ts=[[UIView alloc]initWithFrame:CGRectMake((kMainScreenWidth-90)/2, kMainScreenHeight-250, 90, 20)];
    view_ts.backgroundColor=[UIColor clearColor];
    [self.view_header addSubview:view_ts];
    
    UIActivityIndicatorView *activityindic =(UIActivityIndicatorView *)[view_ts viewWithTag:1000];
    if(!activityindic)
        activityindic =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityindic.hidesWhenStopped=YES;
    activityindic.tag=1000;
    activityindic.center=CGPointMake(10, 10);
    [activityindic startAnimating];
    [view_ts addSubview:activityindic];
    
    UILabel *lab_ts=(UILabel *)[view_ts viewWithTag:1001];
    if(!lab_ts)
        lab_ts=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 70, 20)];
    lab_ts.backgroundColor=[UIColor clearColor];
    lab_ts.textAlignment=NSTextAlignmentCenter;
    lab_ts.font=[UIFont systemFontOfSize:13];
    lab_ts.tag=1001;
    lab_ts.textColor=[UIColor blackColor];
    lab_ts.text=@"正在载入...";
    [view_ts addSubview:lab_ts];
     */
    
    if (!phud) {
        phud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:phud];
        phud.mode=MBProgressHUDModeIndeterminate;
       // phud.dimBackground=YES; //是否开启背景变暗
        phud.labelText = @"路线请求中...";
        phud.blur=NO;  //是否开启ios7毛玻璃风格
        phud.darkBlur=NO; //受blur限制（blur为YES时设置darkBlur才有用）
        [phud show:YES];
    }
    else{
        [phud show:YES];
    }
}

-(void)removePrompt{
    /*
    UIActivityIndicatorView *activityindic =(UIActivityIndicatorView *)[view_ts viewWithTag:1000];
    [activityindic stopAnimating];
    [activityindic removeFromSuperview];
    activityindic=nil;
    UILabel *lab_ts=(UILabel *)[view_ts viewWithTag:1001];
    [lab_ts removeFromSuperview];
    lab_ts=nil;
    [view_ts removeFromSuperview];
    view_ts=nil;
     */
    [phud hide:YES];
}

-(void)pressbtn{
    [self removeWalkts];
    [self loadPrompt];
    
    if (ischanged==YES) {
        [UIView animateWithDuration:0.3 animations:^{
            self.start_lab.frame=CGRectMake((kMainScreenWidth-220)/2-3, 55, 220, 40);
            self.end_lab.frame=CGRectMake((kMainScreenWidth-220)/2, 5, 220, 40);
            image_loction_start.frame=CGRectMake(14, 70, 20, 20);
            image_loction__end.frame=CGRectMake(18, 20, 10, 10);
            
        }completion:^(BOOL finished){
            
        }];
        ischanged=!ischanged;
        startingAdd=self.end_lab.text;
        endingAdd=self.start_lab.text;
        CLLocationCoordinate2D loctaionPt;
        loctaionPt=loctaionPt_self;
        loctaionPt_self=loctaionPt_shop;
        loctaionPt_shop=loctaionPt;
        if([self.dataPoint count]) [self.dataPoint removeAllObjects];
        if ([self.dataArray count]) [self.dataArray removeAllObjects];
        [mtableview reloadData];
        
        if([wayType isEqualToString:@"公交"]){
            [self onClickBusSearch];
        }
        else if ([wayType isEqualToString:@"驾车"]){
            [self onClickDriveSearch];
        }
        else{
            [self onClickWalkSearch];
        }
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            self.start_lab.frame=CGRectMake((kMainScreenWidth-220)/2-3, 5, 220, 40);
            self.end_lab.frame=CGRectMake((kMainScreenWidth-220)/2, 55, 220, 40);
            image_loction_start.frame=CGRectMake(14, 17, 20, 20);
            image_loction__end.frame=CGRectMake(18, 70, 10, 10);
        }completion:^(BOOL finished){
            
        }];
        ischanged=!ischanged;
        startingAdd=self.start_lab.text;
        endingAdd=self.end_lab.text;
        CLLocationCoordinate2D loctaionPt;
        loctaionPt=loctaionPt_self;
        loctaionPt_self=loctaionPt_shop;
        loctaionPt_shop=loctaionPt;
        if([self.dataPoint count]) [self.dataPoint removeAllObjects];
        if ([self.dataArray count]) [self.dataArray removeAllObjects];
        [mtableview reloadData];
        
        if([wayType isEqualToString:@"公交"]){
            [self onClickBusSearch];
        }
        else if ([wayType isEqualToString:@"驾车"]){
            [self onClickDriveSearch];
        }
        else{
            [self onClickWalkSearch];
        }

    }
}

-(void)ClickontheWaycheme:(UIButton *)btn{
    
    if(btn.tag==kButtonTag) {
        if(![wayType isEqualToString:@"步行"]){
            [self removeWalkts];
            [self loadPrompt];
            if([self.dataArray count]){
                [self.dataArray removeAllObjects];
                [mtableview reloadData];
            }
            if([self.dataPoint count]) [self.dataPoint removeAllObjects];
            [self onClickWalkSearch];
        }
        wayType=@"步行";
        for (int i=0; i<3; i++) {
            UIButton *btn_=(UIButton *)[self.view_header viewWithTag:kButtonTag+i];
            if(btn.tag-kButtonTag==i) [btn_ setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            else [btn_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
    else if(btn.tag==kButtonTag+1){
        if(![wayType isEqualToString:@"驾车"]){
            [self removeWalkts];
            [self loadPrompt];
            if([self.dataArray count]){
                [self.dataArray removeAllObjects];
                [mtableview reloadData];
            }
            if([self.dataPoint count]) [self.dataPoint removeAllObjects];
            [self onClickDriveSearch];
        }
        wayType=@"驾车";
        for (int i=0; i<3; i++) {
            UIButton *btn_=(UIButton *)[self.view_header viewWithTag:kButtonTag+i];
            if(btn.tag-kButtonTag==i) [btn_ setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            else [btn_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    else if(btn.tag==kButtonTag+2){
        if(![wayType isEqualToString:@"公交"]) {
            [self removeWalkts];
            [self loadPrompt];
            if([self.dataArray count]){
                [self.dataArray removeAllObjects];
                [mtableview reloadData];
            }
            if([self.dataPoint count]) [self.dataPoint removeAllObjects];
            [self onClickBusSearch];
        }
        wayType=@"公交";
        for (int i=0; i<3; i++) {
            UIButton *btn_=(UIButton *)[self.view_header viewWithTag:kButtonTag+i];
            if(btn.tag-kButtonTag==i) [btn_ setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            else [btn_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark -
#pragma mark - SearchWay

//搜索公交线路
-(void)onClickBusSearch{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt=loctaionPt_self;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt=loctaionPt_shop;
    
    /*
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = @"成华区建设路71号";
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name =@"SM广场" ;
    */
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= currentCity;
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    transitRouteSearchOption.transitPolicy=BMK_TRANSIT_TIME_FIRST;
    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
    if(flag)
    {
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
    }

}

//搜索步行路线
-(void)onClickWalkSearch{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt=loctaionPt_self;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt=loctaionPt_shop;
   
    /*
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name =@"SM广场";
    start.cityName = @"成都市";
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = @"成华区建设路71号";
    end.cityName = @"成都市";
     */
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }

}

//搜索驾车路线
-(void)onClickDriveSearch{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt=loctaionPt_self;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt=loctaionPt_shop;
    
    /*
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name =@"SM广场" ;
    start.cityName = @"成都市";
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name =@"静安区北京西路819号北泰电信大楼";
    end.cityName = @"上海市";
     */
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    drivingRouteSearchOption.drivingPolicy=BMK_DRIVING_TIME_FIRST;
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *cellID=@"mycell";
    WaytoTrvelCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"WaytoTrvelCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(20, 69.5, kMainScreenWidth-20, 0.5)];
        line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        [cell addSubview:line];
    }
    
    if([self.dataArray count]){
    if([wayType isEqualToString:@"公交"]){
    cell.titleName.text=[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"nameString"];
    cell.subLab_first.text=[NSString stringWithFormat:@"%@分钟",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"timeString"]];
    cell.subLab_second.text=[NSString stringWithFormat:@"步行%@米",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"distance"]];
    cell.imageView_first.image=[UIImage imageNamed:@"ic_shjian"];
    cell.imageView_second.image=[UIImage imageNamed:@"ic_juli"];
    }
    else if ([wayType isEqualToString:@"驾车"]){
        cell.titleName.text=[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"nameString"];
        cell.subLab_first.text=[NSString stringWithFormat:@"%@分钟",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"timeString"]];
        cell.subLab_second.text=[NSString stringWithFormat:@"%@公里",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"distance"]];
        cell.imageView_first.image=[UIImage imageNamed:@"ic_shjian"];
        cell.imageView_second.image=[UIImage imageNamed:@"ic_juli"];
    }
    else{
        cell.titleName.text=[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"nameString"];
        cell.subLab_first.text=[NSString stringWithFormat:@"%@分钟",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"timeString"]];
        cell.subLab_second.text=[NSString stringWithFormat:@"%@公里",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"distance"]];
        cell.imageView_first.image=[UIImage imageNamed:@"ic_shjian"];
        cell.imageView_second.image=[UIImage imageNamed:@"ic_buxingyongshi"];
    }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.dataArray count]){
    WaytomapViewController *waymap=[[WaytomapViewController alloc]init];
    if([wayType isEqualToString:@"公交"])
        waymap.plan_trans=[self.dataPoint objectAtIndex:indexPath.row];
    else if ([wayType isEqualToString:@"驾车"])
         waymap.plan_drive=[self.dataPoint objectAtIndex:indexPath.row];
    else
         waymap.plan_walk=[self.dataPoint objectAtIndex:indexPath.row];
    waymap.tranvel_type=wayType;
    waymap.data_Arr=[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"sub_thing"];
    [self.navigationController pushViewController:waymap animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - BMKSearchResultDelegate

//公交方案结果
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    [self removePrompt];
   
    if (error == BMK_SEARCH_NO_ERROR) {
         if([self.dataArray count]) [self.dataArray removeAllObjects];
        if([result.routes count]){
        for(int j=0; j<[result.routes count];j++){
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:j];
        [self.dataPoint addObject:plan];
        // 计算路线方案中的路段数目
        NSUInteger size = [plan.steps count];
        NSString *str_time=[NSString stringWithFormat:@"%.1f",(plan.duration.seconds+plan.duration.minutes*60+plan.duration.hours*3600+plan.duration.dates*24*3600)/60.0];
        NSMutableString *str_name_sub=[NSMutableString stringWithCapacity:0];
        int int_distance=0;
        NSMutableArray *array=[NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            NSLog(@"%@",transitStep.instruction);
                /*
                 BMK_BUSLINE                 = 0,///公交
                 BMK_SUBWAY                  = 1,///地铁
                 BMK_WAKLING                 = 2,///步行
                */
            //计算换乘路线
            if(transitStep.vehicleInfo.title.length>=1){
                [str_name_sub appendFormat:@"%@->",transitStep.vehicleInfo.title];
            }
            
            //计算步行线路距离
            NSRange range03=[transitStep.instruction rangeOfString:@"步行"];
            NSRange range04=[transitStep.instruction rangeOfString:@"米"];
            if(range03.length>1&&range04.length>=1){
               int_distance +=[[transitStep.instruction substringWithRange:NSMakeRange(range03.location+range03.length, range04.location-range03.location-2)] integerValue];
            }
            //计算起点、终点、各个乘坐站点
            NSString *str_main=@"";
            NSString *str_sub=@"";
            if(i == 0) {
                str_main=@"起点";
                str_sub=[self filterHTML:transitStep.instruction];
            }
           else if(i == size-1) {
                str_main=@"终点";
                str_sub=[self filterHTML:transitStep.instruction];
            }
           else{
               if(transitStep.stepType==2){
                   str_main=[self filterHTML:transitStep.instruction];
                    if(range03.length>1&&range04.length>=1)
                   str_sub=[NSString stringWithFormat:@"步行%d米",[[transitStep.instruction substringWithRange:NSMakeRange(range03.location+range03.length, range04.location-range03.location-2)] intValue]];
               }
               else{
                   str_main=[self filterHTML:transitStep.instruction];
                   
                   str_sub=[NSString stringWithFormat:@"共%d站",transitStep.vehicleInfo.passStationNum];
               }
           }
            
            NSDictionary *dict_sub=[NSDictionary dictionaryWithObjects:@[str_main,str_sub,[NSString stringWithFormat:@"%d",transitStep.stepType]] forKeys:@[@"title_main",@"title_sub",@"tranvelType"]];
            [array addObject:dict_sub];
        }
            
        NSString *str=[str_name_sub substringToIndex:str_name_sub.length-2];
        NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[str,str_time,[NSString stringWithFormat:@"%d",int_distance],array] forKeys:@[@"nameString",@"timeString",@"distance",@"sub_thing"]];
        [self.dataArray addObject:dict];
        }
        [mtableview reloadData];
        }
    }
    else if (error==BMK_SEARCH_ST_EN_TOO_NEAR){
        [self displayadvice];
    }
    else if (error==BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"检索地址有岐义");
    }

}

//驾车方案结果
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    [self removePrompt];
    
    if (error == BMK_SEARCH_NO_ERROR) {
         if([self.dataArray count]) [self.dataArray removeAllObjects];
        if([result.routes count]){
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        if(plan.distance>1000){
        [self.dataPoint addObject:plan];
        // 计算路线方案中的路段数目
        NSUInteger size = [plan.steps count];
        NSString *str_time=[NSString stringWithFormat:@"%.1f",(plan.duration.seconds+plan.duration.minutes*60+plan.duration.hours*3600+plan.duration.dates*24*3600)/60.0];
        NSInteger int_distance=plan.distance;
        NSString *str_name_sub=[NSString stringWithFormat:@"%@->%@",startingAdd,endingAdd];
        NSMutableArray *array=[NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            NSString *str_main=@"";
            NSString *str_sub=@"";
            NSString *str_fx=@"";
            NSLog(@"%@---",transitStep.instruction);
            NSLog(@"=====%@",transitStep.entraceInstruction);
            if(i == 0){
                str_main=@"起点";
                str_sub=[self filterHTML:transitStep.instruction];
                NSRange range01=[transitStep.entraceInstruction rangeOfString:@"直行"];
                NSRange range02=[transitStep.entraceInstruction rangeOfString:@"左转"];
                NSRange range03=[transitStep.entraceInstruction rangeOfString:@"右转"];
                NSRange range04=[transitStep.entraceInstruction rangeOfString:@"靠左"];
                NSRange range05=[transitStep.entraceInstruction rangeOfString:@"靠右"];
                if(range01.length>1) str_fx=@"直走";
                else if(range02.length>1) str_fx=@"左转";
                else if(range03.length>1) str_fx=@"右转";
                else if(range04.length>1) str_fx=@"向左前方转";
                else if(range05.length>1) str_fx=@"向右前方转";
            }
            else if(i == size-1){
                str_main=@"终点";
                str_sub=[self filterHTML:transitStep.instruction];
                str_fx=@"";
            }
            else{
                str_main=[self filterHTML:transitStep.instruction];
                //判断方向
                str_sub=[[transitStep.entraceInstruction componentsSeparatedByString:@"-"] lastObject];
                NSRange range01=[transitStep.entraceInstruction rangeOfString:@"直行"];
                NSRange range02=[transitStep.entraceInstruction rangeOfString:@"左转"];
                NSRange range03=[transitStep.entraceInstruction rangeOfString:@"右转"];
                NSRange range04=[transitStep.entraceInstruction rangeOfString:@"靠左"];
                NSRange range05=[transitStep.entraceInstruction rangeOfString:@"靠右"];
                if(range01.length>1) str_fx=@"直走";
                else if(range02.length>1) str_fx=@"左转";
                else if(range03.length>1) str_fx=@"右转";
                else if(range04.length>1) str_fx=@"向左前方转";
                else if(range05.length>1) str_fx=@"向右前方转";
                
                //获取行走指南
                BMKDrivingStep* transitStep_second = [plan.steps objectAtIndex:i-1];
                str_sub=[[transitStep_second.entraceInstruction componentsSeparatedByString:@"-"] lastObject];
            }
            NSDictionary *dict_sub=[NSDictionary dictionaryWithObjects:@[str_main,str_sub,str_fx] forKeys:@[@"title_main",@"title_sub",@"tranvelType"]];
            [array addObject:dict_sub];
        }
            NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[str_name_sub,str_time,[NSString stringWithFormat:@"%0.2f",(int_distance/1000.0)],array] forKeys:@[@"nameString",@"timeString",@"distance",@"sub_thing"]];
            [self.dataArray addObject:dict];
            
             [mtableview reloadData];
        }
        else{
            [self displayadvice];
        }
      }
    }
    else if (error==BMK_SEARCH_ST_EN_TOO_NEAR){
        [self displayadvice];
    }
    else if (error==BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"检索地址有岐义");
    }
}

//步行方案结果
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    [self removePrompt];
    
    if (error == BMK_SEARCH_NO_ERROR) {
         if([self.dataArray count]) [self.dataArray removeAllObjects];
        if([result.routes count]){
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
         [self.dataPoint addObject:plan];
        NSUInteger size = [plan.steps count];
        NSString *str_time=[NSString stringWithFormat:@"%.1f",(plan.duration.seconds+plan.duration.minutes*60+plan.duration.hours*3600+plan.duration.dates*24*3600)/60.0];
        NSInteger int_distance=plan.distance;
        NSString *str_name_sub=[NSString stringWithFormat:@"%@->%@",startingAdd,endingAdd];
        NSMutableArray *array=[NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            NSString *str_main=@"";
            NSString *str_sub=@"";
            NSString *str_fx=@"";
            NSLog(@"%@---",transitStep.instruction);
            NSLog(@"=====%@",transitStep.entraceInstruction);
            if(i == 0){
            str_main=@"起点";
            str_sub=[self filterHTML:transitStep.instruction];
            NSRange range01=[transitStep.entraceInstruction rangeOfString:@"直走"];
            NSRange range001=[transitStep.entraceInstruction rangeOfString:@"继续向前"];
            NSRange range02=[transitStep.entraceInstruction rangeOfString:@"左转"];
            NSRange range03=[transitStep.entraceInstruction rangeOfString:@"右转"];
            NSRange range04=[transitStep.entraceInstruction rangeOfString:@"向左前方转"];
            NSRange range05=[transitStep.entraceInstruction rangeOfString:@"向右前方转"];
            if(range01.length>1 || range001.length) str_fx=@"直走";
            else if(range02.length>1) str_fx=@"左转";
            else if(range03.length>1) str_fx=@"右转";
            else if(range04.length>1) str_fx=@"向左前方转";
            else if(range05.length>1) str_fx=@"向右前方转";
            }
            else if(i == size-1){
                str_main=@"终点";
                str_sub=[self filterHTML:transitStep.instruction];
                str_fx=@"";
            }
            else{
                //判断方向
                str_main=[self filterHTML:transitStep.instruction];
                str_sub=[[transitStep.entraceInstruction componentsSeparatedByString:@"-"] lastObject];
                NSRange range01=[transitStep.entraceInstruction rangeOfString:@"直走"];
                NSRange range001=[transitStep.entraceInstruction rangeOfString:@"继续向前"];
                NSRange range02=[transitStep.entraceInstruction rangeOfString:@"左转"];
                NSRange range03=[transitStep.entraceInstruction rangeOfString:@"右转"];
                NSRange range04=[transitStep.entraceInstruction rangeOfString:@"向左前方转"];
                NSRange range05=[transitStep.entraceInstruction rangeOfString:@"向右前方转"];
                if(range01.length>1 || range001.length) str_fx=@"直走";
                else if(range02.length>1) str_fx=@"左转";
                else if(range03.length>1) str_fx=@"右转";
                else if(range04.length>1) str_fx=@"向左前方转";
                else if(range05.length>1) str_fx=@"向右前方转";
                
                //获取行走指南
                BMKDrivingStep* transitStep_second = [plan.steps objectAtIndex:i-1];
                str_sub=[[transitStep_second.entraceInstruction componentsSeparatedByString:@"-"] lastObject];
            }
            
            NSDictionary *dict_sub=[NSDictionary dictionaryWithObjects:@[str_main,str_sub,str_fx] forKeys:@[@"title_main",@"title_sub",@"tranvelType"]];
            [array addObject:dict_sub];
        }
        NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[str_name_sub,str_time,[NSString stringWithFormat:@"%0.2f",(int_distance/1000.0)],array] forKeys:@[@"nameString",@"timeString",@"distance",@"sub_thing"]];
        [self.dataArray addObject:dict];
        }
        [mtableview reloadData];
    }
    else if (error==BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"检索地址有岐义");
    }
}

//关于距离太近提示
-(void)displayadvice{
    UILabel *lab_ts=(UILabel *)[mtableview viewWithTag:1002];
    if(!lab_ts)
        lab_ts=[[UILabel alloc]initWithFrame:CGRectMake((mtableview.frame.size.width-200)/2, 220, 200, 40)];
    lab_ts.backgroundColor=[UIColor clearColor];
    lab_ts.textAlignment=NSTextAlignmentCenter;
    lab_ts.font=[UIFont systemFontOfSize:18];
    lab_ts.textColor=[UIColor grayColor];
    lab_ts.tag=1002;
    lab_ts.textColor=[UIColor grayColor];
    lab_ts.text=@"距离太近，建议步行";
    [mtableview addSubview:lab_ts];
    
    UIButton *btn_=(UIButton *)[mtableview viewWithTag:1003];
    if(!btn_)
    btn_=[UIButton buttonWithType:UIButtonTypeCustom];
    btn_.frame=CGRectMake(20, 280, kMainScreenWidth-40, 40);
    btn_.backgroundColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    btn_.tag=1003;
    [btn_ setTitle:@"查看步行路线" forState:UIControlStateNormal];
    [btn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_ addTarget:self action:@selector(pressWalk) forControlEvents:UIControlEventTouchUpInside];
    [mtableview addSubview:btn_];
}

-(void)removeWalkts{
     UILabel *lab_ts=(UILabel *)[mtableview viewWithTag:1002];
    if(lab_ts){
    [lab_ts removeFromSuperview];
    lab_ts=nil;
    }
     UIButton *btn_=(UIButton *)[mtableview viewWithTag:1003];
    if(btn_){
    [btn_ removeFromSuperview];
    btn_=nil;
    }
}

-(void)pressWalk{
    [self removeWalkts];
    [self loadPrompt];
    if([self.dataArray count]){
        [self.dataArray removeAllObjects];
        [mtableview reloadData];
    }
    if([self.dataPoint count]) [self.dataPoint removeAllObjects];
    
    wayType=@"步行";
    [self onClickWalkSearch];
    
    for (int i=0; i<3; i++) {
        UIButton *btn_=(UIButton *)[self.view_header viewWithTag:kButtonTag+i];
        if(i==0) [btn_ setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        else [btn_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

//去掉html的标签
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
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
