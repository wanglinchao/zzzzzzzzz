//
//  EffectPictureInfo.m
//  IDIAI
//
//  Created by iMac on 14-7-29.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "EffectPictureInfo.h"
#import "HexColor.h"
#import "UIImageView+OnlineImage.h"
#import "TLToast.h"
#import "IDIAI3DesignerDetailViewController.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "TLToast.h"
#import "ImageZoomView.h"
#import "SVProgressHUD.h"
#import "savelogObj.h"
#import "MRZoomScrollView.h"
#import "SharePcitureView.h"
#import "IDIAIAppDelegate.h"
#import "UIImageView+LBBlurredImage.h"
#import "util.h"
#import "LoginView.h"
#define KUIButton_TAG 100
@interface EffectPictureInfo ()<SharePicViewDelegate>  {
    
    DesignerInfoObj *_obj;
    UIView *bottom_bg;
}

@property (nonatomic,strong) UIImageView *imageview_big;
@property (nonatomic,strong) UIButton *btn_love;
//@property (nonatomic,strong) UIButton *btn_designer;
@property (nonatomic,strong) UILabel *lable_love;
@property (nonatomic,strong) UIView *view_top;
@property (nonatomic,strong) UIView *view_bottom;
@property (nonatomic,strong) UIView *view_download;

@end

@implementation EffectPictureInfo
@synthesize obj_effect,img_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.nav setNavigationBarHidden:YES animated:NO];
}

