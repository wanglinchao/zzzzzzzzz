//
//  ForemanInfoViewController.m
//  IDIAI
//
//  Created by iMac on 14-10-23.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ForemanInfoViewController.h"
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
#import "Macros.h"
#import "OpenUDID.h"
#import "UIScrollView+TwitterCover.h"
#import "CommentsView.h"
#import "SubscribePeopleViewController.h"
#import "GongzhangInfoObj.h"
#import "MoreCommentsViewController.h"
#import "LoginVC.h"
#import "IDIAIAppDelegate.h"
#import "SubscribeListModel.h"
#import "MySubscribeDetailViewController.h"

#define KButtonTag 100
#define Kcelltag 1000

@interface ForemanInfoViewController ()<CustomScrollViewDelegate,LoginViewDelegate,CommentsViewDelegate,loggedDelegate>{
    UIView *_topView;//顶部图片之上的view
    CommentsView *comment;
    
    UIView *view_header;
    NSString *_bookIdStr;
}

@property (nonatomic , strong) CustomScrollView *mainScorllView;
@property (nonatomic,strong) UIImageView *imageview_photo;
@property (nonatomic,strong) UILabel *worker_name;
@property (nonatomic,strong) UILabel *worker_express;
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

@implementation ForemanInfoViewController
@synthesize formanid,lab_score,btn_wyp,obj_gz;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"designer_tap" object:nil];
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
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapPicture:) name:@"designer_tap" object:nil];
    }
    return self;
}

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:NO];
    
    UIColor *color = [UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = image;
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont boldSystemFontOfSize:24];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor whiteColor];
    //lab_nav_title.text=obj.designerName;
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
    NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:@"MygongzhangCollect.plist"];
    NSMutableArray *Arr_=[NSMutableArray arrayWithContentsOfFile:_filename_];
    if (!Arr_) {
        Arr_=[NSMutableArray arrayWithCapacity:0];
    }
    self.btn_shouc = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_shouc.frame=CGRectMake(270, 25, 30, 30);
    if([Arr_ count]){
        for(NSDictionary *dict in Arr_){
           // NSLog(@"%@---%@--%@",formanid,[dict objectForKey:@"foremanId"],dict);
            if([[dict objectForKey:@"foremanId"] integerValue]==[formanid integerValue]){
                
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

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self customizeNavigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [savelogObj saveLog:@"用户查看设计师详情" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:20];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.count_first=1;
    self.count_second=0;
    is_open_first=YES;
    is_change=YES;
    self.data_array=[NSMutableArray arrayWithCapacity:0];
    self.dataArray_pl=[NSMutableArray arrayWithCapacity:0];
    _imageViewArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    mtableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
    mtableview.delegate=self;
    mtableview.dataSource=self;
    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mtableview];
    
    //    obj.designerBrowsePoints=[NSString stringWithFormat:@"%d",[obj.designerBrowsePoints integerValue]+1];
    [self requestBrower];
    
    obj_gz.browsePoints=[NSString stringWithFormat:@"%d",[obj_gz.browsePoints integerValue]+1];
    [self createHeader];
    
//    if([obj.designerMobileNum length] || [obj.designerPhoneNum length])
        [self createPhone];
    
    //创建评论栏
    //[self createPL];
    
     [self requestGongzhangInfo];
    
    [self requestCommentsList];
}

-(void)requestGongzhangInfo{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0124\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"foremanId\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],formanid];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"工长列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==112401) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [self.data_array addObject:[GongzhangInfoObj objWithDict:[jsonDict objectForKey:@"foremanInfo"]]];
                        [mtableview reloadData];
                        
                        GongzhangInfoObj *obj=[self.data_array firstObject];
                        self.worker_name.text=obj.nickName;
                        self.worker_express.text=obj.foremanExperience;
                        [self.imageview_photo setOnlineImage:obj.foremanIconPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over"]];
                    });
                }
                else if (code==112409) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [self stopRequest];
                        [mtableview reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [mtableview reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
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
    btn_wyp.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn_wyp setImage:[UIImage imageNamed:@"contenttoolbar_hd_comment_light"] forState:UIControlStateNormal];
    [btn_wyp setImage:[UIImage imageNamed:@"contenttoolbar_hd_comment_light"] forState:UIControlStateHighlighted];
    btn_wyp.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, kMainScreenWidth-30-75);
    btn_wyp.imageEdgeInsets=UIEdgeInsetsMake(5, 10, 5, kMainScreenWidth-30-30);
    [btn_wyp addTarget:self action:@selector(myappraise) forControlEvents:UIControlEventTouchUpInside];
    [view_pl addSubview:btn_wyp];
}

