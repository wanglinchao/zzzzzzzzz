//
//  BusinessInfoVC.m
//  IDIAI
//
//  Created by iMac on 14-7-30.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "BusinessInfoVC.h"
#import "HexColor.h"
#import "util.h"
#import "CustomScrollView.h"
#import "NetworkRequest.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import "TextUILable.h"
#import "GoodsShowinMapVC.h"
#import "PicturesShowVC.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+OnlineImage.h"
#import "TLToast.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "SVProgressHUD.h"
#import "savelogObj.h"
#import "util.h"
#import "UIScrollView+TwitterCover.h"
#import "OpenUDID.h"
#import "CommentsView.h"
#import "UIImageView+WebCache.h"

#define KButtonTag 100
#define Kcelltag 1000
@interface BusinessInfoVC ()<CustomScrollViewDelegate,LoginViewDelegate,CommentsViewDelegate>{
    UIView *_topView;//顶部图片之上的view
       CommentsView *comment;
}

@property (nonatomic , strong) CustomScrollView *mainScorllView;
@property (nonatomic,strong) UIImageView *imageview_photo;
@property (nonatomic,strong) UILabel *business_name;
@property (nonatomic,strong) UILabel *business_express;
@property (nonatomic,strong) UILabel *business_distance;
@property (nonatomic,strong) TextUILable *lab_address;

@property (nonatomic,strong) UIButton *btn_shouc;
@property (nonatomic,strong) UIButton *btn_phone;
@property (nonatomic,strong) UIImageView *imv_zkai;
@property (nonatomic,strong) UIImageView *imv_zkai_seond;

@property (assign, nonatomic) NSInteger numberStart;
@property (strong, nonatomic) NSMutableArray *imageViewArray;
@property (strong, nonatomic) UIView *startView;
@property (nonatomic , strong) UIPageControl *pagectr;
@property (nonatomic , strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic , strong) UILabel *lab_score;
@property (nonatomic , strong) UIButton *btn_wyp;
@property (nonatomic , assign) float lastContentOffset; //判断UITableView的滑动值；
@end

@implementation BusinessInfoVC
@synthesize obj,lab_score,btn_wyp;

-(void)dealloc{
   [[NSNotificationCenter defaultCenter]removeObserver:self name:@"business_tap" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.startView removeGestureRecognizer:self.panGesture];
    [mtableview removeTwitterCoverView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapPicture:) name:@"business_tap" object:nil];
    }
    return self;
}

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    
    UIColor *color = [UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = image;
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor whiteColor];
    //lab_nav_title.text=@"商家信息";
    self.navigationItem.titleView = lab_nav_title;

    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path_ = [path_ objectAtIndex:0];
    NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:@"MybusinessCollect.plist"];
    NSMutableArray *Arr_=[NSMutableArray arrayWithContentsOfFile:_filename_];
    if (!Arr_) {
        Arr_=[NSMutableArray arrayWithCapacity:0];
    }
    self.btn_shouc = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_shouc.frame=CGRectMake(270, 25, 30, 30);
    if([Arr_ count]){
        for(NSDictionary *dict in Arr_){
            if([[dict objectForKey:@"shopId"] integerValue]==[obj.shopID integerValue]){
                [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang"] forState:UIControlStateNormal];
                self.btn_shouc.selected=YES;
                break;
            }
            else{
                [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_nor"] forState:UIControlStateNormal];
                self.btn_shouc.selected=NO;
            }
        }
    }
    else{
        [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_nor"] forState:UIControlStateNormal];
        self.btn_shouc.selected=NO;
    }
    self.btn_shouc.tag=1001;
    [self.btn_shouc addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn_shouc];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}

-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)PressBarItemRight{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self customizeNavigationBar];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:[UIView class]]&&view.tag == 10001) {
            [view removeFromSuperview];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
   // for(UIView *view in self.mainScorllView.subviews) [view removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.count_first=1;
    self.count_second=0;
    is_open_first=YES;
    is_change=YES;
    self.currentPage=0;
    self.data_array=[NSMutableArray arrayWithCapacity:0];
    _imageViewArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    mtableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-40) style:UITableViewStyleGrouped];
    mtableview.delegate=self;
    mtableview.dataSource=self;
    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mtableview];
    
    obj.shopBrowsePoints=[NSString stringWithFormat:@"%d",[obj.shopBrowsePoints integerValue]+1];
    [self requestBrower];
    
    [self createHeader];
    
    [self createPhone];
    
    is_login_px=NO;
    //创建评论栏
    [self createPL];
    
    [self requestCommentsList];
}

-(void)createPL{
    UIView *view_pl=[[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-64-40, kMainScreenWidth, 40)];
    view_pl.backgroundColor=[UIColor colorWithHexString:@"#F7F7F7" alpha:1.0];
    view_pl.layer.borderColor = [[UIColor colorWithHexString:@"#EBEBEB" alpha:1.0] CGColor];
    view_pl.layer.borderWidth = 0.5f;
    [self.view addSubview:view_pl];
    
    btn_wyp=[UIButton buttonWithType:UIButtonTypeCustom];
    btn_wyp.frame=CGRectMake(15, 5, kMainScreenWidth-30, 30);
    //给按钮加一个白色的板框
    btn_wyp.layer.borderColor = [[UIColor colorWithHexString:@"#EBEBEB" alpha:1.0] CGColor];
    btn_wyp.layer.borderWidth = 0.5f;
    //给按钮设置弧度,这里将按钮变成了圆形
    btn_wyp.layer.cornerRadius = 15.0f;
    btn_wyp.layer.masksToBounds = YES;
    btn_wyp.backgroundColor=[UIColor whiteColor];
    [btn_wyp setTitle:@"我要评" forState:UIControlStateNormal];
    [btn_wyp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn_wyp.titleLabel.font=[UIFont systemFontOfSize:13];
    [btn_wyp setImage:[UIImage imageNamed:@"contenttoolbar_hd_comment_light"] forState:UIControlStateNormal];
    [btn_wyp setImage:[UIImage imageNamed:@"contenttoolbar_hd_comment_light"] forState:UIControlStateHighlighted];
    btn_wyp.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, kMainScreenWidth-30-80);
    btn_wyp.imageEdgeInsets=UIEdgeInsetsMake(5, 15, 5, kMainScreenWidth-30-35);
    [btn_wyp addTarget:self action:@selector(myappraise) forControlEvents:UIControlEventTouchUpInside];
    [view_pl addSubview:btn_wyp];
}


