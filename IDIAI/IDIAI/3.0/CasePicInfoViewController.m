//
//  CasePicInfoViewController.m
//  IDIAI
//
//  Created by iMac on 16/4/6.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CasePicInfoViewController.h"
#import "MyeffectPictureObj.h"
#import "UIImageView+WebCache.h"
#import "util.h"
#import <QuartzCore/QuartzCore.h>
#import "CaseShowPicViewController.h"
#import "SharePcitureView.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "TLToast.h"

#define kTapImage_TAG 1000
#define kCell_TAG 1000000
@interface CasePicInfoViewController ()<SharePicViewDelegate>

@property (nonatomic,strong) UIView *footView;

@end

@implementation CasePicInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"案例详情";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)PressBarItemRight{
    SharePcitureView *shareView=[[SharePcitureView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 100)];
    shareView.delegate=self;
    shareView.isdiary=YES;
    [UIView animateWithDuration:.25 animations:^{
        shareView.frame=CGRectMake(0, kMainScreenHeight-100, kMainScreenWidth, 100);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
    [shareView show];
}

- (void)backButtonPressed:(id)sender {
    self.selectDoneCaseInfo(self.currentPage,self.totalPages,self.dataArr);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    //导航右按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(5, 5, 80, 40)];
    [rightButton setImage:[UIImage imageNamed:@"ic_fenxiang_2"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 50, 0, -10);
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    mTableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64 ) style:UITableViewStylePlain];
    mTableView.pullingDelegate=self;
    mTableView.delegate=self;
    mTableView.dataSource=self;
    mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [mTableView setHeaderOnly:YES];          //只有下拉刷新
    [mTableView setFooterOnly:YES];         //只有上拉加载
    [self.view addSubview:mTableView];
    
    mTableView.showsHorizontalScrollIndicator=NO;
    mTableView.showsVerticalScrollIndicator=NO;
    mTableView.pagingEnabled=YES;
    //使用UIView的transform属性
    mTableView.transform=CGAffineTransformMakeRotation(-M_PI_2);
    mTableView.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64);
    
    [mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_indexSort inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    [self requestBrower];   //发送浏览量+1
    
    if(_indexSort < [_dataArr count]){
        MyeffectPictureObj *obj=_dataArr[_indexSort];
        obj.browserNum=[NSString stringWithFormat:@"%d",[obj.browserNum intValue]+1];
    }
}

#pragma mark - UIGestureRecognizer
-(void)TapActionImage:(UIGestureRecognizer *)gesture{
    if([[UIDevice currentDevice].systemVersion floatValue]>=8.0)
        _indexSort=gesture.view.superview.superview.superview.superview.tag-kCell_TAG;
    else
        _indexSort=gesture.view.superview.superview.superview.superview.superview.tag-kCell_TAG;
    
    MyeffectPictureObj *obj=_dataArr[_indexSort];
    CaseShowPicViewController *picvc=[[CaseShowPicViewController alloc]init];
    picvc.obj_effect=obj;
    picvc.data_array=obj.picList;
    picvc.pic_id=gesture.view.tag-kTapImage_TAG;
    [self.navigationController pushViewController:picvc animated:YES];
}

#pragma mark -
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMainScreenWidth;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"MyCellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor colorWithHexString:@"#efeff4" alpha:1.0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        
        UIScrollView *scrView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
        scrView.tag=2000;
        [cell.contentView addSubview:scrView];
        
        UIView *view_Top=[[UIView alloc]init];
        view_Top.tag=1007;
        view_Top.backgroundColor=[UIColor whiteColor];
        [scrView addSubview:view_Top];
        UIView *view_Foot=[[UIView alloc]init];
        view_Foot.tag=1008;
        view_Foot.backgroundColor=[UIColor whiteColor];
        [scrView addSubview:view_Foot];
        
        UIImageView *coverImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth*4/5)];
        coverImage.tag=1000;
        coverImage.contentMode=UIViewContentModeScaleAspectFill;
        coverImage.clipsToBounds=YES;
        coverImage.userInteractionEnabled=YES;
        [scrView addSubview:coverImage];
        
        UILabel *houseModel=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(coverImage.frame)+20, kMainScreenWidth-30, 20)];
        houseModel.tag=1001;
        houseModel.backgroundColor=[UIColor clearColor];
        houseModel.textAlignment=NSTextAlignmentCenter;
        houseModel.textColor=[UIColor colorWithHexString:@"#575757" alpha:1.0];
        houseModel.font=[UIFont systemFontOfSize:15];
        [scrView addSubview:houseModel];
        
        UILabel *styleArea=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(houseModel.frame)+10, kMainScreenWidth-30, 20)];
        styleArea.tag=1002;
        styleArea.backgroundColor=[UIColor clearColor];
        styleArea.textAlignment=NSTextAlignmentCenter;
        styleArea.textColor=[UIColor lightGrayColor];
        styleArea.font=[UIFont systemFontOfSize:15];
        [scrView addSubview:styleArea];
        
        UILabel *descCri=[[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(styleArea.frame)+10, kMainScreenWidth-60, 20)];
        descCri.tag=1003;
        descCri.backgroundColor=[UIColor clearColor];
        descCri.textAlignment=NSTextAlignmentLeft;
        descCri.textColor=[UIColor lightGrayColor];
        descCri.font=[UIFont systemFontOfSize:15];
        descCri.numberOfLines=0;
        [scrView addSubview:descCri];
        
        UILabel *brower=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-90, CGRectGetMaxY(descCri.frame)+10, 60, 20)];
        brower.tag=1005;
        brower.backgroundColor=[UIColor clearColor];
        brower.textAlignment=NSTextAlignmentLeft;
        brower.textColor=[UIColor lightGrayColor];
        brower.font=[UIFont systemFontOfSize:15];
        [scrView addSubview:brower];
        
        UIImageView *browerLogo=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(brower.frame)-23, CGRectGetMaxY(descCri.frame)+13, 18, 16)];
        browerLogo.tag=1004;
        browerLogo.contentMode=UIViewContentModeScaleAspectFill;
        browerLogo.clipsToBounds=YES;
        browerLogo.image=[UIImage imageNamed:@"ic_liulanliang"];
        [scrView addSubview:browerLogo];
        
        view_Top.frame=CGRectMake(0, 0, kMainScreenWidth, CGRectGetMaxY(brower.frame)+20);
        
        float height=80*kMainScreenWidth/320;
        UIScrollView *imageScr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view_Top.frame)+50, kMainScreenHeight, height)];
        imageScr.showsHorizontalScrollIndicator=NO;
        imageScr.showsVerticalScrollIndicator=NO;
        imageScr.tag=1006;
        [scrView addSubview:imageScr];
        
        view_Foot.frame=CGRectMake(0, CGRectGetMaxY(view_Top.frame)+20, kMainScreenWidth, CGRectGetHeight(imageScr.frame)+30*2);
        NSInteger countCircle=kMainScreenWidth/20+4;
        for(int i=0;i<countCircle;i++){
            UIView *view_circleTop=[[UIView alloc]initWithFrame:CGRectMake(10+i*20, 10, 10, 10)];
            view_circleTop.backgroundColor=[UIColor colorWithHexString:@"#efeff4" alpha:0.6];
            [view_Foot addSubview:view_circleTop];
            
            UIView *view_circleFoot=[[UIView alloc]initWithFrame:CGRectMake(10+i*20, CGRectGetHeight(view_Foot.frame)-20, 10, 10)];
            view_circleFoot.backgroundColor=[UIColor colorWithHexString:@"#efeff4" alpha:0.6];
            [view_Foot addSubview:view_circleFoot];
        }
        
        scrView.contentSize=CGSizeMake(kMainScreenWidth, CGRectGetMaxY(view_Foot.frame)+20);
    }
    cell.tag=kCell_TAG+indexPath.row;
    MyeffectPictureObj *obj=_dataArr[indexPath.row];
    
    UIImageView *coverImage=(UIImageView *)[cell viewWithTag:1000];
    coverImage.image=[UIImage imageNamed:@"ic_morentu"];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    BOOL cachedImage = [manager cachedImageExistsForURL:[NSURL URLWithString:obj.rendreingsPath]];  // 判断图片是否已经被缓存
    if(cachedImage){
        UIImage *img = [manager.imageCache imageFromDiskCacheForKey:obj.rendreingsPath];   // 将缓存的图片加载进来
        coverImage.frame=CGRectMake(0, 0, kMainScreenWidth, (img.size.height*kMainScreenWidth)/img.size.width);
        coverImage.image=img;
        [self obj:obj cell:cell image:coverImage];
    }
    else{
        [coverImage sd_setImageWithURL:[NSURL URLWithString:obj.rendreingsPath] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image) coverImage.frame=CGRectMake(0, 0, kMainScreenWidth, (image.size.height*kMainScreenWidth)/image.size.width);
            [self obj:obj cell:cell image:coverImage];
        }];
    }
    
    return cell;
}

