//
//  WaytomapViewController.m
//  IDIAI
//
//  Created by iMac on 14-10-20.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "WaytomapViewController.h"
#import "HexColor.h"
#import "StepsCell.h"
#import "util.h"
#import "Macros.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：步行 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@interface WaytomapViewController ()

@end

@implementation WaytomapViewController
@synthesize plan_drive,plan_trans,plan_walk;
@synthesize tranvel_type,data_Arr;

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:NO];
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor darkGrayColor];
    lab_nav_title.text=tranvel_type;
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
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate=self;
    
    if([tranvel_type isEqualToString:@"公交"]){
        NSUInteger size=size = [plan_trans.steps count];
        int planPointCounts = 0;
        double latitude_=0.0;
        double longitude_=0.0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan_trans.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan_trans.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
                latitude_=item.coordinate.latitude;
                longitude_=item.coordinate.longitude;
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan_trans.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                
                //设置地图中心点
                CLLocationCoordinate2D centerPt = (CLLocationCoordinate2D){(item.coordinate.latitude+latitude_)/2,(item.coordinate.longitude+longitude_)/2};
                BMKCoordinateRegion pt;
                pt.center=centerPt;
                pt.span=(BMKCoordinateSpan){(item.coordinate.latitude-latitude_),(item.coordinate.longitude-longitude_)};
                [_mapView setRegion:pt];
                [_mapView setCenterCoordinate:centerPt animated:YES];
            }
            else{
                //添加annotation节点
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = transitStep.entrace.location;
                item.title = transitStep.instruction;
                if(transitStep.stepType==BMK_WAKLING) item.type = 3;
                else item.type = 2;
                [_mapView addAnnotation:item];
            }
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints =new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan_trans.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
    else if ([tranvel_type isEqualToString:@"驾车"]){
        NSUInteger size=size = [plan_drive.steps count];
        int planPointCounts = 0;
        double latitude_=0.0;
        double longitude_=0.0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan_drive.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan_drive.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                [_mapView setCenterCoordinate:item.coordinate animated:YES];
                
                //获取起点经纬度
                latitude_=item.coordinate.latitude;
                longitude_=item.coordinate.longitude;
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan_drive.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                
                //设置地图中心点
                CLLocationCoordinate2D centerPt = (CLLocationCoordinate2D){(item.coordinate.latitude+latitude_)/2,(item.coordinate.longitude+longitude_)/2};
                BMKCoordinateRegion pt;
                pt.center=centerPt;
                pt.span=(BMKCoordinateSpan){(item.coordinate.latitude-latitude_),(item.coordinate.longitude-longitude_)};
                [_mapView setRegion:pt];
                [_mapView setCenterCoordinate:centerPt animated:YES];
            }
            else{
                //添加annotation节点
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = transitStep.entrace.location;
                item.title = transitStep.entraceInstruction;
                item.degree = transitStep.direction * 30;
                item.type = 4;
                [_mapView addAnnotation:item];
            }
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        // 添加途经点(只有驾车有)
        if (plan_drive.wayPoints) {
            for (BMKPlanNode* tempNode in plan_drive.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        
        //轨迹点
        BMKMapPoint * temppoints =new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan_drive.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
    else{
        NSUInteger size=size = [plan_walk.steps count];
        int planPointCounts = 0;
        double latitude_=0.0;
        double longitude_=0.0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan_walk.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan_walk.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                [_mapView setCenterCoordinate:item.coordinate animated:YES];
                
                latitude_=item.coordinate.latitude;
                longitude_=item.coordinate.longitude;
            }
            else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan_walk.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                
                //设置地图中心点
                CLLocationCoordinate2D centerPt = (CLLocationCoordinate2D){(item.coordinate.latitude+latitude_)/2,(item.coordinate.longitude+longitude_)/2};
                BMKCoordinateRegion pt;
                pt.center=centerPt;
                pt.span=(BMKCoordinateSpan){(item.coordinate.latitude-latitude_),(item.coordinate.longitude-longitude_)};
                [_mapView setRegion:pt];
                [_mapView setCenterCoordinate:centerPt animated:YES];
            }
            else{
                //添加annotation节点
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = transitStep.entrace.location;
                item.title = transitStep.entraceInstruction;
                item.degree = transitStep.direction * 30;
                item.type = 3;
                [_mapView addAnnotation:item];
            }
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints =new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan_walk.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate=nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
    [self customizeNavigationBar];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    [_mapView setZoomLevel:13];
    //_mapView.showMapScaleBar = YES;
    _mapView.mapScaleBarPosition = CGPointMake(15, kMainScreenHeight-120);
    [self.view addSubview:_mapView];
    
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    
    ischanged=NO;
    [self createView];
}

