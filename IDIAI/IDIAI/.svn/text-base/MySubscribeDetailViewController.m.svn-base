//
//  MySubscribeDetailViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-18.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MySubscribeDetailViewController.h"
#import "util.h"
#import "UIButton+WebCache.h"
#import "AutomaticLogin.h"
#import "ShopClearblankCell.h"
#import "LoginView.h"
#import "TLToast.h"
#import "AttenceTimelineCell.h"
#import "ImageZoomView.h"
#import "IDIAIAppDelegate.h"
#import "UIImageView+WebCache.h"


#define Kimageview_tag 100     //凭证图
#define Kuibutton_tag 1000   //凭证图

#define KButtonTag 10000

//@implementation UIView (category)
//- (void)borderColor:(UIColor *)borderColor borderWidth:(float)borderWidth cornerRadius:(float)cornerRadius{
//    self.layer.borderColor = borderColor.CGColor;
//    self.layer.borderWidth = borderWidth;
//}
//@end

@interface MySubscribeDetailViewController () <UITableViewDataSource, UITableViewDelegate, LoginViewDelegate> {
    UITableView *_theTableView;
    NSMutableArray *dataSourceArr;
}

@property (nonatomic,strong) UIButton *btn_phone;
@property(nonatomic,strong)NSMutableDictionary *isOpenIndex;
@end

