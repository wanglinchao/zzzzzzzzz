//
//  GeneralViewController.m
//  chronic
//
//  Created by 黄润 on 13-8-12.
//  Copyright (c) 2013年 chenhai. All rights reserved.
//

#import "GeneralViewController.h"
#import "MBProgressHUDAdditoin.h"
#import "IDIAIAppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "SDWebImageManager.h"

@interface GeneralViewController ()

@end

@implementation GeneralViewController

@synthesize theStopRequestBlock;
@synthesize theStartRequestBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
}
    return self;
}

- (void)loginViewShow{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
}
//实现方法，设置在类中未定义的key或者不存在定义的成员变量时，需要实现该方法，可以避免程序崩溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"===================key传错了");

}
#pragma mark - 以下方法改变StatusBar字体颜色

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

-(void)loadImageviewBG{
    UIImage *image_failed = [UIImage imageNamed:@"ic_jiazaishibai_404"];
    if(!imageview_bg)
        imageview_bg=[[UIImageView alloc] initWithImage:image_failed ];
    imageview_bg.frame=CGRectMake((kMainScreenWidth-image_failed.size.width)/2, (kMainScreenHeight-64-40-image_failed.size.height - 26)/2, image_failed.size.width, image_failed.size.height);
    imageview_bg.tag=111;
    imageview_bg.hidden=YES;
    [self.view addSubview:imageview_bg];
    if (!label_bg)
        label_bg = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview_bg.frame.origin.y + imageview_bg.frame.size.height + 5, kMainScreenWidth, 21)];
    label_bg.textAlignment = NSTextAlignmentCenter;
    label_bg.font = [UIFont systemFontOfSize:13];
    label_bg.textColor = [UIColor lightGrayColor];
    label_bg.hidden = YES;
    label_bg.text = @"加载失败了,还在睡大觉";
    [self.view addSubview:label_bg];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
//     在内存中能够存储图片的最大容量 以比特为单位
     [[SDImageCache sharedImageCache] setMaxCacheSize:1024*1024*40];
//     在内存缓存保留的最长时间 以秒为单位计算
     [SDImageCache sharedImageCache].maxCacheAge = 60 * 60 * 24 * 7;  //1 week
   //  保存在存储器中像素的总和
//     [SDImageCache sharedImageCache].maxMemoryCost = 1024*2000*50;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];//一行代码改变状态栏为透明背景白色字 huangrun

    if (IS_iOS7_8) {
//
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        [self setEdgesForExtendedLayout:UIRectEdgeNone];//ios7适配iOS6关键代码 使顶部坐标从0，0开始算 但要注意理解 举例：有导航栏、选项卡等 则0，0是从导航栏底部开始的 如4寸屏下self.view的坐标为(0,0,320,504) huangrun
////        self.extendedLayoutIncludesOpaqueBars = NO;
//        
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//        self.navigationController.navigationBar.translucent = NO;
//        self.tabBarController.tabBar.translucent = NO;
    }
    
    //以下配置已经写在了
    
//    // 1.取出设置主题的对象
//    
//    UINavigationBar *navBar = [UINavigationBar appearance];
//
////    // 2.设置导航栏的背景图片
//    
//    NSString *navBarBg = nil;
//
//    if (IS_IOS7 ) { // iOS7
//        
//        navBarBg = @"public_nav_64.png";
//        
//        navBar.tintColor = [UIColor whiteColor];
//        
//    } else { // 非iOS7
//        
//        navBarBg = @"public_nav_44.png";
//        
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
//        
//    }
//
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:navBarBg] forBarMetrics:UIBarMetricsDefault];
//    
//    NSLog(@"navFrame: %@",NSStringFromCGRect(navBar.frame));
//
//    // 3.标题
//    
//    [navBar setTitleTextAttributes:@{
//                                     
//                                     UITextAttributeTextColor : [UIColor whiteColor]
//                                     
//                                     }];
//


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    [manager cancelAll];//取消所有下载操作
    [manager.imageCache clearMemory];//清楚内存缓存
}





