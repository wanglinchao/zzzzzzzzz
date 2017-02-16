//
//  SeeEffectPictureViewController.m
//  IDIAI
//
//  Created by iMac on 15/10/20.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SeeEffectPictureViewController.h"
#import "HexColor.h"
#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "CircleProgressHUD.h"
#import "MyeffectPictureObj.h"
#import "UIImageView+WebCache.h"
#import "EffectPictureInfo.h"
#import "savelogObj.h"
#import "util.h"
#import "HRCoreAnimationEffect.h"
#import "ViewPagerController.h"
#import "IDIAIAppDelegate.h"
#import "UIImageView+OnlineImage.h"
#import "EffectTAOTUPictureInfo.h"
#import "RNFullScreenScroll.h"
#import "UIViewController+RNFullScreenScroll.h"

#define KStyleBtn_Tag 1000
#define KKongJianBtn_Tag 2000

@interface SeeEffectPictureViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate,UITableViewDelegate, EffectPicInfoDelegate>
{
    TMQuiltView *qtmquitView;
    CircleProgressHUD *phud;
    
    //    BOOL *_styleTag;//标记风格是否改变
    NSInteger _browseNum;//点击图酷详情浏览标记
    NSInteger _collectionNum;//点击图酷详情收藏标记
    
    UILabel *_browseTempLabel;

}
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) UIButton *rightButton;
@property (nonatomic, retain) UIView *view_bg_style;

@end

@implementation SeeEffectPictureViewController
@synthesize picture_title;
@synthesize images = _images,view_bg_style,rightButton;

-(void)dealloc{
    [qtmquitView setDelegate:nil];
    [qtmquitView setDataSource:nil];
    [_refreshFooterView setDelegate:nil];
    [_refreshHeaderView setDelegate:nil];
    _control=nil;
    if([self.dataArray count]){
        [self.dataArray removeAllObjects];
        self.dataArray=nil;
    }
    [qtmquitView removeFromSuperview];
    qtmquitView=nil;
}

- (void)customizeNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:kColorWithRGB(249, 249, 250)];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"最新",@"推荐",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0, 0, 90, 25);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor lightGrayColor];
    segmentedControl.layer.cornerRadius=12.5;
    segmentedControl.layer.masksToBounds=YES;
    segmentedControl.layer.borderWidth=1.0;
    segmentedControl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    self.navigationItem.titleView=segmentedControl;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 25, 80, 30)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 65);
    [leftButton addTarget:self
                   action:@selector(backTouched)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //导航右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 42, 42);
    [rightBtn setImage:[UIImage imageNamed:@"ic_fengge_2"] forState:UIControlStateNormal];
    //右移
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, -5);
    [rightBtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

//具体委托方法实例
-(void)segmentAction:(UISegmentedControl *)Seg{
    if(Seg.selectedSegmentIndex==0) [MobClick event:@"Click_XGcase_new"];   //友盟自定义事件,数量统计
    else [MobClick event:@"Click_XGcase_recommended"];   //友盟自定义事件,数量统计
    if(_control) [self dismiss];
    isrefreshing=YES;
    self.currentPage=0;
    self.typeIdInteger=Seg.selectedSegmentIndex;
    [self requestPicturelist];
}

-(void)backTouched{
    [phud hide];
    [self dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showEffectyPicType:) name:kNCShowEffectyPicType object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [self refreshView];
    [qtmquitView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MobClick event:@"Click_XGcase"];   //友盟自定义事件,数量统计
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self customizeNavigationBar];
    
    //自定义返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"ic_fh.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    _browseTempLabel = [[UILabel alloc]init];

    [savelogObj saveLog:@"查看装修效果图" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:34];
    self.typeIdInteger=0;
    
    qtmquitView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    qtmquitView.delegate = self;
    qtmquitView.dataSource = self;
    qtmquitView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    qtmquitView.showsHorizontalScrollIndicator=NO;
    qtmquitView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:qtmquitView];
    
    //[qtmquitView reloadData];
    [self createHeaderView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    
    self.dataArray=[NSMutableArray arrayWithCapacity:0];
    
    self.currentPage=0;
    
    //风格id：依次为-1和1-11
    NSInteger row_style=[[[NSUserDefaults standardUserDefaults]objectForKey:kUDEffectyTypeOfRow_Style] integerValue];
    if (row_style == 0) self.picture_style = -1;
    else self.picture_style=row_style;
    
     //空间id：依次为-1和36-46
    self.picture_kongjian=-1;
    
    [self requestPicturelist];
    [self refreshView];
    //设置全屏显示，隐藏导航栏
    self.fullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:qtmquitView];
    
    [self loadImageviewBG];
}



