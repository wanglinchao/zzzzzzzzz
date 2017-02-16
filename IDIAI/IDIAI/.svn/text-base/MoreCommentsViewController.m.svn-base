//
//  MoreCommentsViewController.m
//  IDIAI
//
//  Created by iMac on 15-2-10.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MoreCommentsViewController.h"
#import "HexColor.h"
#import "util.h"
#import "IDIAIAppDelegate.h"
#import "EmptyClearTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#define Kcelltag 1000
@interface MoreCommentsViewController ()

@end

@implementation MoreCommentsViewController
@synthesize role_id,client_id;

- (void)customizeNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor darkGrayColor];
    lab_nav_title.text=@"更多评论";
    self.navigationItem.titleView = lab_nav_title;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 50);
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
    if ([self.fromVCStr isEqualToString:@"111"]) {
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav setNavigationBarHidden:YES animated:YES];
    }
//    if (![self.fromVCStr isEqualToString:@"collectionVC"]) {
//        [delegate.nav setNavigationBarHidden:NO animated:YES];
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [MobClick event:@"Click_gz_detail_morecomment"];   //友盟自定义事件,数量统计
    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    [self customizeNavigationBar];
    
    dataArray =[[NSMutableArray alloc]initWithCapacity:0];
    self.currentPage=0;

    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) pullingDelegate:self];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [mtableview launchRefreshing];
    [self.view addSubview:mtableview];
}

//请求评论列表
-(void)requestCommentsList{
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
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0037\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeId\":\"%@\",\"objectId\":\"%@\",\"currentPage\":\"%ld\",\"requestRow\":\"15\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],role_id,client_id,(long)self.currentPage+1];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"评论列表返回信息：%@",jsonDict);
                NSArray *arr_pl=[jsonDict objectForKey:@"objectScoreList"];
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10371) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        self.currentPage=[[jsonDict objectForKey:@"currentPage"] integerValue];
                        self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                        if([arr_pl count]){
                            if(self.refreshing==YES) {
                                if ([dataArray count]) [dataArray removeAllObjects];
                            }
                            
                            for(NSDictionary *dict in arr_pl)
                                [dataArray addObject:dict];
                        }
                        
                        [mtableview tableViewDidFinishedLoading];
                        [mtableview reloadData];
                    });
                }
                else if (code==10379) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                       [mtableview tableViewDidFinishedLoading];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                       [mtableview tableViewDidFinishedLoading];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                [mtableview tableViewDidFinishedLoading];  
                              });
                          }
                               method:url postDict:nil];
    });
}

#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([dataArray count]){
        NSString *string_pl=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"objectString"];
        CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",string_pl] width:kMainScreenWidth-70 font:[UIFont systemFontOfSize:15]];
        NSString *string_levelpic=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"levelPic"];
        int height =0;
        if (string_levelpic.length!=0) {
            height=92;
        }
        return 40+size.height+10+height;
    }
    else{
        NSString *string_levelpic=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"levelPic"];
        int height =0;
        if (string_levelpic.length!=0) {
            height=92;
        }
      return 60+height;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"cellid";
    EmptyClearTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"EmptyClearTableViewCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    UIImageView *PlunLogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    PlunLogo.contentMode=UIViewContentModeScaleAspectFill;
    PlunLogo.layer.cornerRadius=20;
    PlunLogo.layer.masksToBounds=YES;
    PlunLogo.clipsToBounds=YES;
    [cell addSubview:PlunLogo];
    
    NSInteger  assessType  = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"assessType"]integerValue] ;
