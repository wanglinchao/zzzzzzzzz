//
//  EffectTAOTUPictureInfo.m
//  IDIAI
//
//  Created by iMac on 15-3-5.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "EffectTAOTUPictureInfoForDesigner.h"
#import "HexColor.h"
#import "util.h"
#import "UIImageView+OnlineImage.h"
#import "MRZoomScrollView.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "IDIAIAppDelegate.h"
#import "SharePcitureView.h"
#import "TLToast.h"
#import "SVProgressHUD.h"
#import "UIImageView+LBBlurredImage.h"
#import "DesignerInfoVC.h"
#import "DesignerInfoObj.h"
#import "savelogObj.h"
#import "CMSCoinView.h"

#define KUIButton_TAG 100

@interface EffectTAOTUPictureInfoForDesigner ()<SharePicViewDelegate>{
    DesignerInfoObj *_obj;
}

@property (nonatomic,strong) UILabel *pic_currentPage_first;
@property (nonatomic,strong) UILabel *pic_currentPage_second;
@property (nonatomic,strong) UILabel *pic_totalPages;
@property (nonatomic,strong) CMSCoinView *coinView;

@property (nonatomic,strong) UIImageView *imv;
@property (nonatomic, strong) NSOperationQueue *queue;


@end

@implementation EffectTAOTUPictureInfoForDesigner
@synthesize data_array,imv,obj_pic,img_,xiaoquName,descName,bottom_bg,type_into,doorModel_Area_price;

-(void)dealloc{
    self.queue=nil;
}

- (NSOperationQueue *)queue {
    if (!_queue) _queue = [[NSOperationQueue alloc] init];
    //[_queue setMaxConcurrentOperationCount:5];
    return _queue;
}


-(void)backTouched{
    if(type_into==1){
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
        [appDelegate.nav popViewControllerAnimated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if(self.queue.operationCount) [self.queue cancelAllOperations];
    for(MRZoomScrollView *mrscr in _scrollView.subviews) {
        [mrscr removeFromSuperview];
    }
}

- (void)viewWillLayoutSubviews{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)loadImageView:(UIImage *)img image:(NSInteger )i{
    
    MRZoomScrollView *_zoomScrollView = [[MRZoomScrollView alloc]init];
    CGRect frame = CGRectMake(0, 150, kMainScreenWidth, kMainScreenHeight);
    frame.origin.x = frame.size.width * (i+1);
    frame.origin.y = 0;
    _zoomScrollView.frame = frame;
    
        [_scrollView addSubview:_zoomScrollView];
        float height=0.01;
        if(img){
            height=(img.size.height*kMainScreenWidth)/img.size.width;
            _zoomScrollView.imageView.frame=CGRectMake(0,(kMainScreenHeight-height)/2, kMainScreenWidth, height);
            _zoomScrollView.imageView.image=img;
        }
}

-(void)downloadImg:(NSString *)url index:(NSInteger)index {
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center=CGPointMake(kMainScreenWidth*(index+1)+kMainScreenWidth/2, kMainScreenHeight/2);
    activityView.hidesWhenStopped=YES;
    [_scrollView addSubview:activityView];
    [activityView startAnimating];
    
    //if ([[NSOperationQueue mainQueue] operationCount]>6) [[NSOperationQueue mainQueue] cancelAllOperations];
    [self.queue addOperationWithBlock: ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]]; //得到图像数据
        UIImage *image = [UIImage imageWithData:imgData];
        if(image){
            [activityView stopAnimating];
            [activityView removeFromSuperview];
        }
        else{
            [activityView stopAnimating];
            [activityView removeFromSuperview];
        }
        //在主线程中更新UI
        if([NSOperationQueue currentQueue]){
            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                if([self respondsToSelector:@selector(loadImageView: image:)]){
                    [self loadImageView:image image:index];
                }
            }];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor blackColor];
    self.imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    self.imageView.contentMode=UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds=YES;
    [self.view addSubview:self.imageView];
    UIView *view_=[[UIView alloc]initWithFrame:self.view.bounds];
    view_.backgroundColor=[UIColor blackColor];
    view_.alpha=0.6;
    [self.view addSubview:view_];
    __block EffectTAOTUPictureInfoForDesigner *weakself=self;
    [self.imageView setImageToBlur:img_
                        blurRadius:kLBBlurredImageDefaultBlurRadius
                   completionBlock:^(NSError *error){
                       [weakself loadThings];
                   }];
    
