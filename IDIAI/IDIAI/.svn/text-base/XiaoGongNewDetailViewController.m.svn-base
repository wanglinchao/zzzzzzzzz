//
//  XiaoGongNewDetailViewController.m
//  IDIAI
//
//  Created by iMac on 15/10/22.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "XiaoGongNewDetailViewController.h"
#import "EmptyClearTableViewCell.h"
#import "savelogObj.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "util.h"
#import "OpenUDID.h"
#import "LoginView.h"
#import "TLToast.h"
#import "PicturesShowVC.h"
#import "MoreCommentsViewController.h"
#import "IDIAI3CommentViewController.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))
#define KImage_Tag 100
#define KAuthzs_Image_Tag 1000

@interface XiaoGongNewDetailViewController ()<UITableViewDataSource,UITableViewDelegate,LoginViewDelegate>

@property (nonatomic,strong) UIButton *headerBtn_one;
@property (nonatomic,strong) UIButton *headerBtn_two;
@property (nonatomic,strong) UIButton *headerBtn_three;
@property (nonatomic,strong) UIImageView *headerImv_one;
@property (nonatomic,strong) UIImageView *headerImv_two;
@property (nonatomic,strong) UIImageView *headerImv_three;

@property (nonatomic , strong) UIButton *btn_wyp;

@end

@implementation XiaoGongNewDetailViewController
@synthesize obj;
@synthesize btn_wyp;

- (void)customizeNavigationBar {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 50);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
//    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* doc_path_ = [path_ objectAtIndex:0];
//    NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:@"MyworkerCollect.plist"];
//    NSMutableArray *Arr_=[NSMutableArray arrayWithContentsOfFile:_filename_];
//    if (!Arr_) {
//        Arr_=[NSMutableArray arrayWithCapacity:0];
//    }
    if(!self.btn_shouc) self.btn_shouc = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_shouc.frame=CGRectMake(0, 0, 80, 40);
    self.btn_shouc.imageEdgeInsets=UIEdgeInsetsMake(0, 50, 0, -10);
//    if([Arr_ count]){
//        for(NSDictionary *dict in Arr_){
            if(obj.objId==obj.workerId){
                [self.btn_shouc setImage:[UIImage imageNamed:@"ic_shoucang_2"] forState:UIControlStateNormal];
                self.btn_shouc.selected=YES;
//                break;
            }
            else{
                [self.btn_shouc setImage:[UIImage imageNamed:@"ic_shoucang_nor_2"] forState:UIControlStateNormal];
                self.btn_shouc.selected=NO;
            }
//        }
//    }
//    else{
//        [self.btn_shouc setImage:[UIImage imageNamed:@"ic_shoucang_nor_2"] forState:UIControlStateNormal];
//        self.btn_shouc.selected=NO;
//    }
    [self.btn_shouc addTarget:self action:@selector(CollectedXiaoGong) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn_shouc];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self customizeNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"工人详情";
    
    self.dataArray_pl=[NSMutableArray arrayWithCapacity:0];
    
    _theTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight -64-40) style:UITableViewStyleGrouped];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_theTableView];
    
    obj.workerBrower=[NSString stringWithFormat:@"%ld",(long)[obj.workerBrower integerValue]+1];
    
    if([obj.phoneNumber length] || [obj.phoneNumber length])
        [self createPhone];
    //创建评论栏
    [self createPL];
    [self requestCommentsList];
    [self requestBrower];
}

#pragma mark -

-(void)createPhone{
    self.btn_phone = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_phone.frame=CGRectMake(kMainScreenWidth-50, kMainScreenHeight-250, 50, 50);
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh_mor.png"] forState:UIControlStateNormal];
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh.png"] forState:UIControlStateHighlighted];
    self.btn_phone.tag=1003;
    [self.btn_phone addTarget:self action:@selector(CallPhone) forControlEvents:UIControlEventTouchUpInside];
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
                    self.btn_phone.frame=CGRectMake(point.x-50, 0, 50, 50);
                }
                else if(point.y>kMainScreenHeight-64-40){
                    self.btn_phone.frame=CGRectMake(point.x-50, point.y-64-10, 50, 50);
                }
            }];
        }
    }
}