//    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(parsingQueue, ^{
//        UIImage *img;
//        
//        if (assessType==1) {
//            photo_pl.image=[UIImage imageNamed:@"ic_touxiang_tk_over.png"];
//        }else if(assessType==2){
//            if ([[self.dataArray_pl objectAtIndex:i] objectForKey:@"userLogos"]) {
//                
//                [photo_pl sd_setImageWithURL:[NSURL URLWithString:[[self.dataArray_pl objectAtIndex:i] objectForKey:@"userLogos"]] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
//            }
//            
//        }else{
//            if([[[self.dataArray_pl objectAtIndex:i] objectForKey:@"userLogos"] length]>1)
//                img=[UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[[[self.dataArray_pl objectAtIndex:i] objectForKey:@"userLogos"] stringByReplacingOccurrencesOfString:@"\n" withString:@""]  options:NSDataBase64DecodingIgnoreUnknownCharacters]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if(img.size.height) photo_pl.image=img;
//            });
//            
//            
//        }
//        
//    });

    PlunLogo.image=[UIImage imageNamed:@"ic_touxiang_tk_over.png"];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        if (assessType==1) {
            PlunLogo.image=[UIImage imageNamed:@"ic_touxiang_tk_over.png"];
        }else if(assessType==2){
            if ([[dataArray objectAtIndex:indexPath.row] objectForKey:@"userLogos"]) {
                
                [PlunLogo sd_setImageWithURL:[NSURL URLWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"userLogos"]] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
            }
            
        }else{
            if([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"userLogos"] length]>1)
                [PlunLogo sd_setImageWithURL:[NSURL URLWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"userLogos"]] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
        }
    });
    
    NSString *nameStr = [[dataArray objectAtIndex:indexPath.row]objectForKey:@"nickName"];
    CGSize  size1 = [util calHeightForLabel:nameStr width:100 font:[UIFont systemFontOfSize:13.0]];
    NSLog(@"size===============%f,%f",size1.width,size1.height);
    UILabel *plName=[[UILabel alloc]initWithFrame:CGRectMake(60, 13, size1.width, size1.height)];
    plName.backgroundColor=[UIColor clearColor];
    plName.textAlignment=NSTextAlignmentLeft;
    plName.textColor=[UIColor lightGrayColor];
    plName.font=[UIFont systemFontOfSize:13];
    if(nameStr.length) plName.text = nameStr;
    else plName.text=@"匿名用户";
    [cell addSubview:plName];

    UILabel * roleLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(plName.frame)+15,CGRectGetMinY(plName.frame),30, CGRectGetHeight(plName.frame))];
    [cell addSubview:roleLab];
    roleLab.layer.cornerRadius = 7;
    roleLab.textAlignment= NSTextAlignmentCenter;
    roleLab.clipsToBounds=YES;
    roleLab.font =[UIFont systemFontOfSize:12];
    roleLab.textColor = [UIColor whiteColor];
    if (assessType==1) {//客服
        roleLab.backgroundColor = emphasizeTextColor;
        roleLab.text = @"官方";
    }else if(assessType==2){//监理
        roleLab.backgroundColor = [UIColor colorWithHexString:@"#35BB9D" alpha:1.0];;
        roleLab.text = @"监理";
    }else {//业主
        roleLab.backgroundColor = emphasizeTextColor;
        roleLab.text = @"业主";
    }


    NSArray *arr=[[[dataArray objectAtIndex:indexPath.row]objectForKey:@"createDate"] componentsSeparatedByString:@" "];
    UILabel *plDate=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-100-24,  12, 100, 20)];
//    UILabel *timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-100-44, nameLabel.frame.origin.y, 100, 10)];
    plDate.backgroundColor=[UIColor clearColor];
    plDate.textAlignment=NSTextAlignmentRight;
    plDate.textColor=[UIColor lightGrayColor];
    plDate.font=[UIFont systemFontOfSize:13];
    if([arr count]) plDate.text=[arr firstObject];
    [cell addSubview:plDate];
    
    NSString *string_pl=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"objectString"];
    CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",string_pl] width:kMainScreenWidth-70 font:[UIFont systemFontOfSize:15]];
    UILabel *plContent=[[UILabel alloc]initWithFrame:CGRectMake(60, 37, kMainScreenWidth-70, size.height)];
    plContent.backgroundColor=[UIColor clearColor];
    plContent.textAlignment=NSTextAlignmentLeft;
    plContent.textColor=[UIColor grayColor];
    plContent.font=[UIFont systemFontOfSize:15];
    plContent.numberOfLines=0;
    plContent.text=string_pl;
    [cell addSubview:plContent];
    
    NSString *string_levelpic=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"levelPic"];
    if (string_levelpic.length>0) {
        NSArray *picArray =[string_levelpic componentsSeparatedByString:@","];
        for (int j=0; j<picArray.count; j++) {
            UIImageView *contentimage =[[UIImageView alloc] initWithFrame:CGRectMake(plContent.frame.origin.x+92*j, plContent.frame.origin.y+plContent.frame.size.height+10, 82, 82)];
            [contentimage sd_setImageWithURL:[NSURL URLWithString:[picArray objectAtIndex:j]] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
            contentimage.userInteractionEnabled =YES;
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [contentimage addGestureRecognizer:tap];
            contentimage.tag =1000+j;
            [cell addSubview:contentimage];
        }
    }
    
    UIView *line_=[[UIView alloc]initWithFrame:CGRectMake(10, 40+size.height+9.5, kMainScreenWidth-20, 0.5)];
    if (string_levelpic.length>0) {
        line_.frame =CGRectMake(10, 40+size.height+9.5+92, kMainScreenWidth-20, 0.5);
    }
    line_.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
    line_.alpha=0.5;
    [cell addSubview:line_];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tapAction:(UITapGestureRecognizer *)sender{
    UIImageView *image =(UIImageView  *)sender.view;

    UITableViewCell *cell =(UITableViewCell *)[image superview];
    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
    NSDictionary *contentdic =[dataArray objectAtIndex:indexPath.row];
    NSArray *photosArray =[[contentdic objectForKey:@"levelPic"] componentsSeparatedByString:@","];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:photosArray.count];
    for (int i = 0; i<photosArray.count; i++) {
        // 替换为中等尺寸图片
        NSString *url = photosArray[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = (UIImageView *)sender.view; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = image.tag-1000; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    //    browser.describe =selectpic.phasePicDescription;
    [browser show];
}
#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=0;
        [self requestCommentsList];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestCommentsList];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