-(void)createPhone{
     if([obj_gz.state integerValue]==1){
         self.btn_phone = [UIButton buttonWithType:UIButtonTypeCustom];
         self.btn_phone.frame=CGRectMake(kMainScreenWidth-50, kMainScreenHeight-250, 50, 50);
         [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_yuyue.png"] forState:UIControlStateNormal];
         if (([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] == 7)) {
             [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_yuyue_pressed.png"] forState:UIControlStateNormal];
         }
         [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_yuyue_pressed.png"] forState:UIControlStateHighlighted];
         self.btn_phone.tag=1003;
         [self.btn_phone addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
         [self.view addSubview:self.btn_phone ];
     }
    
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
    GongzhangInfoObj *obj=[self.data_array firstObject];
    
        
    [mtableview addTwitterCoverWithImage:[util imageWithColor:kThemeColor] withTopView:_topView];
    if(!view_header)view_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, CHTwitterCoverViewHeight + _topView.bounds.size.height+60)];
    
    NSString *sting_name=@" ";
    if(obj.nickName!=nil)
        sting_name=obj.nickName;
    else
        sting_name=@" ";
    CGSize size=[util calHeightForLabel:sting_name width:200 font:[UIFont systemFontOfSize:18]];
    if(!self.worker_name) self.worker_name = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-200)/2, 100, 200, size.height)];
    self.worker_name.backgroundColor = [UIColor clearColor];
    self.worker_name.font = [UIFont systemFontOfSize:20.0];
    self.worker_name.textAlignment = NSTextAlignmentCenter;
    self.worker_name.numberOfLines=0;
    self.worker_name.textColor = [UIColor whiteColor];
    self.worker_name.text =sting_name;
    [view_header addSubview:self.worker_name];
    
    if(!self.worker_express) self.worker_express = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-200)/2, 100+size.height+5, 200, 20)];
    self.worker_express.backgroundColor = [UIColor clearColor];
    self.worker_express.font = [UIFont systemFontOfSize:16.0];
    self.worker_express.textAlignment = NSTextAlignmentCenter;
    self.worker_express.numberOfLines=0;
    self.worker_express.textColor = [UIColor whiteColor];
    if(obj.foremanExperience==nil)
        self.worker_express.text =[NSString stringWithFormat:@"从业经验: %@",@"暂无"];
    else
        self.worker_express.text =[NSString stringWithFormat:@"从业经验: %@",obj.foremanExperience];
    [view_header addSubview:self.worker_express];
    
    UIView *authen_view=[[UIView alloc]initWithFrame:CGRectMake(0, CHTwitterCoverViewHeight + _topView.bounds.size.height, kMainScreenWidth, 60)];
    authen_view.backgroundColor=[UIColor whiteColor];
    [view_header addSubview:authen_view];
    if([obj_gz.foremanAuthzs count]){
        for(int i=0;i<[obj_gz.foremanAuthzs count];i++){
            @autoreleasepool {
                //创建认证
                NSDictionary *dict=[obj_gz.foremanAuthzs objectAtIndex:i];
                UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth/([obj_gz.foremanAuthzs count]+1))*i+((kMainScreenWidth/([obj_gz.foremanAuthzs count]+1))-30)/2, 5, 30, 30)];
                image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_b_%@.png",[dict objectForKey:@"authzId"]]];
                [authen_view addSubview:image_rz];
                
                UILabel *lab_rz = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth/([obj_gz.foremanAuthzs count]+1))*i+((kMainScreenWidth/([obj_gz.foremanAuthzs count]+1))-40)/2, 35, 40, 20)];
                lab_rz.backgroundColor = [UIColor clearColor];
                lab_rz.font = [UIFont systemFontOfSize:10.0];
                lab_rz.textAlignment = NSTextAlignmentCenter;
                lab_rz.textColor = [UIColor grayColor];
                if([[dict objectForKey:@"authzId"] integerValue]==1)lab_rz.text =@"身份认证";
                else if([[dict objectForKey:@"authzId"] integerValue]==2)lab_rz.text =@"折扣认证";
                else if([[dict objectForKey:@"authzId"] integerValue]==3)lab_rz.text =@"特卖认证";
                else if([[dict objectForKey:@"authzId"] integerValue]==5)lab_rz.text =@"商家认证";
                else if([[dict objectForKey:@"authzId"] integerValue]==6)lab_rz.text =@"工艺认证";
                else if([[dict objectForKey:@"authzId"] integerValue]==7)lab_rz.text =@"监理认证";
                [authen_view addSubview:lab_rz];
                [authen_view addSubview:lab_rz];
                
                UIView *line=[[UIView alloc]initWithFrame:CGRectMake((kMainScreenWidth/([obj_gz.foremanAuthzs count]+1))*(i+1), 10, 0.5, 35)];
                line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
                [authen_view addSubview:line];
                
                if(i==[obj_gz.foremanAuthzs count]-1){
                    //创建关注
                    UIImageView *image_gz=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_guanzhu_b"]];
                    image_gz.frame=CGRectMake((kMainScreenWidth/([obj_gz.foremanAuthzs count]+1))*(i+1)+((kMainScreenWidth/([obj_gz.foremanAuthzs count]+1))-30)/2, 5, 30, 30);
                    [authen_view addSubview:image_gz];
                    
                    UILabel *lab_gz = [[UILabel alloc] init];
                    lab_gz.frame=CGRectMake((kMainScreenWidth/([obj_gz.foremanAuthzs count]+1))*(i+1)+((kMainScreenWidth/([obj_gz.foremanAuthzs count]+1))-80)/2, 35, 80, 20);
                    lab_gz.backgroundColor = [UIColor clearColor];
                    lab_gz.font = [UIFont systemFontOfSize:10.0];
                    lab_gz.textAlignment = NSTextAlignmentCenter;
                    lab_gz.textColor = [UIColor grayColor];
                    lab_gz.text =[NSString stringWithFormat:@"关注%@",obj_gz.browsePoints];
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
        lab_gz.text =[NSString stringWithFormat:@"关注%@",obj_gz.browsePoints];
        [authen_view addSubview:lab_gz];
    }
    
    
    //创建头像
    if(!self.imageview_photo)self.imageview_photo=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-80)/2, 10, 80, 80)];
    self.imageview_photo.layer.cornerRadius=40;
    self.imageview_photo.layer.masksToBounds=YES;
    self.imageview_photo.clipsToBounds = YES;
    [self.imageview_photo setOnlineImage:obj.foremanIconPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over"]];
    [view_header addSubview:self.imageview_photo];
    
    view_header.frame=CGRectMake(0, 0, kMainScreenWidth, 120+size.height+70);
    mtableview.tableHeaderView=view_header;
}