//    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(parsingQueue, ^{
//        UIImage *img;
//        if([obj_pic.imagePath length]>1)
//            img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj_pic.imagePath]]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(img.size.height) {
//                [self.imageView setImageToBlur:img
//                                    blurRadius:kLBBlurredImageDefaultBlurRadius
//                               completionBlock:^(NSError *error){
//                                   NSLog(@"The blurred image has been setted");
//                               }];
//            }
//        });
//    });
  
}

-(void)loadThings{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    self.pic_currentPage_first= [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-50, 27, 25, 25)];
    self.pic_currentPage_first.backgroundColor = [UIColor colorWithHexString:@"#D1D1D1" alpha:1.0];
    self.pic_currentPage_first.font = [UIFont systemFontOfSize:16.0];
    self.pic_currentPage_first.textAlignment = NSTextAlignmentCenter;
    self.pic_currentPage_first.textColor = [UIColor blackColor];
    self.pic_currentPage_first.text=@"1";
    
    self.pic_currentPage_second= [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-50, 27, 25, 25)];
    self.pic_currentPage_second.backgroundColor = [UIColor colorWithHexString:@"#D1D1D1" alpha:1.0];
    self.pic_currentPage_second.font = [UIFont systemFontOfSize:16.0];
    self.pic_currentPage_second.textAlignment = NSTextAlignmentCenter;
    self.pic_currentPage_second.textColor = [UIColor blackColor];
    self.pic_currentPage_second.text=@"1";
    
    UIImageView *pic_totalPages_bg=[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth/2-30, 27, 70, 25)];
    pic_totalPages_bg.image=[UIImage imageNamed:@"bg_changyuan"];
    [self.view addSubview:pic_totalPages_bg];
    
    self.pic_totalPages= [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-15, 27, 65, 25)];
    self.pic_totalPages.backgroundColor = [UIColor clearColor];
    self.pic_totalPages.font = [UIFont systemFontOfSize:16.0];
    self.pic_totalPages.textAlignment = NSTextAlignmentLeft;
    self.pic_totalPages.textColor = [UIColor whiteColor];
    [self.view addSubview:self.pic_totalPages];
    
    _coinView=[[CMSCoinView alloc] initWithPrimaryView:self.pic_currentPage_first andSecondaryView:self.pic_currentPage_second inFrame:CGRectMake(kMainScreenWidth/2-48, 27, 25, 25)];
    [_coinView setSpinTime:1.0];
    [self.view addSubview:_coinView];
    
    if([self.designerIDStr integerValue]!=0){
        UIImageView *designer_logo=[[UIImageView alloc]initWithFrame:CGRectMake(20, kMainScreenHeight/2-80, 60, 60)];
        [designer_logo setOnlineImage:self.designerLogo placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over"]];
        designer_logo.layer.cornerRadius=30.0;
        designer_logo.layer.masksToBounds=YES;
        [_scrollView addSubview:designer_logo];
        
        UILabel *designerName= [[UILabel alloc] initWithFrame:CGRectMake(95, kMainScreenHeight/2-65, 150, 30)];
        designerName.backgroundColor = [UIColor clearColor];
        designerName.font = [UIFont systemFontOfSize:20.0];
        designerName.textAlignment = NSTextAlignmentLeft;
        designerName.textColor = [UIColor whiteColor];
        designerName.text=self.designerName;
        [_scrollView addSubview:designerName];
        
//        UIButton *into_designer=[[UIButton alloc]initWithFrame:CGRectMake(20, kMainScreenHeight/2-80, 220, 60)];
//        [into_designer addTarget:self action:@selector(GoIntoDesigner) forControlEvents:UIControlEventTouchUpInside];
//        [_scrollView addSubview:into_designer];
    }
    
    xiaoquName= [[UILabel alloc] initWithFrame:CGRectMake(20, kMainScreenHeight/2, kMainScreenWidth-90, 20)];
    xiaoquName.backgroundColor = [UIColor clearColor];
    xiaoquName.font = [UIFont systemFontOfSize:20.0];
    xiaoquName.textAlignment = NSTextAlignmentLeft;
    xiaoquName.textColor = [UIColor whiteColor];
    xiaoquName.numberOfLines=0;
    xiaoquName.text=@"";
    [_scrollView addSubview:xiaoquName];
    
    NSString *str=@"  ";
    CGSize sizeName=[util calHeightForLabel:str width:kMainScreenWidth-90 font:[UIFont systemFontOfSize:15.0]];
    descName= [[UILabel alloc] initWithFrame:CGRectMake(20, kMainScreenHeight/2+40, kMainScreenWidth-90, sizeName.height)];
    descName.backgroundColor = [UIColor clearColor];
    descName.font = [UIFont systemFontOfSize:15.0];
    descName.textAlignment = NSTextAlignmentLeft;
    descName.textColor = [UIColor whiteColor];
    descName.numberOfLines=0;
    descName.text=str;
    [_scrollView addSubview:descName];
    
    doorModel_Area_price= [[UILabel alloc] initWithFrame:CGRectMake(20, kMainScreenHeight/2+40+sizeName.height, kMainScreenWidth-40, 20)];
    doorModel_Area_price.backgroundColor = [UIColor clearColor];
    doorModel_Area_price.font = [UIFont systemFontOfSize:15.0];
    doorModel_Area_price.textAlignment = NSTextAlignmentLeft;
    doorModel_Area_price.textColor = [UIColor whiteColor];
    [_scrollView addSubview:doorModel_Area_price];
    
    UIImageView *slider_jt=[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-50, kMainScreenHeight/2, 30, 30)];
    slider_jt.image =[UIImage imageNamed:@"ix_jiantou_x"];
    [_scrollView addSubview:slider_jt];
    
    [self CreateBottomBG];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(10, 25, 80,30)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh"] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake( 0, 10, 0, 30)];
    [leftButton addTarget:self
                   action:@selector(backTouched)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    [self requestTAOTUPicturelist];
//    [self getTAOTUPicturelist];
    [self requestDesignerDetailInfo];
    [self requestBrower];
}