@implementation MySubscribeDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];

    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.nav setNavigationBarHidden:NO animated:NO];
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    delegate.nav.navigationBar.backgroundColor = [UIColor clearColor];
    [[delegate.nav navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    delegate.nav.navigationBar.shadowImage = nil;
    
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    //修改navBar字体大小文字颜色
    NSDictionary *attris = @{ NSFontAttributeName:[UIFont systemFontOfSize:19],
                              NSForegroundColorAttributeName:[UIColor blackColor] };
    [delegate.nav.navigationBar setTitleTextAttributes:attris];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillDisappear:(BOOL)animated{
    if([self.fromStr isEqualToString:@"CollectionInfo"]){
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.nav setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预约详情";
    
    dataSourceArr = [NSMutableArray arrayWithCapacity:4];
    for (NSDictionary *dic in self.subscribeListModel.orderFlowPhases) {
        NSString *string = [dic objectForKey:@"phaseName"];
        [dataSourceArr addObject:string];
    }
    self.isOpenIndex =[NSMutableDictionary dictionary];
    dataSourceArr =  [NSMutableArray arrayWithArray:[[dataSourceArr objectEnumerator] allObjects]];
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_theTableView];
    
    [_theTableView reloadData];
    
    if (self.subscribeListModel.bookStateId == 19) {
        [self createPhone];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0;
//    else {
//        return 50;
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if(section==0) return 15;
//    else return 0.1;
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1+[dataSourceArr count];
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return dataSourceArr.count;
    }
//    } else if (dataSourceArr.count == 4) {
//        if (section == 1) {
//            return self.count_first;
//        } else if (section == 2) {
//            return self.count_second;
//        } else if (section == 3) {
//            return self.count_third;
//        } else {
//            return self.count_fouth;
//        }
//        
//    } else if (dataSourceArr.count == 2) {
//        if (section == 1) {
//            return self.count_first;
//        } else if (section == 2) {
//            return self.count_second;
//        }
//    }
    return 0;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if(section==1){
//        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(60, 5, kMainScreenWidth - 60 - 8, 45)];
//        view_.backgroundColor=[UIColor clearColor];
//        
//        UIView *bgView = [[UIView alloc]initWithFrame:view_.frame];
//        bgView.backgroundColor = [UIColor whiteColor];
//        [view_ addSubview:bgView];
//        
//        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, kMainScreenWidth - 100, 30)];
//        designer_jianj.backgroundColor = [UIColor clearColor];
//        designer_jianj.font = [UIFont systemFontOfSize:16.0];
//        designer_jianj.textAlignment = NSTextAlignmentCenter;
//        designer_jianj.text = [NSString stringWithFormat:@"第一步  %@",[dataSourceArr objectAtIndex:section-1]];
//        [view_ addSubview:designer_jianj];
//        
//        UIImageView *roundIV1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
//        roundIV1.image = [UIImage imageNamed:@"bg_shuzi_1.png"];
//        [view_ addSubview:roundIV1];
//        
//        UIView *verticalLineView1 = [[UIView alloc]initWithFrame:CGRectMake(32.5, roundIV1.frame.origin.y + roundIV1.frame.size.height, 2, 25)];
//        verticalLineView1.backgroundColor = kThemeColor;
//        [view_ addSubview:verticalLineView1];
//        
//        self.imv_zkai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
//        self.imv_zkai.frame = CGRectMake(kMainScreenWidth-30, 18, 10, 20);
//        [view_ addSubview:self.imv_zkai];
//        if(is_change_first==YES){
//            if(is_open_first){
//                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//                [spinAnimation setFromValue:[NSNumber numberWithFloat:0]];
//                [spinAnimation setToValue:[NSNumber numberWithDouble:M_PI/2]];
//                [spinAnimation setDelegate:self];
//                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//                [spinAnimation setDuration:0.2];
//                [self.imv_zkai.layer addAnimation:spinAnimation forKey:@"spin"];
//                [self.imv_zkai.layer setTransform:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)];
//            }
//            else{
//                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//                [spinAnimation setFromValue:[NSNumber numberWithFloat:M_PI/2]];
//                [spinAnimation setToValue:[NSNumber numberWithDouble:0]];
//                [spinAnimation setDelegate:self];
//                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//                [spinAnimation setDuration:0.2];
//                [self.imv_zkai.layer addAnimation:spinAnimation forKey:@"spin"];
//                [self.imv_zkai.layer setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];
//            }
//        }
//        
//        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        headerBtn.frame = CGRectMake(0, 0, kMainScreenWidth, 50);
//        headerBtn.tag = 1001;
//        [headerBtn addTarget:self
//                      action:@selector(tapHeader:)
//            forControlEvents:UIControlEventTouchUpInside];
//        [view_ addSubview:headerBtn];
//        
//        return view_;
//    }
//    else if(section==2){
//        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(60, 5, kMainScreenWidth - 60 - 8, 45)];
//        view_.backgroundColor=[UIColor clearColor];
//        
//        UIView *bgView = [[UIView alloc]initWithFrame:view_.frame];
//        bgView.backgroundColor = [UIColor whiteColor];
//        [view_ addSubview:bgView];
//
//        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, kMainScreenWidth - 100, 30)];
//        designer_jianj.backgroundColor = [UIColor clearColor];
//        designer_jianj.font = [UIFont systemFontOfSize:16.0];
//        designer_jianj.textAlignment = NSTextAlignmentCenter;
//        designer_jianj.text = [NSString stringWithFormat:@"第二步  %@",[dataSourceArr objectAtIndex:section-1]];
//        [view_ addSubview:designer_jianj];
//        
//        UIImageView *roundIV2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
//        roundIV2.image = [UIImage imageNamed:@"bg_shuzi_2.png"];
//        [view_ addSubview:roundIV2];
//        
//        if([dataSourceArr count]!=2){
//            UIView *verticalLineView2 = [[UIView alloc]initWithFrame:CGRectMake(32.5, roundIV2.frame.origin.y + roundIV2.frame.size.height, 2, 25)];
//            verticalLineView2.backgroundColor = kThemeColor;
//            [view_ addSubview:verticalLineView2];
//        }
//        
//        self.imv_zkai_seond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
//        self.imv_zkai_seond.frame = CGRectMake(kMainScreenWidth-30, 18, 10, 20);
//        [view_ addSubview:self.imv_zkai_seond];
//        if(is_change_second==YES){
//            if(is_open_second){
//                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//                [spinAnimation setFromValue:[NSNumber numberWithFloat:0]];
//                [spinAnimation setToValue:[NSNumber numberWithDouble:M_PI/2]];
//                [spinAnimation setDelegate:self];
//                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//                [spinAnimation setDuration:0.2];
//                [self.imv_zkai_seond.layer addAnimation:spinAnimation forKey:@"spin"];
//                [self.imv_zkai_seond.layer setTransform:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)];
//                
//            }
//            else{
//                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//                [spinAnimation setFromValue:[NSNumber numberWithFloat:M_PI/2]];
//                [spinAnimation setToValue:[NSNumber numberWithDouble:0]];
//                [spinAnimation setDelegate:self];
//                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//                [spinAnimation setDuration:0.2];
//                [self.imv_zkai_seond.layer addAnimation:spinAnimation forKey:@"spin"];
//                [self.imv_zkai_seond.layer setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];
//            }
//        }
//        
//        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        headerBtn.frame = CGRectMake(0, 0, kMainScreenWidth, 50);
//        headerBtn.tag = 1002;
//        [headerBtn addTarget:self
//                      action:@selector(tapHeader:)
//            forControlEvents:UIControlEventTouchUpInside];
//        [view_ addSubview:headerBtn];
//        
//        return view_;
//    } if(section==3){
//       
//        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(60, 5, kMainScreenWidth - 60 - 8, 45)];
//        view_.backgroundColor=[UIColor clearColor];
//        
//        UIView *bgView = [[UIView alloc]initWithFrame:view_.frame];
//        bgView.backgroundColor = [UIColor whiteColor];
//        [view_ addSubview:bgView];
//        
//        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, kMainScreenWidth - 100, 30)];
//        designer_jianj.backgroundColor = [UIColor clearColor];
//        designer_jianj.font = [UIFont systemFontOfSize:16.0];
//        designer_jianj.textAlignment = NSTextAlignmentCenter;
//        designer_jianj.text = [NSString stringWithFormat:@"第三步  %@",[dataSourceArr objectAtIndex:section-1]];
//        [view_ addSubview:designer_jianj];
//        
//        UIImageView *roundIV3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
//        roundIV3.image = [UIImage imageNamed:@"bg_shuzi_3.png"];
//        [view_ addSubview:roundIV3];
//        
//        UIView *verticalLineView3 = [[UIView alloc]initWithFrame:CGRectMake(32.5, roundIV3.frame.origin.y + roundIV3.frame.size.height, 2, 25)];
//        verticalLineView3.backgroundColor = kThemeColor;
//        [view_ addSubview:verticalLineView3];
//        
//        self.imv_zkai_third = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
//        self.imv_zkai_third.frame = CGRectMake(kMainScreenWidth-30, 18, 10, 20);
//        [view_ addSubview:self.imv_zkai_third];
//        if(is_change_third==YES){
//            if(is_open_third){
//                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//                [spinAnimation setFromValue:[NSNumber numberWithFloat:0]];
//                [spinAnimation setToValue:[NSNumber numberWithDouble:M_PI/2]];
//                [spinAnimation setDelegate:self];
//                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//                [spinAnimation setDuration:0.2];
//                [self.imv_zkai_third.layer addAnimation:spinAnimation forKey:@"spin"];
//                [self.imv_zkai_third.layer setTransform:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)];
//                
//            }
//            else{
//                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//                [spinAnimation setFromValue:[NSNumber numberWithFloat:M_PI/2]];
//                [spinAnimation setToValue:[NSNumber numberWithDouble:0]];
//                [spinAnimation setDelegate:self];
//                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//                [spinAnimation setDuration:0.2];
//                [self.imv_zkai_third.layer addAnimation:spinAnimation forKey:@"spin"];
//                [self.imv_zkai_third.layer setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];
//            }
//        }
//        
//        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        headerBtn.frame = CGRectMake(0, 0, kMainScreenWidth, 50);
//        headerBtn.tag = 1003;
//        [headerBtn addTarget:self
//                      action:@selector(tapHeader:)
//            forControlEvents:UIControlEventTouchUpInside];
//        [view_ addSubview:headerBtn];
//        
//        return view_;
//    } if(section==4){
//      
//        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(60, 5, kMainScreenWidth - 60 - 8, 45)];
//        view_.backgroundColor=[UIColor clearColor];
//        
//        UIView *bgView = [[UIView alloc]initWithFrame:view_.frame];
//        bgView.backgroundColor = [UIColor whiteColor];
//        [view_ addSubview:bgView];
//        
//        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, kMainScreenWidth - 100, 30)];
//        designer_jianj.backgroundColor = [UIColor clearColor];
//        designer_jianj.font = [UIFont systemFontOfSize:16.0];
//        designer_jianj.textAlignment = NSTextAlignmentCenter;
//        designer_jianj.text = [NSString stringWithFormat:@"第四步  %@",[dataSourceArr objectAtIndex:section-1]];
//        [view_ addSubview:designer_jianj];
//        
//        UIImageView *roundIV4 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
//        roundIV4.image = [UIImage imageNamed:@"bg_shuzi_4.png"];
//        [view_ addSubview:roundIV4];
//        
//        self.imv_zkai_fourth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
//        self.imv_zkai_fourth.frame = CGRectMake(kMainScreenWidth-30, 18, 10, 20);
//        [view_ addSubview:self.imv_zkai_fourth];
//        if(is_change_fourth==YES){
//            if(is_open_fourth){
//                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//                [spinAnimation setFromValue:[NSNumber numberWithFloat:0]];
//                [spinAnimation setToValue:[NSNumber numberWithDouble:M_PI/2]];
//                [spinAnimation setDelegate:self];
//                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//                [spinAnimation setDuration:0.2];
//                [self.imv_zkai_fourth.layer addAnimation:spinAnimation forKey:@"spin"];
//                [self.imv_zkai_fourth.layer setTransform:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)];
//                
//            }
//            else{
//                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//                [spinAnimation setFromValue:[NSNumber numberWithFloat:M_PI/2]];
//                [spinAnimation setToValue:[NSNumber numberWithDouble:0]];
//                [spinAnimation setDelegate:self];
//                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//                [spinAnimation setDuration:0.2];
//                [self.imv_zkai_fourth.layer addAnimation:spinAnimation forKey:@"spin"];
//                [self.imv_zkai_fourth.layer setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];
//            }
//        }
//        
//        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        headerBtn.frame = CGRectMake(0, 0, kMainScreenWidth, 50);
//        headerBtn.tag = 1004;
//        [headerBtn addTarget:self
//                      action:@selector(tapHeader:)
//            forControlEvents:UIControlEventTouchUpInside];
//        [view_ addSubview:headerBtn];
//        
//        return view_;
//    } else {
//        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.1)];
//        view_.backgroundColor=[UIColor clearColor];
//        return nil;
//    }
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        float height=10;
        
        if(self.subscribeListModel.bookStateId == 18) height+=125;
        else height+=100;
        
        NSString *str_add;
        if([self.subscribeListModel.provinceName isEqualToString:self.subscribeListModel.cityName])
            str_add=[NSString stringWithFormat:@"%@%@%@ ",self.subscribeListModel.provinceName,self.subscribeListModel.areaName,self.subscribeListModel.villageAddress];
        else
            str_add=[NSString stringWithFormat:@"%@%@%@%@ ",self.subscribeListModel.provinceName,self.subscribeListModel.cityName,self.subscribeListModel.areaName,self.subscribeListModel.villageAddress];
        CGSize sizeAdd=[util calHeightForLabel:str_add width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:15]];
        height+=sizeAdd.height+sizeAdd.height/20*2+5;
        
        NSString *str_vil =[NSString stringWithFormat:@"小区名称: %@", self.subscribeListModel.villageName];
        CGSize sizevil =[util calHeightForLabel:str_vil width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:15]];
        height+=sizevil.height;
        
        NSString *str;
        if(self.subscribeListModel.description) str=self.subscribeListModel.description;
        else str=@"";
        CGSize sizeReason=[util calHeightForLabel:str width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:15]];
         height+=sizeReason.height+sizeReason.height/20*2+5;
        
        if(self.subscribeListModel.clientImgs.count){
//            height+=30;
            height+=(kMainScreenWidth-110)/3+5;
        }
//        else height+=30;
        if (self.subscribeListModel.remarks.length>0) {
            NSString *str_vil1 =[NSString stringWithFormat:@"失败原因: %@", self.subscribeListModel.remarks];
            CGSize sizevil1 =[util calHeightForLabel:str_vil1 width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:15]];
            height+=sizevil1.height+5;
        }
        if (self.subscribeListModel.bookStateId == 18) height+=45;
        
        return height+15;
    }
    else {
        
//        NSString *string_=[NSString stringWithFormat:@"%@ ",[[self.subscribeListModel.orderFlowPhases objectAtIndex:indexPath.section-1] objectForKey:@"phaseDesc"]];
        NSString *string_=[NSString stringWithFormat:@"%@ ",[[self.subscribeListModel.orderFlowPhases objectAtIndex:indexPath.row] objectForKey:@"phaseDesc"]];
        CGSize size=[util calHeightForLabel:string_ width:kMainScreenWidth-73 font:[UIFont systemFontOfSize:12]];
        BOOL isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
        if (isOpen ==NO) {
            return 55;
        }else{
            if (indexPath.row ==0) {
                return 55+size.height;
            }
            return 55+size.height+10;
        }
//        return size.height + 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"MySubscribeDetailCell1";
    static NSString *CellIdentifier2 = @"MySubscribeDetailCell2";
    
    if (indexPath.section == 0) {
        ShopClearblankCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"ShopClearblankCell" owner:nil options:nil] lastObject];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        UIView *view_bg=[[UIView alloc]init];
        view_bg.layer.cornerRadius=5;
        view_bg.backgroundColor=[UIColor whiteColor];
        [cell addSubview:view_bg];
        
        float height=10;
        
        
        
        UILabel *lab_name=[[UILabel alloc]initWithFrame:CGRectMake(10, height+5, (kMainScreenWidth-30)/2, 20)];
        lab_name.textColor=[UIColor blackColor];
        lab_name.textAlignment=NSTextAlignmentLeft;
        lab_name.font=[UIFont systemFontOfSize:16];
        lab_name.text=self.subscribeListModel.serviceProviderName;
        [view_bg addSubview:lab_name];
        
        UILabel *lab_State=[[UILabel alloc]initWithFrame:CGRectMake(10+(kMainScreenWidth-20)/2+10, height+5, (kMainScreenWidth-60)/2, 20)];
        lab_State.textColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
        lab_State.textAlignment=NSTextAlignmentRight;
        lab_State.font=[UIFont systemFontOfSize:16];
        lab_State.text= self.subscribeListModel.bookState;
        [view_bg addSubview:lab_State];
        
        height+=40;
        
        UIView *line_one=[[UIView alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-20, 0.5)];
        line_one.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
        [view_bg addSubview:line_one];
        
        height+=12;
        if (self.subscribeListModel.remarks.length>0) {
            NSString *str_vil1 =[NSString stringWithFormat:@"失败原因:%@", self.subscribeListModel.remarks];
            CGSize sizevil1=[util calHeightForLabel:str_vil1 width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:15]];
            UILabel *remark=[[UILabel alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-50, sizevil1.height)];
            remark.textColor=[UIColor redColor];
            remark.textAlignment=NSTextAlignmentLeft;
            remark.font=[UIFont systemFontOfSize:15];
            remark.numberOfLines=0;
            remark.text=[NSString stringWithFormat:@"失败原因:%@", self.subscribeListModel.remarks];
            [view_bg addSubview:remark];
            height+=remark.frame.size.height+5;
        }
        
        UILabel *villageNameTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 70, 20)];
        villageNameTitle.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
        villageNameTitle.textAlignment=NSTextAlignmentLeft;
        villageNameTitle.font=[UIFont systemFontOfSize:15];
        villageNameTitle.text=@"小区名称: ";
        [view_bg addSubview:villageNameTitle];
        
        NSString *str_vil =[NSString stringWithFormat:@"%@", self.subscribeListModel.villageName];
        CGSize sizevil=[util calHeightForLabel:str_vil width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:15]];
        UILabel *villageName=[[UILabel alloc]initWithFrame:CGRectMake(80, height+2, kMainScreenWidth-120, sizevil.height)];
        villageName.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
        villageName.textAlignment=NSTextAlignmentLeft;
        villageName.font=[UIFont systemFontOfSize:15];
        villageName.numberOfLines=0;
        villageName.text=[NSString stringWithFormat:@"%@", self.subscribeListModel.villageName];
        [view_bg addSubview:villageName];
        
        height+=villageName.frame.size.height+10;
        
        UILabel *bookDate=[[UILabel alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-50, 20)];
        bookDate.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
        bookDate.textAlignment=NSTextAlignmentLeft;
        bookDate.font=[UIFont systemFontOfSize:15];
        bookDate.text=[NSString stringWithFormat:@"预约时间: %@", self.subscribeListModel.bookDate];
        [view_bg addSubview:bookDate];
        
        height+=30;
        
        UILabel *bookStateTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height,80, 20)];
        bookStateTitle.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
        bookStateTitle.textAlignment=NSTextAlignmentLeft;
        bookStateTitle.font=[UIFont systemFontOfSize:15];
        bookStateTitle.text=@"预约倒计时: ";
        [view_bg addSubview:bookStateTitle];
        
        UILabel *bookState=[[UILabel alloc]initWithFrame:CGRectMake(93, height,kMainScreenWidth-140, 20)];
        bookState.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
        bookState.textAlignment=NSTextAlignmentLeft;
        bookState.font=[UIFont systemFontOfSize:15];
        NSArray *array = [self.subscribeListModel.bookRemainDate componentsSeparatedByString:@"分"]; //从字符A中分隔成2个元素的数组
        bookState.text = [[array firstObject]stringByAppendingString:@"分"];
        [view_bg addSubview:bookState];
        
        if(self.subscribeListModel.bookStateId == 18){
            bookStateTitle.hidden=NO;
            bookState.hidden=NO;
            height+=30;
        }
        else{
            bookStateTitle.hidden=YES;
            bookState.hidden=YES;
        }
        
        
        
        UILabel *villageAddressTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 70, 20)];
        villageAddressTitle.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
        villageAddressTitle.textAlignment=NSTextAlignmentLeft;
        villageAddressTitle.font=[UIFont systemFontOfSize:15];
        villageAddressTitle.text=@"小区地址: ";
        [view_bg addSubview:villageAddressTitle];
        
        NSString *str_add;
        if([self.subscribeListModel.provinceName isEqualToString:self.subscribeListModel.cityName])
            str_add=[NSString stringWithFormat:@"%@%@%@ ",self.subscribeListModel.provinceName,self.subscribeListModel.areaName,self.subscribeListModel.villageAddress];
        else
            str_add=[NSString stringWithFormat:@"%@%@%@%@ ",self.subscribeListModel.provinceName,self.subscribeListModel.cityName,self.subscribeListModel.areaName,self.subscribeListModel.villageAddress];
        CGSize sizeAdd=[util calHeightForLabel:str_add width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:15]];
        UILabel *villageAddress=[[UILabel alloc]initWithFrame:CGRectMake(80, height+2, kMainScreenWidth-120, sizeAdd.height)];
        villageAddress.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
        villageAddress.textAlignment=NSTextAlignmentLeft;
        villageAddress.font=[UIFont systemFontOfSize:15];
        villageAddress.numberOfLines=0;
        NSMutableAttributedString *attributedString_add = [[NSMutableAttributedString alloc] initWithString:str_add];
        NSMutableParagraphStyle *paragraphStyle_add = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle_add setLineSpacing:2];
        [attributedString_add addAttribute:NSParagraphStyleAttributeName value:paragraphStyle_add range:NSMakeRange(0, [str_add length])];
        villageAddress.attributedText=attributedString_add;
        [villageAddress sizeToFit];//必须
        [view_bg addSubview:villageAddress];
        
        height+=sizeAdd.height+sizeAdd.height/20*2+10;
        
        UILabel *descTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 70, 20)];
        descTitle.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
        descTitle.textAlignment=NSTextAlignmentLeft;
        descTitle.font=[UIFont systemFontOfSize:15];
        descTitle.text=@"需求描述: ";
        [view_bg addSubview:descTitle];
    
        NSString *str;
        if(self.subscribeListModel.description) str=self.subscribeListModel.description;
        else str=@"";
        CGSize sizeReason=[util calHeightForLabel:str width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:15]];
        UILabel *RefundReason=[[UILabel alloc]initWithFrame:CGRectMake(80, height+2, kMainScreenWidth-120, sizeReason.height)];
        RefundReason.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
        RefundReason.textAlignment=NSTextAlignmentLeft;
        RefundReason.font=[UIFont systemFontOfSize:15];
        RefundReason.numberOfLines=0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        RefundReason.attributedText=attributedString;
        [RefundReason sizeToFit];//必须
        [view_bg addSubview:RefundReason];
        
        height+=sizeReason.height+sizeReason.height/20*2+10;
        
        if(self.subscribeListModel.clientImgs.count){
            UILabel *PictureTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, height, 85, 20)];
            PictureTitle.textColor=[UIColor colorWithHexString:@"#a0a0a0"];
            PictureTitle.textAlignment=NSTextAlignmentLeft;
            PictureTitle.font=[UIFont systemFontOfSize:15];
            PictureTitle.text=@"照片: ";
            [view_bg addSubview:PictureTitle];
            
            height+=30;
            
            for (int i=0; i<self.subscribeListModel.clientImgs.count; i++) {
                UIImageView *photo_img=[[UIImageView alloc]initWithFrame:CGRectMake(10+i*50+(kMainScreenWidth-120)/3*i, height, (kMainScreenWidth-120)/3, (kMainScreenWidth-120)/3-10)];
                photo_img.tag=Kimageview_tag+i;
                photo_img.userInteractionEnabled=YES;
                photo_img.clipsToBounds=YES;
                photo_img.contentMode=UIViewContentModeScaleAspectFill;
                [photo_img sd_setImageWithURL:[NSURL URLWithString:[self.subscribeListModel.clientImgs objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"bg_morentu_tuku_1"]];
                [view_bg addSubview:photo_img];
                
                UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10+i*50+(kMainScreenWidth-120)/3*i, height, (kMainScreenWidth-120)/3, (kMainScreenWidth-120)/3)];
                btn.tag=Kuibutton_tag+i;
                [btn addTarget:self action:@selector(tappress:) forControlEvents:UIControlEventTouchUpInside];
                [view_bg addSubview:btn];
            }
            
            height+=(kMainScreenWidth-110)/3+5;
        }
        else height+=30;
        
        UIButton *btn_xiugai = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_xiugai.frame = CGRectMake(kMainScreenWidth-90, height, 80, 30);
        btn_xiugai.titleLabel.font=[UIFont systemFontOfSize:14];
        [btn_xiugai setTitle:@"取消预约" forState:UIControlStateNormal];
        //给按钮加一个白色的板框
        btn_xiugai.layer.borderColor = [[UIColor colorWithHexString:@"#EF6562" alpha:1.0] CGColor];
        btn_xiugai.layer.borderWidth = 1.0f;
        //给按钮设置弧度,这里将按钮变成了圆形
        btn_xiugai.layer.cornerRadius = 5.0f;
        btn_xiugai.layer.masksToBounds = YES;
        [btn_xiugai setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
        btn_xiugai.backgroundColor=[UIColor whiteColor];
        [btn_xiugai addTarget:self action:@selector(clicksubsribeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view_bg addSubview:btn_xiugai];
        if (self.subscribeListModel.bookStateId == 18) {
            btn_xiugai.hidden=NO;
            height+=45;
        }
        else {
            btn_xiugai.hidden=YES;
        }
        
        UIImageView *bottomImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, height, kMainScreenWidth, 10)];