-(void)obj:(MyeffectPictureObj *)obj cell:(UITableViewCell *)cell image:(UIImageView *)coverImage{
    UILabel *houseModel=(UILabel *)[cell viewWithTag:1001];
    houseModel.frame=CGRectMake(15, CGRectGetMaxY(coverImage.frame)+20, kMainScreenWidth-30, 20);
    houseModel.text=obj.doorModel;
    
    UILabel *styleArea=(UILabel *)[cell viewWithTag:1002];
    styleArea.frame=CGRectMake(15, CGRectGetMaxY(houseModel.frame)+10, kMainScreenWidth-30, 20);
    styleArea.text=[NSString stringWithFormat:@"%@     %@m²     ¥ %@/m²",obj.frameName,obj.buildingArea,obj.price];
    
    if ([obj.description_ isEqualToString:@"(null)"]) obj.description_ =@"";
    CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",obj.description_] width:kMainScreenWidth-60 font:[UIFont systemFontOfSize:15]];
    UILabel *descCri=(UILabel *)[cell viewWithTag:1003];
    descCri.frame=CGRectMake(30, CGRectGetMaxY(styleArea.frame)+10, kMainScreenWidth-60, size.height);
    descCri.text=[NSString stringWithFormat:@"%@ ",obj.description_];
    
    UILabel *brower=(UILabel *)[cell viewWithTag:1005];
    if([obj.browserNum integerValue]>=100000000) brower.text=[NSString stringWithFormat:@"%0.1f亿",[obj.browserNum floatValue]/100000000];
    else if([obj.browserNum integerValue]>=10000) brower.text=[NSString stringWithFormat:@"%0.1f万",[obj.browserNum floatValue]/10000];
    else brower.text=obj.browserNum;
    CGSize sizeBrower=[util calHeightForLabel:brower.text width:100 font:[UIFont systemFontOfSize:15]];
    brower.frame=CGRectMake(kMainScreenWidth-30-sizeBrower.width, CGRectGetMaxY(descCri.frame)+10, sizeBrower.width+5, 20);
    
    UIImageView *browerLogo=(UIImageView *)[cell viewWithTag:1004];
    browerLogo.frame=CGRectMake(CGRectGetMinX(brower.frame)-23 ,CGRectGetMaxY(descCri.frame)+13, 18, 16);
    
    UIView *view_Top=(UILabel *)[cell viewWithTag:1007];
    view_Top.frame=CGRectMake(0, 0, kMainScreenWidth, CGRectGetMaxY(brower.frame)+20);
    
    NSInteger count=[obj.picList count];
    float width=110*kMainScreenWidth/320;
    float height=80*kMainScreenWidth/320;
    UIScrollView *scrImage=(UIScrollView *)[cell viewWithTag:1006];
    scrImage.frame=CGRectMake(0, CGRectGetMaxY(view_Top.frame)+50, kMainScreenWidth, height);
    for(UIImageView *imgView in scrImage.subviews) [imgView removeFromSuperview];
    for(int i=0;i<count;i++){
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(i*(width+10), 0, width, height)];
        imageview.tag=kTapImage_TAG+i;
        imageview.userInteractionEnabled=YES;
        imageview.contentMode=UIViewContentModeScaleAspectFill;
        imageview.clipsToBounds=YES;
        [imageview sd_setImageWithURL:[obj.picList objectAtIndex:i] placeholderImage:[UIImage imageNamed:@"ic_morentu"]];
        [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapActionImage:)]];
        [scrImage addSubview:imageview];
        
        if(i==count-1) scrImage.contentSize=CGSizeMake(CGRectGetMaxX(imageview.frame), height);
    }
    
    UIView *view_Foot=(UILabel *)[cell viewWithTag:1008];
    view_Foot.frame=CGRectMake(0, CGRectGetMaxY(view_Top.frame)+20, kMainScreenWidth, CGRectGetHeight(scrImage.frame)+30*2);
    
    UIScrollView *scrView=(UIScrollView *)[cell.contentView viewWithTag:2000];
    scrView.contentSize=CGSizeMake(kMainScreenWidth, CGRectGetMaxY(view_Foot.frame)+20);
    scrView.contentOffset=CGPointMake(0, 0);
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        self.currentPage=0;
        //[self requestSelectedCaseList];
    }
    else {
        if(self.totalPages>self.currentPage){
            //[self requestSelectedCaseList];
        }
        else{
            [mTableView tableViewDidFinishedLoading];
            mTableView.reachedTheEnd = YES;  //是否加载到底了
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    //MJLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    //MJLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    //创建一个NSDataFormatter显示刷新时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

//上拉加载  Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    // MJLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (mTableView.contentOffset.y<-30) {
        mTableView.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [mTableView tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [mTableView tableViewDidEndDragging:scrollView];
    
//    if(self.totalPages>self.currentPage) _footView.hidden=YES;
//    else _footView.hidden=NO;
    
   // NSLog(@"%f---%f==========%f---%f",mTableView.contentOffset.x,mTableView.contentOffset.y,mTableView.contentSize.width,mTableView.contentSize.height);
    if(mTableView.contentOffset.y > mTableView.contentSize.height-kMainScreenWidth && self.totalPages>self.currentPage){
        [self startRequestWithString:@""];
        [self requestSelectedCaseList];
    }
    else {
        if(self.totalPages <= self.currentPage && mTableView.contentOffset.y > mTableView.contentSize.height-kMainScreenWidth) [TLToast showWithText:@"已是最后一页了" duration:1.0];
        [self requestBrower];   //发送浏览量+1
    }
}

#pragma mark - 请求图片列表
-(void)requestSelectedCaseList{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSInteger cityCodeInteger = [kCityCode integerValue];
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        
        NSString *requestUrl=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0351\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":%ld}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\",\"renderingsId\":\"%ld\",\"doorModelId\":\"%ld\",\"offerId\":\"%ld\",\"classificationId\":\"%ld\",\"cityCode\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,(long)cityCodeInteger,(long)self.currentPage+1,(long)self.picture_style,(long)self.picture_doorModel,(long)self.picture_price,(long)3,(long)self.picture_cityCode];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonDict = [[request responseString] objectFromJSONString];
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                NSLog(@"%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopRequest];
                    if (code==13511) {
                        self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];        //得到总的页数
                        self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];      //当前的页数
                        for (NSDictionary *dict in [jsonDict objectForKey:@"rendreingsList"]){
                            [_dataArr addObject:[MyeffectPictureObj objWithDict:dict]];
                        }
                        [mTableView reloadData];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                              });
                          }
                               method:requestUrl postDict:nil];
    });
}

