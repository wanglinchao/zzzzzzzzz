//
//  IDIAI3NewHomePageViewController.m
//  IDIAI
//
//  Created by iMac on 16/2/17.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3NewHomePageViewController.h"
#import "IDIAIAppDelegate.h"
#import "util.h"
#import "CityListViewController.h"
#import "CityListObj.h"
#import "PersonalInfoViewController.h"
//#import "LearnDecorViewController.h"
#import "WTBWebViewViewController.h"
#import "AutomaticLogin.h"
#import "ShopClearblankCell.h"
#import "LZAutoScrollView.h"
//#import "BannerInfoViewController.h"

#import "ShoppingMallViewController.h"
#import "GongzhangtuanViewController.h"
#import "JianliViewController.h"
#import "MyeffectypictureVC.h"
#import "KnowledgeViewController.h"
#import "SeeEffectPictureViewController.h"
#import "CommonFreeViewController.h"
#import "WorkerSearcheMapViewController.h"
#import "MyhouseTypeVC.h"
#import "TTPageControl.h"
#import "JTScrollLabelView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+OnlineImage.h"
#import <AVFoundation/AVFoundation.h>
#import "LearnDecorViewController.h"

#import "IDIAI3DesignerDetailViewController.h"
#import "IDIAI3GongZhangDetaileViewController.h"
#import "IDIAI3JianLiDetailViewController.h"
#import "EffectTAOTUPictureInfo.h"
#import "IDIAI3DiaryDetaileViewController.h"
#import "BuidlDetailViewController.h"
#import "IDIAI3EngineerSupportViewController.h"
#import "RecommendDetailViewController.h"
#import "IMlogin.h"
#import <WXOUIModule/YWConversationViewController.h>
#import "SPUtil.h"
#import "SPTabBarViewController.h"
#define kMainUIButton_TAG 1000
#define kTapKnowldge_TAG 2000
#define kMainTuiJianPicture_TAG 10000
#define kMainTuiJianBiaoQianPic_TAG 20000
#define kMainTuiJianText_TAG 30000
#define kMiddleSingleImage_Height ([UIImage imageNamed:@"Ic_shejifangan"].size.height*(kMainScreenWidth/2))/[UIImage imageNamed:@"Ic_shejifangan"].size.width


@interface IDIAI3NewHomePageViewController ()<CityListDelegate,LZAutoScrollViewDelegate,JTScrollLabelViewDelegate,IMLoginDelegate>
{
    LZAutoScrollView *autoScrollView;
}

@property (nonatomic, strong) UIScrollView *scrFoot;
@property (nonatomic, strong) TTPageControl *pageControl;
@property (nonatomic, strong) JTScrollLabelView *jtLabel;

@property (nonatomic,strong) UIImageView *envelopeimage;
@property (nonatomic,strong) UIView *envelopebackView;
@property (nonatomic,assign) int moneytag;
@property (nonatomic,strong) UIButton *closebtn;
@property (nonatomic,strong) UIButton *openbtn;
@property (nonatomic,strong) UIButton *showEnvelope;
@property (nonatomic,strong) UIImageView *monkeyimage;

@property (nonatomic,strong ) UIView * contentView;
@property (nonatomic,strong ) AVPlayer *player;//播放器对象
@property (strong, nonatomic) AVPlayerItem *playerItem;//播放对象
@property (nonatomic,strong) UIViewController * vc;
@property(nonatomic,strong)IMlogin * imlogin;
@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UILabel * unreadMsgCountLab;
@end



@implementation IDIAI3NewHomePageViewController

- (void)customizeNavigationBar {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:NO animated:NO];
    delegate.nav.navigationBar.translucent = NO;
    [[delegate.nav navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    delegate.nav.navigationBar.shadowImage=[util imageWithColor:kColorWithRGB(249, 249, 250)];
    
    UIImageView *nav_imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 52, 18)];
    nav_imageV.image =[UIImage imageNamed:@"ico_wtb3"];
    self.tabBarController.navigationItem.titleView=nav_imageV;
              
    NSMutableDictionary *dic =[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey];
    self.Cityname_location =[dic objectForKey:@"cityName"];
    self.Citycode_location =[dic objectForKey:@"cityCode"];
    
    NSString *cityName_str=[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityName"];
    
    if(!_leftButton) _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setFrame:CGRectMake(0, 5, 100, 40)];
    [_leftButton setImage:[UIImage imageNamed:@"ic_xjt.png"] forState:UIControlStateNormal];
    [_leftButton setTitle:cityName_str forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor colorWithHexString:@"#4D4D4D" alpha:1.0] forState:UIControlStateNormal];
    _leftButton.imageEdgeInsets=UIEdgeInsetsMake(15, 50, 10, 40);
    _leftButton.titleEdgeInsets=UIEdgeInsetsMake(2, -20, 0, 50);
    _leftButton.titleLabel.font=[UIFont systemFontOfSize:16];
    _leftButton.titleLabel.textAlignment=NSTextAlignmentLeft;
    [_leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    [self.tabBarController.navigationItem setLeftBarButtonItem:leftItem];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.tabBarController.navigationItem setRightBarButtonItem:rightItem];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    _locService.delegate=nil;
    _geocodesearch.delegate = nil;
    [[NSUserDefaults standardUserDefaults]setObject:self.leftButton.titleLabel.text forKey:homePageCityShowInLeftButton];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    _locService.delegate=self;
    _geocodesearch.delegate = self;
    
    [self requestDynamicInfoList];
    [self customizeNavigationBar];
}

-(void)PressBarItemLeft{
    CityListViewController *cityVC=[[CityListViewController alloc]init];
    cityVC.delegate=self;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)PressBarItemRight:(UIButton*)sender{
//    sender.enabled =NO;
//    [[SPUtil sharedInstance] setWaitingIndicatorShown:YES withKey:@"waiting"];
    //***以前拨打电话的****//
//    NSString *serviceNumber = serviceNumber=[@"400-888-7372" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
//    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",serviceNumber]]]];
//    webview.hidden = YES;
//    // Assume we are in a view controller and have access to self.view
//    [self.view addSubview:webview];
//    SPLoginController * spLoginVC = [[SPLoginController alloc]init];
//    [spLoginVC _tryLogin];
    
//    if (isIMLoginOutByOthers==YES) {
//        [util loginViewShowWithDelegate:self];
//        return;
//    }
    
    IMlogin * imLogin  =[self imLogin];
    [imLogin tryLoginIM];
 
}

