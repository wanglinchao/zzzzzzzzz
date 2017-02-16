//
//  PushMessageViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-20.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "PushMessageViewController.h"
#import "HexColor.h"
#import "MessageListCell.h"
#import "util.h"
#import <QuartzCore/QuartzCore.h>
#import "NetworkRequest.h"
#import "JSONKit.h"
//#import "PushMessageListModel.h"
#import "PushMessageModel.h"
#import "UIImageView+WebCache.h"
#import "DetailedIinforVC.h"
#import "savelogObj.h"
#import "TLToast.h"
#import "Reachability.h"

@interface PushMessageViewController () {

}

@end

@implementation PushMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)customizeNavigationBar {
    
    UIColor *color = [UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor blackColor];
    lab_nav_title.text=@"消息";
    self.navigationItem.titleView = lab_nav_title;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh.png"] forState:UIControlStateNormal];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self customizeNavigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];

    
    self.navigationController.navigationBar.hidden = YES;
    
//    [savelogObj saveLog:@"用户查看了消息" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:17];
    
    self.currentPage=0;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64 - 40) style:UITableViewStylePlain];
    mtableview.pullingDelegate = self;
//     mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    [mtableview setHeaderOnly:YES];          //只有下拉刷新
    //    [mtableview setFooterOnly:YES];         //只有上拉加载
    [mtableview launchRefreshing];
    [self.view addSubview:mtableview];

    self.dataArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    [self loadImageviewBG];
    
    // [self requestMessagelist];
}



#pragma mark -
#pragma mark - CircleProgressHUDDelegate
//-(void)createProgressView{
//    if (!phud) {
//        phud = [[MBProgressHUD alloc] initWithView:self.view];
//        [self.view addSubview:phud];
//        phud.mode=MBProgressHUDModeIndeterminate;
//        //phud.dimBackground=YES; //是否开启背景变暗
//        phud.labelText = @"数据加载中...";
//        phud.blur=NO;  //是否开启ios7毛玻璃风格
//        phud.darkBlur=YES; //受blur限制（blur为YES时设置darkBlur才有用）
//        [phud show:YES];
//    }
//    else{
//        [phud show:YES];
//    }
//}

//f2288eb274cc4757875e7ac7340eb260
-(void)requestMessagelist{
    [self startRequestWithString:@"加载中..."];
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0122\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"15\",\"currentPage\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.currentPage+1];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"message返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                [[NSUserDefaults standardUserDefaults]setObject:[jsonDict objectForKey:@"timeStamp"] forKey:Message_date];
                [[NSUserDefaults standardUserDefaults]synchronize];
                if (code==10071) {
                    //得到总的页数
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                        self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                        for (NSDictionary *dict in [jsonDict objectForKey:@"noticeList"]){
                            @autoreleasepool {
                                [self.dataArray addObject:[PushMessageModel objectWithKeyValues:dict]];
                            }
                        }
                        
                        if([self.dataArray count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [mtableview tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [mtableview tableViewDidFinishedLoading];
                        }
                        
                        [mtableview reloadData];
                    });
                }
                else if (code==10079) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading];//加载完成（可设置信息）
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [mtableview reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading];//加载完成（可设置信息）
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [mtableview tableViewDidFinishedLoading];//加载完成（可设置信息）
                                  if(![self.dataArray count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

#pragma mark -
#pragma mark - UITableViewDelegate



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycellid";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PushMessageCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor whiteColor];
    PushMessageModel *obj=[self.dataArray objectAtIndex:indexPath.section];
    UIImageView *headIV = (UIImageView *)[cell viewWithTag:101];
    headIV.layer.masksToBounds = YES;
    headIV.layer.cornerRadius = 20.5;
    NSString *imgUrlStr = obj.headImgPath; 
    [headIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:102];
    nameLabel.text = obj.name;
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:103];
    contentLabel.text = obj.content;
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:104];
    dateLabel.text = obj.createTime;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        [self.dataArray removeAllObjects];
        self.currentPage=0;
        [self requestMessagelist];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestMessagelist];
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
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
    
}

#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (mtableview.contentOffset.y<-60) {
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

@end