#pragma mark -
#pragma mark - SharePicViewDelegate

-(void)SharePicCustomclickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        if([WXApi isWXAppInstalled])
            [self sendTextContentToWX:1];
        else
            [TLToast showWithText:@"请先安装微信客户端" topOffset:220.0 duration:1.5];
    }
    else if (buttonIndex==1){
        if([WXApi isWXAppInstalled])
            [self sendTextContentToWX:2];
        else
            [TLToast showWithText:@"请先安装微信客户端" topOffset:220.0 duration:1.5];
    }
    else if (buttonIndex==2){
        if([WeiboSDK isWeiboAppInstalled])
            [self sendTextContentToWB];
        else
            [TLToast showWithText:@"请先安装新浪微博客户端" topOffset:220.0 duration:1.5];
    }
    else{
        if([QQApiInterface isQQInstalled])
            [self sendTextContentToQQorZone];
        else
            [TLToast showWithText:@"请先安装手机QQ客户端" topOffset:220.0 duration:1.5];
    }
}

#pragma mark -
#pragma mark - Weixin related
- (void)sendTextContentToWX:(NSInteger)type {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =[self GetTitle];
    message.description =[self GetDescription];
    message.thumbData = UIImageJPEGRepresentation([self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self GetPictureUrl]]]]scaleToSize:CGSizeMake(100, 100)],0.06);
    
    //    WXImageObject *obj=[WXImageObject object];
    //    obj.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url_pic]];
    //    message.mediaObject=obj;
    
    WXWebpageObject *obj=[WXWebpageObject object];
    obj.webpageUrl=[self GetShareUrl];
    message.mediaObject=obj;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if(type==1) req.scene = WXSceneSession;
    else req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