-(void)backTouched{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)CreateBottomBG{
    
    bottom_bg=[[UIView alloc]initWithFrame:CGRectMake( 0, kMainScreenHeight-50, kMainScreenWidth, 50)];
    bottom_bg.backgroundColor=[UIColor blackColor];
    bottom_bg.alpha=0.35;
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
    if([obj_effect.browserNum integerValue]>=100000000)
        lab_brown.text=[NSString stringWithFormat:@"%.1f亿",[obj_effect.browserNum floatValue]/100000000.0];
    else if([obj_effect.browserNum integerValue]>=10000)
        lab_brown.text=[NSString stringWithFormat:@"%.1f万",[obj_effect.browserNum floatValue]/10000.0];
    else
        lab_brown.text=[NSString stringWithFormat:@"%ld",(long)[obj_effect.browserNum integerValue]];
    
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
        if([obj_effect.browserNum integerValue]>=10000)
            lab_brown.text=[NSString stringWithFormat:@"%.1f万",([obj_effect.browserNum floatValue]+1)/10000.0];
        else
            lab_brown.text=[NSString stringWithFormat:@"%ld",(long)[obj_effect.browserNum integerValue]+1];
        obj_effect.browserNum=[NSString stringWithFormat:@"%ld",(long)[obj_effect.browserNum integerValue]+1];
        
        imv_ll.transform = CGAffineTransformMakeScale(1.35, 1.35);
        [UIView animateWithDuration:0.4 animations:^(void){
            imv_ll.transform = CGAffineTransformMakeScale(0.6, 0.6);
        }completion:^(BOOL finished){
            imv_ll.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }];
/***********************************************/
    
//    NSArray *img_arr=[NSArray arrayWithObjects:@"ic_fenxiang",@"ic_xiazai",@"ic_shoucang_nor", nil];
    NSArray *img_arr=[NSArray arrayWithObjects:@"ic_fenxiang",@"ic_shoucang_nor", nil];
    for (int i=0; i<[img_arr count]; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-100+i*50, kMainScreenHeight-45, 50, 40)];
        btn.tag=KUIButton_TAG+i;
        [btn setImage:[UIImage imageNamed:[img_arr objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(Pressbtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view  addSubview:btn];
    }
    
    UIButton *btn_sc=(UIButton *)[self.view viewWithTag:KUIButton_TAG+1];
//    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* doc_path_ = [path_ objectAtIndex:0];
//    NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:@"MyeffectPicture.plist"];
//    NSMutableArray *Arr_=[NSMutableArray arrayWithContentsOfFile:_filename_];
//    if (!Arr_) {
//        Arr_=[NSMutableArray arrayWithCapacity:0];
//    }
//    if([Arr_ count]){
//        for(NSDictionary *dict in Arr_){
            if([obj_effect.objId integerValue]==[obj_effect.picture_id integerValue]){
                [btn_sc setImage:[UIImage imageNamed:@"ic_shoucang"] forState:UIControlStateNormal];
                btn_sc.selected=YES;
//                break;
            }
            else{
                [btn_sc setImage:[UIImage imageNamed:@"ic_shoucang_nor"] forState:UIControlStateNormal];
                btn_sc.selected=NO;
            }
//        }
//    }
//    else{
//        [btn_sc setImage:[UIImage imageNamed:@"ic_shoucang_nor"] forState:UIControlStateNormal];
//         btn_sc.selected=NO;
//    }
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
//    else if (sender.tag==KUIButton_TAG+1){
//        
//        dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(parsingQueue, ^{
//            UIImage *img;
//            if([obj_effect.rendreingsPath length]>1)
//                img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj_effect.rendreingsPath]]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);//保存图片到相册中，需要回调方法或者检验是否存入成功：
//            });
//        });
//    }
    else{
        UIButton *btn_sc=(UIButton *)[self.view viewWithTag:KUIButton_TAG+1];
        if(btn_sc.selected==NO){
            [MobClick event:@"Click_XGcase_detail_collect"];   //友盟自定义事件,数量统计
            [savelogObj saveLog:@"收藏--效果图" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:9];
            [self collectionAction:btn_sc];
//            [btn_sc setImage:[UIImage imageNamed:@"ic_shoucang"] forState:UIControlStateNormal];
//            btn_sc.selected=YES;
//            
//            
//            
//            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString* doc_path = [path objectAtIndex:0];
//            NSString* _filename = [doc_path stringByAppendingPathComponent:@"MyeffectPicture.plist"];
//            NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename];
//            if (!arr_) {
//                arr_=[NSMutableArray arrayWithCapacity:0];
//            }
//            NSMutableDictionary *dict_=[[NSMutableDictionary alloc]initWithCapacity:0];
//            if(obj_effect.browserNum!=nil)
//                [dict_ setObject:obj_effect.browserNum forKey:@"browserNum"];
//            if (obj_effect.collectionNum != nil) {
//                [dict_ setObject:obj_effect.collectionNum forKey:@"collectionNum"];
//            }
//            
//            if (obj_effect.collectionNum != nil) {
//                [dict_ setObject:obj_effect.collectionNum forKey:@"collectionNum"];
//            }
//            
//            if(obj_effect.designerName!=nil)
//                [dict_ setObject:obj_effect.designerName forKey:@"designerName"];
//            if(obj_effect.designerImagePath!=nil)
//                [dict_ setObject:obj_effect.designerImagePath forKey:@"designerImagePath"];
//            if(obj_effect.imagePath!=nil)
//                [dict_ setObject:obj_effect.imagePath forKey:@"imagePath"];
//            if(obj_effect.picture_id!=nil)
//                [dict_ setObject:obj_effect.picture_id forKey:@"id"];
//            if(obj_effect.designerID!=nil)
//                [dict_ setObject:obj_effect.designerID forKey:@"designerID"];
//            
//            if(obj_effect.frameName!=nil)
//                [dict_ setObject:obj_effect.frameName forKey:@"frameName"];
//            if(obj_effect.description_!=nil)
//                [dict_ setObject:obj_effect.description_ forKey:@"description"];
//            
//            [dict_ setObject:@"1" forKey:@"PictureType"];
//            [arr_ addObject:dict_];
//            [arr_ writeToFile:_filename atomically:NO];
//            
//            [self requestCollectionNum];
        }
        else{
            [self collectionAction:btn_sc];
//            [btn_sc setImage:[UIImage imageNamed:@"ic_shoucang_nor"] forState:UIControlStateNormal];
//            btn_sc.selected=NO;
//            
//            [SVProgressHUD showSuccessWithStatus:@"取消收藏成功" duration:1.0];
//            
//            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString* doc_path = [path objectAtIndex:0];
//            NSString* _filename = [doc_path stringByAppendingPathComponent:@"MyeffectPicture.plist"];
//            NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename];
//            if (!arr_) {
//                arr_=[NSMutableArray arrayWithCapacity:0];
//            }
//            for(NSDictionary *dict in arr_){
//                if([[dict objectForKey:@"id"] integerValue]==[obj_effect.picture_id integerValue]){
//                    [arr_ removeObject:dict];
//                    break;
//                }
//                else
//                    continue;
//            }
//            [arr_ writeToFile:_filename atomically:NO];
        }
    }
}
-(void)collectionAction:(UIButton *)iscollect{
    [self startRequestWithString:@"收藏中..."];
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
        
        NSDictionary *bodyDic = @{@"objId":[NSNumber numberWithInt:[obj_effect.picture_id intValue]],@"isCollection":[NSNumber numberWithInt:!iscollect.selected],@"objType":[NSNumber numberWithInt:1]};
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
                            obj_effect.objId=obj_effect.picture_id;
                            [TLToast showWithText:@"收藏成功"];
                            [iscollect setImage:[UIImage imageNamed:@"ic_shoucang"] forState:UIControlStateNormal];
                            iscollect.selected =YES;
                            [self requestCollectionNum];
                            if (self.delegate && [self.delegate respondsToSelector:@selector(picDidCollect:collectNum:cell:)]) {
                                [self.delegate picDidCollect:self collectNum:self.collectionNum cell:self.cell];
                            }
                            
                        }else{
                            obj_effect.objId=@"0";
                            [TLToast showWithText:@"取消收藏成功"];
                            [iscollect setImage:[UIImage imageNamed:@"ic_shoucang_nor"] forState:UIControlStateNormal];
                            iscollect.selected =NO;
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
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error==nil) {
        [TLToast showWithText:@"保存至相册成功" topOffset:220.0f duration:1.0];
    }else {
        [TLToast showWithText:@"保存至相册失败" topOffset:220.0f duration:1.0];
    }
}

