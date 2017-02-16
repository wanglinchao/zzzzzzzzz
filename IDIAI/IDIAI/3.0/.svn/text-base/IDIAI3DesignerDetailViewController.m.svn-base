//
//  IDIAI3DesignerDetailViewController.m
//  IDIAI
//
//  Created by Ricky on 15/10/16.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3DesignerDetailViewController.h"
#import "DesignerDetailModel.h"
#import "MyeffectPictureObj.h"
#import "UIImageView+WebCache.h"
#import "EffectTAOTUPictureInfoForDesigner.h"
#import "IDIAIAppDelegate.h"
#import "PicturesShowVC.h"
#import "util.h"
#import "TLToast.h"
#import "MoreCommentsViewController.h"
#import "savelogObj.h"
#import "SVProgressHUD.h"
#import "LoginView.h"
#import "SubscribePeopleViewController.h"
#import "SubscribeListModel.h"
#import "MySubscribeDetailViewController.h"
#import "EffectTAOTUPictureInfo.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "UIImageView+WebCache.h"
@interface IDIAI3DesignerDetailViewController ()<LoginViewDelegate>{
    DesignerDetailModel *_designerDetailModel;
    NSMutableArray *_taotuMutArr;
    MyeffectPictureObj *_myEffPicObj;
     UIView *_bgView2;
    NSString *_bookIdStr;
}
@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UIView *introductionView;
@property(nonatomic,strong)UIView *honorview;
@property(nonatomic,assign)BOOL isIntorductionOpen;
@property(nonatomic,assign)BOOL ishonorOpen;
@property(nonatomic,strong)UIView *styleView;
@property(nonatomic,strong)UIView *styleContentView;
@property(nonatomic,strong)UIImageView *styleline;
@property(nonatomic,strong)UIButton *worksbtn;
@property(nonatomic,strong)UIButton *commentsbtn;
@property(nonatomic,strong)NSMutableArray *dataArray_pl;
@property(nonatomic,assign)BOOL isWork;
@property(nonatomic,assign)double level;
@property(nonatomic,assign)double professionalLevel;
@property(nonatomic,assign)double customerServiceLevel;
@property(nonatomic,assign)double popularityLevel;
@property(nonatomic,strong) UILabel *intorduction;
@end