-(void)CreateBottomBG{
    
    bottom_bg=[[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-50, kMainScreenWidth, 50)];
    bottom_bg.backgroundColor=[UIColor blackColor];
    bottom_bg.alpha=0.8;
    [self.view addSubview:bottom_bg];
    
    UIImageView *imv_ll=[[UIImageView alloc]initWithFrame:CGRectMake(10, kMainScreenHeight-37, 25, 25)];
    imv_ll.image=[UIImage imageNamed:@"ic_guanzhu_x"];
    [self.view addSubview:imv_ll];
    
    UILabel * lab_brown= [[UILabel alloc] initWithFrame:CGRectMake(40, kMainScreenHeight-40, 100, 30)];
    lab_brown.backgroundColor = [UIColor clearColor];
    lab_brown.font = [UIFont systemFontOfSize:16.0];
    lab_brown.textAlignment = NSTextAlignmentLeft;
    lab_brown.textColor = [UIColor whiteColor];
    [self.view addSubview:lab_brown];
    if([obj_pic.browserNum integerValue]>=10000)
        lab_brown.text=[NSString stringWithFormat:@"%.1f万",[obj_pic.browserNum floatValue]/10000.0];
    else
        lab_brown.text=[NSString stringWithFormat:@"%ld",(long)[obj_pic.browserNum integerValue]];
    
    //数字+1的动画效果
/***********************************************/
    UILabel * math_plus= [[UILabel alloc] initWithFrame:CGRectMake(110, kMainScreenHeight-110, 45, 30)];
    math_plus.backgroundColor = [UIColor clearColor];
    math_plus.font = [UIFont systemFontOfSize:17.0];
    math_plus.textColor = [UIColor whiteColor];
    math_plus.text=@"+1";
    [self.view addSubview:math_plus];
    
    math_plus.transform = CGAffineTransformMakeScale(1.8, 1.8);
    [UIView animateWithDuration:0.8 animations:^(void){
        math_plus.alpha=0.3;
        math_plus.frame=CGRectMake(50, kMainScreenHeight-50, 45, 30);
        math_plus.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    }completion:^(BOOL finished){
        [math_plus removeFromSuperview];

        if([obj_pic.browserNum integerValue]>=100000000)
            lab_brown.text=[NSString stringWithFormat:@"%.1f亿",([obj_pic.browserNum floatValue]+1)/100000000.0];
        else if([obj_pic.browserNum integerValue]>=10000)
            lab_brown.text=[NSString stringWithFormat:@"%.1f万",([obj_pic.browserNum floatValue]+1)/10000.0];
        else
            lab_brown.text=[NSString stringWithFormat:@"%ld",(long)[obj_pic.browserNum integerValue]+1];
        obj_pic.browserNum=[NSString stringWithFormat:@"%ld",(long)[obj_pic.browserNum integerValue]+1];
        
        imv_ll.transform = CGAffineTransformMakeScale(1.35, 1.35);
        [UIView animateWithDuration:0.4 animations:^(void){
            imv_ll.transform = CGAffineTransformMakeScale(0.6, 0.6);
        }completion:^(BOOL finished){
            imv_ll.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [_coinView flipTouched:nil];
        }];
    }];
/***********************************************/

    NSArray *img_arr=[NSArray arrayWithObjects:@"ic_fenxiang",@"ic_xiazai",@"ic_shoucang_nor", nil];
    for (int i=0; i<[img_arr count]; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-190+i*60, kMainScreenHeight-45, 60, 40)];
        btn.tag=KUIButton_TAG+i;
        [btn setImage:[UIImage imageNamed:[img_arr objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(Pressbtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if(i==1) btn.enabled=NO;
    }
    
    UIButton *btn_sc=(UIButton *)[self.view viewWithTag:KUIButton_TAG+2];
    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path_ = [path_ objectAtIndex:0];
    NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:@"MyeffectPictureForTaotu.plist"];
    NSMutableArray *Arr_=[NSMutableArray arrayWithContentsOfFile:_filename_];
    if (!Arr_) {
        Arr_=[NSMutableArray arrayWithCapacity:0];
    }
    if([Arr_ count]){
        for(NSDictionary *dict in Arr_){
            if([[dict objectForKey:@"id"] integerValue]==[obj_pic.picture_id integerValue]){
                [btn_sc setImage:[UIImage imageNamed:@"ic_shoucang"] forState:UIControlStateNormal];
                btn_sc.selected=YES;
                break;
            }
            else{
                [btn_sc setImage:[UIImage imageNamed:@"ic_shoucang_nor"] forState:UIControlStateNormal];
                btn_sc.selected=NO;
            }
        }
    }
    else{
        [btn_sc setImage:[UIImage imageNamed:@"ic_shoucang_nor"] forState:UIControlStateNormal];
        btn_sc.selected=NO;
    }
}

-(void)Pressbtn:(UIButton *)sender{
    if(sender.tag==KUIButton_TAG+0){
        SharePcitureView *shareView=[[SharePcitureView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 100)];
        shareView.delegate=self;
        shareView.isdiary=NO;
        [UIView animateWithDuration:.25 animations:^{
            shareView.frame=CGRectMake(0, kMainScreenHeight-100, kMainScreenWidth, 100);
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
        [shareView show];
    }
    else if (sender.tag==KUIButton_TAG+1){
        NSInteger index_=_scrollView.contentOffset.x/kMainScreenWidth;
        if(index_-1<[data_array count]){
            NSString *url_pic=[data_array objectAtIndex:index_-1];
            dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(parsingQueue, ^{
                UIImage *img;
                if([url_pic length]>1)
                    img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url_pic]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);//保存图片到相册中，需要回调方法或者检验是否存入成功：
                });
            });
        }
    }
    else{
        
        UIButton *btn_sc=(UIButton *)sender;
        if(btn_sc.selected==NO){
            
            obj_pic.collectionNum=[NSString stringWithFormat:@"%d",[obj_pic.collectionNum integerValue]+1];
            
            [btn_sc setImage:[UIImage imageNamed:@"ic_shoucang"] forState:UIControlStateNormal];
            btn_sc.selected=YES;
            
            [SVProgressHUD showSuccessWithStatus:@"收藏成功" duration:1.0];
            
            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* doc_path = [path objectAtIndex:0];
            NSString* _filename = [doc_path stringByAppendingPathComponent:@"MyeffectPictureForTaotu.plist"];
            NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename];
            if (!arr_) {
                arr_=[NSMutableArray arrayWithCapacity:0];
            }
            NSMutableDictionary *dict_=[[NSMutableDictionary alloc]initWithCapacity:0];
            if(obj_pic.browserNum!=nil)
                [dict_ setObject:obj_pic.browserNum forKey:@"browserNum"];
            if (obj_pic.collectionNum != nil) {
                [dict_ setObject:obj_pic.collectionNum forKey:@"collectionNum"];
            }
            if(obj_pic.designerName!=nil)
                [dict_ setObject:obj_pic.designerName forKey:@"designerName"];
            if(obj_pic.designerImagePath!=nil)
                [dict_ setObject:obj_pic.designerImagePath forKey:@"designerImagePath"];
            if(obj_pic.imagePath!=nil)
                [dict_ setObject:obj_pic.imagePath forKey:@"imagePath"];
            if(obj_pic.picture_id!=nil)
                [dict_ setObject:obj_pic.picture_id forKey:@"id"];
            if(obj_pic.designerID!=nil)
                [dict_ setObject:obj_pic.designerID forKey:@"designerID"];
            [dict_ setObject:@"2" forKey:@"PictureType"];
            [arr_ addObject:dict_];
            [arr_ writeToFile:_filename atomically:NO];
            
            [self requestCollectionNum];
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error==nil) {
        [TLToast showWithText:@"保存至相册成功" topOffset:220.0f duration:1.0];
    }else {
        [TLToast showWithText:@"保存至相册失败" topOffset:220.0f duration:1.0];
    }
}