#pragma mark - public methods(http)

-(void)refreshAllUIWhenNetWorkIsRechable{

}
- (void)startRequestWithString:(NSString*)str
{
    [self startRequest:str delegate:nil yOffset:0];
}

- (void)startRequest:(NSString*)str delegate:(id)aDelegate yOffset:(int)yOffset
{
    NSString* strMsg = str;
     [self showWaitingViewWithYOffset:strMsg parentView:self.view yOffset:yOffset delegate:nil];
//    theHttpApi = [[XPHttpApi alloc]init];
//    theHttpApi.delegate = self;
}

- (void)startActionDelay
{
    if(theStartRequestBlock)
        theStartRequestBlock();
}
- (void)startActionWithBlock:(dispatch_block_t)block
{
    if (!block)
        block = ^{};
    [self setTheStartRequestBlock:block];
    [self performSelector:@selector(startActionDelay) withObject:nil afterDelay:DEFAULT_DELAY_SECONDS];
}

- (void)stopRequest
{
    [self hideWatingView];
}
//SP JiangT
- (void)stopMBProgressHUD {
      [self hideWatingView];
}


- (void)stopRequestWithDelay:(SEL)aSel withObject:(NSObject*)anObject
{
    [self stopRequest];
    [self performSelector:aSel withObject:anObject afterDelay:DEFAULT_DELAY_SECONDS];
}
- (void)stopRequestDelay
{
    if(theStopRequestBlock)
        theStopRequestBlock();
    
    [self stopRequest];
}
- (void)stopRequestWithBlock:(dispatch_block_t)block
{
    if (!block)
        block = ^{};
    [self setTheStopRequestBlock:block];
    
    [self performSelector:@selector(stopRequestDelay) withObject:nil afterDelay:DEFAULT_DELAY_SECONDS];
}

#pragma mark -
#pragma mark public methods (MBHUD)
- (void)showWaitingViewWithYOffset:(NSString*)str parentView:(UIView*)parentView yOffset:(int)yOffset delegate:(id)aDelegate
{
    [self hideWatingView];
    
    //theHUD = [[MBProgressHUD alloc]initWithView:self.view];
    theHUD = [[MBProgressHUD alloc]initWithFrame:[self BottomViewRect]];
    theHUD.mode = MBProgressHUDModeIndeterminate;
    theHUD.delegate = aDelegate;
    theHUD.labelText = str;
    theHUD.yOffset = yOffset;
    theHUD.tag = MBHUD_VIEW_TAG;
    theHUD.blur=NO;  //是否开启ios7毛玻璃风格
    theHUD.darkBlur=YES; //受blur限制（blur为YES时设置darkBlur才有用）
    [self.view addSubview:theHUD];
    [theHUD show:YES];

}

- (void)hideWatingView
{
    if(theHUD)
    {
        [theHUD removeFromSuperview];
        
    }
    
    if (_activityIndicator) {
        [_activityIndicator removeFromSuperview];
    }
}

- (CGRect)BottomViewRect
{
    CGRect rect = [self CustomNavgationBarRect];
    return CGRectMake(5, 0, self.view.frame.size.width - 10, self.view.bounds.size.height - rect.size.height - kNavigationBarHeight);
}

- (CGRect)CustomNavgationBarRect
{
    return CGRectMake(0, 0, self.view.frame.size.width, kNavigationBarHeight);
}

- (void)changeMBHUDYOffset:(int)yOffset
{
    MBProgressHUD* hud = [MBProgressHUD getCurrentMBProgressHUD:self.view];
    hud.yOffset = yOffset;
}

- (CGRect)BackButtonRect
{
//    CGRect rect = [self CustomNavgationBarRect];
    return CGRectMake(10, 6, 50, 34);
}

- (CGRect)rightButtonRect
{
    CGRect rect = [self CustomNavgationBarRect];
    return CGRectMake(310, 6, 30,rect.size.height-40);
}

- (void)startRequestWithCustomIndicator {
   [self startRequestWithDelegate:nil yOffset:0];
}