-(void)createPL{
    UIView *view_pl=[[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-64-40, kMainScreenWidth, 40)];
    view_pl.backgroundColor=[UIColor colorWithHexString:@"#F7F7F7" alpha:1.0];
    view_pl.layer.borderColor = [[UIColor colorWithHexString:@"#EBEBEB" alpha:1.0] CGColor];
    view_pl.layer.borderWidth = 0.5f;
    [self.view addSubview:view_pl];
    
    btn_wyp=[UIButton buttonWithType:UIButtonTypeCustom];
    btn_wyp.frame=CGRectMake(15, 5, kMainScreenWidth-40, 30);
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
    btn_wyp.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, kMainScreenWidth-40-80);
    btn_wyp.imageEdgeInsets=UIEdgeInsetsMake(5, 15, 5, kMainScreenWidth-40-35);
    [btn_wyp addTarget:self action:@selector(myappraise) forControlEvents:UIControlEventTouchUpInside];
    [view_pl addSubview:btn_wyp];
}

-(void)myappraise{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]){
        [self.view becomeFirstResponder];
//        comment=[[CommentsView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245)];
//        comment.delegate=self;
//        [UIView animateWithDuration:.25 animations:^{
//            comment.frame=CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245);
//        } completion:^(BOOL finished) {
//            if (finished) {
//                
//            }
//        }];
//        [comment show];
        IDIAI3CommentViewController *commentController =[[IDIAI3CommentViewController alloc] init];
        commentController.orderType =3;
        commentController.servantId =(int)obj.workerId;
        [self.navigationController pushViewController:commentController animated:YES];
    }
    else{
        self.view.tag = 1002;
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2 || section == 3) return 50;
    else return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section<3) return 0.001;
    else if(section==4) {
        if([obj.workerImgPath_arr count]) return 10.0;
        return 0.001;
    }
    else return 10.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIView *line_=[[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 0.5)];
        line_.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        line_.alpha=0.5;
        [bgView addSubview:line_];
        
        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 30)];
        designer_jianj.backgroundColor = [UIColor clearColor];
        designer_jianj.font = [UIFont systemFontOfSize:16.0];
        designer_jianj.textAlignment = NSTextAlignmentLeft;
        designer_jianj.textColor = [UIColor grayColor];
        designer_jianj.text =@"个人简介";
        [bgView addSubview:designer_jianj];
        
        if(!self.headerImv_one) self.headerImv_one = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
        self.headerImv_one.frame = CGRectMake(kMainScreenWidth-25, 22.5, 10, 5);
        [bgView addSubview:self.headerImv_one];
        
        if(!self.headerBtn_one) self.headerBtn_one = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headerBtn_one.frame = CGRectMake(0, 0, kMainScreenWidth , 50);
        [self.headerBtn_one addTarget:self
                      action:@selector(tapHeaderOne)
            forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:self.headerBtn_one];
        
        return bgView;
    }
    else if (section == 2){
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIView *line_=[[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 0.5)];
        line_.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        line_.alpha=0.5;
        [bgView addSubview:line_];
        
        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 30)];
        designer_jianj.backgroundColor = [UIColor clearColor];
        designer_jianj.font = [UIFont systemFontOfSize:16.0];
        designer_jianj.textAlignment = NSTextAlignmentLeft;
        designer_jianj.textColor = [UIColor grayColor];
        designer_jianj.text =@"业务范围";
        [bgView addSubview:designer_jianj];
        
        if(!self.headerImv_two) self.headerImv_two = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
        self.headerImv_two.frame = CGRectMake(kMainScreenWidth-25, 22.5, 10, 5);
        [bgView addSubview:self.headerImv_two];
        
        if(!self.headerBtn_two) self.headerBtn_two = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headerBtn_two.frame = CGRectMake(0, 0, kMainScreenWidth , 50);
        [self.headerBtn_two addTarget:self
                      action:@selector(tapHeaderTwo)
            forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:self.headerBtn_two];
        
        return bgView;
    }
    else if (section == 3)
    {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIView *line_=[[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 0.5)];
        line_.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
        line_.alpha=0.5;
        [bgView addSubview:line_];
        
        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 30)];
        designer_jianj.backgroundColor = [UIColor clearColor];
        designer_jianj.font = [UIFont systemFontOfSize:16.0];
        designer_jianj.textAlignment = NSTextAlignmentLeft;
        designer_jianj.textColor = [UIColor grayColor];
        designer_jianj.text =@"常驻地址";
        [bgView addSubview:designer_jianj];
        
        if(!self.headerImv_three) self.headerImv_three= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantoushaixuan"]];
        self.headerImv_three.frame = CGRectMake(kMainScreenWidth-25, 22.5, 10, 5);
        [bgView addSubview:self.headerImv_three];
        
        if(!self.headerBtn_three) self.headerBtn_three = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headerBtn_three.frame = CGRectMake(0, 0, kMainScreenWidth , 50);
        [self.headerBtn_three addTarget:self
                      action:@selector(tapHeaderThree)
            forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:self.headerBtn_three];
        
        return bgView;
    }
    else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0) return 1;
    else if (section==1){
        if(self.headerBtn_one.selected==YES) return 1;
        else return 0;
    }
    else if (section==2){
        if(self.headerBtn_two.selected==YES) return 1;
        else return 0;
    }
    else if (section==3){
        if(self.headerBtn_three.selected==YES) return 1;
        else return 0;
    }
    else if(section==4) {
        if([obj.workerImgPath_arr count]) return 1;
        else return 0;
    }
    else {
        if([self.dataArray_pl count]>5) return 2+5;
        else return 2+[self.dataArray_pl count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0) return 150;
    else if (indexPath.section==1) {
        CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",obj.workerInfo] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:14]];
        return size.height+10;
    }
    else if (indexPath.section==2) {
        NSMutableString *businessDesc=[NSMutableString string];
        for(NSDictionary *dict in obj.jobScopeName_arr) [businessDesc appendFormat:@"%@  ",[dict objectForKey:@"workerTypeName"]];
        CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",businessDesc] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:14]];
        return size.height+10;
    }
    else if (indexPath.section==3) {
        CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",obj.address] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:14]];
        return size.height+10;
    }
    else if (indexPath.section==4) return 30+5*kMainScreenWidth/16;
    else {
        if (indexPath.row==0 || indexPath.row==1) return 50;
        else {
            NSString *string_pl=[[self.dataArray_pl objectAtIndex:indexPath.row-2] objectForKey:@"objectString"];
            CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",string_pl] width:kMainScreenWidth-70 font:[UIFont systemFontOfSize:15]];
            return 40+size.height+10;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid=@"cellid";
    EmptyClearTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"EmptyClearTableViewCell" owner:nil options:nil]lastObject];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if(indexPath.section==0){
        UIImageView *UserLogo=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-70)/2, 10, 70, 70)];
        UserLogo.contentMode=UIViewContentModeScaleAspectFill;
        UserLogo.layer.cornerRadius=35;
        UserLogo.layer.masksToBounds=YES;
        [UserLogo sd_setImageWithURL:[NSURL URLWithString:obj.workerIconPath] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
        [cell addSubview:UserLogo];
        
        UILabel *UserName=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(UserLogo.frame)+10, kMainScreenWidth-20, 20)];
        UserName.backgroundColor=[UIColor clearColor];
        UserName.textAlignment=NSTextAlignmentCenter;
        UserName.textColor=[UIColor darkGrayColor];
        UserName.font=[UIFont systemFontOfSize:17];
        UserName.text=obj.nickName;
        [cell addSubview:UserName];
        
        UILabel *BrowerCount=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(UserName.frame)+5, kMainScreenWidth-20, 20)];
        BrowerCount.backgroundColor=[UIColor clearColor];
        BrowerCount.textAlignment=NSTextAlignmentCenter;
        BrowerCount.textColor=[UIColor lightGrayColor];
        BrowerCount.font=[UIFont systemFontOfSize:14];
        [cell addSubview:BrowerCount];
        if([obj.workerBrower integerValue]>=100000000) BrowerCount.text=[NSString stringWithFormat:@"浏览数 %.1f亿",[obj.workerBrower floatValue]/100000000.0];
        else if([obj.workerBrower integerValue]>=10000) BrowerCount.text=[NSString stringWithFormat:@"浏览数 %.1f万",[obj.workerBrower floatValue]/10000.0];
        else BrowerCount.text=[NSString stringWithFormat:@"浏览数 %lld",[obj.workerBrower longLongValue]];
        
        [self createAuthzs:cell Rect:UserLogo.frame];
    }
    else if(indexPath.section==1){
        CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",obj.workerInfo] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:14]];
        UILabel *PersonalDesc=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, size.height)];
        PersonalDesc.backgroundColor=[UIColor clearColor];
        PersonalDesc.textAlignment=NSTextAlignmentLeft;
        PersonalDesc.textColor=[UIColor lightGrayColor];
        PersonalDesc.font=[UIFont systemFontOfSize:14];
        PersonalDesc.text=obj.workerInfo;
        PersonalDesc.numberOfLines=0;
        [cell addSubview:PersonalDesc];
    }
    else if(indexPath.section==2){
        
        NSMutableString *businessDesc=[NSMutableString string];
        for(NSDictionary *dict in obj.jobScopeName_arr) [businessDesc appendFormat:@"%@  ",[dict objectForKey:@"workerTypeName"]];
        CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",businessDesc] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:14]];
        UILabel *BusinessDesc=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, size.height)];
        BusinessDesc.backgroundColor=[UIColor clearColor];
        BusinessDesc.textAlignment=NSTextAlignmentLeft;
        BusinessDesc.textColor=[UIColor lightGrayColor];
        BusinessDesc.font=[UIFont systemFontOfSize:14];
        BusinessDesc.numberOfLines=0;
        BusinessDesc.text=businessDesc;
        [cell addSubview:BusinessDesc];
    }
    else if(indexPath.section==3){
        CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",obj.address] width:kMainScreenWidth-20 font:[UIFont systemFontOfSize:14]];
        UILabel *PersonalAddress=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, size.height)];
        PersonalAddress.backgroundColor=[UIColor clearColor];
        PersonalAddress.textAlignment=NSTextAlignmentLeft;
        PersonalAddress.textColor=[UIColor lightGrayColor];
        PersonalAddress.font=[UIFont systemFontOfSize:14];
        PersonalAddress.text=obj.address;
        PersonalAddress.numberOfLines=0;
        [cell addSubview:PersonalAddress];
    }
    else if(indexPath.section==4){
        UILabel *count=[[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-100)/2, 5, 100, 20)];
        count.backgroundColor=[UIColor clearColor];
        count.textAlignment=NSTextAlignmentCenter;
        count.textColor=[UIColor lightGrayColor];
        count.font=[UIFont systemFontOfSize:14];
        count.text=[NSString stringWithFormat:@"共%ld张",(long)[obj.workerImgPath_arr count]];
        [cell addSubview:count];
        
        UIScrollView *scr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, kMainScreenWidth, 5*kMainScreenWidth/16)];
        [cell addSubview:scr];
        
        for(int i=0;i<[obj.workerImgPath_arr count];i++){
            NSDictionary *dict=[obj.workerImgPath_arr objectAtIndex:i];
            UIImageView *Img=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth/2.5+5)*i, 0, kMainScreenWidth/2.5, 5*kMainScreenWidth/16)];
            Img.tag=KImage_Tag+i;
            Img.contentMode=UIViewContentModeScaleAspectFill;
            Img.clipsToBounds=YES;
            Img.userInteractionEnabled=YES;
            [Img sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"imgsPath"]] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"] options:SDWebImageTransformAnimatedImage];
            [scr addSubview:Img];
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
            tap.numberOfTouchesRequired=1;
            tap.numberOfTapsRequired=1;
            [Img addGestureRecognizer:tap];
            
            if(i==[obj.workerImgPath_arr count]-1) scr.contentSize=CGSizeMake(CGRectGetMaxX(Img.frame), 5*kMainScreenWidth/16);
        }
    }
    else if(indexPath.section==5){
        if(indexPath.row==0){
            UILabel *starTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 80, 20)];
            starTitle.backgroundColor=[UIColor clearColor];
            starTitle.textAlignment=NSTextAlignmentLeft;
            starTitle.textColor=[UIColor grayColor];
            starTitle.font=[UIFont systemFontOfSize:16];
            starTitle.text=@"服务星级";
            [cell addSubview:starTitle];
            
            NSInteger srat_full=0;
            NSInteger srat_half=0;
            if([obj.workerLevel integerValue]<[obj.workerLevel floatValue]){
                srat_full=[obj.workerLevel integerValue];
                srat_half=1;
            }
            else if([obj.workerLevel integerValue]==[obj.workerLevel floatValue]){
                srat_full=[obj.workerLevel integerValue];
                srat_half=0;
            }
            for(int i=0;i<5;i++){
                if (i <srat_full) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(90 + i * 18, 17.5, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
                    [cell addSubview:imageView];
                }
                else if (i==srat_full && srat_half!=0) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(90 + i * 18, 17.5, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
                    [cell addSubview:imageView];
                }
                else {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(90 + i * 18, 17.5, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
                    [cell addSubview:imageView];
                }
            }
            
            UIView *line_=[[UIView alloc]initWithFrame:CGRectMake(10, 49.5, kMainScreenWidth-20, 0.5)];
            line_.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
            line_.alpha=0.5;
            [cell addSubview:line_];
        }
        else if(indexPath.row==1){
            UILabel *starTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 80, 20)];
            starTitle.backgroundColor=[UIColor clearColor];
            starTitle.textAlignment=NSTextAlignmentLeft;
            starTitle.textColor=[UIColor grayColor];
            starTitle.font=[UIFont systemFontOfSize:16];
            starTitle.text=@"更多评论";
            [cell addSubview:starTitle];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            UIView *line_=[[UIView alloc]initWithFrame:CGRectMake(10, 49.5, kMainScreenWidth-20, 0.5)];
            line_.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
            line_.alpha=0.5;
            [cell addSubview:line_];
        }
        else{
            UIImageView *PlunLogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
            PlunLogo.contentMode=UIViewContentModeScaleAspectFill;
            PlunLogo.layer.cornerRadius=20;
            PlunLogo.layer.masksToBounds=YES;
            PlunLogo.clipsToBounds=YES;
            [cell addSubview:PlunLogo];
            PlunLogo.image=[UIImage imageNamed:@"ic_touxiang_tk_over.png"];
            dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(parsingQueue, ^{
                if([[[self.dataArray_pl objectAtIndex:indexPath.row-2] objectForKey:@"userLogos"] length]>1)
                    [PlunLogo sd_setImageWithURL:[NSURL URLWithString:[[self.dataArray_pl objectAtIndex:indexPath.row-2] objectForKey:@"userLogos"]] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
                    });
            
            NSString *nameStr = [[self.dataArray_pl objectAtIndex:indexPath.row-2]objectForKey:@"nickName"];
            UILabel *plName=[[UILabel alloc]initWithFrame:CGRectMake(60, 12, kMainScreenWidth-180, 20)];
            plName.backgroundColor=[UIColor clearColor];
            plName.textAlignment=NSTextAlignmentLeft;
            plName.textColor=[UIColor lightGrayColor];
            plName.font=[UIFont systemFontOfSize:13];
            if(nameStr.length) plName.text = nameStr;
            else plName.text=@"匿名用户";
            [cell addSubview:plName];
            
            NSArray *arr=[[[self.dataArray_pl objectAtIndex:indexPath.row-2]objectForKey:@"createDate"] componentsSeparatedByString:@" "];
            UILabel *plDate=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(plName.frame)+10,  12, 100, 20)];
            plDate.backgroundColor=[UIColor clearColor];
            plDate.textAlignment=NSTextAlignmentRight;
            plDate.textColor=[UIColor lightGrayColor];
            plDate.font=[UIFont systemFontOfSize:13];
            if([arr count]) plDate.text=[arr firstObject];
            [cell addSubview:plDate];
            
            NSString *string_pl=[[self.dataArray_pl objectAtIndex:indexPath.row-2] objectForKey:@"objectString"];
            CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",string_pl] width:kMainScreenWidth-70 font:[UIFont systemFontOfSize:15]];
            UILabel *plContent=[[UILabel alloc]initWithFrame:CGRectMake(60, 37, kMainScreenWidth-70, size.height)];
            plContent.backgroundColor=[UIColor clearColor];
            plContent.textAlignment=NSTextAlignmentLeft;
            plContent.textColor=[UIColor grayColor];
            plContent.font=[UIFont systemFontOfSize:15];
            plContent.numberOfLines=0;
            plContent.text=string_pl;
            [cell addSubview:plContent];
            
            UIView *line_=[[UIView alloc]initWithFrame:CGRectMake(10, 40+size.height+9.5, kMainScreenWidth-20, 0.5)];
            line_.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
            line_.alpha=0.5;
            [cell addSubview:line_];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==5 && indexPath.row==1){
        MoreCommentsViewController *morevc=[[MoreCommentsViewController alloc]init];
        morevc.role_id=@"3";
        morevc.client_id=[NSString stringWithFormat:@"%ld",(long)obj.workerId];
        morevc.fromVCStr = self.fromVCStr;
        [self.navigationController pushViewController:morevc animated:YES];
    }
}