#pragma mark -
#pragma mark - QQorZone related
-(void)sendTextContentToQQorZone{
    QQApiNewsObject *txtObj =[QQApiNewsObject objectWithURL:[NSURL URLWithString:[self GetShareUrl]] title:[self GetTitle] description:[self GetDescription] previewImageData:UIImageJPEGRepresentation([self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self GetPictureUrl]]]]scaleToSize:CGSizeMake(100, 100)],0.06)];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    
    [QQApiInterface SendReqToQZone:req];
}

#pragma mark -
#pragma mark - Sinawb related
- (void)sendTextContentToWB {
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
    request.userInfo = @{@"picture": @"share",};
    //request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
    
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"";
    
    //    WBImageObject *image = [WBImageObject object];
    //    image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj_effect.imagePath]];
    //    message.imageObject = image;
    
    MyeffectPictureObj *obj_effect=_dataArr[_indexSort];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = [NSString stringWithFormat:@"%@",obj_effect.picture_id];
    webpage.title = [self GetTitle];
    webpage.description = [self GetDescription];
    webpage.thumbnailData = UIImageJPEGRepresentation([self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self GetPictureUrl]]]]scaleToSize:CGSizeMake(100, 100)],0.06);
    webpage.webpageUrl =[self GetShareUrl];
    message.mediaObject = webpage;
    
    return message;
}

