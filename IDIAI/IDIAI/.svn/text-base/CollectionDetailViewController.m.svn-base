//
//  CollectionDetailViewController.m
//  IDIAI
//
//  Created by Ricky on 15-4-9.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "CollectionDetailViewController.h"
#import "GoodsListCell.h"
#import "util.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+OnlineImage.h"
#import "DesignerListCell.h"
#import "EmptyClearTableViewCell.h"
#import "WorkerListObj.h"
#import "ForemanListCell.h"
#import "ForemanObj.h"
#import "DecorateProcessObj.h"
#import "DecorateInfoVC.h"
#import "XiaoGongNewDetailViewController.h"
#import "DesignerInfoObj.h"
#import "DesignerDetailViewController.h"
#import "GongzhangListObj.h"
#import "GongzhangDetailViewController.h"
#import "SupervisorListObj.h"
#import "JianliDetailViewController.h"
#import "GoodslistObj.h"
#import "BusinessInfoVC.h"
#import "TLToast.h"
#import "TMQuiltView.h"
#import "CollectPictureCell.h"
#import "EffectPictureInfo.h"
#import "EffectTAOTUPictureInfo.h"
#import "TMPhotoQuiltViewCell.h"
#import "CollectDesignerCell.h"
#import "IDIAI3DesignerDetailViewController.h"
#import "IDIAI3GongZhangDetaileViewController.h"
#import "IDIAI3JianLiDetailViewController.h"
#import "SubscribePeopleViewController.h"
#import "MySubscribeDetailViewController.h"
#import "LoginView.h"
#import "IDIAIAppDelegate.h"
#import "SubscribeListModel.h"

#define kButton_Tag 10
#define kButton_Tag_shop_first 100
#define kButton_Tag_shop_second 1000
#define kButton_Tag_shop_third 10000
#define kButton_Tag_shop_fourth 100000
#define kButton_Tag_designer_first 2000
#define kButton_Tag_designer_second 20000
#define kButton_Tag_picture_delete 3000

#define KButtonTag_phone 10000

#define KSubjectTitleTAG 1000000
#define KPicture_TAG 2000000
#define KDescription_TAG 3000000
#define KLine_TAG 4000000
#define KUILabelTag_YuYueCount 110000
#define kButton_Booking 120000
#import "PullingRefreshTableView.h"
@interface CollectionDetailViewController () <UIGestureRecognizerDelegate,UITableViewDataSource, UITableViewDelegate,TMQuiltViewDataSource, TMQuiltViewDelegate,LoginViewDelegate,PullingRefreshTableViewDelegate,BMKLocationServiceDelegate> {
    PullingRefreshTableView *_theTableView;
        UIButton *_btn_designer;
    TMQuiltView *qtmquitView;
    BMKLocationService* _locService;
//    NSMutableArray *_wantPicMutArr;
}

@property (nonatomic,strong) UIScrollView *scr;
@property (nonatomic,strong) UIButton *editBtn;
@property (nonatomic,strong)CLLocation *userLocation;
@end


@implementation CollectionDetailViewController
@synthesize editBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    
    editBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    editBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"取消" forState:UIControlStateSelected];
    [editBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [editBtn addTarget:self action:@selector(editCell:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:editBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    editBtn.selected=NO;
    if ([self.selected_type isEqualToString:@"装修方案"] || [self.selected_type isEqualToString:@"效果图"]) {

        if ([self.selected_type isEqualToString:@"装修方案"]) {
            [self requstplanList];
        }else{
            [self requstrenderingList];
        }
        [qtmquitView reloadData];
    } else {
        [_theTableView launchRefreshing];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.selected_type;
    self.view.backgroundColor = [UIColor whiteColor];

    if ([self.selected_type isEqualToString:@"装修方案"] || [self.selected_type isEqualToString:@"效果图"]) {
        qtmquitView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
        qtmquitView.delegate = self;
        qtmquitView.dataSource = self;
        qtmquitView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        qtmquitView.showsHorizontalScrollIndicator=NO;
        qtmquitView.showsVerticalScrollIndicator=NO;
        [self.view addSubview:qtmquitView];
        if ([self.selected_type isEqualToString:@"装修方案"]) {
            [self requstplanList];
        }else{
            [self requstrenderingList];
        }
        [qtmquitView reloadData];
    } else {
        _theTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _theTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _theTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) pullingDelegate:self];
        _theTableView.dataSource = self;
        _theTableView.delegate = self;
        _theTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _theTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _theTableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_theTableView];
        [_theTableView launchRefreshing];
        if ([self.selected_type isEqualToString:@"工人"]) {
            if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
                if (!_locService) {
                    _locService = [[BMKLocationService alloc]init];
                    _locService.delegate=self;
                }
                [_locService startUserLocationService];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用"
                                                                message:@"GPS定位尚未打开，请在设置中开启定位"
                                                               delegate:self
                                                      cancelButtonTitle:@"否"
                                                      otherButtonTitles:@"是",nil];
                [alert show];
            }
        }
    }
    [self loadImageviewBG];
     label_bg.text = @"暂无收藏";
    if (self.data_array.count<=0) {
        imageview_bg.hidden =NO;
        label_bg.hidden =NO;
    }
  
