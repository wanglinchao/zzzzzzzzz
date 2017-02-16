//
//  IDIAI3EngineerSupportViewController.m
//  IDIAI
//
//  Created by iMac on 16/2/22.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3EngineerSupportViewController.h"
#import "IDIAI3EngineerSupportControlViewController.h"
#import "SharePcitureView.h"
#import "TLToast.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "CustomProvinceCApicker.h"
#import "LoginView.h"
#import "util.h"

@interface IDIAI3EngineerSupportViewController ()<SharePicViewDelegate,UITextFieldDelegate,CustomProvinceCApickerDelegate,UIWebViewDelegate>{
    NSMutableArray *arr_Province; //省市区数组；
    UIScrollView *scr;
}
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UILabel *title_name;
@property (nonatomic,strong) UITextField *tf_Name;
@property (nonatomic,strong) UILabel *title_phone;
@property (nonatomic,strong) UITextField *MobileNumber;
@property (nonatomic,strong) UILabel *title_province;
@property (nonatomic,strong) UIButton *btn_province;
@property (nonatomic,strong) UIButton *btn_phone;
@property (nonatomic,strong) NSString *provinceCode;
@property (nonatomic,strong) UIButton *btn_SMS;
@property (nonatomic,strong) NSString *cityCode;
@property (nonatomic,strong) NSString *areaCode;

@property (nonatomic,strong) NSString *provinceName;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *areaName;

@end

@implementation IDIAI3EngineerSupportViewController

-(void)customizeNavigationBar{
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [rightButton setImage:[UIImage imageNamed:@"ic_fenxiang_2"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 35, 0, -10);
    [rightButton addTarget:self
                    action:@selector(shareBtn)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopRequest];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"工程保障";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    [self customizeNavigationBar];
    
    //获取省市区名字
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceName] length]>0) self.provinceName=[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceName];
    else self.provinceName=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_CityName] length]>0) self.cityName=[[NSUserDefaults standardUserDefaults] objectForKey:User_CityName];
    else self.cityName=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaName] length]>0) self.areaName=[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaName];
    else self.areaName=@"";
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceCode] length]>0) self.provinceCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceCode];
    else self.provinceCode=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_CityCode] length]>0) self.cityCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_CityCode];
    else self.cityCode=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaCode] length]>0) self.areaCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaCode];
    else self.areaCode=@"";
    
    if(!arr_Province) arr_Province=[NSMutableArray arrayWithObjects:@[self.provinceName,self.provinceCode],@[self.cityName,self.cityCode],@[self.areaName,self.areaCode],nil];
    
    [self createView];
}

-(void)createView{
//     scr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-50)];
//    [self.view addSubview:scr];
//    
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
//    [scr addGestureRecognizer:tap];
//    

    
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-50)];
    [self.view addSubview:_webView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [_webView addGestureRecognizer:tap];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _webView.scalesPageToFit = YES;
    
    [self addObserverForWebViewContentSize];
    NSURLRequest * req =[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:engineeringManagement]];
    [_webView loadRequest:req];
    
    UIButton *btn_phone = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_phone.backgroundColor=[UIColor whiteColor];
    btn_phone.frame = CGRectMake(-1, kMainScreenHeight-64-50, kMainScreenWidth+2, 50);
    btn_phone.layer.borderColor = [[UIColor colorWithHexString:@"#DBDBDB" alpha:0.8] CGColor];
    btn_phone.layer.borderWidth = 1.0f;
    [btn_phone setImage:[UIImage imageNamed:@"btn_dianhua_d"] forState:UIControlStateNormal];
    [btn_phone addTarget:self action:@selector(pressPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_phone];
}

#pragma mark - CustomProvinceCApickerDelegate

-(void)actionSheetProvinceCAPickerView:(CustomProvinceCApicker *)pickerView didSelectTitles:(NSArray *)titles{
    NSMutableString *province_name=[NSMutableString string];
    if([arr_Province count]) [arr_Province removeAllObjects];
    for(int i=0;i<[titles count];i++){
        NSArray *arr=[titles objectAtIndex:i];
        [arr_Province addObject:arr];
        
        if(i==1 && [@"上海市北京市天津市重庆市" rangeOfString:[arr objectAtIndex:0]].length>0)[province_name appendFormat:@"%@",@""]; //获取省市区名字
        else [province_name appendFormat:@"%@",[arr objectAtIndex:0]]; //获取省市区名字
        
        //获取省市区code码
        if(i==0) self.provinceCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
        else if(i==1) self.cityCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
        else if(i==2) self.areaCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
    }
    
    //台湾、澳门、香港没有市区
    if([titles count]==1){
        self.cityCode=@"";
        self.areaCode=@"";
    }
    
    [self.btn_province setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btn_province setTitle:province_name forState:UIControlStateNormal];
}