- (void)startRequestWithDelegate:(id)aDelegate yOffset:(int)yOffset {
    [self showWaitingViewWithParentView:self.view yOffset:yOffset delegate:nil];

}

- (void)showWaitingViewWithParentView:(UIView*)parentView yOffset:(int)yOffset delegate:(id)aDelegate
{
    _activityIndicator.hidden = YES;
    
    _activityIndicator = [[WDActivityIndicator alloc]initWithFrame:CGRectMake([[UIApplication sharedApplication]keyWindow].center.x - 17, [[UIApplication sharedApplication]keyWindow].center.y + 20 - 17, 40, 40)];
    [[[UIApplication sharedApplication]keyWindow] addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
}

+ (void)resignAllKeyboard:(UIView*)aView
{
    if([aView isKindOfClass:[UITextField class]] ||
       [aView isKindOfClass:[UITextView class]])
    {
        UITextField* tf = (UITextField*)aView;
        if([tf canResignFirstResponder])
            [tf resignFirstResponder];
    }
    
    for (UIView* pView in aView.subviews) {
        [self resignAllKeyboard:pView];
    }
}

- (void)showWithCustomView:(id)sender msg:(NSString *)msg {
    
    theHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:theHUD];
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    //	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    theHUD.customView = [self customLabel:msg];
    
    // Set custom view mode
    theHUD.mode = MBProgressHUDModeCustomView;
    
    theHUD.delegate = self;
    //	HUD.labelText = @"Completed";
    
    [theHUD show:YES];
    [theHUD hide:YES afterDelay:3];
}

- (UILabel *)customLabel:(NSString *)text {
    UILabel * testlable = [[UILabel alloc]initWithFrame:CGRectMake(10,20,200,20)];
    
    //	NSString * tstring =@"UILabel  ios7 与ios7之前实现自适应撑高的方法,文本的内容长度不一，我们需要根据内容的多少来自动换行处理。在IOS7下要求font，与breakmode与之前设置的完全一致sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping";
    NSString *tstring = text;
    
    testlable.numberOfLines =2;
    
    UIFont * tfont = [UIFont systemFontOfSize:14];
    
    testlable.font = tfont;
    testlable.textColor = [UIColor whiteColor];
    
    testlable.lineBreakMode =NSLineBreakByTruncatingTail ;
    
    testlable.text = tstring ;
    //	[testlable setBackgroundColor:[UIColor redColor]];
    
    [self.view addSubview:testlable];
    
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    
    CGSize size =CGSizeMake(300,60);
    
    // label可设置的最大高度和宽度
    //    CGSize size = CGSizeMake(300.f, MAXFLOAT);
    
    //    获取当前文本的属性
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    
    CGSize  actualsize =[tstring boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    // ios7之前使用方法获取文本需要的size，7.0已弃用下面的方法。此方法要求font，与breakmode与之前设置的完全一致
    //    CGSize actualsize = [tstring sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    //   更新UILabel的frame
    
    
    testlable.frame =CGRectMake(10,20, actualsize.width, actualsize.height);
    
    return testlable;
}
//copy From jiangt   and the "theHud" be changed
#pragma mark - Public Methods

- (void)startMBProgressHUDWithString:(NSString *)str {
    if (!theHUD) {
        theHUD = [[MBProgressHUD alloc] initWithView:self.view];
        theHUD.delegate=self;
        theHUD.mode=MBProgressHUDModeIndeterminate;
        //theHUD.dimBackground=YES; //是否开启背景变暗
        theHUD.labelText = str;     //标题文本
        theHUD.labelColor=[UIColor whiteColor];    //标题文本的颜色
        theHUD.labelFont=[UIFont systemFontOfSize:16];    //标题文本的字体大小
        theHUD.blur=YES;  //是否开启ios7毛玻璃风格
        theHUD.darkBlur=YES; //受blur限制（blur为YES时设置darkBlur才有用）
        theHUD.opacity=0.8;  //背景框的透明度，默认值是0.8
        //theHUD.color=[UIColor redColor]; // 背景框的颜色,需要注意的是如果设置了这个属性，则opacity属性会失效，即不会有半透明效果
        theHUD.cornerRadius=10.0;    //背景框的圆角半径。默认值是10.0
        theHUD.animationType=MBProgressHUDAnimationFade;  //动画类型
        [self.view addSubview:theHUD];
        [theHUD show:YES];
        
        /*****
         @param MBProgressHUDModeDeterminate | MBProgressHUDModeDeterminateHorizontalBar | MBProgressHUDModeAnnularDeterminate
         @param 类型mode为上面三种的任意一种时使用下面方法改变进度
         *****/
        //[theHUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
    }
    else{
        theHUD.labelText = str;     //标题文本
        [theHUD show:YES];
    }
}


///////////////////////////////////////////////////////////////////////////
/**************************** 网络请求交互及回调 ****************************/
#pragma mark -
#pragma mark - HttpRequest 网络请求

/*****
 @param 方法一
 @param 通过指定的函数回调结果
 @param 函数中tag标记是那个函数请求，方便回调中判断处理相关结果
 *****/

-(void)sendRequestToServerUrl:(NSString *)ServerUrl CmdID:(NSString *)cmdID
                     PostDict:(NSMutableDictionary *)bodyDict RequestTag:(NSString *)tag
                  RequestType:(NSString *)requestType
{
    NSMutableDictionary *parameters= [self GetRequestHeaderByCmdID:cmdID BodyDict:bodyDict];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
    manager.requestSerializer.timeoutInterval=15.0;
    if([requestType isEqualToString:@"POST"]){
        [manager POST:ServerUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求成功返回结果：%@",responseObject);
            [self completedRequest:responseObject indexTag:tag];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败返回结果：%@",error);
            [self failedRequest:error indexTag:tag];
        }];
    }
    else{
        [manager GET:ServerUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求成功返回结果：%@",responseObject);
            [self completedRequest:responseObject indexTag:tag];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败返回结果：%@",error);
            [self failedRequest:error indexTag:tag];
        }];
    }
}