-(void)createPhone{
    self.btn_phone = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_phone.frame=CGRectMake(kMainScreenWidth-50, kMainScreenHeight-250, 50, 50);
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh_mor.png"] forState:UIControlStateNormal];
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh.png"] forState:UIControlStateHighlighted];
    self.btn_phone.tag=1003;
    [self.btn_phone addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn_phone ];
    
    UIPanGestureRecognizer *pan_search = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragToSearch:)];
    [pan_search setMinimumNumberOfTouches:1];
    [pan_search setMaximumNumberOfTouches:1];
    [self.btn_phone addGestureRecognizer:pan_search];
}

- (void)dragToSearch:(UIPanGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gr locationInView:self.view];
        self.btn_phone.center = point;
        if (gr.state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:0.18 animations:^{
                if (point.x<(kMainScreenWidth/2)) self.btn_phone.frame=CGRectMake(0, point.y-25, 50, 50);
                else self.btn_phone.frame=CGRectMake(kMainScreenWidth-50, point.y-25, 50, 50);
                
                if(point.y<25){
                    if(point.x<50) self.btn_phone.frame=CGRectMake(0, 0, 50, 50);
                    else self.btn_phone.frame=CGRectMake(point.x-50, 0, 50, 50);
                }
            }];
        }
    }
}

-(void)createHeader{
   [mtableview addTwitterCoverWithImage:[util imageWithColor:kThemeColor] withTopView:_topView];
    UIView *view_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, CHTwitterCoverViewHeight + _topView.bounds.size.height+60)];
    view_header.backgroundColor = kThemeColor;

    CGSize size=[util calHeightForLabel:obj.shopName width:200 font:[UIFont systemFontOfSize:18]];
    self.business_name = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-200)/2, 110, 200, size.height)];
    self.business_name.backgroundColor = [UIColor clearColor];
    self.business_name.font = [UIFont systemFontOfSize:18.0];
    self.business_name.textAlignment = NSTextAlignmentCenter;
    self.business_name.numberOfLines=0;
    self.business_name.textColor = [UIColor whiteColor];
    self.business_name.text =obj.shopName;
    [view_header addSubview:self.business_name];
    
    self.business_express = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-200)/2, 100+size.height+5, 200, 20)];
    self.business_express.backgroundColor = [UIColor clearColor];
    self.business_express.font = [UIFont systemFontOfSize:16.0];
    self.business_express.textAlignment = NSTextAlignmentCenter;
    self.business_express.numberOfLines=1;
    self.business_express.textColor = [UIColor whiteColor];
    self.business_express.text =obj.shopAddress;
    //[view_header addSubview:self.business_express];
    
    UIView *authen_view=[[UIView alloc]initWithFrame:CGRectMake(0, 100+size.height+25, kMainScreenWidth, 60)];
    authen_view.backgroundColor=[UIColor whiteColor];
    [view_header addSubview:authen_view];
    if([obj.arr_rztype count]){
        NSArray *arr_name=[NSArray arrayWithObjects:@"身份认证",@"折扣认证",@"特卖认证",@"工长认证",@"企业认证", nil];
        for(int i=0;i<[obj.arr_rztype count];i++){
            @autoreleasepool {
            NSDictionary *dict=[obj.arr_rztype objectAtIndex:i];
            UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth/([obj.arr_rztype count]+1))*i+((kMainScreenWidth/([obj.arr_rztype count]+1))-30)/2, 5, 30, 30)];
                image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_b_%@.png",[dict objectForKey:@"authzId"]]];
            [authen_view addSubview:image_rz];
            
            UILabel *lab_rz = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth/([obj.arr_rztype count]+1))*i+((kMainScreenWidth/([obj.arr_rztype count]+1))-40)/2, 35, 40, 20)];
            lab_rz.backgroundColor = [UIColor clearColor];
            lab_rz.font = [UIFont systemFontOfSize:10.0];
            lab_rz.textAlignment = NSTextAlignmentCenter;
            lab_rz.textColor = [UIColor grayColor];
            lab_rz.text =[arr_name objectAtIndex:[[dict objectForKey:@"authzId"] integerValue]-1];
            [authen_view addSubview:lab_rz];
             
                UIView *line=[[UIView alloc]initWithFrame:CGRectMake((kMainScreenWidth/([obj.arr_rztype count]+1))*(i+1), 10, 0.5, 35)];
                line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
                [authen_view addSubview:line];
                
                if(i==[obj.arr_rztype count]-1){
                    //创建关注
                    UIImageView *image_gz=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_guanzhu_b"]];
                    image_gz.frame=CGRectMake((kMainScreenWidth/([obj.arr_rztype count]+1))*(i+1)+((kMainScreenWidth/([obj.arr_rztype count]+1))-30)/2, 5, 30, 30);
                    [authen_view addSubview:image_gz];
                    
                    UILabel *lab_gz = [[UILabel alloc] init];
                    lab_gz.frame=CGRectMake((kMainScreenWidth/([obj.arr_rztype count]+1))*(i+1)+((kMainScreenWidth/([obj.arr_rztype count]+1))-80)/2, 35, 80, 20);
                    lab_gz.backgroundColor = [UIColor clearColor];
                    lab_gz.font = [UIFont systemFontOfSize:10.0];
                    lab_gz.textAlignment = NSTextAlignmentCenter;
                    lab_gz.textColor = [UIColor grayColor];
                    lab_gz.text =[NSString stringWithFormat:@"关注%@",obj.shopBrowsePoints];
                    [authen_view addSubview:lab_gz];
                }
            }
        }
    }
    else{
        //创建关注
        UIImageView *image_gz=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_guanzhu_b"]];
        image_gz.frame=CGRectMake((kMainScreenWidth-30)/2, 5, 30, 30);
        [authen_view addSubview:image_gz];
        
        UILabel *lab_gz = [[UILabel alloc] init];
        lab_gz.frame=CGRectMake((kMainScreenWidth-80)/2, 35, 80, 20);
        lab_gz.backgroundColor = [UIColor clearColor];
        lab_gz.font = [UIFont systemFontOfSize:10.0];
        lab_gz.textAlignment = NSTextAlignmentCenter;
        lab_gz.textColor = [UIColor grayColor];
        lab_gz.text =[NSString stringWithFormat:@"关注%@",obj.shopBrowsePoints];
        [authen_view addSubview:lab_gz];
    }
    
    self.imageview_photo=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-80)/2, 10, 80, 80)];
    self.imageview_photo.layer.cornerRadius=40;
    self.imageview_photo.layer.masksToBounds=YES;
    self.imageview_photo.clipsToBounds = YES;
    [self.imageview_photo setOnlineImage:obj.shopLogoPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
    //self.imageview_photo.image=[UIImage imageNamed:@"效果图大图设计师默认图标.png"];
    [view_header addSubview:self.imageview_photo];
    
//    UIButton *map_Button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [map_Button setFrame:CGRectMake(260, 115+size.height, 40, 40)];
//    [map_Button setBackgroundImage:[UIImage imageNamed:@"地图按钮.png"] forState:UIControlStateNormal];
//    [map_Button setBackgroundImage:[UIImage imageNamed:@"地图点击效果.png"] forState:UIControlStateHighlighted];
//    [map_Button addTarget:self
//                   action:@selector(pressMap:)
//         forControlEvents:UIControlEventTouchUpInside];
//    [view_header addSubview:map_Button];
    
    view_header.frame=CGRectMake(0, 0, kMainScreenWidth, 120+size.height+65);
    mtableview.tableHeaderView=view_header;
}

