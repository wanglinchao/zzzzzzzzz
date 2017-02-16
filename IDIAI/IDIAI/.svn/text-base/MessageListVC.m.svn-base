//
//  MessageListVC.m
//  IDIAI
//
//  Created by iMac on 14-7-4.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MessageListVC.h"
#import "HexColor.h"
#import "MessageListCell.h"
#import "util.h"
#import <QuartzCore/QuartzCore.h>
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "MessgeListObj.h"
#import "UIImageView+WebCache.h"
#import "DetailedIinforVC.h"
#import "savelogObj.h"
#import "TLToast.h"
#import "Reachability.h"
#import "IDIAIAppDelegate.h"

@interface MessageListVC ()
{
  
}

@end

@implementation MessageListVC

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
    lab_nav_title.backgroundColor=[UIColor clearColor
                                   ];
    lab_nav_title.textColor=[UIColor blackColor];
    lab_nav_title.text=@"消息";
    self.navigationItem.titleView = lab_nav_title;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
    self.tabBarController.navigationItem.leftBarButtonItem = leftItem;
}

-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:YES animated:NO];
    [self customizeNavigationBar];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [savelogObj saveLog:@"查看消息" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:17];
    
    self.currentPage=0;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    mtableview.pullingDelegate = self;
   // mtableview.backgroundColor=[UIColor clearColor];
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0006\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"15\",\"currentPage\":\"%d\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.currentPage+1];
        
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
                                [self.dataArray addObject:[MessgeListObj objWithDict:dict]];
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    MessgeListObj *obj=[self.dataArray objectAtIndex:indexPath.section];
//    CGSize size;
//    if([obj.messagetype isEqualToString:@"1"])
//     size=[util calHeightForLabel:obj.messagedescri width:kMainScreenWidth-60 font:[UIFont systemFontOfSize:17.0]];
//    else
//        size=[util calHeightForLabel:obj.messagecontent width:kMainScreenWidth-60 font:[UIFont systemFontOfSize:17.0]];
//    if ([obj.messagetype isEqualToString:@"1"]) {
//        return 50+120+size.height+52;
//    }
//    else{
//        return 5+size.height+10;
//    }
    return 66;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MessgeListObj *obj=[self.dataArray objectAtIndex:section];
    
    UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    view_.backgroundColor=[UIColor clearColor];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-100)/2, 10, 100, 20)];
    lab.backgroundColor=[UIColor colorWithHexString:@"#D8D8DB" alpha:1.0];
    //给按钮设置弧度,这里将按钮变成了圆形
    lab.layer.cornerRadius = 8.0f;
    lab.layer.masksToBounds = YES;
    lab.text=obj.messagetime;
    lab.textColor=[UIColor grayColor];
    lab.font=[UIFont systemFontOfSize:15];
    lab.textAlignment=NSTextAlignmentCenter;
    [view_ addSubview:lab];
    
    return view_;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycellid";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PushMessageCell" owner:nil options:nil]lastObject];
    }

    MessgeListObj *obj=[self.dataArray objectAtIndex:indexPath.section];
    
        if ([obj.messagetype isEqualToString:@"1"]) {
    UIImageView *headIV = (UIImageView *)[cell viewWithTag:101];
    headIV.layer.masksToBounds = YES;
    headIV.layer.cornerRadius = 20.5;
    NSString *imgUrlStr = obj.messagepicture ;
    [headIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"]];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:102];
    nameLabel.text = obj.messaetitle;
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:103];
    contentLabel.text = obj.messagedescri;
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:104];
    dateLabel.text = obj.messagetime;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
    
    