-(IMlogin*)imLogin{
    if (!_imlogin) {
        _imlogin = [[IMlogin alloc]init];
        _imlogin.delegate =self;
    }

    return _imlogin;
}

-(void)performLoadLearnDecor{
    LearnDecorViewController *learnVC=[[LearnDecorViewController alloc]init];
    learnVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:learnVC animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor =[UIColor whiteColor];
    
    _rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5,80, 40)];
    _rightButton.tag = 200;
    [_rightButton setImage:[UIImage imageNamed:@"ic_im_"] forState:UIControlStateNormal];
    _rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 45, 0,-5);
    [_rightButton addTarget:self
                     action:@selector(PressBarItemRight:)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.tabBarController.navigationItem setRightBarButtonItem:rightItem];
//    self.unreadMsgCountLab = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, 10, 10)];
//    [_rightButton addSubview:_unreadMsgCountLab];
//    _unreadMsgCountLab.backgroundColor = [UIColor redColor];
//    _unreadMsgCountLab.textColor = [UIColor whiteColor];
//    _unreadMsgCountLab.layer.cornerRadius=5;
//    _unreadMsgCountLab.clipsToBounds =YES;
//    _unreadMsgCountLab.hidden =YES;
    
    
//    
//    
//    NSMutableDictionary * cityNameDict = [[NSMutableDictionary alloc]init];
//    if (_leftButton.titleLabel.text) {
//        [cityNameDict setObject:_leftButton.titleLabel.text forKey:@"defaultLocatedcityName"];
//    }
//    [cityNameDict setObject:@"成都市" forKey:@"defaultLocatedcityName"];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"homePageCityName" object:nil userInfo:cityNameDict];
////    NSNotification * notification = [NSNotification notificationWithName:@"homePageCityName" object:nil userInfo:cityNameDict];
////    [[NSNotificationCenter defaultCenter]performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
//    NSLog(@"____________%@",cityNameDict);
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first_yd"]){
//        [self performSelector:@selector(performLoadLearnDecor) withObject:nil afterDelay:1.5];//小白学装修
        
        //  添加引导页视图
        [self addContentView];
        //  添加播放器
        [self addAVPlayer];
        //  添加通知
        [self addNotification];
    }
    
    mtableview = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-44) style:UITableViewStyleGrouped];
    mtableview.pullingDelegate = self;
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.backgroundColor=[UIColor colorWithHexString:@"#f1f0f6" alpha:1.0];
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    mtableview.showsVerticalScrollIndicator=NO;
    mtableview.showsHorizontalScrollIndicator=NO;
    [mtableview setHeaderOnly:YES];          //只有下拉刷新
    [mtableview setFooterOnly:YES];         //只有上拉加载
    [self.view addSubview:mtableview];
    
    if(!autoScrollView){
        float height=(kMainScreenHeight-113)/(736-113)*190;
        if(kMainScreenWidth==375) height=170;
        else if (kMainScreenWidth==320) height=150;
        autoScrollView = [[LZAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, height)];
        autoScrollView.delegate = self;
        autoScrollView.images = @[@" "];
        autoScrollView.placeHolder = [UIImage imageNamed:@"ic_morentu"];
        autoScrollView.interval=3.0;
        autoScrollView.pageControlAligment=PageControlAligmentCenter;
        autoScrollView.isAutoScorll=NO;
        [autoScrollView createViews];
        mtableview.tableHeaderView=autoScrollView;
    }
    
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        _locService = [[BMKLocationService alloc]init];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用"
                                                        message:@"可在“设置->隐私->定位服务”中确认“定位服务”和“屋托邦”是否为开启状态"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
//    //自动登录
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:User_Name] length] && [[[NSUserDefaults standardUserDefaults]objectForKey:User_Password] length]) {
//        [AutomaticLogin Automaticlogin:self];
//    }

    self.data_array=[NSMutableArray array];
    self.recom_array=[NSMutableArray array];
    [self requestBannerlist];
    [self requestHomePageRecommendedList];
    [self requestCitylist];
    [self requestDistrictNOlist];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNewMessageRedDot) name:@"IMNewMessage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelNewMessageRedDot) name:@"cancelNewMessageRedDot" object:nil];

}

-(void)showNewMessageRedDot{
    
    [_rightButton setImage:[UIImage imageNamed:@"ic_im_dian"] forState:UIControlStateNormal];
    
}

-(void)cancelNewMessageRedDot{
    [_rightButton setImage:[UIImage imageNamed:@"ic_im_"] forState:UIControlStateNormal];

}


#pragma mark -
#pragma mark -添加引导页视图

/**
 *  添加引导页视图
 */
-(void)addContentView{
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    self.contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.contentView.backgroundColor=[UIColor whiteColor];
    [appDelegate.window addSubview:self.contentView];
}

/**
 *  添加播放器
 */
-(void)addAVPlayer{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"changjing_shejishi-960" ofType:@"mp4"];
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:filePath];
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    // 获得播放媒介
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    // 初始化播放器
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    // 创建播放器层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.contentView.layer.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.contentView.layer addSublayer:playerLayer];
    [self.player play];
    
    UIButton *jumpBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-70, 20, 60, 30)];
    [jumpBtn setImage:[UIImage imageNamed:@"ic_tiaoguo"] forState:UIControlStateNormal];
    [jumpBtn addTarget:self action:@selector(enterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:jumpBtn];
}

/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

/**
 *  播放完成通知
 *  @param notification 通知对象
 */
//  播放完成
-(void)playbackFinished:(NSNotification *)notification{
    [self enterBtn];
}

-(void)enterBtn{
    [self.player pause];   //暂停播放
    [self hide];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_yd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  播放完成,移除视图
- (void)hide
{
    [UIView animateWithDuration:.35 animations:^{
       // self.contentView.transform =CGAffineTransformMakeScale(1.3, 1.3);
        self.contentView.alpha=0.2;
    } completion:^(BOOL finished) {
        if(finished) [self.contentView removeFromSuperview];
    }];
}

#pragma mark -IMLoginDelegate
-(void)pushToIMVC:(UIViewController *)IMVC{
    IMVC.hidesBottomBarWhenPushed =YES;
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
        [appDelegate.nav setNavigationBarHidden:YES animated:NO];
    if([IMVC isKindOfClass:[YWConversationViewController class]])
     self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:IMVC animated:YES];
  
}





