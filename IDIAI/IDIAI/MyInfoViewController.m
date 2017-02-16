//
//  MyInfoViewController.m
//  UTOP
//
//  Created by iMac on 14-11-21.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#define kCurrentVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define Firth_Cell_Button_Height 64
#define Firth_Cell_Button_ImageView_Height 30
#define Firth_Cell_Button_Label_Font [UIFont systemFontOfSize:13];
#define Space_Image_To_Label_In_Button 40
#define SecondSection_Cell_LabelText_Font [UIFont systemFontOfSize:14]

#import "MyInfoViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "HexColor.h"
#import "util.h"
#import "UIScrollView+TwitterCover.h"
#import "MyInfoHeader.h"
#import "UIImageView+OnlineImage.h"
#import "PersonalInfoViewController.h"
#import "SVProgressHUD.h"
#import "TLToast.h"
#import "RetroactionVC.h"
#import "MyhouseTypeVC.h"
#import "AutomaticLogin.h"
#import "AboutSelfViewController.h"
#import "IDIAIAppDelegate.h"
#import "CollectionViewController.h"
#import "LoginView.h"
#import "AddressManageViewController.h"
#import "DecorationInfoViewController.h"
#import "savelogObj.h"
#import "EmptyClearTableViewCell.h"
#import "IDIAI3MyAccountViewController.h"
#import "IDIAI3DiaryViewController.h"
#import "MoreResourcesViewController.h"
#import "MainMessageViewController.h"
#import "MyPreferentialViewController.h"
#import "MyToDoViewController.h"
#import "MyMailMainViewController.h"
#import "SettingViewController.h"
#import "PointMallViewController.h"
#import "MyOrderMainViewController.h"
#import "OrderOfGoodsMainViewController.h"
#import "MySeverOrderViewController.h"
#import "MyGoodsOrderViewController.h"
#import "UIImageView+WebCache.h"
#import "IMlogin.h"
#import <WXOUIModule/YWConversationViewController.h>
#import "SPTabBarViewController.h"
#import "SPUtil.h"
#import "WTBWebViewViewController.h"
#import "AFNetworking.h"
#define NAVBAR_CHANGE_POINT 50

@interface MyInfoViewController ()<IMLoginDelegate>  {
    UITableView *_theTableView;
    UIActivityIndicatorView *_activityIndicatorView;
    NSString *_appStoreVersionStr;
    
    MyInfoHeader *headerView;
    
    UIImageView *BarView;
    UILabel *nav_title;
    UIView *line_bar;
}

@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) IMlogin * imlogin;
@property (nonatomic,assign) BOOL  hasSPTabBarViewController;
@property(nonatomic,assign) BOOL isHasNewContract;
@end

@implementation MyInfoViewController

-(void)dealloc{
    [_theTableView removeTwitterCoverView];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"resgister_succeed" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNCAutoLoginedUpdatePersonalInfo object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNCChangePasswordSuccess object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"IMNewMessage" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cancelNewMessageRedDot" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"IMLostConnenction" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AppLoginOut" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.hasSPTabBarViewController==YES) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else
    [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.hasSPTabBarViewController=NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //检查登录是否失效
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
    [bodyDict setObject:@"1" forKey:@"currentPage"];
    [bodyDict setObject:@"1" forKey:@"requestRow"];
    [bodyDict setObject:@(1) forKey:@"siteDiaryType"];
    [bodyDict setObject:@(7)forKey:@"roleId"];
    
    [ZLNetWorkRequest sendRequestToServerUrl:^(id responseObject) {//用查看我的日记接口检查登录是否失效
        if (kResCode1==102881) {//登录状态
            
               } else if(kResCode1==102889){//系统出错
              }else{//登录失效
                  [util utopLoginOut];
        }
        
    } failedBlock:^(id responseObject) {
      
    } RequestUrl: normalUrlStr CmdID:@"ID0288" PostDict:bodyDict RequestType:@"GET"];
    


    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent = YES;

    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:YES animated:NO];
    
    //[self.tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);//修复点击其余选项卡导致关于cell不能点击的问题 huangrun
   
    [self configParallaxHeaderView];
    

}