@implementation IDIAI3DesignerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _taotuMutArr =[NSMutableArray array];
    self.isWork =YES;
    self.view.backgroundColor =[UIColor whiteColor];
    [self customizeNavigationBar];
    self.table =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
    self.table.delegate =self;
    self.table.dataSource =self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    self.dataArray_pl =[NSMutableArray array];
    [self requestDesignerDetail];
    [self requestBrower];
    [self requestCommentsList];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapPicture:) name:@"designer_tap" object:nil];
    // Do any additional setup after loading the view.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"designer_tap" object:nil];
}
-(void)creaintroductionView{
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    CGSize size = CGSizeMake(kMainScreenWidth-60,2000);
    CGSize labelsize = [_designerDetailModel.designerDesc sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    self.introductionView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth-60, labelsize.height+4)];
    _intorduction =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelsize.width, labelsize.height)];
    [_intorduction setNumberOfLines:0];
    _intorduction.lineBreakMode = UILineBreakModeWordWrap;
    _intorduction.font =font;
    _intorduction.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    _intorduction.text =_designerDetailModel.designerDesc;
    [self.introductionView addSubview:_intorduction];
    
    UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(0, self.introductionView.frame.size.height-1, self.introductionView.frame.size.width, 1)];
    line.backgroundColor =kColorWithRGB(249, 249, 249);
    [self.introductionView addSubview:line];
}
-(void)creahonorView{
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    CGSize size = CGSizeMake(kMainScreenWidth-60,2000);
    CGSize labelsize = [_designerDetailModel.personalHonor sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.honorview =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth-60, labelsize.height+4)];
    UILabel *honor =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelsize.width, labelsize.height)];
    [honor setNumberOfLines:0];
    honor.lineBreakMode = NSLineBreakByWordWrapping;
    honor.font =font;
    honor.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    honor.text =_designerDetailModel.personalHonor;
    [self.honorview addSubview:honor];
}
-(void)creastyleView{
    if (self.styleView==nil) {
        self.styleView =[[UIView alloc] initWithFrame:CGRectMake(30, 0, kMainScreenWidth-60, 126)];
        for (int i=0; i<3; i++) {
            UIButton *typebtn =[UIButton buttonWithType:UIButtonTypeCustom];
            typebtn.frame =CGRectMake(14+(56+(kMainScreenWidth-60-28-56*3)/2)*i, 15, 56, 14);
            NSString *typestr =[NSString string];
            typebtn.tag =1000+i;
            if (i==0) {
                typestr =@"擅长风格";
                typebtn.selected =YES;
            }else if (i==1){
                typestr =@"擅长空间";
            }else if (i==2){
                typestr =@"特色服务";
            }
            [typebtn setTitle:typestr forState:UIControlStateNormal];
            [typebtn setTitle:typestr forState:UIControlStateHighlighted];
            [typebtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:UIControlStateNormal];
            [typebtn setTitleColor:[UIColor colorWithHexString:@"#fd3e40"] forState:UIControlStateSelected];
            typebtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
            [typebtn addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.styleView addSubview:typebtn];
        }
        self.styleContentView =[[UIView alloc] initWithFrame:CGRectMake(0, 44, self.styleView.frame.size.width, self.styleView.frame.size.height-44)];
        [self.styleView addSubview:self.styleContentView];
#warning 需要填写风格和空间等东西
        int countx =0;
        int county =0;
        int height =44;
        NSArray *dataArray =[_designerDetailModel.specialtys componentsSeparatedByString:@","];
        for (int i =0; i<dataArray.count; i++) {
            UILabel *stylelbl =[[UILabel alloc] initWithFrame:CGRectMake(14+(52+(kMainScreenWidth-60-28-52*4)/3)*countx, 26*county, 52, 13)];
            stylelbl.text =[dataArray objectAtIndex:i];
            stylelbl.font =[UIFont systemFontOfSize:13];
            stylelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            [self.styleContentView addSubview:stylelbl];
            countx++;
            if (countx!=0&&countx%4==0) {
                countx=0;
                county++;
                height =44+26*county;
            }else{
                height =44+26*(county+1);
            }
        }
        self.styleline =[[UIImageView alloc] initWithFrame:CGRectMake(14, 33, 56, 2)];
        self.styleline.backgroundColor =[UIColor colorWithHexString:@"#fd3e40"];
        [self.styleView addSubview:self.styleline];
        
        self.styleView.frame =CGRectMake(self.styleView.frame.origin.x, self.styleView.frame.origin.y, self.styleView.frame.size.width, height);
        
        UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(0, self.styleView.frame.size.height-1, kMainScreenWidth-54, 1)];
        footline.tag =10000;
        footline.backgroundColor =[UIColor colorWithHexString:@"#f6f6f6"];
        [self.styleView addSubview:footline];
    }
    
}
-(void)typeAction:(UIButton *)sender{
    sender.selected =!sender.selected;
    int height =44;
    if (self.styleContentView) {
        [self.styleContentView removeFromSuperview];
        self.styleContentView =nil;
        self.styleContentView =[[UIView alloc] initWithFrame:CGRectMake(0, 44, self.styleView.frame.size.width, self.styleView.frame.size.height-44)];
        [self.styleView addSubview:self.styleContentView];
        NSString *stylecontent =[NSString string];
        NSMutableArray *dataArray =[NSMutableArray array];
        if (sender.tag-1000 ==0) {
            [dataArray addObjectsFromArray:[_designerDetailModel.specialtys componentsSeparatedByString:@","]];
        }else if(sender.tag -1000 ==1){
            [dataArray addObjectsFromArray:[_designerDetailModel.spaces componentsSeparatedByString:@","]];
        }else{
            [dataArray addObjectsFromArray:_designerDetailModel.specialtyFeatures];
        }
        int countx =0;
        int county =0;
        if (sender.tag-1000!=2) {
            for (int i =0; i<dataArray.count; i++) {
                NSLog(@"%f",(kMainScreenWidth-60-28-52*3)/2);
                UILabel *stylelbl =[[UILabel alloc] initWithFrame:CGRectMake(14+(52+(kMainScreenWidth-60-28-52*4)/3)*countx, 26*county, 52, 13)];
                stylelbl.text =[dataArray objectAtIndex:i];
                stylelbl.font =[UIFont systemFontOfSize:13];
                stylelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                [self.styleContentView addSubview:stylelbl];
                countx++;
                if (countx!=0&&countx%4==0) {
                    countx=0;
                    county++;
                    height =44+26*county;
                }else{
                    height =44+26*(county+1);
                }
                
            }
        }else{
            for (int i=0; i<3; i++) {
                UIView *styleserver =[[UIView alloc] initWithFrame:CGRectMake((75+(kMainScreenWidth-60-75*3)/2)*countx, 26*county, 75, 17)];
                styleserver.backgroundColor =[UIColor clearColor];
                [self.styleContentView addSubview:styleserver];
                UIImageView *headimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
                [styleserver addSubview:headimage];
                UILabel *stylelbl =[[UILabel alloc] initWithFrame:CGRectMake(headimage.frame.origin.x+headimage.frame.size.width+2, 3, 52, 13)];
                if (i==0) {
                    stylecontent =@"软装搭配";
                    headimage.image =[UIImage imageNamed:@"ic_tiesefuwu_36.png"];
                }else if (i==1){
                    stylecontent =@"材料陪购";
                    headimage.image =[UIImage imageNamed:@"ic_tiesefuwu_39.png"];
                }else{
                    stylecontent =@"全程跟踪";
                    headimage.image =[UIImage imageNamed:@"ic_tiesefuwu_53.png"];
                }
                stylelbl.text =stylecontent;
                stylelbl.font =[UIFont systemFontOfSize:13];
                stylelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                [styleserver addSubview:stylelbl];
                UIImageView *selectImage =[[UIImageView alloc] initWithFrame:CGRectMake(stylelbl.frame.origin.x+stylelbl.frame.size.width+2, 4.5, 10, 8)];
                selectImage.image =[UIImage imageNamed:@"ic_gougou.png"];
                selectImage.hidden =YES;
//                [styleserver addSubview:selectImage];
                countx++;
                if (countx!=0&&countx%3==0) {
                    countx=0;
                    county++;
                    height =44+26*county;
                }else{
                    height =44+26*(county+1);
                }
                
                for (NSDictionary *dic in dataArray) {
                    if ([[dic objectForKeyedSubscript:@"FEATURESID"] integerValue]==24&&i==0) {
                        stylelbl.textColor =[UIColor colorWithHexString:@"#fd3e40"];
                        headimage.image =[UIImage imageNamed:@"ic_tiesefuwu_05.png"];
                        selectImage.hidden =NO;
                    }else if ([[dic objectForKeyedSubscript:@"FEATURESID"] integerValue]==25&&i==1){
                        stylelbl.textColor =[UIColor colorWithHexString:@"#fd3e40"];
                        headimage.image =[UIImage imageNamed:@"ic_tiesefuwu_11.png"];
                        selectImage.hidden =NO;
                    }else if ([[dic objectForKeyedSubscript:@"FEATURESID"] integerValue]==26&&i==2){
                        stylelbl.textColor =[UIColor colorWithHexString:@"#fd3e40"];
                        headimage.image =[UIImage imageNamed:@"ic_tiesefuwu_27.png"];
                        selectImage.hidden =NO;
                    }
                }
            }
        }
        

        
    }
    self.styleline.frame =CGRectMake(14+(56+(kMainScreenWidth-60-28-56*3)/2)*(sender.tag-1000), 33, 56, 2);
    self.styleView.frame =CGRectMake(self.styleView.frame.origin.x, self.styleView.frame.origin.y, self.styleView.frame.size.width, height);
//    self.styleView.backgroundColor =[UIColor orangeColor];
    UIImageView *footline =(UIImageView *)[self.styleView viewWithTag:10000];
    footline.frame =CGRectMake(0, self.styleView.frame.size.height-1, kMainScreenWidth-54, 1);
    for (int i=0; i<3; i++) {
        UIButton *typebtn =(UIButton *)[self.styleView viewWithTag:1000+i];
        if (i!=sender.tag-1000) {
            typebtn.selected =NO;
        }
    }
    [self.table reloadData];
}  
-(UIView *)settableHeadView{
    UIView *headView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 233)];
    headView.backgroundColor =[UIColor clearColor];
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth-67)/2, 20, 67, 67)];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 33;
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:_designerDetailModel.designerIconPath] placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
    [headView addSubview:self.headImage];
    
    for (int i =0; i<2; i++) {
        UIImageView *appellationimage =[[UIImageView alloc] init];
        appellationimage.frame =CGRectMake(self.headImage.frame.origin.x+58+i*5, self.headImage.frame.origin.y+8+16*i, 29, 13);
        if (i==0) {
            if (_designerDetailModel.designerIsAuthent.count>0) {
                if ([[[_designerDetailModel.designerIsAuthent objectAtIndex:0] objectForKey:@"authzId"] integerValue]==1) {
                    appellationimage.image =[UIImage imageNamed:@"ic_shiming_n.png"];
                }
            }else{
                appellationimage.hidden =YES;
            }
        }else{
            if (_designerDetailModel.qualificationRating>0) {
                if (_designerDetailModel.qualificationRating==1) {
                    appellationimage.image =[UIImage imageNamed:@"ic_xinrui_n.png"];
                }else if (_designerDetailModel.qualificationRating==2){
                    appellationimage.image =[UIImage imageNamed:@"ic_youxiu_n.png"];
                }else if (_designerDetailModel.qualificationRating==3){
                    appellationimage.image =[UIImage imageNamed:@"ic_jingying_n.png"];
                }
            }else{
                appellationimage.hidden =YES;
            }
        }
        
//            if (i ==0) {
//                appellationimage.image =[UIImage imageNamed:@"ic_xinrui_n.png"];
//            }else{
//                appellationimage.image =[UIImage imageNamed:@"ic_shiming_n.png"];
//            }
        [headView addSubview:appellationimage];
    }
    
    UILabel *namelbl =[[UILabel alloc] initWithFrame:CGRectMake(0, self.headImage.frame.origin.y+self.headImage.frame.size.height+14, kMainScreenWidth, 16)];
    namelbl.text =_designerDetailModel.designerName;
    namelbl.textAlignment =NSTextAlignmentCenter;
    namelbl.font =[UIFont systemFontOfSize:16];
    namelbl.textColor =[UIColor blackColor];
    [headView addSubview:namelbl];
    
    UILabel *experiencelbl =[[UILabel alloc] initWithFrame:CGRectMake(0, namelbl.frame.origin.y+namelbl.frame.size.height+8, kMainScreenWidth, 14)];
    experiencelbl.text =[NSString stringWithFormat:@"经验:%@",_designerDetailModel.designerExperience];
    experiencelbl.textAlignment =NSTextAlignmentCenter;
    experiencelbl.font =[UIFont systemFontOfSize:14];
    experiencelbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [headView addSubview:experiencelbl];
    
    UILabel *offerlbl =[[UILabel alloc] initWithFrame:CGRectMake(0, experiencelbl.frame.origin.y+experiencelbl.frame.size.height+8, kMainScreenWidth, 14)];
    offerlbl.text =[NSString stringWithFormat:@"报价:%@-%@元/㎡",_designerDetailModel.priceMin,_designerDetailModel.priceMax];
    offerlbl.textAlignment =NSTextAlignmentCenter;
    offerlbl.font =[UIFont systemFontOfSize:14];
    offerlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    [headView addSubview:offerlbl];
    
    UILabel *yuyue_lab=[[UILabel alloc]initWithFrame:CGRectMake(18, offerlbl.frame.origin.y+offerlbl.frame.size.height+22, 80, 13)];
    yuyue_lab.backgroundColor=[UIColor clearColor];
    yuyue_lab.textAlignment=NSTextAlignmentLeft;
    yuyue_lab.font=[UIFont systemFontOfSize:13];
    yuyue_lab.textColor=[UIColor lightGrayColor];
    int length =0;
    if([_designerDetailModel.appointmentNum integerValue]>=100000000) {yuyue_lab.text=[NSString stringWithFormat:@"%.1f亿",[_designerDetailModel.appointmentNum floatValue]/100000000.0];
        length =(int)yuyue_lab.text.length -1;
    }
    else if([_designerDetailModel.appointmentNum integerValue]>=10000){ yuyue_lab.text=[NSString stringWithFormat:@"%.1f万",[_designerDetailModel.appointmentNum floatValue]/10000.0];
        length =(int)yuyue_lab.text.length -1;
    }
    else {yuyue_lab.text=[NSString stringWithFormat:@"%@",_designerDetailModel.appointmentNum];
        length =(int)yuyue_lab.text.length;
    }
    yuyue_lab.frame =CGRectMake((kMainScreenWidth/3-length*13)/2, offerlbl.frame.origin.y+offerlbl.frame.size.height+22,length*13, 13);
    //        yuyue_lab.backgroundColor =[UIColor redColor];
    yuyue_lab.textAlignment =NSTextAlignmentCenter;
    [headView addSubview:yuyue_lab];
    
    UILabel *yuyue_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(yuyue_lab.frame.origin.x, yuyue_lab.frame.origin.y+yuyue_lab.frame.size.height+9, MAX(length*13, 36), 11)];
    if (length*13<36) {
        yuyue_foot_lab.frame =CGRectMake(yuyue_lab.frame.origin.x+yuyue_lab.frame.size.width/2-36/2, yuyue_foot_lab.frame.origin.y, yuyue_foot_lab.frame.size.width, yuyue_foot_lab.frame.size.height);
    }
    yuyue_foot_lab.textAlignment =NSTextAlignmentCenter;
    yuyue_foot_lab.text =@"预约数";
    yuyue_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
    yuyue_foot_lab.font =[UIFont systemFontOfSize:12];
    //        yuyue_foot_lab.backgroundColor =[UIColor purpleColor];
    [headView addSubview:yuyue_foot_lab];
    
    UILabel *lab_brower =[[UILabel alloc] init];
    lab_brower.frame =CGRectMake(yuyue_lab.frame.origin.x+yuyue_lab.frame.size.width-length/2*13+100+(5-length)*13, yuyue_lab.frame.origin.y, 0, 13);
    lab_brower.backgroundColor=[UIColor clearColor];
    lab_brower.textAlignment=NSTextAlignmentCenter;
    lab_brower.font=[UIFont systemFontOfSize:13];
    lab_brower.textColor=[UIColor lightGrayColor];
    length =0;
    
    if(_designerDetailModel.successOrderPoint>=100000000){
        lab_brower.text=[NSString stringWithFormat:@"%0.1ld亿",_designerDetailModel.successOrderPoint/100000000];
        length =(int)lab_brower.text.length-1;
    }
    else if(_designerDetailModel.successOrderPoint>=10000){ lab_brower.text=[NSString stringWithFormat:@"%0.1ld万",_designerDetailModel.successOrderPoint/10000];
        length =(int)lab_brower.text.length-1;
    }
    else{ lab_brower.text=[NSString stringWithFormat:@"%d",(int)_designerDetailModel.successOrderPoint];
        length =(int)lab_brower.text.length;;
    }
    
    lab_brower.frame =CGRectMake(kMainScreenWidth/3*1+(kMainScreenWidth/3-length*13)/2, yuyue_lab.frame.origin.y, length*13, 13);
    [headView addSubview:lab_brower];
    
    UILabel *brower_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(lab_brower.frame.origin.x, lab_brower.frame.origin.y+lab_brower.frame.size.height+9, MAX(length*13, 36), 11)];
    if (length*13<36) {
        brower_foot_lab.frame =CGRectMake(lab_brower.frame.origin.x+lab_brower.frame.size.width/2-36/2, brower_foot_lab.frame.origin.y, brower_foot_lab.frame.size.width, brower_foot_lab.frame.size.height);
    }
    brower_foot_lab.textAlignment =NSTextAlignmentCenter;
    brower_foot_lab.text =@"成单数";
    brower_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
    brower_foot_lab.font =[UIFont systemFontOfSize:12];
    //        brower_foot_lab.backgroundColor =[UIColor purpleColor];
    [headView addSubview:brower_foot_lab];
    UILabel *lab_collect =[[UILabel alloc] init];
    lab_collect.frame =CGRectMake((lab_brower.frame.origin.x+lab_brower.frame.size.width-length/2*13+80+(5-length)*13)*kMainScreenWidth/375, lab_brower.frame.origin.y, 0, 13);
    lab_collect.backgroundColor=[UIColor clearColor];
    lab_collect.textAlignment=NSTextAlignmentCenter;
    lab_collect.font=[UIFont systemFontOfSize:13];
    lab_collect.textColor=[UIColor lightGrayColor];
    length =0;

    if(_designerDetailModel.collectPoints>=100000000) {lab_collect.text=[NSString stringWithFormat:@"%0.1ld亿",_designerDetailModel.collectPoints/100000000];
        length =(int)lab_collect.text.length-1;
    }
    else if(_designerDetailModel.collectPoints>=10000) {lab_collect.text=[NSString stringWithFormat:@"%0.1ld万",_designerDetailModel.collectPoints/10000];
        length =(int)lab_collect.text.length-1;
    }
    else{ lab_collect.text=[NSString stringWithFormat:@"%d",(int)_designerDetailModel.collectPoints];
        length =(int)lab_collect.text.length;
    };
    lab_collect.frame =CGRectMake(kMainScreenWidth/3*2+(kMainScreenWidth/3-length*13)/2, lab_brower.frame.origin.y, length*13, 13);
    [headView addSubview:lab_collect];
    UILabel *collect_foot_lab =[[UILabel alloc] initWithFrame:CGRectMake(lab_collect.frame.origin.x, lab_collect.frame.origin.y+lab_collect.frame.size.height+9, MAX(length*13, 36), 11)];
    if (length*13<36) {
        collect_foot_lab.frame =CGRectMake(lab_collect.frame.origin.x+lab_collect.frame.size.width/2-36/2, collect_foot_lab.frame.origin.y, collect_foot_lab.frame.size.width, collect_foot_lab.frame.size.height);
    }
    collect_foot_lab.textAlignment =NSTextAlignmentCenter;
    collect_foot_lab.text =@"收藏数";
    collect_foot_lab.textColor =[UIColor colorWithHexString:@"#898989"];
    collect_foot_lab.font =[UIFont systemFontOfSize:12];
    //        collect_foot_lab.backgroundColor =[UIColor purpleColor];
    [headView addSubview:collect_foot_lab];
    
    for (int i=1; i<3; i++) {
        UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth/3*i, offerlbl.frame.origin.y+offerlbl.frame.size.height+22, 1, 30)];
        line.backgroundColor =[UIColor colorWithHexString:@"#f6f6f6"];
        [headView addSubview:line];
    }
    UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(27, headView.frame.size.height-1, kMainScreenWidth-54, 1)];
    footline.backgroundColor =[UIColor colorWithHexString:@"#f6f6f6"];
    [headView addSubview:footline];
    return headView;
}
-(void)customizeNavigationBar{
    UIView *navView =[[UIView alloc] initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 44)];
    navView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton *backbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame =CGRectMake(0, 0, 44, 44);
    [backbtn setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backbtn];
    
    UILabel *title =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    title.textColor =[UIColor blackColor];
    title.font =[UIFont systemFontOfSize:16];
    title.textAlignment =NSTextAlignmentCenter;
    title.text =@"设计师详情";
    [navView addSubview:title];
    
