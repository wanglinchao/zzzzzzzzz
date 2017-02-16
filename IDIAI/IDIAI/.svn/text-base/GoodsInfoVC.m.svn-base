//
//  GoodsInfoVC.m
//  IDIAI
//
//  Created by iMac on 14-7-31.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GoodsInfoVC.h"
#import "HexColor.h"
#import "util.h"
#import "GoodsListCell.h"
#import "GoodscategoryVC.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "BusinessInfoVC.h"
#import "GoodslistObj.h"
#import "UIImageView+WebCache.h"
#import "savelogObj.h"
#import "ListView.h"
#import "SearchBusinessViewController.h"
#import "IDIAIAppDelegate.h"


#define KButtonTag 100

@interface GoodsInfoVC ()<DropDownChooseDelegate>
{
    UIImageView *imageview_bg;
    UILabel *label_bg;
}
@property (nonatomic, strong) NSString *sortType_string;

@end

@implementation GoodsInfoVC
@synthesize business_id,search_content,title_lab;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"searchTocategory" object:nil];
    [mtableview setDelegate:nil];
    [mtableview setDataSource:nil];
    self.dataArray=nil;
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
    [[[self navigationController] navigationBar] setHidden:NO];
    
//    UIColor *color = [UIColor clearColor];
//    UIImage *image = [util imageWithColor:color];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    UIImage *image2 = [util imageWithColor:kFontPlacehoderColor];
//    self.navigationController.navigationBar.shadowImage = image2;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage =[UIImage new];// [util imageWithColor:kFontPlacehoderColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    UIToolbar* blurredView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -20, kMainScreenWidth, 64)];
    //    [blurredView setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar insertSubview:blurredView atIndex:0];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 43, kMainScreenWidth, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    line.alpha=0.6;
    line.tag = 10001;
    [self.navigationController.navigationBar addSubview:line];
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor whiteColor];
    lab_nav_title.text=@"材料";
    lab_nav_title.textColor = [UIColor blackColor];
    self.navigationItem.titleView = lab_nav_title;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
//    [self.navigationItem setLeftBarButtonItem:leftItem];
    
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

-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)PressBarItemRight{
    SearchBusinessViewController *searchvc=[[SearchBusinessViewController alloc]init];
    searchvc.lat_=self.lat;
    searchvc.lng_=self.lng;
    searchvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchvc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);//修复点击其余选项卡导致关于cell不能点击的问题 huangrun
    _locService.delegate=self;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self customizeNavigationBar];
    [mtableview reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    _locService.delegate=nil;
     [_locService stopUserLocationService];

}

-(void)backTouched:(UIButton *)btn{
    if(btn.tag==1){
    [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag==2) {
        GoodscategoryVC *goodsvc=[[GoodscategoryVC alloc]init];
        goodsvc.delegate=self;
        goodsvc.entrance_type=@"goods";
        [self.navigationController pushViewController:goodsvc animated:YES];
    }
}

-(void)chooseAtSection:(NSInteger)section indexId:(NSString *)index_id{
    NSLog(@"%d------%@",section,index_id);
    search_content=@"";
   if(section==0) self.requestArea=index_id;
    if(section==1) business_id=index_id;
    if(section==2) self.sortType_string=index_id;
    self.is_delegate=YES;
    if([self.dataArray count])[self.dataArray removeAllObjects];
    [mtableview reloadData];
    [mtableview launchRefreshing];

}

#pragma mark-
#pragma mark - GoodscategoryVCDelegate
-(void)selectedThing:(NSString *)string Title:(NSString *)title{
 
    search_content=@"";
    business_id=string;
    UILabel *lab=(UILabel *)[self.view viewWithTag:1000];
    lab.text=title;
    self.is_delegate=YES;
    if([self.dataArray count])[self.dataArray removeAllObjects];
    [mtableview reloadData];
    [mtableview launchRefreshing];

}
-(void)requestcagatelist{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0003\",\"deviceType\":\"ios\",\"token\":\"\",\"userID\":\"\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
    
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"材料分类返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10031) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *arr_=[jsonDict objectForKey:@"classificationList"];
                       if([self.dataArray_fenlei count]) [self.dataArray_fenlei removeAllObjects];
                        if([arr_ count]){
                            for(NSDictionary *dict in arr_){
                                [self.dataArray_fenlei addObject:dict];
                            }
                        }
                        [self.dataArray_fenlei insertObject:@{@"classfiedName":@"全部",@"businessTypeList":@[@{@"businessTypeName":@"全部",@"businessTypeId":@"-1"}]} atIndex:0];
                        
                        ListView *listview=[[ListView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40) array_name:@[@"区域",@"分类",@"排序"] type:1];
                        listview.delegate=self;
                        listview.array_data_first=self.dataArray_quyu;
                        listview.array_data_second=self.dataArray_fenlei;
                        listview.array_data_three=@[@"星级",@"距离",@"热度"];
                        listview.mSuperView=self.view;
                        [self.view addSubview:listview];
                        
                        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
                            _locService = [[BMKLocationService alloc]init];
                            _locService.delegate=self;
                            [_locService startUserLocationService];
                        }else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用"
                                                                            message:@"可在“设置->隐私->定位服务”中确认“定位服务”和“屋托邦”是否为开启状态"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                            [alert show];
                            self.lng=@"";
                            self.lat=@"";
                            [mtableview launchRefreshing];
                        }
                        
                    });
                }
            
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                      imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                imageview_bg.hidden=NO;
                                  label_bg.hidden = NO;
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

