//
//  SubscribePeopleViewController.m
//  IDIAI
//
//  Created by iMac on 15-6-26.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "SubscribePeopleViewController.h"
#import "UIImage+fixOrientation.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TLToast.h"
#import "util.h"
#import "NSStringAdditions.h"
#import "MySubscribeViewController.h"
#import "LoginView.h"
#import "CustomProvinceCApicker.h"
#import "SubcriblePeopleCell.h"
#import "EditRequermentViewController.h"
#import "savelogObj.h"
#import "MBProgressHUD.h"
#import "IDIAIAppDelegate.h"
#import "ImageZoomView.h"

#define ORIGINAL_MAX_WIDTH 640.0f

#define kMath_Small_Tag 10000
#define kMath_LineView_Tag 100
#define kMath_Big_Tag 100000

#define kUIButton_Tag 1000000

@interface SubscribePeopleViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,LoginViewDelegate,CustomProvinceCApickerDelegate,EditRequermentVCDelegate,UITextFieldDelegate>
{
    UITableView *mtableView;
    
//     NSString *_callNum;//电话
    
    NSTimer *timer;
    
    NSInteger selectedMath;
    
    MBProgressHUD *phud;
}

@property (nonatomic,strong) UILabel *stepsDes_lab;

@end

@implementation SubscribePeopleViewController