-(void)scrollviewToCurrent:(NSInteger)index{
    GongzhangInfoObj *obj=[self.data_array firstObject];
    self.selected_picture=index;
    self.lab_count.text=[NSString stringWithFormat:@"%d/%d",index+1,[obj.foremanImagesPath count]];
}

-(void)tapImage:(UIGestureRecognizer *)gers{
    GongzhangInfoObj *obj=[self.data_array firstObject];
    if(![util isConnectionAvailable]) [TLToast showWithText:@"无网络连接" topOffset:200.0f duration:1.0];
    PicturesShowVC *picvc=[[PicturesShowVC alloc]init];
    picvc.data_array=obj.foremanImagesPath;
    picvc.type_pic=@"business";
    picvc.pic_id=self.selected_picture;
    [self.navigationController pushViewController:picvc animated:YES];
}

-(void)tapPicture:(NSNotification *)notif{
     GongzhangInfoObj *obj=[self.data_array firstObject];
    if(![util isConnectionAvailable]) [TLToast showWithText:@"无网络连接" topOffset:200.0f duration:1.0];
    PicturesShowVC *picvc=[[PicturesShowVC alloc]init];
    picvc.data_array=obj.foremanImagesPath;
    picvc.type_pic=@"business";
    picvc.pic_id=self.selected_picture;
    [self.navigationController pushViewController:picvc animated:YES];
}