/************************
    //添加长按手势
    UILongPressGestureRecognizer *lpgesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(presslonggesture:)];
    [qtmquitView addGestureRecognizer:lpgesture];
************************/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    view.backgroundColor=[UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0 && [self.selected_type isEqualToString:@"装修知识"]) return 10;
    else if ([self.selected_type isEqualToString:@"设计师"] || [self.selected_type isEqualToString:@"工长"] || [self.selected_type isEqualToString:@"监理"] || [self.selected_type isEqualToString:@"工人"]) return 10;
    else return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.selected_type isEqualToString:@"设计师"] || [self.selected_type isEqualToString:@"工长"] || [self.selected_type isEqualToString:@"监理"] || [self.selected_type isEqualToString:@"工人"]) {
        return [self.data_array count];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.selected_type isEqualToString:@"设计师"] || [self.selected_type isEqualToString:@"工长"] || [self.selected_type isEqualToString:@"监理"] || [self.selected_type isEqualToString:@"工人"]) {
        return 1;
    }
    return [self.data_array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.selected_type isEqualToString:@"材料商"]){
        return 250;
    }
    else if([self.selected_type isEqualToString:@"设计师"] || [self.selected_type isEqualToString:@"工长"] || [self.selected_type isEqualToString:@"监理"]){
        return 170;
    }
    else if([self.selected_type isEqualToString:@"工人"]){
        return 90;
    }
    else if([self.selected_type isEqualToString:@"装修知识"]){
        NSDictionary *dict=[self.data_array objectAtIndex:indexPath.row];
        NSString *desc=[NSString stringWithFormat:@"%@ ",[dict objectForKey:@"knowledgeDescription"]];
        
        CGSize size=[util calHeightForLabel:desc width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:16]];
        if(size.height>45) size.height=45;
        float height=10+20+10+(kMainScreenWidth-40)*1.1/2+10+size.height+20;
        
        return height;
    } else {
        return 90;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.selected_type isEqualToString:@"材料商"]){
        static NSString *cellid=@"mycellid_shop";
        GoodsListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"GoodsListCell" owner:nil options:nil]lastObject];
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        if([self.data_array count]){
            NSDictionary *dict=[self.data_array objectAtIndex:indexPath.row];
            CGSize size_name=[util calHeightForLabel:[dict objectForKey:@"shopName"] width:kMainScreenWidth-140 font:[UIFont systemFontOfSize:17]];
            cell.shop_name.text=[dict objectForKey:@"shopName"];
            cell.image_big.clipsToBounds = YES;            cell.image_big.contentMode=UIViewContentModeRedraw;
            [cell.image_big sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"shopLitimgPath"]] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"] options:SDWebImageTransformAnimatedImage];
            
            if(![[dict objectForKey:@"distance"] isEqual:[NSNull null]] && ![[dict objectForKey:@"distance"] isEqualToString:@"(null)"]){
                if(![[dict objectForKey:@"distance"] isEqualToString:@"-1"]){
                    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:[[dict objectForKey:@"workerLatitude"] doubleValue] longitude:[[dict objectForKey:@"distance"] doubleValue]];
                    double distance  = [self.userLocation distanceFromLocation:otherLocation];
                    cell.lab_distance.text=[NSString stringWithFormat:@"%0.1fkm",[[dict objectForKey:@"distance"] floatValue]];
                }else{
                    cell.lab_distance.text=@"无法定位";
                }
            }
            else
                cell.lab_distance.text=@"";
            
            if([[dict objectForKey:@"shopIdentificationType"] count]){
                for(int i=0;i<[[dict objectForKey:@"shopIdentificationType"] count];i++){
                    NSDictionary *dict2=[[dict objectForKey:@"shopIdentificationType"] objectAtIndex:i];
                    UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(20+size_name.width+i*25, 195, 20, 20)];
                    image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_s_%@.png",[dict2 objectForKey:@"authzId"]]];
                    [cell addSubview:image_rz];
                }
            }
            
            //            if([[dict objectForKey:@"shopLevel"] integerValue]!=3){
            NSInteger srat_full=0;
            NSInteger srat_half=0;
            if([[dict objectForKey:@"shopLevel"] integerValue]<[[dict objectForKey:@"shopLevel"] floatValue]){
                srat_full=[[dict objectForKey:@"shopLevel"] integerValue];
                srat_half=1;
            }
            else if([[dict objectForKey:@"shopLevel"] integerValue]==[[dict objectForKey:@"shopLevel"] floatValue]){
                srat_full=[[dict objectForKey:@"shopLevel"] integerValue];
                srat_half=0;
            }
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(13, 220, 100, 20)];
            view.backgroundColor=[UIColor clearColor];
            for(int i=0;i<5;i++){
                if (i <srat_full) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 5, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
                    [view addSubview:imageView];
                    
                }
                else if (i==srat_full && srat_half!=0) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 5, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
                    [view addSubview:imageView];
                    
                }
                else {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 5, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
                    [view addSubview:imageView];
                    
                }
            }
            [cell addSubview:view];
            cell.image_brower.hidden=YES;
            cell.image_collect.hidden=YES;
            //            }
            //            else{
            ////                cell.lab_brower.text=obj.shopBrowsePoints;
            ////                cell.lab_collect.text=obj.shopCollectPoints;
            //                cell.lab_brower.text=@"0";
            //                cell.lab_collect.text=@"0";
            //            }
        }
        
        
        return cell;
    }
    else if ([self.selected_type isEqualToString:@"装修知识"]){
        NSString *cellider=[NSString stringWithFormat:@"MycellIder_%ld",(long)indexPath.row];
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellider];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellider];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        if([self.data_array count]){
            NSDictionary *dict=[self.data_array objectAtIndex:indexPath.row];
            
            UIView *view=[[UIView alloc]init];
            view.backgroundColor=[UIColor whiteColor];
            view.layer.cornerRadius=5;
            [cell addSubview:view];
            
            UILabel *lab_title=(UILabel *)[cell viewWithTag:KSubjectTitleTAG+indexPath.row];
            if(!lab_title) lab_title=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, kMainScreenWidth-40, 20)];
            lab_title.tag=KSubjectTitleTAG+indexPath.row;
            lab_title.backgroundColor=[UIColor clearColor];
            lab_title.textAlignment=NSTextAlignmentLeft;
            lab_title.textColor=[UIColor blackColor];
            lab_title.font=[UIFont systemFontOfSize:18];
            lab_title.text=[dict objectForKey:@"knowledgeTitle"];
            [cell addSubview:lab_title];
            
            UIImageView *logo=(UIImageView *)[cell viewWithTag:KPicture_TAG+indexPath.row];
            if(!logo) logo=[[UIImageView alloc]initWithFrame:CGRectMake(20, 40, kMainScreenWidth-40, (kMainScreenWidth-40)*1.1/2)];
            logo.tag=KPicture_TAG+indexPath.row;
            logo.contentMode=UIViewContentModeScaleAspectFill;
            logo.layer.cornerRadius=3;
            logo.layer.masksToBounds=YES;
            [cell addSubview:logo];
            [logo sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"knowledgeLogoPath"]] placeholderImage:[UIImage imageNamed:@"bg_morentu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image) {
                    logo.image=[self imageWithImage:image scaledToSize:CGSizeMake(image.size.width*0.8, image.size.height*0.8)];
                    //产生逐渐显示的效果
                    logo.alpha=0.2;
                    [UIView animateWithDuration:0.5 animations:^(){
                        logo.alpha=1.0;
                    }completion:^(BOOL finished){
                        
                    }];
                }
            }];
            
            NSString *desc=[NSString stringWithFormat:@"%@ ",[dict objectForKey:@"knowledgeDescription"]];
            CGSize size=[util calHeightForLabel:desc width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:16]];
            if(size.height>45) size.height=45;
            UILabel *lab_desc=(UILabel *)[cell viewWithTag:KDescription_TAG+indexPath.row];
            if(!lab_desc) lab_desc=[[UILabel alloc]initWithFrame:CGRectMake(24, logo.frame.origin.y+logo.frame.size.height+10, kMainScreenWidth-40, size.height)];
            lab_desc.tag=KDescription_TAG+indexPath.row;
            lab_desc.backgroundColor=[UIColor clearColor];
            lab_desc.textAlignment=NSTextAlignmentLeft;
            lab_desc.textColor=[UIColor grayColor];
            lab_desc.font=[UIFont systemFontOfSize:16];
            lab_desc.numberOfLines=2;
            lab_desc.text=desc;
            [cell addSubview:lab_desc];
            
            view.frame=CGRectMake(10, 0, kMainScreenWidth-20, 10+lab_title.frame.size.height+10+lab_desc.frame.size.height+10+logo.frame.size.height+10);
            
            
            if(is_delete==YES){
                UIButton *btn=(UIButton *)[cell viewWithTag:kButton_Tag_picture_delete+indexPath.row];
                if(!btn) btn=[[UIButton alloc]init];
                btn.alpha=0.2;
                btn.frame=CGRectMake(kMainScreenWidth - 55, 6, 35, 35);
                btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
                [UIView animateWithDuration:0.4 animations:^(void){
                    btn.transform = CGAffineTransformMakeScale(0.45, 0.45);
                    btn.alpha=1.0;
                }completion:^(BOOL finished){
                    btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
                btn.tag=kButton_Tag_picture_delete+indexPath.row;
                [btn setBackgroundImage:[UIImage imageNamed:@"ic_shanchu.png"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(pressbtnToDelete:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
            }
            else{
                UIButton *btn=(UIButton *)[cell viewWithTag:kButton_Tag_picture_delete+indexPath.row];
                if (btn) {
                    btn.alpha=1.0;
                    [UIView animateWithDuration:0.4 animations:^(void){
                        btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
                        btn.alpha=0.2;
                    }completion:^(BOOL finished){
                        [btn removeFromSuperview];
                    }];
                    btn =nil;
                }
            }
            
        }
        
        return cell;
    }
    else if([self.selected_type isEqualToString:@"设计师"]) {
        static NSString *cellid=@"mycellid";
        DesignerListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"DesignerListCell" owner:nil options:nil]lastObject];
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            //        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_libiao"]];
            //        cell.backgroundView.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
            //        cell.backgroundView.layer.borderWidth = 1;
            //        cell.backgroundView.layer.masksToBounds = YES;
            //        cell.backgroundView.layer.cornerRadius = 20;
            //        cell.backgroundView.backgroundColor =[UIColor lightGrayColor];
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = YES;
            
        }
        UIButton *btn=(UIButton *)[cell.contentView viewWithTag:kButton_Tag_picture_delete+indexPath.section];
        if(!btn) btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-35-5*kMainScreenWidth/375, 0, 20, 20)];
        btn.tag=kButton_Tag_picture_delete+indexPath.section;
        [btn setBackgroundImage:[UIImage imageNamed:@"ic_shanchu.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pressbtnToDelete:) forControlEvents:UIControlEventTouchUpInside];
        //        btn.hidden =YES;
        [cell addSubview:btn];
        
        if(is_delete==YES) {
            //            cell.offsetX=60;
            //            [UIView animateWithDuration:0.4 animations:^{
            //                btn.frame=CGRectMake(kMainScreenWidth+12.5, 22.5, 35, 35);
            //            }completion:^(BOOL finished){
            //                btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
            //                [UIView animateWithDuration:0.2 animations:^{
            //                    btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            //                }completion:^(BOOL finished){
            //
            //                }];
            //            }];
        }
        else {
            //            cell.offsetX=0;
            btn.frame=CGRectMake(kMainScreenWidth+12.5, 0, 35, 35);
            [UIView animateWithDuration:0.5 animations:^{
                btn.frame=CGRectMake(kMainScreenWidth+60, 0, 35, 35);
            }completion:^(BOOL finished){
                
            }];
        }

        if(indexPath.section<[self.data_array count]){
            NSDictionary *dict=[self.data_array objectAtIndex:indexPath.section];
            
            UIImageView *photo=(UIImageView *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section];
            if(!photo) photo=[[UIImageView alloc]initWithFrame:CGRectMake(14, 15, 45, 45)];
            photo.tag=KButtonTag_phone*2+indexPath.section;
            photo.layer.cornerRadius=22;
            photo.clipsToBounds=YES;
            [photo setOnlineImage:[dict objectForKey:@"designerIconPath"] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
            [cell addSubview:photo];
            
            if((![[dict objectForKey:@"designerMobileNum"] length]) && (![[dict objectForKey:@"designerMobileNum"] length])) cell.designer_phone.hidden=YES;

            CGSize size_name=[util calHeightForLabel:[dict objectForKey:@"designerName"] width:61 font:[UIFont systemFontOfSize:18]];
            cell.designer_name.text=[dict objectForKey:@"designerName"];
            cell.designer_name.frame =CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_name.frame.origin.y, 61, cell.designer_name.frame.size.height);
            if([dict objectForKey:@"designerExperience"]==nil)
                cell.designer_express.text=[NSString stringWithFormat:@"经验 %@",@"暂无"];
            else
                cell.designer_express.text=[NSString stringWithFormat:@"经验 %@",[dict objectForKey:@"designerExperience"]];
            cell.designer_express.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            //[cell.designer_photo setOnlineImage:obj.designerIconPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
            cell.designer_express.frame =CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+8, cell.designer_express.frame.size.width, cell.designer_express.frame.size.height);
            
            float width_=0;
            if([[dict objectForKey:@"arr_rztype"] count]){
                for(int i=0;i<[[dict objectForKey:@"arr_rztype"] count];i++){
                    NSDictionary *dict1=[[dict objectForKey:@"arr_rztype"] objectAtIndex:i];
                    UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(cell.designer_name.frame.origin.x+size_name.width+i*34+5, 17, 29, 13)];
                    image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_new_%@",[dict1 objectForKey:@"authzId"]]];
                    if ([[dict1 objectForKey:@"authzId"] integerValue] ==1) {
                        image_rz.image =[UIImage imageNamed:@"ic_shiming_n.png"];
                    }else if ([[dict1 objectForKey:@"authzId"] integerValue] ==6){
                        image_rz.image =[UIImage imageNamed:@"ic_gongyirenzhong_n.png"];
                    }else if ([[dict1 objectForKey:@"authzId"] integerValue] ==4){
                        image_rz.image =[UIImage imageNamed:@"ic_zhibao_n.png"];
                    }
                    [cell.contentView addSubview:image_rz];
                    
                    width_+=CGRectGetMaxX(image_rz.frame);
                }
            }
            if ([[dict objectForKey:@"arr_rztype"] count]>0&&[dict objectForKey:@"qualificationRating"]!=nil) {
                UIImageView *appellationimage =[[UIImageView alloc] init];
                appellationimage.frame =CGRectMake(cell.designer_name.frame.origin.x+size_name.width+([[dict objectForKey:@"arr_rztype"] count])*34+5, 17, 29, 13);
                if ([[dict objectForKey:@"qualificationRating"] integerValue]==1) {
                    appellationimage.image =[UIImage imageNamed:@"ic_xinrui_n.png"];
                }else if ([[dict objectForKey:@"qualificationRating"] integerValue]==2){
                    appellationimage.image =[UIImage imageNamed:@"ic_youxiu_n.png"];
                }else if ([[dict objectForKey:@"qualificationRating"] integerValue]==3){
                    appellationimage.image =[UIImage imageNamed:@"ic_jingying_n.png"];
                }
                [cell.contentView addSubview:appellationimage];
            }
            
            UIImageView *image_zl=[[UIImageView alloc]initWithFrame:CGRectMake(width_+5, 17, 29, 13)];
            image_zl.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_zlpj_sjs_%@",[dict objectForKey:@"qualificationRating"]]];
            [cell.contentView addSubview:image_zl];
            
            UILabel *offerlbl=(UILabel *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section+2];
            if(!offerlbl) offerlbl =[[UILabel alloc] initWithFrame:CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+cell.designer_express.frame.size.height+4, cell.designer_express.frame.size.width, 14)];
            offerlbl.font =[UIFont systemFontOfSize:14];
            offerlbl.tag =KButtonTag_phone*2+indexPath.section+2;
            offerlbl.textColor =[UIColor lightGrayColor];
            offerlbl.text =[NSString stringWithFormat:@"报价 %@-%@元/㎡",[dict objectForKey:@"priceMin"],[dict objectForKey:@"priceMax"]];
            offerlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            [cell addSubview:offerlbl];
            
            UILabel *credibilitylbl=(UILabel *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section+1];
            if(!credibilitylbl) credibilitylbl=[[UILabel alloc]initWithFrame:CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+cell.designer_express.frame.size.height+26, 30, 14)];
            credibilitylbl.tag=KButtonTag_phone*2+indexPath.section+1;
            credibilitylbl.font =[UIFont systemFontOfSize:14];
            credibilitylbl.text=@"口碑";
            credibilitylbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            [cell addSubview:credibilitylbl];
            
            UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(15, credibilitylbl.frame.size.height+credibilitylbl.frame.origin.y+10, kMainScreenWidth-50
                                                                                 , 1)];
            footline.backgroundColor =[UIColor colorWithHexString:@"#f1f0f6"];
            [cell addSubview:footline];
            
            cell.view_star.frame =CGRectMake(credibilitylbl.frame.size.width+credibilitylbl.frame.origin.x+5, credibilitylbl.frame.origin.y-4, cell.view_star.frame.size.width, cell.view_star.frame.size.height);
            NSInteger srat_full=0;
            NSInteger srat_half=0;
            if([[dict objectForKey:@"designerLevel"] integerValue]<[[dict objectForKey:@"designerLevel"] floatValue]){
                srat_full=[[dict objectForKey:@"designerLevel"] integerValue];
                srat_half=1;
            }
            else if([[dict objectForKey:@"designerLevel"] integerValue]==[[dict objectForKey:@"designerLevel"] floatValue]){
                srat_full=[[dict objectForKey:@"designerLevel"] integerValue];
                srat_half=0;
            }
            for(int i=0;i<5;i++){
                if (i <srat_full) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
                    [cell.view_star addSubview:imageView];
                }
                else if (i==srat_full && srat_half!=0) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
                    [cell.view_star addSubview:imageView];
                    
                }
                else {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
                    [cell.view_star addSubview:imageView];
                    
                }
            }
            cell.image_collect.hidden=YES;
            cell.image_brower.hidden=YES;
            
            UIImageView *img_dhua=(UIImageView *)[cell viewWithTag:KButtonTag_phone*3+indexPath.section];
            if(!img_dhua) img_dhua=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3+((kMainScreenWidth-20)/4-40)/2+13*kMainScreenWidth/414, 17, 40, 20)];
            img_dhua.tag=KButtonTag_phone*3+indexPath.section;
            if([[dict objectForKey:@"state"] integerValue]==1) img_dhua.image=[UIImage imageNamed:@"bt_yuyue_nor.png"];
            else img_dhua.image=[UIImage imageNamed:@"btn_yuyue_no1"];
            [cell addSubview:img_dhua];
            
            if([[dict objectForKey:@"state"] integerValue]==1){
                UIButton *btn_phone=(UIButton *)[cell viewWithTag:kButton_Booking+indexPath.section];
                if(!btn_phone) btn_phone=[[UIButton alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3, 17, (kMainScreenWidth-20)/4, 110)];
                btn_phone.tag=kButton_Booking+indexPath.section;
                [btn_phone addTarget:self action:@selector(pressbtnToyuyue:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn_phone];
            }
            
            UILabel *yuyue_lab=(UILabel *)[cell viewWithTag:KUILabelTag_YuYueCount+indexPath.section];
            if(!yuyue_lab) yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(18, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25, 80, 13)];