-(void)PressBarItemRight{
//    [[SPUtil sharedInstance] setWaitingIndicatorShown:YES withKey:@"waiting"];
    
//    if (isIMLoginOutByOthers==YES) {
//        [util loginViewShowWithDelegate:self];
//        return;
//    }

    IMlogin * imLogin  =[self imLogin];
    [imLogin tryLoginIM]; 


    
    
//    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]){
//        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:Is_NewMessage];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        [_rightButton setImage:[UIImage imageNamed:@"ic_xiaoxi"] forState:UIControlStateNormal];
//        MainMessageViewController *mainMsgVC = [[MainMessageViewController alloc]init];
//        mainMsgVC.hidesBottomBarWhenPushed = YES;
////        mainMsgVC.fromVCStr = @"homeV C";
//        [self.navigationController pushViewController:mainMsgVC animated:YES];
//    }
//    else{
//        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
//        login.delegate=self;
//        self.view.tag=1;
//        [login show];
//    }
}

-(IMlogin*)imLogin{
    if (!_imlogin) {
        _imlogin = [[IMlogin alloc]init];
        _imlogin.delegate =self;
    }
    
    return _imlogin;
}

#pragma mark -IMLoginDelegate
-(void)pushToIMVC:(UIViewController *)IMVC{

        IMVC.hidesBottomBarWhenPushed =YES;
//        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
//        [appDelegate.nav setNavigationBarHidden:YES animated:NO];
        //    if([IMVC isKindOfClass:[YWConversationViewController class]])
        //     self.navigationController.navigationBarHidden = NO;
//       self.navigationController.navigationBarHidden=YES;
//        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController pushViewController:IMVC animated:YES];
    if ([IMVC isKindOfClass:[SPTabBarViewController class]]) {
        self.hasSPTabBarViewController = YES;
    }
    
    
//        [self presentViewController:IMVC animated:YES completion:nil];
        NSLog(@"self.navigationcontroller================%@",self.navigationController);
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registersucceed:) name:@"resgister_succeed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoLogined:) name:kNCAutoLoginedUpdatePersonalInfo object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangePassWordAciton:) name:kNCChangePasswordSuccess object:nil];
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 49) style:UITableViewStyleGrouped];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_theTableView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.frame = CGRectMake(kMainScreenWidth - 50, 12, _activityIndicatorView.bounds.size.width, _activityIndicatorView.bounds.size.height);
    

    [self createNavgationBar];
    
    if(!_rightButton) _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setFrame:CGRectMake(kMainScreenWidth-90, 20, 80, 40)];

    
    [_rightButton setImage:[UIImage imageNamed:@"ic_im_w"] forState:UIControlStateNormal];
    _rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [_rightButton addTarget:self
                     action:@selector(PressBarItemRight)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNewMessageRedDot) name:@"IMNewMessage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelNewMessageRedDot) name:@"cancelNewMessageRedDot" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginOutkWhenLostIMConenction) name:@"IMLostConnenction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeUserLogo) name:@"AppLoginOut" object:nil];
    

    
}

#pragma mark -
#pragma mark - 检查消息标识

-(void)showNewMessageRedDot{

  [_rightButton setImage:[UIImage imageNamed:@"ic_im_w_dian"] forState:UIControlStateNormal];


}

-(void)cancelNewMessageRedDot{

  [_rightButton setImage:[UIImage imageNamed:@"ic_im_w"] forState:UIControlStateNormal];

}

-(void)removeUserLogo{
  headerView.userLogo.image = [UIImage imageNamed:@"ic_me_touxiang"];
}

//检查消息标识
-(void)requestmessge{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:Is_NewMessage]isEqualToString:@"yes"]){
        [self checkMessage];
    }
}