////评价
//-(void)requestEvaluationOfStar:(NSString *)title star:(NSInteger)star{
//    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(parsingQueue, ^{
//        
//        NSString *string_token;
//        NSString *string_userid;
//        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
//            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
//            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
//        }
//        else{
//            string_token=@"";
//            string_userid=@"";
//        }
//        
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
//        
//        NSMutableDictionary *postDict01 = [[NSMutableDictionary alloc] init];
//        [postDict01 setObject:@"ID0004" forKey:@"cmdID"];
//        [postDict01 setObject:string_token forKey:@"token"];
//        [postDict01 setObject:string_userid forKey:@"userID"];
//        [postDict01 setObject:@"ios" forKey:@"deviceType"];
//        [postDict01 setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"] forKey:@"cityCode"];
//        NSString *string01=[postDict01 JSONString];
//        
//        NSMutableDictionary *postDict02 = [[NSMutableDictionary alloc] init];
//        [postDict02 setObject:[NSString stringWithFormat:@"%d",obj.foremanId] forKey:@"objectId"];
//        [postDict02 setObject:title forKey:@"objectString"];
//        [postDict02 setObject:@"1" forKey:@"objectTypeId"];
//        if(star%2==0)
//            [postDict02 setObject:[NSString stringWithFormat:@"%d",star/2] forKey:@"objectLevel"];
//        else
//            [postDict02 setObject:[NSString stringWithFormat:@"%0.1f",star/2+0.5] forKey:@"objectLevel"];
//        NSString *string02=[postDict02 JSONString];
//        
//        NSMutableDictionary *req_dict= [[NSMutableDictionary alloc] init];
//        [req_dict setObject:string01 forKey:@"header"];
//        [req_dict setObject:string02 forKey:@"body"];
//        
//        NetworkRequest *req = [[NetworkRequest alloc] init];
//        [req setHttpMethod:PostMethod];
//        
//        [req sendToServerInBackground:^{
//            dispatch_async(parsingQueue, ^{
//                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
//                [request setResponseEncoding:NSUTF8StringEncoding];
//                NSString *respString = [request responseString];
//                NSDictionary *jsonDict = [respString objectFromJSONString];
//                NSLog(@"评星：返回信息：%@",jsonDict);
//                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
//                if (code==10041) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSInteger star_level=0;
//                        if([[jsonDict objectForKey:@"average"] integerValue]<[[jsonDict objectForKey:@"average"] floatValue])
//                            star_level=[[jsonDict objectForKey:@"average"] integerValue]*2+1;
//                        else
//                            star_level=[[jsonDict objectForKey:@"average"] integerValue]*2;
//                        self.numberStart = star_level;
//                        [self numberStartReLoad:self.numberStart];
//                        //[self.startView removeGestureRecognizer:self.tapGesture];
//                        //[self.startView removeGestureRecognizer:self.panGesture];
//                        [TLToast showWithText:@"评价成功，感谢您的支持" bottomOffset:220.0f duration:1.0];
//                        obj.foremanLevel=[jsonDict objectForKey:@"average"];
//                        // [[NSNotificationCenter defaultCenter] postNotificationName:@"worker_refresh" object:nil];
//                        if([self.data_array count]) [self.data_array removeAllObjects];
//                        self.currentPage=0;
//                        [self requestCommentsList];
//                    });
//                }
//                else if (code==10042) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [TLToast showWithText:@"亲，不符合评价的规则" bottomOffset:220.0f duration:1.0];
//                    });
//                }
//                else if (code==10043) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [TLToast showWithText:@"亲，评价的内容过长" bottomOffset:220.0f duration:1.0];
//                        
//                    });
//                }
//                
//                else if (code==10049) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
//                    });
//                }
//                else{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
//                    });
//                }
//            });
//        }
//                          failedBlock:^{
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
//                              });
//                          }
//                               method:url postDict:req_dict];
//    });
//    
//    
//}
//
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
        NSString *foremanIDStr = [NSString stringWithFormat:@"%@",obj_gz.foremanId];
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0037\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeId\":\"4\",\"objectId\":\"%@\",\"currentPage\":\"1\",\"requestRow\":\"5\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],foremanIDStr];
        
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if([arr_pl count]){
                            for(NSDictionary *dict in arr_pl){
                                [self.dataArray_pl addObject:dict];
                            }
                        }
                        //                        //一个section刷新
                        //                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
                        //                        [mtableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                        
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
        NSString *foremanIDStr = [NSString stringWithFormat:@"%@",formanid];
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0038\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeID\":\"4\",\"objectID\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],foremanIDStr];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
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