#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 13;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        float height=80+kMiddleSingleImage_Height*2+0.5+60;
        return height;
    }
//    else if(indexPath.section==1){
//        return 100;
//    }
    else{
        NSDictionary *dict=self.recom_array[indexPath.section-1];
        if([[dict objectForKey:@"indexPicUrl"] length]) return kMainScreenWidth/2+20+40+20;
        else{
            CGSize size=[util calHeightForLabel:[dict objectForKey:@"recommendDesc"] width:kMainScreenWidth-80 font:[UIFont systemFontOfSize:13.5]];
            return 25+size.height+25;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1+[self.recom_array count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycellid_";
    ShopClearblankCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ShopClearblankCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        if(indexPath.section==0){
            UIView *topfunction =[self createTopFunction];
            topfunction.frame =CGRectMake(0, 0, kMainScreenWidth, 60);
            [cell.contentView addSubview:topfunction];
            
            UIView *middleFunciton =[self createMiddleFunction];
            middleFunciton.frame =CGRectMake(0, 60, kMainScreenWidth, kMiddleSingleImage_Height*2+0.5);
            [cell.contentView addSubview:middleFunciton];
            
            UIView *footFuncitonback =[self createFootFunction];
            footFuncitonback.frame =CGRectMake(0, CGRectGetMaxY(middleFunciton.frame), kMainScreenWidth, 80);
            [cell.contentView addSubview:footFuncitonback];
        }
//        else
//            if (indexPath.section==1){
//            UIView *knowledgefunction =[self createKnowledgeFunction];
//            knowledgefunction.frame =CGRectMake(0, 0, kMainScreenWidth, 100);
//            [cell.contentView addSubview:knowledgefunction];
//        }
    }
    
    if(indexPath.section >= 1 && [self.recom_array count]){
        NSDictionary *dict=self.recom_array[indexPath.section-1];
        
        float height=0;
        if([[dict objectForKey:@"indexPicUrl"] length]){
            UIImageView *picture=(UIImageView *)[cell.contentView viewWithTag:kMainTuiJianPicture_TAG+indexPath.section];
            if(!picture) picture=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth/2)];
            picture.tag=kMainTuiJianPicture_TAG+indexPath.section;
            picture.contentMode=UIViewContentModeScaleAspectFill;
            picture.clipsToBounds=YES;
            [picture setOnlineImage:[dict objectForKey:@"indexPicUrl"] placeholderImage:[UIImage imageNamed:@"ic_morentu"]];
            [cell.contentView addSubview:picture];
            
            height+=kMainScreenWidth/2;
        }
        
        NSInteger indexType=[[dict objectForKey:@"indexType"] integerValue];
        NSArray *arrImages=@[@"ic_shejibiaoqian",@"ic_gonzhangbiaoqian",@"ic_jianlibiaoqian",@"ic_fanganbiaoqian"
                             ,@"ic_rijibiaoqian",@"ic_gongdibiaoqian",@"ic_renmen"];     // @"ic_shangpin",@"ic_pinpai"
        if(indexType-1<[arrImages count] && indexType>=1){
            UIImage *img=[UIImage imageNamed:arrImages[indexType-1]];
            UIImageView *BQPic=(UIImageView *)[cell.contentView viewWithTag:kMainTuiJianBiaoQianPic_TAG+indexPath.section];
            if(!BQPic) BQPic=[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-img.size.width-15, height, img.size.width, img.size.height)];
            BQPic.tag=kMainTuiJianBiaoQianPic_TAG+indexPath.section;
            BQPic.contentMode=UIViewContentModeScaleAspectFill;
            BQPic.clipsToBounds=YES;
            BQPic.image=img;
            [cell.contentView addSubview:BQPic];
            if([[dict objectForKey:@"indexPicUrl"] length]==0) BQPic.image=[UIImage imageNamed:@"icon_tuijian"];
        }
        
        UILabel *descLab=(UILabel *)[cell.contentView viewWithTag:kMainTuiJianText_TAG+indexPath.section];
        if(!descLab) descLab=[[UILabel alloc]initWithFrame:CGRectMake(25, height+20, kMainScreenWidth-80, 40)];
        descLab.tag=kMainTuiJianText_TAG+indexPath.section;
        descLab.textColor=[UIColor grayColor];
        descLab.textAlignment=NSTextAlignmentLeft;
        descLab.font=[UIFont systemFontOfSize:13.5];
        if([[dict objectForKey:@"indexPicUrl"] length]){
            descLab.numberOfLines=2;
            descLab.frame=CGRectMake(25, height+20, kMainScreenWidth-80, 40);
        }
        else{
            CGSize size=[util calHeightForLabel:[dict objectForKey:@"recommendDesc"] width:kMainScreenWidth-80 font:[UIFont systemFontOfSize:13.5]];
            descLab.numberOfLines=0;
            descLab.frame=CGRectMake(25, height+25, kMainScreenWidth-80, size.height);
        }
        descLab.text=[NSString stringWithFormat:@"%@ ",[dict objectForKey:@"recommendDesc"]];
        [cell.contentView addSubview:descLab];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MobClick event:@"Click_HotInfor"];
    
    if(indexPath.section >=1){
        NSDictionary *dict=[self.recom_array objectAtIndex:indexPath.section-1];
        NSInteger indexType=[[dict objectForKey:@"indexType"] integerValue];
        if(indexType==1){
            /*设计师*/
            IDIAI3DesignerDetailViewController *Designerinfovc = [[IDIAI3DesignerDetailViewController alloc]init];
            Designerinfovc.designerID = [[dict objectForKey:@"indexId"] integerValue];
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
            [appDelegate.nav pushViewController:Designerinfovc animated:YES];
//            [self.navigationController pushViewController:Designerinfovc animated:YES];
        }
        else if (indexType==2){
            /*工长*/
            IDIAI3GongZhangDetaileViewController *gzinfovc =[[IDIAI3GongZhangDetaileViewController alloc] init];
            gzinfovc.gongZhangID=[[dict objectForKey:@"indexId"] integerValue];
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
            [appDelegate.nav pushViewController:gzinfovc animated:YES];
//            [self.navigationController pushViewController:gzinfovc animated:YES];
        }
        else if (indexType==3){
            /*监理*/
            IDIAI3JianLiDetailViewController *jlinfovc =[[IDIAI3JianLiDetailViewController alloc] init];
            jlinfovc.jianliID=[[dict objectForKey:@"indexId"] integerValue];
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
            [appDelegate.nav pushViewController:jlinfovc animated:YES];
//            [self.navigationController pushViewController:jlinfovc animated:YES];
        }
        else if (indexType==4){
            /*案例*/
            EffectTAOTUPictureInfo *effVC=[[EffectTAOTUPictureInfo alloc]init];
            effVC.taotuID=[[dict objectForKey:@"indexId"] integerValue];;
            effVC.ishome =YES;
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
            effVC.selectDone =^(MyeffectPictureObj *obj_pic){
                
            };
            [appDelegate.nav pushViewController:effVC animated:YES];
//            [self.navigationController pushViewController:effVC animated:YES];
        }
        else if (indexType==5){
            /*日记*/
            IDIAI3DiaryDetaileViewController *detail =[[IDIAI3DiaryDetaileViewController alloc] init];
            detail.title =@"帖子详情";
            detail.diaryId =[NSString stringWithFormat:@"%@",[dict objectForKey:@"indexId"]];
            detail.type =7;
            detail.ismyDiary =NO;
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
            [appDelegate.nav pushViewController:detail animated:YES];
//            [self.navigationController pushViewController:detail animated:YES];
        }
        else if (indexType==6){
            /*工地*/
            BuidlDetailViewController *buidldetail =[[BuidlDetailViewController alloc] init];
            buidldetail.title =@"工地详情";
            buidldetail.foremanSitesId =[NSString stringWithFormat:@"%@",[dict objectForKey:@"indexId"]];
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
            [appDelegate.nav pushViewController:buidldetail animated:YES];
//            [self.navigationController pushViewController:buidldetail animated:YES];
        }
        else if (indexType==7){
            RecommendDetailViewController *recommend =[[RecommendDetailViewController alloc] init];
            recommend.title =@"推荐详情";
            recommend.url =[NSString stringWithFormat:@"%@%@",IndexRecommendUrl,[dict objectForKey:@"hrId"]];
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
            [appDelegate.nav pushViewController:recommend animated:YES];
//            [self.navigationController pushViewController:recommend animated:YES];
        }
    }
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
//    if (self.refreshing==YES) {
//        self.currentPage=0;
//        [self RequestDiaryList];
//    }
//    else {
//        if(self.totalPages>self.currentPage){
//            [self RequestDiaryList];
//        }
//        else{
//            [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
//            mtableview.reachedTheEnd = YES;  //是否加载到底了
//        }
//    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    //MJLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    //self.refreshing=YES;
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
    
   // self.refreshing=NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView == _scrFoot){
        self.pageControl.currentPage=scrollView.contentOffset.x/kMainScreenWidth;
    }
}