//    NSArray *path_ = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* doc_path_ = [path_ objectAtIndex:0];
//    NSString* _filename_ = [doc_path_ stringByAppendingPathComponent:@"MydesignerCollect.plist"];
//    NSMutableArray *Arr_=[NSMutableArray arrayWithContentsOfFile:_filename_];
//    if (!Arr_) {
//        Arr_=[NSMutableArray arrayWithCapacity:0];
//    }
    self.btn_shouc = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_shouc.frame=CGRectMake(kMainScreenWidth-40, 10, 25, 25);
//    if([Arr_ count]){
//        for(NSDictionary *dict in Arr_){
            if(_designerDetailModel.objId==_designerDetailModel.designerID){
                [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_2.png"] forState:UIControlStateNormal];
                self.btn_shouc.selected=YES;
//                break;
            }
            else{
                [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_nor_2.png"] forState:UIControlStateNormal];
                self.btn_shouc.selected=NO;
            }
//        }
//    }
//    else{
//        [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_nor_2.png"] forState:UIControlStateNormal];
//        self.btn_shouc.selected=NO;
//    }
    
    [self.btn_shouc addTarget:self action:@selector(pressbtn:) forControlEvents:UIControlEventTouchUpInside];
//    self.btn_shouc.backgroundColor =[UIColor redColor];
//    UIButton *btn_shouc =(UIButton *)[navView viewWithTag:100001];
//    if (!btn_shouc) {
        [navView addSubview:self.btn_shouc];
//    }
    self.btn_shouc.tag=1001;
    
}
-(void)pressbtn:(UIButton *)sender{
    if (sender.tag==1001) {
        if(self.btn_shouc.selected==NO){
            [savelogObj saveLog:@"收藏--设计师" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:11];
            
//            [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_2.png"] forState:UIControlStateNormal];
//            self.btn_shouc.selected=YES;
            
//            [SVProgressHUD showSuccessWithStatus:@"收藏成功" duration:1.0];
            [self collectionAction:self.btn_shouc];
            
//            
//            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString* doc_path = [path objectAtIndex:0];
//            NSString* _filename = [doc_path stringByAppendingPathComponent:@"MydesignerCollect.plist"];
//            NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename];
//            if (!arr_) {
//                arr_=[NSMutableArray arrayWithCapacity:0];
//            }
//            NSMutableDictionary *dict_=[[NSMutableDictionary alloc]initWithCapacity:0];
//            
//            if(_designerDetailModel.designerID)
//                [dict_ setObject:[NSString stringWithFormat:@"%ld",(long)_designerDetailModel.designerID] forKey:@"designerID"];
//            if(_designerDetailModel.designerName!=nil)
//                [dict_ setObject:_designerDetailModel.designerName forKey:@"designerName"];
//            if(_designerDetailModel.designerIconPath!=nil)
//                [dict_ setObject:_designerDetailModel.designerIconPath forKey:@"designerIconPath"];
//            if(_designerDetailModel.designerLevel)
//                [dict_ setObject:[NSString stringWithFormat:@"%ld",(long)_designerDetailModel.designerLevel] forKey:@"designerLevel"];
//            if(_designerDetailModel.designerDesc!=nil)
//                [dict_ setObject:_designerDetailModel.designerDesc forKey:@"designerDesc"];
//            if(_designerDetailModel.designerExperience!=nil)
//                [dict_ setObject:_designerDetailModel.designerExperience forKey:@"designerExperience"];
//            if(_designerDetailModel.designerAddress!=nil)
//                [dict_ setObject:_designerDetailModel.designerAddress forKey:@"designerAddress"];
//            if(_designerDetailModel.designerMobileNum!=nil)
//                [dict_ setObject:_designerDetailModel.designerMobileNum forKey:@"designerMobileNum"];
//            if(_designerDetailModel.designerPhoneNum!=nil)
//                [dict_ setObject:_designerDetailModel.designerPhoneNum forKey:@"designerPhoneNum"];
//            if(_designerDetailModel.designerWorks!=nil)
//                [dict_ setObject:_designerDetailModel.designerWorks forKey:@"designerWorks"];
//            if(_designerDetailModel.browsePoints)
//                [dict_ setObject:[NSString stringWithFormat:@"%ld",(long)_designerDetailModel.browsePoints] forKey:@"designerBrowsePoints"];
//            if(_designerDetailModel.collectPoints)
//                [dict_ setObject:[NSString stringWithFormat:@"%ld",(long)_designerDetailModel.collectPoints] forKey:@"designerCollectPoints"];
//            if([_designerDetailModel.designerIsAuthent count])
//                [dict_ setObject:_designerDetailModel.designerIsAuthent forKey:@"arr_rztype"];
//            if([_designerDetailModel.designerImagesPath count])
//                [dict_ setObject:_designerDetailModel.designerImagesPath forKey:@"arr_picture"];
//            if(_designerDetailModel.appointmentNum)
//            {
//                [dict_ setObject:_designerDetailModel.appointmentNum forKey:@"appointmentNum"];
//            }else{
//                [dict_ setObject:@"0" forKey:@"appointmentNum"];
//            }
//            if(_designerDetailModel.priceMin)
//                [dict_ setObject:_designerDetailModel.priceMin forKey:@"priceMin"];
//            if(_designerDetailModel.priceMax)
//                [dict_ setObject:_designerDetailModel.priceMax forKey:@"priceMax"];
//            if(_designerDetailModel.qualificationRating)
//                [dict_ setObject:[NSNumber numberWithInteger:_designerDetailModel.qualificationRating] forKey:@"qualificationRating"];
//            if(_designerDetailModel.state)
//                [dict_ setObject:[NSNumber numberWithInteger:_designerDetailModel.state] forKey:@"state"];
//            [arr_ addObject:dict_];
//            [arr_ writeToFile:_filename atomically:NO];
        }
        else{
//            [SVProgressHUD showSuccessWithStatus:@"取消收藏成功" duration:1.0];
//            
//            [self.btn_shouc setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_nor_2.png"] forState:UIControlStateNormal];
//            self.btn_shouc.selected=NO;
//            
//            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString* doc_path = [path objectAtIndex:0];
//            NSString* _filename = [doc_path stringByAppendingPathComponent:@"MydesignerCollect.plist"];
//            NSMutableArray *arr_=[NSMutableArray arrayWithContentsOfFile:_filename];
//            if (!arr_) {
//                arr_=[NSMutableArray arrayWithCapacity:0];
//            }
//            
//            for(NSDictionary *dict in arr_){
//                if([[dict objectForKey:@"designerID"] integerValue]==_designerDetailModel.designerID){
//                    [arr_ removeObject:dict];
//                    break;
//                }
//                else
//                    continue;
//            }
//            [arr_ writeToFile:_filename atomically:NO];
            [self collectionAction:self.btn_shouc];
        }
    }
    
    else if(sender.tag==1003){
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
-(void)collectionAction:(UIButton *)iscollect{
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
        
        NSDictionary *bodyDic = @{@"objId":[NSNumber numberWithInteger:_designerDetailModel.designerID ],@"isCollection":[NSNumber numberWithInt:!iscollect.selected],@"objType":[NSNumber numberWithInt:4]};
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
                            [iscollect setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_2"] forState:UIControlStateNormal];
                            iscollect.selected =YES;
                            [self requestCollect];
                            
                        }else{
                            [TLToast showWithText:@"取消收藏成功"];
                            [iscollect setBackgroundImage:[UIImage imageNamed:@"ic_shoucang_nor_2"] forState:UIControlStateNormal];
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
        
        NSString *designerID_Str;
        if(self.obj.designerID) designerID_Str=self.obj.designerID;
        else designerID_Str=[NSString stringWithFormat:@"%ld",(long)self.designerID];
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0038\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeID\":\"1\",\"objectID\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],designerID_Str];
        
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
        
        NSString *designerID_Str;
        if(self.obj.designerID) designerID_Str=self.obj.designerID;
        else designerID_Str=[NSString stringWithFormat:@"%ld",(long)self.designerID];
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0039\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeID\":\"1\",\"objectID\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],designerID_Str];
        
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
                        return;
                    }
                    
                    if (kResCode == 101311) {
                        [self stopRequest];
                        SubscribePeopleViewController *subscribeVC = [[SubscribePeopleViewController alloc] init];
                        subscribeVC.businessIDStr = designerIdStr;
                        subscribeVC.servantRoleIdStr = @"1";
                        if(self.fromwhere.length==0) self.fromwhere=@"CollectionInfo";
                        subscribeVC.fromStr=self.fromwhere;
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
-(void)backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)numberStartReLoad:(NSInteger)number imageViewArray:(NSMutableArray *)imageViewArray {

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
            if (imageViewArray.count) {
                UIImageView *imageView = [imageViewArray objectAtIndex:i];
                [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_xing_%@",[starArray objectAtIndex:i]]]];
            } else {
                return;
            }
        }
    }
}
//-(void)collectionAction:(UIButton *)sender{
//    sender.selected =!sender.selected;
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestDesignerDetail];
    [self requestBrower];
    [self requestCommentsList];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)workAction:(UIButton *)sender{
    sender.selected =YES;
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 17;
    sender.layer.borderColor =[UIColor colorWithHexString:@"#fd3e40"].CGColor;
    sender.layer.borderWidth = 1;
    
    self.commentsbtn.selected =NO;
    self.commentsbtn.layer.masksToBounds = YES;
    self.commentsbtn.layer.cornerRadius = 17;
    self.commentsbtn.layer.borderColor =[UIColor clearColor].CGColor;
    self.commentsbtn.layer.borderWidth = 1;
    self.isWork =YES;
    [self.table reloadData];
}
-(void)commentAction:(UIButton *)sender{
    sender.selected =YES;
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 17;
    sender.layer.borderColor =[UIColor colorWithHexString:@"#fd3e40"].CGColor;
    sender.layer.borderWidth = 1;
    
    self.worksbtn.selected =NO;
    self.worksbtn.layer.masksToBounds = YES;
    self.worksbtn.layer.cornerRadius = 17;
    self.worksbtn.layer.borderColor =[UIColor clearColor].CGColor;
    self.worksbtn.layer.borderWidth = 1;
    self.isWork =NO;
    [self.table reloadData];
}
#define UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        return self.styleView.frame.size.height;
    }
    if (indexPath.row ==1) {
        float height =0;
        if (self.isIntorductionOpen ==YES) {
            height+=43+self.introductionView.frame.size.height+10;
        }else{
            height +=43;
        }
        if (self.ishonorOpen ==YES) {
            height+=43+self.honorview.frame.size.height+10;
        }else{
            if (self.isIntorductionOpen ==YES&&self.ishonorOpen ==NO) {
                height+=53+10;
                return height;
            }
            height+=43;
        }
        
        return height;
    }
    if (indexPath.row==2) {
        if (self.isWork ==YES) {
            float designerImageHeight =0;
            if (_designerDetailModel.designerImagesPath.count>0) {
                designerImageHeight =100;
            }
            return _bgView2.frame.size.height-designerImageHeight>30?_bgView2.frame.size.height-designerImageHeight : 0;
        }else{
            return _bgView2.frame.size.height>30?_bgView2.frame.size.height : 0;
        }
        
    }
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier1 = @"designerDetailCell1";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (!cell1) {
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
    }
    if (indexPath.row ==0) {
        if (self.styleView) {
            [cell1 addSubview:self.styleView];
        }
    }
    if (indexPath.row ==1) {
        if (myCollapseClick) {
            [myCollapseClick removeFromSuperview];
            myCollapseClick=nil;
            myCollapseClick.scrollEnabled =NO;
            myCollapseClick =[[CollapseClick alloc] initWithFrame:CGRectMake(30, 0, kMainScreenWidth-60, 86+self.introductionView.frame.size.height+self.honorview.frame.size.height+10)];
            myCollapseClick.CollapseClickDelegate = self;
            myCollapseClick.scrollEnabled =NO;
            [myCollapseClick reloadCollapseClick];
            if (self.isIntorductionOpen ==YES) {
                _intorduction.text=_designerDetailModel.designerDesc;
                [myCollapseClick openCollapseClickCellAtIndex:0 animated:NO];
            }
            if (self.ishonorOpen ==YES) {
               _intorduction.text=nil;
                [myCollapseClick openCollapseClickCellAtIndex:1 animated:NO];
            }
            [cell1 addSubview:myCollapseClick];
        }else{
            myCollapseClick =[[CollapseClick alloc] initWithFrame:CGRectMake(30, 0, kMainScreenWidth-60, 86+self.introductionView.frame.size.height+self.honorview.frame.size.height+10)];
            myCollapseClick.scrollEnabled =NO;
            myCollapseClick.CollapseClickDelegate = self;
            [myCollapseClick reloadCollapseClick];
            if (self.isIntorductionOpen ==YES) {
                _intorduction.text=_designerDetailModel.designerDesc;
                [myCollapseClick openCollapseClickCellAtIndex:0 animated:YES];
            }
            if (self.ishonorOpen ==YES) {
                 _intorduction.text=nil;
                [myCollapseClick openCollapseClickCellAtIndex:1 animated:YES];
            }
        }
        cell1.clipsToBounds =YES;
    }
    if (indexPath.row ==2) {
        NSInteger height;
        if (_bgView2) {
            [_bgView2 removeFromSuperview];
            _bgView2 =nil;
        }
        _bgView2 =[[UIView alloc] init];
        if (_designerDetailModel.designerImagesPath.count) {
            height =10+ cell1.frame.size.width/4*3+10+ cell1.frame.size.width/4*3 * _designerDetailModel.designerCollectivePics.count + _designerDetailModel.designerCollectivePics.count * 10;
            
        } else {
            height = 10+cell1.frame.size.width/4*3 * _designerDetailModel.designerCollectivePics.count + _designerDetailModel.designerCollectivePics.count * 10;
        }
        UIView *headView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 101)];
        
        UIImageView *headimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 8)];
        headimage.backgroundColor =[UIColor colorWithHexString:@"#f0efef"];
        [headView addSubview:headimage];
        self.worksbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.worksbtn.frame =CGRectMake(kMainScreenWidth/2-112, 22.5, 90, 30);
        [self.worksbtn setTitle:@"代表作品" forState:UIControlStateNormal];
        [self.worksbtn setTitle:@"代表作品" forState:UIControlStateHighlighted];
        [self.worksbtn setTitleColor:[UIColor colorWithHexString:@"#bbbbbb"] forState:UIControlStateNormal];
        [self.worksbtn setTitleColor:[UIColor colorWithHexString:@"#fd3e40"] forState:UIControlStateSelected];
        [self.worksbtn addTarget:self action:@selector(workAction:) forControlEvents:UIControlEventTouchUpInside];
        self.worksbtn.titleLabel.font =[UIFont systemFontOfSize:15];
        if (self.isWork ==YES) {
            self.worksbtn.selected =YES;
            self.worksbtn.layer.masksToBounds = YES;
            self.worksbtn.layer.cornerRadius = 15;
            self.worksbtn.layer.borderColor =[UIColor colorWithHexString:@"#fd3e40"].CGColor;
            self.worksbtn.layer.borderWidth = 1;
        }
        [headView addSubview:self.worksbtn];
        
        self.commentsbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.commentsbtn.frame =CGRectMake(kMainScreenWidth/2+22, 22.5, 90, 30);
        [self.commentsbtn setTitle:@"用户评论" forState:UIControlStateNormal];
        [self.commentsbtn setTitle:@"用户评论" forState:UIControlStateHighlighted];
        [self.commentsbtn setTitleColor:[UIColor colorWithHexString:@"#bbbbbb"] forState:UIControlStateNormal];
        [self.commentsbtn setTitleColor:[UIColor colorWithHexString:@"#fd3e40"] forState:UIControlStateSelected];
        [self.commentsbtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        self.commentsbtn.titleLabel.font =[UIFont systemFontOfSize:15];
        if (self.isWork ==NO) {
            self.commentsbtn.selected =YES;
            self.commentsbtn.layer.masksToBounds = YES;
            self.commentsbtn.layer.cornerRadius = 15;
            self.commentsbtn.layer.borderColor =[UIColor colorWithHexString:@"#fd3e40"].CGColor;
            self.commentsbtn.layer.borderWidth = 1;
        }
        [headView addSubview:self.commentsbtn];
        if (self.isWork ==YES) {
            UIImageView *footimage =[[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth-84)/2, self.worksbtn.frame.size.height+self.worksbtn.frame.origin.y+14, 84, 16)];
            footimage.image =[UIImage imageNamed:@"wenzi_jxxgt.png"];
            if (_designerDetailModel.designerImagesPath.count>0) {
                [headView addSubview:footimage];
            }
            
            
            UILabel *countlbl =[[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-100)/2, footimage.frame.origin.y+footimage.frame.size.height+4, 100, 11)];
            countlbl.textColor =[UIColor colorWithHexString:@"#bbbbbb"];
            countlbl.font =[UIFont systemFontOfSize:11];
            countlbl.textAlignment =NSTextAlignmentCenter;
            countlbl.text =[NSString stringWithFormat:@"共%d张",[_designerDetailModel.designerImagesPath count]];
            [headView addSubview:countlbl];
            
            UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(footimage.frame.origin.x-120, footimage.frame.origin.y+7.5, 105, 1)];
            footline.backgroundColor =[UIColor colorWithHexString:@"#bbbbbb"];
            if (_designerDetailModel.designerImagesPath.count>0) {
                [headView addSubview:footline];
            }
            
            UIImageView *footline1 =[[UIImageView alloc] initWithFrame:CGRectMake(footimage.frame.origin.x+footimage.frame.size.width+15, footimage.frame.origin.y+7.5, 105, 1)];
            footline1.backgroundColor =[UIColor colorWithHexString:@"#bbbbbb"];
            if (_designerDetailModel.designerImagesPath.count>0) {
                [headView addSubview:footline1];
            }
            
            _bgView2.frame = CGRectMake(0, 0, kMainScreenWidth, height+headView.frame.size.height+40+_designerDetailModel.designerCollectivePics.count*89);
            [_bgView2 addSubview:headView];
            float designerImageHeight =0;
            if([_designerDetailModel.designerImagesPath count]>1){
                NSMutableArray *urls = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < [_designerDetailModel.designerImagesPath count]; ++i) {
                    [urls addObject:[[_designerDetailModel.designerImagesPath objectAtIndex:i] objectForKey:@"rendreingsPath"]];
                }
                
                self.selected_picture=0;
                if(!self.mainScorllView)self.mainScorllView = [[CustomScrollView3 alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y+headView.frame.size.height, _bgView2.frame.size.width, 130) imageURL:urls];
                self.mainScorllView.backgroundColor = [UIColor clearColor];
                __weak __typeof(self) weakself = self;
                self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
                    weakself.selected_picture =pageIndex;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"designer_tap" object:nil];
                };
                [_bgView2 addSubview:self.mainScorllView];
                designerImageHeight =150;
            }
            else if([_designerDetailModel.designerImagesPath count]==1){
                footimage.image =[UIImage imageNamed:@"wenzi_jxxgt.png"];
                [headView addSubview:footimage];
                
                UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(footimage.frame.origin.x-120, footimage.frame.origin.y+7.5, 105, 1)];
                footline.backgroundColor =[UIColor colorWithHexString:@"#bbbbbb"];
                [headView addSubview:footline];
                
                UIImageView *footline1 =[[UIImageView alloc] initWithFrame:CGRectMake(footimage.frame.origin.x+footimage.frame.size.width+15, footimage.frame.origin.y+7.5, 105, 1)];
                footline1.backgroundColor =[UIColor colorWithHexString:@"#bbbbbb"];
                [headView addSubview:footline1];
                
                UIImageView *view_sub = [[UIImageView alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y+headView.frame.size.height, 130*4/3, 130)];
                view_sub.userInteractionEnabled=YES;
                view_sub.clipsToBounds=YES;
                view_sub.contentMode=UIViewContentModeScaleAspectFill;
                [view_sub sd_setImageWithURL:[NSURL URLWithString:[[_designerDetailModel.designerImagesPath objectAtIndex:0] objectForKey:@"rendreingsPath"]] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq"] options:SDWebImageTransformAnimatedImage];
                [_bgView2 addSubview:view_sub];
                
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
                tap.numberOfTouchesRequired=1;
                tap.numberOfTapsRequired=1;
                [view_sub addGestureRecognizer:tap];
                designerImageHeight =150;
            }else{
//                footimage.image =[UIImage imageNamed:@"wenzi_jxxgt.png"];
//                [headView addSubview:footimage];
//                
//                UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(footimage.frame.origin.x-120, footimage.frame.origin.y+7.5, 105, 1)];
//                footline.backgroundColor =[UIColor colorWithHexString:@"#bbbbbb"];
//                [headView addSubview:footline];
//                
//                UIImageView *footline1 =[[UIImageView alloc] initWithFrame:CGRectMake(footimage.frame.origin.x+footimage.frame.size.width+15, footimage.frame.origin.y+7.5, 105, 1)];
//                footline1.backgroundColor =[UIColor colorWithHexString:@"#bbbbbb"];
//                [headView addSubview:footline1];
//                
//                UIImageView *view_sub = [[UIImageView alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y+headView.frame.size.height, 130*4/3, 130)];
//                view_sub.userInteractionEnabled=YES;
//                view_sub.clipsToBounds=YES;
//                view_sub.contentMode=UIViewContentModeScaleAspectFill;
//                view_sub.image =[UIImage imageNamed:@"bg_morentu_xq"];
//                [_bgView2 addSubview:view_sub];
                designerImageHeight =0;
                
            }
            
            UIImageView *footimage1 =[[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth-112)/2, headView.frame.size.height+headView.frame.origin.y+designerImageHeight, 112, 18)];
            footimage1.image =[UIImage imageNamed:@"wenzi_jxjzfa.png"];
            [headView addSubview:footimage1];
            
            UIImageView *footline2 =[[UIImageView alloc] initWithFrame:CGRectMake(footimage1.frame.origin.x-92, footimage1.frame.origin.y+12.5, 77, 1)];
            footline2.backgroundColor =[UIColor colorWithHexString:@"#bbbbbb"];
            [headView addSubview:footline2];
            
            UIImageView *footline3 =[[UIImageView alloc] initWithFrame:CGRectMake(footimage1.frame.origin.x+footimage1.frame.size.width+15, footimage1.frame.origin.y+12.5, 77, 1)];
            footline3.backgroundColor =[UIColor colorWithHexString:@"#bbbbbb"];
            [headView addSubview:footline3];
            
            for (UIView *view in _bgView2.subviews) {
                if (view.tag == 110 || view.tag == 111) {
                    [view removeFromSuperview];
                }
            }
            
            for (int i = 0; i < _designerDetailModel.designerCollectivePics.count; i++) {
                UIImageView *taotuIV;
                if (self.mainScorllView) {
                    taotuIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.mainScorllView.frame.origin.y + self.mainScorllView.frame.size.height + _bgView2.frame.size.width/4*3 * i +40+i*100+15, _bgView2.frame.size.width, _bgView2.frame.size.width/4*3)];
                    if (designerImageHeight==0) {
                        taotuIV.frame =CGRectMake(taotuIV.frame.origin.x, taotuIV.frame.origin.y-150, taotuIV.frame.size.width, taotuIV.frame.size.height);
                    }
                    taotuIV.clipsToBounds=YES;
                    taotuIV.contentMode=UIViewContentModeScaleAspectFill;
                    NSString *imgStr = [[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"narrowImgPath"];
                    [taotuIV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                    taotuIV.tag = 110 + i;
                    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTaotuImage:)];
                    taotuIV.userInteractionEnabled = YES;
                    [taotuIV addGestureRecognizer:tapRec];
                    [_bgView2 addSubview:taotuIV];
                    
                    UIImageView *hintBgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, taotuIV.frame.size.height+taotuIV.frame.origin.y, _bgView2.frame.size.width, 100)];
                    //                hintBgIV.image = [UIImage imageNamed:@"bg_taotu.png"];
                    hintBgIV.backgroundColor =[UIColor whiteColor];
                    [_bgView2 addSubview:hintBgIV];
                    
                    //            UILabel *nameLabel = (UILabel *)[cell2 viewWithTag:123];
                    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 22, _bgView2.frame.size.width/2 - 10, 21)];
                    nameLabel.textColor = [UIColor blackColor];
                    NSString *name = [[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"collectiveDrawingName"];
                    nameLabel.text = name;
                    [hintBgIV addSubview:nameLabel];
                    
                    UILabel *roomlbl =[[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+14, 80, 14)];
                    NSString *bedRoom =[[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"bedRoom"];
                    if (bedRoom.length ==0){
                        bedRoom =@"0";
                    }
                    NSString *livingRoom =[[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"livingRoom"];
                    if (livingRoom.length ==0) {
                        livingRoom =@"0";
                    }
                    roomlbl.text =[NSString stringWithFormat:@"%@室%@厅",bedRoom,livingRoom];
                    roomlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                    roomlbl.font =[UIFont systemFontOfSize:14];
                    [hintBgIV addSubview:roomlbl];
                    
                    UILabel *numlbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-50, 54, 12, 22)];
                    numlbl.textColor =[UIColor colorWithHexString:@"#343532"];
                    numlbl.text =@"1";
                    numlbl.font =[UIFont systemFontOfSize:22];
                    [hintBgIV addSubview:numlbl];
                    
                    UILabel *numfootlbl =[[UILabel alloc] initWithFrame:CGRectMake(numlbl.frame.origin.x+numlbl.frame.size.width, 64, 24, 12)];
                    NSInteger numInteger = [[[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"rendreingsList"]count];
                    numfootlbl.textColor =[UIColor colorWithHexString:@"#bbbbbb"];
                    numfootlbl.text =[NSString stringWithFormat:@"/%ld",(long)numInteger];
                    numfootlbl.font =[UIFont systemFontOfSize:12];
                    [hintBgIV addSubview:numfootlbl];
                    
                    UIView *segmentation =[[UIView alloc] initWithFrame:CGRectMake(0, hintBgIV.frame.size.height-8, kMainScreenWidth, 8)];
                    segmentation.backgroundColor =[UIColor colorWithHexString:@"#f0efef"];
                    [hintBgIV addSubview:segmentation];
                } else {
                    
                    if (!_designerDetailModel.designerImagesPath.count) {
                        taotuIV = [[UIImageView alloc]initWithFrame:CGRectMake(0,  231*kMainScreenHeight/667 + _bgView2.frame.size.width/4*3 * i +40+i*100+15, _bgView2.frame.size.width, _bgView2.frame.size.width/4*3)];
                        if (designerImageHeight==0) {
                            taotuIV.frame =CGRectMake(taotuIV.frame.origin.x, taotuIV.frame.origin.y-150, taotuIV.frame.size.width, taotuIV.frame.size.height);
                        }
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
                        taotuIV = [[UIImageView alloc]initWithFrame:CGRectMake(0,  231*kMainScreenHeight/667 + _bgView2.frame.size.width/4*3 * i +40+i*100+15, _bgView2.frame.size.width, _bgView2.frame.size.width/4*3)];
                        if (designerImageHeight==0) {
                            taotuIV.frame =CGRectMake(taotuIV.frame.origin.x, taotuIV.frame.origin.y-150, taotuIV.frame.size.width, taotuIV.frame.size.height);
                        }
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
                    
                    UIImageView *hintBgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, taotuIV.frame.size.height+taotuIV.frame.origin.y, _bgView2.frame.size.width, 100)];
//                    hintBgIV.image = [UIImage imageNamed:@"bg_taotu.png"];
                    [_bgView2 addSubview:hintBgIV];
                    
                    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 22, _bgView2.frame.size.width/2 - 10, 21)];
                    nameLabel.textColor = [UIColor blackColor];
                    NSString *name = [[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"collectiveDrawingName"];
                    nameLabel.text = name;
                    [hintBgIV addSubview:nameLabel];
                    
                    UILabel *roomlbl =[[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+14, 80, 12)];
                    NSString *bedRoom =[[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"bedRoom"];
                    if (bedRoom.length ==0){
                        bedRoom =@"0";
                    }
                    NSString *livingRoom =[[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"livingRoom"];
                    if (livingRoom.length ==0) {
                        livingRoom =@"0";
                    }
                    roomlbl.text =[NSString stringWithFormat:@"%@室%@厅",bedRoom,livingRoom];
                    roomlbl.textColor =[UIColor colorWithHexString:@"#bbbbbb"];
                    roomlbl.font =[UIFont systemFontOfSize:12];
                    [hintBgIV addSubview:roomlbl];
                    
                    UILabel *numlbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-50, 54, 12, 22)];
                    numlbl.textColor =[UIColor colorWithHexString:@"#343532"];
                    numlbl.text =@"1";
                    numlbl.font =[UIFont systemFontOfSize:22];
                    [hintBgIV addSubview:numlbl];
                    
                    UILabel *numfootlbl =[[UILabel alloc] initWithFrame:CGRectMake(numlbl.frame.origin.x+numlbl.frame.size.width, 64, 24, 12)];
                    NSInteger numInteger = [[[_designerDetailModel.designerCollectivePics objectAtIndex:i]objectForKey:@"rendreingsList"]count];
                    numfootlbl.textColor =[UIColor colorWithHexString:@"#bbbbbb"];
                    numfootlbl.text =[NSString stringWithFormat:@"/%ld",(long)numInteger];
                    numfootlbl.font =[UIFont systemFontOfSize:12];
                    [hintBgIV addSubview:numfootlbl];
                    
                    UIView *segmentation =[[UIView alloc] initWithFrame:CGRectMake(0, hintBgIV.frame.size.height-8, kMainScreenWidth, 8)];
                    segmentation.backgroundColor =[UIColor colorWithHexString:@"#f0efef"];
                    [hintBgIV addSubview:segmentation];
                    
                }
        }
        }else{
             _bgView2.frame = CGRectMake(0, 0, kMainScreenWidth, self.worksbtn.frame.origin.y+self.worksbtn.frame.size.height+162);
            headView.frame =CGRectMake(headView.frame.origin.x, headView.frame.origin.y, headView.frame.size.width, headView.frame.size.height-20);
            for (int i=0; i<3; i++) {
                NSInteger startlevel =0;
                double points =0;
                if (i==0) {
                    startlevel =self.level*2;
                    points =self.level;
                }else if (i==1){
                    startlevel =self.professionalLevel*2;
                    points =self.professionalLevel;
                }else{
                    startlevel =self.customerServiceLevel*2;
                    points =self.customerServiceLevel;
                }
                UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(22, headView.frame.origin.y+headView.frame.size.height+i*31, 60, 15)];
                titlelbl.font =[UIFont systemFontOfSize:15];
                titlelbl.textColor =[UIColor colorWithHexString:@"#bbbbbb"];
                if (i==0) {
                    titlelbl.text =@"服务态度";
                }else if (i==1){
                    titlelbl.text =@"设计水平";
                }else if (i==2){
                    titlelbl.text =@"沟通能力";
                }
                [_bgView2 addSubview:titlelbl];
                NSMutableArray *imageArray =[NSMutableArray array];
                for (int j=0; j<5; j++) {
                    UIImageView *startimage =[[UIImageView alloc] initWithFrame:CGRectMake(titlelbl.frame.origin.x+titlelbl.frame.size.width+23+j*15, titlelbl.frame.origin.y+1.5, 12, 12)];
                    [imageArray addObject:startimage];
                    [_bgView2 addSubview:startimage];
                }
                [self numberStartReLoad:startlevel imageViewArray:imageArray];
                UILabel *pointslbl =[[UILabel alloc] initWithFrame:CGRectMake(titlelbl.frame.origin.x+titlelbl.frame.size.width+105, titlelbl.frame.origin.y, 40, 15)];
                pointslbl.text =[NSString stringWithFormat:@"%.1f",points];
                pointslbl.textColor =[UIColor redColor];
                pointslbl.font =[UIFont systemFontOfSize:15.0];
                [_bgView2 addSubview:pointslbl];
            }
            
            UILabel *pointlbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-103*kMainScreenWidth/375, self.worksbtn.frame.origin.y+self.worksbtn.frame.size.height+50, 39, 22)];
            
            pointlbl.text =[NSString stringWithFormat:@"%.1f",self.professionalLevel];
            pointlbl.textColor =[UIColor redColor];
            pointlbl.font =[UIFont boldSystemFontOfSize:24];
            pointlbl.textAlignment =NSTextAlignmentCenter;
            [_bgView2 addSubview:pointlbl];
            
            UILabel *mouth =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-103*kMainScreenWidth/375, pointlbl.frame.origin.y+pointlbl.frame.size.height+5, 39, 13)];
            mouth.textColor =[UIColor colorWithHexString:@"#898989"];
            mouth.text=@"口碑值";
            mouth.font =[UIFont systemFontOfSize:13];
            [_bgView2 addSubview:mouth];
            
            UIImageView *headline =[[UIImageView alloc] initWithFrame:CGRectMake(22, self.worksbtn.frame.origin.y+self.worksbtn.frame.size.height+116, kMainScreenWidth-44, 1)];
            headline.backgroundColor =kColorWithRGB(239, 239, 239);
            [_bgView2 addSubview:headline];
            
            UIImageView *footline =[[UIImageView alloc] initWithFrame:CGRectMake(22, self.worksbtn.frame.origin.y+self.worksbtn.frame.size.height+162, kMainScreenWidth-44, 1)];
            footline.backgroundColor =kColorWithRGB(239, 239, 239);
            [_bgView2 addSubview:footline];
            
            UIButton *morebtn =[UIButton buttonWithType:UIButtonTypeCustom];
            morebtn.frame =CGRectMake(22, self.worksbtn.frame.origin.y+self.worksbtn.frame.size.height+117, kMainScreenWidth-44, 44);
            [morebtn addTarget:self action:@selector(tapHeader:) forControlEvents:UIControlEventTouchUpInside];