//            if (selected_mark ==2) {
//                yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(18, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25,80, 13)];
//            }
            yuyue_lab.tag=KUILabelTag_YuYueCount+indexPath.section;
            yuyue_lab.backgroundColor=[UIColor clearColor];
            yuyue_lab.textAlignment=NSTextAlignmentLeft;
            yuyue_lab.font=[UIFont systemFontOfSize:13];
            yuyue_lab.textColor=[UIColor lightGrayColor];
            int length =0;
            if([[dict objectForKey:@"appointmentNum"] integerValue]>=100000000) {yuyue_lab.text=[NSString stringWithFormat:@"%.1f亿",[[dict objectForKey:@"appointmentNum"] floatValue]/100000000.0];
                length =(int)yuyue_lab.text.length -1;
            }
            else if([[dict objectForKey:@"appointmentNum"] integerValue]>=10000){ yuyue_lab.text=[NSString stringWithFormat:@"%.1f万",[[dict objectForKey:@"appointmentNum"] floatValue]/10000.0];
                length =(int)yuyue_lab.text.length -1;
            }
            else {yuyue_lab.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"appointmentNum"]];
                length =(int)yuyue_lab.text.length;
            }
            yuyue_lab.frame =CGRectMake(((kMainScreenWidth-50)/3-length*13)/2, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25,length*13, 13);
            //        yuyue_lab.backgroundColor =[UIColor redColor];
            yuyue_lab.textAlignment =NSTextAlignmentCenter;
            [cell addSubview:yuyue_lab];
            
            UILabel *yuyue_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(yuyue_lab.frame.origin.x, yuyue_lab.frame.origin.y+yuyue_lab.frame.size.height+9, MAX(length*13, 36), 11)];
            if (length*13<36) {
                yuyue_foot_lab.frame =CGRectMake(yuyue_lab.frame.origin.x+yuyue_lab.frame.size.width/2-33/2, yuyue_foot_lab.frame.origin.y, yuyue_foot_lab.frame.size.width, yuyue_foot_lab.frame.size.height);
            }
            yuyue_foot_lab.textAlignment =NSTextAlignmentCenter;
            yuyue_foot_lab.text =@"预约数";
            yuyue_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
            yuyue_foot_lab.font =[UIFont systemFontOfSize:12];
            //        yuyue_foot_lab.backgroundColor =[UIColor purpleColor];
            [cell addSubview:yuyue_foot_lab];
            
            //        cell.designer_phone.hidden=YES;
            //        cell.designer_phone.frame =CGRectMake(kMainScreenWidth-30, cell.designer_phone.frame.origin.y, cell.designer_phone.frame.size.width, cell.designer_phone.frame.size.height);
            cell.lab_brower.frame =CGRectMake(yuyue_lab.frame.origin.x+yuyue_lab.frame.size.width-length/2*13+100+(5-length)*13, yuyue_lab.frame.origin.y, 0, 13);
            cell.lab_brower.backgroundColor=[UIColor clearColor];
            cell.lab_brower.textAlignment=NSTextAlignmentCenter;
            cell.lab_brower.font=[UIFont systemFontOfSize:13];
            cell.lab_brower.textColor=[UIColor lightGrayColor];
            length =0;
            if([[dict objectForKey:@"browsePoints"] integerValue]>=100000000){
                cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f亿",[[dict objectForKey:@"browsePoints"] floatValue]/100000000];
                length =(int)cell.lab_brower.text.length-1;
            }
            else if([[dict objectForKey:@"browsePoints"] integerValue]>=10000){ cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f万",[[dict objectForKey:@"browsePoints"] floatValue]/10000];
                length =(int)cell.lab_brower.text.length-1;
            }
            else{
                cell.lab_brower.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"browsePoints"]];
                length =(int)cell.lab_brower.text.length;
            }
            
            cell.lab_brower.frame =CGRectMake((kMainScreenWidth-20)/3*1+((kMainScreenWidth-50)/3-length*13)/2, yuyue_lab.frame.origin.y, length*13, 13);
            UILabel *brower_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(cell.lab_brower.frame.origin.x, cell.lab_brower.frame.origin.y+cell.lab_brower.frame.size.height+9, MAX(length*13, 36), 11)];
            if (length*13<36) {
                brower_foot_lab.frame =CGRectMake(cell.lab_brower.frame.origin.x+cell.lab_brower.frame.size.width/2-33/2, brower_foot_lab.frame.origin.y, brower_foot_lab.frame.size.width, brower_foot_lab.frame.size.height);
            }
            brower_foot_lab.textAlignment =NSTextAlignmentCenter;
            brower_foot_lab.text =@"浏览数";
            brower_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
            brower_foot_lab.font =[UIFont systemFontOfSize:12];
            //        brower_foot_lab.backgroundColor =[UIColor purpleColor];
            [cell addSubview:brower_foot_lab];
            cell.lab_collect.frame =CGRectMake((cell.lab_brower.frame.origin.x+cell.lab_brower.frame.size.width-length/2*13+80+(5-length)*13)*kMainScreenWidth/375, cell.lab_brower.frame.origin.y, 0, 13);
            cell.lab_collect.backgroundColor=[UIColor clearColor];
            cell.lab_collect.textAlignment=NSTextAlignmentCenter;
            cell.lab_collect.font=[UIFont systemFontOfSize:13];
            cell.lab_collect.textColor=[UIColor lightGrayColor];
            length =0;
            
            if([[dict objectForKey:@"collectPoints"] integerValue]>=100000000) {cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f亿",[[dict objectForKey:@"collectPoints"] floatValue]/100000000];
                length =(int)cell.lab_collect.text.length-1;
            }
            else if([[dict objectForKey:@"collectPoints"] integerValue]>=10000) {cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f万",[[dict objectForKey:@"collectPoints"] floatValue]/10000];
                length =(int)cell.lab_collect.text.length-1;
            }
            else{ cell.lab_collect.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"collectPoints"]];
                length =(int)cell.lab_collect.text.length;
            };
            cell.lab_collect.frame =CGRectMake((kMainScreenWidth-20)/3*2+((kMainScreenWidth-50)/3-length*13)/2, cell.lab_brower.frame.origin.y, length*13, 13);
            
            UILabel *collect_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(cell.lab_collect.frame.origin.x, cell.lab_collect.frame.origin.y+cell.lab_collect.frame.size.height+9, MAX(length*13, 36), 11)];
            if (length*13<36) {
                collect_foot_lab.frame =CGRectMake(cell.lab_collect.frame.origin.x+cell.lab_collect.frame.size.width/2-33/2, collect_foot_lab.frame.origin.y, collect_foot_lab.frame.size.width, collect_foot_lab.frame.size.height);
            }
            
            collect_foot_lab.textAlignment =NSTextAlignmentCenter;
            collect_foot_lab.text =@"收藏数";
            collect_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
            collect_foot_lab.font =[UIFont systemFontOfSize:12];
            //        collect_foot_lab.backgroundColor =[UIColor purpleColor];
            [cell addSubview:collect_foot_lab];
            
            //        if([obj.state integerValue]==1){
            //            cell.designer_phone.tag=kButton_phone+indexPath.row;
            //            [cell.designer_phone addTarget:self action:@selector(pressbtnTodesigner:) forControlEvents:UIControlEventTouchUpInside];
            //        }
            //        else{
            //            cell.designer_phone.hidden=YES;
            //        }
        }
        
        return cell;

    }
    else if ([self.selected_type isEqualToString:@"工人"]){
        static NSString *cellid=@"mycellid";
        EmptyClearTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"EmptyClearTableViewCell" owner:nil options:nil]lastObject];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        if([self.data_array count]){
            NSDictionary *dict=[self.data_array objectAtIndex:indexPath.section];
            
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 90)];
            view.backgroundColor=[UIColor whiteColor];
            view.layer.cornerRadius=5;
            [cell addSubview:view];
            
            UIButton *btn=(UIButton *)[cell.contentView viewWithTag:kButton_Tag_picture_delete+indexPath.section];
            if(!btn) btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth+60, 22.5, 35, 35)];
            btn.tag=kButton_Tag_picture_delete+indexPath.section;
            [btn setBackgroundImage:[UIImage imageNamed:@"ic_shanchu.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(pressbtnToDelete:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            
            if(is_delete==YES) {
                cell.offsetX=60;
                [UIView animateWithDuration:0.4 animations:^{
                    btn.frame=CGRectMake(kMainScreenWidth+12.5, 22.5, 35, 35);
                }completion:^(BOOL finished){
                    btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
                    [UIView animateWithDuration:0.2 animations:^{
                        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }completion:^(BOOL finished){
                        
                    }];
                }];
            }
            else {
                cell.offsetX=0;
                btn.frame=CGRectMake(kMainScreenWidth+12.5, 22.5, 35, 35);
                [UIView animateWithDuration:0.5 animations:^{
                    btn.frame=CGRectMake(kMainScreenWidth+60, 22.5, 35, 35);
                }completion:^(BOOL finished){
                    
                }];
            }
            
            UIImageView *UserLogo=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 50, 50)];
            UserLogo.contentMode=UIViewContentModeScaleAspectFill;
            UserLogo.layer.cornerRadius=25;
            UserLogo.layer.masksToBounds=YES;
            [UserLogo sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"workerIconPath"]] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
            [cell addSubview:UserLogo];
            
            CGSize size_name=[util calHeightForLabel:[NSString stringWithFormat:@"%@ ",[dict objectForKey:@"nickName"]] width:kMainScreenWidth-140 font:[UIFont systemFontOfSize:20]];
            UILabel *UserName=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, 10, size_name.width, 20)];
            UserName.backgroundColor=[UIColor clearColor];
            UserName.textAlignment=NSTextAlignmentLeft;
            UserName.textColor=[UIColor blackColor];
            UserName.font=[UIFont systemFontOfSize:20];
            UserName.text=[dict objectForKey:@"nickName"];
            [cell addSubview:UserName];
            
            if([[dict objectForKey:@"authentication"] count]){
                for(int i=0;i<[[dict objectForKey:@"authentication"] count];i++){
                    NSDictionary *dict_=[[dict objectForKey:@"authentication"] objectAtIndex:i];
                    UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserName.frame)+i*34, 14, 29, 13)];
                    image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_new_%@.png",[dict_ objectForKey:@"authzId"]]];
                    [cell addSubview:image_rz];
                }
            }
            
            UILabel *Distance=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, CGRectGetMaxY(UserName.frame)+8, kMainScreenWidth-CGRectGetMaxX(UserLogo.frame)-80, 20)];
            Distance.backgroundColor=[UIColor clearColor];
            Distance.textAlignment=NSTextAlignmentLeft;
            Distance.textColor=[UIColor lightGrayColor];
            Distance.font=[UIFont systemFontOfSize:16];
            CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:[[dict objectForKey:@"workerLatitude"] doubleValue] longitude:[[dict objectForKey:@"workerLongitude"] doubleValue]];
            double distance  = [self.userLocation distanceFromLocation:otherLocation];
            Distance.text=[NSString stringWithFormat:@"距离  %.1fkm",distance/1000];
            [cell addSubview:Distance];
            
            UILabel *MouthWord=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(UserLogo.frame)+10, CGRectGetMaxY(Distance.frame)+5, 40, 20)];
            MouthWord.backgroundColor=[UIColor clearColor];
            MouthWord.textAlignment=NSTextAlignmentLeft;
            MouthWord.textColor=[UIColor lightGrayColor];
            MouthWord.font=[UIFont systemFontOfSize:16];
            MouthWord.text=@"口碑   ";
            [cell addSubview:MouthWord];
            
            NSInteger srat_full=0;
            NSInteger srat_half=0;
            if([[dict objectForKey:@"workerLevel"] integerValue]<[[dict objectForKey:@"workerLevel"] floatValue]){
                srat_full=[[dict objectForKey:@"workerLevel"] integerValue];
                srat_half=1;
            }
            else if([[dict objectForKey:@"workerLevel"] integerValue]==[[dict objectForKey:@"workerLevel"] floatValue]){
                srat_full=[[dict objectForKey:@"workerLevel"] integerValue];
                srat_half=0;
            }
            
            for(int i=0;i<5;i++){
                if (i <srat_full) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(MouthWord.frame) + i * 18, CGRectGetMinY(MouthWord.frame)+1, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
                    [cell addSubview:imageView];
                }
                else if (i==srat_full && srat_half!=0) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(MouthWord.frame) + i * 18, CGRectGetMinY(MouthWord.frame)+1, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
                    [cell addSubview:imageView];
                }
                else {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(MouthWord.frame) + i * 18, CGRectGetMinY(MouthWord.frame)+1, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
                    [cell addSubview:imageView];
                }
            }
            
            UIButton *btn_phone=(UIButton *)[cell viewWithTag:KButtonTag_phone+indexPath.section];
            if(!btn_phone) btn_phone=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-60, 10, 50, 40)];
            btn_phone.tag=KButtonTag_phone+indexPath.section;
            [btn_phone setImage:[UIImage imageNamed:@"ic_dianhua"] forState:UIControlStateNormal];
            [btn_phone addTarget:self action:@selector(makeACallToWorker:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn_phone];
            
            UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 89.5, kMainScreenWidth-20, 0.5)];
            line.backgroundColor=[UIColor colorWithHexString:@"#F1F1F4" alpha:1.0];
            [cell addSubview:line];
            
        }
        
        return cell;
    }
    else if([self.selected_type isEqualToString:@"工长"]) {
        static NSString *cellid=@"mycellid";
        DesignerListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"DesignerListCell" owner:nil options:nil]lastObject];
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            //        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_libiao"]];
            //        cell.backgroundView.layer.borderColor = kColorWithRGB(218, 219, 224).CGColor;
            //        cell.backgroundView.layer.borderWidth = 1;
            //        cell.backgroundView.layer.masksToBounds = YES;
            //        cell.backgroundView.layer.cornerRadius = 20;
            //        cell.backgroundView.backgroundColor =[UIColor lightGrayColor];
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = YES;
            
        }
        
        UIButton *btn=(UIButton *)[cell.contentView viewWithTag:kButton_Tag_picture_delete+indexPath.section];
        if(!btn) btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-35-5*kMainScreenWidth/375, 0, 20, 20)];
        btn.tag=kButton_Tag_picture_delete+indexPath.section;
        [btn setBackgroundImage:[UIImage imageNamed:@"ic_shanchu.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pressbtnToDelete:) forControlEvents:UIControlEventTouchUpInside];
//        btn.hidden =YES;
        [cell addSubview:btn];
        
        if(is_delete==YES) {
//            cell.offsetX=60;
//            [UIView animateWithDuration:0.4 animations:^{
//                btn.frame=CGRectMake(kMainScreenWidth+12.5, 22.5, 35, 35);
//            }completion:^(BOOL finished){
//                btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
//                [UIView animateWithDuration:0.2 animations:^{
//                    btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                }completion:^(BOOL finished){
//                    
//                }];
//            }];
        }
        else {
//            cell.offsetX=0;
            btn.frame=CGRectMake(kMainScreenWidth+12.5, 0, 35, 35);
            [UIView animateWithDuration:0.5 animations:^{
                btn.frame=CGRectMake(kMainScreenWidth+60, 0, 35, 35);
            }completion:^(BOOL finished){
                
            }];
        }

        if([self.data_array count]){
            NSDictionary *dic=[self.data_array objectAtIndex:indexPath.section];
            
            UIImageView *photo=(UIImageView *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section];
            if(!photo) photo=[[UIImageView alloc]initWithFrame:CGRectMake(14, 15, 45, 45)];
            photo.tag=KButtonTag_phone*2+indexPath.section;
            photo.layer.cornerRadius=22;
            photo.clipsToBounds=YES;
            [photo setOnlineImage:[dic objectForKey:@"foremanIconPath"] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
            [cell addSubview:photo];
            
            if((![[dic objectForKey:@"foremanMobile"] length])) cell.designer_phone.hidden=YES;
            CGSize size_name=[util calHeightForLabel:[dic objectForKey:@"nickName"] width:81 font:[UIFont systemFontOfSize:17]];
            cell.designer_name.text=[dic objectForKey:@"nickName"];
            cell.designer_name.frame =CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_name.frame.origin.y, 81, cell.designer_name.frame.size.height);
            if([dic objectForKey:@"teamMemberNum"]==nil)
                cell.designer_express.text=[NSString stringWithFormat:@"成员：0人"];
            else
                cell.designer_express.text=[NSString stringWithFormat:@"成员：%@人",[dic objectForKey:@"teamMemberNum"]];
            cell.designer_express.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            cell.designer_express.frame =CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+8, cell.designer_express.frame.size.width, cell.designer_express.frame.size.height);
            //[cell.designer_photo setOnlineImage:obj.designerIconPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
            UILabel *expresslbl=(UILabel *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section+2];
            if(!expresslbl)expresslbl=[[UILabel alloc] initWithFrame:CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+cell.designer_express.frame.size.height-1, cell.designer_express.frame.size.width+4, cell.designer_express.frame.size.height)];
            
            if([dic objectForKey:@"foremanExperience"]==nil)
                expresslbl.text=[NSString stringWithFormat:@"经验：%@",@"暂无"];
            else
                expresslbl.text=[NSString stringWithFormat:@"经验：%@",[dic objectForKey:@"foremanExperience"]];
            expresslbl.font =[UIFont systemFontOfSize:14.0];
            expresslbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            expresslbl.textColor =[UIColor lightGrayColor];
            [cell addSubview:expresslbl];
            //[cell.designer_photo setOnlineImage:obj.designerIconPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
            
            if([[dic objectForKey:@"foremanAuthzs"] count]){
                for(int i=0;i<[[dic objectForKey:@"foremanAuthzs"] count];i++){
                    NSDictionary *dict=[[dic objectForKey:@"foremanAuthzs"] objectAtIndex:i];
                    UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(cell.designer_name.frame.origin.x+size_name.width+i*34+5, 17, 29, 13)];
                    if ([[dict objectForKey:@"authzId"] integerValue] ==1) {
                        image_rz.image =[UIImage imageNamed:@"ic_shiming_n.png"];
                    }else if ([[dict objectForKey:@"authzId"] integerValue] ==6){
                        image_rz.image =[UIImage imageNamed:@"ic_gongyirenzhong_n.png"];
                    }else if ([[dict objectForKey:@"authzId"] integerValue] ==4){
                        image_rz.image =[UIImage imageNamed:@"ic_zhibao_n.png"];
                    }
                    [cell.contentView addSubview:image_rz];
                    
                }
            }