- (void)customizeNavigationBar {
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [util imageWithColor:color];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[[self navigationController] navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[util imageWithColor:[UIColor colorWithHexString:@"#F1F0F6" alpha:1.0]];
    
    CGRect frame = CGRectMake(100, 29, 100, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkTextColor];
    label.text = @"预约";
    self.navigationItem.titleView=label;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fh_2"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 60);
    [leftButton addTarget:self
                   action:@selector(backTouched:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setFrame:CGRectMake(0, 0, 80, 40)];
//    [rightButton setImage:[UIImage imageNamed:@"ico_kefu"] forState:UIControlStateNormal];
//    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, -5)];
//    [rightButton addTarget:self
//                    action:@selector(CallGuestPhone)
//          forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 90, 40)];
    [rightButton setImage:[UIImage imageNamed:@"btn_dianhua"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 25, 0, -5);
    [rightButton addTarget:self
                    action:@selector(CallGuestPhone)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}

-(void)backTouched:(UIButton *)btn{
    [timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    if([self.fromStr isEqualToString:@"CollectionInfo"]){
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.nav setNavigationBarHidden:YES animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self customizeNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
   // self.view.backgroundColor=[UIColor colorWithHexString:@"#F8F8FF" alpha:1.0];
    
    selectedMath=1;
    if([self.servantRoleIdStr integerValue]==1) arr_desc=[NSArray arrayWithObjects:@"第一步，筛选中意的设计师，提交预约。设计是家装的灵魂，设计师可以帮助您对整个装修过程进行一个总体规划，同时综合您的思路与的想法，帮您量身设计一个满意的新家",@"第二步，预约成功后，电话沟通与设计师线下见面",@"第三步，达成合作意向，签订设计合同",@"第四步，设计服务订单分4个阶段托管，分别为：平面图、效果图、施工图和施工跟踪服务每阶段满意后再支付，最大限度保障装修设计效果。", nil];   //设计师
    else if([self.servantRoleIdStr integerValue]==4) arr_desc=[NSArray arrayWithObjects:@"第一步：筛选中意的工长，提交预约工长。对整个施工过程进行统筹安排，包括材料与工人的协调进场，施工质量的检查、施工进度的控制、施工现场的管理、材料入场时间安排等。",@"第二步：预约成功后，电话沟通用与工长线下见面",@"第三步：达成合作意向，签订施工合同",@"第四步：平台创建订单，分4个阶段托管，施工费用分别为：水电阶段、泥木阶段、油漆乳胶漆阶段、竣工验收阶段每阶段验收满意后再支付，控制施工质量，掌握绝对的主动权", nil];//工长
    else if([self.servantRoleIdStr integerValue]==6) arr_desc=[NSArray arrayWithObjects:@"第一步：筛选中意的监理，提交预约监理是装修过程中重要寻监官，监理可以帮您审核预算，避免高估冒算、工艺及材料描述不清；施工过程巡检、节点验收把好质量关，让您快乐装修、无忧入住。",@"第二步：预约成功后，电话沟通与监理线下见面",@"第三部：达成合作意向，签订监理合同",@"第四步：平台创建订单，分2个阶段托管，监理费用分别为：施工前期，施工后期每阶段满对监理的服务满意再支付，真正的第三方监理，拒绝施工猫腻。", nil];//监理
    
    //省市区数据
    arr_Province=[NSMutableArray array];
    
    self.tf_Contact=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, kMainScreenWidth-120, 40)];
    self.tf_Contact.delegate=self;
    self.tf_Contact.textAlignment=NSTextAlignmentRight;
    self.tf_Contact.textColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    self.tf_Contact.placeholder=@"请填写联系人";
    self.tf_Contact.font=[UIFont systemFontOfSize:16];
    self.tf_Contact.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.tf_Contact.returnKeyType=UIReturnKeyDone;
    
    self.tf_Phone=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, kMainScreenWidth-120, 40)];
    self.tf_Phone.delegate=self;
    self.tf_Phone.textAlignment=NSTextAlignmentRight;
    self.tf_Phone.textColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    self.tf_Phone.placeholder=@"请填写电话";
    self.tf_Phone.font=[UIFont systemFontOfSize:16];
    self.tf_Phone.keyboardType=UIKeyboardTypeNumberPad;
    self.tf_Phone.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.tf_Phone.returnKeyType=UIReturnKeyDone;
    
    self.tf_Area=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, kMainScreenWidth-150, 40)];
    self.tf_Area.delegate=self;
    self.tf_Area.textAlignment=NSTextAlignmentRight;
    self.tf_Area.placeholder=@"请填写装修面积";
    self.tf_Area.font=[UIFont systemFontOfSize:16];
    self.tf_Area.keyboardType=UIKeyboardTypeDecimalPad;
    self.tf_Area.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.tf_Area.returnKeyType=UIReturnKeyDone;
    
    self.tf_VillageName=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, kMainScreenWidth-120, 40)];
    self.tf_VillageName.delegate=self;
    self.tf_VillageName.textAlignment=NSTextAlignmentRight;
    self.tf_VillageName.placeholder=@"请填小区名称";
    self.tf_VillageName.font=[UIFont systemFontOfSize:16];
    self.tf_VillageName.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.tf_VillageName.returnKeyType=UIReturnKeyDone;
    
    self.tf_VillageAdd=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, kMainScreenWidth-120, 40)];
    self.tf_VillageAdd.delegate=self;
    self.tf_VillageAdd.textAlignment=NSTextAlignmentRight;
    self.tf_VillageAdd.placeholder=@"请填写小区地址";
    self.tf_VillageAdd.font=[UIFont systemFontOfSize:16];
    self.tf_VillageAdd.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.tf_VillageAdd.returnKeyType=UIReturnKeyDone;
    
    self.provindeCityArea_lab=[[UILabel alloc]initWithFrame:CGRectMake(100, 15, kMainScreenWidth-120, 20)];
    self.provindeCityArea_lab.backgroundColor=[UIColor clearColor];
    self.provindeCityArea_lab.textColor=[UIColor colorWithHexString:@"#CFCFCF" alpha:1.0];
    self.provindeCityArea_lab.textAlignment=NSTextAlignmentRight;
    self.provindeCityArea_lab.font=[UIFont systemFontOfSize:16];
    self.provindeCityArea_lab.text=@"请选择省市区";
    
    self.imgBtn1=[[UIButton alloc]initWithFrame:CGRectMake(20, 45, (kMainScreenWidth-80)/3, 70)];
    self.imgBtn1.tag=1000;
    self.imgBtn1.layer.masksToBounds = YES;
    self.imgBtn1.layer.cornerRadius = 3;
    self.imgBtn1.layer.borderColor = kFontPlacehoderCGColor;
    self.imgBtn1.layer.borderWidth = 1;