-(void)scrollviewToCurrent:(NSInteger)index{
    self.selected_picture=index;
    self.lab_count.text=[NSString stringWithFormat:@"%d/%d",index+1,[obj.arr_picture count]];
}

-(void)tapImage:(UIGestureRecognizer *)gers{
    PicturesShowVC *picvc=[[PicturesShowVC alloc]init];
    picvc.data_array=obj.arr_picture;
    picvc.type_pic=@"business";
    picvc.pic_id=self.selected_picture;
    [self.navigationController pushViewController:picvc animated:YES];
}

-(void)tapPicture:(NSNotification *)notif{
    PicturesShowVC *picvc=[[PicturesShowVC alloc]init];
    picvc.data_array=obj.arr_picture;
    picvc.type_pic=@"business";
    picvc.pic_id=self.selected_picture;
    [self.navigationController pushViewController:picvc animated:YES];
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0037\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeId\":\"2\",\"objectId\":\"%@\",\"currentPage\":\"%d\",\"requestRow\":\"15\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],obj.shopID,self.currentPage+1];
        
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
                    self.currentPage=[[jsonDict objectForKey:@"currentPage"] integerValue];
                    self.totalPage=[[jsonDict objectForKey:@"totalPage"] integerValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if([arr_pl count]){
                            for(NSDictionary *dict in arr_pl){
                                [self.data_array addObject:dict];
                            }
                        }
                        //一个section刷新
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
//                        [mtableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                        
                        [mtableview reloadData];
                    });
                }
                else if (code==10379) {
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


//发送浏览量
-(void)requestBrower{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0038\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeID\":\"2\",\"objectID\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],obj.shopID];
        
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
//发送收藏量
-(void)requestCollect{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0039\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeID\":\"2\",\"objectID\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],obj.shopID];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"发送收藏量返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10391) {
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

//评价
-(void)requestEvaluationOfStar:(NSString *)title star:(NSInteger)star{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *postDict01 = [[NSMutableDictionary alloc] init];
        [postDict01 setObject:@"ID0004" forKey:@"cmdID"];
        [postDict01 setObject:string_token forKey:@"token"];
        [postDict01 setObject:string_userid forKey:@"userID"];
        [postDict01 setObject:@"ios" forKey:@"deviceType"];
        [postDict01 setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
        NSString *string01=[postDict01 JSONString];
        
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:[NSString stringWithFormat:@"%@",obj.shopID] forKey:@"objectId"];
        [postDict02 setObject:title forKey:@"objectString"];
        [postDict02 setObject:@"2" forKey:@"objectTypeId"];
        if(star%2==0)
            [postDict02 setObject:[NSString stringWithFormat:@"%d",star/2] forKey:@"objectLevel"];
        else
            [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",star/2+0.5] forKey:@"objectLevel"];
        NSString *string02=[postDict02 JSONString];
        
        NSMutableDictionary *req_dict= [[NSMutableDictionary alloc] init];
        [req_dict setObject:string01 forKey:@"header"];
        [req_dict setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"评星：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
               
                //token为空或验证未通过处理 huangrun
                if (kResCode == 10002 || kResCode == 10003) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopRequest];
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    
                });
                    return ;
                }
                
                
                if (code==10041) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSInteger star_level=0;
                        if([[jsonDict objectForKey:@"average"] integerValue]<[[jsonDict objectForKey:@"average"] floatValue])
                            star_level=[[jsonDict objectForKey:@"average"] integerValue]*2+1;
                        else
                            star_level=[[jsonDict objectForKey:@"average"] integerValue]*2;
                        self.numberStart = star_level;
                        [self numberStartReLoad:self.numberStart];
                        //[self.startView removeGestureRecognizer:self.tapGesture];
                        //[self.startView removeGestureRecognizer:self.panGesture];
                        [TLToast showWithText:@"评价成功，感谢您的支持" bottomOffset:220.0f duration:1.0];
                        obj.shopLevel=[jsonDict objectForKey:@"average"];
                        // [[NSNotificationCenter defaultCenter] postNotificationName:@"worker_refresh" object:nil];
                        if([self.data_array count]) [self.data_array removeAllObjects];
                        self.currentPage=0;
                        [self requestCommentsList];
                    });
                }
                else if (code==10042) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，不符合评价的规则" bottomOffset:220.0f duration:1.0];
                    });
                }
                else if (code==10043) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，评价的内容过长" bottomOffset:220.0f duration:1.0];
                        
                    });
                }
                
                else if (code==10049) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                              });
                          }
                               method:url postDict:req_dict];
    });
    
    
}