//发送收藏量
-(void)requestCollect{
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
        NSString *foremanIDStr = [NSString stringWithFormat:@"%@",formanid];
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0039\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeID\":\"4\",\"objectID\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],foremanIDStr];
        
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

//发送记录呼叫电话信息
-(void)requestRecordCallinfo{
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
        
        GongzhangInfoObj *obj=[self.data_array firstObject];
        
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
        if([obj.foremanMobile length]>2) str_called=obj.foremanMobile;
        else str_called=@"";
        //获取被叫号码编号
        NSString *str_called_id;
        if([obj.foremanId integerValue]  >=0) str_called_id=[NSString stringWithFormat:@"%@",obj.foremanId];
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
        [postDict02 setObject:@"1" forKey:@"calledIdenttityType"];
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
                        
                    });
                }
                else if (code==10329) {
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
        
        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 120, 30)];
        designer_jianj.backgroundColor = [UIColor clearColor];
        designer_jianj.font = [UIFont systemFontOfSize:18.0];
        designer_jianj.textAlignment = NSTextAlignmentLeft;
        designer_jianj.textColor = [UIColor grayColor];
        designer_jianj.text =@"业务介绍";
        [view_ addSubview:designer_jianj];
        
        self.imv_zkai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
        self.imv_zkai.frame = CGRectMake(kMainScreenWidth-30, 15, 10, 20);
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
    else if(section==2){
        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 30)];
        view_.backgroundColor=[UIColor clearColor];
        
        UIView *line_first_header=[[UIView alloc]initWithFrame:CGRectMake(20, 49.5, kMainScreenWidth-20, 0.5)];
        line_first_header.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        [view_ addSubview:line_first_header];
        
        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 120, 20)];
        designer_jianj.backgroundColor = [UIColor clearColor];
        designer_jianj.font = [UIFont systemFontOfSize:18.0];
        designer_jianj.textAlignment = NSTextAlignmentLeft;
        designer_jianj.textColor = [UIColor grayColor];
        designer_jianj.text =@"更多评论";
        [view_ addSubview:designer_jianj];
        
        UIImageView *imv_zk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
        imv_zk.frame = CGRectMake(kMainScreenWidth-30, 10, 10, 20);
        [view_ addSubview:imv_zk];
        
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
        view_.backgroundColor=[UIColor redColor];
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0)return 50;
    else if (section==2) return 40;
    else return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GongzhangInfoObj *obj=[self.data_array firstObject];
    if(indexPath.section==0){
        NSString *sting_=@"";
        
        if(indexPath.section==0)
            sting_=obj.foremanDesc;
        else{
//            sting_=obj.designerWorks;
        }
        CGSize size=[util calHeightForLabel:sting_ width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:15]];
        
        return size.height+20;
    }
    else if(indexPath.section==1){
        if([obj.foremanImagesPath count])
            return 98+275 - 60;
        else
            return 98 - 40;
    }
    else {
        if([self.dataArray_pl count]){
            NSString *string_pl=[[self.dataArray_pl objectAtIndex:indexPath.row] objectForKey:@"objectString"];
            CGSize size=[util calHeightForLabel:string_pl width:kMainScreenWidth-90 font:[UIFont systemFontOfSize:16]];
            if(size.height<40) size.height=40;
            return size.height+20;
        }
        else return 40;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.count_first;
    }
    else if (section==1) {
        return 1;
    }
    else {
        return [self.dataArray_pl count];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid=[NSString stringWithFormat:@"mycellid_%d_%d",indexPath.section,indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    GongzhangInfoObj *obj=[self.data_array firstObject];
    
    if(indexPath.section==0){
        NSString *sting_=@"";
        if(indexPath.section==0)
            sting_=obj.foremanDesc;
        else{
//            sting_=obj.designerWorks;
        }
        if(sting_==nil) sting_=@"";
        CGSize size=[util calHeightForLabel:sting_ width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:15]];
        UILabel *cs=(UILabel *)[cell.contentView viewWithTag:KButtonTag+indexPath.row+indexPath.section];
        cs.frame = CGRectMake(20, 0, kMainScreenWidth - 40, size.height);
        if(!cs)
            cs = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kMainScreenWidth-40, size.height+0)];
        cs.tag=KButtonTag+indexPath.row+indexPath.section;
        cs.backgroundColor = [UIColor clearColor];
        cs.font = [UIFont systemFontOfSize:15.0];
        cs.textAlignment = NSTextAlignmentLeft;
        cs.numberOfLines=0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:sting_];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [sting_ length])];
        cs.textColor = [UIColor grayColor];
//        cs.attributedText=attributedString;
        cs.text = sting_;
//        [cs sizeToFit];//必须
        [cell.contentView addSubview:cs];
    }
    else if(indexPath.section==1){
        
        UIView *line_fist=(UIView *)[cell viewWithTag:Kcelltag+1];
        if(!line_fist)line_fist=[[UIView alloc]initWithFrame:CGRectMake(20, 0, kMainScreenWidth-20, 0.5)];
        line_fist.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        line_fist.tag=Kcelltag+1;
        [cell addSubview:line_fist];
        
        UILabel *lab_add=(UILabel *)[cell viewWithTag:Kcelltag+2];
        if(!lab_add) lab_add = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
        lab_add.backgroundColor = [UIColor clearColor];
        lab_add.tag=Kcelltag+2;
        lab_add.font = [UIFont systemFontOfSize:18.0];
        lab_add.textAlignment = NSTextAlignmentLeft;
        lab_add.textColor = [UIColor grayColor];
        lab_add.text =@"常驻地址";
//        [cell addSubview:lab_add];
        
        NSString *sting_add=@" ";
        if(obj.address!=nil)
            sting_add=obj.address;
        else
            sting_add=@" ";
        
        CGSize size=[util calHeightForLabel:sting_add width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:15]];
        size.height = 0;
        if(!self.lab_address)self.lab_address = [[TextUILable alloc] initWithFrame:CGRectMake(20, 35, kMainScreenWidth-40, size.height)];
        self.lab_address.backgroundColor = [UIColor clearColor];
        self.lab_address.font = [UIFont systemFontOfSize:15.0];
        self.lab_address.textAlignment = NSTextAlignmentLeft;
        self.lab_address.verticalAlignment=VerticalAlignmentTop;
        self.lab_address.numberOfLines=0;
        self.lab_address.textColor = [UIColor grayColor];
        self.lab_address.text=sting_add;