//    [self.imgBtn1 setBackgroundImage:[UIImage imageNamed:@"ic_add.png"] forState:UIControlStateNormal];
//    [self.imgBtn1 setImage: forState:]; \]
    [self.imgBtn1 setTitle:@"" forState:UIControlStateNormal];
    [self.imgBtn1 addTarget:self action:@selector(PresstakePhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.imgBtn1.selected=NO;
    
    self.imgback1 =[[UIImageView alloc] initWithFrame:self.imgBtn1.frame];
    self.imgback1.image =[UIImage imageNamed:@"ic_add.png"];
    self.imgback1.contentMode =UIViewContentModeCenter;
    
    self.imgBtn2=[[UIButton alloc]initWithFrame:CGRectMake(20+((kMainScreenWidth-80)/3+20)*1, 45, (kMainScreenWidth-80)/3, 70)];
    self.imgBtn2.tag=1001;
    self.imgBtn2.layer.masksToBounds = YES;
    self.imgBtn2.layer.cornerRadius = 3;
    self.imgBtn2.layer.borderColor = kFontPlacehoderCGColor;
    self.imgBtn2.layer.borderWidth = 1;
//    [self.imgBtn2 setImage:[UIImage imageNamed:@"ic_add.png"] forState:UIControlStateNormal];
//    [self.imgBtn2 setBackgroundImage:[UIImage imageNamed:@"ic_add.png"] forState:UIControlStateNormal];
    [self.imgBtn2 setTitle:@"" forState:UIControlStateNormal];
    [self.imgBtn2 addTarget:self action:@selector(PresstakePhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.imgBtn2.selected=NO;
    
    self.imgback2 =[[UIImageView alloc] initWithFrame:self.imgBtn2.frame];
    self.imgback2.image =[UIImage imageNamed:@"ic_add.png"];
    self.imgback2.contentMode =UIViewContentModeCenter;
    
    self.imgBtn3=[[UIButton alloc]initWithFrame:CGRectMake(20+((kMainScreenWidth-80)/3+20)*2, 45, (kMainScreenWidth-80)/3, 70)];
    self.imgBtn3.tag=1002;
    self.imgBtn3.layer.masksToBounds = YES;
    self.imgBtn3.layer.cornerRadius = 3;
    self.imgBtn3.layer.borderColor = kFontPlacehoderCGColor;
    self.imgBtn3.layer.borderWidth = 1;
//    [self.imgBtn3 setImage:[UIImage imageNamed:@"ic_add.png"] forState:UIControlStateNormal];
//    [self.imgBtn3 setBackgroundImage:[UIImage imageNamed:@"ic_add.png"] forState:UIControlStateNormal];
    [self.imgBtn3 setTitle:@"" forState:UIControlStateNormal];
    [self.imgBtn3 addTarget:self action:@selector(PresstakePhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.imgBtn3.selected=NO;
    
    self.imgback3 =[[UIImageView alloc] initWithFrame:self.imgBtn3.frame];
    self.imgback3.image =[UIImage imageNamed:@"ic_add.png"];
    self.imgback3.contentMode =UIViewContentModeCenter;
    
    CGSize sizeDesc=[util calHeightForLabel:[arr_desc objectAtIndexedSubscript:selectedMath-1] width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:15]];
    self.stepsDes_lab=[[UILabel alloc]initWithFrame:CGRectMake(15, 120, kMainScreenWidth-30, sizeDesc.height)];
    self.stepsDes_lab.backgroundColor=[UIColor clearColor];
    self.stepsDes_lab.font=[UIFont systemFontOfSize:15];
    self.stepsDes_lab.numberOfLines=0;
    self.stepsDes_lab.textColor=[UIColor grayColor];
    
    mtableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-50) style:UITableViewStyleGrouped];
    mtableView.delegate=self;
    mtableView.dataSource=self;
    mtableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mtableView];
    
    UIView *bottom_bg=[[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-50-64, kMainScreenWidth, 50)];
    bottom_bg.backgroundColor=[UIColor whiteColor];
    bottom_bg.layer.borderColor=[UIColor colorWithHexString:@"#F1F0F6" alpha:1.0].CGColor;
    bottom_bg.layer.borderWidth=1.0;
    [self.view addSubview:bottom_bg];
    
    UIButton *btn_yuyue = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_yuyue.frame = CGRectMake(kMainScreenWidth-110, 7.5, 80, 35);
    btn_yuyue.tag = 100;
    btn_yuyue.titleLabel.font=[UIFont systemFontOfSize:16];
    [btn_yuyue setTitle:@"预约" forState:UIControlStateNormal];
    //给按钮加一个白色的板框
    btn_yuyue.layer.borderColor = [[UIColor colorWithHexString:@"#EF6562" alpha:1.0] CGColor];
    btn_yuyue.layer.borderWidth = 1.0f;
    //给按钮设置弧度,这里将按钮变成了圆形
    btn_yuyue.layer.cornerRadius = 5.0f;
    btn_yuyue.layer.masksToBounds = YES;
    [btn_yuyue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_yuyue.backgroundColor=[UIColor colorWithHexString:@"#EF6562" alpha:1.0];
    [btn_yuyue addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottom_bg addSubview:btn_yuyue];
    
    UIButton *btn_quxiao = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_quxiao.frame = CGRectMake(30, 7.5, 80, 35);
    btn_quxiao.tag = 101;
    btn_quxiao.titleLabel.font=[UIFont systemFontOfSize:16];
    [btn_quxiao setTitle:@"取消" forState:UIControlStateNormal];
    //给按钮加一个白色的板框
    btn_quxiao.layer.borderColor = [[UIColor colorWithHexString:@"#EF6562" alpha:1.0] CGColor];
    btn_quxiao.layer.borderWidth = 0.5f;
    //给按钮设置弧度,这里将按钮变成了圆形
    btn_quxiao.layer.cornerRadius = 5.0f;
    btn_quxiao.layer.masksToBounds = YES;
    [btn_quxiao setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateNormal];
    btn_quxiao.backgroundColor=[UIColor whiteColor];
    [btn_quxiao addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottom_bg addSubview:btn_quxiao];
    
    UIView *footerView=[[UIView alloc]init];
    footerView.backgroundColor=[UIColor clearColor];
    
    UILabel *labTitle=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 20)];
    labTitle.backgroundColor=[UIColor clearColor];
    labTitle.textColor=[UIColor darkTextColor];
    labTitle.textAlignment=NSTextAlignmentLeft;
    labTitle.font=[UIFont systemFontOfSize:16];
    labTitle.text=@"温馨提示：";
    [footerView addSubview:labTitle];
    
    NSString *value=@"1、屋托邦针对所有用户不收取任何交易服务费用，因此不存在交易服务费用。\n2、与服务商进行线下交易而造成的资金损失屋托邦无法进行处理，为了保证你的交易权益请选择在线交易。";
    CGSize size=[util calHeightForLabel:value width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:13]];
    UILabel *labValue=[[UILabel alloc]initWithFrame:CGRectMake(15, 25, kMainScreenWidth-30, size.height)];
    labValue.backgroundColor=[UIColor clearColor];
    labValue.textColor=[UIColor grayColor];
    labValue.textAlignment=NSTextAlignmentLeft;
    labValue.font=[UIFont systemFontOfSize:13];
    labValue.numberOfLines=0;
    labValue.text=value;
    [footerView addSubview:labValue];
    footerView.frame=CGRectMake(0, 0, kMainScreenWidth, size.height+50);
    mtableView.tableFooterView=footerView;
    
    NSString *phoneStr = [[NSUserDefaults standardUserDefaults]objectForKey:User_Mobile];
    if (phoneStr) {
        self.tf_Phone.text = phoneStr;
    }
    