//        bottomImage.image=[UIImage imageNamed:@"bg_dingdan"];
        bottomImage.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
        [view_bg addSubview:bottomImage];
    
        view_bg.frame=CGRectMake(0, 0, kMainScreenWidth, height);
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
//        if (cell == nil) {
//            cell = [[[NSBundle mainBundle]loadNibNamed:@"MySubscribeDetailCell2" owner:self options:nil]lastObject];
//        }
//        
//        bool isFirst = indexPath.row == 0;
//        bool isLast = indexPath.row == dataSourceArr.count - 1;
//        [(AttenceTimelineCell *)cell setDataSource:dataSourceArr[dataSourceArr.count - 1 - indexPath.row] isFirst:isFirst isLast:isLast];
//        
//        NSArray *imgNameArr = @[@"bg_shuzi_1.png",@"bg_shuzi_2.png",@"bg_shuzi_3.png",@"bg_shuzi_4.png"];
//        UIImageView *indicateIV = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 25, 25)];
//        [indicateIV setImage:[UIImage imageNamed:[imgNameArr objectAtIndex:indexPath.row]]];
//        [cell addSubview:indicateIV];
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor clearColor];
//           return cell;
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            UIView *contentBackView =[[UIView alloc] initWithFrame:CGRectMake(33, 5, kMainScreenWidth-43, 40)];
            
            contentBackView.layer.masksToBounds = YES;
            contentBackView.layer.cornerRadius = 10;
            contentBackView.layer.borderColor =[UIColor colorWithHexString:@"#efeff4"].CGColor;
            contentBackView.layer.borderWidth = 1;