//发送记录呼叫电话信息
-(void)requestRecordCallinfo{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSMutableDictionary *postDict01 = [[NSMutableDictionary alloc] init];
        [postDict01 setObject:@"ID0032" forKey:@"cmdID"];
        [postDict01 setObject:string_token forKey:@"token"];
        [postDict01 setObject:string_userid forKey:@"userID"];
        [postDict01 setObject:@"ios" forKey:@"deviceType"];
        [postDict01 setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
        NSString *string01=[postDict01 JSONString];
        
        //获取日期时间
        NSDate *senddate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *locationDate=[dateformatter stringFromDate:senddate];
        //获取主叫号码
        NSString *str_calling;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Mobile] length]>2) str_calling=[[NSUserDefaults standardUserDefaults]objectForKey:User_Mobile];
        else str_calling=@"";
        //获取主叫号码编号
        NSString *str_calling_id;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]) str_calling_id=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        else str_calling_id=@"";
        //获取被叫号码
        NSString *str_called;
        if([obj.shopMobileNum length]>2) str_called=obj.shopMobileNum;
        else str_called=@"";
        //获取被叫号码编号
        NSString *str_called_id;
        if([obj.shopID integerValue] >=0) str_called_id=[NSString stringWithFormat:@"%@",obj.shopID];
        else str_called_id=@"";
        //获取设备编号
        NSString *str_uuid=[OpenUDID value];
        
        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
        [postDict02 setObject:str_called forKey:@"calledPhone"];
        [postDict02 setObject:str_called_id forKey:@"calledId"];
        [postDict02 setObject:str_uuid forKey:@"mobileUUID"];
        [postDict02 setObject:str_calling_id forKey:@"callingId"];
        [postDict02 setObject:str_calling forKey:@"callingPhone"];
        [postDict02 setObject:locationDate forKey:@"callingDate"];
        [postDict02 setObject:@"2" forKey:@"calledIdenttityType"];
        NSString *string02=[postDict02 JSONString];
        
        NSMutableDictionary *req_dict= [[NSMutableDictionary alloc] init];
        [req_dict setObject:string01 forKey:@"header"];
        [req_dict setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"电话记录：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10321) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    });
                }
                else if (code==10329) {
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
                               method:url postDict:req_dict];
    });
    
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0){
    UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
    view_.backgroundColor=[UIColor clearColor];
        
    UIView *line_first_header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
    line_first_header.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
    [view_ addSubview:line_first_header];
    
    UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 120, 30)];
    designer_jianj.backgroundColor = [UIColor clearColor];
    designer_jianj.font = [UIFont systemFontOfSize:18.0];
    designer_jianj.textAlignment = NSTextAlignmentLeft;
    designer_jianj.textColor = [UIColor grayColor];
    designer_jianj.text =@"商家简介";
    [view_ addSubview:designer_jianj];
    
    self.imv_zkai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
    self.imv_zkai.frame = CGRectMake(kMainScreenWidth-30, 15, 15
                                     , 20);
    [view_ addSubview:self.imv_zkai];
    if(is_change==YES){
    if(is_open_first){
        CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [spinAnimation setFromValue:[NSNumber numberWithFloat:0]];
        [spinAnimation setToValue:[NSNumber numberWithDouble:M_PI/2]];
        [spinAnimation setDelegate:self];
        [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [spinAnimation setDuration:0.2];
        [self.imv_zkai.layer addAnimation:spinAnimation forKey:@"spin"];
        [self.imv_zkai.layer setTransform:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)];
        }
    else{
        CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [spinAnimation setFromValue:[NSNumber numberWithFloat:M_PI/2]];
        [spinAnimation setToValue:[NSNumber numberWithDouble:0]];
        [spinAnimation setDelegate:self];
        [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [spinAnimation setDuration:0.2];
        [self.imv_zkai.layer addAnimation:spinAnimation forKey:@"spin"];
        [self.imv_zkai.layer setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];
        }
    }
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = CGRectMake(0, 0, kMainScreenWidth, 50);
    headerBtn.tag = 100;
    [headerBtn addTarget:self
                  action:@selector(tapHeader:)
        forControlEvents:UIControlEventTouchUpInside];
    [view_ addSubview:headerBtn];
    
    return view_;
    }
    else if(section==1){
        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
        view_.backgroundColor=[UIColor clearColor];
        
        UIView *line_secon_header=[[UIView alloc]initWithFrame:CGRectMake(20, 0, kMainScreenWidth-20, 0.5)];
        line_secon_header.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        [view_ addSubview:line_secon_header];
        
        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 120, 30)];
        designer_jianj.backgroundColor = [UIColor clearColor];
        designer_jianj.font = [UIFont systemFontOfSize:18.0];
        designer_jianj.textAlignment = NSTextAlignmentLeft;
        designer_jianj.textColor = [UIColor grayColor];
        designer_jianj.text =@"经营范围";
        [view_ addSubview:designer_jianj];
        
        self.imv_zkai_seond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
        self.imv_zkai_seond.frame = CGRectMake(kMainScreenWidth-30, 12, 15, 20);
        [view_ addSubview:self.imv_zkai_seond];
        if(is_change==NO){
        if(is_open_second){
            CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            [spinAnimation setFromValue:[NSNumber numberWithFloat:0]];
            [spinAnimation setToValue:[NSNumber numberWithDouble:M_PI/2]];
            [spinAnimation setDelegate:self];
            [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [spinAnimation setDuration:0.2];
            [self.imv_zkai_seond.layer addAnimation:spinAnimation forKey:@"spin"];
            [self.imv_zkai_seond.layer setTransform:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)];
            
            }
        else{
            CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            [spinAnimation setFromValue:[NSNumber numberWithFloat:M_PI/2]];
            [spinAnimation setToValue:[NSNumber numberWithDouble:0]];
            [spinAnimation setDelegate:self];
            [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [spinAnimation setDuration:0.2];
            [self.imv_zkai_seond.layer addAnimation:spinAnimation forKey:@"spin"];
            [self.imv_zkai_seond.layer setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];
            }
        }
        
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headerBtn.frame = CGRectMake(0, 0, kMainScreenWidth, 50);
        headerBtn.tag = 101;
        [headerBtn addTarget:self
                      action:@selector(tapHeader:)
            forControlEvents:UIControlEventTouchUpInside];
        [view_ addSubview:headerBtn];
        
        return view_;
    }
    else{
        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.1)];
        view_.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];;
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section<2)return 50;
    else return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section<2){
        NSString *sting_=@"";
        if(indexPath.section==0)
            sting_=obj.shopDescription;
        else{
            NSMutableString *string=[NSMutableString stringWithCapacity:0];
            if([obj.shopBusinessType count]){
                for(int i=0;i<[obj.shopBusinessType count];i++){
                [string appendFormat:@"%@ ",[[obj.shopBusinessType objectAtIndex:i] objectForKey:@"businessTypeName"]];
                }
                sting_=string;
            }
        }
        CGSize size=[util calHeightForLabel:sting_ width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:15]];
        return size.height+20+(size.height/20-2)*5;
    }
    else if(indexPath.section==2){
        CGSize size=[util calHeightForLabel:obj.shopAddress width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:15]];
        if([obj.arr_picture count])
            return 98+size.height+270+40;
        else
            return 98+size.height+45;
    }
    else{
        if([self.data_array count]){
            NSString *string_pl=[[self.data_array objectAtIndex:indexPath.row] objectForKey:@"objectString"];
            CGSize size=[util calHeightForLabel:string_pl width:kMainScreenWidth-90 font:[UIFont systemFontOfSize:16]];
            if(size.height<40) size.height=40;
            return size.height+20;
        }
        else return 0.1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.count_first;
    }
    else if (section==1) {
        return self.count_second;
    }
    else if (section==2) {
        return 1;
    }
    else
        return [self.data_array count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   NSString *cellid=[NSString stringWithFormat:@"mycellid_%d_%d",indexPath.section,indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
   
    if(indexPath.section<2){
        NSString *sting_=@"";
        if(indexPath.section==0)
            sting_=obj.shopDescription;
        else{
            NSMutableString *string=[NSMutableString stringWithCapacity:0];
            if([obj.shopBusinessType count]){
                for(int i=0;i<[obj.shopBusinessType count];i++){
                    [string appendFormat:@"%@ ",[[obj.shopBusinessType objectAtIndex:i] objectForKey:@"businessTypeName"]];
                }
                sting_=string;
            }
            
        }
        if(sting_==nil) sting_=@"";
        CGSize size=[util calHeightForLabel:sting_ width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:15]];
        UILabel *cs=(UILabel *)[cell.contentView viewWithTag:KButtonTag+indexPath.row+indexPath.section];
        cs.frame = CGRectMake(20, 0, kMainScreenWidth - 40, size.height);
        if(!cs)
            cs = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kMainScreenWidth-40, size.height)];
        cs.tag=KButtonTag+indexPath.row+indexPath.section;
        cs.backgroundColor = [UIColor clearColor];
        cs.font = [UIFont systemFontOfSize:15.0];
        cs.textAlignment = NSTextAlignmentLeft;
        cs.textColor = [UIColor grayColor];
        cs.numberOfLines=0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:sting_];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [sting_ length])];
        cs.textColor = [UIColor grayColor];
        cs.attributedText=attributedString;
        [cs sizeToFit];//必须
        [cell.contentView addSubview:cs];
    }
    else if(indexPath.section==2){
        
        UIView *line_fist=(UIView *)[cell viewWithTag:Kcelltag+1];
        if(!line_fist)line_fist=[[UIView alloc]initWithFrame:CGRectMake(20, 0, kMainScreenWidth-20, 0.5)];
        line_fist.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        line_fist.tag=Kcelltag+1;
        [cell addSubview:line_fist];
        
        //加载地址
        UILabel *lab_add=(UILabel *)[cell viewWithTag:Kcelltag+2];
        if(!lab_add) lab_add = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
        lab_add.backgroundColor = [UIColor clearColor];
        lab_add.tag=Kcelltag+2;
        lab_add.font = [UIFont systemFontOfSize:18.0];
        lab_add.textAlignment = NSTextAlignmentLeft;
        lab_add.textColor = [UIColor grayColor];
        lab_add.text =@"常驻地址";
        [cell addSubview:lab_add];
        
        CGSize size=[util calHeightForLabel:obj.shopAddress width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:15]];
        if(size.height<=0)  size.height=20;
        if(!self.lab_address)self.lab_address = [[TextUILable alloc] initWithFrame:CGRectMake(20, 35, kMainScreenWidth-40, size.height)];
        self.lab_address.backgroundColor = [UIColor clearColor];
        self.lab_address.font = [UIFont systemFontOfSize:15.0];
        self.lab_address.textAlignment = NSTextAlignmentLeft;
        self.lab_address.verticalAlignment=VerticalAlignmentTop;
        self.lab_address.numberOfLines=0;
        self.lab_address.textColor = [UIColor grayColor];
        if(obj.shopAddress.length>=1) self.lab_address.text =obj.shopAddress;
        else self.lab_address.text =@"暂无";
        [cell addSubview:self.lab_address];
  
        UIView *line_second=(UIView *)[cell viewWithTag:Kcelltag+3];
        if(!line_second) line_second=[[UIView alloc]initWithFrame:CGRectMake(20, 45+size.height, kMainScreenWidth-20, 0.5)];
        line_second.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        line_second.tag=Kcelltag+3;
        [cell addSubview:line_second];
        
        //加载距离
        UILabel *lab_distance=(UILabel *)[cell viewWithTag:Kcelltag+4];
        if(!lab_distance) lab_distance = [[UILabel alloc] initWithFrame:CGRectMake(20, 55+size.height, 80, 30)];
        lab_distance.backgroundColor = [UIColor clearColor];
        lab_distance.tag=Kcelltag+4;
        lab_distance.font = [UIFont systemFontOfSize:18.0];
        lab_distance.textAlignment = NSTextAlignmentLeft;
        lab_distance.textColor = [UIColor grayColor];
        lab_distance.text =@"距离";
        [cell addSubview:lab_distance];

        if(!self.business_distance)self.business_distance = [[UILabel alloc] initWithFrame:CGRectMake(100, 55+size.height, 100, 30)];
        self.business_distance.backgroundColor = [UIColor clearColor];
        self.business_distance.font = [UIFont systemFontOfSize:18.0];
        self.business_distance.textAlignment = NSTextAlignmentLeft;
        self.business_distance.numberOfLines=0;
        self.business_distance.textColor = [UIColor grayColor];
        if([obj.distance isEqualToString:@"-1"]) self.business_distance.text =@"无法定位";
        else if(obj.distance.length>=1) self.business_distance.text =[NSString stringWithFormat:@"%0.1fkm",[obj.distance floatValue]];
        else self.business_distance.text =@"无法定位";
        [cell addSubview:self.business_distance];
        
        UIButton *btn_map=(UIButton *)[cell viewWithTag:Kcelltag+8];
        if(!btn_map) btn_map=[UIButton buttonWithType:UIButtonTypeCustom];
        btn_map.frame=CGRectMake(kMainScreenWidth-40, 55+size.height, 30, 30);
        [btn_map setImage:[UIImage imageNamed:@"ic_weizhi"] forState:UIControlStateNormal];
        [btn_map addTarget:self action:@selector(pressMap:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_map];
        
        UIView *line_three=(UIView *)[cell viewWithTag:Kcelltag+5];
        if(!line_three) line_three=[[UIView alloc]initWithFrame:CGRectMake(20, 95+size.height, kMainScreenWidth-20, 0.5)];
        line_three.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        line_three.tag=Kcelltag+5;
        [cell addSubview:line_three];
       
        //图集
        if([obj.arr_picture count]>1){
            NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < [obj.arr_picture count]; ++i) {
                @autoreleasepool {
                    UIImageView *view_sub = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8+size.height+60, kMainScreenWidth-20, 220)];
                    view_sub.clipsToBounds=YES;
                    view_sub.contentMode=UIViewContentModeScaleAspectFill;
                    [view_sub sd_setImageWithURL:[NSURL URLWithString:[[obj.arr_picture objectAtIndex:i] objectForKey:@"imgsPath"]] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"] options:SDWebImageTransformAnimatedImage];
                    [viewsArray addObject:view_sub];
                }
            }
            
            self.selected_picture=0;
            if(!self.mainScorllView)self.mainScorllView = [[CustomScrollView alloc] initWithFrame:CGRectMake(10, size.height+113, kMainScreenWidth-20, 220) animationDuration:0];
            self.mainScorllView.backgroundColor = [UIColor clearColor];
            self.mainScorllView.delegate=self;
            self.mainScorllView.currentPageIndex=0;
            self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return viewsArray[pageIndex];
            };
            self.mainScorllView.totalPagesCount = ^NSInteger(void){
                return [viewsArray count];
            };
            self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"business_tap" object:nil];
            };
            [cell addSubview:self.mainScorllView];
        }
        else if([obj.arr_picture count]==1){
            UIImageView *view_sub = [[UIImageView alloc] initWithFrame:CGRectMake(10, size.height+113, kMainScreenWidth-20, 220)];
            view_sub.userInteractionEnabled=YES;
            view_sub.clipsToBounds=YES;
            view_sub.contentMode=UIViewContentModeScaleAspectFill;
            [view_sub sd_setImageWithURL:[NSURL URLWithString:[[obj.arr_picture objectAtIndex:0] objectForKey:@"imgsPath"]] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"] options:SDWebImageTransformAnimatedImage];
            [cell addSubview:view_sub];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
            tap.numberOfTouchesRequired=1;
            tap.numberOfTapsRequired=1;
            [view_sub addGestureRecognizer:tap];
        }
        
        if([obj.arr_picture count]!=0){
            UIView *view_bg_count=[[UIView alloc]initWithFrame:CGRectMake((kMainScreenWidth-60)/2, 8+size.height+60+250-10, 60, 20)];
            view_bg_count.layer.cornerRadius=10;
            view_bg_count.layer.masksToBounds=YES;
            view_bg_count.clipsToBounds = YES;
            view_bg_count.backgroundColor=[UIColor blackColor];
            view_bg_count.opaque=YES;
            view_bg_count.alpha=0.35;
            [cell addSubview:view_bg_count];
            
            if(!self.lab_count)self.lab_count= [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 60, 16)];
            self.lab_count.backgroundColor = [UIColor clearColor];
            self.lab_count.font = [UIFont systemFontOfSize:13.0];
            self.lab_count.textAlignment = NSTextAlignmentCenter;
            self.lab_count.textColor = [UIColor whiteColor];
            self.lab_count.text =[NSString stringWithFormat:@"1/%d",[obj.arr_picture count]];
            [view_bg_count addSubview:self.lab_count];
        }
        
        UIView *line_four=(UIView *)[cell viewWithTag:Kcelltag+6];
        if(!line_four) line_four=[[UIView alloc]init];
        if([obj.arr_picture count])line_four.frame=CGRectMake(20, size.height+355, kMainScreenWidth-20, 0.5);
        else line_four.frame=CGRectMake(20, size.height+145, kMainScreenWidth-20, 0.5);
        line_four.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        line_four.tag=Kcelltag + 6;
        [cell addSubview:line_four];
        
        if(!lab_score)lab_score = [[UILabel alloc] init];
        if(![obj.arr_picture count])lab_score.frame = CGRectMake(20, size.height+105, 90, 30);
        else lab_score.frame = CGRectMake(20, size.height+370, 90, 30);
        lab_score.backgroundColor = [UIColor clearColor];
        lab_score.font = [UIFont systemFontOfSize:18.0];
        lab_score.textAlignment = NSTextAlignmentLeft;
        lab_score.textColor = [UIColor grayColor];
        lab_score.text =@"服务星级";
        [cell addSubview:lab_score];
        
        //加载星级（0-10,0表示无星级）
        NSInteger star_level=0;
        if([obj.shopLevel integerValue]<[obj.shopLevel floatValue])
            star_level=[obj.shopLevel integerValue]*2+1;
        else
            star_level=[obj.shopLevel integerValue]*2;
        self.numberStart = star_level;
        if(!self.startView) self.startView = [[UIView alloc] init];
        if(![obj.arr_picture count]) self.startView.frame=CGRectMake(110, size.height+110, 160, 20);
        else self.startView.frame=CGRectMake(110, size.height+375, 160, 20);
        [self.startView setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:self.startView];
        if(![self.imageViewArray count]){
            for (int i = 0; i < 5; i++) {
                @autoreleasepool {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*20, 3, 15, 15)];
                    [self.imageViewArray addObject:imageView];
                    [self.startView addSubview:imageView];
                }
            }
        }
        [self numberStartReLoad:self.numberStart];
        
        //self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        //[self.startView addGestureRecognizer:self.tapGesture];
        
        //self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        //[self.startView addGestureRecognizer:self.panGesture];
        
        if([obj.arr_picture count]){
            UIView *line_five=(UIView *)[cell viewWithTag:Kcelltag+7];
            if(!line_five) line_five=[[UIView alloc]initWithFrame:CGRectMake(20, size.height+415, kMainScreenWidth-20, 0.5)];
            line_five.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
            line_five.tag=Kcelltag+7;
            [cell addSubview:line_five];
        }
    }
    else{
        UIImageView *photo_pl=(UIImageView *)[cell.contentView viewWithTag:Kcelltag*(indexPath.section+2)+indexPath.row];
        if(!photo_pl){
            photo_pl=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
            photo_pl.image=[UIImage imageNamed:@"ic_touxiang_tk"];
        }
        photo_pl.layer.cornerRadius=20.0;
        photo_pl.layer.masksToBounds=YES;
        photo_pl.clipsToBounds = YES;
        photo_pl.tag=Kcelltag*(indexPath.section+2)+indexPath.row;
        [cell.contentView addSubview:photo_pl];
        
        dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(parsingQueue, ^{

            if([[[self.data_array objectAtIndex:indexPath.row] objectForKey:@"userLogos"] length]>1)
                [photo_pl sd_setImageWithURL:[NSURL URLWithString:[[self.data_array objectAtIndex:indexPath.row] objectForKey:@"userLogos"]] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];

        });
        
        NSString *string_pl=[[self.data_array objectAtIndex:indexPath.row] objectForKey:@"objectString"];
        CGSize size=[util calHeightForLabel:string_pl width:kMainScreenWidth-90 font:[UIFont systemFontOfSize:16]];
        if(size.height<40) size.height=40;
        UILabel *lab_pl=(UILabel *)[cell.contentView viewWithTag:Kcelltag*(indexPath.section+1)+indexPath.row];
        if(!lab_pl) lab_pl = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, kMainScreenWidth-90, size.height)];
        lab_pl.backgroundColor = [UIColor clearColor];
        lab_pl.tag=Kcelltag*(indexPath.section+1)+indexPath.row;
        lab_pl.font = [UIFont systemFontOfSize:16.0];
        lab_pl.textAlignment = NSTextAlignmentLeft;
        lab_pl.textColor = [UIColor grayColor];
        lab_pl.numberOfLines=0;
        lab_pl.text =string_pl;
        [cell.contentView addSubview:lab_pl];
        
        
        UIView *line_pl=(UIView *)[cell.contentView viewWithTag:Kcelltag*indexPath.section+indexPath.row];
        if(!line_pl) line_pl=[[UIView alloc]initWithFrame:CGRectMake(20, size.height+20-0.5, kMainScreenWidth-20, 0.5)];
        line_pl.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        line_pl.tag=Kcelltag*indexPath.section+indexPath.row;
        [cell.contentView addSubview:line_pl];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentSize.height-mtableview.frame.size.height<scrollView.contentOffset.y){
        if(self.currentPage <self.totalPage) [self requestCommentsList];
        else if(self.totalPage>=1){
            if (scrollView.contentOffset.y<self.lastContentOffset){
                //向下
            }
            else if (scrollView.contentOffset.y>self.lastContentOffset){
                [TLToast showWithText:@"已无更多评论信息" topOffset:220.0f duration:1.0];
                //向上
            }
            
            
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastContentOffset = scrollView.contentOffset.y;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

- (void)tapHeader:(UIButton *)sender {
    if (sender.tag==100) {
        is_change=YES;
        self.count_second=0;
        if(is_open_first) {
            is_open_second=NO;
            is_open_first=!is_open_first;
            self.count_first=0;
        }
        else {
            is_open_second=NO;
            is_open_first=!is_open_first;
            self.count_first=1;
        }
        [mtableview reloadData];
    }
    if (sender.tag==101) {
        is_change=NO;
        self.count_first=0;
        if(is_open_second) {
            is_open_first=NO;
            is_open_second=!is_open_second;
            self.count_second=0;
        }
        else {
            is_open_first=NO;
            is_open_second=!is_open_second;
            self.count_second=1;
        }
        [mtableview reloadData];
    }
    if(is_pj_star==YES) {
        btn_wyp.hidden=YES;
        [btn_wyp removeFromSuperview];
        btn_wyp=nil;
    }
    else btn_wyp.hidden=NO;
    lab_score.text =@"商家评分:";
    //[self.startView removeGestureRecognizer:self.tapGesture];
    [self.startView removeGestureRecognizer:self.panGesture];
    NSInteger star_level=0;
    if([obj.shopLevel integerValue]<[obj.shopLevel floatValue])
        star_level=[obj.shopLevel integerValue]*2+1;
    else
        star_level=[obj.shopLevel integerValue]*2;
    self.numberStart = star_level;
    [self numberStartReLoad:self.numberStart];
}

-(void)pressbtn:(UIButton *)btn{
    if (btn.tag==1001 && self.btn_shouc.selected==NO) {
        [savelogObj saveLog:@"用户收藏了商家" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:12];
        [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang"] forState:UIControlStateNormal];
        self.btn_shouc.selected=YES;
        
        [SVProgressHUD showSuccessWithStatus:@"收藏成功" duration:1.0];
        
        [self requestCollect];
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:@"MybusinessCollect.plist"];
        NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename];
        if (!arr_) {
            arr_=[NSMutableArray arrayWithCapacity:0];
        }
        NSMutableDictionary *dict_=[[NSMutableDictionary alloc]initWithCapacity:0];
        if(obj.distance!=nil)
            [dict_ setObject:obj.distance forKey:@"distance"];
        if(obj.shopAddress!=nil)
            [dict_ setObject:obj.shopAddress forKey:@"shopAddress"];
        if([obj.shopBusinessType count])
            [dict_ setObject:obj.shopBusinessType forKey:@"shopBusinessType"];
        if(obj.ShopContact!=nil)
            [dict_ setObject:obj.ShopContact forKey:@"shopContact"];
        if(obj.shopDescription!=nil)
            [dict_ setObject:obj.shopDescription forKey:@"shopDescription"];
        if(obj.shopID!=nil)
            [dict_ setObject:obj.shopID forKey:@"shopId"];
        if([obj.arr_rztype count])
            [dict_ setObject:obj.arr_rztype forKey:@"shopIdentificationType"];
        if([obj.arr_picture count])
            [dict_ setObject:obj.arr_picture forKey:@"shopImgPath"];
        if(obj.shopLatitude!=nil)
            [dict_ setObject:obj.shopLatitude forKey:@"shopLatitude"];
        if(obj.shopLevel!=nil)
            [dict_ setObject:obj.shopLevel forKey:@"shopLevel"];
        if(obj.shopLitimgPath !=nil)
            [dict_ setObject:obj.shopLitimgPath forKey:@"shopLitimgPath"];
        if(obj.shopLogoPath!=nil)
            [dict_ setObject:obj.shopLogoPath forKey:@"shopLogoPath"];
        if(obj.shopLongitude!=nil)
            [dict_ setObject:obj.shopLongitude forKey:@"shopLongitude"];
        if(obj.shopMobileNum!=nil)
            [dict_ setObject:obj.shopMobileNum forKey:@"shopMobile"];
        if(obj.shopName!=nil)
            [dict_ setObject:obj.shopName forKey:@"shopName"];
        if(obj.shopPhoneNum!=nil)
            [dict_ setObject:obj.shopPhoneNum forKey:@"shopPhone"];
        
        [arr_ addObject:dict_];
        [arr_ writeToFile:_filename atomically:NO];
    }
    if (btn.tag==1003) {
         [savelogObj saveLog:@"用户拨打商家电话" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:22];
        [self requestRecordCallinfo];
        NSString *osVersion = [[UIDevice currentDevice] systemVersion];
        NSString *serviceNumber;
        if([obj.shopMobileNum length])
            serviceNumber=[obj.shopMobileNum stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        else if ([obj.shopPhoneNum length])
            serviceNumber=[obj.shopPhoneNum stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([osVersion floatValue] >= 3.1) {
            UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
            [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",serviceNumber]]]];
            webview.hidden = YES;
            // Assume we are in a view controller and have access to self.view
            [self.view addSubview:webview];
            
        }else {
            // On 3.0 and below, dial as usual
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", serviceNumber]]];
        }
    }
}

-(void)pressMap:(UIButton *)btn{
    GoodsShowinMapVC *mapvc=[[GoodsShowinMapVC alloc]init];
    mapvc.lng_map=[NSString stringWithFormat:@"%@",obj.shopLongitude];
    mapvc.lat_map=[NSString stringWithFormat:@"%@",obj.shopLatitude];
    mapvc.nav_title=obj.shopName;
    mapvc.title_string=obj.shopDescription;
    mapvc.address_string=obj.shopAddress;
    if([obj.shopMobileNum length])
        mapvc.phoneNumber=[NSString stringWithFormat:@"%@",obj.shopMobileNum];
    else if ([obj.shopPhoneNum length])
        mapvc.phoneNumber=[NSString stringWithFormat:@"%@",obj.shopPhoneNum];
    //[self.navigationController pushViewController:mapvc animated:YES];
    mapvc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:mapvc];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)myappraise{
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]){
            [self.view becomeFirstResponder];
            comment=[[CommentsView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 260)];
            comment.delegate=self;
            [UIView animateWithDuration:.25 animations:^{
                comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 260);
            } completion:^(BOOL finished) {
                if (finished) {
                    
                }
            }];
            [comment show];
        }
        else{
           
                LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                login.delegate=self;
                [login show];
                

        }
    
}