//请求行政区域列表
-(void)requestDistrictNOlist{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0042\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
       
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                 NSLog(@"行政区号：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10421) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *arr_=[jsonDict objectForKey:@"countyList"];
                        if([self.dataArray_quyu count]) [self.dataArray_quyu removeAllObjects];
                        if ([arr_ count]) {
                            for(NSDictionary *dict in arr_){
                                [self.dataArray_quyu addObject:dict];
                            }
                        }
                        NSDictionary *dict_=[NSDictionary dictionaryWithObjects:@[@"-1",@"不限"] forKeys:@[@"areaCode",@"areaName"]];
                        [self.dataArray_quyu insertObject:dict_ atIndex:0]; //插入某城市不限范围
                        
                        [self requestcagatelist];
                    });
                }
                else if (code==10429) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                 imageview_bg.hidden=NO;
                                  label_bg.hidden = NO;
                              });
                          }
                               method:url postDict:nil];
    });
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    [savelogObj saveLog:@"用户查看了商家" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:15];
 
    self.is_first_load=YES;
    self.is_loadorrefering=YES;
    self.is_delegate=NO;
    self.currentPage=0;
    self.search_content=@"";
    self.requestArea=@"-1";
    self.business_id=@"-1";
    self.sortType_string=@"1";
   // [self createTopbtn];
    
    
    // 分类  http://qttecx.com:8080/idas/dispatch/dispatch.action?header={"cmdID":"ID0003","deviceType":"ios","token":"","userID":""}&body={}
    
    //区域 http://qttecx.com:8080/idas/dispatch/dispatch.action?header={"cmdID":"ID0029","deviceType":"ios","token":"","userID":""}&body={}
    //-----
     self.dataArray =[[NSMutableArray alloc]initWithCapacity:0];
    IDIAIAppDelegate *delegate_=(IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.dataArray_fenlei =[[NSMutableArray alloc]initWithCapacity:0];
    self.dataArray_paixu =[[NSMutableArray alloc]initWithCapacity:0];
    self.dataArray_quyu =[NSMutableArray arrayWithArray:delegate_.array_area_list];
    
    if([self.dataArray_quyu count]) {
        NSDictionary *dict_=[NSDictionary dictionaryWithObjects:@[@"-1",@"不限"] forKeys:@[@"areaCode",@"areaName"]];
        [self.dataArray_quyu insertObject:dict_ atIndex:0]; //插入某城市不限范围
        [self requestcagatelist];
    }
    else [self requestDistrictNOlist];
    

    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight -64-40 - 40) style:UITableViewStyleGrouped];
    mtableview.pullingDelegate = self;
    //mtableview.backgroundColor=[UIColor whiteColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    [mtableview setHeaderOnly:YES];          //只有下拉刷新
    //    [mtableview setFooterOnly:YES];         //只有上拉加载
    //[mtableview launchRefreshing];
    mtableview.scrollsToTop = YES;
    [self.view addSubview:mtableview];
    
    [self loadImageviewBG];
}