#pragma mark -createFootFunction

-(UIView *)createFootFunction{
    UIView *footFuncitonback =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 80)];
    footFuncitonback.backgroundColor =[UIColor whiteColor];
    
    if(!_scrFoot) _scrFoot=[[UIScrollView alloc]initWithFrame:footFuncitonback.bounds];
    _scrFoot.contentSize=CGSizeMake(kMainScreenWidth*2, footFuncitonback.bounds.size.height);
    _scrFoot.delegate=self;
    _scrFoot.pagingEnabled=YES;
    _scrFoot.showsVerticalScrollIndicator=NO;
    _scrFoot.showsHorizontalScrollIndicator=NO;
    [footFuncitonback addSubview:_scrFoot];
    
    if(!self.pageControl) {self.pageControl = [[TTPageControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(footFuncitonback.frame)-20*2, CGRectGetHeight(_scrFoot.frame)-18, 20*2, 18)];
        self.pageControl.currentPage = 0;
    }
    self.pageControl.center = CGPointMake(footFuncitonback.center.x, self.pageControl.center.y);
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentDotImage=[UIImage imageNamed:@"ic_dian_l"];
    self.pageControl.dotImage=[UIImage imageNamed:@"ic_dian_r"];
    [footFuncitonback addSubview:self.pageControl];
    
    NSArray *arr_Names=@[@"知识",@"灵感",@"保障",@"验房",@"工地",@"小工",@"报价",@"贷款"];
    NSArray *arr_Images=@[@"ic_zhishi",@"ic_xiaoguotuNew",@"ic_baozhangNew",@"ic_yanfangNew",@"ic_gongdiNew",@"ic_xiaogongNew"
                          ,@"ic_baojiaNew",@"ic_shenqingdaikuanNew"];
    for(int i=0;i<[arr_Images count];i++){
        UIButton *btn=(UIButton *)[_scrFoot viewWithTag:kMainUIButton_TAG+i];
        if(!btn)btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth/4*i, 0, kMainScreenWidth/4, CGRectGetHeight(_scrFoot.frame)-18)];
        btn.tag=kMainUIButton_TAG+i;
        [btn setImage:[UIImage imageNamed:[arr_Images objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setTitle:[arr_Names objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:13.5];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(7, (kMainScreenWidth/4-[UIImage imageNamed:[arr_Images objectAtIndex:i]].size.width)/2, 20, (kMainScreenWidth/4-[UIImage imageNamed:[arr_Images objectAtIndex:i]].size.width)/2)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(48, -25, 0, 10)];
        [btn addTarget:self action:@selector(PressMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_scrFoot addSubview:btn];
    }

    
//    UIImageView *radioImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
//    radioImg.animationImages = @[[UIImage imageNamed:@"ic_laba_1"],[UIImage imageNamed:@"ic_laba_2"]]; //动画图片数组
//    radioImg.animationDuration = 2; //执行一次完整动画所需的时长
//    radioImg.animationRepeatCount = 0;  //动画重复次数
//    [radioImg startAnimating];
//    [footFuncitonback addSubview:radioImg];
//    
//    if(!_jtLabel) _jtLabel=[[JTScrollLabelView alloc]initWithFrame:CGRectMake(55, 2.5, kMainScreenWidth-65, 55)];
//    _jtLabel.delegate=self;
//    [footFuncitonback addSubview:_jtLabel];
    
    return footFuncitonback;
}

-(void)JTScrollLabelViewClickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

#pragma mark -createMiddleFunction

-(UIView *)createMiddleFunction{
    UIView *middleFuncitonback =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMiddleSingleImage_Height*2+0.5)];
    middleFuncitonback.backgroundColor =[UIColor whiteColor];
    
    NSArray *logoNormalArr=@[@"Ic_shejifangan",@"Ic_zhuangxiushigong",@"Ic_zhuangxiuguanjia",@"homeshangcheng"];
    NSArray *logoSelectedArr=@[@"Ic_shejifangan_s",@"Ic_zhuangxiushigong_s",@"Ic_zhuangxiuguanjia_s.png",@"homeshangcheng_s"];
    float widthImg=kMainScreenWidth/2;
    for (int i=0; i<4; i++) {
        UIButton *funbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        funbtn.frame =CGRectMake((widthImg+0.5)*(i%2), (kMiddleSingleImage_Height+0.5)*(i/2), widthImg, kMiddleSingleImage_Height);
        funbtn.tag =300+i;
        funbtn.imageView.contentMode=UIViewContentModeScaleAspectFill;
        funbtn.imageView.clipsToBounds=YES;
        [funbtn setImage:[UIImage imageNamed:logoNormalArr[i]] forState:UIControlStateNormal];
        [funbtn setImage:[UIImage imageNamed:logoSelectedArr[i]] forState:UIControlStateHighlighted];
        [funbtn addTarget:self action:@selector(middleAction:) forControlEvents:UIControlEventTouchUpInside];
        [middleFuncitonback addSubview:funbtn];
    }
    return middleFuncitonback;
}