//            [morebtn setTitle:@"更多评论" forState:UIControlStateNormal];
//            [morebtn setTitle:@"更多评论" forState:UIControlStateHighlighted];
//            [morebtn setTitleColor:[UIColor colorWithHexString:@"#8a8a8a"] forState:UIControlStateNormal];
//            [morebtn setTitleColor:[UIColor colorWithHexString:@"#8a8a8a"] forState:UIControlStateHighlighted];
            UILabel *btntitle =[[UILabel alloc] initWithFrame:CGRectMake(0, 31/2, 60, 13)];
            btntitle.textColor =[UIColor colorWithHexString:@"#8a8a8a"];
            btntitle.text =@"更多评论";
            btntitle.font =[UIFont systemFontOfSize:13];
            [morebtn addSubview:btntitle];
            UIImageView *arrow =[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-44-8.5, 31.5/2, 8.5, 13.5)];
            arrow.image =[UIImage imageNamed:@"ic_jiantou_lb.png"];
            [morebtn addSubview:arrow];
            [_bgView2 addSubview:morebtn];
            
            float height=0;
            int countheight =0;
            int count =0;
            int heighty =0;
            for (int i=0; i<self.dataArray_pl.count; i++){
                if (i==5) {
                    break;
                }
                UIView *pl_backView =[[UIView alloc] initWithFrame:CGRectMake(22, footline.frame.origin.y+footline.frame.size.height+heighty, kMainScreenWidth-44, 152)];
                pl_backView.tag =10000+i;
//                if (i ==0) {
//                    pl_backView.backgroundColor =[UIColor orangeColor];
//                }else if (i==1){
//                    pl_backView.backgroundColor =[UIColor redColor];
//                }else if (i==2){
//                    pl_backView.backgroundColor =[UIColor purpleColor];
//                }else if (i==3){
//                    pl_backView.backgroundColor =[UIColor yellowColor];
//                }else if (i==4){
//                    pl_backView.backgroundColor =[UIColor lightGrayColor];
//                }
                
                UIImageView *photo_pl=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 27, 27)];
                photo_pl.layer.cornerRadius=14.0;
                photo_pl.layer.masksToBounds=YES;