//            contentBackView.hidden =YES;
            contentBackView.tag =100000;
            [cell addSubview:contentBackView];
            
            UIImageView *roundimage =[[UIImageView alloc] initWithFrame:CGRectMake(15, contentBackView.frame.origin.y+13, 14, 14)];
            roundimage.layer.masksToBounds = YES;
            roundimage.layer.cornerRadius = 7;
            roundimage.backgroundColor =[UIColor colorWithHexString:@"#ef6562"];
            roundimage.tag =100003;
            [cell addSubview:roundimage];
            
            UIImageView  *arrowimage =[[UIImageView alloc] initWithFrame:CGRectMake(contentBackView.frame.size.width-18, 16, 10, 5)];
            arrowimage.image =[UIImage imageNamed:@"ic_jintou_u.png"];
            arrowimage.tag =100004;
            [contentBackView addSubview:arrowimage];
            
            UILabel *phaseOrderNamelbl =[[UILabel alloc] initWithFrame:CGRectMake(11, 11, kMainScreenWidth-65, 15)];
            phaseOrderNamelbl.font =[UIFont systemFontOfSize:15];
            phaseOrderNamelbl.textColor =[UIColor colorWithHexString:@"#575757"];
            phaseOrderNamelbl.tag =10001;
            [contentBackView addSubview:phaseOrderNamelbl];
            
            UILabel *phaseDesclbl =[[UILabel alloc] initWithFrame:CGRectMake(15, phaseOrderNamelbl.frame.origin.y+phaseOrderNamelbl.frame.size.height+12, contentBackView.frame.size.width-30, 12)];
            phaseDesclbl.font =[UIFont systemFontOfSize:12];
            phaseDesclbl.tag =10002;
            phaseDesclbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            [contentBackView addSubview:phaseDesclbl];
        }
        cell.backgroundColor =[UIColor whiteColor];
        UIView *contentBackView =(UILabel *)[cell viewWithTag:100000];
        UILabel *phaseOrderNamelbl =(UILabel *)[contentBackView viewWithTag:10001];
        phaseOrderNamelbl.text =[dataSourceArr objectAtIndex:indexPath.row];
        UILabel *phaseDesclbl =(UILabel *)[contentBackView viewWithTag:10002];
        UIFont *font = [UIFont fontWithName:@"Arial" size:12];
        CGSize size = CGSizeMake(contentBackView.frame.size.width-30,2000);
        NSString *context=[[self.subscribeListModel.orderFlowPhases objectAtIndex:indexPath.row] objectForKey:@"phaseDesc"];
        CGSize labelsize = [context sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        phaseDesclbl.lineBreakMode = UILineBreakModeWordWrap;
        phaseDesclbl.numberOfLines =0;
        phaseDesclbl.frame =CGRectMake(phaseDesclbl.frame.origin.x, phaseDesclbl.frame.origin.y, labelsize.width, labelsize.height);
        phaseDesclbl.text =context;
        phaseDesclbl.font =font;
        int height =0;
        BOOL isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
        height =phaseDesclbl.frame.size.height+phaseDesclbl.frame.origin.y+15;
        if (indexPath.row ==0) {
            height =height-10;
        }
        if (isOpen ==YES) {
            contentBackView.frame =CGRectMake(contentBackView.frame.origin.x, contentBackView.frame.origin.y, contentBackView.frame.size.width, height);
            UIImageView *roundimage =(UIImageView *)[cell viewWithTag:100003];
            roundimage.frame =CGRectMake(15, contentBackView.frame.origin.y+13, 14, 14);
            UIImageView *arrowimage =(UIImageView *)[cell viewWithTag:100004];
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
            arrowimage.transform = transform;
        }else{
            contentBackView.frame =CGRectMake(contentBackView.frame.origin.x, contentBackView.frame.origin.y, contentBackView.frame.size.width, 40);
            UIImageView *roundimage =(UIImageView *)[cell viewWithTag:100003];
            roundimage.frame =CGRectMake(15, contentBackView.frame.origin.y+13, 14, 14);
            UIImageView *arrowimage =(UIImageView *)[cell viewWithTag:100004];
            CGAffineTransform transform = CGAffineTransformMakeRotation(0);
            arrowimage.transform = transform;
        }

//        NSString *sting_ = [NSString stringWithFormat:@"%@ ",[[self.subscribeListModel.orderFlowPhases objectAtIndex:indexPath.section-1] objectForKey:@"phaseDesc"]];
//        
//        if(sting_==nil) sting_=@"";
//        CGSize size=[util calHeightForLabel:sting_ width:kMainScreenWidth-60 - 20 font:[UIFont systemFontOfSize:15]];
//        UILabel *cs=(UILabel *)[cell.contentView viewWithTag:KButtonTag+indexPath.row+indexPath.section];
//        if(!cs)
//        cs = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-60 - 20, size.height+25)];
//        cs.tag=KButtonTag+indexPath.row+indexPath.section;
//        cs.backgroundColor = [UIColor whiteColor];
//        cs.font = [UIFont systemFontOfSize:15.0];
//        cs.textAlignment = NSTextAlignmentLeft;
//        cs.numberOfLines=0;
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:sting_];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:5];
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [sting_ length])];
//        cs.textColor = [UIColor grayColor];
//        cs.attributedText=attributedString;
//        [cs sizeToFit];//必须
//        
//        for (UIView *view in cell.contentView.subviews) {
//            if ([view isKindOfClass:[UIView class]]) {
//                [view removeFromSuperview];
//            }
//        }
//        
//        UIView *cellBgView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, kMainScreenWidth-60 - 8, size.height+10)];
//        cellBgView.backgroundColor = [UIColor whiteColor];
//        [cellBgView addSubview:cs];
//        
//        [cell.contentView addSubview:cellBgView];
//        
//        UIView *verticalLineView = (UIView *)[cell viewWithTag:1001];
//        if (verticalLineView == nil)
//            verticalLineView = [[UIView alloc]initWithFrame:CGRectMake(32.5, 10, 2, cell.frame.size.height + 20)];
//        verticalLineView.tag = 1001;
//        verticalLineView.backgroundColor = kThemeColor;
//        [cell.contentView addSubview:verticalLineView];
//        
//        if (indexPath.section == dataSourceArr.count) {
//            UIView *verticalLineView = (UIView *)[cell.contentView viewWithTag:1001];
//            [verticalLineView removeFromSuperview];
//        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1) {
        BOOL isOpen =[[self.isOpenIndex objectForKey:indexPath] boolValue];
        isOpen =!isOpen;
        [self.isOpenIndex setObject:[NSNumber numberWithBool:isOpen] forKey:indexPath];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]  withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)clicksubsribeBtn:(id)sender {
    NSString *bookIDStr = [NSString stringWithFormat:@"%ld",(long)self.subscribeListModel.id];
    [self requestCancelSubcribe:bookIDStr];
}

