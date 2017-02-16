//
//  DecorateInfoVC.m
//  IDIAI
//
//  Created by iMac on 14-7-16.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DecorateInfoVC.h"
#import "HexColor.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "CircleProgressHUD.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "TLToast.h"
#import "SVProgressHUD.h"
#import "savelogObj.h"
#import "ACNavBarDrawer.h"
#import "util.h"
#import "IDIAIAppDelegate.h"
#import "LoginView.h"
@interface DecorateInfoVC ()<UIWebViewDelegate, ACNavBarDrawerDelegate>
{
    CircleProgressHUD *phud;
    UIActivityIndicatorView *activ;
    
    /** 导航栏 按钮 加号 图片 */
    UIImageView *_navIV;
    
    /** 是否已打开抽屉 */
    BOOL _isOpen;
    
    /** 抽屉视图 */
    ACNavBarDrawer *_drawerView;
}
@property (nonatomic,strong) UIButton *btn_shouc;

@end

@implementation DecorateInfoVC
@synthesize obj;

-(void)dealloc{
    [super dealloc];
    [activ release];
    activ = nil;
    [imageview_bg release];
    [label_bg release];
    imageview_bg = nil;
    label_bg = nil;
    [phud release];
    phud=nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:kColorWithRGB(249, 249, 250)];
    
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    
    //修改navBar字体大小文字颜色
    NSDictionary *attris = @{ NSFontAttributeName:[UIFont systemFontOfSize:19],
                              NSForegroundColorAttributeName:[UIColor blackColor] };
    [self.navigationController.navigationBar setTitleTextAttributes:attris];
    
    // 导航栏弹出框 消失时 关闭抽屉
    _isOpen = NO;
    [_drawerView closeNavBarDrawer];
    
    // 旋回加号图片
    [self rotatePlusIV];
}

-(void)backTouched:(UIButton *)btn{
    [phud hide];
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title = @"装修知识详情";

    [savelogObj saveLog:@"用户查看知识详情" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:14];
    
    [self loadWebview];
    
    [self loadImageviewBG];
    
    //导航栏右边按钮 两个
    self.socialButton=[[UIButton alloc]initWithFrame:CGRectMake(50, 5, 40, 40)];
    [self.socialButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.socialButton setImage:[UIImage imageNamed:@"ic_fenxiang_2"] forState:UIControlStateNormal];
    self.socialButton.selected=NO;
//        _navIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_fenxiang_2.png"]];
//    _navIV.frame = CGRectMake(0, 0, 30, 30);
//    [self.socialButton addSubview:_navIV];
    [self.view addSubview:self.socialButton];
    
    
//    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* doc_path_ = [path_ objectAtIndex:0];
//    NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:@"MyknowledgeCollect.plist"];
//    NSMutableArray *Arr_=[NSMutableArray arrayWithContentsOfFile:_filename_];
//    if (!Arr_) {
//        Arr_=[NSMutableArray arrayWithCapacity:0];
//    }
    self.btn_shouc = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_shouc.frame=CGRectMake(10, 5, 40, 40);
//    if([Arr_ count]){
//        for(NSDictionary *dict in Arr_){
//            if([[dict objectForKey:@"knowledgeID"] integerValue]==[obj.objId integerValue]){
//                [self.btn_shouc setImage:[UIImage imageNamed:@"ic_shoucang_2"] forState:UIControlStateNormal];
//                self.btn_shouc.selected=YES;
//                break;
//            }
//            else{
//                [self.btn_shouc setImage:[UIImage imageNamed:@"ic_shoucang_nor_2"] forState:UIControlStateNormal];
//                self.btn_shouc.selected=NO;
//            }
//        }
//    }
//    else{
//        [self.btn_shouc setImage:[UIImage imageNamed:@"ic_shoucang_nor_2"] forState:UIControlStateNormal];
//        self.btn_shouc.selected=NO;
//    }
    if ([self.obj.objId intValue] ==[self.obj.KnowledgeID intValue]) {
        [self.btn_shouc setImage:[UIImage imageNamed:@"ic_shoucang_2"] forState:UIControlStateNormal];
        self.btn_shouc.selected=YES;
    }else{
        [self.btn_shouc setImage:[UIImage imageNamed:@"ic_shoucang_nor_2"] forState:UIControlStateNormal];
        self.btn_shouc.selected=NO;
    }
    [self.btn_shouc addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 50)];
    [rightView addSubview:self.socialButton];
    [rightView addSubview:self.btn_shouc];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    //导航栏弹出框
    //*********************************************************************************************;
    
    
    //** 抽屉 *******************************************************************************
    
    //-- 按钮信息 -------------------------------------------------------------------------------
    // 就不建数据对象了，第一个为图片名、第二个为按钮名
    NSArray *item_01 = [NSArray arrayWithObjects:@"ic_weixin", @"微信好友", nil];
    NSArray *item_02 = [NSArray arrayWithObjects:@"ic_pengyouquan", @"朋友圈", nil];
    NSArray *item_03 = [NSArray arrayWithObjects:@"ic_xinlangweibo", @"微博", nil];
    NSArray *item_04 = [NSArray arrayWithObjects:@"ic_qqkongjian", @"空间", nil];
    
    // 最好是 2-5 个按钮，1个很2，5个以上很丑
    NSArray *allItems = [NSArray arrayWithObjects:item_01,item_02,item_03,item_04, nil];
    
    _drawerView = [[ACNavBarDrawer alloc] initWithView:self.view andItemInfoArray:allItems];
    _drawerView.delegate = self;
}