//    [self requestCallNum];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(changePicture) userInfo:nil repeats:YES];
    
    [self performSelector:@selector(delayTime) withObject:nil afterDelay:2.0];
}

-(void)delayTime{
    selectedMath++;
}

-(void)createProgressView{
    if (!phud) {
        phud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:phud];
        phud.mode=MBProgressHUDModeIndeterminate;
        //self.pHUD.dimBackground=YES; //是否开启背景变暗
        phud.labelText = @"";
        phud.blur=NO;  //是否开启ios7毛玻璃风格
        phud.darkBlur=YES; //受blur限制（blur为YES时设置darkBlur才有用）
        [phud show:YES];
    }
    else{
        [phud show:YES];
    }
}

#pragma mark -
#pragma mark - NSTimer

-(void)changePicture{
    UITableViewCell *cell=[mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    for(int i=0;i<4;i++){
        UIImageView *image_small=(UIImageView *)[cell viewWithTag:kMath_Small_Tag+i];
        if(!image_small)image_small=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-100)/8+2*i*(kMainScreenWidth-100)/8+i*20, 89.5, 25, 25)];
        image_small.tag=kMath_Small_Tag+i;
        if(selectedMath==i+1) image_small.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_phase_selected_%d",i+1]];
        else image_small.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_phase_normal_%d",i+1]];
        [cell addSubview:image_small];

        
        self.stepsDes_lab.text=[arr_desc objectAtIndexedSubscript:selectedMath-1];
        [cell addSubview:self.stepsDes_lab];
        
    }
    [mtableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    selectedMath++;
    if(selectedMath==5) selectedMath=1;
    
}

#pragma mark -
#pragma mark - UIBUttonr

-(void)PressbtnPicture:(UIButton *)btn{
    [timer invalidate];
    selectedMath=btn.tag-kUIButton_Tag+1;
    UITableViewCell *cell=[mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    for(int i=0;i<4;i++){
        UIImageView *image_small=(UIImageView *)[cell viewWithTag:kMath_Small_Tag+i];
        if(!image_small)image_small=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-100)/8+2*i*(kMainScreenWidth-100)/8+i*20, 89.5, 25, 25)];
        image_small.tag=kMath_Small_Tag+i;
        if(selectedMath==i+1) image_small.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_phase_selected_%d",i+1]];
        else image_small.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_phase_normal_%d",i+1]];
        [cell addSubview:image_small];
        
        self.stepsDes_lab.text=[arr_desc objectAtIndexedSubscript:selectedMath-1];
        [cell addSubview:self.stepsDes_lab];
    }
    [mtableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

    timer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(changePicture) userInfo:nil repeats:YES];
    selectedMath++;
    if(selectedMath==5) selectedMath=1;
}