-(void)createAuthzs:(UITableViewCell *)cell Rect:(CGRect)rect{
    //获取要显示的资历评级
    NSMutableArray *_zlpj=[NSMutableArray array];
    NSArray *arr_zlpj=[[NSUserDefaults standardUserDefaults]objectForKey:@"zl"];
    if([arr_zlpj count]){
        for(NSDictionary *dict in arr_zlpj)
            [_zlpj addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"qId"]]];
    }
    //获取要显示的认证
    NSMutableArray *_rz=[NSMutableArray array];
    NSArray *arr_rz=obj.authentication_arr;
    if([arr_rz count]){
        for(NSDictionary *dict in arr_rz)
            [_rz addObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"authzId"]]];
    }
    
    UIView *bg_rz=[[UIView alloc] init];
    bg_rz.backgroundColor=[UIColor clearColor];
    [cell addSubview:bg_rz];
    
    NSInteger totalCount=[_zlpj count]+[_rz count];
    //清除认证图标
    for(int i=0; i<totalCount; i++){
        //创建认证
        UIImageView *image_rz=(UIImageView *)[bg_rz viewWithTag:KAuthzs_Image_Tag+i];
        if(image_rz) {
            [image_rz removeFromSuperview];
            image_rz=nil;
        }
    }
    
    float height=0;
    for(int i=0;i<[_zlpj count];i++){
        //创建资历
        UIImageView *image_rz=(UIImageView *)[bg_rz viewWithTag:KAuthzs_Image_Tag+i];
        if(!image_rz) image_rz=[[UIImageView alloc]init];
        image_rz.frame =CGRectMake(0, 29*i, 29, 13);
        image_rz.tag=KAuthzs_Image_Tag+i;
        image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_zlpj_%@.png",_zlpj[i]]];
        [bg_rz addSubview:image_rz];
        
        if(i==[_zlpj count]-1) height=CGRectGetMaxY(image_rz.frame)+5;
    }
    
    for(int i=0;i<[_rz count];i++){
        //创建认证
        UIImageView *image_rz=(UIImageView *)[bg_rz viewWithTag:KAuthzs_Image_Tag+[_zlpj count]+i];
        if(!image_rz) image_rz=[[UIImageView alloc]init];
        image_rz.frame =CGRectMake(0, height+29*i, 29, 13);
        image_rz.tag=KAuthzs_Image_Tag+[_zlpj count]+i;
        image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_new_%@.png",_rz[i]]];
        [bg_rz addSubview:image_rz];
        
        if(i==[_rz count]-1) height=CGRectGetMaxY(image_rz.frame)+5;
    }
    
    bg_rz.frame=CGRectMake(CGRectGetMaxX(rect)-6, CGRectGetMidY(rect)-height/2, 100, height);
}