-(void)sendRequestImagesToServerUrl:(NSString *)ServerUrl CmdID:(NSString *)cmdID
                           PostDict:(NSMutableDictionary *)bodyDict PostImages:(NSMutableArray *)images_arr
                     UploadImageKey:(NSString *)imageKey RequestTag:(NSString *)tag Progress:(BOOL)isProgress
{
    NSMutableDictionary *parameters= [self GetRequestHeaderByCmdID:cmdID BodyDict:bodyDict];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
    manager.requestSerializer.timeoutInterval=15.0;
    AFHTTPRequestOperation *fileUploadOp=[manager POST:ServerUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i=0;i<[images_arr count];i++){
            UIImage *uploadImage=(UIImage *)[images_arr objectAtIndex:i];
            NSData *img_data=[util compressionImageData:uploadImage]; /*同一张拍照所得照片：png大小在8M，而JPG压缩系数为0.75时候，大小只有1M。而且，将压缩系数降低对图片视觉上并没有太大的影响*/
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str,(int)i];
            [formData appendPartWithFileData:img_data name:imageKey fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功返回结果：%@",responseObject);
        [self completedRequest:responseObject indexTag:tag];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败返回结果：%@",error);
        [self failedRequest:error indexTag:tag];
    }];
    
    if(isProgress==YES){
        //获取上传进度
        [fileUploadOp setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            CGFloat progress = ((float)totalBytesWritten) / totalBytesExpectedToWrite;
            [self startMBProgressHUDWithString:[NSString stringWithFormat:@"已上传%.0f%%",progress*100]];
            //NSLog(@"%ld--上传进度:%f=========%lld++++++%lld",(long)bytesWritten,progress,totalBytesWritten,totalBytesExpectedToWrite);
        }];
    }
}

//下面两个是成功和失败结果的回调函数
-(void)completedRequest:(id)responseObject_ indexTag:(NSString *)tag{
    // do someThings...
}

-(void)failedRequest:(id)error indexTag:(NSString *)tag{
    // do someThings...
}