-(void)btnPressed:(UIButton *)btn{
    if(btn.tag==100){
        if (![self verifyTheItems]) {
            return;
        }
        else{
            [self createProgressView];
            [self senderInfoToServer];
        }
    }
    else if (btn.tag==101){
        [timer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)PresstakePhoto:(UIButton *)btn{
     _tapIndex=btn.tag;
    if (btn.imageView.image) {
        [self tappress:btn];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [actionSheet showInView:self.view];
    }
    
}
-(void)tappress:(UIButton *)sender{
    ImageZoomView *zoomView = [[ImageZoomView alloc] initWithView:self.view.window Images:sender.imageView.image];
    [zoomView show];
}
-(void)DeleteImageBtn:(UIButton *)btn{
    if(btn.tag==10){
        UITableViewCell *cell=[mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        UIButton *btn=(UIButton *)[cell viewWithTag:10];
        [self.imgBtn1 setImage:nil forState:UIControlStateNormal];
        self.imgBtn1.imageView.image =nil;
//        [self.imgBtn1 setBackgroundImage:nil forState:UIControlStateNormal];
        self.imgBtn1.selected=NO;
        [btn removeFromSuperview];
        btn=nil;
    }
    else if(btn.tag==11){
        UITableViewCell *cell=[mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        UIButton *btn=(UIButton *)[cell viewWithTag:11];
        [self.imgBtn2 setImage:nil forState:UIControlStateNormal];
//        [self.imgBtn2 setBackgroundImage:nil forState:UIControlStateNormal];
        self.imgBtn2.imageView.image =nil;
        self.imgBtn2.selected=NO;
        [btn removeFromSuperview];
        btn=nil;
    }
    else{
        UITableViewCell *cell=[mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        UIButton *btn=(UIButton *)[cell viewWithTag:12];
        [self.imgBtn3 setImage:nil forState:UIControlStateNormal];
//        [self.imgBtn3 setBackgroundImage:nil forState:UIControlStateNormal];
        self.imgBtn3.imageView.image =nil;
        self.imgBtn3.selected=NO;
        [btn removeFromSuperview];
        btn=nil;
    }
}

#pragma mark = actionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        [self takePhoto];
    }
    if (buttonIndex==1) {
        [self LocalPhoto];
    }
}

#pragma mark -
#pragma mark - UITextfiled

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark -
#pragma mark -PickerViewDelegate

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
    
    self.provindeCityArea_lab.text=province_name;
    self.provindeCityArea_lab.textColor=[UIColor darkTextColor];
}

//#pragma mark - 获取电话号码
//- (void)requestCallNum {
//    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(parsingQueue, ^{
//        
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
//        
//        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
//        [postDict setObject:@"ID0036" forKey:@"cmdID"];
//        [postDict setObject:@"" forKey:@"token"];
//        [postDict setObject:@"" forKey:@"userID"];
//        [postDict setObject:@"iOS" forKey:@"deviceType"];
//        NSString *string=[postDict JSONString];
//        
//        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
//        [post setObject:string forKey:@"header"];
//        [post setObject:@"" forKey:@"body"];
//        
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
//                //NSLog(@"返回信息：%@",jsonDict);
//                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10361) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        _callNum = [jsonDict objectForKey:@"fbPhoneNumber"];
//                        NSLog(@"获取电话成功");
//                    });
//                }
//                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10369){
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSLog(@"获取电话失败");
//                    });
//                } else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                    });
//                }
//            });
//        }
//                          failedBlock:^{
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  
//                              });
//                          }
//                               method:url postDict:post];
//    });
//    
//    
//}
//
#pragma mark = 发送预约信息

-(void)senderInfoToServer{
    
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
    
    if(self.requireDescribe.length<1) self.requireDescribe=@"";
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:@"ID0140" forKey:@"cmdID"];
    [postDict setObject:string_token forKey:@"token"];
    [postDict setObject:string_userid forKey:@"userID"];
    [postDict setObject:@"ios" forKey:@"deviceType"];
    [postDict setObject:kCityCode forKey:@"cityCode"];
    
    NSString *string=[postDict JSONString];
    
    NSDictionary *bodyDic = @{@"businessID":self.businessIDStr,
                              @"name":self.tf_Contact.text,
                              @"phone":self.tf_Phone.text,
                              @"area":self.tf_Area.text,
                              @"houseName":self.tf_VillageName.text,
                              @"requirmentDisc":self.requireDescribe,
                              @"servantRoleId":self.servantRoleIdStr,
                              @"villageAddress":self.tf_VillageAdd.text,
                              @"provinceCode":self.provinceCode,
                              @"cityCode":self.cityCode,
                              @"areaCode":self.areaCode
                              };
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: url]];
    
    NSString *string02=[bodyDic JSONString];
    [request setPostValue:string forKey:@"header"];
    [request setPostValue:string02 forKey:@"body"];
    if (self.imgBtn1.selected==YES){
        NSData *data1=UIImageJPEGRepresentation(self.imgBtn1.imageView.image, 0.5);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName1 = [NSString stringWithFormat:@"%@.jpg", str];
        
        [request addData:data1 withFileName:fileName1 andContentType:@"image/jpeg" forKey:@"filedata"];
    }
    if (self.imgBtn2.selected==YES){
        NSData *data2=UIImageJPEGRepresentation(self.imgBtn2.imageView.image, 0.5);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName2 = [NSString stringWithFormat:@"%@.jpg", str];
        
        [request addData:data2 withFileName:fileName2 andContentType:@"image/jpeg" forKey:@"filedata"];
    }
    if (self.imgBtn3.selected==YES){
        
        NSData *data3=UIImageJPEGRepresentation(self.imgBtn3.imageView.image, 0.5);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName3 = [NSString stringWithFormat:@"%@.jpg", str];
        
        [request addData:data3 withFileName:fileName3 andContentType:@"image/jpeg" forKey:@"filedata"];
    }
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request startAsynchronous];
    
}