#pragma mark -
#pragma mark - NetWorkRequest

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
        if([obj.phoneNumber length]>2) str_called=obj.phoneNumber;
        else str_called=@"";
        //获取被叫号码编号
        NSString *str_called_id;
        if(obj.workerId >=0) str_called_id=[NSString stringWithFormat:@"%ld",(long)obj.workerId];
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
        [postDict02 setObject:@"3" forKey:@"calledIdenttityType"];
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

//请求评论列表
-(void)requestCommentsList{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0037\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeId\":\"3\",\"objectId\":\"%@\",\"currentPage\":\"1\",\"requestRow\":\"5\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],[NSString stringWithFormat:@"%ld",(long)obj.workerId]];
        
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
                        if([self.dataArray_pl count]) [self.dataArray_pl removeAllObjects];
                        if([arr_pl count]){
                            for(NSDictionary *dict in arr_pl){
                                [self.dataArray_pl addObject:dict];
                            }
                        }
                        [_theTableView reloadData];
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0038\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeID\":\"3\",\"objectID\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],[NSString stringWithFormat:@"%ld",(long)obj.workerId]];
        
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0039\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeID\":\"3\",\"objectID\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)obj.workerId];
        
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

//评价
-(void)requestEvaluationOfStar:(NSString *)title star:(NSInteger)star{
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
        [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)obj.workerId] forKey:@"objectId"];
        [postDict02 setObject:title forKey:@"objectString"];
        [postDict02 setObject:@"3" forKey:@"objectTypeId"];
        if(star%2==0)
            [postDict02 setObject:[NSString stringWithFormat:@"%ld",(long)star/2] forKey:@"objectLevel"];
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
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                NSLog(@"评星：返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (code == 10002 || code == 10003) {
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    else if (code==10041){
                        [TLToast showWithText:@"评价成功，感谢您的支持" bottomOffset:220.0f duration:1.0];
                        obj.workerLevel=[jsonDict objectForKey:@"average"];
                        [_theTableView reloadData];
                        
                        [self requestCommentsList];
                    }
                    else if (code==10042)
                        [TLToast showWithText:@"亲，不符合评价的规则" bottomOffset:220.0f duration:1.0];
                    else if (code==10043)
                        [TLToast showWithText:@"亲，评价的内容过长" bottomOffset:220.0f duration:1.0];
                    else if (code==10049)
                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                    else
                        [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [TLToast showWithText:@"亲，评价失败哦" bottomOffset:220.0f duration:1.0];
                              });
                          }
                               method:url postDict:req_dict];
    });
}