//        [cell addSubview:self.lab_address];
        
        UIView *line_second=(UIView *)[cell viewWithTag:Kcelltag+3];
        if(!line_second) line_second=[[UIView alloc]initWithFrame:CGRectMake(20, 45+size.height, kMainScreenWidth-20, 0.5)];
        line_second.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        line_second.tag=Kcelltag+3;
//        [cell addSubview:line_second];
        
        if([obj.foremanImagesPath count]>1){
            NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < [obj.foremanImagesPath count]; ++i) {
                @autoreleasepool {
                    UIImageView *view_sub = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8+size.height, kMainScreenWidth-20, 220)];
                    view_sub.clipsToBounds=YES;
                    view_sub.contentMode=UIViewContentModeScaleAspectFill;
                    [view_sub sd_setImageWithURL:[NSURL URLWithString:[[obj.foremanImagesPath objectAtIndex:i] objectForKey:@"rendreingsPath"]] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"] options:SDWebImageTransformAnimatedImage];
                    [viewsArray addObject:view_sub];
                }
            }
            
            self.selected_picture=0;
            if(!self.mainScorllView)self.mainScorllView = [[CustomScrollView alloc] initWithFrame:CGRectMake(10, 8+size.height, kMainScreenWidth-20, 220) animationDuration:0];
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
                [[NSNotificationCenter defaultCenter] postNotificationName:@"designer_tap" object:nil];
            };
            [cell addSubview:self.mainScorllView];
        }
        else if([obj.foremanImagesPath count]==1){
            UIImageView *view_sub = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8+size.height, kMainScreenWidth-20, 220)];
            view_sub.userInteractionEnabled=YES;
            view_sub.clipsToBounds=YES;
            view_sub.contentMode=UIViewContentModeScaleAspectFill;
            [view_sub sd_setImageWithURL:[NSURL URLWithString:[[obj.foremanImagesPath objectAtIndex:0] objectForKey:@"rendreingsPath"]] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"] options:SDWebImageTransformAnimatedImage];
            [cell addSubview:view_sub];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
            tap.numberOfTouchesRequired=1;
            tap.numberOfTapsRequired=1;
            [view_sub addGestureRecognizer:tap];
        }
        
        if([obj.foremanImagesPath count]!=0){
            UIView *view_bg_count=[[UIView alloc]initWithFrame:CGRectMake((kMainScreenWidth-60)/2, 8+size.height+200-5, 60, 20)];
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
            self.lab_count.text =[NSString stringWithFormat:@"1/%d",[obj.foremanImagesPath count]];
            [view_bg_count addSubview:self.lab_count];
        }
        
        UIView *line_three=(UIView *)[cell viewWithTag:Kcelltag+4];
        if(!line_three)line_three=[[UIView alloc]init];
        if([obj.foremanImagesPath count])line_three.frame=CGRectMake(20, size.height+310 - 50, kMainScreenWidth-20, 0.5);
        else line_three.frame=CGRectMake(0, size.height+100 - 50, kMainScreenWidth, 0.5);
        line_three.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        line_three.tag=Kcelltag+4;
        [cell addSubview:line_three];
        
        if(!lab_score)lab_score = [[UILabel alloc] init];
        if(![obj.foremanImagesPath count])lab_score.frame = CGRectMake(20, size.height+10, 90, 30);
        else lab_score.frame = CGRectMake(20, size.height+325 - 50, 90, 30);
        lab_score.backgroundColor = [UIColor clearColor];
        lab_score.font = [UIFont systemFontOfSize:18.0];
        lab_score.textAlignment = NSTextAlignmentLeft;
        lab_score.textColor = [UIColor grayColor];
        lab_score.text =@"服务星级";
        [cell addSubview:lab_score];
        
        //加载星级（0-10,0表示无星级）
        NSInteger star_level=0;
        if([obj.foremanLevel integerValue]<[obj.foremanLevel floatValue])
            star_level=[obj.foremanLevel integerValue]*2+1;
        else
            star_level=[obj.foremanLevel integerValue]*2;
        self.numberStart = star_level;
        if(!self.startView) self.startView = [[UIView alloc] init];
        if(![obj.foremanImagesPath count]) self.startView.frame=CGRectMake(110, size.height + 15, 160, 20);
        else self.startView.frame=CGRectMake(110, size.height+330 - 50, 160, 20);
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
        
        // self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        //[self.startView addGestureRecognizer:self.panGesture];
        
        if([obj.foremanImagesPath count]){
            UIView *line_four=(UIView *)[cell viewWithTag:Kcelltag+5];
            if(!line_four)line_four=[[UIView alloc]initWithFrame:CGRectMake(20, size.height+370 - 60, kMainScreenWidth-20, 0.5)];
            line_four.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
            line_four.tag=Kcelltag+5;
            [cell addSubview:line_four];
        }
        
    }
    else{
        
        if([self.dataArray_pl count]){
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
            
            if([[[self.dataArray_pl objectAtIndex:indexPath.row] objectForKey:@"userLogos"] length]>1)
                 [photo_pl sd_setImageWithURL:[NSURL URLWithString:[[self.data_array objectAtIndex:indexPath.row] objectForKey:@"userLogos"]] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
                });
        
        NSString *string_pl=[[self.dataArray_pl objectAtIndex:indexPath.row] objectForKey:@"objectString"];
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
    }
    
    return cell;
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
    else if(sender.tag==101){
        MoreCommentsViewController *morevc=[[MoreCommentsViewController alloc]init];
        morevc.role_id=@"4";
        morevc.client_id=obj_gz.foremanId;
        [self.navigationController pushViewController:morevc animated:YES];
    }
    
    lab_score.text =@"服务星级:";
    //[self.startView removeGestureRecognizer:self.tapGesture];
    [self.startView removeGestureRecognizer:self.panGesture];