#pragma mark -
#pragma mark -ASIHTTPRequestDelegate

- (void)requestFailed:(ASIHTTPRequest *)request {
    [phud hide:YES];
    [TLToast showWithText:@"预约失败"];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [savelogObj saveLog:@"预约" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:55];
    
    [phud hide:YES];
    
    NSString *respString = [request responseString];
    NSDictionary *jsonDict = [respString objectFromJSONString];
    
    if (kResCode == 10002 || kResCode == 10003) {
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"预约成功" delegate:self cancelButtonTitle:@"查看预约" otherButtonTitles:@"继续浏览", nil];
        [alertView show];
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            //CGSize size=[util calHeightForLabel:[arr_desc objectAtIndexedSubscript:selectedMath-1] width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:15]];
            if(kMainScreenWidth>320) return 10+70+120;
            else return 10+90+120;
            break;
        }
        case 1:
            return 50;
            break;
        case 2:
            return 50;
            break;
        case 3:
            return 130;
            break;
        default:
            return 50;
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 5;
            break;
        case 3:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidener=@"mycellID";
    SubcriblePeopleCell *cell=[tableView dequeueReusableCellWithIdentifier:cellidener];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SubcriblePeopleCell" owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if(indexPath.section==0){
        for(int i=0;i<4;i++){
            if (i <3) {
                UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-100)/8+2*i*(kMainScreenWidth-100)/8+i*25+25, 100, (kMainScreenWidth-100)/8+2*(i+1)*(kMainScreenWidth-100)/8+(i+1)*25-((kMainScreenWidth-100)/8+2*i*(kMainScreenWidth-100)/8+i*25+25), 4)];
                switch (selectedMath) {
                    case 1:{
                        line.backgroundColor=[UIColor colorWithHexString:@"#F1F0F6" alpha:1.0];
                    }
                        break;
                    case 2:{
                        if (i ==0) {
                            line.backgroundColor=[UIColor colorWithHexString:@"#f6c9c7" alpha:1.0];
                        }else{
                            line.backgroundColor=[UIColor colorWithHexString:@"#F1F0F6" alpha:1.0];
                        }
                        
                    }
                        break;
                    case 3:{
                        if (i ==0||i==1) {
                            line.backgroundColor=[UIColor colorWithHexString:@"#f6c9c7" alpha:1.0];
                        }else{
                            line.backgroundColor=[UIColor colorWithHexString:@"#F1F0F6" alpha:1.0];
                        }
                    }
                        break;
                    case 4:{
                        if (i ==0||i==1||i==2) {
                            line.backgroundColor=[UIColor colorWithHexString:@"#f6c9c7" alpha:1.0];
                        }else{
                            line.backgroundColor=[UIColor colorWithHexString:@"#F1F0F6" alpha:1.0];
                        }
                    }
                        break;
                    default:
                        break;
                }
                
                
                line.tag =kMath_LineView_Tag+i;
                [cell addSubview:line];
            }
            
            UIImageView *image_small=(UIImageView *)[cell viewWithTag:kMath_Small_Tag+i];
            if(!image_small)image_small=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-100)/8+2*i*(kMainScreenWidth-100)/8+i*25, 89.5, 25, 25)];
            image_small.tag=kMath_Small_Tag+i;
            if(selectedMath==i+1) image_small.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_phase_selected_%d",i+1]];
            else image_small.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_phase_normal_%d",i+1]];
            [cell addSubview:image_small];
            
            UIImageView *image_big=(UIImageView *)[cell viewWithTag:kMath_Big_Tag+i];
            if(!image_big)image_big=[[UIImageView alloc]initWithFrame:CGRectMake((image_small.frame.origin.x+25/2)-30, 30, 60, 60)];
            image_big.tag=kMath_Big_Tag+i;
            image_big.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_phase_%d",i+1]];
            [cell addSubview:image_big];
            
            CGSize size=[util calHeightForLabel:[arr_desc objectAtIndexedSubscript:selectedMath-1] width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:15]];
            self.stepsDes_lab.frame=CGRectMake(15, 120, kMainScreenWidth-30, size.height);
            self.stepsDes_lab.text=[arr_desc objectAtIndexedSubscript:selectedMath-1];
            [cell addSubview:self.stepsDes_lab];
            
            UIButton *btn=(UIButton *)[cell viewWithTag:kUIButton_Tag+i];
            if(!btn) btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth/4*i, 0, kMainScreenWidth/4, 110)];
            btn.tag=kUIButton_Tag+i;
            [btn addTarget:self action:@selector(PressbtnPicture:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
    }
    
    if(indexPath.section==1 || indexPath.section==2){
        if(indexPath.section==1 && indexPath.row==0){
            UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 49.5, kMainScreenWidth-10, 0.5)];
            line.backgroundColor=[UIColor lightGrayColor];
            line.alpha=0.3;
            [cell addSubview:line];
        }
        if(indexPath.section==2 && indexPath.row!=4){
            UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 49.5, kMainScreenWidth-10, 0.5)];
            line.backgroundColor=[UIColor lightGrayColor];
            line.alpha=0.3;
            [cell addSubview:line];
        }
        if(indexPath.section==2 && indexPath.row==4) cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        NSArray *arr_title=@[@[@"联 系 人：",@"电       话:"],@[@"面      积：",@"省 市 区：",@"小区地址：",@"小区名称：",@"需求描述："]];
        cell.textLabel.text=[[arr_title objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        
        if(indexPath.section==1){
            if(indexPath.row==0) [cell addSubview:self.tf_Contact];
            else [cell addSubview:self.tf_Phone];
        }
        if(indexPath.section==2){
            if(indexPath.row==0) {
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-40, 15, 20, 20)];
                lab.backgroundColor=[UIColor clearColor];
                lab.textColor=[UIColor darkTextColor];
                lab.font=[UIFont systemFontOfSize:16];
                lab.text=@"m²";
                [cell addSubview:lab];
                [cell addSubview:self.tf_Area];
            }
            else if(indexPath.row==1) [cell addSubview:self.provindeCityArea_lab];
            else if(indexPath.row==2) [cell addSubview:self.tf_VillageAdd];
            else if(indexPath.row==3) [cell addSubview:self.tf_VillageName];
        }
    }
    if(indexPath.section==3){
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 20)];
        lab.backgroundColor=[UIColor clearColor];
        lab.textColor=[UIColor darkTextColor];
        lab.textAlignment=NSTextAlignmentLeft;
        lab.font=[UIFont systemFontOfSize:16];
        lab.text=@"插入图片：";
        [cell addSubview:lab];
        
        [cell addSubview:self.imgback1];
        [cell addSubview:self.imgBtn1];
        [cell addSubview:self.imgback2];
        [cell addSubview:self.imgBtn2];
        [cell addSubview:self.imgback3];
        [cell addSubview:self.imgBtn3];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==2 && indexPath.row==1){
        [self.view endEditing:YES];
        CustomProvinceCApicker *picker_pro = [[CustomProvinceCApicker alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250)title:@"选择省市区"];
        picker_pro.delegate=self;
        [picker_pro setSelectedTitles:arr_Province animated:YES];
        [picker_pro show];
    }
    else if (indexPath.section==2 && indexPath.row==4){
        EditRequermentViewController *editVC=[[EditRequermentViewController alloc]init];
        editVC.delegate=self;
        editVC.content=self.requireDescribe;
        editVC.fromwhere=self.fromStr;
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

#pragma mark - 头像设置

#pragma mark -
#pragma mark - UIImagePickerDelegate
//开始拍照
-(void)takePhoto
{
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
/*       
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;   //设置为前置摄像头
        }
 */
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             
                         }];
    }
    else
    {
        [TLToast showWithText:@"该设备不支持摄像头拍照" bottomOffset:200.0f duration:2.0];
    }
}