//                photo_pl.backgroundColor =[UIColor redColor];
                photo_pl.clipsToBounds = YES;
                photo_pl.image=[UIImage imageNamed:@"ic_touxiang_tk_over.png"];
                [pl_backView addSubview:photo_pl];
                
                dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(parsingQueue, ^{
                    if([[[self.dataArray_pl objectAtIndex:i] objectForKey:@"userLogos"] length]>1)
                        [photo_pl sd_setImageWithURL:[[self.dataArray_pl objectAtIndex:i] objectForKey:@"userLogos"]  placeholderImage:[UIImage imageNamed:@"ic_touxiang_tk_over.png"]];
                });
                
                NSString *nameStr = [[self.dataArray_pl objectAtIndex:i]objectForKey:@"nickName"];
                UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(photo_pl.frame.origin.x+photo_pl.frame.size.width+15, 10, 100, 12)];
                nameLabel.font = [UIFont systemFontOfSize:12.0];
                nameLabel.textColor =[UIColor colorWithHexString:@"#bbbbbb"];
                if(nameStr.length) nameLabel.text = nameStr;
                else nameLabel.text = @"匿名用户";
                [pl_backView addSubview:nameLabel];
                
                NSString *string_pl=[[self.dataArray_pl objectAtIndex:i] objectForKey:@"objectString"];
                CGSize size=[util calHeightForLabel:string_pl width:kMainScreenWidth-nameLabel.frame.origin.x-40 font:[UIFont systemFontOfSize:14]];
                if(size.height<20) size.height=30;
                UILabel *lab_pl=[[UILabel alloc] init];
                lab_pl.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height, kMainScreenWidth-nameLabel.frame.origin.x-40, size.height);
                lab_pl.numberOfLines =0;
                
                if (size.height>20) {
                    height +=size.height -14;
                    countheight =size.height -30;
                }
                lab_pl.text =string_pl;
                lab_pl.textColor =[UIColor colorWithHexString:@"#8a8a8a"];
                lab_pl.font =[UIFont systemFontOfSize:14];
                [pl_backView addSubview:lab_pl];
                NSString *string_levelpic=[[self.dataArray_pl objectAtIndex:i] objectForKey:@"levelPic"];
                if (string_levelpic.length>0) {
                    NSArray *picArray =[string_levelpic componentsSeparatedByString:@","];
                    for (int j=0; j<picArray.count; j++) {
                        UIImageView *contentimage =[[UIImageView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+92*j, lab_pl.frame.origin.y+lab_pl.frame.size.height+10, 82, 82)];
                        [contentimage sd_setImageWithURL:[NSURL URLWithString:[picArray objectAtIndex:j]] placeholderImage:[UIImage imageNamed:@"bg_morentu_xq.png"]];
                        contentimage.userInteractionEnabled =YES;
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                        [contentimage addGestureRecognizer:tap];
                        contentimage.tag =1000+j;
                        [pl_backView addSubview:contentimage];
                    }
                }else{
                    pl_backView.frame =CGRectMake(22, footline.frame.origin.y+footline.frame.size.height+heighty, kMainScreenWidth-44, 70);
                }
                
                
                
                NSString *createDate = [[self.dataArray_pl objectAtIndex:i]objectForKey:@"createDate"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                NSDate *destDate= [dateFormatter dateFromString:createDate];
                NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                
                [dateFormatter1 setDateFormat: @"yyyy-MM-dd"];
                NSString *timeStr =[dateFormatter1 stringFromDate:destDate];
                UILabel *timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-100-44, nameLabel.frame.origin.y, 100, 10)];
                timeLabel.textColor =[UIColor colorWithHexString:@"#bbbbbb"];
                timeLabel.textAlignment =NSTextAlignmentRight;
                timeLabel.text = timeStr;
                timeLabel.font =[UIFont systemFontOfSize:10];
                [pl_backView addSubview:timeLabel];
                
                pl_backView.frame =CGRectMake(pl_backView.frame.origin.x, pl_backView.frame.origin.y, pl_backView.frame.size.width, pl_backView.frame.size.height+countheight);
                heighty +=pl_backView.frame.size.height;
                
                UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(0, pl_backView.frame.size.height-1, kMainScreenWidth-44, 1)];
                line.backgroundColor =kColorWithRGB(239, 239, 239);
                [pl_backView addSubview:line];
                [_bgView2 addSubview:pl_backView];
                count++;
            }

            _bgView2.frame =CGRectMake(_bgView2.frame.origin.x, _bgView2.frame.origin.y, _bgView2.frame.size.width, _bgView2.frame.size.height+heighty);

             [_bgView2 addSubview:headView];
        }
        [cell1 addSubview:_bgView2];
    }
    cell1.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell1;
}
- (void)tapHeader:(UIButton *)sender {
    MoreCommentsViewController *morevc=[[MoreCommentsViewController alloc]init];
    morevc.role_id=@"1";
    morevc.client_id=[NSString stringWithFormat:@"%d",(int)_designerDetailModel.designerID];
    morevc.fromVCStr = self.fromwhere;
    [self.navigationController pushViewController:morevc animated:YES];
}
-(void)tapAction:(UITapGestureRecognizer *)sender{
    UIImageView *image =(UIImageView *)sender.view;
    NSLog(@"%@",[image superview]);
    UIView *pl_view =[image superview];
    NSDictionary *contentdic =[self.dataArray_pl objectAtIndex:pl_view.tag-10000];
    NSArray *photosArray =[[contentdic objectForKey:@"levelPic"] componentsSeparatedByString:@","];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:photosArray.count];
    for (int i = 0; i<photosArray.count; i++) {
        // 替换为中等尺寸图片
        NSString *url = photosArray[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = (UIImageView *)sender.view; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = image.tag-1000; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    //    browser.describe =selectpic.phasePicDescription;
    [browser show];
    
}
#pragma mark - Collapse Click Delegate

// Required Methods
-(int)numberOfCellsForCollapseClick {
    return 2;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"个人简介";
            break;
        default:
            return @"个人荣誉";
            break;
    }
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0:
            return self.introductionView;
            break;
        default:
            return self.honorview;
            break;
    }
}