-(void)middleAction:(UIButton*)sender{
    if (sender.tag ==300) {
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
        MyeffectypictureVC *effectvc=[[MyeffectypictureVC alloc]init];
        effectvc.picture_type=@"taotu";
        effectvc.hidesBottomBarWhenPushed=YES;
        [appDelegate.nav pushViewController:effectvc animated:YES];
//        [self.navigationController pushViewController:effectvc animated:YES];
    }else if (sender.tag ==301){
        GongzhangtuanViewController *gongzhangtuanVC = [[GongzhangtuanViewController alloc]init];
        gongzhangtuanVC.hidesBottomBarWhenPushed = YES;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;//zl
        [delegate.nav pushViewController:gongzhangtuanVC animated:YES];
//        [self.navigationController pushViewController:gongzhangtuanVC animated:YES];
    }else if (sender.tag ==302){
        JianliViewController *supervisorVC = [[JianliViewController alloc]init];
        supervisorVC.hidesBottomBarWhenPushed = YES;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;//zl
        [delegate.nav pushViewController:supervisorVC animated:YES];
//        [self.navigationController pushViewController:supervisorVC animated:YES];
    }else{
//        ShoppingMallViewController *shoppingMallVC = [[ShoppingMallViewController alloc]init];
//        shoppingMallVC.hidesBottomBarWhenPushed=YES;
//        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate.nav pushViewController:shoppingMallVC animated:YES];
        WTBWebViewViewController * shoppingMallWebViewVC= [[WTBWebViewViewController alloc]init];
        shoppingMallWebViewVC.hidesBottomBarWhenPushed = YES;
//        shoppingMallWebViewVC.backType = @"TabBar";
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

        shoppingMallWebViewVC.requesUrl  =[NSString stringWithFormat:@"%@?userId=%@&cityCode=%@&token=%@",kUrlShoppingMall,string_userid,kCityCode,string_token];
//        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;//zl
//        [delegate.nav pushViewController:shoppingMallWebViewVC animated:YES];
        [self.navigationController pushViewController:shoppingMallWebViewVC animated:YES];
    }
}

#pragma mark - createTopFunction

-(UIView *)createTopFunction{
    UIView *topFuncitonback =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    topFuncitonback.backgroundColor = [UIColor whiteColor];
    
    UIImageView *radioImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
    radioImg.animationImages = @[[UIImage imageNamed:@"ic_laba_1"],[UIImage imageNamed:@"ic_laba_2"]]; //动画图片数组
    radioImg.animationDuration = 2; //执行一次完整动画所需的时长
    radioImg.animationRepeatCount = 0;  //动画重复次数
    [radioImg startAnimating];
    [topFuncitonback addSubview:radioImg];
    
    if(!_jtLabel) _jtLabel=[[JTScrollLabelView alloc]initWithFrame:CGRectMake(55, 2.5, kMainScreenWidth-65, 55)];
    _jtLabel.delegate=self;
    [topFuncitonback addSubview:_jtLabel];

    
//    if(!_scrFoot) _scrFoot=[[UIScrollView alloc]initWithFrame:topFuncitonback.bounds];
//    _scrFoot.contentSize=CGSizeMake(kMainScreenWidth*2, topFuncitonback.bounds.size.height);
//    _scrFoot.delegate=self;
//    _scrFoot.pagingEnabled=YES;
//    _scrFoot.showsVerticalScrollIndicator=NO;
//    _scrFoot.showsHorizontalScrollIndicator=NO;
//    [topFuncitonback addSubview:_scrFoot];
//    
//    if(!self.pageControl) {self.pageControl = [[TTPageControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(topFuncitonback.frame)-20*2, CGRectGetHeight(_scrFoot.frame)-18, 20*2, 18)];
//        self.pageControl.currentPage = 0;
//    }
//    self.pageControl.center = CGPointMake(topFuncitonback.center.x, self.pageControl.center.y);
//    self.pageControl.numberOfPages = 2;
//    self.pageControl.currentDotImage=[UIImage imageNamed:@"ic_dian_l"];
//    self.pageControl.dotImage=[UIImage imageNamed:@"ic_dian_r"];
//    [topFuncitonback addSubview:self.pageControl];
//    
//    NSArray *arr_Names=@[@"灵感",@"保障",@"验房",@"工地",@"小工",@"报价",@"贷款"];
//    NSArray *arr_Images=@[@"ic_xiaoguotuNew",@"ic_baozhangNew",@"ic_yanfangNew",@"ic_gongdiNew",@"ic_xiaogongNew"
//                          ,@"ic_baojiaNew",@"ic_shenqingdaikuanNew"];
//    for(int i=0;i<[arr_Images count];i++){
//        UIButton *btn=(UIButton *)[_scrFoot viewWithTag:kMainUIButton_TAG+i];
//        if(!btn)btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth/4*i, 0, kMainScreenWidth/4, CGRectGetHeight(_scrFoot.frame)-18)];
//        btn.tag=kMainUIButton_TAG+i;
//        [btn setImage:[UIImage imageNamed:[arr_Images objectAtIndex:i]] forState:UIControlStateNormal];
//        [btn setTitle:[arr_Names objectAtIndex:i] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        btn.titleLabel.font=[UIFont systemFontOfSize:13.5];
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(7, (kMainScreenWidth/4-[UIImage imageNamed:[arr_Images objectAtIndex:i]].size.width)/2, 20, (kMainScreenWidth/4-[UIImage imageNamed:[arr_Images objectAtIndex:i]].size.width)/2)];
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(48, -25, 0, 10)];
//        [btn addTarget:self action:@selector(PressMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [_scrFoot addSubview:btn];
//    }
    
    return topFuncitonback;
}

