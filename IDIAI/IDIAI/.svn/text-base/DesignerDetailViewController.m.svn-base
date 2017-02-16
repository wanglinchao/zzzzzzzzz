//
//  DesingerDetailViewController.m
//  IDIAI
//
//  Created by Ricky on 15-3-6.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DesignerDetailViewController.h"
#import "util.h"
#import "DesignerDetailModel.h"
#import "UIImageView+WebCache.h"
#import "TLToast.h"
#import "PicturesShowVC.h"
#import "SVProgressHUD.h"
#import "savelogObj.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "SubscribePeopleViewController.h"
#import "MyeffectPictureObj.h"
#import "EffectTAOTUPictureInfoForDesigner.h"
#import "IDIAIAppDelegate.h"
#import "MoreCommentsViewController.h"
#import "SubscribeListModel.h"
#import "MySubscribeDetailViewController.h"
#import "UIImageView+WebCache.h"
#define Kcelltag 1000


@interface DesignerDetailViewController () <LoginViewDelegate,CustomScrollViewDelegate> {
    PullingRefreshTableView *_theTableView;
//    UITableView *_theTableView;
    DesignerDetailModel *_designerDetailModel;
    UIView *_bgView;//section0的cell背景
    UIView *_bgView2;//section1的cell背景
    MyeffectPictureObj *_myEffPicObj;
    NSMutableArray *_taotuMutArr;
    NSString *_bookIdStr;
}

@end

@implementation DesignerDetailViewController

@synthesize dataArray_pl;

- (void)customizeNavigationBar {
    
        NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path_ = [path_ objectAtIndex:0];
        NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:@"MydesignerCollect.plist"];
        NSMutableArray *Arr_=[NSMutableArray arrayWithContentsOfFile:_filename_];
        if (!Arr_) {
            Arr_=[NSMutableArray arrayWithCapacity:0];
        }
        self.btn_shouc = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_shouc.frame=CGRectMake(kMainScreenWidth-50, 25, 35, 35);
        if([Arr_ count]){
            for(NSDictionary *dict in Arr_){
                if([[dict objectForKey:@"designerID"] integerValue]==_designerDetailModel.designerID){
                    [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_grb_s.png"] forState:UIControlStateNormal];
                    self.btn_shouc.selected=YES;
                    break;
                }
                else{
                    [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_grb.png"] forState:UIControlStateNormal];
                    self.btn_shouc.selected=NO;
                }
            }
        }
        else{
            [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_grb.png"] forState:UIControlStateNormal];
            self.btn_shouc.selected=NO;
        }
    
        [self.btn_shouc addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn_shouc =(UIButton *)[self.view viewWithTag:1001];
    if (!btn_shouc) {
        [self.view addSubview:self.btn_shouc];
    }
    self.btn_shouc.tag=1001;
}

//- (void)viewWillLayoutSubviews{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
//}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIButton *leftButton = (UIButton *)[self.view viewWithTag:10001];
    if (!leftButton)
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.tag = 10001;
    [leftButton setFrame:CGRectMake(20, 25, 35, 35)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"ic_fanhui_b.png"] forState:UIControlStateNormal];
    //    [leftButton setBackgroundImage:[UIImage imageNamed:@"bt_back_pressed"] forState:UIControlStateHighlighted];
    //leftButton.imageEdgeInsets=UIEdgeInsetsMake(30, 20, 0, 60);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:leftButton];
}

- (void)viewDidAppear:(BOOL)animated {
     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
     [_theTableView launchRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
//    [[[self navigationController] navigationBar] setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"查看设计师详情" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:54];
    
    self.title = @"设计师详情";
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapPicture:) name:@"designer_tap" object:nil];
//    _theTableView  = [[UITableView alloc]initWithFrame:kTableViewWithTabBarFrame style:UITableViewStyleGrouped];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _theTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _theTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _theTableView=[[PullingRefreshTableView alloc]initWithFrame:kTableViewWithTabBarFrame pullingDelegate:self];
    _theTableView.backgroundColor = [UIColor colorWithHexString:@"#F0B236" alpha:1.0];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _theTableView.headerOnly =YES;
    [self.view addSubview:_theTableView];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 10, 250)];
    bgView.backgroundColor = [UIColor clearColor];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 20, 250)];
    contentView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:contentView];
    _theTableView.tableFooterView = bgView;
    
    self.imageViewArray = [[NSMutableArray alloc] initWithCapacity:5];
    self.dataArray_pl=[NSMutableArray arrayWithCapacity:0];
    _taotuMutArr = [NSMutableArray arrayWithCapacity:10];
//    [self requestDesignerDetail];
//    [self requestCommentsList];
//    [self requestBrower];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        if ([[_designerDetailModel.designerIsAuthent firstObject]objectForKey:@"authzId"]) {
//            return _bgView.frame.size.height + 75;
//        }else{
            return _bgView.frame.size.height + 45;
//        }
    
    } else if (indexPath.section == 1) {
        return _bgView2.frame.size.height>30?_bgView2.frame.size.height + 20 : 0;
    } else  {
        if([self.dataArray_pl count]){
            NSString *string_pl=[[self.dataArray_pl objectAtIndex:indexPath.row] objectForKey:@"objectString"];
            CGSize size=[util calHeightForLabel:string_pl width:kMainScreenWidth-90 font:[UIFont systemFontOfSize:15]];
            if(size.height<20) size.height=30;
            return 30 + size.height + 35;
        } else {
            return 50;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 60;
    } else {
        if (section ==0) {
            return 40;
        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
    return 0;
    } else if (section == 1) {
        return 0;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return [self.dataArray_pl count];
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth , 150)];
        bgView.backgroundColor = [UIColor clearColor];
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 20, 150)];
        contentView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:contentView];
        return bgView;
    }
    return nil;
}