-(void)requestPicturelist{
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSInteger cityCodeInteger = [kCityCode integerValue];
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
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0121\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":%ld}&body={\"currentPage\":\"%ld\",\"requestRow\":\"10\",\"renderingsId\":\"%ld\",\"classificationId\":\"%ld\",\"doorModelId\":\"-1\",\"offerId\":\"-1\",\"spaceId\":\"%ld\",\"cityCode\":\"-1\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,(long)cityCodeInteger,(long)self.currentPage+1,(long)self.picture_style,(long)self.typeIdInteger+1,(long)self.picture_kongjian];
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"图片库返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==11211) {
                    //得到总的页数
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                        self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                        if(isrefreshing==YES && [self.dataArray count]){
                            [self.dataArray removeAllObjects];
                            [qtmquitView reloadData];
                        }
                        
                        if([[jsonDict objectForKey:@"rendreingsList"] count]){
                            for (NSDictionary *dict in [jsonDict objectForKey:@"rendreingsList"]){
                                @autoreleasepool {
                                    [self.dataArray addObject:[MyeffectPictureObj objWithDict:dict]];
                                }
                            }
                            imageview_bg.hidden=YES;
                            label_bg.hidden=YES;
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden=NO;
                        }
                        [phud hide];
                        [self stopRequest];
                        [qtmquitView reloadData];
                        [self removeFooterView];
                        [self testFinishedLoadData];
                    });
                }
                else if (code==11219) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide];
                        [self stopRequest];
                        [qtmquitView reloadData];
                        [self removeFooterView];
                        [self testFinishedLoadData];
                        
                        if([self.dataArray count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden=YES;
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden=NO;
                        }
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [phud hide];
                        [self stopRequest];
                        [qtmquitView reloadData];
                        [self removeFooterView];
                        [self testFinishedLoadData];
                        
                        if([self.dataArray count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden=YES;
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden=NO;
                        }
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [phud hide];
                                  [self stopRequest];
                                  [qtmquitView reloadData];
                                  [self removeFooterView];
                                  [self testFinishedLoadData];
                                  
                                  if([self.dataArray count]){
                                      imageview_bg.hidden=YES;
                                      label_bg.hidden=YES;
                                  }
                                  else{
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden=NO;
                                  }
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [qtmquitView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:qtmquitView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:qtmquitView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(qtmquitView.contentSize.height, qtmquitView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              qtmquitView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         qtmquitView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [qtmquitView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    imageview_bg.hidden=YES;
    label_bg.hidden=YES;
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        // pull down to refresh data
        
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
    }else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.1];
    }
    
    // overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
    //	NSLog(@"刷新完成");
    //    [self testFinishedLoadData];
    
    self.currentPage=0;
    isrefreshing=YES;
    [self requestPicturelist];
    
}
//加载调用的方法
-(void)getNextPageView
{
    //	[qtmquitView reloadData];
    //    [self removeFooterView];
    //    [self testFinishedLoadData];
    if(self.totalPages>self.currentPage){
        isrefreshing=NO;
        [self requestPicturelist];
    }
    else{
        [phud hide];
        [self removeFooterView];
        [self testFinishedLoadData];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //huangrun
    if (scrollView.tag == 101) {
        return;
    }
    
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //huangrun
    if (scrollView.tag == 101) {
        return;
    }
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
    return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
    {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    //return height/[self quiltViewNumberOfColumns:quiltView];
    return 2*(kMainScreenWidth-20)/3+90;
}

- (CGFloat)quiltViewMargin:(TMQuiltView *)quilView marginType:(TMQuiltViewMarginType)marginType{
    return 15;
}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.dataArray count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid=@"mycellid-0";
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:cellid];
    if (!cell) {
        if([self.dataArray count]){
            MyeffectPictureObj *obj=[self.dataArray objectAtIndex:indexPath.row];
            cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:cellid index:[obj.designerID integerValue] type:0];
        }
    }
    
    if([self.dataArray count]){
        MyeffectPictureObj *obj=[self.dataArray objectAtIndex:indexPath.row];
        NSString *placeter_image=[[NSBundle mainBundle]pathForResource:@"bg_taotubeijing@2x" ofType:@"png"];
        NSString *placeter_designer=[[NSBundle mainBundle]pathForResource:@"ic_touxiang_tk@2x" ofType:@"png"];
        
        cell.photoView.image=[UIImage imageWithContentsOfFile:placeter_image];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:obj.rendreingsPath] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if(image) {
                cell.photoView.image=[self imageWithImage:image scaledToSize:CGSizeMake(image.size.width*0.8, image.size.height*0.8)];
                //产生逐渐显示的效果
                cell.photoView.alpha=0.2;
                [UIView animateWithDuration:0.5 animations:^(){
                    cell.photoView.alpha=1.0;
                }completion:^(BOOL finished){
                    
                }];
            }
        }];
        
        if([obj.designerID integerValue]!=0){
            cell.designer_photoView.hidden=NO;
            cell.Label_designer.hidden=NO;
            [cell.designer_photoView setOnlineImage:obj.designerImagePath placeholderImage:[UIImage imageWithContentsOfFile:placeter_designer]];
            cell.Label_designer.text =obj.designerName;
        }
        else{
            NSString *icon=[[NSBundle mainBundle]pathForResource:@"platform_icon@2x" ofType:@"png"];
            cell.designer_photoView.image=[UIImage imageWithContentsOfFile:icon];;
            cell.Label_designer.text=@"屋托邦";
        }
        
        cell.collectIV.image = [UIImage imageNamed:@"ic_xingxing_picture"];
        if([obj.collectionNum integerValue]>=100000000) cell.collectNumLabel.text=[NSString stringWithFormat:@"%0.1f亿",[obj.collectionNum floatValue]/100000000];
        else if([obj.collectionNum integerValue]>=10000) cell.collectNumLabel.text=[NSString stringWithFormat:@"%0.1f万",[obj.collectionNum floatValue]/10000];
        else cell.collectNumLabel.text=obj.collectionNum;
        
        cell.browseNumIV.image = [UIImage imageNamed:@"ic_yanjing_picture"];
        if([obj.browserNum integerValue]>=100000000) cell.browseNumLabel.text=[NSString stringWithFormat:@"%0.1f亿",[obj.browserNum floatValue]/100000000];
        else if([obj.browserNum integerValue]>=10000) cell.browseNumLabel.text=[NSString stringWithFormat:@"%0.1f万",[obj.browserNum floatValue]/10000];
        else cell.browseNumLabel.text=obj.browserNum;
        
        cell.houseDesc.text=obj.description_;
        cell.houseTAndAAndPOrS.text=obj.frameName;
        
    }
    return cell;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    MyeffectPictureObj *obj=[self.dataArray objectAtIndex:indexPath.row];
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView cellAtIndexPath:indexPath];
  
    EffectPictureInfo *effvc=[[EffectPictureInfo alloc]init];
    effvc.obj_effect=obj;
    effvc.img_=cell.photoView.image;
    __block MyeffectPictureObj *weakself=obj;
    effvc.selectDone =^(MyeffectPictureObj *pic_obj){
        weakself =obj;
        [quiltView reloadData];
    };
    [self.navigationController pushViewController:effvc animated:YES];
}

