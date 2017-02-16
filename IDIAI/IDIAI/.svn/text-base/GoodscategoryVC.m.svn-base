//
//  GoodscategoryVC.m
//  IDIAI
//
//  Created by iMac on 14-7-31.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GoodscategoryVC.h"
#import "HexColor.h"
#import "GoodscategCellTableViewCell.h"
#import "GoodsInfoVC.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "UIImageView+OnlineImage.h"
#import "CircleProgressHUD.h"

#define KButtonTag 100
@interface GoodscategoryVC ()
{
    CircleProgressHUD *phud;
    UIImageView *imageview_bg;
    UILabel *label_bg;
}
@end

@implementation GoodscategoryVC
@synthesize entrance_type,delegate;

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
    label.text =@"商品分类";
    [self.view addSubview:label];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(10, 25, 50, 28)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回键.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(backTouched:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:statusBarView];
}

-(void)viewWillAppear:(BOOL)animated{
    [[[self navigationController] navigationBar] setHidden:YES];
}
-(void)backTouched:(UIButton *)btn{
    [phud hide];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
    [self customizeNavigationBar];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) pullingDelegate:self];
    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [mtableview setHeaderOnly:YES];       //只有下拉刷新
    //[mtableview setFooterOnly:YES];     //只有上拉加载
    [mtableview launchRefreshing];
    [self.view addSubview:mtableview];
    
    self.dataArray =[NSMutableArray arrayWithCapacity:0];
    [self loadImageviewBG];
    [self createProgressView];
}