-(void)SharePicCustomclickedButtonAtIndex:(NSInteger)buttonIndex{
    [savelogObj saveLog:@"分享效果图" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:28];
    [MobClick event:@"Click_XGcase_detail_share"];   //友盟自定义事件,数量统计
    
    if(buttonIndex==0){
        if([WXApi isWXAppInstalled])
            [self sendTextContentToWX:1];
        else
            [TLToast showWithText:@"请先安装微信客户端" topOffset:220.0 duration:1.5];
    }
    else if(buttonIndex==1){
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [MobClick event:@"Click_XGcase_detail"];   //友盟自定义事件,数量统计
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor blackColor];
    
    [savelogObj saveLog:@"查看效果图" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:13];
    
    self.imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    self.imageView.contentMode=UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds=YES;
    [self.view addSubview:self.imageView];
    UIView *view_=[[UIView alloc]initWithFrame:self.view.bounds];
    view_.backgroundColor=[UIColor blackColor];
    view_.alpha=0.6;
    [self.view addSubview:view_];
     __block EffectPictureInfo *weakself=self;
    [self.imageView setImageToBlur:img_
                        blurRadius:kLBBlurredImageDefaultBlurRadius
                   completionBlock:^(NSError *error){
                       [weakself loadMainTing];
                   }];
    
}