#pragma mark - 选择风格

- (void)show {
    [MobClick event:@"Click_XGcase_filter"];   //友盟自定义事件,数量统计
    if(_control) {
        [self dismiss];
        return;
    }

    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if(!_control)_control = [[UIControl alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kMainScreenHeight - 80, kMainScreenHeight - kTabBarHeight)];
    _control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.25];
    [_control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [keywindow addSubview:_control];

//    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(80, kNavigationBarHeight+0.5, kMainScreenWidth - 80, kMainScreenHeight - kNavigationBarHeight)];
    if(!_dv) _dv = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+0.5, kMainScreenWidth , kMainScreenHeight - kNavigationBarHeight)];
    _dv.tag=101;
    _dv.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    _dataArr = @[@[@"全部",@"现代简约",@"田园",@"欧式",@"中式",@"美式",@"地中海",@"东南亚",@"混搭",@"新古典",@"日式",@"家居墙绘"],@[@"全部",@"客厅",@"卧室",@"书房",@"阳台",@"餐厅",@"厨房",@"卫生间",@"儿童房",@"衣帽间",@"玄关",@"过道",@"飘窗"]];
    [keywindow addSubview:_dv];
    [self createChioces];
    
    [HRCoreAnimationEffect animationPushRight:_dv];
}

-(void)dismiss{
    [_control removeFromSuperview];
    _control=nil;
    //_dv.frame=CGRectMake(80, kNavigationBarHeight+0.5, kMainScreenWidth - 80, kMainScreenHeight - kNavigationBarHeight);
    _dv.frame=CGRectMake(0, kNavigationBarHeight+0.5, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight);
    [UIView animateWithDuration:.25 animations:^{
//        _dv.frame=CGRectMake(kMainScreenWidth, kNavigationBarHeight+0.5, kMainScreenWidth - 80, kMainScreenHeight - kNavigationBarHeight);
        _dv.frame=CGRectMake(kMainScreenWidth, kNavigationBarHeight+0.5, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight);
    } completion:^(BOOL finished) {
        if (finished) {
            [_dv removeFromSuperview];
            _dv=nil;
        }
    }];
}