//检查是否有新信息标识
-(void)checkMessage{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *string_date=@"";
        if([[[NSUserDefaults standardUserDefaults] objectForKey:Message_date] length])
            string_date = [[NSUserDefaults standardUserDefaults] objectForKey:Message_date];
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0005\",\"deviceType\":\"ios\",\"token\":\"\",\"userID\":\"\",\"cityCode\":\"%@\"}&body={\"timeStamp\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],string_date];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"消息标识返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (code==10051) {
                        if([[jsonDict objectForKey:@"noticeSign"] integerValue]==1){
                            [_rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:Is_NewMessage];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                        }
                    }
                    else {
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



-(void)ChangePassWordAciton:(NSNotification *)sender{
    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    login.delegate=self;
    [login show];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   // UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        BarView.alpha=alpha;
        nav_title.textColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
        line_bar.backgroundColor=[UIColor colorWithHexString:@"#838B8B" alpha:alpha*0.5];
    } else {
        BarView.alpha=0;
        nav_title.textColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        line_bar.backgroundColor=[UIColor colorWithHexString:@"#838B8B" alpha:0];
    }
    if (BarView.alpha ==1) {
        _rightButton.alpha = 1;
    }
}

-(void)createNavgationBar{
    BarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    [BarView setImageToBlur:[util imageWithColor:[UIColor whiteColor]]
                 blurRadius:kLBBlurredImageDefaultBlurRadius
            completionBlock:^(NSError *error){
            }];
    BarView.alpha=0;
    [self.view addSubview:BarView];

    nav_title = [[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-80)/2, 30, 80, 20)];
    nav_title.textColor = [UIColor clearColor];
    nav_title.font = [UIFont systemFontOfSize:20];
    nav_title.textAlignment=NSTextAlignmentCenter;
    nav_title.text = @"我";
    [BarView addSubview:nav_title];
    
    line_bar=[[UIView alloc]initWithFrame:CGRectMake(0, 63.5, kMainScreenWidth, 0.5)];
    line_bar.backgroundColor=[UIColor clearColor];
    [BarView addSubview:line_bar];
}

-(void)LoginOutkWhenLostIMConenction{
    [self performSelector:@selector(loginOutUtop) withObject:nil afterDelay:2];
   
}
-(void)loginOutUtop{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]) {
        [util utopLoginOut];
    }

}