// Optional Methods

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor whiteColor];
}


-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
}

-(UIColor *)colorForTitleArrowAtIndex:(int)index {
    return [UIColor colorWithWhite:0.0 alpha:0.25];
}

-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    NSLog(@"%d and it's open:%@", index, (open ? @"YES" : @"NO"));
    if (index==0) {
        self.isIntorductionOpen =open;
    }else{
        self.ishonorOpen =open;
        _intorduction.text=nil;
    }
    
    [self.table reloadData];
}
-(void)tapTaotuImage:(UIGestureRecognizer *)gers{
      UIImageView *cellIV = (UIImageView *)[gers view];
    EffectTAOTUPictureInfo *effVC=[[EffectTAOTUPictureInfo alloc]init];
    effVC.selectDone =^(MyeffectPictureObj *pic_obj){
    };
    effVC.obj_pic=[_taotuMutArr objectAtIndex:cellIV.tag-110];

    effVC.selectDone =^(MyeffectPictureObj *obj_pic){
        
    };
    IDIAIAppDelegate *appDelegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication]delegate];//zl
    [appDelegate.nav pushViewController:effVC animated:YES];
//    [self.navigationController pushViewController:effVC animated:YES];
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
        
        NSString *designerID_Str;
        if(self.obj.designerID) designerID_Str=self.obj.designerID;
        else designerID_Str=[NSString stringWithFormat:@"%ld",(long)self.designerID];
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0021\",\"deviceType\":\"ios\",\"cityCode\":\"%@\",\"token\":\"%@\",\"userID\":\"%@\"}&body={\"designerID\":\"%@\"}",kDefaultUpdateVersionServerURL,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],string_token,string_userid,designerID_Str];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"设计师详情返回信息：%@",jsonDict);
                NSArray *arr_pl=[jsonDict objectForKey:@"objectScoreList"];
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10231) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        _designerDetailModel = [DesignerDetailModel objectWithKeyValues:jsonDict];
                        
                        [self customizeNavigationBar];
                        
                        if(_designerDetailModel.state == 1){
                            [self createPhone];
                        }
                        
                        [_taotuMutArr removeAllObjects];
                        for (NSDictionary *dic in _designerDetailModel.designerCollectivePics) {
                            if(_obj){
                                NSDictionary *dic2;
                                if ([dic objectForKey:@"objId"]) {
                                    dic2= @{@"id":[dic objectForKey:@"collectiveDrawingId"],@"browserNum":[dic objectForKey:@"browsePoints"],@"collectionName":[dic objectForKey:@"collectiveDrawingName"],@"imagePath":[dic objectForKey:@"narrowImgPath"],@"bathRoom":[dic objectForKey:@"bathRoom"],@"livingRoom":[dic objectForKey:@"livingRoom"],@"bedRoom":[dic objectForKey:@"bedRoom"],@"objId":[dic objectForKey:@"objId"],@"designerID":_obj.designerID,@"designerName":_obj.designerName,@"designerImagePath":_designerDetailModel.designerIconPath?_designerDetailModel.designerIconPath:@""};
                                }else{
                                    dic2= @{@"id":[dic objectForKey:@"collectiveDrawingId"],@"browserNum":[dic objectForKey:@"browsePoints"],@"collectionName":[dic objectForKey:@"collectiveDrawingName"],@"imagePath":[dic objectForKey:@"narrowImgPath"],@"bathRoom":[dic objectForKey:@"bathRoom"],@"livingRoom":[dic objectForKey:@"livingRoom"],@"bedRoom":[dic objectForKey:@"bedRoom"],@"objId":@"",@"designerID":_obj.designerID,@"designerName":_obj.designerName,@"designerImagePath":_designerDetailModel.designerIconPath?_designerDetailModel.designerIconPath:@""};
                                }
                                
                                MyeffectPictureObj *myEffPicObj = [MyeffectPictureObj objWithDict:dic2];
                                
                                [_taotuMutArr addObject:myEffPicObj];
                            }
                            else{
                                NSString *objId =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"objId"] intValue]];
                                if (objId.length<=0) {
                                    objId =@"";
                                }
                                NSDictionary *dic2 = @{@"id":[dic objectForKey:@"collectiveDrawingId"],@"browserNum":[dic objectForKey:@"browsePoints"],@"collectionName":[dic objectForKey:@"collectiveDrawingName"],@"imagePath":[dic objectForKey:@"narrowImgPath"],@"bathRoom":[dic objectForKey:@"bathRoom"],@"livingRoom":[dic objectForKey:@"livingRoom"],@"bedRoom":[dic objectForKey:@"bedRoom"],@"objId":objId,@"designerImagePath":_designerDetailModel.designerIconPath?_designerDetailModel.designerIconPath:@""};
                                MyeffectPictureObj *myEffPicObj = [MyeffectPictureObj objWithDict:dic2];
                                
                                [_taotuMutArr addObject:myEffPicObj];
                            }
                        }