- (void)showEffectyPicType:(id)sender {
    [self show];
}

-(void)createChioces{
    _scr=[[UIScrollView alloc] init];
    _scr.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
    [_dv addSubview:_scr];
    
    UILabel *style_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
    style_lab.backgroundColor=[UIColor clearColor];
    style_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
    style_lab.font=[UIFont boldSystemFontOfSize:18];
    style_lab.text=@"风格";
    [_scr addSubview:style_lab];
    float width_=(kMainScreenWidth-40-60)/3;
    float heigth_=32;
    float space=0;
    for (int i=0; i<[[_dataArr firstObject] count]; i++) {
        UIButton *btn_style=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), CGRectGetMaxY(style_lab.frame)+10+(i/3)*(heigth_+15), width_, heigth_)];
        btn_style.tag=KStyleBtn_Tag+i;
        [btn_style setTitle:[[_dataArr firstObject] objectAtIndex:i] forState:UIControlStateNormal];
        [btn_style setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
        [btn_style setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
        btn_style.titleLabel.font=[UIFont systemFontOfSize:16];
        if(i==0 && self.picture_style==-1) btn_style.selected=YES;
        else if(i==self.picture_style && i!=0) btn_style.selected=YES;
        //给按钮加一个红色的板框
        if(btn_style.selected==YES) btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
        else btn_style.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
        btn_style.layer.borderWidth = 1.0f;
        //给按钮设置弧度,这里将按钮变成了圆形
        btn_style.layer.cornerRadius = 5.0f;
        btn_style.layer.masksToBounds = YES;
        [btn_style addTarget:self action:@selector(ChoiceStyle:) forControlEvents:UIControlEventTouchUpInside];
        [_scr addSubview:btn_style];
        
        if(i==[[_dataArr firstObject] count]-1) space=CGRectGetMaxY(btn_style.frame);
    }
    
    UILabel *kongjian_lab=[[UILabel alloc]initWithFrame:CGRectMake(20, space+20, 100, 20)];
    kongjian_lab.backgroundColor=[UIColor clearColor];
    kongjian_lab.textColor=[UIColor colorWithHexString:@"#ADADB0" alpha:1.0];
    kongjian_lab.font=[UIFont boldSystemFontOfSize:18];
    kongjian_lab.text=@"局部";
    [_scr addSubview:kongjian_lab];
    space=CGRectGetMaxY(kongjian_lab.frame);
    for (int i=0; i<[[_dataArr lastObject] count]; i++) {
        UIButton *btn_kongjian=[[UIButton alloc]initWithFrame:CGRectMake(20+(width_+30)*(i%3), space+10+(i/3)*(heigth_+15), width_, heigth_)];
        btn_kongjian.tag=KKongJianBtn_Tag+i;
        NSLog(@"%@",[[_dataArr lastObject] objectAtIndex:i]);
        [btn_kongjian setTitle:[[_dataArr lastObject] objectAtIndex:i] forState:UIControlStateNormal];
        [btn_kongjian setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateSelected];
        [btn_kongjian setTitleColor:[UIColor colorWithHexString:@"#ACABB1" alpha:1.0] forState:UIControlStateNormal];
        btn_kongjian.titleLabel.font=[UIFont systemFontOfSize:16];
        if(i==0 && self.picture_kongjian==-1) btn_kongjian.selected=YES;
        else if(i==self.picture_kongjian-35 && i!=0) btn_kongjian.selected=YES;
        //给按钮加一个红色的板框
        if(btn_kongjian.selected==YES) btn_kongjian.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
        else btn_kongjian.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
        btn_kongjian.layer.borderWidth = 1.0f;
        //给按钮设置弧度,这里将按钮变成了圆形
        btn_kongjian.layer.cornerRadius = 5.0f;
        btn_kongjian.layer.masksToBounds = YES;
        [btn_kongjian addTarget:self action:@selector(ChoiceKongjian:) forControlEvents:UIControlEventTouchUpInside];
        [_scr addSubview:btn_kongjian];
        
        if(i==[[_dataArr lastObject] count]-1) space=CGRectGetMaxY(btn_kongjian.frame)+20;
    }

    _scr.frame=CGRectMake(0, 0, CGRectGetWidth(_dv.frame), CGRectGetHeight(_dv.frame)-kMainScreenWidth/8);
    _scr.contentSize=CGSizeMake(CGRectGetWidth(_scr.frame), space);
    
    UIButton *finished_Choice=[[UIButton alloc]initWithFrame:CGRectMake(0,kMainScreenHeight-64-kMainScreenWidth/8,kMainScreenWidth,kMainScreenWidth/8)];
    [finished_Choice setTitle:@"确定" forState:UIControlStateNormal];
    [finished_Choice setTitleColor:[UIColor colorWithHexString:@"#FC5351" alpha:1.0] forState:UIControlStateNormal];
    finished_Choice.titleLabel.font=[UIFont systemFontOfSize:16];
    finished_Choice.backgroundColor=[UIColor colorWithHexString:@"#E5E5E5" alpha:0.8];
    [finished_Choice addTarget:self action:@selector(ChoiceFinished) forControlEvents:UIControlEventTouchUpInside];
    [_dv addSubview:finished_Choice];
}