#pragma mark - createKnowledgeFunction

-(void)PressMenuBtn:(UIButton *)sender{
    NSInteger index=sender.tag;
    switch (index) {
        case 1000:{
        
            KnowledgeViewController * knowledageVC = [[KnowledgeViewController alloc]init];
            knowledageVC.hidesBottomBarWhenPushed = YES;
//            
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
            [appDelegate.nav pushViewController:knowledageVC animated:YES];
//            [self.navigationController pushViewController:knowledageVC animated:YES];
            break;
        
        }
        case 1001:
        {
            SeeEffectPictureViewController *effectVC=[[SeeEffectPictureViewController alloc]init];
            effectVC.hidesBottomBarWhenPushed = YES;
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
            [appDelegate.nav pushViewController:effectVC animated:YES];
//            [self.navigationController pushViewController:effectVC animated:YES];
            break;
        }
        case 1002:
        {
            [MobClick event:@"Click_Security"];
            IDIAI3EngineerSupportViewController *esVC=[[IDIAI3EngineerSupportViewController alloc]init];
            esVC.hidesBottomBarWhenPushed = YES;
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
            [appDelegate.nav pushViewController:esVC animated:YES];
//            [self.navigationController pushViewController:esVC animated:YES];
            break;
        }
        case 1003:
        {
            CommonFreeViewController *common =[[CommonFreeViewController alloc] init];
            common.type =0;
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
            [appDelegate.nav pushViewController:common animated:YES];
//            [self.navigationController pushViewController:common animated:YES];
            break;
        }
        case 1004:
        {
            [self openUTopGDApp];
            break;
        }
        case 1005:
        {
            WorkerSearcheMapViewController *workMapVC = [[WorkerSearcheMapViewController alloc]init];
//            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;//zl
            workMapVC.hidesBottomBarWhenPushed = YES;
//            [delegate.nav pushViewController:workMapVC animated:YES];
            [self.navigationController pushViewController:workMapVC animated:YES];
            break;
        }
        case 1006:
        {
            MyhouseTypeVC *myHouseTypeVC = [[MyhouseTypeVC alloc]init];
            myHouseTypeVC.hidesBottomBarWhenPushed = YES;
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
            [appDelegate.nav pushViewController:myHouseTypeVC animated:YES];
//            [self.navigationController pushViewController:myHouseTypeVC animated:YES];
            break;
        }
        case 1007:
        {
            CommonFreeViewController *common =[[CommonFreeViewController alloc] init];
            common.type =2;
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
            [appDelegate.nav pushViewController:common animated:YES];
//            [self.navigationController pushViewController:common animated:YES];
            break;
        }
        default:
            break;
    }
}

-(void)TapActionKnowledge:(UIGestureRecognizer *)gesture{
    NSInteger index=gesture.view.tag-kTapKnowldge_TAG;
    KnowledgeViewController *knowledgeVC = [[KnowledgeViewController alloc]init];
    knowledgeVC.selectedIndex=index;
    knowledgeVC.hidesBottomBarWhenPushed = YES;
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.nav pushViewController:knowledgeVC animated:YES];
//    [self.navigationController pushViewController:knowledgeVC animated:YES];
}

#pragma mark - 客服端轮播动态信息
-(void)requestDynamicInfoList{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0342\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"客服端轮播动态信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (code==103421) {
                        NSArray *arr_=[jsonDict objectForKey:@"dynamicInfos"];
                        NSMutableArray *dataArray=[NSMutableArray arrayWithCapacity:0];
                        NSMutableArray *timeArray=[NSMutableArray arrayWithCapacity:0];
                        for(NSDictionary *dict in arr_){
                            [dataArray addObject:[dict objectForKey:@"dynamicInfo"]];
                            [timeArray addObject:[self getDateString:[dict objectForKey:@"createTime"]]];
                        }
                        [_jtLabel beginScrollDatas:dataArray TimerDatas:timeArray TimeInterval:0.04];
                    }
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

#pragma mark - 首页的推荐动态信息

-(void)requestHomePageRecommendedList{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0343\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"首页的推荐动态信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (code==103431) {
                        self.recom_array=[NSMutableArray arrayWithArray:[jsonDict objectForKey:@"indexRecommendInfo"]];
//                        [mtableview beginUpdates];
//                        [mtableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//                        [mtableview endUpdates];
                        
                        [mtableview reloadData];
                    }
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

#pragma mark -
#pragma mark - CityListDelegate