-(void)createView{
    view_big=[[UIView alloc]initWithFrame:CGRectMake(0, 100, kMainScreenWidth, kMainScreenHeight-120)];
    view_big.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view_big];
    
    UIImageView *imv=[[UIImageView alloc]initWithFrame:CGRectMake(0, -17, kMainScreenWidth, 30)];
    imv.image=[UIImage imageNamed:@"ic_shanglakuang.png"];
    imv.userInteractionEnabled=YES;
    [view_big addSubview:imv];
    
    UIImageView *im_arrow=[[UIImageView alloc]initWithFrame:CGRectMake((view_big.frame.size.width-40)/2, -15,40, 40)];
    im_arrow.tag=11;
    im_arrow.image=[UIImage imageNamed:@"ic_jiantou_down"];
    im_arrow.userInteractionEnabled=YES;
    [view_big addSubview:im_arrow];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapGesture:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [view_big addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(PanGesture:)];
    pan.maximumNumberOfTouches=5;
    pan.maximumNumberOfTouches=1;
    [view_big addGestureRecognizer:pan];
    
    UITableView *mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 30, kMainScreenWidth, view_big.frame.size.height-30) style:UITableViewStylePlain];
    mtableview.tag=1000;
    mtableview.delegate=self;
    mtableview.dataSource=self;
    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [view_big addSubview:mtableview];
}

-(void)TapGesture:(UITapGestureRecognizer *)gesture{
    UIImageView *imv=(UIImageView *)[view_big viewWithTag:11];
    [UIView animateWithDuration:0.20 animations:^{
        if(ischanged==NO){
            view_big.frame=CGRectMake(0, kMainScreenHeight-100, kMainScreenWidth, kMainScreenHeight-120);
            imv.image=[UIImage imageNamed:@"ic_jiantou_up"];
        }
        else{
            view_big.frame=CGRectMake(0, 100, kMainScreenWidth, kMainScreenHeight-120);
            imv.image=[UIImage imageNamed:@"ic_jiantou_down"];
        }
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.08 animations:^{
            if(ischanged==NO){
                view_big.frame=CGRectMake(0, kMainScreenHeight-170, kMainScreenWidth, kMainScreenHeight-120);
                imv.image=[UIImage imageNamed:@"ic_jiantou_up"];
            }
            else{
                view_big.frame=CGRectMake(0, 100, kMainScreenWidth, kMainScreenHeight-120);
                imv.image=[UIImage imageNamed:@"ic_jiantou_down"];
            }
            UITableView *tableview=(UITableView *)[view_big viewWithTag:1000];
            if(ischanged==NO) tableview.frame=CGRectMake(0, 40, kMainScreenWidth, 50);
            else tableview.frame=CGRectMake(0, 30, kMainScreenWidth, view_big.frame.size.height-30);
        }completion:^(BOOL finished){
            ischanged=!ischanged;
        }];
    }];
}