#pragma mark -
#pragma mark - KeyBord
- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat kbSize = rect.size.height;
    NSLog(@"will---键盘高度：%f",kbSize);
    
    [UIView animateWithDuration:duration animations:^{
        comment.frame=CGRectMake(0, kMainScreenHeight-245-kbSize, kMainScreenWidth, 245);
    } completion:^(BOOL finished) {
        if (finished) {
            
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

#pragma mark - Btn_Actions

-(void)CallPhone{
    [self requestRecordCallinfo];
    [savelogObj saveLog:@"打电话--小工" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:48];
    NSString *serviceNumber=[obj.phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",serviceNumber]]]];
    webview.hidden = YES;
    // Assume we are in a view controller and have access to self.view
    [self.view addSubview:webview];
}

-(void)CollectedXiaoGong{
    if (self.btn_shouc.selected==NO) {
        [savelogObj saveLog:@"用户收藏小工" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:23];
        [self collectionAction:self.btn_shouc];
//        [self.btn_shouc setImage:[UIImage imageNamed:@"ic_shoucang_2"] forState:UIControlStateNormal];
//        self.btn_shouc.selected=YES;
//        
//        [SVProgressHUD showSuccessWithStatus:@"收藏成功" duration:1.0];
//        
//        [self requestCollect];
//        
//        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString* doc_path = [path objectAtIndex:0];
//        NSString* _filename = [doc_path stringByAppendingPathComponent:@"MyworkerCollect.plist"];
//        NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename];
//        if (!arr_) {
//            arr_=[NSMutableArray arrayWithCapacity:0];
//        }
//        NSMutableDictionary *dict_=[[NSMutableDictionary alloc]initWithCapacity:0];
//        
//        if(obj.workerId)
//            [dict_ setObject:[NSString stringWithFormat:@"%ld",(long)obj.workerId] forKey:@"workerId"];
//        if(obj.nickName!=nil)
//            [dict_ setObject:obj.nickName forKey:@"nickName"];
//        if(obj.workerIconPath!=nil)
//            [dict_ setObject:obj.workerIconPath forKey:@"workerIconPath"];
//        if(obj.workerLevel)
//            [dict_ setObject:obj.workerLevel forKey:@"workerLevel"];
//        if(obj.distance)
//            [dict_ setObject:[NSString stringWithFormat:@"%.2f",obj.distance] forKey:@"distance"];
//        if(obj.workerInfo!=nil)
//            [dict_ setObject:obj.workerInfo forKey:@"workerInfo"];
//        if(obj.address!=nil)
//            [dict_ setObject:obj.address forKey:@"address"];
//        if(obj.phoneNumber!=nil)
//            [dict_ setObject:obj.phoneNumber forKey:@"phoneNumber"];
//        if(obj.workerLongitude)
//            [dict_ setObject:[NSString stringWithFormat:@"%f",obj.workerLongitude] forKey:@"workerLongitude"];
//        if(obj.workerLatitude)
//            [dict_ setObject:[NSString stringWithFormat:@"%f",obj.workerLatitude] forKey:@"workerLatitude"];
//        if([obj.authentication_arr count])
//            [dict_ setObject:obj.authentication_arr forKey:@"authentication"];
//        if([obj.jobScopeName_arr count])
//            [dict_ setObject:obj.jobScopeName_arr forKey:@"jobScopeName"];
//        if([obj.workerImgPath_arr count])
//            [dict_ setObject:obj.workerImgPath_arr forKey:@"workerImgPath"];
//        
//        if(obj.workerBrower!=nil)
//            [dict_ setObject:obj.workerBrower forKey:@"browsePoints"];
//        
//        
//        [arr_ addObject:dict_];
//        [arr_ writeToFile:_filename atomically:NO];
    }
    else{
        [self collectionAction:self.btn_shouc];
//        [self.btn_shouc setImage:[UIImage imageNamed:@"ic_shoucang_nor_2"] forState:UIControlStateNormal];
//        self.btn_shouc.selected=NO;
//        
//        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功" duration:1.0];
//        
//        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString* doc_path = [path objectAtIndex:0];
//        NSString* _filename = [doc_path stringByAppendingPathComponent:@"MyworkerCollect.plist"];
//        NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename];
//        if (!arr_) {
//            arr_=[NSMutableArray arrayWithCapacity:0];
//        }
//        for(NSDictionary *dict in arr_){
//            if([[dict objectForKey:@"workerId"] integerValue]==obj.workerId){
//                [arr_ removeObject:dict];
//                break;
//            }
//            else
//                continue;
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
        
        NSDictionary *bodyDic = @{@"objId":[NSNumber numberWithInteger:obj.workerId ],@"isCollection":[NSNumber numberWithInt:!iscollect.selected],@"objType":[NSNumber numberWithInt:5]};
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
                            iscollect.selected =YES;
                            [self requestCollect];
                            
                        }else{
                            [TLToast showWithText:@"取消收藏成功"];
                            [iscollect setImage:[UIImage imageNamed:@"ic_shoucang_nor_2"] forState:UIControlStateNormal];
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
-(void)PressBarItemLeft{
    if(comment) [comment dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapHeaderOne{
    [UIView animateWithDuration:0.3 animations:^{
            self.headerImv_one.transform = CGAffineTransformRotate(self.headerImv_one.transform, DEGREES_TO_RADIANS(180));
    }];
    
    self.headerBtn_one.selected=!self.headerBtn_one.selected;
    
    [_theTableView beginUpdates];
    [_theTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_theTableView endUpdates];
}
-(void)tapHeaderTwo{
    [UIView animateWithDuration:0.3 animations:^{
        self.headerImv_two.transform = CGAffineTransformRotate(self.headerImv_two.transform, DEGREES_TO_RADIANS(180));
    }];
    
    self.headerBtn_two.selected=!self.headerBtn_two.selected;
    
    [_theTableView beginUpdates];
    [_theTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_theTableView endUpdates];
}
-(void)tapHeaderThree{
    [UIView animateWithDuration:0.3 animations:^{
        self.headerImv_three.transform = CGAffineTransformRotate(self.headerImv_three.transform, DEGREES_TO_RADIANS(180));
    }];
    
    self.headerBtn_three.selected=!self.headerBtn_three.selected;
    
    [_theTableView beginUpdates];
    [_theTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_theTableView endUpdates];
}

-(void)tapImage:(UIGestureRecognizer *)gers{
    NSInteger selected_picture=gers.view.tag-KImage_Tag;
    if(![util isConnectionAvailable]) [TLToast showWithText:@"无网络连接" topOffset:200.0f duration:1.0];
    PicturesShowVC *picvc=[[PicturesShowVC alloc]init];
    picvc.data_array=obj.workerImgPath_arr;
    picvc.type_pic=@"business";
    picvc.pic_id=selected_picture;
    [self.navigationController pushViewController:picvc animated:YES];
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

#pragma mark - LoginDelegate

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    comment=[[CommentsView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 245)];
    comment.delegate=self;
    [UIView animateWithDuration:.25 animations:^{
        comment.frame=CGRectMake(0, kMainScreenHeight-245-210, kMainScreenWidth, 245);
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
    [comment show];
    
    [self.view becomeFirstResponder];
}

-(void)cancel{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