//判断是否有新合同
-(void)judgeIsHasNewContract{

    _isHasNewContract=NO;
    NSString *string_token=@"";
    NSString *string_userid=@"";
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length] && [[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
        string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
        string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
        [headerDict setObject:@"CMS0127" forKey:@"cmdID"];
        [headerDict setObject:string_token forKey:@"token"];
        [headerDict setObject:[NSNumber numberWithInteger:[[NSString stringWithFormat:@"%@",string_userid] integerValue]] forKey:@"userId"];
        [headerDict setObject:@"iOS" forKey:@"deviceType"];
        [headerDict setObject:@(7) forKey:@"roleType"];
        [headerDict setObject:@"idas" forKey:@"from"];
        [headerDict setObject:[OpenUDID value] forKey:@"uniquelyNo"];
        NSString *header_str = [headerDict JSONString];
        
        NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc]init];
        
        NSString *body_str = [bodyDict JSONString];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:header_str forKey:@"header"];
        [parameters setObject:body_str forKey:@"body"];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
        manager.requestSerializer.timeoutInterval=15.0;
        
        NSString *url=[NSString stringWithFormat:@"%@/cms/dispatch/dispatch.action",kSCMSPrefix];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求成功返回结果=====++++++++++++：%@",responseObject);
            if ([responseObject objectForKey:@"haveContract"]) {
                _isHasNewContract =[[responseObject objectForKey:@"haveContract"]integerValue];
                    if (_isHasNewContract==YES) {//有新合同
                        WTBWebViewViewController * mySeverOrderWebViewController = [[WTBWebViewViewController alloc]init];;
                        NSString * userId = [[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
                        NSString * userToken = [[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
                        if (userId&&userToken) {
                            NSString * url =[NSString stringWithFormat:@"%@/list.html?from=idas&userId=%@&token=%@&roleType=7",kCMSPrefix,userId,userToken];
                    
                            mySeverOrderWebViewController.requesUrl =url;
                            mySeverOrderWebViewController.controllerHeight =kMainScreenHeight;
                            
                            [self.navigationController pushViewController:mySeverOrderWebViewController animated:YES];
                        }
                    }else{//没有新合同
                        MySeverOrderViewController * mySeverOrderVC = [[MySeverOrderViewController alloc]init];
                        mySeverOrderVC.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:mySeverOrderVC animated:YES];
                        
                    }

            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败返回结果======++++++++++++：%@",error);
            
        }];
    }

   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDatasource and delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section==0) return 64;
    else return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 1;
    } else if(section ==2){
        return 3;
    }else if(section==3){
        return 1;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid=@"mycellid";
    EmptyClearTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"EmptyClearTableViewCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if(indexPath.section==0){
    
        UIButton *collect_btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth/3,Firth_Cell_Button_Height)];
        [collect_btn addTarget:self action:@selector(PressMyCollect) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:collect_btn];
        
        UIImageView *collect_image=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth/3-Firth_Cell_Button_ImageView_Height)/2, 6, Firth_Cell_Button_ImageView_Height,Firth_Cell_Button_ImageView_Height)];
        collect_image.image=[UIImage imageNamed:@"ic_wodeshoucang"];
        collect_image.contentMode=UIViewContentModeScaleAspectFit;
        collect_image.clipsToBounds=YES;
        [collect_btn addSubview:collect_image];
        
        //        UILabel *collect_lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(collect_image.frame)+10, 20, 80, 20)];
        UILabel *collect_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, Space_Image_To_Label_In_Button, kMainScreenWidth/3, 20)];
        
        collect_lab.textColor = [UIColor blackColor];
        collect_lab.font = Firth_Cell_Button_Label_Font;
        collect_lab.text = @"我的收藏";
        collect_lab.textAlignment =NSTextAlignmentCenter;
        [collect_btn addSubview:collect_lab];
        
        
        UIButton *zhanghu_btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth/3, 0, kMainScreenWidth/3, Firth_Cell_Button_Height)];
        [zhanghu_btn addTarget:self action:@selector(PressMyZhanghu) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:zhanghu_btn];
        
        UIImageView *zhanghu_image=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth/3-Firth_Cell_Button_ImageView_Height)/2, 6, Firth_Cell_Button_ImageView_Height, Firth_Cell_Button_ImageView_Height)];
        zhanghu_image.image=[UIImage imageNamed:@"ic_wodezhanghu"];
        zhanghu_image.clipsToBounds=YES;
        zhanghu_image.contentMode=UIViewContentModeScaleAspectFit;
        [zhanghu_btn addSubview:zhanghu_image];
        
        //        UILabel *zhaobiao_lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zhaobiao_image.frame)+10, 20, 80, 20)];
        UILabel *zhanghu_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, Space_Image_To_Label_In_Button, kMainScreenWidth/3, 20)];
        zhanghu_lab.textColor = [UIColor blackColor];
        zhanghu_lab.font = Firth_Cell_Button_Label_Font;
        zhanghu_lab.text = @"我的账户";
        zhanghu_lab.textAlignment =NSTextAlignmentCenter;
        [zhanghu_btn addSubview:zhanghu_lab];
        
        UIButton *jifenshangcheng_btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth/3*2, 0, kMainScreenWidth/3, Firth_Cell_Button_Height)];
        [jifenshangcheng_btn addTarget:self action:@selector(PressJiFenShangCheng) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:jifenshangcheng_btn];
        
        UIImageView *jifenshangcheng_image=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth/3-Firth_Cell_Button_ImageView_Height)/2, 6, Firth_Cell_Button_ImageView_Height, Firth_Cell_Button_ImageView_Height)];
        jifenshangcheng_image.image=[UIImage imageNamed:@"ic_jifenshangcheng"];
        jifenshangcheng_image.clipsToBounds=YES;
        jifenshangcheng_image.contentMode=UIViewContentModeScaleAspectFit;
        [jifenshangcheng_btn addSubview:jifenshangcheng_image];
        
        //        UILabel *zhaobiao_lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zhaobiao_image.frame)+10, 20, 80, 20)];
        UILabel *jifen_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, Space_Image_To_Label_In_Button, kMainScreenWidth/3, 20)];
        jifen_lab.textColor = [UIColor blackColor];
        jifen_lab.font = Firth_Cell_Button_Label_Font
        jifen_lab.text = @"积分商城";
        jifen_lab.textAlignment =NSTextAlignmentCenter;
        [jifenshangcheng_btn addSubview:jifen_lab];
        
        
    }
    else{

        NSArray *cellImageArr = @[@[@"ic_wo_fuwudingdan"],@[@"ic_wodeyouhuijuan",@"ic_wodeweizhi",@"ic_tizi"],@[@"ic_shezhi"],@[@"ic_gengduoapp",@"ic_qq",@"ic_qq"]];
        NSArray *cellNameArr = @[@[@"我的服务订单"],@[@"优惠劵",@"收货地址",@"我的帖子"],@[@"设置"],@[@"更多装修资源",@"屋托邦装修咨询群",@"屋托邦商务合作群"]];
        
        cell.imageView.image = [UIImage imageNamed:[[cellImageArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row]];
        cell.textLabel.text = [[cellNameArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row];
        cell.textLabel.font = SecondSection_Cell_LabelText_Font;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//        
//        if (indexPath.section == 2) {
//            if (indexPath.row == 0) {
//                cell.tag=101;
//                //获取缓存大小
//                NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//                CGFloat catchSizeFloat = [self folderSizeAtPath:cachePath];
//                
//                UILabel *huanc_lab = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth- 110, 15, 80, 20)];
//                huanc_lab.tag=1000;
//                huanc_lab.textColor = kThemeColor;
//                huanc_lab.font = [UIFont systemFontOfSize:16];
//                huanc_lab.textAlignment=NSTextAlignmentRight;
//                huanc_lab.text = [NSString stringWithFormat:@"%.2fM",catchSizeFloat];
//                [cell addSubview:huanc_lab];
//            }
//        }
//        else
            if (indexPath.section == 3) {
//            UILabel *detailTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 5, kMainScreenWidth - 130 - 20, 40)];
//            detailTextLabel.textColor = [UIColor grayColor];
//            detailTextLabel.font = [UIFont systemFontOfSize:13];
//            detailTextLabel.text = @"点击下载APP,免费入驻，轻松赚钱";
//            detailTextLabel.numberOfLines=2;
//            [cell.contentView addSubview:detailTextLabel];
        }
//        }else if (indexPath.section ==0){
//            UIButton *todobtn =[UIButton buttonWithType:UIButtonTypeCustom];
//            [todobtn setTitle:@"今日代办" forState:UIControlStateNormal];
//            [todobtn setTitle:@"今日代办" forState:UIControlStateHighlighted];
//            [todobtn setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateNormal];
//            todobtn.frame=CGRectMake(0, 0, kMainScreenWidth/2, 44);
//            [todobtn addTarget:self action:@selector(PressMyToDo) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:todobtn];
//            
//            UIButton *mailbtn =[UIButton buttonWithType:UIButtonTypeCustom];
//            [mailbtn setTitle:@"信箱" forState:UIControlStateNormal];
//            [mailbtn setTitle:@"信箱" forState:UIControlStateHighlighted];
//            [mailbtn setTitleColor:[UIColor colorWithHexString:@"#575757"] forState:UIControlStateNormal];
//            mailbtn.frame=CGRectMake(kMainScreenWidth/2, 0, kMainScreenWidth/2, 44);
//            [mailbtn addTarget:self action:@selector(PressMyMail) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:mailbtn];
////            [mailbtn setBackgroundColor:[UIColor redColor]];
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
    
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==1) {
         //检测是否登陆了
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]){
            [self loginViewShow];
            return ;
        }
        if (indexPath.row==0) {
            [self judgeIsHasNewContract];
            
            
        }else {
//            MyGoodsOrderViewController * goodsOrderVC = [[MyGoodsOrderViewController alloc]init];
//            goodsOrderVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:goodsOrderVC animated:YES];
        }
        
        
    }else if (indexPath.section == 2) {
        //检测是否登陆了
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]) {
            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
            login.delegate=self;
            [login show];
            return;
        }
        if (indexPath.row == 0) {
            [self PressMyYouHui];
        }
        else if (indexPath.row==1){
            AddressManageViewController *addressManageVC = [[AddressManageViewController alloc]init];
            addressManageVC.fromStr = @"myInfoVC";
            addressManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressManageVC animated:YES];
        }
        else{
            [self PressMyRiJ];
            
        }
    }
    else if (indexPath.section == 3) {
        SettingViewController * settingVC = [[SettingViewController alloc]init];
        settingVC.hidesBottomBarWhenPushed  = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    else if(indexPath.section==4) {
        if (indexPath.row ==0) {
            MoreResourcesViewController *more =[[MoreResourcesViewController alloc] init];
            more.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:more animated:YES];
        }else if(indexPath.row==1)
        {
             [self joinGroup:@"138386598" key:@"4ed5972feba820ff1b07005e3d523516129cc84f76daa12f8a54721bd4c83f3c"];
        }else {
        
            [self joinGroup:@"378150657" key:@"7ddf4777b2bf711ab8bc976a9f89b39428d76915efaa6c35b6c708f8bf041217"];
        
        }
        
//        [savelogObj saveLog:@"下载卖家版" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:31];
//        [self downloadUTopSP];
    }
}
- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", groupUin,key];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}