-(void)didSelectedCity:(CityListObj *)obj{
    if (![obj.cityName isEqualToString:self.self.Cityname_location] && self.self.Cityname_location) {
        [self dismissViewControllerAnimated:YES completion:^{
            if(obj){
                self.Citycode_location=obj.cityCode;
                self.Cityname_location =obj.cityName;
                UIAlertView *alerv=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"是否切换当前城市为%@",obj.cityName] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                alerv.tag =100000;
                [alerv show];
                
            }
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            self.Citycode_location=obj.cityCode;
            self.Cityname_location =obj.cityName;
            [_leftButton setTitle:self.Cityname_location forState:UIControlStateNormal];
            
            [[NSUserDefaults standardUserDefaults] setObject:@{@"cityName":self.Cityname_location,@"cityCode":self.Citycode_location} forKey:cityCodeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self requestDistrictNOlist];
            [self requestHomePageRecommendedList];
        }];
        
    }
}

#pragma mark - 请求当前城市下区县列表
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
                        IDIAIAppDelegate *delegate_=(IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                        delegate_.array_area_list=arr_;
                    });
                }
                else if (code==10429) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                              });
                          }
                               method:url postDict:nil];
    });
    
}

#pragma mark - 请求城市列表
-(void)requestCitylist{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0041\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"城市列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10411) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *arr_=[jsonDict objectForKey:@"cityList"];
                        NSMutableArray *data_=[NSMutableArray arrayWithCapacity:0];
                        if ([arr_ count]) {
                            for(NSDictionary *dict in arr_){
                                [data_ addObject:[CityListObj objWithDict:dict]];
                            };
                        }
                        
                        IDIAIAppDelegate *delegate_=(IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                        delegate_.array_city_list=data_;
                        
                        if([delegate_.array_city_list count]) [_locService startUserLocationService];
                        else [_locService stopUserLocationService];
                        
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

#pragma mark - 请求活动列表
-(void)requestBannerlist{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (code==10401) {
                        if([self.data_array count]) [self.data_array removeAllObjects];
                        NSArray *arr_=[jsonDict objectForKey:@"bannerList"];
                        NSMutableArray *arr_images=[NSMutableArray array];
                        if([arr_ count]){
                            for(NSDictionary *dict in arr_){
                                if([[dict objectForKey:@"bannerWay"] integerValue]==2){
                                    [self.data_array addObject:dict];
                                    [arr_images addObject:[dict objectForKey:@"bannerUrl"]];
                                }
                                else continue;
                            }
                            autoScrollView.images = arr_images;
                            if([arr_images count]>1) autoScrollView.isAutoScorll=YES;
                            else if([arr_images count]==1) [autoScrollView stopScroll];
                            [autoScrollView ajustImageViewContent];
                        }
                    }
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

#pragma mark - 活动被点击

-(void)imageClicked:(NSInteger)index{
    [MobClick event:@"Click_banner"];   //友盟自定义事件,数量统计
    if(index<[self.data_array count]){
        NSDictionary *dict=[self.data_array objectAtIndex:index];
        if([[dict objectForKey:@"bannerType"] integerValue]==1){
            if([[dict objectForKey:@"bannerDetailUrl"] length]){
                WTBWebViewViewController *bannervc=[[WTBWebViewViewController alloc]init];
                bannervc.requesUrl=[dict objectForKey:@"bannerDetailUrl"];
                bannervc.hidesBottomBarWhenPushed=YES;
                IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
                [appDelegate.nav pushViewController:bannervc animated:YES];
//                [self.navigationController pushViewController:bannervc animated:YES];
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
}

#pragma mark -
#pragma mark - BMKGeoCodeSearchDelegate

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        [_locService stopUserLocationService];
        
        self.Cityname_location =[NSString stringWithFormat:@"%@",result.addressDetail.city];
        NSLog(@"%@",self.Cityname_location);
        //将定位城市与开通城市比较
        IDIAIAppDelegate *delegate_=(IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        if([delegate_.array_city_list count]){
            BOOL is_city_kt=NO;
            for(CityListObj *obj in delegate_.array_city_list){
                if([obj.cityName isEqualToString:self.Cityname_location]) {
                    is_city_kt=YES;
                    if(![[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityName"] isEqualToString:self.Cityname_location]){
                        self.Citycode_location=obj.cityCode;
                        UIAlertView *alerv=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"已定位到您当前所在城市为%@，是否切换？",self.Cityname_location] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                        alerv.tag =100000;
                        [alerv show];
                    }
                    break;
                }
                else continue;
            }
            
            if(is_city_kt==NO){
                UIAlertView *alerv=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"当前定位“%@”暂未开通“屋托邦”，默认切换为成都",self.Cityname_location] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alerv.tag =100000;
                [alerv show];
                [[NSUserDefaults standardUserDefaults] setObject:@{@"cityName":@"成都市",@"cityCode":@"510100"} forKey:cityCodeKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [_leftButton setTitle:@"成都市" forState:UIControlStateNormal];
            }
        }
        else{
            [self requestCitylist];
        }
    }
    else{
        [_locService stopUserLocationService];
    }
}

#pragma mark -
#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation.location.coordinate.latitude >0 && userLocation.location.coordinate.longitude >0) {
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
        BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag) NSLog(@"反geo检索发送成功");
        else NSLog(@"反geo检索发送失败");
    }
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==100000) {
        if (buttonIndex!=alertView.cancelButtonIndex) {
            [_leftButton setTitle:self.Cityname_location forState:UIControlStateNormal];
            
            [[NSUserDefaults standardUserDefaults] setObject:@{@"cityName":self.Cityname_location,@"cityCode":self.Citycode_location} forKey:cityCodeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self requestDistrictNOlist];
            [self requestHomePageRecommendedList];
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
        else{
            NSMutableDictionary *dic =[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey];
            self.Cityname_location =[dic objectForKey:@"cityName"];
            self.Citycode_location =[dic objectForKey:@"cityCode"];
            
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
    }
    else if (alertView.tag==100001){
        if (buttonIndex ==alertView.cancelButtonIndex) {
            LearnDecorViewController *learnVC=[[LearnDecorViewController alloc]init];
            learnVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:learnVC animated:NO];
        }else{
            PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc]init];
            personalInfoVC.hidesBottomBarWhenPushed = YES;
            personalInfoVC.isHomePage =YES;
            IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.nav pushViewController:personalInfoVC animated:YES];
        }
    }
    else if (alertView.tag==100002){
        if (buttonIndex!=alertView.cancelButtonIndex) [self downloadUTopGDApp];
        else [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

#pragma mark - 调起屋托邦看工地App
/*
 注意：URL Schemes必填， URL identifier选填。
 另外，URL Schemes建议都小写，因为之后接收到数据的时候，不区分大小写，都是转为小写。
 规定的格式是：URL Schemes://URL identifier ，其中(URL identifier可不填写)
 */
- (void)openUTopGDApp {
    NSString *UrlSchemes =@"qttecx.utopgd://";
    NSURL *urlApp = [NSURL URLWithString:[UrlSchemes stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([[UIApplication sharedApplication] canOpenURL:urlApp])
        [[UIApplication sharedApplication] openURL:urlApp];
    else{
        UIAlertView *alv=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您尚未安装“屋托邦看工地”，是否立即前往下载安装？" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"立即", nil];
        alv.tag=100002;
        [alv show];
    }
}

#pragma mark - 下载屋托邦看工地App
- (void)downloadUTopGDApp {
    NSString *sPappIDStr = @"1044950732";
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", sPappIDStr];
    NSURL *iTunesURL = [NSURL URLWithString:[iTunesString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([[UIApplication sharedApplication] canOpenURL:iTunesURL]) [[UIApplication sharedApplication] openURL:iTunesURL];
}

#pragma mark - 
#pragma mark -  春节红包

-(void)showEnvelopeAction:(id)sender{
    if (self.envelopeimage ==nil) {
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        self.envelopebackView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        self.envelopebackView.backgroundColor =[UIColor blackColor];
        self.envelopebackView.alpha =0.5;
        [keywindow addSubview:self.envelopebackView];
        
        self.envelopeimage =[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-(kMainScreenWidth-225)/2, kMainScreenHeight-(kMainScreenHeight-238)/2, 1, 1)];
        self.envelopeimage.image =[UIImage imageNamed:@"envelope.png"];
        self.envelopeimage.userInteractionEnabled =YES;
        [keywindow addSubview:self.envelopeimage];
        
        self.closebtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.closebtn setImage:[UIImage imageNamed:@"closeenvelope"] forState:UIControlStateNormal];
        [self.closebtn setImage:[UIImage imageNamed:@"closeenvelope"] forState:UIControlStateHighlighted];
        [self.closebtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        self.closebtn.frame =CGRectMake(kMainScreenWidth-17-35, 34, 35, 34);
        [keywindow addSubview:self.closebtn];
        
        self.openbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.openbtn.backgroundColor =[UIColor clearColor];
        [self.openbtn addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
        self.openbtn.frame =CGRectMake(95, 10, 100, 100);
        [self.envelopeimage addSubview:self.openbtn];
        
    }else{
        self.envelopeimage.frame =CGRectMake(kMainScreenWidth-(kMainScreenWidth-225)/2, kMainScreenHeight-(kMainScreenHeight-238)/2, 1, 1);
    }
    
    
    [UIView animateWithDuration:0.30 animations:^{
        self.envelopeimage.frame =CGRectMake((kMainScreenWidth-225*kMainScreenWidth/320)/2, (kMainScreenHeight-238*kMainScreenWidth/320)/2, 225*kMainScreenWidth/320, 238*kMainScreenWidth/320);
    } completion:^(BOOL finished) {
        //finished判断动画是否完成
        if (finished) {
            NSLog(@"finished");
            if (finished ==YES) {
                self.envelopeimage.transform = CGAffineTransformMakeScale(0.9, 0.9);
                [UIView animateWithDuration:0.5
                                      delay:0.0
                     usingSpringWithDamping:0.3
                      initialSpringVelocity:5
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     self.envelopeimage.transform = CGAffineTransformIdentity;
                                 }
                                 completion:nil];
            }
        }
    }];
    for (int i=0; i<7; i++) {
        UIImageView *money =[[UIImageView alloc] initWithFrame:CGRectMake(0, -91, 58, 91)];
        money.tag =1001+i;
        money.image =[UIImage imageNamed:@"money"];
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        //        money.backgroundColor =[UIColor redColor];
        [keywindow addSubview:money];
    }
    self.moneytag =0;
    
    //定时器
    NSTimer   *showTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                            target:self
                                                          selector:@selector(showMoney:)
                                                          userInfo:nil
                                                           repeats:YES];
    [showTimer fire];
}
-(void)closeAction:(id)sender{
    [self.openbtn removeFromSuperview];
    [self.envelopeimage removeFromSuperview];
    [self.envelopebackView removeFromSuperview];
    [self.closebtn removeFromSuperview];
    self.envelopeimage =nil;
    self.envelopebackView =nil;
    self.closebtn =nil;
    self.openbtn =nil;
    self.moneytag =0;
}
-(void)openAction:(id)sender{
    int opennum =0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"opennum"]) {
        opennum =[[[NSUserDefaults standardUserDefaults] objectForKey:@"opennum"] intValue];
    }
    opennum++;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",opennum] forKey:@"opennum"];
    if (opennum>=5) {
        self.showEnvelope.hidden =YES;
        self.monkeyimage.hidden =YES;
    }
    [self.openbtn removeFromSuperview];
    int num =random()%5;
    self.envelopeimage.image =[UIImage imageNamed:[NSString stringWithFormat:@"envelopeend%d",num]];
}
-(void)showMoney:(NSTimer *)theTimer{
    if (self.moneytag ==7) {
        [theTimer invalidate];
    }
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    UIImageView *money =(UIImageView *)[keywindow viewWithTag:1001+self.moneytag];
    float frameX =random()%320;
    money.frame =CGRectMake(frameX, -91, 58, 91);
    [UIView animateWithDuration:1.0 animations:^{
        money.frame =CGRectMake(frameX, kMainScreenHeight, 58, 91);
    } completion:^(BOOL finished) {
        //finished判断动画是否完成
        if (finished) {
            NSLog(@"finished");
            if (finished ==YES) {
                [money removeFromSuperview];
            }
        }
    }];
    self.moneytag++;
}

/*******毫秒转换******/
- (NSString *)getDateString:(NSString *) msecStr{
    NSDate *getDate = [[NSDate alloc]initWithTimeIntervalSince1970:[msecStr doubleValue]/1000.0];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM/dd HH:mm"];
    NSString *locationString=[dateformatter stringFromDate:getDate];
    
    return locationString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
