//
//  HuoDoneViewController.m
//  IDIAI
//
//  Created by Ricky on 15/8/18.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "HuoDoneViewController.h"
#import "UIImageView+WebCache.h"
#import "SCGIFImageView.h"
#import "UIImage+GIF.h"
//#import "BannerInfoViewController.h"
#import "WTBWebViewViewController.h"
#import "IDIAIAppDelegate.h"
#import "TLToast.h"
#import "DirectionMPMoviePlayerViewController.h"
#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZTransitionInteractionControllerProtocol.h"

#define kimageview_tag 1000
#define kuilable_tag 10000
@interface HuoDoneViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger dataoldcount;
@property (nonatomic,assign)NSInteger willIndexRow;
@property (nonatomic,assign)NSInteger endIndexRow;

@end

@implementation HuoDoneViewController
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview_sub.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview_sub.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.dataArray=[NSMutableArray arrayWithCapacity:0];
    mtableview_sub=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0,kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
    mtableview_sub.pullingDelegate=self;
    //    mtableview_sub.backgroundColor=[UIColor clearColor];
    mtableview_sub.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    mtableview_sub.dataSource=self;
    mtableview_sub.delegate=self;
    mtableview_sub.showsHorizontalScrollIndicator=NO;
    mtableview_sub.showsVerticalScrollIndicator=NO;
    mtableview_sub.separatorStyle =UITableViewCellSeparatorStyleNone;
    mtableview_sub.headerOnly=YES;
    [self.view addSubview:mtableview_sub];
    [mtableview_sub launchRefreshing];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIButton *leftButton = (UIButton *)[self.view viewWithTag:10001];
    if (!leftButton){
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.tag = 10001;
        [leftButton setFrame:CGRectMake(Main_Screen_Width-45, 20, 35, 35)];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"btn_ganbi.png"] forState:UIControlStateNormal];
        //    [leftButton setBackgroundImage:[UIImage imageNamed:@"bt_back_pressed"] forState:UIControlStateHighlighted];
        //leftButton.imageEdgeInsets=UIEdgeInsetsMake(30, 20, 0, 60);
        [leftButton addTarget:self
                       action:@selector(PressBarItemLeft)
             forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:leftButton];
    }
    
    
}
-(void)PressBarItemLeft{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark - Request

//请求活动列表
-(void)requestBannerlist{
    // if([self.dataArray count]) [self.dataArray removeAllObjects];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        else{
            string_token=@"";
            string_userid=@"";
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0040\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"活动返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10401) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([self.dataArray count])
                            [self.dataArray removeAllObjects];
                        NSArray *arr_=[jsonDict objectForKey:@"bannerList"];
                        if([arr_ count]){
                            for(NSDictionary *dict in arr_){
                                //                                if([[dict objectForKey:@"bannerWay"] integerValue]==2)
                                [self.dataArray addObject:dict];
                                //                                else continue;
                            }
                        }
                        
                        [mtableview_sub reloadData];
                        [mtableview_sub tableViewDidFinishedLoading];
                        
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mtableview_sub tableViewDidFinishedLoading];
                        
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [mtableview_sub tableViewDidFinishedLoading];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}
#pragma mark -
#pragma mark - UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.1)];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49*kMainScreenWidth/64;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid=[NSString stringWithFormat:@"cell_smallid%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        // cell.backgroundColor=[UIColor clearColor];
    }
    if([self.dataArray count]){
        UIImageView *banner=(UIImageView *)[cell.contentView viewWithTag:kimageview_tag+indexPath.section];
        if(!banner) {
            banner=[[UIImageView alloc]initWithFrame:CGRectMake(0, -2, kMainScreenWidth, 49*kMainScreenWidth/64)];
            banner.image=[UIImage imageNamed:@"bg_morentu_xq"];
        }
        banner.tag=kimageview_tag+indexPath.section;
        banner.clipsToBounds = YES;
        banner.contentMode=UIViewContentModeRedraw;
        [cell.contentView addSubview:banner];
        
        dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(parsingQueue, ^{
            UIImage *img;
            if([[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"] length]>1){
                //                NSLog(@"banner ==========%@",[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"] substringFromIndex:([[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"] length]-3)]);
                //                NSLog(@"%d",[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"] length]-3)]);
                if ([[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"] substringFromIndex:([[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"] length]-3)] isEqualToString:@"gif"]) {
                    img =[UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"]]]];
                }else{
                    img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerUrl"]]]];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if(img.size.height) banner.image=img;
            });
        });
        
        UILabel *theme=(UILabel *)[cell.contentView viewWithTag:kuilable_tag+indexPath.section];
        //        if(!theme) theme=[[UILabel alloc]initWithFrame:CGRectMake(10, 170, kMainScreenWidth-20, 20)];
        if(!theme) theme=[[UILabel alloc]initWithFrame:CGRectMake(10, 49*kMainScreenWidth/64-30, kMainScreenWidth-20, 20)];//新需求 上移
        theme.tag=kuilable_tag+indexPath.section;
        theme.textAlignment=NSTextAlignmentLeft;
        theme.font=[UIFont systemFontOfSize:15];
        theme.textColor=[UIColor blackColor];
        
        if(![[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerName"]isEqual:[NSNull null]])
            theme.text=[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerName"];
        else
            theme.text=@"";
        [cell.contentView addSubview:theme];
        
        if([[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerType"] integerValue]==2){
            UIButton *btn_video=(UIButton *)[cell.contentView viewWithTag:kuilable_tag*2+indexPath.section];
            if(!btn_video) btn_video=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 49*kMainScreenWidth/64)];
            btn_video.tag=kuilable_tag*2+indexPath.section;
            [btn_video setImage:[UIImage imageNamed:@"ic_bofang"] forState:UIControlStateNormal];
            [btn_video setImage:[UIImage imageNamed:@"ic_bofang_pressed"] forState:UIControlStateHighlighted];
            [btn_video addTarget:self action:@selector(PlayVideo:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn_video];
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"isValid"] integerValue]==1){
        if([[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerType"] integerValue]==1){
            if(![[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerDetailUrl"] isEqual:[NSNull null]]){
                WTBWebViewViewController *bannervc=[[WTBWebViewViewController alloc]init];
                bannervc.requesUrl=[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerDetailUrl"];
//                [self.navigationController setNavigationBarHidden:NO animated:YES];
                [self.navigationController pushViewController:bannervc animated:YES];
            }
            else{
                [TLToast showWithText:@"亲，暂时无活动详情" topOffset:200.0f duration:1.5];
            }
        }
        else{
            //                DirectionMPMoviePlayerViewController *playerView = [[DirectionMPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"bannerDetailUrl"]]];
            //                playerView.view.frame = self.view.frame;//全屏播放（全屏播放不可缺）
            //                playerView.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;//全屏播放（全屏播放不可缺）
            //                [[NSNotificationCenter defaultCenter] addObserver:self
            //                                                         selector:@selector(myMovieFinishedCallback:)
            //                                                             name:MPMoviePlayerPlaybackDidFinishNotification
            //                                                           object:playerView];
            //                [playerView.moviePlayer play];
            //                [self presentMoviePlayerViewControllerAnimated:playerView];
        }
    }
    else{
        [TLToast showWithText:@"亲，此活动已结束" topOffset:200.0f duration:1.5];
    }

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
        UIImageView *banner=(UIImageView *)[cell.contentView viewWithTag:kimageview_tag+indexPath.section];
        float oldY =banner.frame.origin.y;
        float width = banner.frame.size.width;
        float height = banner.frame.size.height;
        NSLog(@"%lu",(unsigned long)self.dataArray.count);
        NSLog(@"will =%ld",(long)indexPath.section);
        //    if (indexPath.section!=dataArray.count-16) {
        
        
        //    if (self.isrequst ==NO) {
        if (self.dataoldcount==self.dataArray.count) {
            NSInteger max =MAX(self.willIndexRow, self.endIndexRow);
            NSInteger min =MIN(self.willIndexRow, self.endIndexRow);
            if (min ==0&&max==0) {
                min =0;
                if ((int)Main_Screen_Height%(int)(49*kMainScreenWidth/64)>0) {
                    max =Main_Screen_Height/(int)(49*kMainScreenWidth/64)-2;
                }else {
                    max =Main_Screen_Height/(int)(49*kMainScreenWidth/64)-1;
                }
            }
            if (indexPath.section>max||indexPath.section<min) {
                
                banner.frame =CGRectMake(banner.frame.size.width/2-(Main_Screen_Width-20)/2, banner.frame.origin.y+banner.frame.size.height/2-(banner.frame.size.height-50)/2, Main_Screen_Width-20, banner.frame.size.height-50);
                [UIView beginAnimations:@"showcell" context:NULL];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDuration:0.3];
                banner.frame =CGRectMake(0, oldY, width, height);
                [UIView commitAnimations];
                self.willIndexRow =indexPath.section;
            }
            
        }
        if (indexPath.section<self.dataArray.count) {
            self.dataoldcount =self.dataArray.count;
        }
        
        //    }
        
        //    }
    
    
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
    [self requestBannerlist];
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
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
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}
-(void)PlayVideo:(UIButton *)btn{
    
    DirectionMPMoviePlayerViewController *playerView = [[DirectionMPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:btn.tag-kuilable_tag*2] objectForKey:@"bannerDetailUrl"]]];
    playerView.view.frame = self.view.frame;//全屏播放（全屏播放不可缺）
    playerView.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;//全屏播放（全屏播放不可缺）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerView];
    [playerView.moviePlayer play];
    [self presentMoviePlayerViewControllerAnimated:playerView];
}
-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    DirectionMPMoviePlayerViewController* theMovie = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    
    [theMovie removeFromParentViewController];
}
#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [mtableview_sub tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView==mtableview_sub) {
        [mtableview_sub tableViewDidEndDragging:scrollView];
    }

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  
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