-(void)loadMainTing{
    [self requestDesignerDetailInfo];
    [self requestBrower];
    
    UIActivityIndicatorView *activ=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activ.center= CGPointMake(kMainScreenWidth/2, kMainScreenHeight/2);
    [self.view addSubview:activ];
    [activ startAnimating]; // 开始旋转
    [activ setHidesWhenStopped:YES]; //当旋转结束时隐藏
    
    MRZoomScrollView *_zoomScrollView = [[MRZoomScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    [self.view addSubview:_zoomScrollView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80,80)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui_b.png"] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake( 0, 10, 0, 40)];
    [leftButton addTarget:self
                   action:@selector(backTouched)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj_effect.imagePath]];
        UIImage *img = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(img){
                _zoomScrollView.contentSize=CGSizeMake(img.size.width, kMainScreenHeight);
                float height=0.01;
                if(img){
                    height=(img.size.height*kMainScreenWidth)/img.size.width;
                    //根据图片比例显示在屏幕中央位置
                    //_zoomScrollView.imageView.frame=CGRectMake(0,(kMainScreenHeight-height)/2, kMainScreenWidth, height);
                    //将图片全屏展示
                    _zoomScrollView.imageView.frame=CGRectMake(0,0, img.size.width, kMainScreenHeight);
                    _zoomScrollView.imageView.image=img;
                }
                [activ stopAnimating];
                [activ removeFromSuperview];
                
                [self CreateBottomBG];
                
                UILabel *picture_style= [[UILabel alloc] initWithFrame:CGRectMake(20, kMainScreenHeight-100, kMainScreenWidth-40, 20)];
                picture_style.backgroundColor = [UIColor clearColor];
                picture_style.font = [UIFont systemFontOfSize:15.0];
                picture_style.textAlignment = NSTextAlignmentLeft;
                picture_style.textColor = [UIColor whiteColor];
                picture_style.text=obj_effect.frameName;
                [self.view addSubview:picture_style];
                
                CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",obj_effect.description_] width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:17.0]];
                UILabel *picture_desc= [[UILabel alloc] initWithFrame:CGRectMake(20, picture_style.frame.origin.y-size.height-10, kMainScreenWidth-40, size.height)];
                picture_desc.backgroundColor = [UIColor clearColor];
                picture_desc.font = [UIFont systemFontOfSize:17.0];
                picture_desc.textAlignment = NSTextAlignmentLeft;
                picture_desc.textColor = [UIColor whiteColor];
                picture_desc.numberOfLines=4;
                picture_desc.text=obj_effect.description_;
                [self.view addSubview:picture_desc];
                
                if([obj_effect.designerID integerValue]!=0){
                    UIImageView *designer_logo=[[UIImageView alloc]initWithFrame:CGRectMake(20, picture_desc.frame.origin.y-70, 50, 50)];
                    [designer_logo setOnlineImage:obj_effect.designerImagePath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over"]];
                    designer_logo.layer.cornerRadius=25.0;
                    designer_logo.layer.masksToBounds=YES;
                    [self.view addSubview:designer_logo];
                    
                    UILabel *designerName= [[UILabel alloc] initWithFrame:CGRectMake(85, picture_desc.frame.origin.y-60, 150, 30)];
                    designerName.backgroundColor = [UIColor clearColor];
                    designerName.font = [UIFont systemFontOfSize:18.0];
                    designerName.textAlignment = NSTextAlignmentLeft;
                    designerName.textColor = [UIColor whiteColor];
                    designerName.text=obj_effect.designerName;
                    [self.view addSubview:designerName];
                    
                    UIButton *into_designer=[[UIButton alloc]initWithFrame:CGRectMake(20, picture_desc.frame.origin.y-70, 100, 50)];
                    [into_designer addTarget:self action:@selector(GoIntoDesigner) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:into_designer];
                }
                
            }
            else{
                self.imageview_big=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_morentu_tuku.png"]];
                self.imageview_big.userInteractionEnabled=NO;
                [self.view addSubview:self.imageview_big];
                self.imageview_big.center = self.view.window.center;
                
                [activ stopAnimating];
                [activ removeFromSuperview];
                [TLToast showWithText:@"亲，美图加载失败哟！" topOffset:220.0f duration:1.0];
                
                [self CreateBottomBG];
                
                UILabel *picture_style= [[UILabel alloc] initWithFrame:CGRectMake(20, kMainScreenHeight-100, kMainScreenWidth-40, 20)];
                picture_style.backgroundColor = [UIColor clearColor];
                picture_style.font = [UIFont systemFontOfSize:15.0];
                picture_style.textAlignment = NSTextAlignmentLeft;
                picture_style.textColor = [UIColor whiteColor];
                picture_style.text=obj_effect.frameName;
                [self.view addSubview:picture_style];
                
                CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",obj_effect.description_] width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:17.0]];
                UILabel *picture_desc= [[UILabel alloc] initWithFrame:CGRectMake(20, picture_style.frame.origin.y-size.height-10, kMainScreenWidth-40, size.height)];
                picture_desc.backgroundColor = [UIColor clearColor];
                picture_desc.font = [UIFont systemFontOfSize:17.0];
                picture_desc.textAlignment = NSTextAlignmentLeft;
                picture_desc.textColor = [UIColor whiteColor];
                picture_desc.numberOfLines=4;
                picture_desc.text=obj_effect.description_;
                [self.view addSubview:picture_desc];
                
                if([obj_effect.designerID integerValue]!=0){
                    UIImageView *designer_logo=[[UIImageView alloc]initWithFrame:CGRectMake(20, picture_desc.frame.origin.y-70, 50, 50)];
                    [designer_logo setOnlineImage:obj_effect.designerImagePath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over"]];
                    designer_logo.layer.cornerRadius=25.0;
                    designer_logo.layer.masksToBounds=YES;
                    [self.view addSubview:designer_logo];
                    
                    UILabel *designerName= [[UILabel alloc] initWithFrame:CGRectMake(85, picture_desc.frame.origin.y-60, 150, 30)];
                    designerName.backgroundColor = [UIColor clearColor];
                    designerName.font = [UIFont systemFontOfSize:18.0];
                    designerName.textAlignment = NSTextAlignmentLeft;
                    designerName.textColor = [UIColor whiteColor];
                    designerName.text=obj_effect.designerName;
                    [self.view addSubview:designerName];
                    
                    UIButton *into_designer=[[UIButton alloc]initWithFrame:CGRectMake(20, picture_desc.frame.origin.y-70, 100, 50)];
                    [into_designer addTarget:self action:@selector(GoIntoDesigner) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:into_designer];
                }
                
            }
        });
    });
}