//            
//            if([[dic objectForKey:@"foremanAuthzs"]  count]){
//                for(int i=0;i<[[dic objectForKey:@"foremanAuthzs"]  count];i++){
//                    NSDictionary *dict=[[dic objectForKey:@"foremanAuthzs"]  objectAtIndex:i];
//                    UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(cell.designer_name.frame.origin.x+size_name.width+i*34+5, 16, 29, 13)];
//                    image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_new_%@.png",[dict objectForKey:@"authzId"]]];
//                    [cell.contentView addSubview:image_rz];
//                }
//            }
            UILabel *credibilitylbl=(UILabel *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section+1];
            if(!credibilitylbl) credibilitylbl=[[UILabel alloc]initWithFrame:CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+cell.designer_express.frame.size.height+26, 30, 12)];
            credibilitylbl.tag=KButtonTag_phone*2+indexPath.section+1;
            credibilitylbl.font =[UIFont systemFontOfSize:14];
            credibilitylbl.text=@"口碑";
            credibilitylbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            [cell addSubview:credibilitylbl];
            
            UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(15, credibilitylbl.frame.size.height+credibilitylbl.frame.origin.y+10, kMainScreenWidth-50, 1)];
            footline.backgroundColor =[UIColor colorWithHexString:@"#f1f0f6"];
            [cell addSubview:footline];
            
            cell.view_star.frame =CGRectMake(credibilitylbl.frame.size.width+credibilitylbl.frame.origin.x+5, credibilitylbl.frame.origin.y-4, cell.view_star.frame.size.width, cell.view_star.frame.size.height);
            //        if(selected_mark!=2){
            NSInteger srat_full=0;
            NSInteger srat_half=0;
            
            if([[dic objectForKey:@"popularityLevel"] integerValue]<[[dic objectForKey:@"popularityLevel"] floatValue]){
                srat_full=[[dic objectForKey:@"popularityLevel"] integerValue];
                srat_half=1;
            }
            else if([[dic objectForKey:@"popularityLevel"] integerValue]==[[dic objectForKey:@"popularityLevel"] floatValue]){
                srat_full=[[dic objectForKey:@"popularityLevel"] integerValue];
                srat_half=0;
            }
            for(int i=0;i<5;i++){
                if (i <srat_full) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
                    [cell.view_star addSubview:imageView];
                }
                else if (i==srat_full && srat_half!=0) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
                    [cell.view_star addSubview:imageView];
                    
                }
                else {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
                    [cell.view_star addSubview:imageView];
                    
                }
            }
            cell.image_collect.hidden=YES;
            cell.image_brower.hidden=YES;
            //        }
            //        else{
            //            cell.view_star.hidden=YES;
            //        }
            
            UIImageView *img_dhua=(UIImageView *)[cell viewWithTag:KButtonTag_phone*3+indexPath.section];
            if(!img_dhua) img_dhua=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3+((kMainScreenWidth-20)/4-40)/2+13*kMainScreenWidth/414, 17, 40, 20)];
            img_dhua.tag=KButtonTag_phone*3+indexPath.section;
            if([[dic objectForKey:@"state"] integerValue]==1) img_dhua.image=[UIImage imageNamed:@"bt_yuyue_nor.png"];
            else img_dhua.image=[UIImage imageNamed:@"btn_yuyue_no1"];
            [cell addSubview:img_dhua];
            
            if([[dic objectForKey:@"state"] integerValue]==1){
                UIButton *btn_phone=(UIButton *)[cell viewWithTag:kButton_Booking+indexPath.section];
                if(!btn_phone) btn_phone=[[UIButton alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3, 17, (kMainScreenWidth-20)/4, 110)];
                btn_phone.tag=kButton_Booking+indexPath.section;
                [btn_phone addTarget:self action:@selector(pressbtnToyuyue:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn_phone];
            }
            
            UILabel *yuyue_lab=(UILabel *)[cell viewWithTag:KUILabelTag_YuYueCount+indexPath.section];
            if(!yuyue_lab) yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(18, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25, 80, 13)];
            yuyue_lab.tag=KUILabelTag_YuYueCount+indexPath.section;
            yuyue_lab.backgroundColor=[UIColor clearColor];
            yuyue_lab.textAlignment=NSTextAlignmentLeft;
            yuyue_lab.font=[UIFont systemFontOfSize:13];
            yuyue_lab.textColor=[UIColor lightGrayColor];
            int length =0;
            
            if([[dic objectForKey:@"appointmentNum"] integerValue]>=100000000) {yuyue_lab.text=[NSString stringWithFormat:@"%.1f亿",[[dic objectForKey:@"appointmentNum"] floatValue]/100000000.0];
                length =(int)yuyue_lab.text.length -1;
            }
            else if([[dic objectForKey:@"appointmentNum"] integerValue]>=10000){ yuyue_lab.text=[NSString stringWithFormat:@"%.1f万",[[dic objectForKey:@"appointmentNum"] floatValue]/10000.0];
                length =(int)yuyue_lab.text.length -1;
            }
            else {yuyue_lab.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"appointmentNum"]];
                length =(int)yuyue_lab.text.length;
            }
            yuyue_lab.frame =CGRectMake(((kMainScreenWidth-50)/3-length*13)/2, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25,length*13, 13);
            //        yuyue_lab.backgroundColor =[UIColor redColor];
            yuyue_lab.textAlignment =NSTextAlignmentCenter;
            [cell addSubview:yuyue_lab];
            
            UILabel *yuyue_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(yuyue_lab.frame.origin.x, yuyue_lab.frame.origin.y+yuyue_lab.frame.size.height+9, MAX(length*13, 36), 11)];
            if (length*13<36) {
                yuyue_foot_lab.frame =CGRectMake(yuyue_lab.frame.origin.x+yuyue_lab.frame.size.width/2-36/2, yuyue_foot_lab.frame.origin.y, yuyue_foot_lab.frame.size.width, yuyue_foot_lab.frame.size.height);
            }
            yuyue_foot_lab.textAlignment =NSTextAlignmentCenter;
            yuyue_foot_lab.text =@"预约数";
            yuyue_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
            yuyue_foot_lab.font =[UIFont systemFontOfSize:12];
            //        yuyue_foot_lab.backgroundColor =[UIColor purpleColor];
            [cell addSubview:yuyue_foot_lab];
            
            
            
            cell.designer_phone.hidden=YES;
            cell.lab_brower.frame =CGRectMake(yuyue_lab.frame.origin.x+yuyue_lab.frame.size.width-length/2*13+100+(5-length)*13, yuyue_lab.frame.origin.y, 0, 13);
            cell.lab_brower.backgroundColor=[UIColor clearColor];
            cell.lab_brower.textAlignment=NSTextAlignmentCenter;
            cell.lab_brower.font=[UIFont systemFontOfSize:13];
            cell.lab_brower.textColor=[UIColor lightGrayColor];
            length =0;
            
            if([[dic objectForKey:@"browsePoints"] integerValue]>=100000000){
                cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f亿",[[dic objectForKey:@"browsePoints"] floatValue]/100000000];
                length =(int)cell.lab_brower.text.length-1;
            }
            else if([[dic objectForKey:@"browsePoints"] integerValue]>=10000){ cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f万",[[dic objectForKey:@"browsePoints"] floatValue]/10000];
                length =(int)cell.lab_brower.text.length-1;
            }
            else{ cell.lab_brower.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"browsePoints"]];
                length =(int)cell.lab_brower.text.length;;
            }
            
            cell.lab_brower.frame =CGRectMake((kMainScreenWidth-20)/3*1+((kMainScreenWidth-50)/3-length*13)/2, yuyue_lab.frame.origin.y, length*13, 13);
            UILabel *brower_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(cell.lab_brower.frame.origin.x, cell.lab_brower.frame.origin.y+cell.lab_brower.frame.size.height+9, MAX(length*13, 36), 11)];
            if (length*13<36) {
                brower_foot_lab.frame =CGRectMake(cell.lab_brower.frame.origin.x+cell.lab_brower.frame.size.width/2-36/2, brower_foot_lab.frame.origin.y, brower_foot_lab.frame.size.width, brower_foot_lab.frame.size.height);
            }
            brower_foot_lab.textAlignment =NSTextAlignmentCenter;
            brower_foot_lab.text =@"浏览数";
            brower_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
            brower_foot_lab.font =[UIFont systemFontOfSize:12];
            //        brower_foot_lab.backgroundColor =[UIColor purpleColor];
            [cell addSubview:brower_foot_lab];
            cell.lab_collect.frame =CGRectMake((cell.lab_brower.frame.origin.x+cell.lab_brower.frame.size.width-length/2*13+80+(5-length)*13)*kMainScreenWidth/375, cell.lab_brower.frame.origin.y, 0, 13);
            cell.lab_collect.backgroundColor=[UIColor clearColor];
            cell.lab_collect.textAlignment=NSTextAlignmentCenter;
            cell.lab_collect.font=[UIFont systemFontOfSize:13];
            cell.lab_collect.textColor=[UIColor lightGrayColor];
            length =0;
            
            if([[dic objectForKey:@"collectPoints"] integerValue]>=100000000) {cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f亿",[[dic objectForKey:@"collectPoints"] floatValue]/100000000];
                length =(int)cell.lab_collect.text.length-1;
            }
            else if([[dic objectForKey:@"collectPoints"] integerValue]>=10000) {cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f万",[[dic objectForKey:@"collectPoints"] floatValue]/10000];
                length =(int)cell.lab_collect.text.length-1;
            }
            else{ cell.lab_collect.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"collectPoints"]];
                length =(int)cell.lab_collect.text.length;
            };
            cell.lab_collect.frame =CGRectMake((kMainScreenWidth-20)/3*2+((kMainScreenWidth-50)/3-length*13)/2, cell.lab_brower.frame.origin.y, length*13, 13);
            
            UILabel *collect_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(cell.lab_collect.frame.origin.x, cell.lab_collect.frame.origin.y+cell.lab_collect.frame.size.height+9, MAX(length*13, 36), 11)];
            if (length*13<36) {
                collect_foot_lab.frame =CGRectMake(cell.lab_collect.frame.origin.x+cell.lab_collect.frame.size.width/2-36/2, collect_foot_lab.frame.origin.y, collect_foot_lab.frame.size.width, collect_foot_lab.frame.size.height);
            }
            collect_foot_lab.textAlignment =NSTextAlignmentCenter;
            collect_foot_lab.text =@"收藏数";
            collect_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
            collect_foot_lab.font =[UIFont systemFontOfSize:12];
            //        collect_foot_lab.backgroundColor =[UIColor purpleColor];
            [cell addSubview:collect_foot_lab];
            
            //        if([obj.state integerValue]==1){
            //            cell.designer_phone.tag=kButton_phone+indexPath.row;
            //            [cell.designer_phone addTarget:self action:@selector(pressbtnTodesigner:) forControlEvents:UIControlEventTouchUpInside];
            //        }
            //        else{
            //            cell.designer_phone.hidden=YES;
            //        }
        }
        
        return cell;