-(void)PanGesture:(UIPanGestureRecognizer *)gesture{
    static BOOL is_uping=NO;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
           // NSLog(@"======UIGestureRecognizerStateBegan");
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            /*
             让view_big跟着手指移动
             1.获取每次系统捕获到的手指移动的偏移量translation
             2.根据偏移量translation算出当前view_big应该出现的位置
             3.设置view_big的新frame
             4.将translation重置为0（十分重要。一旦你完成上述的移动,否则translation每次都会叠加，很快你的view_big就会移除屏幕！）
             */
            CGPoint translation_ = [gesture translationInView:view_big];
            if(translation_.y<0.0) {
                is_uping=YES;
                ischanged=NO;
            }
            else if(translation_.y>0.0){
                is_uping=NO;
                ischanged=YES;
            }
            
            if(view_big.frame.origin.y>=140){
                CGPoint translation = [gesture translationInView:view_big];
                view_big.center = CGPointMake(view_big.center.x , gesture.view.center.y + translation.y);
                [gesture setTranslation:CGPointMake(0, 0) inView:view_big];
            }
            
            UITableView *tableview=(UITableView *)[view_big viewWithTag:1000];
            if(ischanged==NO && is_uping==YES) tableview.frame=CGRectMake(0, 30, kMainScreenWidth, view_big.frame.size.height-30);
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
           // NSLog(@"======UIGestureRecognizerStateCancelled");
            break;
        }
        case UIGestureRecognizerStateFailed:
        {
            //NSLog(@"======UIGestureRecognizerStateFailed");
            break;
        }
        case UIGestureRecognizerStatePossible:
        {
           // NSLog(@"======UIGestureRecognizerStatePossible");
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            /*
             当手势结束后，view的减速缓冲效果
             写的一个很简单的方法。它遵循如下策略：
             计算速度向量的长度（i.e. magnitude）
             如果长度小于200，则减少基本速度，否则增加它。
             基于速度和滑动因子计算终点
             确定终点在视图边界内
             让视图使用动画到达最终的静止点
             使用“Ease out“动画参数，使运动速度随着时间降低
             */
            //            CGPoint velocity = [gesture velocityInView:view_big];// 分别得出x，y轴方向的速度向量长度（velocity代表按照当前速度，每秒可移动的像素个数，分xy轴两个方向）
            //            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));// 根据直角三角形的算法算出综合速度向量长度
            //
            //            // 如果长度小于200，则减少基本速度，否则增加它。
            //            CGFloat slideMult = magnitude / 200;
            //
            //            NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
            //            float slideFactor = 0.1 * slideMult; // Increase for more of a slide
            //
            //            // 基于速度和滑动因子计算终点
            //            CGPoint finalPoint = CGPointMake(view_big.center.x,
            //                                             view_big.center.y + (velocity.y * slideFactor));
            //
            //            // 确定终点在视图边界内
            //            finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
            //            finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
            
            
            UIImageView *imv=(UIImageView *)[view_big viewWithTag:11];
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                if(is_uping){
                    view_big.frame=CGRectMake(0, 100, kMainScreenWidth, kMainScreenHeight-120);
                    imv.image=[UIImage imageNamed:@"ic_jiantou_down"];
                }
                else {
                    view_big.frame=CGRectMake(0, kMainScreenHeight-100, kMainScreenWidth, kMainScreenHeight-120);
                    imv.image=[UIImage imageNamed:@"ic_jiantou_up"];
                }
            } completion:^(BOOL finised){
                [UIView animateWithDuration:0.08 animations:^{
                    if(is_uping){
                        view_big.frame=CGRectMake(0, 100, kMainScreenWidth, kMainScreenHeight-120);
                        imv.image=[UIImage imageNamed:@"ic_jiantou_down"];
                    }
                    else {
                        view_big.frame=CGRectMake(0, kMainScreenHeight-170, kMainScreenWidth, kMainScreenHeight-120);
                        imv.image=[UIImage imageNamed:@"ic_jiantou_up"];
                    }
                    
                    UITableView *tableview=(UITableView *)[view_big viewWithTag:1000];
                    if(ischanged==YES && is_uping==NO) tableview.frame=CGRectMake(0, 30, kMainScreenWidth, 60);
                }completion:^(BOOL finished){
                    
                }];
            }];
            
            break;
        }
        default:{
           // NSLog(@"======Unknow gestureRecognizer");
            break;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data_Arr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"Mycell";
    StepsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"StepsCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if([data_Arr count]){
        CGSize size_main=[util calHeightForLabel:[[data_Arr objectAtIndex:indexPath.row] objectForKey:@"title_main"] width:252 font:[UIFont systemFontOfSize:15]];
        CGSize size_sub=[util calHeightForLabel:[[data_Arr objectAtIndex:indexPath.row] objectForKey:@"title_sub"] width:252 font:[UIFont systemFontOfSize:13]];
        
        cell.title_main_lab.frame=CGRectMake(cell.title_main_lab.frame.origin.x, cell.title_main_lab.frame.origin.y, cell.title_main_lab.frame.size.width, size_main.height);
        cell.title_sub_lab.frame=CGRectMake(cell.title_sub_lab.frame.origin.x, size_main.height+5, cell.title_sub_lab.frame.size.width, size_sub.height);
        cell.title_main_lab.numberOfLines=0;
        cell.title_sub_lab.numberOfLines=0;
        cell.title_main_lab.text=[[data_Arr objectAtIndex:indexPath.row] objectForKey:@"title_main"];
        cell.title_sub_lab.text=[[data_Arr objectAtIndex:indexPath.row] objectForKey:@"title_sub"];
        cell.title_main_lab.textColor=[UIColor blackColor];
        cell.title_sub_lab.textColor=[UIColor grayColor];
        
        if(indexPath.row==[data_Arr count]-1) cell.image_line.hidden=YES;
        if([tranvel_type isEqualToString:@"公交"]){
            if(indexPath.row==[data_Arr count]-1){
                cell.image_bz.image=[UIImage imageNamed:@"ic_dt_yuandian"];
            }
            else{
                NSInteger index=[[[data_Arr objectAtIndex:indexPath.row] objectForKey:@"tranvelType"] integerValue];
                if(index==0)
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_chengche_cell"];
                else if(index==1)
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_chengche_cell"];
                else
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_buxiang_cell"];
            }
            
        }
        else if([tranvel_type isEqualToString:@"驾车"]){
            if(indexPath.row==[data_Arr count]-1){
                cell.image_bz.image=[UIImage imageNamed:@"ic_dt_yuandian"];
            }
            else{
                NSString *str_type=[[data_Arr objectAtIndex:indexPath.row] objectForKey:@"tranvelType"];
                if([str_type isEqualToString:@"直走"])
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_zhixing"];
                else if([str_type isEqualToString:@"左转"])
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_guai_l"];
                else if([str_type isEqualToString:@"右转"])
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_guai_r"];
                else if([str_type isEqualToString:@"向左前方转"])
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_zhuan_l"];
                else if([str_type isEqualToString:@"向右前方转"])
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_zhuan_r"];
                else
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_zhixing"];
            }
        }
        else{
            if(indexPath.row==[data_Arr count]-1){
                cell.image_bz.image=[UIImage imageNamed:@"ic_dt_yuandian"];
            }
            else{
                NSString *str_type=[[data_Arr objectAtIndex:indexPath.row] objectForKey:@"tranvelType"];
                if([str_type isEqualToString:@"直走"])
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_zhixing"];
                else if([str_type isEqualToString:@"左转"])
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_guai_l"];
                else if([str_type isEqualToString:@"右转"])
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_guai_r"];
                else if([str_type isEqualToString:@"向左前方转"])
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_zhuan_l"];
                else if([str_type isEqualToString:@"向右前方转"])
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_zhuan_r"];
                else
                    cell.image_bz.image=[UIImage imageNamed:@"ic_dt_zhixing"];
            }
        }
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - BMKmap


- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                //view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.image=[UIImage imageNamed:@"map_map_start"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                //view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.image=[UIImage imageNamed:@"map_map_end"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                //view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.image=[UIImage imageNamed:@"map_map_bus"];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                //view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.image=[UIImage imageNamed:@"map_map_walk"];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            //UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            //view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.image=[UIImage imageNamed:@"map_map_car"];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor clearColor] colorWithAlphaComponent:1.0];
        polylineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1.0];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark -
#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [_mapView updateLocationData:userLocation];
    if (userLocation.location.coordinate.latitude >0 && userLocation.location.coordinate.longitude >0) {
       // NSLog(@"%f----%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        [_locService stopUserLocationService];
    }
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