-(void)SharePicCustomclickedButtonAtIndex:(NSInteger)buttonIndex{
    [savelogObj saveLog:@"分享装修方案" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:36];
    
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

-(void)GoIntoDesigner{
    DesignerInfoVC *desvc=[[DesignerInfoVC alloc]init];
    desvc.designer_id=obj_pic.designerID;
    desvc.picture_id=obj_pic.picture_id;
    desvc.obj = _obj;
    [self.navigationController pushViewController:desvc animated:YES];
}

#pragma mark - Zoom methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index_=_scrollView.contentOffset.x/kMainScreenWidth;
    if([self.pic_currentPage_first.text integerValue]!=index_+1 && [self.pic_currentPage_second.text integerValue]!=index_+1) [_coinView flipTouched:nil];
    self.pic_currentPage_first.text=[NSString stringWithFormat:@"%ld",(long)index_+1];
    self.pic_currentPage_second.text=[NSString stringWithFormat:@"%ld",(long)index_+1];
    
    UIButton *btn=(UIButton *)[self.view viewWithTag:KUIButton_TAG+1];
    if(index_>=1) btn.enabled=YES;
    else btn.enabled=NO;
}

#pragma mark -请求图集
-(void)requestTAOTUPicturelist{
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSInteger cityCodeInteger = [kCityCode integerValue];
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0125\",\"deviceType\":\"ios\",\"token\":\"\",\"userID\":\"\",\"cityCode\":%d}&body={\"id\":\"%@\"}",kDefaultUpdateVersionServerURL,cityCodeInteger,self.picIDStr];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"套图返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==11251) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        data_array=[jsonDict objectForKey:@"rendreingsList"];
                        
                        obj_pic.shareUrl=[jsonDict objectForKey:@"shareUrl"];
                        
                        NSString *nameStr = [jsonDict objectForKey:@"collectiveDrawingName"];
                        CGSize size=[util calHeightForLabel:nameStr width:kMainScreenWidth-90 font:[UIFont systemFontOfSize:20.0]];
                        xiaoquName.frame = CGRectMake(20, kMainScreenHeight/2, kMainScreenWidth-90, size.height);
                        xiaoquName.text=[jsonDict objectForKey:@"collectiveDrawingName"];
                        
                        NSString *str=[NSString stringWithFormat:@"       %@",[jsonDict objectForKey:@"description"]];
                        CGSize sizeName=[util calHeightForLabel:str width:kMainScreenWidth-90 font:[UIFont systemFontOfSize:15.0]];
                        descName.frame= CGRectMake(20, xiaoquName.frame.origin.y + xiaoquName.frame.size.height + 5, kMainScreenWidth-90, sizeName.height);
                        descName.text=str;
                        
                        doorModel_Area_price.frame=CGRectMake(20, descName.frame.origin.y+sizeName.height+10, kMainScreenWidth-40, 20);
                        doorModel_Area_price.text=[NSString stringWithFormat:@"%@   %@m²   %@元/m²",[jsonDict objectForKey:@"doorModel"],[jsonDict objectForKey:@"buildingArea"],[jsonDict objectForKey:@"price"]];
                        
                        self.pic_totalPages.text =[NSString stringWithFormat:@" of %ld",(long)[data_array count]+1];
                        [_scrollView setContentSize:CGSizeMake(kMainScreenWidth * ([data_array count]+1), kMainScreenHeight)];
                        
                        if([data_array count]){
                            [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                            for (int i = 0; i < [data_array count]; i++) {
                                @autoreleasepool {
                                    [self downloadImg:[data_array objectAtIndex:i] index:i];
                                }
                            }
                        }
                    });
                }
                else if (code==11259) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                 [self stopRequest];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