//                        [_theTableView tableViewDidFinishedLoading];
                        
                        self.table.tableHeaderView =[self settableHeadView];
                        [self creaintroductionView];
                        [self creahonorView];
                        [self creastyleView];
                        [self.table reloadData];
                        
                    });
                }
                else if (code==10379) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
//                        [_theTableView tableViewDidFinishedLoading];
                    });
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
//                        [_theTableView tableViewDidFinishedLoading];
                    });
                }
            });
        }
                          failedBlock:^{
                              [self stopRequest];
                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  [_theTableView tableViewDidFinishedLoading];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}
//-(void)scrollviewToCurrent:(NSInteger)index{
//    self.selected_picture=index;
//    self.lab_count.text=[NSString stringWithFormat:@"%d/%d",index+1,[_designerDetailModel.designerImagesPath count]];
//}
-(void)tapImage:(UIGestureRecognizer *)gers{
    if(![util isConnectionAvailable]) [TLToast showWithText:@"无网络连接" topOffset:200.0f duration:1.0];
    PicturesShowVC *picvc=[[PicturesShowVC alloc]init];
    picvc.data_array=_designerDetailModel.designerImagesPath;
    picvc.type_pic=@"designer";
    picvc.pic_id=self.selected_picture;
    [self.navigationController pushViewController:picvc animated:YES];
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
        
        NSString *designerID_Str;
        if(self.obj.designerID) designerID_Str=self.obj.designerID;
        else designerID_Str=[NSString stringWithFormat:@"%ld",(long)self.designerID];
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0037\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"objectTypeId\":\"1\",\"objectId\":\"%@\",\"currentPage\":\"1\",\"requestRow\":\"5\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],designerID_Str];
        
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
                self.level =[[jsonDict objectForKey:@"level"] doubleValue];
                self.professionalLevel =[[jsonDict objectForKey:@"professionalLevel"] doubleValue];
                self.customerServiceLevel =[[jsonDict objectForKey:@"customerServiceLevel"] doubleValue];
                self.popularityLevel =[[jsonDict objectForKey:@"popularityLevel"] doubleValue];
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
                        
                        [self.table reloadData];
                    });
                }
                else if (code==10379) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