//    static NSString *cellid=@"mycellid";
//    MessageListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
//    if (cell==nil) {
//       cell=[[[NSBundle mainBundle]loadNibNamed:@"PushMessageCell" owner:nil options:nil]lastObject];
//       cell.backgroundColor=[UIColor whiteColor];
//       cell.selectionStyle=UITableViewCellSelectionStyleNone;
//       cell.layer.cornerRadius = 3.0f;
//       cell.layer.masksToBounds = YES;
//    }
//  
//    MessgeListObj *obj=[self.dataArray objectAtIndex:indexPath.section];
// 
//    if ([obj.messagetype isEqualToString:@"1"])
//    cell.title_lab.text=obj.messaetitle;
//    else
//    cell.title_lab.text=obj.messaetitle;
//    
//    if(![obj.messagetype isEqualToString:@"1"]) cell.Topline.hidden=YES;
//    
//    UIView *view_bg=[[UIView alloc]init];
//    view_bg.backgroundColor=[UIColor whiteColor];
//    [cell.contentView addSubview:view_bg];
//    
//    UIImageView *image_desc;
//    if ([obj.messagetype isEqualToString:@"1"]) {
//        
//        image_desc=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kMainScreenWidth-50, 120)];
//    }
//    else{
//        image_desc=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kMainScreenWidth-50, 0)];
//        
//    }
//    image_desc.clipsToBounds=YES;
//    image_desc.contentMode=UIViewContentModeScaleAspectFill;
//    [image_desc sd_setImageWithURL:[NSURL URLWithString:obj.messagepicture ] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"] options:SDWebImageTransformAnimatedImage];
//    [view_bg addSubview:image_desc];
//    
//    
//    CGSize size_content;
//    if([obj.messagetype isEqualToString:@"1"]) size_content=[util calHeightForLabel:obj.messagedescri width:kMainScreenWidth-60 font:[UIFont systemFontOfSize:17.0]];
//    else size_content=[util calHeightForLabel:obj.messagecontent width:kMainScreenWidth-60 font:[UIFont systemFontOfSize:17.0]];
//    UILabel *content_Lab=[[UILabel alloc]init];
//    if([obj.messagetype isEqualToString:@"1"]) content_Lab.frame=CGRectMake(10,image_desc.frame.size.height+10 ,kMainScreenWidth-60 , size_content.height);
//    else content_Lab.frame=CGRectMake(10,image_desc.frame.size.height+5 ,kMainScreenWidth-60, size_content.height);
//    content_Lab.backgroundColor=[UIColor whiteColor];
//    content_Lab.numberOfLines=0;
//    if([obj.messagetype isEqualToString:@"1"]) content_Lab.text=obj.messagedescri;
//    else content_Lab.text=obj.messagecontent;
//    content_Lab.textAlignment=NSTextAlignmentLeft;
//    [view_bg addSubview:content_Lab];
//    
//    
//    if ([obj.messagetype isEqualToString:@"1"]){ UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"消息横条.png"]];
//    line.frame=CGRectMake(5, 15+image_desc.frame.size.height+size_content.height, kMainScreenWidth-50, 1);
//    [view_bg addSubview:line];
//    }
//    
//    if ([obj.messagetype isEqualToString:@"1"]){
//    UILabel *read_lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 10+image_desc.frame.size.height+size_content.height+14, 100, 30)];
//    read_lab.backgroundColor=[UIColor clearColor];
//    read_lab.font=[UIFont systemFontOfSize:18];
//    read_lab.textColor=[UIColor redColor];
//    read_lab.textAlignment=NSTextAlignmentLeft;
//    read_lab.text=@"查看详情";
//    [view_bg addSubview:read_lab];
//    }
//    
//    if ([obj.messagetype isEqualToString:@"1"]){
//    UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
//    line.frame=CGRectMake(kMainScreenWidth-60, 10+image_desc.frame.size.height+size_content.height+17, 10, 20);
//    [view_bg addSubview:line];
//    }
//    
//    if ([obj.messagetype isEqualToString:@"1"]) view_bg.frame=CGRectMake(4, 40, kMainScreenWidth-40, 10+image_desc.frame.size.height+size_content.height+40);
//    else view_bg.frame=CGRectMake(4, 3, kMainScreenWidth-40, 10+image_desc.frame.size.height+size_content.height);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessgeListObj *obj=[self.dataArray objectAtIndex:indexPath.section];
    
    if ([obj.messagetype isEqualToString:@"1"]) {
          DetailedIinforVC *detailvc=[[DetailedIinforVC alloc]init];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"get" object:obj.messagecontent];
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav pushViewController:detailvc animated:YES];
    }
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
         //[TLToast showWithText:@"亲，没有了哦" topOffset:350.0f duration:1.5];
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
    
    if(isFirstInt==YES){
        self.refreshing=NO;
        imageview_bg.hidden=YES;
        label_bg.hidden = YES;
        [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
    }
    else {
        [mtableview tableViewDidFinishedLoading];
        isFirstInt=!isFirstInt;
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