//        static NSString *cellid=@"mycellid_gongzhang";
//        CollectDesignerCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
//        if (cell==nil) {
//            cell=[[[NSBundle mainBundle]loadNibNamed:@"CollectDesignerCell" owner:nil options:nil]lastObject];
//            cell.fromVCStr = @"collectionVC";
//            cell.backgroundColor=[UIColor clearColor];
//            cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        }
//        
//        UIButton *btn=(UIButton *)[cell.contentView viewWithTag:kButton_Tag_picture_delete+indexPath.row];
//        if(!btn) btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth+60, 22.5, 35, 35)];
//        btn.tag=kButton_Tag_picture_delete+indexPath.row;
//        [btn setBackgroundImage:[UIImage imageNamed:@"ic_shanchu.png"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(pressbtnToDelete:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:btn];
//
//        if(is_delete==YES) {
//            cell.offsetX=60;
//            [UIView animateWithDuration:0.4 animations:^{
//                btn.frame=CGRectMake(kMainScreenWidth+12.5, 22.5, 35, 35);
//            }completion:^(BOOL finished){
//                btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
//                [UIView animateWithDuration:0.2 animations:^{
//                    btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                }completion:^(BOOL finished){
//                    
//                }];
//            }];
//        }
//        else {
//            cell.offsetX=0;
//            btn.frame=CGRectMake(kMainScreenWidth+12.5, 22.5, 35, 35);
//            [UIView animateWithDuration:0.5 animations:^{
//                btn.frame=CGRectMake(kMainScreenWidth+60, 22.5, 35, 35);
//            }completion:^(BOOL finished){
//                
//            }];
//        }
//
//        UIView *line=(UIView *)[cell.contentView viewWithTag:KLine_TAG+indexPath.row];
//        if(!line) line=[[UIView alloc]initWithFrame:CGRectMake(0, 89.5, kMainScreenWidth, 0.5)];
//        line.tag=KLine_TAG+indexPath.row;
//        line.backgroundColor=[UIColor colorWithHexString:@"#E0E0E0" alpha:0.7];
//        [cell.contentView addSubview:line];
//        
//        NSDictionary *dict=[self.data_array objectAtIndex:indexPath.row];
//        CGSize size_name=[util calHeightForLabel:[dict objectForKey:@"nickName"] width:122 font:[UIFont systemFontOfSize:17]];
//        cell.designer_name.text=[dict objectForKey:@"nickName"];
//        if([dict objectForKey:@"foremanExperience"]==nil)
//            cell.designer_express.text=[NSString stringWithFormat:@"从业经验：%@",@"暂无"];
//        else
//            cell.designer_express.text=[NSString stringWithFormat:@"从业经验：%@",[dict objectForKey:@"foremanExperience"]];
//        [cell.designer_photo setOnlineImage:[dict objectForKey:@"foremanIconPath"] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
//        if([[dict objectForKey:@"foremanAuthzs"] count]){
//            for(int i=0;i<[[dict objectForKey:@"foremanAuthzs"] count];i++){
//                NSDictionary *dict_=[[dict objectForKey:@"foremanAuthzs"] objectAtIndex:i];
//                UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(25+size_name.width+i*20, 15, 15, 15)];
//                image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_s_%@.png",[dict_ objectForKey:@"authzId"]]];
//                [cell.contentView addSubview:image_rz];
//            }
//        }
//        
//        NSInteger srat_full=0;
//        NSInteger srat_half=0;
//        if([[dict objectForKey:@"foremanLevel"]integerValue]<[[dict objectForKey:@"foremanLevel"] floatValue]){
//            srat_full=[[dict objectForKey:@"foremanLevel"] integerValue];
//            srat_half=1;
//        }
//        else if([[dict objectForKey:@"foremanLevel"] integerValue]==[[dict objectForKey:@"foremanLevel"] floatValue]){
//            srat_full=[[dict objectForKey:@"foremanLevel"] integerValue];
//            srat_half=0;
//        }
//        for(int i=0;i<5;i++){
//            if (i <srat_full) {
//                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 5, 15, 15)];
//                [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
//                [cell.view_star addSubview:imageView];
//                
//            }
//            else if (i==srat_full && srat_half!=0) {
//                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 5, 15, 15)];
//                [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
//                [cell.view_star addSubview:imageView];
//                
//            }
//            else {
//                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 5, 15, 15)];
//                [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
//                [cell.view_star addSubview:imageView];
//                
//            }
//        }
//        cell.image_collect.hidden=YES;
//        cell.image_brower.hidden=YES;
//        
//        cell.designer_phone.tag=kButton_Tag_designer_second+indexPath.row;
//        [cell.designer_phone addTarget:self action:@selector(pressbtnToGZYYUE:) forControlEvents:UIControlEventTouchUpInside];
//        
//        cell.designer_phone.hidden = YES;//隐藏收藏里的预约按钮
//        return cell;
    } else if ([self.selected_type isEqualToString:@"监理"]) {
        static NSString *cellid=@"mycellid";
        DesignerListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"DesignerListCell" owner:nil options:nil]lastObject];
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = YES;
            
        }
        UIButton *btn=(UIButton *)[cell.contentView viewWithTag:kButton_Tag_picture_delete+indexPath.section];
        if(!btn) btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-35-5*kMainScreenWidth/375, 0, 20, 20)];
        btn.tag=kButton_Tag_picture_delete+indexPath.section;
        [btn setBackgroundImage:[UIImage imageNamed:@"ic_shanchu.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pressbtnToDelete:) forControlEvents:UIControlEventTouchUpInside];
        //        btn.hidden =YES;
        [cell addSubview:btn];
        
        if(is_delete==YES) {
            //            cell.offsetX=60;
            //            [UIView animateWithDuration:0.4 animations:^{
            //                btn.frame=CGRectMake(kMainScreenWidth+12.5, 22.5, 35, 35);
            //            }completion:^(BOOL finished){
            //                btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
            //                [UIView animateWithDuration:0.2 animations:^{
            //                    btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            //                }completion:^(BOOL finished){
            //
            //                }];
            //            }];
        }
        else {
            //            cell.offsetX=0;
            btn.frame=CGRectMake(kMainScreenWidth+12.5, 0, 35, 35);
            [UIView animateWithDuration:0.5 animations:^{
                btn.frame=CGRectMake(kMainScreenWidth+60, 0, 35, 35);
            }completion:^(BOOL finished){
                
            }];
        }
        if([self.data_array count]){
            NSDictionary *dic=[self.data_array objectAtIndex:indexPath.section];
            
            UIImageView *photo=(UIImageView *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section];
            if(!photo) photo=[[UIImageView alloc]initWithFrame:CGRectMake(14, 15, 45, 45)];
            photo.tag=KButtonTag_phone*2+indexPath.section;
            photo.layer.cornerRadius=22;
            photo.clipsToBounds=YES;
            [photo setOnlineImage:[dic objectForKey:@"supervisorLogoUrl"] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk"]];
            [cell addSubview:photo];
            
            
            
            if((![[dic objectForKey:@"mobileNo"] length])) cell.designer_phone.hidden=YES;
            
            CGSize size_name=[util calHeightForLabel:[dic objectForKey:@"nickName"] width:61 font:[UIFont systemFontOfSize:17]];
            cell.designer_name.text=[dic objectForKey:@"nickName"];
            cell.designer_name.frame =CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_name.frame.origin.y, 61, cell.designer_name.frame.size.height);
            if([dic objectForKey:@"foremanExperience"]==nil)
                cell.designer_express.text=[NSString stringWithFormat:@"经验 %@",@"暂无"];
            else
                cell.designer_express.text=[NSString stringWithFormat:@"经验 %@",[dic objectForKey:@"foremanExperience"]];
            cell.designer_express.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            //[cell.designer_photo setOnlineImage:obj.designerIconPath placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
            cell.designer_express.frame =CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+8, cell.designer_express.frame.size.width, cell.designer_express.frame.size.height);
            //        if([obj.authzs  count]){
            //            for(int i=0;i<[obj.authzs  count];i++){
            //                NSDictionary *dict=[obj.authzs  objectAtIndex:i];
            //                UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(cell.designer_name.frame.origin.x+size_name.width+i*34+5, 16, 29, 13)];
            //                //                image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_s_%@.png",[dict objectForKey:@"authzId"]]];
            //#warning 只有实名欠缺其他
            //                if ([[dict objectForKey:@"authzId"] integerValue]==1) {
            //                    image_rz.image =[UIImage imageNamed:@"ic_shiming_n.png"];
            //                }
            //                [cell.contentView addSubview:image_rz];
            //            }
            //        }
            if([[dic objectForKey:@"foremanAuthzs"] count]){
                for(int i=0;i<[[dic objectForKey:@"foremanAuthzs"] count];i++){
                    NSDictionary *dict=[[dic objectForKey:@"foremanAuthzs"] objectAtIndex:i];
                    UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(cell.designer_name.frame.origin.x+size_name.width+i*34+5, 17, 29, 13)];
                    image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_new_%@",[dict objectForKey:@"authzId"]]];
                    if ([[dict objectForKey:@"authzId"] integerValue] ==1) {
                        image_rz.image =[UIImage imageNamed:@"ic_shiming_n.png"];
                    }else if ([[dict objectForKey:@"authzId"] integerValue] ==6){
                        image_rz.image =[UIImage imageNamed:@"ic_gongyirenzhong_n.png"];
                    }else if ([[dict objectForKey:@"authzId"] integerValue] ==4){
                        image_rz.image =[UIImage imageNamed:@"ic_zhibao_n.png"];
                    }
                    [cell.contentView addSubview:image_rz];
                    
                }
            }
            
            if ([[dic objectForKey:@"foremanAuthzs"] count]>0&&[dic objectForKey:@"qualificationRating"]!=nil) {
                UIImageView *appellationimage =[[UIImageView alloc] init];
                appellationimage.frame =CGRectMake(cell.designer_name.frame.origin.x+size_name.width+([[dic objectForKey:@"foremanAuthzs"] count])*34+5, 17, 29, 13);
                if ([[dic objectForKey:@"qualificationRating"] integerValue]==1) {
                    appellationimage.image =[UIImage imageNamed:@"ic_xinrui_n.png"];
                }else if ([[dic objectForKey:@"qualificationRating"] integerValue]==2){
                    appellationimage.image =[UIImage imageNamed:@"ic_youxiu_n.png"];
                }else if ([[dic objectForKey:@"qualificationRating"] integerValue]==3){
                    appellationimage.image =[UIImage imageNamed:@"ic_jingying_n.png"];
                }
                [cell.contentView addSubview:appellationimage];
            }
            UILabel *offerlbl=(UILabel *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section+2];
            if(!offerlbl) offerlbl =[[UILabel alloc] initWithFrame:CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+cell.designer_express.frame.size.height+4, cell.designer_express.frame.size.width, 14)];
            offerlbl.font =[UIFont systemFontOfSize:14];
            offerlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            offerlbl.tag =KButtonTag_phone*2+indexPath.section+2;
            offerlbl.textColor =[UIColor lightGrayColor];
            
            offerlbl.text =[NSString stringWithFormat:@"报价 %@-%@元/㎡",[dic objectForKey:@"priceMin"],[dic objectForKey:@"priceMax"]];
            [cell addSubview:offerlbl];
            
            UILabel *credibilitylbl=(UILabel *)[cell viewWithTag:KButtonTag_phone*2+indexPath.section+1];
            if(!credibilitylbl) credibilitylbl=[[UILabel alloc]initWithFrame:CGRectMake(photo.frame.origin.x+photo.frame.size.width+11, cell.designer_express.frame.origin.y+cell.designer_express.frame.size.height+26, 30, 14)];
            credibilitylbl.tag=KButtonTag_phone*2+indexPath.section+1;
            credibilitylbl.font =[UIFont systemFontOfSize:14];
            credibilitylbl.text=@"口碑";
            credibilitylbl.textColor =[UIColor lightGrayColor];
            [cell addSubview:credibilitylbl];
            
            UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(15, credibilitylbl.frame.size.height+credibilitylbl.frame.origin.y+10, kMainScreenWidth-50, 1)];
            footline.backgroundColor =[UIColor colorWithHexString:@"#f1f0f6"];
            [cell addSubview:footline];
            
            cell.view_star.frame =CGRectMake(credibilitylbl.frame.size.width+credibilitylbl.frame.origin.x+5, credibilitylbl.frame.origin.y-4, cell.view_star.frame.size.width, cell.view_star.frame.size.height);
            //        if(selected_mark!=2){
            NSInteger srat_full=0;
            NSInteger srat_half=0;
            if([[dic objectForKey:@"foremanLevel"] integerValue]<[[dic objectForKey:@"foremanLevel"] floatValue]){
                srat_full=[[dic objectForKey:@"foremanLevel"] integerValue];
                srat_half=1;
            }
            else if([[dic objectForKey:@"foremanLevel"] integerValue]==[[dic objectForKey:@"foremanLevel"] floatValue]){
                srat_full=[[dic objectForKey:@"foremanLevel"] integerValue];
                srat_half=0;
            }
            for(int i=0;i<5;i++){
                if (i <srat_full) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
                    [cell.view_star addSubview:imageView];
                }
                else if (i==srat_full && srat_half!=0) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
                    [cell.view_star addSubview:imageView];
                    
                }
                else {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (15 + 3), 2, 15, 15)];
                    [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
                    [cell.view_star addSubview:imageView];
                    
                }
            }
            cell.image_collect.hidden=YES;
            cell.image_brower.hidden=YES;
            //        }
            //        else{
            //            cell.view_star.hidden=YES;
            //        }
            
            UIImageView *img_dhua=(UIImageView *)[cell viewWithTag:KButtonTag_phone*3+indexPath.section];
            if(!img_dhua) img_dhua=[[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3+((kMainScreenWidth-20)/4-40)/2+13*kMainScreenWidth/414, 17, 40, 20)];
            img_dhua.tag=KButtonTag_phone*3+indexPath.section;
            if([[dic objectForKey:@"state"] integerValue]==1) img_dhua.image=[UIImage imageNamed:@"bt_yuyue_nor.png"];
            else img_dhua.image=[UIImage imageNamed:@"btn_yuyue_no1"];
            [cell addSubview:img_dhua];
            
            if([[dic objectForKey:@"state"] integerValue]==1){
                UIButton *btn_phone=(UIButton *)[cell viewWithTag:kButton_Booking+indexPath.section];
                if(!btn_phone) btn_phone=[[UIButton alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/4*3, 17, (kMainScreenWidth-20)/4, 110)];
                btn_phone.tag=kButton_Booking+indexPath.section;
                [btn_phone addTarget:self action:@selector(pressbtnToyuyue:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn_phone];
            }
            
            UILabel *yuyue_lab=(UILabel *)[cell viewWithTag:KUILabelTag_YuYueCount+indexPath.section];
            if(!yuyue_lab) yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(18, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25, 80, 13)];
//            if (selected_mark ==2) {
//                yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(18, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25,80, 13)];
//            }
            yuyue_lab.tag=KUILabelTag_YuYueCount+indexPath.section;
            yuyue_lab.backgroundColor=[UIColor clearColor];
            yuyue_lab.textAlignment=NSTextAlignmentLeft;
            yuyue_lab.font=[UIFont systemFontOfSize:13];
            yuyue_lab.textColor=[UIColor lightGrayColor];
            int length =0;
            
            if([[dic objectForKey:@"appointmentNum"] integerValue]>=100000000) {yuyue_lab.text=[NSString stringWithFormat:@"%.1f亿",[[dic objectForKey:@"appointmentNum"] floatValue]/100000000.0];
                length =(int)yuyue_lab.text.length -1;
            }
            else if([[dic objectForKey:@"appointmentNum"] integerValue]>=10000){ yuyue_lab.text=[NSString stringWithFormat:@"%.1f万",[[dic objectForKey:@"appointmentNum"] floatValue]/10000.0];
                length =(int)yuyue_lab.text.length -1;
            }
            else {yuyue_lab.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"appointmentNum"]];
                length =(int)yuyue_lab.text.length;
            }
            yuyue_lab.frame =CGRectMake(((kMainScreenWidth-50)/3-length*13)/2, credibilitylbl.frame.origin.y+credibilitylbl.frame.size.height+25,length*13, 13);
            //        yuyue_lab.backgroundColor =[UIColor redColor];
            yuyue_lab.textAlignment =NSTextAlignmentCenter;
            [cell addSubview:yuyue_lab];
            
            UILabel *yuyue_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(yuyue_lab.frame.origin.x, yuyue_lab.frame.origin.y+yuyue_lab.frame.size.height+9, MAX(length*13, 36), 11)];
            if (length*13<36) {
                yuyue_foot_lab.frame =CGRectMake(yuyue_lab.frame.origin.x+yuyue_lab.frame.size.width/2-33/2, yuyue_foot_lab.frame.origin.y, yuyue_foot_lab.frame.size.width, yuyue_foot_lab.frame.size.height);
            }
            yuyue_foot_lab.textAlignment =NSTextAlignmentCenter;
            yuyue_foot_lab.text =@"预约数";
            yuyue_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
            yuyue_foot_lab.font =[UIFont systemFontOfSize:12];
            //        yuyue_foot_lab.backgroundColor =[UIColor purpleColor];
            [cell addSubview:yuyue_foot_lab];
            
            cell.designer_phone.hidden=YES;
            cell.lab_brower.frame =CGRectMake(yuyue_lab.frame.origin.x+yuyue_lab.frame.size.width-length/2*13+100+(5-length)*13, yuyue_lab.frame.origin.y, 0, 13);
            cell.lab_brower.backgroundColor=[UIColor clearColor];
            cell.lab_brower.textAlignment=NSTextAlignmentCenter;
            cell.lab_brower.font=[UIFont systemFontOfSize:13];
            cell.lab_brower.textColor=[UIColor lightGrayColor];
            length =0;
            
            if([[dic objectForKey:@"browsePoints"] integerValue]>=100000000){
                cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f亿",[[dic objectForKey:@"browsePoints"] floatValue]/100000000];
                length =(int)cell.lab_brower.text.length-1;
            }
            else if([[dic objectForKey:@"browsePoints"] integerValue]>=10000){ cell.lab_brower.text=[NSString stringWithFormat:@"%0.1f万",[[dic objectForKey:@"browsePoints"] floatValue]/10000];
                length =(int)cell.lab_brower.text.length-1;
            }
            else{ cell.lab_brower.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"browsePoints"]];
                length =(int)cell.lab_brower.text.length;;
            }
            
            cell.lab_brower.frame =CGRectMake((kMainScreenWidth-20)/3*1+((kMainScreenWidth-50)/3-length*13)/2, yuyue_lab.frame.origin.y, length*13, 13);
            UILabel *brower_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(cell.lab_brower.frame.origin.x, cell.lab_brower.frame.origin.y+cell.lab_brower.frame.size.height+9, MAX(length*13, 36), 11)];
            if (length*13<36) {
                brower_foot_lab.frame =CGRectMake(cell.lab_brower.frame.origin.x+cell.lab_brower.frame.size.width/2-36/2, brower_foot_lab.frame.origin.y, brower_foot_lab.frame.size.width, brower_foot_lab.frame.size.height);
            }
            brower_foot_lab.textAlignment =NSTextAlignmentCenter;
            brower_foot_lab.text =@"浏览数";
            brower_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
            brower_foot_lab.font =[UIFont systemFontOfSize:12];
            //        brower_foot_lab.backgroundColor =[UIColor purpleColor];
            [cell addSubview:brower_foot_lab];
            cell.lab_collect.frame =CGRectMake((cell.lab_brower.frame.origin.x+cell.lab_brower.frame.size.width-length/2*13+80+(5-length)*13)*kMainScreenWidth/375, cell.lab_brower.frame.origin.y, 0, 13);
            cell.lab_collect.backgroundColor=[UIColor clearColor];
            cell.lab_collect.textAlignment=NSTextAlignmentCenter;
            cell.lab_collect.font=[UIFont systemFontOfSize:13];
            cell.lab_collect.textColor=[UIColor lightGrayColor];
            length =0;
            
            if([[dic objectForKey:@"collectPoints"] integerValue]>=100000000) {cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f亿",[[dic objectForKey:@"collectPoints"] floatValue]/100000000];
                length =(int)cell.lab_collect.text.length-1;
            }
            else if([[dic objectForKey:@"collectPoints"] integerValue]>=10000) {cell.lab_collect.text=[NSString stringWithFormat:@"%0.1f万",[[dic objectForKey:@"collectPoints"] floatValue]/10000];
                length =(int)cell.lab_collect.text.length-1;
            }
            else{ cell.lab_collect.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"collectPoints"]];
                length =(int)cell.lab_collect.text.length;
            };
            cell.lab_collect.frame =CGRectMake((kMainScreenWidth-20)/3*2+((kMainScreenWidth-50)/3-length*13)/2, cell.lab_brower.frame.origin.y, length*13, 13);
            
            UILabel *collect_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(cell.lab_collect.frame.origin.x, cell.lab_collect.frame.origin.y+cell.lab_collect.frame.size.height+9, MAX(length*13, 36), 11)];
            if (length*13<36) {
                collect_foot_lab.frame =CGRectMake(cell.lab_collect.frame.origin.x+cell.lab_collect.frame.size.width/2-36/2, collect_foot_lab.frame.origin.y, collect_foot_lab.frame.size.width, collect_foot_lab.frame.size.height);
            }
            collect_foot_lab.textAlignment =NSTextAlignmentCenter;
            collect_foot_lab.text =@"收藏数";
            collect_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
            collect_foot_lab.font =[UIFont systemFontOfSize:12];
            //        collect_foot_lab.backgroundColor =[UIColor purpleColor];
            [cell addSubview:collect_foot_lab];
            
            //        if([obj.state integerValue]==1){
            //            cell.designer_phone.tag=kButton_phone+indexPath.row;
            //            [cell.designer_phone addTarget:self action:@selector(pressbtnTodesigner:) forControlEvents:UIControlEventTouchUpInside];
            //        }
            //        else{
            //            cell.designer_phone.hidden=YES;
            //        }
        }
        
        return cell;