-(void)loadImageviewBG{
    if(!imageview_bg)
        imageview_bg=[[UIImageView alloc]initWithFrame:CGRectMake(40, 150, kMainScreenWidth-80, 200)];
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


-(void)requestshopslist{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0003\",\"deviceType\":\"ios\",\"token\":\"\",\"userID\":\"\"}&body={}",kDefaultUpdateVersionServerURL];
        
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                //NSLog(@"message返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10031) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *arr_=[jsonDict objectForKey:@"classificationList"];
                        [self.dataArray removeAllObjects];
                        if([arr_ count]){
                        for(NSDictionary *dict in arr_){
                            [self.dataArray addObject:dict];
                        }
                        }
                        imageview_bg.hidden=YES;
                        label_bg.hidden = YES;
                        [mtableview reloadData];
                        [mtableview tableViewDidFinishedLoading];
                        [phud hide];
                    });
                }
                else if (code==10039) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mtableview tableViewDidFinishedLoading];
                        [phud hide];
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mtableview tableViewDidFinishedLoading];
                        [phud hide];
                        if(![self.dataArray count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [mtableview tableViewDidFinishedLoading];
                                  [phud hide];
                                  if(![self.dataArray count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count=[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"businessTypeList"]count];
    //int index_firs=count%4;
    int index_second=count/4;
    NSInteger height=0.0;
    if(index_second>=3) height=25*index_second;
    return 100.0+height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycellid";
    GoodscategCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GoodscategCellTableViewCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    NSInteger count=[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"businessTypeList"]count];
    long index_second=count/4;
    NSInteger height=0.0;
    if(index_second>=3) height=25*index_second;
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 97.0+height, 320, 5)];
    line.image=[UIImage imageNamed:@"粗分割线.png"];
    [cell addSubview:line];
    
    if([self.dataArray count]){
        cell.image_icon.image=[UIImage imageNamed:@"设计师图集默认图片.png"];
        UIImage *image_zs=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"classfiedLogoPath"]]]];
        if(image_zs) {
            cell.image_icon.image=nil;
            cell.image_icon.image=image_zs;
        }
    cell.title_main.text=[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"classfiedName"];
        
    }
    
    if ([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"businessTypeList"]count]) {
        for (int i=0; i<[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"businessTypeList"]count]; i++) {
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(80+60*(i%4), 50+(i/4)*25, 60, 20)];
            [btn setTitle:[[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"businessTypeList"]objectAtIndex:i] objectForKey:@"businessTypeName"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#6d2907" alpha:1.0] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:14];
            btn.tag=KButtonTag*(indexPath.row+1)+i;
            [btn addTarget:self action:@selector(pressbtnToPre:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)pressbtnToPre:(UIButton*)btn{
    if ([[NSString stringWithFormat:@"%d",btn.tag] length]==3) {
        NSInteger weis=[[[NSString stringWithFormat:@"%d",btn.tag] substringWithRange:NSMakeRange(0, 1)] integerValue];
        NSInteger jig=btn.tag-KButtonTag*(weis-1+1);
        if([entrance_type isEqualToString:@"goods"]){
            [delegate selectedThing:[NSString stringWithFormat:@"%@",[[[[self.dataArray objectAtIndex:weis-1] objectForKey:@"businessTypeList"]objectAtIndex:jig] objectForKey:@"businessTypeId"]] Title:[[[[self.dataArray objectAtIndex:weis-1] objectForKey:@"businessTypeList"]objectAtIndex:jig] objectForKey:@"businessTypeName"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if ([entrance_type isEqualToString:@"search"]) {
            GoodsInfoVC *goodvc=[[GoodsInfoVC alloc]init];
            goodvc.business_id=[NSString stringWithFormat:@"%@",[[[[self.dataArray objectAtIndex:weis-1] objectForKey:@"businessTypeList"]objectAtIndex:jig] objectForKey:@"businessTypeId"]];
            goodvc.search_content=@"";
            goodvc.title_lab=[[[[self.dataArray objectAtIndex:weis-1] objectForKey:@"businessTypeList"]objectAtIndex:jig] objectForKey:@"businessTypeName"];
            [self.navigationController pushViewController:goodvc animated:YES];
        }
    }
    if ([[NSString stringWithFormat:@"%d",btn.tag] length]==4) {
         NSInteger weis=[[[NSString stringWithFormat:@"%d",btn.tag] substringWithRange:NSMakeRange(0, 2)] integerValue];
        NSInteger jig=btn.tag-KButtonTag*(weis-1+1);
        if([entrance_type isEqualToString:@"goods"]){
        [delegate selectedThing:[NSString stringWithFormat:@"%@",[[[[self.dataArray objectAtIndex:weis-1] objectForKey:@"businessTypeList"]objectAtIndex:jig] objectForKey:@"businessTypeId"]] Title:[[[[self.dataArray objectAtIndex:weis-1] objectForKey:@"businessTypeList"]objectAtIndex:jig] objectForKey:@"businessTypeName"]];
        [self.navigationController popViewControllerAnimated:YES];
        }
        if ([entrance_type isEqualToString:@"search"]) {
            GoodsInfoVC *goodvc=[[GoodsInfoVC alloc]init];
            goodvc.business_id=[NSString stringWithFormat:@"%@",[[[[self.dataArray objectAtIndex:weis-1] objectForKey:@"businessTypeList"]objectAtIndex:jig] objectForKey:@"businessTypeId"]];
            goodvc.search_content=@"";
            goodvc.title_lab=[[[[self.dataArray objectAtIndex:weis-1] objectForKey:@"businessTypeList"]objectAtIndex:jig] objectForKey:@"businessTypeName"];
            [self.navigationController pushViewController:goodvc animated:YES];
        }
    }
    if ([[NSString stringWithFormat:@"%d",btn.tag] length]==5) {
         NSInteger weis=[[[NSString stringWithFormat:@"%d",btn.tag] substringWithRange:NSMakeRange(0, 3)] integerValue];
        NSInteger jig=btn.tag-KButtonTag*(weis-1+1);
        if([entrance_type isEqualToString:@"goods"]){
        [delegate selectedThing:[NSString stringWithFormat:@"%@",[[[[self.dataArray objectAtIndex:weis-1] objectForKey:@"businessTypeList"]objectAtIndex:jig] objectForKey:@"businessTypeId"]] Title:[[[[self.dataArray objectAtIndex:weis-1] objectForKey:@"businessTypeList"]objectAtIndex:jig] objectForKey:@"businessTypeName"]];
        [self.navigationController popViewControllerAnimated:YES];
        }
        if ([entrance_type isEqualToString:@"search"]) {
            GoodsInfoVC *goodvc=[[GoodsInfoVC alloc]init];
            goodvc.business_id=[NSString stringWithFormat:@"%@",[[[[self.dataArray objectAtIndex:weis-1] objectForKey:@"businessTypeList"]objectAtIndex:jig] objectForKey:@"businessTypeId"]];
            goodvc.search_content=@"";
            goodvc.title_lab=[[[[self.dataArray objectAtIndex:weis-1] objectForKey:@"businessTypeList"]objectAtIndex:jig] objectForKey:@"businessTypeName"];
            [self.navigationController pushViewController:goodvc animated:YES];
        }
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
    [self requestshopslist];
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    [self createProgressView];
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