- (void)getTAOTUPicturelist {
    data_array = self.picListArr;
    xiaoquName.text = self.xiaoquNameStr;
    descName.text = self.descStr;
    self.pic_totalPages.text =[NSString stringWithFormat:@" of %ld",(long)[data_array count]+1];
    [_scrollView setContentSize:CGSizeMake(kMainScreenWidth * ([data_array count]+1), kMainScreenHeight)];
    
    if([data_array count]){
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        for (int i = 0; i < [data_array count]; i++) {
            @autoreleasepool {
                [self downloadImg:[data_array objectAtIndex:i] index:i];
            }
        }
    }

}

#pragma mark - 请求设计师详情

- (void)requestDesignerDetailInfo {
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0021\",\"deviceType\":\"ios\",\"token\":\"\",\"userID\":\"\",\"cityCode\":\"%@\"}&body={\"designerID\":\"%@\"}",kDefaultUpdateVersionServerURL,kCityCode, obj_pic.designerID];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"设计师：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10231) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSDictionary *dic = [jsonDict mutableCopy];
                        if (dic) {
                            
                            _obj = [DesignerInfoObj objWithDict:dic];
                            
                        }
                        
                        //                        [self requestworkerTypelist];
                    });
                }
                else if (code==10232) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        //                        imageview_bg.hidden=NO;
                    });
                }
                else if (code == 10239){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        //                        imageview_bg.hidden=NO;
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  //                                  imageview_bg.hidden=NO;
                              });
                          }
                               method:url postDict:nil];
    });
    
}