//        static NSString *cellid=@"mycellid_designer";
//        CollectDesignerCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
//        if (cell==nil) {
//            cell=[[[NSBundle mainBundle]loadNibNamed:@"CollectDesignerCell" owner:nil options:nil]lastObject];
//            cell.fromVCStr = @"collectionVC";
//            cell.backgroundColor=[UIColor clearColor];
//            cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        }
//        
//        UIButton *btn=(UIButton *)[cell.contentView viewWithTag:kButton_Tag_picture_delete+indexPath.row];
//        if(!btn) btn=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth+60, 22.5, 35, 35)];
//        btn.tag=kButton_Tag_picture_delete+indexPath.row;
//        [btn setBackgroundImage:[UIImage imageNamed:@"ic_shanchu.png"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(pressbtnToDelete:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:btn];
//        
//        if(is_delete==YES) {
//            cell.offsetX=60;
//            [UIView animateWithDuration:0.4 animations:^{
//                btn.frame=CGRectMake(kMainScreenWidth+12.5, 22.5, 35, 35);
//            }completion:^(BOOL finished){
//                btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
//                [UIView animateWithDuration:0.2 animations:^{
//                    btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                }completion:^(BOOL finished){
//                    
//                }];
//            }];
//        }
//        else {
//            cell.offsetX=0;
//            btn.frame=CGRectMake(kMainScreenWidth+12.5, 22.5, 35, 35);
//            [UIView animateWithDuration:0.5 animations:^{
//                btn.frame=CGRectMake(kMainScreenWidth+60, 22.5, 35, 35);
//            }completion:^(BOOL finished){
//                
//            }];
//        }
//        
//        UIView *line=(UIView *)[cell.contentView viewWithTag:KLine_TAG+indexPath.row];
//        if(!line) line=[[UIView alloc]initWithFrame:CGRectMake(0, 89.5, kMainScreenWidth, 0.5)];
//        line.tag=KLine_TAG+indexPath.row;
//        line.backgroundColor=[UIColor colorWithHexString:@"#E0E0E0" alpha:0.7];
//        [cell.contentView addSubview:line];
//        
//        NSDictionary *dict=[self.data_array objectAtIndex:indexPath.row];
//        NSString *nameStr;
//        
//        if ([[dict objectForKey:@"nickName"]length] > 7) {
//            nameStr = [[dict objectForKey:@"nickName"] stringByReplacingCharactersInRange:NSMakeRange(8, [[dict objectForKey:@"nickName"]length] - 8) withString:@"..."];
//        } else {
//            nameStr = [dict objectForKey:@"nickName"];
//        }
//
//        CGSize size_name=[util calHeightForLabel:nameStr width:170 font:[UIFont systemFontOfSize:17]];
//        cell.designer_name.text=nameStr;
//        if([dict objectForKey:@"foremanExperience"]==nil)
//            cell.designer_express.text=[NSString stringWithFormat:@"从业经验：%@",@"暂无"];
//        else
//            cell.designer_express.text=[NSString stringWithFormat:@"从业经验：%@",[dict objectForKey:@"foremanExperience"]];
//        [cell.designer_photo setOnlineImage:[dict objectForKey:@"supervisorLogoUrl"] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
//        if([[dict objectForKey:@"foremanAuthzs"] count]){
//            for(int i=0;i<[[dict objectForKey:@"foremanAuthzs"] count];i++){
//                NSDictionary *dict_=[[dict objectForKey:@"foremanAuthzs"] objectAtIndex:i];
//                UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(25+size_name.width+i*20, 15, 15, 15)];
//                image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_s_%@.png",[dict_ objectForKey:@"authzId"]]];
//                [cell.contentView addSubview:image_rz];
//            }
//        }
//        NSInteger srat_full=0;
//        NSInteger srat_half=0;
//        if([[dict objectForKey:@"workerLevel"] integerValue]<[[dict objectForKey:@"workerLevel"] floatValue]){
//            srat_full=[[dict objectForKey:@"workerLevel"] integerValue];
//            srat_half=1;
//        }
//        else if([[dict objectForKey:@"workerLevel"] integerValue]==[[dict objectForKey:@"workerLevel"] floatValue]){
//            srat_full=[[dict objectForKey:@"workerLevel"] integerValue];
//            srat_half=0;
//        }
//        
//        for(int i=0;i<5;i++){
//            if (i <srat_full) {
//                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * 18, 5, 15, 15)];
//                [imageView setImage:[UIImage imageNamed:@"ic_xing_0.png"]];
//                [cell.view_star addSubview:imageView];
//                
//            }
//            else if (i==srat_full && srat_half!=0) {
//                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * 18, 5, 15, 15)];
//                [imageView setImage:[UIImage imageNamed:@"ic_xing_1.png"]];
//                [cell.view_star addSubview:imageView];
//                
//            }
//            else {
//                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * 18, 5, 15, 15)];
//                [imageView setImage:[UIImage imageNamed:@"ic_xing_2.png"]];
//                [cell.view_star addSubview:imageView];
//                
//            }
//        }
//        cell.image_brower.hidden=YES;
//        cell.image_collect.hidden=YES;
//        
//        cell.designer_phone.tag=kButton_Tag_designer_second+indexPath.row;
//        [cell.designer_phone addTarget:self action:@selector(pressbtnToforeman:) forControlEvents:UIControlEventTouchUpInside];
//        
//        cell.designer_phone.hidden = YES;//隐藏收藏里的预约按钮
//        return cell;
    }
    
    else{
        static NSString *cellid=@"mycellid";
        ForemanListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"ForemanListCell" owner:nil options:nil]lastObject];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        if([self.data_array count]){
            ForemanObj *obj=[ForemanObj objWithDict:[self.data_array objectAtIndex:indexPath.row]];
            cell.name_lab.text=obj.nickName;
            cell.express_lab.text=obj.foremanExperience;
            [cell.photo_inage setOnlineImage:obj.foremanIconPath placeholderImage:[UIImage imageNamed:@"bg_morentu_tuku_1.png"]];
            if([obj.foremanAuthents_arr count]){
                for(int i=0;i<[obj.foremanAuthents_arr count];i++){
                    NSDictionary *dict=[obj.foremanAuthents_arr objectAtIndex:i];
                    UIImageView *image_rz=[[UIImageView alloc]initWithFrame:CGRectMake(140+i*40, 10, 35, 32)];
                    image_rz.image=[UIImage imageNamed:[NSString stringWithFormat:@"rz_%@.png",[dict objectForKey:@"authzId"]]];
                    [cell.contentView addSubview:image_rz];
                }
            }
            
            NSInteger srat_full=0;
            NSInteger srat_half=0;
            if([obj.foremanLevel integerValue]<[obj.foremanLevel floatValue]){
                srat_full=[obj.foremanLevel integerValue];
                srat_half=1;
            }
            else if([obj.foremanLevel integerValue]==[obj.foremanLevel floatValue]){
                srat_full=[obj.foremanLevel integerValue];
                srat_half=0;
            }
            
            for(int i=0;i<5;i++){
                if (i <srat_full) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 2, 20, 20)];
                    [imageView setImage:[UIImage imageNamed:@"stars_0.png"]];
                    [cell.view_ addSubview:imageView];
                    
                }
                else if (i==srat_full && srat_half!=0) {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 2, 20, 20)];
                    [imageView setImage:[UIImage imageNamed:@"stars_1.png"]];
                    [cell.view_ addSubview:imageView];
                    
                }
                else {
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 + i * (18 + 3), 2, 20, 20)];
                    [imageView setImage:[UIImage imageNamed:@"stars_2.png"]];
                    [cell.view_ addSubview:imageView];
                    
                }
            }
            cell.btn_call.tag=kButton_Tag+indexPath.row;
            [cell.btn_call addTarget:self action:@selector(pressbtnToforeman:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(is_delete==NO){
        if ([self.selected_type isEqualToString:@"装修知识"]) {
            DecorateProcessObj *obj_=[DecorateProcessObj objWithDict:[self.data_array objectAtIndex:indexPath.row]];
            DecorateInfoVC *decvc=[[DecorateInfoVC alloc]init];
            decvc.obj=obj_;
            [self.navigationController pushViewController:decvc animated:YES];
        } else if ([self.selected_type isEqualToString:@"工人"]){
            WorkerListObj *obj_=[WorkerListObj objWithDict:[self.data_array objectAtIndex:indexPath.section]];
            CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:obj_.workerLatitude longitude:obj_.workerLongitude];
            float distance  = [self.userLocation distanceFromLocation:otherLocation];
            obj_.distance =distance;
            XiaoGongNewDetailViewController *decvc = [[XiaoGongNewDetailViewController alloc]init];
            decvc.obj=obj_;
            decvc.fromVCStr = @"111";
            [self.navigationController pushViewController:decvc animated:YES];
        } else if ([self.selected_type isEqualToString:@"设计师"]) {
            DesignerInfoObj *obj_ = [DesignerInfoObj objectWithKeyValues:[self.data_array objectAtIndex:indexPath.section]];
//            DesignerDetailViewController *infovc = [[DesignerDetailViewController alloc]init];
//            infovc.obj=obj_;
            IDIAI3DesignerDetailViewController *designer =[[IDIAI3DesignerDetailViewController alloc] init];
            designer.obj =obj_;
            designer.fromwhere = @"111";
//            infovc.fromDesigStr=@"CollectionInfo";
            [self.navigationController pushViewController:designer animated:YES];
            
        } else if ([self.selected_type isEqualToString:@"工长"]) {
            GongzhangListObj *obj_ = [GongzhangListObj objectWithKeyValues:[self.data_array objectAtIndex:indexPath.section]];
            IDIAI3GongZhangDetaileViewController *infovc = [[IDIAI3GongZhangDetaileViewController alloc]init];
            infovc.obj=obj_;
            infovc.fromwhere = @"111";
//            infovc.fromGongzhangStr=@"CollectionInfo";
            [self.navigationController pushViewController:infovc animated:YES];
        } else if ([self.selected_type isEqualToString:@"监理"]) {
            SupervisorListObj *obj_ = [SupervisorListObj objectWithKeyValues:[self.data_array objectAtIndex:indexPath.section]];
            IDIAI3JianLiDetailViewController *supervisiorInfoVC = [[IDIAI3JianLiDetailViewController alloc]init];
            supervisiorInfoVC.obj = obj_;
           supervisiorInfoVC.fromwhere = @"111";
//            supervisiorInfoVC.fromJianliStr=@"CollectionInfo";
            [self.navigationController pushViewController:supervisiorInfoVC animated:YES];
            
        } else if ([self.selected_type isEqualToString:@"材料商"]) {
            GoodslistObj *obj_=[GoodslistObj objWithDict:[self.data_array objectAtIndex:indexPath.row]];
            BusinessInfoVC *ectvc=[[BusinessInfoVC alloc]init];
            ectvc.obj=obj_;
            [self.navigationController pushViewController:ectvc animated:YES];
        }
    }
}

#pragma mark - 工人拨打电话
- (void)makeACallToWorker:(UIButton *)btn {
    NSDictionary *dict=[self.data_array objectAtIndex:btn.tag-KButtonTag_phone];
    NSString *callNumStr = [dict objectForKey:@"phoneNumber"];
    if (callNumStr) {
        UIWebView *callWebWiew = [[UIWebView alloc]init];
        NSString *wantcallNumStr = [NSString stringWithFormat:@"tel://%@",callNumStr];
        [callWebWiew loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wantcallNumStr]]];
        [self.view addSubview:callWebWiew];
    } else {
        [TLToast showWithText:@"工人暂未留电话,请下次再试"];
    }
}