#pragma mark -
#pragma mark - KeyBord
- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat kbSize = rect.size.height;
    NSLog(@"will---键盘高度：%f",kbSize);

    if(!comment){
        comment=[[CommentsView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245)];
        comment.delegate=self;
    }
    [UIView animateWithDuration:duration animations:^{
        comment.frame=CGRectMake(0, kMainScreenHeight-245-kbSize, kMainScreenWidth, 245);
    } completion:^(BOOL finished) {
        if (finished) {
            comment.textf.inputView=comment;
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245);
    } completion:^(BOOL finished) {
        if (finished) {
            [comment dismiss];
        }
    }];
}

#pragma mark -
#pragma mark - comments

-(void)didFinishedComments:(NSString *)comment_title star:(NSInteger)star_int{
   
    [UIView animateWithDuration:.35 animations:^{
        comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245);
    } completion:^(BOOL finished) {
        if (finished) {
            [comment dismiss];
        }
    }];
   
    if(comment_title.length && star_int!=0) [self requestEvaluationOfStar:comment_title star:star_int];
}

#pragma mark -
#pragma mark - gestrue

//- (void)handleTapGesture:(UIGestureRecognizer*)sender{
//    CGPoint translation = [sender locationInView:self.startView];
//    if (translation.x>= 0&& translation.x <= 165) {
//        if(translation.x >= 0 &&translation.x <=10)
//        {
//            self.numberStart = 0;
//        }
//        else if (translation.x >10 &&translation.x <25) {
//            self.numberStart = 1;
//        }
//        else if (translation.x >= 25 &&translation.x <40) {
//            self.numberStart = 2;
//        }
//        else if(translation.x >= 40 &&translation.x < 55){
//            self.numberStart = 3;
//        }
//        else if (translation.x >= 55 &&translation.x < 70) {
//            self.numberStart = 4;
//        }
//        else if(translation.x >=70 &&translation.x < 85)
//        {
//            self.numberStart = 5;
//        }
//        else if (translation.x >=85 &&translation.x <100) {
//            self.numberStart = 6;
//        }
//        else if (translation.x >= 100 &&translation.x <115) {
//            self.numberStart = 7;
//        }
//        else if(translation.x >= 115 &&translation.x < 130){
//            self.numberStart = 8;
//        }
//        else if (translation.x >= 130 &&translation.x < 145) {
//            self.numberStart = 9;
//        }
//        else if(translation.x >= 145 &&translation.x < 160)
//        {
//            self.numberStart = 10;
//        }
//        [self numberStartReLoad:self.numberStart];
//    }
//    if(sender.state==UIGestureRecognizerStateEnded){
//            [self Requeststar];
//    }
//}