//打开本地相册
-(void)LocalPhoto
{
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             
                         }];
    }
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    portraitImg = [self imageByScalingToMaxSize:portraitImg];
    NSDictionary* metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
    [picker dismissViewControllerAnimated:YES completion:^{
        if(_tapIndex==1000) {
            
            [self.imgBtn1 setImage:portraitImg forState:UIControlStateNormal];
            self.imgBtn1.selected=YES;
            
            UITableViewCell *cell=[mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
            CGPoint origin = self.imgBtn1.frame.origin;
            CGSize size = self.imgBtn1.frame.size;
            
            UIButton *btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_delete.frame = CGRectMake(origin.x + size.width - 15, origin.y - 15, 30, 30);
            btn_delete.tag = 10;
            [btn_delete setImage:[UIImage imageNamed:@"ic_jian.png"] forState:UIControlStateNormal];
            [btn_delete addTarget:self action:@selector(DeleteImageBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn_delete];
        }
        else if(_tapIndex==1001) {
            [self.imgBtn2 setImage:portraitImg forState:UIControlStateNormal];
            self.imgBtn2.selected=YES;
            
            UITableViewCell *cell=[mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
            CGPoint origin = self.imgBtn2.frame.origin;
            CGSize size = self.imgBtn2.frame.size;
            
            UIButton *btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_delete.frame = CGRectMake(origin.x + size.width - 15, origin.y - 15, 30, 30);
            btn_delete.tag = 11;
            [btn_delete setImage:[UIImage imageNamed:@"ic_jian.png"] forState:UIControlStateNormal];
            [btn_delete addTarget:self action:@selector(DeleteImageBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn_delete];
        }
        else if(_tapIndex==1002) {
            [self.imgBtn3 setImage:portraitImg forState:UIControlStateNormal];
            self.imgBtn3.selected=YES;
            
            UITableViewCell *cell=[mtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
            CGPoint origin = self.imgBtn3.frame.origin;
            CGSize size = self.imgBtn3.frame.size;
            
            UIButton *btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_delete.frame = CGRectMake(origin.x + size.width - 15, origin.y - 15, 30, 30);
            btn_delete.tag = 12;
            [btn_delete setImage:[UIImage imageNamed:@"ic_jian.png"] forState:UIControlStateNormal];
            [btn_delete addTarget:self action:@selector(DeleteImageBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn_delete];
        }
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
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

#pragma mark -
#pragma mark - NSTimer

-(void)GetEditRequerment:(NSString *)title{
    self.requireDescribe=title;
    NSLog(@"---%@",self.requireDescribe);
}


#pragma mark - 预约前验证 未完张亮
- (BOOL)verifyTheItems {
    if ([NSString isEmptyOrWhitespace:self.tf_Contact.text]) {
        [TLToast showWithText:@"请输入联系人"];
        return NO;
    }else if (self.tf_Contact.text.length < 2 || self.tf_Contact.text.length > 4) {
        [TLToast showWithText:@"请填写2～4字的联系人姓名"];
        return NO;
    } else if (![util checkTel:self.tf_Phone.text]) {
        return NO;
    } else if ([NSString isEmptyOrWhitespace:self.tf_Area.text]) {
        [TLToast showWithText:@"请填写正确的房屋面积"];
        return NO;
    } else if ([self.tf_Area.text integerValue] < 0 || [self.tf_Area.text integerValue] > 1000) {
        [TLToast showWithText:@"面积应1-1000平方米"];
        return NO;
    } else if(![util isPureInt:self.tf_Area.text]){
       [TLToast showWithText:@"请输入整数面积数"];
        return NO;
    } else if (!self.provinceCode){
        [TLToast showWithText:@"请选择省市区"];
        return NO;
    }else if ([NSString isEmptyOrWhitespace:self.tf_VillageAdd.text]) {
        [TLToast showWithText:@"请输入小区地址"];
        return NO;
    } else if (self.tf_VillageAdd.text.length < 4 || self.tf_VillageAdd.text.length > 40) {
        [TLToast showWithText:@"请填写4～40字的小区地址"];
        return NO;
    }
    else if ([NSString isEmptyOrWhitespace:self.tf_VillageName.text]) {
          [TLToast showWithText:@"请输入小区名称"];
        return NO;
    } else if (self.tf_VillageName.text.length < 2 || self.tf_VillageName.text.length > 30) {
        [TLToast showWithText:@"请填写2～30字的小区名称"];
        return NO;
    }
    else if (self.requireDescribe.length > 200||self.requireDescribe.length<10) {
        [TLToast showWithText:@"请填写10～200字的需求描述"];
        return NO;
    }
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        MySubscribeViewController *mySubcribeVC = [[MySubscribeViewController alloc]init];
        [self.navigationController pushViewController:mySubcribeVC animated:YES];
    } else {
        if ([self.sourceStr isEqualToString:@"detailVC"] ) {
            NSArray * ctrlArray = self.navigationController.viewControllers;
            [self.navigationController popToViewController:[ctrlArray objectAtIndex:1] animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//呼叫客服电话
-(void)CallGuestPhone{
    [savelogObj saveLog:@"联系客服" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:29];
    
//    if (_callNum) {
        UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[callNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]]];
        webview.hidden = YES;
        [self.view addSubview:webview];
//    }
//    else {
//        [self requestCallNum];
//    }
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