-(void)ChoiceStyle:(UIButton *)sender{
    //风格id：-1和1-11
    for (int i=0; i<[[_dataArr firstObject] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KStyleBtn_Tag+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
}

-(void)ChoiceKongjian:(UIButton *)sender{
    //空间id：-1和36-46
    for (int i=0; i<[[_dataArr lastObject] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KKongJianBtn_Tag+i];
        if(sender.tag==btn.tag){
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#FC5351" alpha:1.0] CGColor];
            btn.selected=YES;
        }
        else{
            btn.layer.borderColor = [[UIColor colorWithHexString:@"#ADABB1" alpha:1.0] CGColor];
            btn.selected=NO;
        }
    }
}

-(void)ChoiceFinished{
    [MobClick event:@"Click_XGcase_filter_detail"];   //友盟自定义事件,数量统计
    for (int i=0; i<[[_dataArr firstObject] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KStyleBtn_Tag+i];
        if(btn.selected==YES){
           //风格id：-1和1-11
            if(i==0) self.picture_style=-1;
            else self.picture_style=i;
            [[NSUserDefaults standardUserDefaults]setInteger:self.picture_style forKey:kUDEffectyTypeOfRow_Style];
            [[NSUserDefaults standardUserDefaults]synchronize];
            break;
        }
        else continue;
    }
    for (int i=0; i<[[_dataArr lastObject] count]; i++) {
        UIButton *btn=(UIButton *)[_dv viewWithTag:KKongJianBtn_Tag+i];
        if(btn.selected==YES){
            //空间id：-1和36-46
            if(i==0) self.picture_kongjian=-1;
            else self.picture_kongjian=35+i;
            break;
        }
        else continue;
    }
    
    [self dismiss];
    [self.dataArray removeAllObjects];
    [qtmquitView reloadData];
    self.currentPage=0;
    [self requestPicturelist];
}

#pragma mark - EffectPicInfoDelegate

- (void)picDidCollect:(EffectPictureInfo *)effectPicInfo collectNum:(NSInteger)collectNum cell:(UITableViewCell *)cell {
    
    _collectionNum += 1;
    
    if (self.typeIdInteger == -1 || self.typeIdInteger == 2) {
        ((TMPhotoQuiltViewCell *)cell).collectIV.image = [UIImage imageNamed:@"ic_shoucangliang"];
        
        ((TMPhotoQuiltViewCell *)cell).collectNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_collectionNum];
    } else if (self.typeIdInteger == 1) {
        ((TMPhotoQuiltViewCell *)cell).collectIV.image = [UIImage imageNamed:@"ic_liulanliang"];
        _collectionNum = [((TMPhotoQuiltViewCell *)cell).collectNumLabel.text integerValue];
        _collectionNum  = _collectionNum + 1;
        ((TMPhotoQuiltViewCell *)cell).collectNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_collectionNum];
    } else if (self.typeIdInteger == 3) {
        ((TMPhotoQuiltViewCell *)cell).collectIV.image = [UIImage imageNamed:@"ic_shoucangliang"];
        
        ((TMPhotoQuiltViewCell *)cell).collectNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_collectionNum];
        ((TMPhotoQuiltViewCell *)cell).browseNumIV.image = [UIImage imageNamed:@"ic_liulanliang"];
        _browseNum = [((TMPhotoQuiltViewCell *)cell).browseNumLabel.text integerValue];
        _browseNum  = _browseNum + 1;
        ((TMPhotoQuiltViewCell *)cell).browseNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_browseNum];
    }
    
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
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