#pragma mark -Btn

-(void)PressMyZhaobiao{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]) {
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
    else{
        DecorationInfoViewController *infovc=[[DecorationInfoViewController alloc]init];
        infovc.fromType=@"MyZhaoBiao";
        infovc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infovc animated:YES];
    }
}
-(void)PressMyRiJ{
    
        IDIAI3DiaryViewController *supervisorVC = [[IDIAI3DiaryViewController alloc]init];
        supervisorVC.title =@"我的帖子";
        supervisorVC.ismyDiary =YES;
        supervisorVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:supervisorVC animated:YES];
    
}
-(void)PressMyZhanghu{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]){
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }else{
        IDIAI3MyAccountViewController *myaccount =[[IDIAI3MyAccountViewController alloc] init];
        myaccount.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myaccount animated:YES];
    }
}

-(void)PressJiFenShangCheng{
   
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]){
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }else{
         PointMallViewController * PointVC = [[PointMallViewController alloc]init];
         PointVC.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:PointVC animated:YES];
    }

}

-(void)PressMyYouHui{
    MyPreferentialViewController *myPreferential = [[MyPreferentialViewController alloc]init];
    myPreferential.hidesBottomBarWhenPushed = YES;
    myPreferential.title =@"我的优惠";
    [self.navigationController pushViewController:myPreferential animated:YES];
}
-(void)PressMyCollect{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:User_Token]) {
        CollectionViewController *myCollectVC = [[CollectionViewController alloc]init];
        myCollectVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myCollectVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
}
-(void)PressMyToDo{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:User_Token]) {
        MyToDoViewController *myToDoVC = [[MyToDoViewController alloc]init];
        myToDoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myToDoVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
}
-(void)PressMyMail{
    MyMailMainViewController *myOrderVC = [[MyMailMainViewController alloc]init];
    myOrderVC.hidesBottomBarWhenPushed=YES;
//    myOrderVC.fromIndex =1;
//    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.nav setNavigationBarHidden:NO animated:YES];
//    [delegate.nav pushViewController:myOrderVC animated:YES];
    [self.navigationController pushViewController:myOrderVC animated:YES];

}
- (void)clickPersonalInfoBtn:(id)sender {
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]){
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];

    }
    else{
        PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc]init];
        personalInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personalInfoVC animated:YES];
    }
}
-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 0.0 ];
    rotationAnimation.duration = 0.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    
    [layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}
