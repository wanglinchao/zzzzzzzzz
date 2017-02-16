//
//  DecorateProcessVCViewController.m
//  IDIAI
//
//  Created by iMac on 14-7-15.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DecorateProcessVCViewController.h"
#import "HexColor.h"
#import "DecorateInfoVC.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "CircleProgressHUD.h"
#import "DecorateProcessObj.h"
#import "UIImageView+WebCache.h"
#import "savelogObj.h"
#import "TLToast.h"
#import "IDIAIAppDelegate.h"
#import "util.h"

#define KSubjectTitleTAG 100000
#define KPicture_TAG 200000
#define KDescription_TAG 300000

@interface DecorateProcessVCViewController ()
{

//    UIScrollView *scr;
}
@end

@implementation DecorateProcessVCViewController
@synthesize knowledge_type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self requestKnowledgelist];
}
-(void)backTouched:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.title = @"装修知识";
    self.view.backgroundColor = [UIColor whiteColor];

    [savelogObj saveLog:@"用户查看知识" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:14];
    
    self.currentPage=0;
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight - kTabBarHeight) pullingDelegate:self];
    mtableview = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight  - kTabBarHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    mtableview.pullingDelegate = self;
//    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    [mtableview setHeaderOnly:YES];          //只有下拉刷新
    //    [mtableview setFooterOnly:YES];         //只有上拉加载
    //[mtableview launchRefreshing];
    [self.view addSubview:mtableview];
    
    self.data_Array =[[NSMutableArray alloc]initWithCapacity:0];
    
    [self loadImageviewBG];

    [self requestKnowledgelist];
}


-(void)requestKnowledgelist{
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
    NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0013\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\"}&body={\"knowledgeTypeID\":\"%ld\",\"requestRow\":\"10\",\"currentPage\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,(long)self.selected_id,(long)self.currentPage+1];
     
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
               // NSLog(@"know_message返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10161) {
                    //得到总的页数
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                        self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                        if (self.currentPage ==1) {
                            [self.data_Array removeAllObjects];
                        }
                        for (NSDictionary *dict in [jsonDict objectForKey:@"knowledgeList"]){
                            @autoreleasepool {
                                [self.data_Array addObject:[DecorateProcessObj objWithDict:dict]];
                            }
                        }
                        imageview_bg.hidden=YES;
                        label_bg.hidden = YES;
                        [mtableview reloadData];
                        [mtableview tableViewDidFinishedLoading];
                       
                    });
                }
                else if (code==10169) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
                    
                        if(![self.data_Array count]) {
                            imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                        }
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
                      
                        if(![self.data_Array count]) {
                            imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                        }
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
                           
                                  if(![self.data_Array count]) {
                                      imageview_bg.hidden=NO;
                                  label_bg.hidden = NO;
                                  }
                              });
                          }
                               method:url postDict:nil];
    });
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.data_Array.count>0) {
        DecorateProcessObj *obj=[self.data_Array objectAtIndex:indexPath.section];
        NSString *desc=[NSString stringWithFormat:@"%@ ",obj.knowledgeDescription];
        
        CGSize size=[util calHeightForLabel:desc width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:16]];
        if(size.height>45) size.height=45;
        float height=10+20+10+(kMainScreenWidth-40)*1.1/2+10+size.height+10;
        
        return height;
    }else{
        return 0;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.data_Array.count>0) {
        return [self.data_Array count];
    }else{
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellider=[NSString stringWithFormat:@"MycellIder_%ld",(long)indexPath.section];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellider];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellider];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if([self.data_Array count]){
        DecorateProcessObj *obj=[self.data_Array objectAtIndex:indexPath.section];
        
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        view.layer.cornerRadius=5;
        [cell addSubview:view];
        
        UILabel *lab_title=(UILabel *)[cell viewWithTag:KSubjectTitleTAG+indexPath.section];
        if(!lab_title) lab_title=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, kMainScreenWidth-40, 20)];
        lab_title.tag=KSubjectTitleTAG+indexPath.section;
        lab_title.backgroundColor=[UIColor clearColor];
        lab_title.textAlignment=NSTextAlignmentLeft;
        lab_title.textColor=[UIColor colorWithHexString:@"#575757"];
        lab_title.font=[UIFont systemFontOfSize:16];
        lab_title.text=obj.knowledgeTitle;
        [cell addSubview:lab_title];
        
        UIImageView *logo=(UIImageView *)[cell viewWithTag:KPicture_TAG+indexPath.section];
        if(!logo) logo=[[UIImageView alloc]initWithFrame:CGRectMake(20, 40, kMainScreenWidth-40, (kMainScreenWidth-40)*1.1/2)];
        logo.tag=KPicture_TAG+indexPath.section;
        logo.contentMode=UIViewContentModeScaleAspectFill;
        logo.layer.cornerRadius=3;
        logo.layer.masksToBounds=YES;
        //[logo sd_setImageWithURL:[NSURL URLWithString:obj.knowledgeLogoPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_naobu"]];
        [cell addSubview:logo];
        [logo sd_setImageWithURL:[NSURL URLWithString:obj.knowledgeLogoPath] placeholderImage:[UIImage imageNamed:@"bg_morentu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image) {
                //产生逐渐显示的效果
                logo.alpha=0.2;
                [UIView animateWithDuration:0.5 animations:^(){
                    logo.alpha=1.0;
                }completion:^(BOOL finished){
                    
                }];
            }
        }];

        
        NSString *desc=[NSString stringWithFormat:@"%@ ",obj.knowledgeDescription];
        CGSize size=[util calHeightForLabel:desc width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:16]];
        if(size.height>45) size.height=45;
        UILabel *lab_desc=(UILabel *)[cell viewWithTag:KDescription_TAG+indexPath.section];
        if(!lab_desc) lab_desc=[[UILabel alloc]initWithFrame:CGRectMake(24, logo.frame.origin.y+logo.frame.size.height+10, kMainScreenWidth-40, size.height)];
        lab_desc.tag=KDescription_TAG+indexPath.section;
        lab_desc.backgroundColor=[UIColor clearColor];
        lab_desc.textAlignment=NSTextAlignmentLeft;
        lab_desc.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
        lab_desc.font=[UIFont systemFontOfSize:14];
        lab_desc.numberOfLines=2;
        lab_desc.text=obj.knowledgeDescription;
        [cell addSubview:lab_desc];
        
        view.frame=CGRectMake(10, 0, kMainScreenWidth-20, 10+lab_title.frame.size.height+10+lab_desc.frame.size.height+10+logo.frame.size.height+10);
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DecorateProcessObj *obj_=[self.data_Array objectAtIndex:indexPath.section];
    DecorateInfoVC *decvc=[[DecorateInfoVC alloc]init];
    decvc.obj=obj_;
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
    [appDelegate.nav pushViewController:decvc animated:YES];
//    [self.navigationController pushViewController:decvc animated:YES];
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        [self.data_Array removeAllObjects];
        self.currentPage=0;
        [self requestKnowledgelist];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestKnowledgelist];
        }
        else{
            [self stopRequest];
            [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            mtableview.reachedTheEnd = YES;  //是否加载到底了
            //[TLToast showWithText:@"亲，没有了哦" topOffset:350.0f duration:1.5];
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    self.refreshing=YES;
//    [self createProgressView];
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
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    self.refreshing=NO;
//    [self createProgressView];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"woooooooooooooooo");
    if (mtableview.contentOffset.y<-60) {
        mtableview.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [mtableview tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{   NSLog(@"hahhhahahahahhahaha");
    [mtableview tableViewDidEndDragging:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
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