//    NSInteger star_level=0;
//    if([obj.foremanLevel integerValue]<[obj.foremanLevel floatValue])
//        star_level=[obj.foremanLevel integerValue]*2+1;
//    else
//        star_level=[obj.foremanLevel integerValue]*2;
//    self.numberStart = star_level;
//    [self numberStartReLoad:self.numberStart];
}

#pragma mark -
#pragma mark - UIButton

-(void)pressbtn:(UIButton *)btn{
    GongzhangInfoObj *obj=[self.data_array firstObject];
    if (btn.tag==1001 && self.btn_shouc.selected==NO) {
        [savelogObj saveLog:@"用户收藏小工" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:23];
        [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang"] forState:UIControlStateNormal];
        self.btn_shouc.selected=YES;
        
        [SVProgressHUD showSuccessWithStatus:@"收藏成功" duration:1.0];
        
        [self requestCollect];
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:@"MygongzhangCollect.plist"];
        NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename];
        if (!arr_) {
            arr_=[NSMutableArray arrayWithCapacity:0];
        }
        NSMutableDictionary *dict_=[[NSMutableDictionary alloc]initWithCapacity:0];
        
        if(obj.foremanId)
            [dict_ setObject:[NSString stringWithFormat:@"%@",obj.foremanId] forKey:@"foremanId"];
        if(obj.nickName!=nil)
            [dict_ setObject:obj.nickName forKey:@"nickName"];
        if(obj.foremanIconPath!=nil)
            [dict_ setObject:obj.foremanIconPath forKey:@"foremanIconPath"];
        if(obj.foremanLevel)
            [dict_ setObject:obj.foremanLevel forKey:@"foremanLevel"];
        if(obj.foremanDesc!=nil)
            [dict_ setObject:obj.foremanDesc forKey:@"foremanDesc"];
        if(obj.foremanExperience!=nil)
            [dict_ setObject:obj.foremanExperience forKey:@"foremanExperience"];
        if(obj.address!=nil)
            [dict_ setObject:obj.address forKey:@"address"];
        if(obj.foremanMobile!=nil)
            [dict_ setObject:obj.foremanMobile forKey:@"foremanMobile"];
//        if(obj.designerPhoneNum!=nil)
//            [dict_ setObject:obj.designerPhoneNum forKey:@"designerPhoneNum"];
//        if(obj.designerWorks!=nil)
//            [dict_ setObject:obj.designerWorks forKey:@"designerWorks"];
        if(obj.browsePoints!=nil)
            [dict_ setObject:obj.browsePoints forKey:@"browsePoints"];
        if(obj.collectPoints!=nil)
            [dict_ setObject:obj.collectPoints forKey:@"collectPoints"];
        if([obj.foremanAuthzs count])
            [dict_ setObject:obj.foremanAuthzs forKey:@"foremanAuthzs"];
        if([obj.foremanImagesPath count])
            [dict_ setObject:obj.foremanImagesPath forKey:@"foremanImagesPath"];
        
        [arr_ addObject:dict_];
        [arr_ writeToFile:_filename atomically:NO];
    }
    
    else if(btn.tag==1003){
        //        [self requestRecordCallinfo];
        //        [savelogObj saveLog:@"用户拨打设计师电话" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:22];
        //        [self requestRecordCallinfo];
        //        NSString *osVersion = [[UIDevice currentDevice] systemVersion];
        //        NSString *serviceNumber;
        //        if([obj.designerMobileNum length]) serviceNumber=[obj.designerMobileNum stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        else serviceNumber=[obj.designerPhoneNum stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        if ([osVersion floatValue] >= 3.1) {
        //            UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        //            [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",serviceNumber]]]];
        //            webview.hidden = YES;
        //            // Assume we are in a view controller and have access to self.view
        //            [self.view addSubview:webview];
        //
        //        }else {
        //            // On 3.0 and below, dial as usual
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", serviceNumber]]];
        //        }
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]) {
            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
            login.delegate=self;
            [login show];
            return;
        }
        
        [self requestCheckSubcribeStatus:self.formanid];
        
    }
    
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
    