#pragma mark -UIButton

-(void)pressMore{
    IDIAI3EngineerSupportControlViewController *supVC=[[IDIAI3EngineerSupportControlViewController alloc]init];
    [self.navigationController pushViewController:supVC animated:NO];
}

-(void)PressBtn_Address_SJS{
    [self.view endEditing:YES];
    CustomProvinceCApicker *picker_pro = [[CustomProvinceCApicker alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250)title:@"选择省市区"];
    picker_pro.delegate=self;
    [picker_pro setSelectedTitles:arr_Province animated:YES];
    [picker_pro show];
}

//立即预约
-(void)appointmentImmediately{
    if(self.tf_Name.text.length==0) {
        [TLToast showWithText:@"请填写姓名"];
        return;
    }
    else if (self.MobileNumber.text.length==0){
        [TLToast showWithText:@"请填写电话"];
        return;
    }
    else if (![util checkTel:self.MobileNumber.text]){
        return;
    }
    else if (self.provinceCode.length==0){
        [TLToast showWithText:@"请选择省市区"];
        return;
    }
    
    [self startRequestWithString:@""];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSString *string_token=@"";
        NSString *string_userid=@"";
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        
        NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
        [headerDict setObject:@"ID0260" forKey:@"cmdID"];
        [headerDict setObject:string_token forKey:@"token"];
        [headerDict setObject:string_userid forKey:@"userID"];
        [headerDict setObject:@"ios" forKey:@"deviceType"];
        [headerDict setObject:kCityCode forKey:@"cityCode"];
        NSString *headerStr=[headerDict JSONString];
        
        NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
        [bodyDict setObject:self.tf_Name.text forKey:@"userName"];
        [bodyDict setObject:self.MobileNumber.text forKey:@"userMobile"];
        [bodyDict setObject:self.provinceCode forKey:@"provinceCode"];
        [bodyDict setObject:self.cityCode forKey:@"cityCode"];
        [bodyDict setObject:self.areaCode forKey:@"areaCode"];
        [bodyDict setObject:@(4) forKey:@"serviceType"];
        NSString *bodyStr=[bodyDict JSONString];
        
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:headerStr forKey:@"header"];
        [post setObject:bodyStr forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setTimeOutSeconds:15];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                 NSLog(@"立即预约：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopRequest];
                    if (kResCode == 10002 || kResCode == 10003) {
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        
                            [login show];
                            return;
                    }
                    else if (kResCode==102601){
                        [TLToast showWithText:@"预约成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                       [TLToast showWithText:@"预约失败"];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"预约失败"];
                              });
                          }
                               method:url postDict:post];
    });
}