/***********************
#pragma mark -
#pragma mark -Gesture

-(void)presslonggesture:(UIGestureRecognizer *)gesture{
    is_delete=YES;
    [qtmquitView reloadData];
}
***********************/

#pragma mark -
#pragma mark -TMQuiltView

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.data_array count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *cellid=@"mycellid-1";
     TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:cellid];
    if (!cell) {
        if([self.data_array count]){
            NSDictionary *dic=[self.data_array objectAtIndex:indexPath.row];
        
            if ([self.selected_type isEqualToString:@"装修方案"]) {
            
               cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:cellid index:[[dic objectForKey:@"designerID"] integerValue] type:1];
            } else {
                 cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:cellid index:[[dic objectForKey:@"designerID"] integerValue] type:0];
            }
            
        }
    }
    if([self.data_array count]){
        NSDictionary *dic=[self.data_array objectAtIndex:indexPath.row];
        NSString *placeter_image=[[NSBundle mainBundle]pathForResource:@"bg_taotubeijing@2x" ofType:@"png"];
        NSString *placeter_designer=[[NSBundle mainBundle]pathForResource:@"ic_touxiang_tk@2x" ofType:@"png"];
        
        cell.photoView.image=[UIImage imageWithContentsOfFile:placeter_image];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:[dic objectForKey:@"imagePath"]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if(image) {
                NSData *imagdata=UIImageJPEGRepresentation(image, 0.2);
                UIImage *img=[UIImage imageWithData:imagdata];
                cell.photoView.image=[self imageWithImage:img scaledToSize:CGSizeMake(image.size.width*0.5, image.size.height*0.5)];
            }
        }];

        
//        cell.pictureCount.text=[NSString stringWithFormat:@"%ld",(long)[[dic objectForKey:@"collectionNum"] integerValue]+1];
       
        if([[dic objectForKey:@"designerID"] integerValue]!=0){
            cell.designer_photoView.hidden=NO;
            cell.Label_designer.hidden=NO;
            [cell.designer_photoView setOnlineImage:[dic objectForKey:@"designerImagePath"] placeholderImage:[UIImage imageWithContentsOfFile:placeter_designer]];
            if ([self.selected_type isEqualToString:@"装修方案"])
                cell.Label_designer.text =[dic objectForKey:@"collectionName"];
            else
                cell.Label_designer.text =[dic objectForKey:@"designerName"];
        }
        else{
            
            NSString *icon=[[NSBundle mainBundle]pathForResource:@"icon@2x" ofType:@"png"];
            cell.designer_photoView.image=[UIImage imageWithContentsOfFile:icon];;
            cell.Label_designer.text=@"屋托邦";
        }
        
        //            if (self.typeIdInteger+1 == 1 || self.typeIdInteger+1 == 2) {
        cell.collectIV.image = [UIImage imageNamed:@"ic_xingxing_2"];
        if([[dic objectForKey:@"collectionNum"] integerValue]>=10000) cell.collectNumLabel.text=[NSString stringWithFormat:@"%0.1f万",[[dic objectForKey:@"collectionNum"] floatValue]/10000];
        else cell.collectNumLabel.text=[NSString stringWithFormat:@"%d",[[dic objectForKey:@"collectionNum"] intValue]];
        
        //增加详情页的浏览量显示必须
        cell.browseNumIV.image = [UIImage imageNamed:@"ic_yanjing_2"];
        if([[dic objectForKey:@"browserNum"] integerValue]>=10000) cell.browseNumLabel.text=[NSString stringWithFormat:@"%0.1f万",[[dic objectForKey:@"browserNum"] floatValue]/10000];
        else cell.browseNumLabel.text=[NSString stringWithFormat:@"%d",[[dic objectForKey:@"browserNum"]intValue]];
        
        if ([self.selected_type isEqualToString:@"装修方案"]) {
            cell.houseTAndAAndPOrS.text=[NSString stringWithFormat:@"%@  %@m²  %@元/m²",[dic objectForKey:@"doorModel"],[dic objectForKey:@"buildingArea"],[dic objectForKey:@"price"]];
        }
        else{
            cell.houseDesc.text=[dic objectForKey:@"description"];
            cell.houseTAndAAndPOrS.text=[dic objectForKey:@"frameName"];
        }
        cell.pictureCountIV.image =[UIImage imageNamed:@"ic_taotuyeshu"];
        cell.pictureCount.text=[NSString stringWithFormat:@"%ld",(long)[[dic objectForKey:@"collectionCount"] integerValue]+1];
        if(is_delete==YES){
            UIButton *btn=(UIButton *)[cell viewWithTag:kButton_Tag_picture_delete+indexPath.row];
            if(!btn) btn=[[UIButton alloc]init];
            if ([self.selected_type isEqualToString:@"装修方案"]){
                btn.alpha=0.2;
                btn.frame=CGRectMake(kMainScreenWidth - 45, 10, 35, 35);
                btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
                [UIView animateWithDuration:0.4 animations:^(void){
                btn.transform = CGAffineTransformMakeScale(0.45, 0.45);
                btn.alpha=1.0;
                }completion:^(BOOL finished){
                    btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            }
            else{
                btn.alpha=0.2;
                btn.frame=CGRectMake(kMainScreenWidth - 60, 10, 35, 35);
                btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
                [UIView animateWithDuration:0.4 animations:^(void){
                    btn.transform = CGAffineTransformMakeScale(0.45, 0.45);
                    btn.alpha=1.0;
                }completion:^(BOOL finished){
                    btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            }
            btn.tag=kButton_Tag_picture_delete+indexPath.row;
            [btn setBackgroundImage:[UIImage imageNamed:@"ic_shanchu.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(pressbtnToDelete:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
        else{
            UIButton *btn=(UIButton *)[cell viewWithTag:kButton_Tag_picture_delete+indexPath.row];
            if (btn) {
                btn.alpha=1.0;
                [UIView animateWithDuration:0.4 animations:^(void){
                    btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
                    btn.alpha=0.2;
                }completion:^(BOOL finished){
                    [btn removeFromSuperview];
                }];
                btn =nil;
            }
        }

    }
    
    return cell;
    
}



#pragma mark - TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
    {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.selected_type isEqualToString:@"装修方案"]) return kMainScreenWidth+120;
    else return 2*(kMainScreenWidth-20)/3+90;
}

- (CGFloat)quiltViewMargin:(TMQuiltView *)quilView marginType:(TMQuiltViewMarginType)marginType{
    if([self.selected_type isEqualToString:@"装修方案"]) return 0;
    else return 15;
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    if(is_delete==NO){
        CollectPictureCell *cell = (CollectPictureCell *)[quiltView cellAtIndexPath:indexPath];
        MyeffectPictureObj *obj=[MyeffectPictureObj objWithDict:[self.data_array objectAtIndex:indexPath.row]];
        if([self.selected_type isEqualToString:@"效果图"]){
            EffectPictureInfo *effvc=[[EffectPictureInfo alloc]init];
            effvc.obj_effect=obj;
            effvc.obj_effect.objId =obj.picture_id;
            effvc.browseNumInteger = [obj.browserNum integerValue];
            
            effvc.img_=cell.photoView.image;
            [self.navigationController pushViewController:effvc animated:YES];
        }
        else{
            EffectTAOTUPictureInfo *effVC=[[EffectTAOTUPictureInfo alloc]init];
            effVC.obj_pic=obj;
            effVC.obj_pic.objId =obj.picture_id;
            effVC.selectDone =^(MyeffectPictureObj *obj_pic){
                
            };
            [self.navigationController pushViewController:effVC animated:YES];
        }
    }
}

-(void)pressbtnToDelete:(UIButton *)btn{
    
    
    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path_ = [path_ objectAtIndex:0];
    NSString* _filename_;
    
    if([self.selected_type isEqualToString:@"装修方案"]){
        [self cancleknowlege:[[self.data_array objectAtIndex:btn.tag-kButton_Tag_picture_delete] objectForKey:@"id"]count:btn.tag-kButton_Tag_picture_delete];
//        [self.data_array removeObjectAtIndex:];
        
    }
    else if([self.selected_type isEqualToString:@"效果图"]){
        [self cancleknowlege:[[self.data_array objectAtIndex:btn.tag-kButton_Tag_picture_delete] objectForKey:@"id"]count:btn.tag-kButton_Tag_picture_delete];
//        [self.data_array removeObjectAtIndex:];
//        [qtmquitView reloadData];
    }
    else if([self.selected_type isEqualToString:@"装修知识"]){
        [self cancleknowlege:[[self.data_array objectAtIndex:btn.tag-kButton_Tag_picture_delete] objectForKey:@"knowledgeID"]count:btn.tag-kButton_Tag_picture_delete];
//        [self.data_array removeObjectAtIndex:];
//        [_theTableView reloadData];
    }
    else if([self.selected_type isEqualToString:@"材料商"]){
        _filename_ = [doc_path_ stringByAppendingPathComponent:@"MybusinessCollect.plist"];
        [self.data_array removeObjectAtIndex:btn.tag-kButton_Tag_picture_delete];
//        [_theTableView reloadData];
    }
    else if([self.selected_type isEqualToString:@"设计师"]){
         [self cancleknowlege:[[self.data_array objectAtIndex:btn.tag-kButton_Tag_picture_delete] objectForKey:@"designerID"]count:btn.tag-kButton_Tag_picture_delete];
//        [self.data_array removeObjectAtIndex:];
//        [_theTableView reloadData];
    }
    else if([self.selected_type isEqualToString:@"工人"]){
         [self cancleknowlege:[[self.data_array objectAtIndex:btn.tag-kButton_Tag_picture_delete] objectForKey:@"workerId"]count:btn.tag-kButton_Tag_picture_delete];
//        [self.data_array removeObjectAtIndex:];
//        [_theTableView reloadData];
    }
    else if([self.selected_type isEqualToString:@"工长"]){
        [self cancleknowlege:[[self.data_array objectAtIndex:btn.tag-kButton_Tag_picture_delete] objectForKey:@"foremanId"]count:btn.tag-kButton_Tag_picture_delete];
//        [self.data_array removeObjectAtIndex:];
//        [_theTableView reloadData];
    } else if([self.selected_type isEqualToString:@"监理"]){
        [self cancleknowlege:[[self.data_array objectAtIndex:btn.tag-kButton_Tag_picture_delete] objectForKey:@"supervisorId"]count:btn.tag-kButton_Tag_picture_delete];
//        [self.data_array removeObjectAtIndex:];
//        [_theTableView reloadData];
    }
    
//    [self.data_array writeToFile:_filename_ atomically:NO];
    
    
    
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

#pragma mark - 延长cell分割线至顶端

- (void)viewDidLayoutSubviews
{
    if ([_theTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_theTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_theTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_theTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -
#pragma mark - UIButton

-(void)editCell:(UIButton *)sender{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:User_Token]){
        if ([self.selected_type isEqualToString:@"装修方案"] || [self.selected_type isEqualToString:@"效果图"]) {
            editBtn.enabled=NO;
            [self performSelector:@selector(delay) withObject:nil afterDelay:0.4];
            
            editBtn.selected=!editBtn.selected;
            is_delete=editBtn.selected;
            [qtmquitView reloadData];
        }
        else {
            editBtn.enabled=NO;
            [self performSelector:@selector(delay) withObject:nil afterDelay:0.4];
            
            editBtn.selected=!editBtn.selected;
            is_delete=editBtn.selected;
            [_theTableView reloadData];
        }
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
    
}

-(void)delay{
    editBtn.enabled=YES;
}

#pragma mark -预约

-(void)pressbtnToyuyue:(UIButton *)btn{
    
    self.selectCell=btn.tag-kButton_Booking;
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:User_Token] length]) {
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
        return;
    }
    
    if([self.selected_type isEqualToString:@"设计师"]){
        NSDictionary *dic=[self.data_array objectAtIndex:btn.tag-kButton_Booking];
        [self requestCheckSubcribeStatus:[dic objectForKey:@"designerID"] type:@"1"];
    }
    else if([self.selected_type isEqualToString:@"工长"]){
        NSDictionary *dic=[self.data_array objectAtIndex:btn.tag-kButton_Booking];
        [self requestCheckSubcribeStatus:[dic objectForKey:@"foremanId"] type:@"4"];
    }
    else if([self.selected_type isEqualToString:@"监理"]){
        NSDictionary *dic=[self.data_array objectAtIndex:btn.tag-kButton_Booking];
        [self requestCheckSubcribeStatus:[dic objectForKey:@"supervisorId"] type:@"6"];
    }
}

#pragma mark - LoginDelegate

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    if (self.view.tag == 1001) {
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
        [appDelegate.nav dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSDictionary *dic=[self.data_array objectAtIndex:self.selectCell];
        SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
        ;//supervisorId 监理   designerID 设计师   foremanId 工长
        if([self.selected_type isEqualToString:@"设计师"]){
            subscribeVC.businessIDStr = [dic objectForKey:@"designerID"];
            subscribeVC.servantRoleIdStr = @"1";
        }
        else if([self.selected_type isEqualToString:@"工长"]){
            subscribeVC.businessIDStr = [dic objectForKey:@"foremanId"];
            subscribeVC.servantRoleIdStr = @"4";
        }
        else if([self.selected_type isEqualToString:@"监理"]){
            subscribeVC.businessIDStr = [dic objectForKey:@"supervisorId"];
            subscribeVC.servantRoleIdStr = @"6";
        }
        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
        [appDelegate.nav pushViewController:subscribeVC animated:YES];
//        [self.navigationController pushViewController:subscribeVC animated:YES];
    }
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 检查预约状态
-(void)requestCheckSubcribeStatus:(NSString *)designerIdStr type:(NSString *)type {
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
        NSDictionary *bodyDic = @{@"businessID":designerIdStr,@"servantRoleId":type};
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
                //NSLog(@"检查是否预约返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        self.view.tag = 1001;
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 101311) {
                        [self stopRequest];
                        SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
                        subscribeVC.businessIDStr = designerIdStr;
                        subscribeVC.servantRoleIdStr = @"1";
                        subscribeVC.fromStr=@"111";
//                        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
//                        [appDelegate.nav pushViewController:subscribeVC animated:YES];
                        [self.navigationController pushViewController:subscribeVC animated:YES];
                    }
                    else if (kResCode == 101312) {
                        [self stopRequest];
                        _bookIdStr = [jsonDict objectForKey:@"bookId"];
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"亲，您已预约该设计师" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
                        alertView.delegate = self;
                        [alertView show];
                    }
                    else if (kResCode == 101313) {
                        [self stopRequest];
                        [TLToast showWithText:@"该设计师业务繁忙..."];
                    }
                    else {
                        [self stopRequest];
                        [TLToast showWithText:@"检查预约状态失败"];
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
                        self.view.tag = 1001;
                        [self stopRequest];
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
                         mySubscribeDetailVC.fromStr=@"CollectionInfo";
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
-(void)requstplanList{
    self.currentPage =1;
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
        NSString *url =[NSString string];
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0294\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"收藏装修方案返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (kResCode == 10002 || kResCode == 10003) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    return;
                    });
                }
                if (code==102941) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if(self.refreshing==YES && [self.data_array count]) [self.data_array removeAllObjects];
                        if (self.currentPage==1) {
                            [self.data_array removeAllObjects];
                        }
                        NSArray *arr_=[jsonDict objectForKey:@"rendreingsList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                
                                [self.data_array addObject:dict];
                            }
                            //                            if ([[jsonDict objectForKey:@"newInfoNumber"] integerValue]>0) {
                            //                            }else{
                            //                                [self.unreadbtn removeFromSuperview];
                            //                            }
                        }
                        if([self.data_array count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [qtmquitView reloadData];
                            //                            [_theTableView tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [qtmquitView reloadData];
                            //                            [_theTableView tableViewDidFinishedLoading];
                        }
                        //                        self.isrequst =YES;
                        //                        [_theTableView reloadData];
                        //                        self.isrequst =NO;
                    });
                }
                else if (code==102809) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [qtmquitView reloadData];
                        //                        [_theTableView reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [qtmquitView reloadData];
                        //                        [_theTableView reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [_theTableView tableViewDidFinishedLoading];
                                  if(![self.data_array count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [qtmquitView reloadData];
                                  //                                  [_theTableView reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
}
-(void)requstrenderingList{
    self.currentPage =1;
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
        NSString *url =[NSString string];
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0293\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"收藏效果图返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (kResCode == 10002 || kResCode == 10003) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    return;
                    });
                }
                if (code==102931) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if(self.refreshing==YES && [self.data_array count]) [self.data_array removeAllObjects];
                        if (self.currentPage==1) {
                            [self.data_array removeAllObjects];
                        }
                        NSArray *arr_=[jsonDict objectForKey:@"rendreingsList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                
                                [self.data_array addObject:dict];
                            }
                            //                            if ([[jsonDict objectForKey:@"newInfoNumber"] integerValue]>0) {
                            //                            }else{
                            //                                [self.unreadbtn removeFromSuperview];
                            //                            }
                        }
                        if([self.data_array count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [qtmquitView reloadData];
//                            [_theTableView tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [qtmquitView reloadData];
//                            [_theTableView tableViewDidFinishedLoading];
                        }
                        //                        self.isrequst =YES;
//                        [_theTableView reloadData];
                        //                        self.isrequst =NO;
                    });
                }
                else if (code==102809) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [qtmquitView reloadData];