//发送浏览量+1
-(void)requestBrower{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0129\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"id\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,kCityCode,self.picIDStr];
        
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
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==11291) {
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


//发送收藏量+1
-(void)requestCollectionNum{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0128\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"id\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,kCityCode,obj_pic.picture_id];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"发送收藏量返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==11281) {
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

#pragma mark -
#pragma mark - Weixin related
- (void)sendTextContentToWX:(NSInteger)type {
    //分享图片
    if(obj_pic.shareUrl==nil) obj_pic.shareUrl=@" ";
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =@"屋托邦精选方案";
    message.description =descName.text;
     message.thumbData = UIImageJPEGRepresentation([self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj_pic.rendreingsPath]]]scaleToSize:CGSizeMake(100, 100)],0.06);
    //    WXImageObject *obj=[WXImageObject object];
    //    obj.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url_pic]];
    //    message.mediaObject=obj;
    
    WXWebpageObject *obj=[WXWebpageObject object];
    obj.webpageUrl=obj_pic.shareUrl;
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
    if(obj_pic.shareUrl==nil) obj_pic.shareUrl=@" ";
    QQApiNewsObject *txtObj =[QQApiNewsObject objectWithURL:[NSURL URLWithString:obj_pic.rendreingsPath] title:@"屋托邦精选方案" description:descName.text previewImageURL:[NSURL URLWithString:obj_pic.shareUrl]];
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
    message.text = @"屋托邦精选方案";
    
    //    WBImageObject *image = [WBImageObject object];
    //    image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj_effect.imagePath]];
    //    message.imageObject = image;
    
    //分享图片
    if(obj_pic.shareUrl==nil) obj_pic.shareUrl=@" ";
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = [NSString stringWithFormat:@"%@",@"11111"];
    webpage.title = @"屋托邦精选方案";
    webpage.description = descName.text;
    webpage.thumbnailData = UIImageJPEGRepresentation([self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj_pic.rendreingsPath]]]scaleToSize:CGSizeMake(100, 100)],0.06);
    webpage.webpageUrl =obj_pic.shareUrl;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