- (void)tapHeader:(UIButton *)sender {
    if (sender.tag==1001) {
        is_change_first=YES;
        is_change_second = NO;
        is_change_third = NO;
        is_change_fourth = NO;
        self.count_second=0;
        self.count_third = 0;
        self.count_fouth = 0;
        if(is_open_first) {
            is_open_second=NO;
            is_open_third = NO;
            is_open_fourth = NO;
            is_open_first=!is_open_first;
            self.count_first=0;
        }
        else {
            is_open_second=NO;
            is_open_third = NO;
            is_open_fourth = NO;
            is_open_first=!is_open_first;
            self.count_first=1;
        }
        [_theTableView reloadData];
    }
    if (sender.tag==1002) {
        is_change_first=NO;
        is_change_second = YES;
        is_change_third = NO;
        is_change_fourth = NO;
        self.count_first=0;
        self.count_third = 0;
        self.count_fouth = 0;
        if(is_open_second) {
            is_open_first=NO;
            is_open_third = NO;
            is_open_fourth = NO;
            is_open_second=!is_open_second;
            self.count_second=0;
        }
        else {
            is_open_first=NO;
            is_open_third = NO;
            is_open_fourth = NO;
            is_open_second=!is_open_second;
            self.count_second=1;
        }
        [_theTableView reloadData];
    }
    if (sender.tag==1003) {
        is_change_first=NO;
        is_change_second = NO;
        is_change_third = YES;
        is_change_fourth = NO;
        self.count_first=0;
        self.count_second = 0;
        self.count_fouth = 0;
        if(is_open_third) {
            is_open_first=NO;
            is_open_second = NO;
            is_open_fourth = NO;
            is_open_third=!is_open_third;
            self.count_third=0;
        }
        else {
            is_open_first=NO;
            is_open_second = NO;
            is_open_fourth = NO;
            is_open_third=!is_open_third;
            self.count_third=1;
        }
        [_theTableView reloadData];
    }
    if (sender.tag==1004) {
        is_change_first=NO;
        is_change_second = NO;
        is_change_third = NO;
        is_change_fourth = YES;
        self.count_first=0;
        self.count_second = 0;
        self.count_third = 0;
        if(is_open_fourth) {
            is_open_first=NO;
            is_open_second = NO;
            is_open_third = NO;
            is_open_fourth=!is_open_fourth;
            self.count_fouth=0;
        }
        else {
            is_open_first=NO;
            is_open_second = NO;
            is_open_third = NO;
            is_open_fourth=!is_open_fourth;
            self.count_fouth=1;
        }
        [_theTableView reloadData];
    }
}