- (void)handlePanGesture:(UIGestureRecognizer *)sender {
    CGPoint translation = [sender locationInView:self.startView];
    if (translation.x>= 0&& translation.x <= 165) {
        if(translation.x >= 0 &&translation.x <=10)
        {
            self.numberStart = 0;
        }
        else if (translation.x >10 &&translation.x <25) {
            self.numberStart = 1;
        }
        else if (translation.x >= 25 &&translation.x <40) {
            self.numberStart = 2;
        }
        else if(translation.x >= 40 &&translation.x < 55){
            self.numberStart = 3;
        }
        else if (translation.x >= 55 &&translation.x < 70) {
            self.numberStart = 4;
        }
        else if(translation.x >=70 &&translation.x < 85)
        {
            self.numberStart = 5;
        }
        else if (translation.x >=85 &&translation.x <100) {
            self.numberStart = 6;
        }
        else if (translation.x >= 100 &&translation.x <115) {
            self.numberStart = 7;
        }
        else if(translation.x >= 115 &&translation.x < 130){
            self.numberStart = 8;
        }
        else if (translation.x >= 130 &&translation.x < 145) {
            self.numberStart = 9;
        }
        else if(translation.x >= 145 &&translation.x < 160)
        {
            self.numberStart = 10;
        }
        else if(translation.x >=160)
        {
            self.numberStart = 10;
        }
        [self numberStartReLoad:self.numberStart];
    }
    if(sender.state==UIGestureRecognizerStateEnded){
           // [self Requeststar];
    }
}