-(void)loadWebview{

    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth, kMainScreenHeight - 57)];
    webview.backgroundColor=[UIColor whiteColor];
    webview.delegate=self;
    //webview.scalesPageToFit=YES;
    [self.view addSubview:webview];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:obj.knowledgeInfoPath]]];
    [webview release];
    
    activ=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activ.center= CGPointMake(kMainScreenWidth/2, kMainScreenHeight/2);//只能设置中心，不能设置大小
    [self.view addSubview:activ];
    [activ setHidesWhenStopped:YES]; //当旋转结束时隐藏
}

//UTF8编码
-(NSString*)UrlEncodedString:(NSString*)sourceText
{
    NSString *result = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)sourceText, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
    return result;
}

#pragma mark -
#pragma mark -UIWebviewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    [activ startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    [activ stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [activ stopAnimating];
    imageview_bg.hidden=NO;
    label_bg.hidden = NO;
}

-(void)buttonPressed:(UIButton *)btn{

    // 如果是关，则开，反之亦然
    if (_drawerView.isOpen == NO)
    {
        [_drawerView openNavBarDrawer];
    }
    else
    {
        [_drawerView closeNavBarDrawer];
    }
    
    [self rotatePlusIV];
    
}

#pragma mark -
#pragma mark - Weixin related
- (void)sendTextContentToWX:(NSString *)nsText Type:(NSInteger) type {
    
    //分享图文结合
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =obj.knowledgeTitle;
    message.description =nsText;
    if(obj.knowledgeLogoPath==nil)
        [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@" "]]]];
    else
        [message setThumbImage:[self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj.knowledgeLogoPath]]] scaleToSize:CGSizeMake(100, 100)]];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl =obj.knowledgeInfoPath;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if(type==1) req.scene = WXSceneSession;   //微信好友
    else req.scene = WXSceneTimeline;         //朋友圈
    [WXApi sendReq:req];
}

#pragma mark -
#pragma mark - QQorZone related
-(void)sendTextContentToQQorZone:(NSString *)nsText{
    QQApiNewsObject *txtObj =[QQApiNewsObject objectWithURL:[NSURL URLWithString:obj.knowledgeInfoPath] title:obj.knowledgeTitle description:nsText previewImageURL:[NSURL URLWithString:obj.knowledgeLogoPath]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    
    [QQApiInterface SendReqToQZone:req];
}

#pragma mark -
#pragma mark - Sinawb related
- (void)sendTextContentToWB:(NSString *)nsText {
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
    request.userInfo = @{@"knowledge": @"messagetitle",};
    //request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}
- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = obj.knowledgeDescription;
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID =[NSString stringWithFormat:@"%@", obj.KnowledgeID];
    webpage.title = obj.knowledgeTitle;
    webpage.description = obj.knowledgeDescription;
//    webpage.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.knowledgeLogoPath]];
    webpage.thumbnailData = UIImageJPEGRepresentation([self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj.knowledgeLogoPath]]]scaleToSize:CGSizeMake(100, 100)],0.1);
    
    webpage.webpageUrl =obj.knowledgeInfoPath;
    message.mediaObject = webpage;
    
    return message;
}