-(void)GoIntoDesigner{
    [MobClick event:@"Click_XGcase_detail_desginer"];   //友盟自定义事件,数量统计
    IDIAI3DesignerDetailViewController *infovc = [[IDIAI3DesignerDetailViewController alloc]init];
    infovc.obj = _obj;
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.nav pushViewController:infovc animated:YES];
//    [self.navigationController pushViewController:infovc animated:YES];
    
}

#pragma mark -
#pragma mark - Weixin related
- (void)sendTextContentToWX:(NSInteger)type {
    //分享图片
    if(obj_effect.shareUrl==nil) obj_effect.shareUrl=@" ";
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =@"屋托邦精选效果图";
    message.description =obj_effect.description_;
    message.thumbData = UIImageJPEGRepresentation([self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj_effect.rendreingsPath]]]scaleToSize:CGSizeMake(100, 100)],0.06);
    
//    WXImageObject *obj=[WXImageObject object];
//    obj.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:obj_effect.shareUrl]];
//    message.mediaObject=obj;
    
    WXWebpageObject *obj=[WXWebpageObject object];
    obj.webpageUrl=obj_effect.shareUrl;
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
    if(obj_effect.shareUrl==nil) obj_effect.shareUrl=@" ";
    QQApiNewsObject *txtObj =[QQApiNewsObject objectWithURL:[NSURL URLWithString:obj_effect.shareUrl] title:@"屋托邦精选效果图" description:obj_effect.description_ previewImageData:UIImageJPEGRepresentation([self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj_effect.imagePath]]]scaleToSize:CGSizeMake(100, 100)],0.06)];
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
     message.text = @"屋托邦精选效果图";
    