#pragma mark - 获取分享标题、描述
//获取分享标题
-(NSString *)GetTitle{
    NSString *title=@"【屋托邦】精选家装案例";
    return title;
}

//获取分享的描述
-(NSString *)GetDescription{
    MyeffectPictureObj *obj_effect=_dataArr[_indexSort];
    NSString *desc=@"";
    if(obj_effect.description_.length) desc=obj_effect.description_;
    return desc;
}

//获取分享的Logo图片
-(NSString  *)GetPictureUrl{
    MyeffectPictureObj *obj_effect=_dataArr[_indexSort];
    NSString *picUrl=@"";
    if(obj_effect.rendreingsPath.length) picUrl=obj_effect.rendreingsPath;
    return picUrl;
}
//获取分享的链接Url
-(NSString  *)GetShareUrl{
    MyeffectPictureObj *obj_effect=_dataArr[_indexSort];
    NSString *shareUrl=[NSString stringWithFormat:@"%@%@",self.shareUrl,obj_effect.picture_id];
    return shareUrl;
}

////////////////////////////////////////////////////////////////////////////////////////
/*改变图片尺寸大小*/
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

#pragma mark - 发送浏览量+1
-(void)requestBrower{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        
        MyeffectPictureObj *obj_effect=_dataArr[_indexSort];
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0129\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"id\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,kCityCode,obj_effect.picture_id];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"发送浏览量返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                        
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                              });
                          }
                               method:url postDict:nil];
    });
    
    
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