- (void)tapHeader:(UIButton *)sender {
    MoreCommentsViewController *morevc=[[MoreCommentsViewController alloc]init];
    morevc.role_id=@"1";
    morevc.client_id=_obj.designerID;
    morevc.fromVCStr = self.fromVCStr;
    [self.navigationController pushViewController:morevc animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier1 = @"designerDetailCell1";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
         if (!cell1) {
             cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
             cell1.backgroundColor = [UIColor clearColor];
             
             _bgView = [[UIView alloc]init];
             _bgView.backgroundColor = [UIColor whiteColor];
             [cell1.contentView addSubview:_bgView];
             
             UIImageView *headView = [[UIImageView alloc]init];
             headView.tag = 104;
             headView.layer.masksToBounds = YES;
             headView.layer.cornerRadius = 45;
             UIColor *color = [UIColor colorWithHexString:@"#F0B236" alpha:1.0];
             headView.layer.borderColor = color.CGColor;
             headView.layer.borderWidth = 5;
             [cell1.contentView addSubview:headView];
             
         
             UILabel *nameLabel = [[UILabel alloc]init];
             nameLabel.font = [UIFont systemFontOfSize:15];
             nameLabel.tag = 105;
             nameLabel.textAlignment = NSTextAlignmentCenter;
             [_bgView addSubview:nameLabel];
             
             UIImageView *authentIV = [[UIImageView alloc]init];
             authentIV.tag = 122;
             [_bgView addSubview:authentIV];
             
             UILabel *authzidlbl =[[UILabel alloc] init];
             authzidlbl.tag =170;
             [_bgView addSubview:authzidlbl];
             
             UILabel *experienceLabel = [[UILabel alloc]init];
             experienceLabel.font = [UIFont systemFontOfSize:15];
             experienceLabel.textColor = [UIColor lightGrayColor];
             experienceLabel.tag = 106;
             experienceLabel.textAlignment = NSTextAlignmentCenter;
             [_bgView addSubview:experienceLabel];
             
             UILabel *descLabel = [[UILabel alloc]init];
             descLabel.tag = 107;
             descLabel.numberOfLines = 0;
             descLabel.lineBreakMode = NSLineBreakByWordWrapping;
             descLabel.font = [UIFont systemFontOfSize:15];
             descLabel.textColor = [UIColor lightGrayColor];
             [_bgView addSubview:descLabel];
             
             UIView *lineView = [[UIView alloc]init];
             lineView.tag = 108;
             lineView.backgroundColor = kFontPlacehoderColor;
             [_bgView addSubview:lineView];
             
             UIView *lineView1 = [[UIView alloc]init];
             lineView1.tag = 171;
             lineView1.backgroundColor = kFontPlacehoderColor;
             [_bgView addSubview:lineView1];
       /*
            UIImageView *browseIV = [[UIImageView alloc]init];
             browseIV.tag = 101;
             browseIV.image = [UIImage imageNamed:@"ic_liulanliang.png"];
             [_bgView addSubview:browseIV];
             
             UILabel *browseLabel = [[UILabel alloc]init];
             browseLabel.tag = 102;
             browseLabel.textAlignment = NSTextAlignmentCenter;
             browseLabel.textColor = [UIColor lightGrayColor];
             [_bgView addSubview:browseLabel];
        
        */
             
             UILabel *priceRangeKey = [[UILabel alloc]init];
             priceRangeKey.tag = 150;
             priceRangeKey.font=[UIFont systemFontOfSize:14];
             priceRangeKey.textAlignment = NSTextAlignmentLeft;
             priceRangeKey.textColor = [UIColor lightGrayColor];
             [_bgView addSubview:priceRangeKey];
             
             UILabel *fuhao = [[UILabel alloc]init];
             fuhao.tag = 151;
             fuhao.font=[UIFont systemFontOfSize:13];
             fuhao.textAlignment = NSTextAlignmentLeft;
             fuhao.textColor = [UIColor redColor];
             [_bgView addSubview:fuhao];
             
             UILabel *priceRangeValue = [[UILabel alloc]init];
             priceRangeValue.tag = 152;
             priceRangeValue.font=[UIFont systemFontOfSize:17];
             priceRangeValue.textAlignment = NSTextAlignmentLeft;
             priceRangeValue.textColor = [UIColor redColor];
             [_bgView addSubview:priceRangeValue];
             
             UILabel *subscribe = [[UILabel alloc]init];
             subscribe.tag = 153;
             subscribe.font=[UIFont systemFontOfSize:14];
             subscribe.textAlignment = NSTextAlignmentRight;
             subscribe.textColor = [UIColor lightGrayColor];
             [_bgView addSubview:subscribe];
             
             
             UIImageView *footIV = [[UIImageView alloc]init];
             footIV.tag = 103;
             footIV.image = [UIImage imageNamed:@"bg_shejishixiangqing.png"];
             
             [cell1.contentView addSubview:footIV];
             NSLog(@"%@",[_bgView subviews]);
             NSLog(@"%@",[cell1.contentView subviews]);
             
         }
        
        CGSize descSize = [util calHeightForLabel:_designerDetailModel.designerDesc width:kMainScreenWidth - 40 font:[UIFont systemFontOfSize:15]];
        float authzheight =0;
        if ([[_designerDetailModel.designerIsAuthent firstObject]objectForKey:@"authzId"]){
            authzheight =30;
        }
            _bgView.frame = CGRectMake(10, 35, kMainScreenWidth - 20, descSize.height + 200+authzheight);
        
        
        UIImageView *headView = (UIImageView *)[cell1 viewWithTag:104];
        headView.frame = CGRectMake(_bgView.frame.size.width/2 - 35, -5, 90, 90);
        [headView sd_setImageWithURL:[NSURL URLWithString:_designerDetailModel.designerIconPath] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
        
        UILabel *nameLabel = (UILabel *)[cell1 viewWithTag:105];
        NSString *nameStr = _designerDetailModel.designerName;
        CGSize size = [util calHeightForLabel:nameStr width:_bgView.frame.size.width - 20 font:[UIFont systemFontOfSize:17]];
        nameLabel.frame = CGRectMake((_bgView.frame.size.width - size.width)/2, headView.frame.origin.y + headView.frame.size.height - 20, size.width, 21);
        nameLabel.text = nameStr;
        
        UILabel *experienceLabel = (UILabel *)[cell1 viewWithTag:106];
        NSString *experienceStr = [NSString string];
        if(_designerDetailModel.designerExperience)
            experienceStr = [NSString stringWithFormat:@"经验: %@",_designerDetailModel.designerExperience];
        else
            experienceStr = @"经验: ";
        CGSize exlabelSize = [util calHeightForLabel:experienceStr width:_bgView.frame.size.width - 20 font:[UIFont systemFontOfSize:15]];
        experienceLabel.frame = CGRectMake((_bgView.frame.size.width - exlabelSize.width)/2, nameLabel.frame.origin.y + nameLabel.frame.size.height + 5, exlabelSize.width, 21);
        experienceLabel.text = experienceStr;
        
        //加载星级（0-10,0表示无星级）
        NSInteger star_level=0;
        if(_designerDetailModel.designerLevel < _designerDetailModel.designerLevel)
            star_level=_designerDetailModel.designerLevel *2+1;
        else
            star_level=_designerDetailModel.designerLevel *2;
        self.numberStart = star_level;
        if(!self.startView) self.startView = [[UIView alloc] init];
        self.startView.frame=CGRectMake((_bgView.frame.size.width - 160)/2 + 25, experienceLabel.frame.origin.y + experienceLabel.frame.size.height + 5, 160, 20);
        [self.startView setBackgroundColor:[UIColor clearColor]];
        [_bgView addSubview:self.startView];
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
        if (_designerDetailModel.designerIsAuthent.count>0) {
            int count =0;
            for (NSDictionary *authzdic in _designerDetailModel.designerIsAuthent) {
                NSString *authzid =[authzdic objectForKey:@"authzId"];
                UIImageView *authentIV =(UIImageView *)[cell1 viewWithTag:1000+count*2+1];
                if (!authentIV) {
                    authentIV = [[UIImageView alloc] initWithFrame:CGRectMake(10+103*count, self.startView.frame.origin.y + self.startView.frame.size.height + 6, 18, 18)];
                    authentIV.tag =1000+count*2+1;
                    [_bgView addSubview:authentIV];
                }
                authentIV.image =[UIImage imageNamed:[NSString stringWithFormat:@"ic_rz_b_%i.png",[[authzdic objectForKey:@"authzId"]integerValue]]];
                UILabel *authzidlbl =(UILabel *)[cell1 viewWithTag:1000+count*2+2];
                if (!authzidlbl) {
                    authzidlbl =[[UILabel  alloc] initWithFrame:CGRectMake(authentIV.frame.origin.x+authentIV.frame.size.width+5, authentIV.frame.origin.y+1, 80, 16)];
                    authzidlbl.tag =1000+count*2+2;
                    [_bgView addSubview:authzidlbl];
                }
                authzidlbl.textColor =[UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1.0];
                authzidlbl.font =[UIFont systemFontOfSize:16.0];
                NSString *rzbstr =[NSString string];
                switch ([authzid integerValue]) {
                    case 1:
                        rzbstr =@"身份验证";
                        break;
                    case 2:
                        rzbstr =@"优惠";
                        break;
                    case 3:
                        rzbstr =@"特价";
                        break;
                    case 4:
                        rzbstr =@"工长认证";
                        break;
                    case 5:
                        rzbstr =@"商铺认证";
                        break;
                    case 6:
                        rzbstr =@"工艺认证";
                        break;
                    case 7:
                        rzbstr =@"监理认证";
                        break;
                    default:
                        break;
                }
                authzidlbl.text =rzbstr;
                count++;
            }
            UIView *lineView = (UIView *)[cell1 viewWithTag:172];
            lineView.frame = CGRectMake(10, self.startView.frame.origin.y + self.startView.frame.size.height +29.5, _bgView.frame.size.width - 20, 0.5);
            
        }
//        if ([[_designerDetailModel.designerIsAuthent firstObject]objectForKey:@"authzId"]) {
//            UIImageView *authentIV = (UIImageView *)[cell1 viewWithTag:122];
//            authentIV.frame = CGRectMake(10, self.startView.frame.origin.y + self.startView.frame.size.height + 6, 18, 18);
//            authentIV.image = [UIImage imageNamed:@"ic_grrz_s.png"];
//            UILabel *authzidlbl =(UILabel *)[cell1 viewWithTag:170];
//            authzidlbl.frame=CGRectMake( authentIV.frame.origin.x+authentIV.frame.size.width+5, authentIV.frame.origin.y+1, 80, 16);
//            authzidlbl.textColor =[UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1.0];
//            authzidlbl.text =@"身份验证";
//            authzidlbl.font =[UIFont systemFontOfSize:16.0];
//            
//            UIView *lineView = (UIView *)[cell1 viewWithTag:171];
//            lineView.frame = CGRectMake(10, self.startView.frame.origin.y + self.startView.frame.size.height +29.5, _bgView.frame.size.width - 20, 0.5);
//        }
        
        UILabel *descLabel = (UILabel *)[cell1 viewWithTag:107];
         descLabel.frame = CGRectMake(10, self.startView.frame.origin.y + self.startView.frame.size.height + 10+authzheight, _bgView.frame.size.width - 20, descSize.height);
         descLabel.text = _designerDetailModel.designerDesc;
        
        UIView *lineView = (UIView *)[cell1 viewWithTag:108];
        lineView.frame = CGRectMake(10, descLabel.frame.origin.y + descLabel.frame.size.height + 10, _bgView.frame.size.width - 20, 0.5);
        
    /*
        UIImageView *browseIV = (UIImageView *)[cell1 viewWithTag:101];
        browseIV.frame = CGRectMake(kMainScreenWidth - 100, lineView.frame.origin.y + lineView.frame.size.height + 10, 22, 22);
        
        UILabel *browseLabel = (UILabel *)[cell1 viewWithTag:102];
        browseLabel.frame = CGRectMake(browseIV.frame.origin.x + browseIV.frame.size.width + 5, browseIV.frame.origin.y, 50, 21);
         browseLabel.text = [NSString stringWithFormat:@"%d",_designerDetailModel.browsePoints];
    */
        
        UILabel *priceRangeKey = (UILabel *)[cell1 viewWithTag:150];
        priceRangeKey.frame = CGRectMake(10, lineView.frame.origin.y + lineView.frame.size.height + 10, 70, 21);
        priceRangeKey.text = @"报价区间：";
        
        UILabel *fuhao = (UILabel *)[cell1 viewWithTag:151];
        fuhao.frame = CGRectMake(priceRangeKey.frame.origin.x +65, lineView.frame.origin.y + lineView.frame.size.height + 11, 10, 21);
        fuhao.text = @"￥";
        
        UILabel *priceRangeValue = (UILabel *)[cell1 viewWithTag:152];
        priceRangeValue.frame = CGRectMake(priceRangeKey.frame.origin.x +80, lineView.frame.origin.y + lineView.frame.size.height + 10, kMainScreenWidth-30-70-120, 21);
        priceRangeValue.text = [NSString stringWithFormat:@"%ld-%ld /m²",(long)[_designerDetailModel.priceMin integerValue],(long)[_designerDetailModel.priceMax integerValue]];

        UILabel *subscribe = (UILabel *)[cell1 viewWithTag:153];
        subscribe.frame = CGRectMake(kMainScreenWidth-150, lineView.frame.origin.y + lineView.frame.size.height + 10, 120, 21);
        if([_designerDetailModel.appointmentNum integerValue]>=100000000) subscribe.text=[NSString stringWithFormat:@"预约数：%.1f亿",[_designerDetailModel.appointmentNum floatValue]/100000000.0];
        else if([_designerDetailModel.appointmentNum integerValue]>=10000) subscribe.text=[NSString stringWithFormat:@"预约数：%.1f万",[_designerDetailModel.appointmentNum floatValue]/10000.0];
        else subscribe.text=[NSString stringWithFormat:@"预约数：%lld",[_designerDetailModel.appointmentNum longLongValue]];
        
        UIView *footView = (UIView *)[cell1 viewWithTag:103];
        footView.frame = CGRectMake(10, _bgView.frame.origin.y +_bgView.frame.size.height , _bgView.frame.size.width, 10);
        
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
        
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier2 = @"designerDetailCell2";
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (!cell2) {
            cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            cell2.backgroundColor = [UIColor clearColor];
            
            _bgView2 = [[UIView alloc]init];
            _bgView2.backgroundColor = [UIColor whiteColor];
            [cell2.contentView addSubview:_bgView2];
            
            UILabel *nameLabel = [[UILabel alloc]init];
            nameLabel.tag = 123;
            [cell2.contentView addSubview:nameLabel];
            
            UIImageView *footIV = [[UIImageView alloc]init];
            footIV.tag = 120;
            footIV.image = [UIImage imageNamed:@"bg_shejishixiangqing.png"];
            [cell2.contentView addSubview:footIV];
        }
        
        NSInteger height;
        if (_designerDetailModel.designerImagesPath.count) {
            height =10+ 220+10+ 220 * _designerDetailModel.designerCollectivePics.count + _designerDetailModel.designerCollectivePics.count * 10;
            
        } else {
            height = 10+220 * _designerDetailModel.designerCollectivePics.count + _designerDetailModel.designerCollectivePics.count * 10;
        }
        
//        if (_designerDetailModel.designerImagesPath.count) {
//            height = 220 + 220 * _designerDetailModel.designerCollectivePics.count + _designerDetailModel.designerCollectivePics.count * 40;
//            
//            if (_designerDetailModel.designerCollectivePics.count == 0) {
//                height += 30;
//            } else if (_designerDetailModel.designerCollectivePics.count > 4) {
//                height -= _designerDetailModel.designerCollectivePics.count * 10;
//            }
//        } else {
//            height = 220 * _designerDetailModel.designerCollectivePics.count + _designerDetailModel.designerCollectivePics.count * 25;
//        }
        _bgView2.frame = CGRectMake(10, 10, kMainScreenWidth - 20, height);
        
        if([_designerDetailModel.designerImagesPath count]>1){
            NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < [_designerDetailModel.designerImagesPath count]; ++i) {
                @autoreleasepool {
                    UIImageView *view_sub = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, _bgView2.frame.size.width-20, 220)];
                    view_sub.clipsToBounds=YES;
                    view_sub.contentMode=UIViewContentModeScaleAspectFill;
                    [view_sub sd_setImageWithURL:[NSURL URLWithString:[[_designerDetailModel.designerImagesPath objectAtIndex:i] objectForKey:@"rendreingsPath"]] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"] options:SDWebImageTransformAnimatedImage];
                    [viewsArray addObject:view_sub];
                }
            }
            
            self.selected_picture=0;
            if(!self.mainScorllView)self.mainScorllView = [[CustomScrollView alloc] initWithFrame:CGRectMake(10, 10, _bgView2.frame.size.width-20, 220) animationDuration:0];
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
            [_bgView2 addSubview:self.mainScorllView];
            
        }
        else if([_designerDetailModel.designerImagesPath count]==1){
            UIImageView *view_sub = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _bgView2.frame.size.width-20, 220)];
            view_sub.userInteractionEnabled=YES;
            view_sub.clipsToBounds=YES;
            view_sub.contentMode=UIViewContentModeScaleAspectFill;
            [view_sub sd_setImageWithURL:[NSURL URLWithString:[[_designerDetailModel.designerImagesPath objectAtIndex:0] objectForKey:@"rendreingsPath"]] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"] options:SDWebImageTransformAnimatedImage];
            [_bgView2 addSubview:view_sub];
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
            tap.numberOfTouchesRequired=1;
            tap.numberOfTapsRequired=1;
            [view_sub addGestureRecognizer:tap];
        }
        
        if([_designerDetailModel.designerImagesPath count]!=0){
            UIView *view_bg_count=[[UIView alloc]initWithFrame:CGRectMake((kMainScreenWidth-60)/2, 8+200-5, 60, 20)];
            view_bg_count.layer.cornerRadius=10;
            view_bg_count.layer.masksToBounds=YES;
            view_bg_count.clipsToBounds = YES;
            view_bg_count.backgroundColor=[UIColor blackColor];
            view_bg_count.opaque=YES;
            view_bg_count.alpha=0.35;
            [_bgView2 addSubview:view_bg_count];
            
            if(!self.lab_count)self.lab_count= [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 60, 16)];
            self.lab_count.backgroundColor = [UIColor clearColor];
            self.lab_count.font = [UIFont systemFontOfSize:13.0];
            self.lab_count.textAlignment = NSTextAlignmentCenter;
            self.lab_count.textColor = [UIColor whiteColor];
            self.lab_count.text =[NSString stringWithFormat:@"1/%d",[_designerDetailModel.designerImagesPath count]];
            [view_bg_count addSubview:self.lab_count];
        }
        
        for (UIView *view in _bgView2.subviews) {
            if (view.tag == 110 || view.tag == 111) {
                [view removeFromSuperview];
            }
        }
        
        for (int i = 0; i < _designerDetailModel.designerCollectivePics.count; i++) {
            UIImageView *taotuIV;
            if (self.mainScorllView) {
            taotuIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.mainScorllView.frame.origin.y + self.mainScorllView.frame.size.height + 220 * i + 10 + i * 10, _bgView.frame.size.width - 20, 220)];
                taotuIV.clipsToBounds=YES;
                taotuIV.contentMode=UIViewContentModeScaleAspectFill;
                NSString *imgStr = [[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"narrowImgPath"];
                [taotuIV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                taotuIV.tag = 110 + i;
                UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTaotuImage:)];
                taotuIV.userInteractionEnabled = YES;
                [taotuIV addGestureRecognizer:tapRec];
                [_bgView2 addSubview:taotuIV];
                
                UIImageView *hintBgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 190, _bgView.frame.size.width, 70)];
                hintBgIV.image = [UIImage imageNamed:@"bg_taotu.png"];
                [taotuIV addSubview:hintBgIV];

                //            UILabel *nameLabel = (UILabel *)[cell2 viewWithTag:123];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, _bgView.frame.size.width/2 - 10, 21)];
                nameLabel.textColor = [UIColor whiteColor];
                NSString *name = [[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"collectiveDrawingName"];
                nameLabel.text = name;
                [hintBgIV addSubview:nameLabel];
                
                UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(_bgView2.frame.size.width/2 + 20, 0, _bgView2.frame.size.width/2 - 50, 21)];
                numLabel.textColor = [UIColor whiteColor];
                numLabel.textAlignment = NSTextAlignmentRight;
                NSInteger numInteger = [[[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"rendreingsList"]count];
                NSString *numStr = [NSString stringWithFormat:@"1/%d",numInteger];
                numLabel.text = numStr;
                [hintBgIV addSubview:numLabel];
            } else {
                
                if (!_designerDetailModel.designerImagesPath.count) {
                    taotuIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10 + 220 * i + 10 + i * 10, _bgView.frame.size.width - 20, 220)];
                    taotuIV.clipsToBounds=YES;
                    taotuIV.contentMode=UIViewContentModeScaleAspectFill;
                    NSString *imgStr = [[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"narrowImgPath"];
                    [taotuIV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                    taotuIV.tag = 110 + i;
                    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTaotuImage:)];
                    taotuIV.userInteractionEnabled = YES;
                    [taotuIV addGestureRecognizer:tapRec];
                    [_bgView2 addSubview:taotuIV];

                } else {
                 taotuIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10 + 220 + 220 * i + 10 + i * 10, _bgView.frame.size.width - 20, 220)];
                    taotuIV.clipsToBounds=YES;
                    taotuIV.contentMode=UIViewContentModeScaleAspectFill;
                    NSString *imgStr = [[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"narrowImgPath"];
                    [taotuIV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                    taotuIV.tag = 110 + i;
                    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTaotuImage:)];
                    taotuIV.userInteractionEnabled = YES;
                    [taotuIV addGestureRecognizer:tapRec];
                    [_bgView2 addSubview:taotuIV];

                }
                
                UIImageView *hintBgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 190, _bgView.frame.size.width, 70)];
                hintBgIV.image = [UIImage imageNamed:@"bg_taotu.png"];
                [taotuIV addSubview:hintBgIV];
                
                //            UILabel *nameLabel = (UILabel *)[cell2 viewWithTag:123];
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, _bgView.frame.size.width/2 - 10, 21)];
                nameLabel.textColor = [UIColor whiteColor];
                NSString *name = [[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"collectiveDrawingName"];
                nameLabel.text = name;
                [hintBgIV addSubview:nameLabel];
                
                UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(_bgView2.frame.size.width/2 + 20, 0, _bgView2.frame.size.width/2 - 50, 21)];
                numLabel.textColor = [UIColor whiteColor];
                numLabel.textAlignment = NSTextAlignmentRight;
                NSInteger numInteger = [[[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"rendreingsList"]count];
                NSString *numStr = [NSString stringWithFormat:@"1/%i",numInteger];
                numLabel.text = numStr;
                [hintBgIV addSubview:numLabel];
                
            }
            
        }
        
        

        if (_bgView2.frame.size.height != 0) {
        UIImageView *footView = (UIImageView *)[cell2 viewWithTag:120];
        footView.frame = CGRectMake(10, _bgView2.frame.origin.y +_bgView2.frame.size.height , _bgView2.frame.size.width, 10);
        }
        
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell2;
    } else {
        NSString *CellIdentifier3 =[NSString stringWithFormat:@"designerDetailCell3_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (!cell3) {
            cell3 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
            cell3.backgroundColor = [UIColor clearColor];
            
            UIView *cellBgView = [[UIView alloc]init];
            cellBgView.tag = 10011;
            cellBgView.backgroundColor = [UIColor whiteColor];
            [cell3.contentView addSubview:cellBgView];
            
            UIView *line_pl=[[UIView alloc]init];
            line_pl.backgroundColor=[UIColor lightGrayColor];
            line_pl.tag=10010;
            [cellBgView addSubview:line_pl];
            
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.textColor = [UIColor grayColor];
            nameLabel.tag = 10012;
            [cell3.contentView addSubview:nameLabel];
            
            UILabel *lab_pl = [[UILabel alloc] init];
            lab_pl.backgroundColor = [UIColor clearColor];
            lab_pl.tag=10013;
            lab_pl.font = [UIFont systemFontOfSize:15.0];
            lab_pl.textAlignment = NSTextAlignmentLeft;
            lab_pl.textColor = [UIColor grayColor];
            lab_pl.numberOfLines=0;
            [cell3.contentView addSubview:lab_pl];
            
            UILabel *timeLabel = [[UILabel alloc] init];
            timeLabel.font = [UIFont systemFontOfSize:11.0];
            timeLabel.textColor = [UIColor lightGrayColor];
            timeLabel.tag = 10014;
            [cell3.contentView addSubview:timeLabel];
        }
        
        UIImageView *photo_pl=(UIImageView *)[cell3.contentView viewWithTag:Kcelltag*(indexPath.section+2)+indexPath.row];
        if(!photo_pl){
            photo_pl=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 40, 40)];
            photo_pl.image=[UIImage imageNamed:@"ic_touxiang_tk_over.png"];
        }
        photo_pl.layer.cornerRadius=20.0;
        photo_pl.layer.masksToBounds=YES;
        photo_pl.clipsToBounds = YES;
        photo_pl.tag=Kcelltag*(indexPath.section+2)+indexPath.row;
        [cell3.contentView addSubview:photo_pl];
        
        dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(parsingQueue, ^{
            if([[[self.dataArray_pl objectAtIndex:indexPath.row] objectForKey:@"userLogos"] length]>1)
                [photo_pl sd_setImageWithURL:[NSURL URLWithString:[[self.dataArray_pl objectAtIndex:indexPath.row] objectForKey:@"userLogos"]] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
                
                     });
        
        NSString *nameStr = [[self.dataArray_pl objectAtIndex:indexPath.row]objectForKey:@"nickName"];
        UILabel *nameLabel=(UILabel *)[cell3.contentView viewWithTag:10012];
        nameLabel.font = [UIFont systemFontOfSize:14.0];
        nameLabel.frame = CGRectMake(70, 12, kMainScreenWidth-90, 20);
        if(nameStr.length) nameLabel.text = nameStr;
        else nameLabel.text = @"匿名用户";
        
        NSString *string_pl=[[self.dataArray_pl objectAtIndex:indexPath.row] objectForKey:@"objectString"];
        CGSize size=[util calHeightForLabel:string_pl width:kMainScreenWidth-90 font:[UIFont systemFontOfSize:15]];
        if(size.height<20) size.height=30;
        UILabel *lab_pl=(UILabel *)[cell3.contentView viewWithTag:10013];
        lab_pl.frame = CGRectMake(68, 35, kMainScreenWidth-90, size.height);
        lab_pl.text =string_pl;
        
        NSString *timeStr = [[self.dataArray_pl objectAtIndex:indexPath.row]objectForKey:@"createDate"];
        UILabel *timeLabel=(UILabel *)[cell3.contentView viewWithTag:10014];
        timeLabel.frame = CGRectMake(68, 35+size.height , kMainScreenWidth-90, 20);
        timeLabel.text = timeStr;

        CGFloat height = 30 + size.height + 35;
        UIView *cellBgView = (UIView *)[cell3 viewWithTag:10011];
        cellBgView.frame = CGRectMake(10, 0, kMainScreenWidth - 20, height+0.5);
        
        UIView *line_pl=(UIView *)[cell3.contentView viewWithTag:10010];
        line_pl.frame = CGRectMake(50, cellBgView.frame.size.height-2.5, kMainScreenWidth-80, 0.5);
        line_pl.alpha=0.5;

        cell3.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell3;
    }
    
 }

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
    UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth - 20, 50)];
    view_.backgroundColor=[UIColor clearColor];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth - 20, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
    
    UIView *line_secon_header=[[UIView alloc]initWithFrame:CGRectMake(10, 49.5, kMainScreenWidth-40, 0.5)];
    line_secon_header.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
    [bgView addSubview:line_secon_header];
    
    
    UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 30)];
    designer_jianj.backgroundColor = [UIColor clearColor];
    designer_jianj.font = [UIFont systemFontOfSize:18.0];
    designer_jianj.textAlignment = NSTextAlignmentLeft;
    designer_jianj.textColor = [UIColor grayColor];
    designer_jianj.text =@"更多评论";
    [bgView addSubview:designer_jianj];
    
    UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
    imv.frame = CGRectMake(kMainScreenWidth-45, 15, 10, 20);
    [bgView addSubview:imv];
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = CGRectMake(0, 0, kMainScreenWidth - 20, 50);
    headerBtn.tag = 102;
    [headerBtn addTarget:self
                  action:@selector(tapHeader:)
        forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:headerBtn];
    
        [view_ addSubview:bgView];
        
    return view_;
        
    } else {
        if (section ==0) {
            UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth - 20, 40)];
            view_.backgroundColor=[UIColor clearColor];
            return view_;
        }
        return nil;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 1) {
//        EffectTAOTUPictureInfoForDesigner *effVC=[[EffectTAOTUPictureInfoForDesigner alloc]init];
////        effVC.obj_pic=obj;
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        UIImageView *cellIV = (UIImageView *)[cell viewWithTag:110 + indexPath.row];
//        
//        if (!cellIV.tag) {
//            return;
//        }
//        effVC.img_=cellIV.image;
//        effVC.type_into=1;
//        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];
//        [appDelegate.nav pushViewController:effVC animated:YES];
//    }
}