#pragma mark - loginVC delegate
-(void)logged:(NSDictionary *)dict{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (void)showActivityIndicatorView {
    UITableViewCell *cell = (UITableViewCell *)[self.view viewWithTag:101];
    UILabel *lab_ = (UILabel *)[cell viewWithTag:1000];
    lab_.text = @"";
    [cell addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
}

//裁剪为圆形图片
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


////手机读取头像
//-(UIImage *)ReadPhoto{
//    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"user_photo"];
//    UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
//    return imgFromUrl3;
//}

#pragma mark - Header

-(void)configParallaxHeaderView{
    if(!headerView){
        [_theTableView addTwitterCoverWithImage:[UIImage imageNamed:@"bg_wo.png"] withTopView:nil];
        headerView = [[MyInfoHeader alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth*8/15-2)];
        _theTableView.tableHeaderView=headerView;
    }
    
    //未登录和已登录的不同显示
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]) {
        headerView.userLogo.image = [UIImage imageNamed:@"ic_me_touxiang"];
        headerView.userName.text = @"登录/注册";
//        headerView.userAddress.text = @"请登录，开启你的装修之旅";
    } else {
      NSString  * url  = [[NSUserDefaults standardUserDefaults]objectForKey:User_logo];
        __weak typeof(self) weaself =self;
        [headerView.userLogo sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ic_me_touxiang"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                 [headerView.userLogo  setImage:[self circleImage:image withParam:1.0]];
            }
            if (!imageURL) {
                [headerView.userLogo setImage:[weaself circleImage:[UIImage imageNamed:@"ic_me_touxiang"] withParam:1.0]];
            }
        }];

        NSString *nicknameStr;
        if ([[NSUserDefaults standardUserDefaults]objectForKey:User_nickName]) {
            nicknameStr = [[NSUserDefaults standardUserDefaults]objectForKey:User_nickName];
        } else {
            nicknameStr = [[NSUserDefaults standardUserDefaults]objectForKey:User_Name];
        }
        headerView.userName.text = nicknameStr;
        