//    WBImageObject *image = [WBImageObject object];
//    image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj_effect.imagePath]];
//    message.imageObject = image;
    
    if(obj_effect.shareUrl==nil) obj_effect.shareUrl=@" ";
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = [NSString stringWithFormat:@"%@",obj_effect.picture_id];
    webpage.title = @"屋托邦精选效果图";
    webpage.description = obj_effect.description_;
    webpage.thumbnailData = UIImageJPEGRepresentation([self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj_effect.imagePath]]]scaleToSize:CGSizeMake(100, 100)],0.06);
    webpage.webpageUrl =obj_effect.shareUrl;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

-(void)RequestDianz{
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0020" forKey:@"cmdID"];
        [postDict setObject:@"" forKey:@"token"];
        [postDict setObject:@"" forKey:@"userID"];
        [postDict setObject:@"iOS" forKey:@"deviceType"];
        NSString *string=[postDict JSONString];
        
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:@"2" forKey:@"operateID"];
        [postDict02 setObject:[NSString stringWithFormat:@"%@",obj_effect.picture_id] forKey:@"ID"];
        NSString *string02=[postDict02 JSONString];
        
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
               // NSLog(@"返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[jsonDict objectForKey:@"resCode"] integerValue]==10221) {
                        //本地标记效果图已经被点赞过
                        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString* doc_path = [path objectAtIndex:0];
                        NSString* _filename = [doc_path stringByAppendingPathComponent:@"Somepraise_picture.plist"];
                        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
                        if (!dict) {
                            dict=[NSMutableDictionary dictionary];
                        }
                        [dict setObject:@"1" forKey:[NSString stringWithFormat:@"%@",obj_effect.picture_id]];
                        [dict writeToFile:_filename atomically:NO];
                        
                        //刷新本地收藏效果图的点赞数
                        NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString* doc_path_ = [path_ objectAtIndex:0];
                        NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:@"MyeffectPicture.plist"];
                        NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename_];
                        if (!arr_) {
                            arr_=[NSMutableArray arrayWithCapacity:0];
                        }
                        if([arr_ count]){
                            for (int i=0; i<[arr_ count]; i++) {
                                @autoreleasepool {
                                NSMutableDictionary *dict_=[arr_ objectAtIndex:i];
                                if([[dict_ objectForKey:@"id"] integerValue]==[obj_effect.picture_id integerValue]){
                                    //[dict_ setObject:obj_effect.imagePoints forKey:@"imagePoints"];
                                    [arr_ replaceObjectAtIndex:i withObject:dict_];
                                    break;
                                    }
                                }
                            }
                        }
                        [arr_ writeToFile:_filename_ atomically:NO];
                    }
                    else if([[jsonDict objectForKey:@"resCode"] integerValue]==10229){
                       //obj_effect.imagePoints=[NSString stringWithFormat:@"%d",[self.lable_love.text integerValue]-1];
                    }
                    else {
                        //obj_effect.imagePoints=[NSString stringWithFormat:@"%d",[self.lable_love.text integerValue]-1];
                    }
                    
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  //obj_effect.imagePoints=[NSString stringWithFormat:@"%d",[self.lable_love.text integerValue]-1];
                              });
                          }
                               method:url postDict:post];
    });
    
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0021\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"designerID\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,kCityCode, obj_effect.designerID];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                //NSLog(@"行政区号：返回信息：%@",jsonDict);
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0038\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeID\":\"5\",\"objectID\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,kCityCode,obj_effect.picture_id];
        
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
                if (code==10381) {
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0039\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeID\":\"5\",\"objectID\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,kCityCode,obj_effect.picture_id];
        
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
                if (code==10391) {
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


@end