-(void)pressPhone{
    NSString *serviceNumber = serviceNumber=[@"400-888-7372" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",serviceNumber]]]];
    webview.hidden = YES;
    // Assume we are in a view controller and have access to self.view
    [self.view addSubview:webview];
}

-(void)shareBtn{
    SharePcitureView *shareView=[[SharePcitureView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 100)];
    shareView.delegate=self;
    shareView.isdiary =YES;
    [UIView animateWithDuration:.25 animations:^{
        shareView.frame=CGRectMake(0, kMainScreenHeight-100, kMainScreenWidth, 100);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
    [shareView show];
}

- (void)addObserverForWebViewContentSize{
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
}

- (void)removeObserverForWebViewContentSize{
    
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //在这里边添加你的代码
    [self layoutCell];
    
}

- (void)layoutCell{
    
    //取消监听，因为这里会调整contentSize，避免无限递归
    [self removeObserverForWebViewContentSize];
    
    CGSize contentSize = self.webView.scrollView.contentSize;
    if (!self.title_name) {
            self.title_name=[[UILabel alloc]init];
            self.title_name.textColor=[UIColor grayColor];
            self.title_name.font=[UIFont systemFontOfSize:16];
            self.title_name.textAlignment=NSTextAlignmentLeft;
            self.title_name.text=@"姓 名";
            [self.webView.scrollView addSubview:self.title_name];
    }
    self.title_name.frame = CGRectMake(10, contentSize.height+40, 70, 20);
    if (!self.tf_Name) {
            self.tf_Name=[[UITextField alloc]init];
            self.tf_Name.delegate=self;
            self.tf_Name.borderStyle= UITextBorderStyleRoundedRect;
            //    self.tf_Name.layer.borderColor = [[UIColor colorWithHexString:@"#DBDBDB" alpha:0.8] CGColor];
            //    self.tf_Name.layer.borderWidth = 1.0f;
            self.tf_Name.font=[UIFont systemFontOfSize:15];
            self.tf_Name.textColor=[UIColor darkGrayColor];
            self.tf_Name.textAlignment=NSTextAlignmentLeft;
            self.tf_Name.returnKeyType=UIReturnKeyDone;
            self.tf_Name.placeholder=@"请填写您的姓名";
            if([[[NSUserDefaults standardUserDefaults] objectForKey:User_nickName] length]) self.tf_Name.text=[[NSUserDefaults standardUserDefaults] objectForKey:User_nickName];
            [self.webView.scrollView addSubview:self.tf_Name];
    }
    self.tf_Name.frame = CGRectMake(80,contentSize.height+30, kMainScreenWidth-90, 40);
   
    if (!self.title_phone) {
            self.title_phone = [[UILabel alloc]init];
            self.title_phone.textColor = [UIColor grayColor];
            self.title_phone.font = [UIFont  systemFontOfSize:16];
            self.title_phone.text = @"电话";
            [self.webView.scrollView addSubview:self.title_phone];
    }
    self.title_phone.frame  = CGRectMake(10,CGRectGetMaxY(self.tf_Name.frame)+20, 70, 20);
    if (!self.MobileNumber) {
            self.MobileNumber=[[UITextField alloc]init];
            self.MobileNumber.backgroundColor=[UIColor whiteColor];
            self.MobileNumber.borderStyle= UITextBorderStyleRoundedRect;
            self.MobileNumber.font=[UIFont systemFontOfSize:15];
            self.MobileNumber.textColor=[UIColor darkGrayColor];;
            self.MobileNumber.delegate=self;
            self.MobileNumber.keyboardType = UIKeyboardTypePhonePad;
            self.MobileNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.MobileNumber.placeholder=@"请填写您的联系电话";
            if([[[NSUserDefaults standardUserDefaults] objectForKey:User_Mobile] length]) self.MobileNumber.text=[[NSUserDefaults standardUserDefaults] objectForKey:User_Mobile];
            self.MobileNumber.returnKeyType = UIReturnKeyNext;
            self.MobileNumber.leftViewMode=UITextFieldViewModeAlways;
            self.MobileNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [self.webView.scrollView addSubview:self.MobileNumber];
    }
    self.MobileNumber.frame =CGRectMake(80,CGRectGetMaxY(self.tf_Name.frame)+10, kMainScreenWidth-90, 40);
    
    if (!self.title_province) {
            self.title_province=[[UILabel alloc]init];
            self.title_province.textColor=[UIColor grayColor];
            self.title_province.font=[UIFont systemFontOfSize:16];
            self.title_province.textAlignment=NSTextAlignmentLeft;
            self.title_province.text=@"省市区";
            [self.webView.scrollView addSubview:_title_province];
    }
    self.title_province.frame = CGRectMake(10, CGRectGetMaxY(self.MobileNumber.frame)+20, 70, 20);

    if (!self.btn_province) {
            self.btn_province=[[UIButton alloc]init];
            self.btn_province.layer.borderColor = [[UIColor colorWithHexString:@"#DBDBDB" alpha:0.8] CGColor];
            self.btn_province.layer.borderWidth = 1.0f;
            self.btn_province.layer.cornerRadius=5;
            self.btn_province.layer.masksToBounds=YES;
            [self.btn_province setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            if(self.provinceName.length) [self.btn_province setTitle:[NSString stringWithFormat:@"%@%@%@",self.provinceName,self.cityName,self.areaName] forState:UIControlStateNormal];
            else {
                [self.btn_province setTitleColor:[UIColor colorWithHexString:@"#CFCFCF" alpha:1.0] forState:UIControlStateNormal];
                [self.btn_province setTitle:@"请选择省市区" forState:UIControlStateNormal];
            }
            self.btn_province.titleLabel.font=[UIFont systemFontOfSize:15];
            self.btn_province.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            [self.btn_province setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [self.btn_province addTarget:self action:@selector(PressBtn_Address_SJS) forControlEvents:UIControlEventTouchUpInside];
            [self.webView.scrollView addSubview:self.btn_province];
        
    }
    self.btn_province.frame =CGRectMake(80,CGRectGetMaxY(self.MobileNumber.frame)+10, kMainScreenWidth-90, 40);
    if(!self.btn_SMS) {
            self.btn_SMS =  [UIButton buttonWithType:UIButtonTypeCustom];
            _btn_SMS.titleLabel.font=[UIFont boldSystemFontOfSize:17];
            [_btn_SMS setTitle:@"预约装修 立省50%" forState:UIControlStateNormal];
            //给按钮加一个白色的板框
            _btn_SMS.layer.borderColor = [[UIColor colorWithHexString:@"#EF6562" alpha:1.0] CGColor];
            _btn_SMS.layer.borderWidth = 1.0f;
            //给按钮设置弧度,这里将按钮变成了圆形
            _btn_SMS.layer.cornerRadius = 5.0f;
            _btn_SMS.layer.masksToBounds = YES;
            [_btn_SMS setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             _btn_SMS.backgroundColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
            [_btn_SMS addTarget:self action:@selector(appointmentImmediately) forControlEvents:UIControlEventTouchUpInside];
            [self.webView.scrollView addSubview:_btn_SMS];

    }
    self.btn_SMS.frame = CGRectMake(20,CGRectGetMaxY(self.btn_province.frame)+25, kMainScreenWidth-40, 44);
    self.webView.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height+320);
    
    //重新监听
    
    [self addObserverForWebViewContentSize];
}

# pragma mark- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{



}

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
    //分享图片
    NSString *shareUrl= ProjectGtUrl;
    if(shareUrl==nil) shareUrl=@" ";
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =@"屋托邦QMS智能工程保障体系";
    message.description =@"屋托邦QMS智能工程质量保障体系，给你360度安全防护，让装修轻松无忧！";
    message.thumbData = UIImageJPEGRepresentation([self OriginImage:[UIImage imageNamed:@"ic_guanyu"] scaleToSize:CGSizeMake(100, 100)],0.3);
    
    WXWebpageObject *obj=[WXWebpageObject object];
    obj.webpageUrl=shareUrl;
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
    //分享图片
    NSString *shareUrl=ProjectGtUrl;
    if(shareUrl==nil) shareUrl=@" ";
    QQApiNewsObject *txtObj =[QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:@"屋托邦QMS智能工程保障体系" description:@"屋托邦QMS智能工程质量保障体系，给你360度安全防护，让装修轻松无忧！" previewImageData:UIImageJPEGRepresentation([self OriginImage:[UIImage imageNamed:@"ic_guanyu"] scaleToSize:CGSizeMake(100, 100)],0.3)];
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
    message.text = @"屋托邦QMS智能工程保障体系";
    
    //    WBImageObject *image = [WBImageObject object];
    //    image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj_effect.imagePath]];
    //    message.imageObject = image;
    
    //分享图片
    NSString *shareUrl=ProjectGtUrl;
    if(shareUrl==nil) shareUrl=@" ";
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = [NSString stringWithFormat:@"%@",@"21111"];
    webpage.title = @"屋托邦QMS智能工程保障体系";
    webpage.description = @"屋托邦QMS智能工程质量保障体系，给你360度安全防护，让装修轻松无忧！";
    webpage.thumbnailData = UIImageJPEGRepresentation([self OriginImage:[UIImage imageNamed:@"ic_guanyu"] scaleToSize:CGSizeMake(100, 100)],0.3);
    webpage.webpageUrl =shareUrl;
    message.mediaObject = webpage;
    
    return message;
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

#pragma mark - KeyBord

- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat kbSize = rect.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        scr.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-50-kbSize);
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    //CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //CGFloat kbSize = rect.size.height;
    NSLog(@"length============%f",self.webView.pageLength);
    [UIView animateWithDuration:duration animations:^{
        scr.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-50);
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

#pragma mark -UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(void)tapView:(UIGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    [self removeObserverForWebViewContentSize];

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