/*****
 @param 方法二
 @param 通过block回调结果
 ******/

-(void)sendRequestToServerUrl:(void (^)(id))aCompletionBlock failedBlock:(void (^)(id))aFailedBlock
                   RequestUrl:(NSString *)requestUrl CmdID:(NSString *)cmdID
                     PostDict:(NSMutableDictionary *)bodyDict RequestType:(NSString *)requestType
{
    NSMutableDictionary *parameters= [self GetRequestHeaderByCmdID:cmdID BodyDict:bodyDict];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
    manager.requestSerializer.timeoutInterval=15.0;
    if([requestType isEqualToString:@"POST"]){
        [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求成功返回结果：%@",responseObject);
            aCompletionBlock(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败返回结果：%@",error);
            aFailedBlock(error);
        }];
    }
    else{
        [manager GET:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求成功返回结果：%@",responseObject);
            aCompletionBlock(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败返回结果：%@",error);
            aFailedBlock(error);
        }];
    }
}

-(void)sendRequestImagesToServerUrl:(void (^)(id))aCompletionBlock failedBlock:(void (^)(id))aFailedBlock
                         RequestUrl:(NSString *)requestUrl CmdID:(NSString *)cmdID
                           PostDict:(NSMutableDictionary *)bodyDict PostImages:(NSMutableArray *)images_arr
                     UploadImageKey:(NSString *)imageKey Progress:(BOOL)isProgress
{
    NSMutableDictionary *parameters= [self GetRequestHeaderByCmdID:cmdID BodyDict:bodyDict];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
    manager.requestSerializer.timeoutInterval=15.0;
    AFHTTPRequestOperation *fileUploadOp=[manager POST:requestUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i=0;i<[images_arr count];i++){
            UIImage *uploadImage=(UIImage *)[images_arr objectAtIndex:i];
            NSData *img_data=[util compressionImageData:uploadImage]; /*同一张拍照所得照片：png大小在8M，而JPG压缩系数为0.75时候，大小只有1M。而且，将压缩系数降低对图片视觉上并没有太大的影响*/
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str,(int)i];
            [formData appendPartWithFileData:img_data name:imageKey fileName:fileName mimeType:@"image/jpeg"];
            NSLog(@"图片的大小：%dKB", (unsigned)img_data.length/1000);
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功返回结果：%@",responseObject);
        aCompletionBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败返回结果：%@",error);
        aFailedBlock(error);
    }];
    
    if(isProgress==YES){
        //获取上传进度
        [fileUploadOp setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            CGFloat progress = ((float)totalBytesWritten) / totalBytesExpectedToWrite;
            [self startMBProgressHUDWithString:[NSString stringWithFormat:@"已上传%.0f%%",progress*100]];
            //NSLog(@"%ld--上传进度:%f=========%lld++++++%lld",(long)bytesWritten,progress,totalBytesWritten,totalBytesExpectedToWrite);
        }];
    }
}

#pragma mark - 封装网络请求需要的包头和包体

-(NSMutableDictionary *)GetRequestHeaderByCmdID:(NSString *)cmdID BodyDict:(NSMutableDictionary *)bodyDictionary {
    NSString *string_token=@"";
    NSString *string_userid=@"";
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length] && [[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
        string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
        string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
    }
    
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
    [headerDict setObject:cmdID forKey:@"cmdID"];
    [headerDict setObject:string_token forKey:@"token"];
    [headerDict setObject:[NSString stringWithFormat:@"%@",string_userid] forKey:@"userID"];
    [headerDict setObject:@"iOS" forKey:@"deviceType"];
    [headerDict setObject:@"" forKey:@"cityCode"];
    [headerDict setObject:@"1" forKey:@"httpver"];
    NSString *header_str = [headerDict JSONString];
    
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] initWithDictionary:bodyDictionary];

    NSString *body_str = [bodyDict JSONString];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:header_str forKey:@"header"];
    [parameters setObject:body_str forKey:@"body"];
    
    return parameters;
}


@end