-(void)loadImageviewBG{
    UIImage *image_failed = [UIImage imageNamed:@"ic_moren"];
    if(!imageview_bg)
        imageview_bg=[[UIImageView alloc] initWithImage:image_failed ];
    imageview_bg.frame=CGRectMake((kMainScreenWidth-image_failed.size.width)/2, (kMainScreenHeight-64-40-image_failed.size.height)/2, image_failed.size.width, image_failed.size.height);
    imageview_bg.tag=111;
    imageview_bg.hidden=YES;
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


-(void)createTopbtn{
    
    UIImageView *view_top_bg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 64, kMainScreenWidth-40, 40)];
    view_top_bg.image=[UIImage imageNamed:@"商品信息背景背景条.png"];
    [self.view addSubview:view_top_bg];
    
    NSArray *arr_btn_name=[NSArray arrayWithObjects:@"星级",@"距离", nil];
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=KButtonTag+i;
        [btn setTitle:[arr_btn_name objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#6d2907" alpha:1.0] forState:UIControlStateNormal];
        if(i==0){
            [btn setFrame:CGRectMake(20, 64, 93, 40)];
            [btn setImage:[UIImage imageNamed:@"star_select.png"] forState:UIControlStateNormal];
            btn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
            btn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 3, 10);
        }
        else if(i==1){
            [btn setFrame:CGRectMake(206, 64, 93, 40)];
            [btn setImage:[UIImage imageNamed:@"distance_.png"] forState:UIControlStateNormal];
            btn.imageEdgeInsets=UIEdgeInsetsMake(0, 60, 0, 0);
            btn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 3, 30);
        }
        [btn addTarget:self
                       action:@selector(pressbtn:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

-(void)pressbtn:(UIButton *)btn{
     UIButton *btn_f=(UIButton*)[self.view viewWithTag:KButtonTag+0];
     UIButton *btn_s=(UIButton*)[self.view viewWithTag:KButtonTag+1];
    if(btn.tag-KButtonTag==0){
        self.sortType_string=@"1";
       [btn_f setImage:[UIImage imageNamed:@"star_select.png"] forState:UIControlStateNormal];
        [btn_s setImage:[UIImage imageNamed:@"distance_.png"] forState:UIControlStateNormal];
        self.is_delegate=YES;
        [self.dataArray removeAllObjects];
        [mtableview reloadData];
        [mtableview launchRefreshing];
    }
    else{
        self.sortType_string=@"2";
        [btn_f setImage:[UIImage imageNamed:@"star_.png"] forState:UIControlStateNormal];
        [btn_s setImage:[UIImage imageNamed:@"distance_select.png"] forState:UIControlStateNormal];
        if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        self.is_delegate=YES;
        [self.dataArray removeAllObjects];
        [mtableview reloadData];
        [mtableview launchRefreshing];
        }
        else{
            [self.dataArray removeAllObjects];
            [mtableview reloadData];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"定位未开启，无法按距离查看，请在“设置->隐私->定位服务”中打开“定位服务”和“屋托邦”"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)requestshopslist{
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
 //self.lat=@"104.074603";
// self.lng=@"30.541457";

        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0001\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"searchContent\":\"%@\",\"requestArea\":\"%@\",\"businessID\":\"%@\",\"requestRow\":\"10\",\"currentPage\":\"%d\",\"sortType\":\"%@\",\"userLongitude\":\"%@\",\"userLatitude\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],search_content,self.requestArea,business_id,self.currentPage+1,self.sortType_string,self.lng,self.lat];

        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"材料商列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10011) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *arr_=[jsonDict objectForKey:@"shopList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            if(self.is_delegate==YES)
                                [self.dataArray removeAllObjects];
                            for(NSDictionary *dict in arr_){
                                [self.dataArray addObject:[GoodslistObj objWithDict:dict]];
                            }
                        }
                        
                        
                        if([self.dataArray count]){
                            imageview_bg.hidden=YES;
                            [mtableview tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                             [mtableview tableViewDidFinishedLoading];
                        }
                        
                        [mtableview reloadData];
                        
                        self.is_loadorrefering=NO;
                    });
                }
                else if (code==10012) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [mtableview tableViewDidFinishedLoading];
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        self.is_loadorrefering=NO;
                         [mtableview reloadData];
                        });
                }
                else if (code==10019) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        self.is_loadorrefering=NO;
                         [mtableview reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        self.is_loadorrefering=NO;
                         [mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                   [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
                                  if(![self.dataArray count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  self.is_loadorrefering=NO;
                                   [mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

#pragma mark -UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 20)];
    view_.backgroundColor=[UIColor clearColor];
    
    return view_;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycellid";
    GoodsListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GoodsListCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if([self.dataArray count]){
    GoodslistObj *obj=[self.dataArray objectAtIndex:indexPath.section];
    CGSize size_name=[util calHeightForLabel:obj.shopName width:kMainScreenWidth-140 font:[UIFont systemFontOfSize:17]];
    cell.shop_name.text=obj.shopName;
    cell.image_big.clipsToBounds = YES;
    cell.image_big.contentMode=UIViewContentModeRedraw;
    [cell.image_big sd_setImageWithURL:[NSURL URLWithString:obj.shopLitimgPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"] options:SDWebImageTransformAnimatedImage];
        
        if(![obj.distance isEqual:[NSNull null]] && ![obj.distance isEqualToString:@"(null)"]){
            if(![obj.distance isEqualToString:@"-1"])
                cell.lab_distance.text=[NSString stringWithFormat:@"%0.1fkm",[obj.distance floatValue]];
            else
                cell.lab_distance.text=@"无法定位";
        }
    else
        cell.lab_distance.text=@"";
        
    if([obj.arr_rztype count]){
        for(int i=0;i<[obj.arr_rztype count];i++){
            NSDictionary *dict=[obj.arr_rztype objectAtIndex:i];
            UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(20+size_name.width+i*25, 195, 20, 20)];
            image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_s_%@.png",[dict objectForKey:@"authzId"]]];
            [cell addSubview:image_rz];
        }
    }
        
    if([self.sortType_string integerValue]!=3){
    NSInteger srat_full=0;
    NSInteger srat_half=0;
    if([obj.shopLevel integerValue]<[obj.shopLevel floatValue]){
        srat_full=[obj.shopLevel integerValue];
        srat_half=1;
    }
    else if([obj.shopLevel integerValue]==[obj.shopLevel floatValue]){
        srat_full=[obj.shopLevel integerValue];
        srat_half=0;
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(13, 220, 100, 20)];
    view.backgroundColor=[UIColor clearColor];
    for(int i=0;i<5;i++){
    if (i <srat_full) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 5, 15, 15)];
        [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
        [view addSubview:imageView];
     
        }
    else if (i==srat_full && srat_half!=0) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 5, 15, 15)];
        [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
        [view addSubview:imageView];
        
        }
    else {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 5, 15, 15)];
        [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
        [view addSubview:imageView];
       
        }
      }
     [cell addSubview:view];
        cell.image_brower.hidden=YES;
        cell.image_collect.hidden=YES;
    }
    else{
        cell.lab_brower.text=obj.shopBrowsePoints;
        cell.lab_collect.text=obj.shopCollectPoints;
    }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.dataArray count]){
    GoodslistObj *obj_=[self.dataArray objectAtIndex:indexPath.section];
    BusinessInfoVC *ectvc=[[BusinessInfoVC alloc]init];
    ectvc.delegate=self;
    ectvc.obj=obj_;
        ectvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ectvc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)reloadThing:(NSString *)string{
    if(self.is_delegate==YES)
    [self requestshopslist];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [mtableview setDelegate:nil];
    [mtableview setDataSource:nil];
    self.dataArray=nil;
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        self.is_delegate=YES;
        self.currentPage=0;
        [self requestshopslist];
    }
    else {
        if(self.totalPages>self.currentPage){
             self.is_delegate=NO;
            [self requestshopslist];
        }
        else{
            [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            mtableview.reachedTheEnd = YES;  //是否加载到底了
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    if(self.lat.length<1 && self.lng.length<1){
        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
            isrefreshLocation = YES;
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate=self;
            [_locService startUserLocationService];
        }
        else{
            imageview_bg.hidden=YES;
            label_bg.hidden = YES;
            self.refreshing=YES;
            self.is_loadorrefering=YES;
            [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
        }
    }
    else{
        imageview_bg.hidden=YES;
        label_bg.hidden = YES;
        self.refreshing=YES;
        self.is_loadorrefering=YES;
        [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
    }
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
    if(self.lat.length<1 && self.lng.length<1){
        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
            isrefreshLocation = YES;
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate=self;
            [_locService startUserLocationService];
        }
        else{
            imageview_bg.hidden=YES;
            label_bg.hidden = YES;
            self.refreshing=YES;
            self.is_loadorrefering=YES;
            [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
        }
    }
    else{
        if(isFirstInt==YES){
            imageview_bg.hidden=YES;
            label_bg.hidden = YES;
            self.refreshing=NO;
            self.is_loadorrefering=YES;
            [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
            }
        else {
            [mtableview tableViewDidFinishedLoading];
            isFirstInt=!isFirstInt;
        }
    }
}

#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (mtableview.contentOffset.y<-30) {
        mtableview.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [mtableview tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [mtableview tableViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark - BMKLocationServiceDelegate


/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation.location.coordinate.longitude>0.0 && userLocation.location.coordinate.latitude>0.0) {
        self.lng = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
        self.lat = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
        [_locService stopUserLocationService];
        if(self.is_loadorrefering==YES && self.is_first_load==YES && [self.lng floatValue]!=0.000000){
            // NSLog(@"经度：%f----纬度：%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
         self.is_loadorrefering=NO;
            self.is_first_load=NO;
            if(isrefreshLocation==YES){
                isrefreshLocation=NO;
                [self requestshopslist];
            }
            else [mtableview launchRefreshing];
        }
        else{
            if(isrefreshLocation==YES){
                isrefreshLocation=NO;
                [self requestshopslist];
                }
            else [mtableview launchRefreshing];
        }
	}
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */

-(void)didFailToLocateUserWithError:(NSError *)error{
        [_locService stopUserLocationService];
        self.lng=@"";
        self.lat=@"";
        [mtableview launchRefreshing];
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