//收藏知识
-(void)pressbtn:(UIButton *)btn{
    if(btn.selected==NO){
        [savelogObj saveLog:@"收藏--知识" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:10];
        [self collectionAction:btn];
//        [self.btn_shouc setImage:[UIImage imageNamed:@"ic_shoucang_2"] forState:UIControlStateNormal];
//        self.btn_shouc.selected=YES;
//
//        [SVProgressHUD showSuccessWithStatus:@"收藏成功" duration:1.0];
//        
//        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString* doc_path = [path objectAtIndex:0];
//        NSString* _filename = [doc_path stringByAppendingPathComponent:@"MyknowledgeCollect.plist"];
//        NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename];
//        if (!arr_) {
//            arr_=[NSMutableArray arrayWithCapacity:0];
//        }
//        NSMutableDictionary *dict_=[[NSMutableDictionary alloc]initWithCapacity:0];
//        if(obj.KnowledgeID!=nil)
//            [dict_ setObject:obj.KnowledgeID forKey:@"knowledgeID"];
//        if(obj.knowledgeLogoPath!=nil)
//            [dict_ setObject:obj.knowledgeTitle forKey:@"knowledgeTitle"];
//        if(obj.knowledgeLogoPath!=nil)
//            [dict_ setObject:obj.knowledgeDescription forKey:@"knowledgeDescription"];
//        if(obj.knowledgeLogoPath!=nil)
//            [dict_ setObject:obj.knowledgeLogoPath forKey:@"knowledgeLogoPath"];
//        if(obj.knowledgeLogoPath!=nil)
//            [dict_ setObject:obj.knowledgeInfoPath forKey:@"knowledgeInfoPath"];
//        
//        [arr_ addObject:dict_];
//        [arr_ writeToFile:_filename atomically:NO];
        
    }
    else{
        [self collectionAction:btn];
//        [self.btn_shouc setImage:[UIImage imageNamed:@"ic_shoucang_nor_2"] forState:UIControlStateNormal];
//        self.btn_shouc.selected=NO;
//        
//        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功" duration:1.0];
//        
//        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString* doc_path = [path objectAtIndex:0];
//        NSString* _filename = [doc_path stringByAppendingPathComponent:@"MyknowledgeCollect.plist"];
//        NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename];
//        if (!arr_) {
//            arr_=[NSMutableArray arrayWithCapacity:0];
//        }
//        for(NSDictionary *dict in arr_){
//            if([[dict objectForKey:@"knowledgeID"] integerValue]==[obj.KnowledgeID integerValue]){
//                [arr_ removeObject:dict];
//                break;
//            }
//            else{
//                continue;
//            }
//        }
//        [arr_ writeToFile:_filename atomically:NO];
    }
}
-(void)collectionAction:(UIButton *)iscollect{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
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
        
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0292" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        
        NSDictionary *bodyDic = @{@"objId":[NSNumber numberWithInt:[self.obj.KnowledgeID intValue]],@"isCollection":[NSNumber numberWithInt:!iscollect.selected],@"objType":[NSNumber numberWithInt:3]};
        NSString *string02=[bodyDic JSONString];
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setTimeOutSeconds:15];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                // NSLog(@"login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 102921) {
                        [self stopRequest];
                        if (!iscollect.selected==YES) {
                            [TLToast showWithText:@"收藏成功"];
                            [iscollect setImage:[UIImage imageNamed:@"ic_shoucang_2"] forState:UIControlStateNormal];
                            self.btn_shouc.selected=YES;
                        }else{
                            [TLToast showWithText:@"取消收藏成功"];
                            [iscollect setImage:[UIImage imageNamed:@"ic_shoucang_nor_2"] forState:UIControlStateNormal];
                            self.btn_shouc.selected=NO;
                        }
                        
                    } else {
                        [self stopRequest];
                        if (!iscollect.selected==YES) {
                            [TLToast showWithText:@"收藏失败"];
                        }else{
                            [TLToast showWithText:@"取消收藏失败"];
                        }
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  if (!iscollect.selected==YES) {
                                      [TLToast showWithText:@"收藏失败"];
                                  }else{
                                      [TLToast showWithText:@"取消收藏失败"];
                                  }
                              });
                          }
                               method:url postDict:post];
    });
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

#pragma mark - Rotate _plusIV

- (void)rotatePlusIV
{
    // 旋转加号按钮 需求不需要旋转 huangrun
//    float angle = _drawerView.isOpen ? -M_PI_4 : 0.0f;
//    [UIView animateWithDuration:0.2f animations:^{
//        _navIV.transform = CGAffineTransformMakeRotation(angle);
//    }];
}

#pragma mark - ACNavBarDrawerDelegate

-(void)theBtnPressed:(UIButton *)theBtn
{
    NSInteger btnTag = theBtn.tag;
    NSInteger btnNumber = btnTag + 1;
    
    switch (theBtn.tag)
    {
        case 0:
        {
            if([WXApi isWXAppInstalled]) {
                [self sendTextContentToWX:obj.knowledgeDescription Type:1];
            } else {
                [TLToast showWithText:@"请先安装微信客户端" bottomOffset:220.0 duration:1.5];
            }
        }
            break;
        case 1:
        {
            if([WXApi isWXAppInstalled]) {
                [self sendTextContentToWX:obj.knowledgeDescription Type:2];
            } else {
                [TLToast showWithText:@"请先安装微信客户端" bottomOffset:220.0 duration:1.5];
            }
        }
            break;
        case 2:
        {
            if([WeiboSDK isWeiboAppInstalled]) {
                [self sendTextContentToWB:obj.knowledgeDescription];
            } else {
                [TLToast showWithText:@"请先安装新浪微博客户端" bottomOffset:220.0 duration:1.5];
            }
        }
            break;
        case 3:
        {
            if([QQApiInterface isQQInstalled]) {
                [self sendTextContentToQQorZone:obj.knowledgeDescription];
            } else {
                [TLToast showWithText:@"请先安装手机QQ客户端" bottomOffset:220.0 duration:1.5];
            }
        }
            break;
            
        default:
            break;
    }
    // 点完按钮，旋回加号图片
    [self rotatePlusIV];
}

-(void)theBGMaskTapped
{
    // 触摸背景遮罩时，需要通过回调，旋回加号图片
    [self rotatePlusIV];
}


-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

@end