//        NSString *addressStr;
//        if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss]) {
//            addressStr = [[NSUserDefaults standardUserDefaults]objectForKey:User_Addrss];
//        } else {
//            addressStr = @"请完善资料，开启你的装修之旅";
//        }
//        headerView.userAddress.text = addressStr;
    }
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPersonalInfoBtn:)];
    [headerView addGestureRecognizer:tapGR];
}

#pragma mark -Notify

-(void)registersucceed:(NSNotification *)notification {
    //自动登录
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:User_Name] length] && [[[NSUserDefaults standardUserDefaults]objectForKey:User_Password] length]) {
        [AutomaticLogin Automaticlogin:self];
    }
}

- (void)autoLogined:(NSNotification *)notification {
     [self configParallaxHeaderView];
}

//添加小红点 huangrun 取消了
//- (void)addSmallRedDotToTabBar:(UITableViewCell *)cell {
//    UIImageView *dotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dian.png"]];
//    dotImage.backgroundColor = [UIColor clearColor];
//    dotImage.tag = 1001;
//    CGRect cellFrame = CGRectMake(0, 0, kMainScreenWidth, 44);
//    CGFloat x = ceilf(0.11 * cellFrame.size.width);
//    CGFloat y = ceilf(0.2 * cellFrame.size.height);
//    dotImage.frame = CGRectMake(x, y, 8, 8);
//    [cell addSubview:dotImage];
//}

#pragma mark - 下载卖家版
//- (void)downloadUTopSP {
//    NSString *sPappIDStr = @"967239506";
//    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", sPappIDStr];
//        NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
//        [[UIApplication sharedApplication] openURL:iTunesURL];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    [self configParallaxHeaderView];
}

//-(void)pushToConversitonListViewControllerWithbePushedViewController:(UIViewController *)viewController{
//    [self.navigationController pushViewController:viewController animated:YES];
//
//}

@end