- (void)numberStartReLoad:(NSInteger)number {
    int fullNum = number/2;
    int halfNum = number%2;
    int emptyNum = 5 - fullNum -halfNum;
    NSMutableArray *starArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            if (fullNum != 0 ) {
                fullNum --;
                [starArray addObject:@"0"];
            }else if(fullNum == 0 &&halfNum != 0)
            {
                halfNum --;
                [starArray addObject:@"1"];
            }
            else if(fullNum == 0 &&halfNum == 0 &&emptyNum!= 0)
            {
                emptyNum --;
                [starArray addObject:@"2"];
            }
            if (self.imageViewArray.count) {
            UIImageView *imageView = [self.imageViewArray objectAtIndex:i];
            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_xing_%@",[starArray objectAtIndex:i]]]];
            }
            else return;
        }
    }
}

#pragma mark -
#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.view becomeFirstResponder];
//        comment=[[CommentsView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 260)];
//        comment.delegate=self;
//        [UIView animateWithDuration:.25 animations:^{
//            comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 260);
//        } completion:^(BOOL finished) {
//            if (finished) {
//                
//            }
//        }];
//        [comment show];
//    }];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.view becomeFirstResponder];
        comment=[[CommentsView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 260)];
        comment.delegate=self;
        [UIView animateWithDuration:.25 animations:^{
            comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 260);
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
        [comment show];
    }];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