//                        [_theTableView reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [qtmquitView reloadData];
//                        [_theTableView reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [_theTableView tableViewDidFinishedLoading];
                                  if(![self.data_array count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [qtmquitView reloadData];
//                                  [_theTableView reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
}
-(void)requstknowledgeList{
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
        NSString *url =[NSString string];
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0295\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"收藏装修知识返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (kResCode == 10002 || kResCode == 10003) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    return;
                    });
                }
                if (code==102971) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self stopRequest];
                        if(self.refreshing==YES && [self.data_array count]) [self.data_array removeAllObjects];
                        if (self.currentPage==1) {
                            [self.data_array removeAllObjects];
                        }
                        NSArray *arr_=[jsonDict objectForKey:@"knowledgeList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSMutableDictionary *dict in arr_){
                                long str =[[dict objectForKey:@"knowledgeID"]longValue];
                                NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:dict];
                                [dic setObject:[NSNumber numberWithLong:str] forKey:@"objId"];
                                [self.data_array addObject:dic];
//                                [dict setObject:[dict objectForKey:@"knowledgeID"] forKey:@"objId"];
//                                [self.data_array addObject:dict];
                            }
                            //                            if ([[jsonDict objectForKey:@"newInfoNumber"] integerValue]>0) {
                            //                            }else{
                            //                                [self.unreadbtn removeFromSuperview];
                            //                            }
                        }
                        if([self.data_array count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [_theTableView tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [_theTableView tableViewDidFinishedLoading];
                        }
//                        self.isrequst =YES;
                        [_theTableView reloadData];
                        //                        self.isrequst =NO;
                    });
                }
                else if (code==102809) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [_theTableView reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [_theTableView reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                   [self stopRequest];
                                  [_theTableView tableViewDidFinishedLoading];
                                  if(![self.data_array count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [_theTableView reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
}
-(void)requstDesignerList{
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
        NSString *url =[NSString string];
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0296\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"收藏设计师返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (kResCode == 10002 || kResCode == 10003) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    return;
                    });
                }
                if (code==102961) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self stopRequest];
                        if(self.refreshing==YES && [self.data_array count]) [self.data_array removeAllObjects];
                        NSArray *arr_=[jsonDict objectForKey:@"rendreingsList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                long str =[[dict objectForKey:@"designerID"]longValue];
//                                [dict setObject:str forKey:@"objId"];
                                NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:dict];
                                [dic setObject:[NSNumber numberWithLong:str] forKey:@"objId"];
                                [self.data_array addObject:dic];
                            }
                            //                            if ([[jsonDict objectForKey:@"newInfoNumber"] integerValue]>0) {
                            //                            }else{
                            //                                [self.unreadbtn removeFromSuperview];
                            //                            }
                        }
                        if([self.data_array count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [_theTableView tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [_theTableView tableViewDidFinishedLoading];
                        }
                        //                        self.isrequst =YES;
                        [_theTableView reloadData];
                        //                        self.isrequst =NO;
                    });
                }
                else if (code==102809) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [_theTableView reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [_theTableView reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                   [self stopRequest];
                                  [_theTableView tableViewDidFinishedLoading];
                                  if(![self.data_array count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [_theTableView reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
}
-(void)requstGongZhangList{
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
        NSString *url =[NSString string];
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0297\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"收藏工长返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (kResCode == 10002 || kResCode == 10003) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    return;
                    });
                }
                if (code==102971) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if(self.refreshing==YES && [self.data_array count]) [self.data_array removeAllObjects];
                        NSArray *arr_=[jsonDict objectForKey:@"foremanList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                long str =[[dict objectForKey:@"foremanId"]longValue];
                                //                                [dict setObject:str forKey:@"objId"];
                                NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:dict];
                                [dic setObject:[NSNumber numberWithLong:str] forKey:@"objId"];
                                [self.data_array addObject:dic];
                            }
                            //                            if ([[jsonDict objectForKey:@"newInfoNumber"] integerValue]>0) {
                            //                            }else{
                            //                                [self.unreadbtn removeFromSuperview];
                            //                            }
                        }
                        if([self.data_array count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [_theTableView tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [_theTableView tableViewDidFinishedLoading];
                        }
                        //                        self.isrequst =YES;
                        [_theTableView reloadData];
                        //                        self.isrequst =NO;
                    });
                }
                else if (code==102809) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [_theTableView reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [_theTableView reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [_theTableView tableViewDidFinishedLoading];
                                  if(![self.data_array count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [_theTableView reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
}
-(void)requstJianLiList{
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
        NSString *url =[NSString string];
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0298\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"收藏监理返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (kResCode == 10002 || kResCode == 10003) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    return;
                    });
                }
                if (code==102981) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if(self.refreshing==YES && [self.data_array count]) [self.data_array removeAllObjects];
                        NSArray *arr_=[jsonDict objectForKey:@"supervisorList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                long str =[[dict objectForKey:@"supervisorId"]longValue];
                                //                                [dict setObject:str forKey:@"objId"];
                                NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:dict];
                                [dic setObject:[NSNumber numberWithLong:str] forKey:@"objId"];
                                [self.data_array addObject:dic];
                            }
                            //                            if ([[jsonDict objectForKey:@"newInfoNumber"] integerValue]>0) {
                            //                            }else{
                            //                                [self.unreadbtn removeFromSuperview];
                            //                            }
                        }
                        if([self.data_array count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [_theTableView tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [_theTableView tableViewDidFinishedLoading];
                        }
                        //                        self.isrequst =YES;
                        [_theTableView reloadData];
                        //                        self.isrequst =NO;
                    });
                }
                else if (code==102809) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [_theTableView reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [_theTableView reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [_theTableView tableViewDidFinishedLoading];
                                  if(![self.data_array count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [_theTableView reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
}
-(void)requstXiaoGongList{
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
        NSString *url =[NSString string];
        url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0299\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.currentPage];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"收藏小工返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (kResCode == 10002 || kResCode == 10003) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    return;
                    });
                }
                if (code==102991) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if(self.refreshing==YES && [self.data_array count]) [self.data_array removeAllObjects];
                        NSArray *arr_=[jsonDict objectForKey:@"workersList"];
                        if ([arr_ count]) {
                            self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                            self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                            for(NSDictionary *dict in arr_){
                                long str =[[dict objectForKey:@"workerId"]longValue];
                                //                                [dict setObject:str forKey:@"objId"];
                                NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:dict];
                                [dic setObject:[NSNumber numberWithLong:str] forKey:@"objId"];
                                [self.data_array addObject:dic];
                            }
                            //                            if ([[jsonDict objectForKey:@"newInfoNumber"] integerValue]>0) {
                            //                            }else{
                            //                                [self.unreadbtn removeFromSuperview];
                            //                            }
                        }
                        if([self.data_array count]){
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [_theTableView tableViewDidFinishedLoading];
                        }
                        else{
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [_theTableView tableViewDidFinishedLoading];
                        }
                        //                        self.isrequst =YES;
                        [_theTableView reloadData];
                        //                        self.isrequst =NO;
                    });
                }
                else if (code==102809) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [_theTableView reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        if(![self.data_array count]) {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        [_theTableView reloadData];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [_theTableView tableViewDidFinishedLoading];
                                  if(![self.data_array count]) {
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  [_theTableView reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
}
-(void)cancleknowlege:(NSString *)KnowledgeID count:(NSInteger)count{
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
        [postDict setObject:@"ID0292" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        int type =0;
        if ([self.selected_type isEqualToString:@"装修知识"]) {
            type =3;
        }else if ([self.selected_type isEqualToString:@"效果图"]){
            type = 1;
        }else if ([self.selected_type isEqualToString:@"装修方案"]){
            type =2;
        }else if ([self.selected_type isEqualToString:@"设计师"]){
            type =4;
        }else if ([self.selected_type isEqualToString:@"工长"]){
            type =6;
        }else if ([self.selected_type isEqualToString:@"监理"]){
            type =7;
        }else if ([self.selected_type isEqualToString:@"工人"]){
            type =5;
        }
        NSDictionary *bodyDic = @{@"objId":[NSNumber numberWithInt:[KnowledgeID intValue]],@"isCollection":[NSNumber numberWithInt:0],@"objType":[NSNumber numberWithInt:type]};
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
                        [self.data_array removeObjectAtIndex:count];
                        
                        if ([self.selected_type isEqualToString:@"装修知识"]) {
                            [_theTableView reloadData];
                        }else if ([self.selected_type isEqualToString:@"效果图"]){
                            [qtmquitView reloadData];
                        }else if ([self.selected_type isEqualToString:@"装修方案"]){
                            [qtmquitView reloadData];
                        }else if ([self.selected_type isEqualToString:@"设计师"]){
                            [_theTableView reloadData];
                        }else if ([self.selected_type isEqualToString:@"工长"]){
                            [_theTableView reloadData];
                        }else if ([self.selected_type isEqualToString:@"监理"]){
                            [_theTableView reloadData];
                        }else if ([self.selected_type isEqualToString:@"工人"]){
                            [_theTableView reloadData];
                        }
                        [TLToast showWithText:@"取消收藏成功"];
                    } else {
                        [self stopRequest];
                        [TLToast showWithText:@"取消收藏失败"];
                    }
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"取消收藏失败"];
                              });
                          }
                               method:url postDict:post];
    });
}
#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=1;
        if ([self.selected_type isEqualToString:@"装修知识"]) {
            [self requstknowledgeList];
        }else if ([self.selected_type isEqualToString:@"设计师"]){
            [self requstDesignerList];
        }else if ([self.selected_type isEqualToString:@"工长"]){
            [self requstGongZhangList];
        }else if ([self.selected_type isEqualToString:@"监理"]){
            [self requstJianLiList];
        }else if ([self.selected_type isEqualToString:@"工人"]){
            [self requstXiaoGongList];
        }
    }
    else {
        if(self.totalPages>self.currentPage){
            self.currentPage +=1;
            if ([self.selected_type isEqualToString:@"装修知识"]) {
                [self requstknowledgeList];
            }else if ([self.selected_type isEqualToString:@"设计师"]){
                [self requstDesignerList];
            }else if ([self.selected_type isEqualToString:@"工长"]){
                [self requstGongZhangList];
            }else if ([self.selected_type isEqualToString:@"监理"]){
                [self requstJianLiList];
            }else if ([self.selected_type isEqualToString:@"工人"]){
                [self requstXiaoGongList];
            }
        }
        else{
            
            [_theTableView tableViewDidFinishedLoading]; //加载完成（可设置信息）
            _theTableView.reachedTheEnd = YES;  //是否加载到底了
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=YES;
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    //NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    //创建一个NSDataFormatter显示刷新时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

//上拉加载  Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    if(isFirstInt==YES){
        self.refreshing=NO;
        [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
    }
    else {
        [_theTableView tableViewDidFinishedLoading];
        isFirstInt=!isFirstInt;
    }
}
#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_theTableView.contentOffset.y<-30) {
        _theTableView.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [_theTableView tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_theTableView tableViewDidEndDragging:scrollView];
}
//在将要启动定位时，会调用此函数
- (void)willStartLocatingUser{

}

//在停止定位后，会调用此函数
- (void)didStopLocatingUser{
    
}

//定位失败后，会调用此函数
- (void)didFailToLocateUserWithError:(NSError *)error{
    [TLToast showWithText:@"定位失败"];
}

//用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation.location.coordinate.latitude >0 && userLocation.location.coordinate.longitude >0) {
        self.userLocation =[[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
        [_locService stopUserLocationService];
        [_theTableView reloadData];
    }
}
@end