//    if(comment_title.length && star_int!=0)
//        [self requestEvaluationOfStar:comment_title star:star_int];
}

#pragma mark -
#pragma mark - gestrue

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
    //    if(sender.state==UIGestureRecognizerStateEnded){
    //        [self requestEvaluationOfStar];
    //    }
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
            } else {
                return;
            }
        }
    }
}

#pragma mark - 检查预约状态
-(void)requestCheckSubcribeStatus:(NSString *)designerIdStr {
    [self startRequestWithString:@"加载中..."];
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
        [postDict setObject:@"ID0131" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"businessID":designerIdStr,@"servantRoleId":@"4"};
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
                        self.view.tag = 1001;
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 101311) {
                        [self stopRequest];
                        SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
                        subscribeVC.businessIDStr = designerIdStr;
                        subscribeVC.servantRoleIdStr = @"4";
                        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
                        [appDelegate.nav pushViewController:subscribeVC animated:YES];
//                        [self.navigationController pushViewController:subscribeVC animated:YES];
                        
                    } else if (kResCode == 101319) {
                        [self stopRequest];
                        [TLToast showWithText:@"检查预约状态失败"];
                    } else if (kResCode == 101312) {
                        [self stopRequest];
                        _bookIdStr = [jsonDict objectForKey:@"bookId"];
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"亲，您已预约该师傅" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
                        alertView.delegate = self;
                        [alertView show];
                    }
                    
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:post];
    });
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    } else {
        [self requestSubcribeDetail:_bookIdStr];
    }
}

#pragma mark - 预约详情
-(void)requestSubcribeDetail:(NSString *)bookIdStr {
    [self startRequestWithString:@"加载中..."];
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
        [postDict setObject:@"ID0107" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"bookId":bookIdStr};
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
                        self.view.tag = 1001;
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 101071) {
                        [self stopRequest];
                        SubscribeListModel *model = [SubscribeListModel objectWithKeyValues:[jsonDict objectForKey:@"BookBean"]];
                        
                        MySubscribeDetailViewController *mySubscribeDetailVC = [[MySubscribeDetailViewController alloc]init];
                        SubscribeListModel *subcribeListModel = model;
                        //                        mySubscribeDetailVC.delegate = self;
                        mySubscribeDetailVC.subscribeListModel = subcribeListModel;
                        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                        [delegate.nav pushViewController:mySubscribeDetailVC animated:YES];
                        
                    } else if (kResCode == 101079) {
                        [self stopRequest];
                        [TLToast showWithText:@"查询失败"];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:post];
    });
    
}

#pragma mark -
#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    if (self.view.tag == 1001) {
//        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate.nav dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate.nav dismissViewControllerAnimated:YES completion:^{
//            SubscribeViewController *subscribeVC = [[SubscribeViewController alloc]initWithNibName:@"SubscribeViewController" bundle:nil];
//            subscribeVC.businessIDStr = self.formanid;
//            subscribeVC.servantRoleIdStr = @"4";
//            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate.nav pushViewController:subscribeVC animated:YES];
//        }];
//    }
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    if (self.view.tag == 1001) {
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
        [appDelegate.nav dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
        [appDelegate.nav dismissViewControllerAnimated:YES completion:^{
            SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
            subscribeVC.businessIDStr = self.formanid;
            subscribeVC.servantRoleIdStr = @"4";
            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.nav pushViewController:subscribeVC animated:YES];
        }];
//        __weak typeof(self) weakself = self;
//        [weakself.navigationController dismissViewControllerAnimated:YES completion:^{
//            SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
//            subscribeVC.businessIDStr = self.formanid;
//            subscribeVC.servantRoleIdStr = @"4";
//            [weakself.navigationController pushViewController:subscribeVC animated:YES];
//        }];
    }
   
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