#pragma mark - 取消预约
-(void)requestCancelSubcribe:(NSString *)bookIdStr {
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
        [postDict setObject:@"ID0108" forKey:@"cmdID"];
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
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 10701) {
                        [self stopRequest];
                        
                        self.subscribeListModel.bookStateId = 22;
                        self.subscribeListModel.bookState=@"已取消";
                        [_theTableView reloadData];
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(stateBtnDidClick:)]) {
                        [self.delegate stateBtnDidClick:self];
                        }
    
                        [TLToast showWithText:@"取消预约成功"];
                    } else if (kResCode == 10709) {
                        [self stopRequest];
                        [TLToast showWithText:@"取消预约失败"];
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

- (void)pressbtn:(UIButton *)sender {
    NSString *callNumStr = [NSString stringWithFormat:@"tel://4008887372",self.subscribeListModel.serviceProviderTel];
    UIWebView *callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
    [self.view addSubview:callWebview];
}

-(void)tappress:(UIButton *)sender{
    UITableViewCell *cell=[_theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIImageView *imageview_big=(UIImageView *)[cell viewWithTag:sender.tag-Kuibutton_tag+Kimageview_tag];
    ImageZoomView *zoomView = [[ImageZoomView alloc] initWithView:self.view.window Images:imageview_big.image];
    [zoomView show];
}

#pragma mark -
#pragma mark - LoginDelegate

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    [self stopRequest];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