#pragma mark - 请求设计师详情
-(void)requestDesignerDetail{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0021\",\"deviceType\":\"ios\",\"cityCode\":\"%@\"}&body={\"designerID\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.obj.designerID];
        
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
                if (code==10231) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _designerDetailModel = [DesignerDetailModel objectWithKeyValues:jsonDict];
                        
                         [self customizeNavigationBar];
                        
                        if(_designerDetailModel.state == 1){
                            [self createPhone];
                        }
                        
                        [_taotuMutArr removeAllObjects];
                        for (NSDictionary *dic in _designerDetailModel.designerCollectivePics) {
                            NSDictionary *dic2 = @{@"id":[dic objectForKey:@"collectiveDrawingId"],@"browserNum":[dic objectForKey:@"browsePoints"],@"collectionName":[dic objectForKey:@"collectiveDrawingName"],@"imagePath":[dic objectForKey:@"narrowImgPath"],@"designerID":_obj.designerID,@"designerName":_obj.designerName,@"designerImagePath":_designerDetailModel.designerIconPath?_designerDetailModel.designerIconPath:@""};
                             MyeffectPictureObj *myEffPicObj = [MyeffectPictureObj objWithDict:dic2];
                            
                            [_taotuMutArr addObject:myEffPicObj];
                        }
                        [_theTableView tableViewDidFinishedLoading];
                        [_theTableView reloadData];
                        
                    });
                }
                else if (code==10379) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_theTableView tableViewDidFinishedLoading];
                    });
                }
                else{
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_theTableView tableViewDidFinishedLoading];
                    });
                }
            });
        }
                          failedBlock:^{
                              [self stopRequest];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [_theTableView tableViewDidFinishedLoading];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
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

-(void)scrollviewToCurrent:(NSInteger)index{
    self.selected_picture=index;
    self.lab_count.text=[NSString stringWithFormat:@"%d/%d",index+1,[_designerDetailModel.designerImagesPath count]];
}

-(void)tapImage:(UIGestureRecognizer *)gers{
    if(![util isConnectionAvailable]) [TLToast showWithText:@"无网络连接" topOffset:200.0f duration:1.0];
    PicturesShowVC *picvc=[[PicturesShowVC alloc]init];
    picvc.data_array=_designerDetailModel.designerImagesPath;
    picvc.type_pic=@"designer";
    picvc.pic_id=self.selected_picture;
    [self.navigationController pushViewController:picvc animated:YES];
}

-(void)tapTaotuImage:(UIGestureRecognizer *)gers{
    UIImageView *cellIV = (UIImageView *)[gers view];
    EffectTAOTUPictureInfoForDesigner *effVC=[[EffectTAOTUPictureInfoForDesigner alloc]init];
    //        effVC.obj_pic=obj;
    effVC.obj_pic = [_taotuMutArr objectAtIndex:cellIV.tag-110];
            effVC.img_=cellIV.image;
            effVC.type_into=1;
    effVC.picListArr = [[_designerDetailModel.designerCollectivePics objectAtIndex:cellIV.tag-110]objectForKey:@"rendreingsList"];
    effVC.descStr = [[_designerDetailModel.designerCollectivePics objectAtIndex:cellIV.tag-110]objectForKey:@"description"];
    effVC.xiaoquNameStr = [[_designerDetailModel.designerCollectivePics objectAtIndex:cellIV.tag-110]objectForKey:@"collectiveDrawingName"];
    
//    NSInteger browseInteger = [[[_designerDetailModel.designerCollectivePics objectAtIndex:cellIV.tag-110]objectForKey:@"browsePoints"]integerValue]+1;
//    effVC.browseNumStr = [NSString stringWithFormat:@"%d",browseInteger];
    effVC.designerIDStr = _obj.designerID;
    effVC.picIDStr = [[_designerDetailModel.designerCollectivePics objectAtIndex:cellIV.tag-110]objectForKey:@"collectiveDrawingId"];
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
            [appDelegate.nav pushViewController:effVC animated:YES];
//    [self.navigationController pushViewController:effVC animated:YES];
//    effVC.selectDone =^(MyeffectPictureObj *obj_pic){
//        
//    };
}

-(void)tapPicture:(NSNotification *)notif{
    if(![util isConnectionAvailable]) [TLToast showWithText:@"无网络连接" topOffset:200.0f duration:1.0];
    PicturesShowVC *picvc=[[PicturesShowVC alloc]init];
    picvc.data_array=_designerDetailModel.designerImagesPath
    ;
    picvc.type_pic=@"designer";
    picvc.pic_id=self.selected_picture;
    picvc.obj_effect = _myEffPicObj;
    [self.navigationController pushViewController:picvc animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"designer_tap" object:nil];
}

-(void)pressbtn:(UIButton *)btn{
    if (btn.tag==1001 && self.btn_shouc.selected==NO) {
        [savelogObj saveLog:@"收藏--设计师" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:11];
        
        [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_grb_s.png"] forState:UIControlStateNormal];
        self.btn_shouc.selected=YES;
        
        [SVProgressHUD showSuccessWithStatus:@"收藏成功" duration:1.0];
        
        [self requestCollect];
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:@"MydesignerCollect.plist"];
        NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename];
        if (!arr_) {
            arr_=[NSMutableArray arrayWithCapacity:0];
        }
        NSMutableDictionary *dict_=[[NSMutableDictionary alloc]initWithCapacity:0];
        
        if(_designerDetailModel.designerID)
            [dict_ setObject:[NSString stringWithFormat:@"%d",_designerDetailModel.designerID] forKey:@"designerID"];
        if(_designerDetailModel.designerName!=nil)
            [dict_ setObject:_designerDetailModel.designerName forKey:@"designerName"];
        if(_designerDetailModel.designerIconPath!=nil)
            [dict_ setObject:_designerDetailModel.designerIconPath forKey:@"designerIconPath"];
        if(_designerDetailModel.designerLevel)
            [dict_ setObject:[NSString stringWithFormat:@"%d",_designerDetailModel.designerLevel] forKey:@"designerLevel"];
        if(_designerDetailModel.designerDesc!=nil)
            [dict_ setObject:_designerDetailModel.designerDesc forKey:@"designerDesc"];
        if(_designerDetailModel.designerExperience!=nil)
            [dict_ setObject:_designerDetailModel.designerExperience forKey:@"designerExperience"];
        if(_designerDetailModel.designerAddress!=nil)
            [dict_ setObject:_designerDetailModel.designerAddress forKey:@"designerAddress"];
        if(_designerDetailModel.designerMobileNum!=nil)
            [dict_ setObject:_designerDetailModel.designerMobileNum forKey:@"designerMobileNum"];
        if(_designerDetailModel.designerPhoneNum!=nil)
            [dict_ setObject:_designerDetailModel.designerPhoneNum forKey:@"designerPhoneNum"];
        if(_designerDetailModel.designerWorks!=nil)
            [dict_ setObject:_designerDetailModel.designerWorks forKey:@"designerWorks"];
        if(_designerDetailModel.browsePoints)
            [dict_ setObject:[NSString stringWithFormat:@"%d",_designerDetailModel.browsePoints] forKey:@"designerBrowsePoints"];
        if(_designerDetailModel.collectPoints)
            [dict_ setObject:[NSString stringWithFormat:@"%d",_designerDetailModel.collectPoints] forKey:@"designerCollectPoints"];
        if([_designerDetailModel.designerIsAuthent count])
            [dict_ setObject:_designerDetailModel.designerIsAuthent forKey:@"arr_rztype"];
        if([_designerDetailModel.designerImagesPath count])
            [dict_ setObject:_designerDetailModel.designerImagesPath forKey:@"arr_picture"];
        if(_designerDetailModel.qualificationRating)
            [dict_ setObject:[NSNumber numberWithInteger:_designerDetailModel.qualificationRating ] forKey:@"qualificationRating"];
        if(_designerDetailModel.priceMin)
            [dict_ setObject:_designerDetailModel.priceMin forKey:@"priceMin"];
        if(_designerDetailModel.priceMax)
            [dict_ setObject:_designerDetailModel.priceMax forKey:@"priceMax"];
        if(_designerDetailModel.state)
            [dict_ setObject:[NSNumber numberWithInteger:_designerDetailModel.state ] forKey:@"state"];
        if(_designerDetailModel.appointmentNum)
            [dict_ setObject:_designerDetailModel.appointmentNum forKey:@"appointmentNum"];
        
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
        [self requestCheckSubcribeStatus:[NSString stringWithFormat:@"%i",_designerDetailModel.designerID]];
    }
    
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0039\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeID\":\"1\",\"objectID\":\"%d\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],_designerDetailModel.designerID];
        
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

-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0037\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeId\":\"1\",\"objectId\":\"%@\",\"currentPage\":\"1\",\"requestRow\":\"5\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],_obj.designerID];
        
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
                        if([arr_pl count]){
                            [self.dataArray_pl removeAllObjects];
                            for(NSDictionary *dict in arr_pl){
                                [self.dataArray_pl addObject:dict];
                            }
                        }
                        //                        //一个section刷新
                        //                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
                        //                        [mtableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                        
                        [_theTableView reloadData];
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0038\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeID\":\"1\",\"objectID\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],_obj.designerID];
        
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

-(void)createPhone{
    if(!self.btn_phone) {
        self.btn_phone = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_phone.frame=CGRectMake(kMainScreenWidth-50, kMainScreenHeight-250, 50, 50);
    }
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_yuyue.png"] forState:UIControlStateNormal];
    if (([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] == 7)) {
        [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_yuyue_pressed.png"] forState:UIControlStateNormal];
    }
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_yuyue_pressed.png"] forState:UIControlStateHighlighted];
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
        NSDictionary *bodyDic = @{@"businessID":designerIdStr,@"servantRoleId":@"1"};
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
                 NSLog(@"检查预约状态返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                    }
                    
                    if (kResCode == 101311) {
                        [self stopRequest];
                        SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
                        subscribeVC.businessIDStr = designerIdStr;
                        subscribeVC.servantRoleIdStr = @"1";
                        subscribeVC.fromStr=@"CollectionInfo";
                       // IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                        [self.navigationController pushViewController:subscribeVC animated:YES];
                        
                    }else if (kResCode == 101312) {
                        [self stopRequest];
                        _bookIdStr = [jsonDict objectForKey:@"bookId"];
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"亲，您已预约该设计师" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
                        alertView.delegate = self;
                        [alertView show];
                    }else if (kResCode == 101313) {
                        [self stopRequest];
                        [TLToast showWithText:@"该设计师业务繁忙..."];
                    }else{
                        [self stopRequest];
//                        [TLToast showWithText:@"检查预约状态失败"];
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
                NSLog(@"%@",[respString objectFromJSONString]);
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
                    
                    if (kResCode == 101071) {
                        [self stopRequest];
                        SubscribeListModel *model = [SubscribeListModel objectWithKeyValues:[jsonDict objectForKey:@"BookBean"]];
                        
                        MySubscribeDetailViewController *mySubscribeDetailVC = [[MySubscribeDetailViewController alloc]init];
                        mySubscribeDetailVC.fromStr=@"CollectionInfo";
                        SubscribeListModel *subcribeListModel = model;
                        //                        mySubscribeDetailVC.delegate = self;
                        mySubscribeDetailVC.subscribeListModel = subcribeListModel;
                        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                        [self.navigationController pushViewController:mySubscribeDetailVC animated:YES];
                        
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
//            subscribeVC.businessIDStr = [NSString stringWithFormat:@"%i",_designerDetailModel.designerID];
//            subscribeVC.servantRoleIdStr = @"1";
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
//        IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];//zl
//        [appDelegate.nav dismissViewControllerAnimated:YES completion:^{
//            SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
//            subscribeVC.businessIDStr = [NSString stringWithFormat:@"%i",_designerDetailModel.designerID];
//            subscribeVC.servantRoleIdStr = @"1";
//            IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate.nav pushViewController:subscribeVC animated:YES];
//        }];
        __weak typeof(self) weakself = self;
        [weakself.navigationController dismissViewControllerAnimated:YES completion:^{
            SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
            subscribeVC.businessIDStr = [NSString stringWithFormat:@"%i",_designerDetailModel.designerID];
            subscribeVC.servantRoleIdStr = @"1";
            [weakself.navigationController pushViewController:subscribeVC animated:YES];
        }];
    }
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    [self requestDesignerDetail];
    [self requestCommentsList];
    [self requestBrower];
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
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
#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_theTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_theTableView tableViewDidEndDragging:scrollView];
}



@end
