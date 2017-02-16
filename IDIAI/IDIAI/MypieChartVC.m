//
//  MypieChartVC.m
//  IDIAI
//
//  Created by iMac on 14-7-22.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MypieChartVC.h"
#import "HexColor.h"
#import "MyThingPriceVC.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabasePool.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"
#import "SqliteHubgetObj.h"
#import "MyhudgetInfoObj.h"
#import "savelogObj.h"
#import <QuartzCore/QuartzCore.h>
#import "AutomaticLogin.h"
#import "TLToast.h"
#import "DecorationInfoViewController.h"
//#import "LoginVC.h"
#import "LoginView.h"

#define KButton_tag_name 1000
#define KButton_tag_percent 2000
#define KButton_tag_totalPrice 3000

@interface MypieChartVC ()

@end

@implementation MypieChartVC
@synthesize sql_string;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"报价分析";
    }
    return self;
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [savelogObj saveLog:@"用户进行了房屋预算" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:7];
    
    //导航右按钮
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 25, 25);
//    [rightBtn setImage:[UIImage imageNamed:@"ic_fbzx.png"] forState:UIControlStateNormal];
//    //右移
//    //    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
//    [rightBtn addTarget:self action:@selector(clickNavRightBtn:) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.adjustsImageWhenHighlighted = NO;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    NSString *string=[dict objectForKey:@"户型"];
    
    self.data_bottom=[NSMutableArray arrayWithCapacity:0];
    NSArray *array_first=[NSArray arrayWithObjects:@"主卧",@"次卧",@"客卧",@"小孩卧房",@"老人卧房", nil];
    NSArray *array_second=[NSArray arrayWithObjects:@"客厅",@"餐厅", nil];
    NSArray *array_three=[NSArray arrayWithObjects:@"公共卫生间",@"主卧卫生间",@"次卧卫生间", nil];
    NSArray *array_four=[NSArray arrayWithObjects:@"厅阳台",@"厨房阳台",@"主卧阳台", nil];
    for(int i=0;i<4;i++){
        if(i==0){
            for(int j=0;j<[[string substringWithRange:NSMakeRange(0, 1)] intValue];j++){
                [self.data_bottom addObject:[array_first objectAtIndex:j]];
            }
        }
        if(i==1){
            if([[string substringWithRange:NSMakeRange(2, 1)] intValue]!=0)
                for(int j=0;j<[[string substringWithRange:NSMakeRange(2, 1)] intValue];j++){
                    [self.data_bottom addObject:[array_second objectAtIndex:j]];
                }
        }
        if(i==2){
            if([[string substringWithRange:NSMakeRange(4, 1)] intValue]!=0)
                for(int j=0;j<[[string substringWithRange:NSMakeRange(4, 1)] intValue];j++){
                    [self.data_bottom addObject:[array_three objectAtIndex:j]];
                }
        }
        if(i==3){
            if([[string substringWithRange:NSMakeRange(6, 1)] intValue]!=0)
                for(int j=0;j<[[string substringWithRange:NSMakeRange(6, 1)] intValue];j++){
                    [self.data_bottom addObject:[array_four objectAtIndex:j]];
                }
        }
    }
    [self.data_bottom addObject:@"厨房"];
    
    self.arr_type=[[NSMutableArray alloc]initWithCapacity:0];
    self.arr_get=[[NSMutableArray alloc]initWithCapacity:0];
    self.all_dictionary=[NSMutableDictionary dictionaryWithCapacity:14];
    //创建数据库
     [self creatDatabase];
    //查询数据
    [self choiceMathformula];
}

-(void)createTableView{
    mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
//    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mtableview];
    
    [self createHeaderview];
}

-(void)createHeaderview{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
 
    UIView *header_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 120)];
    header_view.backgroundColor=[UIColor clearColor];
    mtableview.tableHeaderView=header_view;
    
    UILabel *name_price=[[UILabel alloc]initWithFrame:CGRectMake(15, 20, 100, 40)];
    name_price.textAlignment=NSTextAlignmentLeft;
    name_price.font=[UIFont systemFontOfSize:27];
//    name_price.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    name_price.text=@"总价：";
    [header_view addSubview:name_price];
    self.totalPrice_zj=[[UILabel alloc]initWithFrame:CGRectMake(100, 25, 150, 30)];
    self.totalPrice_zj.textAlignment=NSTextAlignmentLeft;
    self.totalPrice_zj.font=[UIFont systemFontOfSize:27];
    self.totalPrice_zj.textColor=[UIColor redColor];
    self.totalPrice_zj.text=[NSString stringWithFormat:@"%.2f万",self.totalMoney/10000];
    [header_view addSubview:self.totalPrice_zj];
    
    UILabel *name_jzck=[[UILabel alloc]initWithFrame:CGRectMake(15, 80, 70, 20)];
    name_jzck.textAlignment=NSTextAlignmentLeft;
    name_jzck.font=[UIFont systemFontOfSize:17];
    name_jzck.textColor=kFontPlacehoderColor;
    name_jzck.text=@"基装参考";
    [header_view addSubview:name_jzck];
    
    self.totalPrice_jzck=[[UILabel alloc]initWithFrame:CGRectMake(95, 80, 70, 20)];
    self.totalPrice_jzck.textAlignment=NSTextAlignmentLeft;
    self.totalPrice_jzck.font=[UIFont systemFontOfSize:17];
    self.totalPrice_jzck.textColor=kFontPlacehoderColor;
    self.totalPrice_jzck.text=[NSString stringWithFormat:@"%.2f万",(self.totalMoney-[[[dict objectForKey:@"各项总价"] objectForKey:@"主材报价"]floatValue])/10000];
    [header_view addSubview:self.totalPrice_jzck];
    
    UILabel *name_zcck=[[UILabel alloc]initWithFrame:CGRectMake(175, 80, 70, 20)];
    name_zcck.textAlignment=NSTextAlignmentLeft;
    name_zcck.font=[UIFont systemFontOfSize:17];
    name_zcck.textColor=kFontPlacehoderColor;
    name_zcck.text=@"主材参考";
    [header_view addSubview:name_zcck];
    self.totalPrice_zcck=[[UILabel alloc]initWithFrame:CGRectMake(255, 80, 70, 20)];
    self.totalPrice_zcck.textAlignment=NSTextAlignmentLeft;
    self.totalPrice_zcck.font=[UIFont systemFontOfSize:17];
    self.totalPrice_zcck.textColor=kFontPlacehoderColor;
    self.totalPrice_zcck.text=[NSString stringWithFormat:@"%.2f万",[[[dict objectForKey:@"各项总价"] objectForKey:@"主材报价"]floatValue]/10000];
    [header_view addSubview:self.totalPrice_zcck];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, kMainScreenWidth, .5)];
    lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.25];
    [header_view addSubview:lineView];
}

#pragma mark -
#pragma mark -UITableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arr_type count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid=[NSString stringWithFormat:@"cellid_%d",indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
//        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    
    UILabel *name_lab=(UILabel *)[cell.contentView viewWithTag:KButton_tag_name+indexPath.row];
    if (!name_lab)
    name_lab = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 70, 20)];
    name_lab.backgroundColor = [UIColor clearColor];
    name_lab.tag=KButton_tag_name+indexPath.row;
    name_lab.font = [UIFont systemFontOfSize:13.0];
//    name_lab.textAlignment = NSTextAlignmentCenter;
    name_lab.text=[self.arr_type objectAtIndex:indexPath.row];
//    name_lab.textColor = [UIColor colorWithHexString:@"#6d2900" alpha:1.0];
    name_lab.textColor = kFontPlacehoderColor;
    [cell.contentView addSubview:name_lab];
    
    if ([name_lab.text isEqualToString:@"厨房"]){
    cell.imageView.image = [UIImage imageNamed:@"ic_cf"];
    } else if ([name_lab.text isEqualToString:@"客厅"]) {
        cell.imageView.image = [UIImage imageNamed:@"ic_keting"];
    } else if ([name_lab.text isEqualToString:@"餐厅"]) {
            cell.imageView.image = [UIImage imageNamed:@"ic_ct"];
    } else if ([name_lab.text isEqualToString:@"主卧"] || [name_lab.text isEqualToString:@"次卧"] || [name_lab.text isEqualToString:@"客卧"] || [name_lab.text isEqualToString:@"小孩卧房"] || [name_lab.text isEqualToString:@"老人卧房"]) {
            cell.imageView.image = [UIImage imageNamed:@"ic_ws"];
    } else if ([name_lab.text isEqualToString:@"公共卫生间"] || [name_lab.text isEqualToString:@"主卧卫生间"] || [name_lab.text isEqualToString:@"次卧卫生间"]) {
            cell.imageView.image = [UIImage imageNamed:@"ic_cs"];
    } else if ([name_lab.text isEqualToString:@"厅阳台"] || [name_lab.text isEqualToString:@"厨房阳台"] || [name_lab.text isEqualToString:@"主卧阳台"]) {
            cell.imageView.image = [UIImage imageNamed:@"ic_yt"];
    } else if ([name_lab.text isEqualToString:@"水电安装"]) {
        cell.imageView.image = [UIImage imageNamed:@"ic_shuidian"];

    } else if ([name_lab.text isEqualToString:@"主材报价"]) {
        cell.imageView.image = [UIImage imageNamed:@"ic_zhucai"];

    } else {
        cell.imageView.image = [UIImage imageNamed:@"ic_qita"];

    }
    
    UILabel *percent_lab=(UILabel *)[cell.contentView viewWithTag:KButton_tag_percent+indexPath.row];
    if(!percent_lab)
        percent_lab = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 60, 20)];
    percent_lab.tag=KButton_tag_percent+indexPath.row;
    percent_lab.backgroundColor = [UIColor clearColor];
    percent_lab.font = [UIFont systemFontOfSize:13.0];
    percent_lab.textAlignment = NSTextAlignmentCenter;
    percent_lab.textColor = kFontPlacehoderColor;
    percent_lab.text =[NSString stringWithFormat:@"%.2f%%",([[[dict objectForKey:@"各项总价"] objectForKey:[self.arr_type objectAtIndex:indexPath.row]] floatValue]/self.totalMoney)*100];
    [cell.contentView addSubview:percent_lab];
    
    UIView *budgetBgView = [[UIView alloc]initWithFrame:CGRectMake(70, 35, kMainScreenWidth - 90, 20)];
    budgetBgView.backgroundColor = [UIColor colorWithHexString:@"#fad2d0"];
    [cell.contentView addSubview:budgetBgView];
    
    UIImageView *image_pro=[[UIImageView alloc]initWithFrame:CGRectMake(70, 36, 0, 20)];
    image_pro.contentMode= UIViewContentModeScaleAspectFit;
    image_pro.backgroundColor=kThemeColor;
    [cell.contentView addSubview:image_pro];
    [UIView animateWithDuration:0.5 animations:^{
        image_pro.frame=CGRectMake(70, 36, (kMainScreenWidth - 90)*([[[dict objectForKey:@"各项总价"] objectForKey:[self.arr_type objectAtIndex:indexPath.row]] floatValue]/self.totalMoney), 19);
    }completion:^(BOOL finished){
        
    }];
    
    UILabel *totalPrice_lab=(UILabel *)[cell.contentView viewWithTag:KButton_tag_totalPrice+indexPath.row];
    if(!totalPrice_lab)
    totalPrice_lab = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 60, 20)];
    totalPrice_lab.tag=KButton_tag_totalPrice+indexPath.row;
    totalPrice_lab.backgroundColor = [UIColor clearColor];
    totalPrice_lab.font = [UIFont systemFontOfSize:13.0];
    totalPrice_lab.textAlignment = NSTextAlignmentLeft;
//    totalPrice_lab.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    totalPrice_lab.textColor = kFontPlacehoderColor;
    totalPrice_lab.text =[NSString stringWithFormat:@"%.2f万",([[[dict objectForKey:@"各项总价"] objectForKey:[self.arr_type objectAtIndex:indexPath.row]] floatValue])/10000];
    [cell.contentView addSubview:totalPrice_lab];

    UIView *lineView=(UIView *)[cell.contentView viewWithTag:10000+indexPath.row];
    if(!lineView) lineView= [[UIView alloc]initWithFrame:CGRectMake(70, 60, kMainScreenWidth-70, .5)];
    lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.25];
    lineView.tag=10000+indexPath.row;
    [cell.contentView addSubview:lineView];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyThingPriceVC *pricevc=[[MyThingPriceVC alloc]init];
    pricevc.data_Array=[self.all_dictionary objectForKey:[self.arr_type objectAtIndex:indexPath.row]];;
    pricevc.title_string=[self.arr_type objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:pricevc animated:YES];
}


#pragma mark -
#pragma mark - formula

-(void)choiceMathformula{
    self.arr_get=[self exquery:sql_string];

    [self area];
}

-(float)CalculatingArea:(float)index_area type:(NSInteger)index_type formula:(NSString *)formula{
    //获得我的房型的面积
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    
    float math_return=0.0;
    
    NSString *string_hx=[dict objectForKey:@"户型"];
    //计算卧室数
    NSInteger totalcount_ws=[[string_hx substringWithRange:NSMakeRange(0, 1)] intValue];
    //计算厅数
    NSInteger totalcount_kt=[[string_hx substringWithRange:NSMakeRange(2, 1)] intValue];
    //计算卫生间数
    NSInteger totalcount_wsj=[[string_hx substringWithRange:NSMakeRange(4, 1)] intValue];
    //计算阳台间数
    NSInteger totalcount_yt=[[string_hx substringWithRange:NSMakeRange(6, 1)] intValue];
    
    //计算卧室总面积
    float area_total_ws=0.0;
    NSArray *arr_ws=[NSArray arrayWithObjects:@"主卧",@"次卧",@"客卧",@"小孩卧房",@"老人卧房", nil];
    for (int i=0; i<totalcount_ws; i++) {
        if([[dict objectForKey:[arr_ws objectAtIndex:i]] floatValue]>0)
            area_total_ws+=[[dict objectForKey:[arr_ws objectAtIndex:i]] floatValue];
    }
    
    //计算厅总面积
    float area_total_kt=0.0;
    NSArray *arr_kt=[NSArray arrayWithObjects:@"客厅",@"餐厅", nil];
    for (int i=0; i<totalcount_kt; i++) {
        if([[dict objectForKey:[arr_kt objectAtIndex:i]] floatValue]>0)
            area_total_kt+=[[dict objectForKey:[arr_kt objectAtIndex:i]] floatValue];
    }
    
    //计算卫生间面积
    float area_total_wsj=0.0;
    NSArray *arr_wsj=[NSArray arrayWithObjects:@"公共卫生间",@"主卧卫生间",@"次卧卫生间", nil];
    for (int i=0; i<totalcount_wsj; i++) {
        if([[dict objectForKey:[arr_wsj objectAtIndex:i]] floatValue]>0)
            area_total_wsj+=[[dict objectForKey:[arr_wsj objectAtIndex:i]] floatValue];
    }
    
    //计算阳台总面积
    float area_total_yt=0.0;
    NSArray *arr_yt=[NSArray arrayWithObjects:@"厅阳台",@"厨房阳台",@"主卧阳台", nil];
    for (int i=0; i<totalcount_yt; i++) {
        if([[dict objectForKey:[arr_yt objectAtIndex:i]] floatValue]>0)
            area_total_yt+=[[dict objectForKey:[arr_yt objectAtIndex:i]] floatValue];
    }
    
    //计算总面积
    float area_total_all=0.0;
    area_total_all=area_total_ws+area_total_kt+area_total_wsj+area_total_yt+[[dict objectForKey:@"厨房"] floatValue];

 
    /*
     //单价
     NSString *ay=@"上述项目总价5%";
     NSString *by=@"3950+255*卧室总面积";
     NSString *cy=@"5000+360*卧室总面积";
     NSString *dy=@"3380+360*卧室总面积";
     NSString *ey=@"1400+卧室数*3000+卫生间*600+客厅数*1500";
     NSString *fy=@"5000+300*卧室总面积";
     NSString *gy=@"5920+卧室数*4000+卫生间数*800+客厅数*2000";
     NSString *hy=@"3360+卧室总面积*120";
     NSString *iy=@"3360+卧室总面积*144";
     NSString *jy=@"950+卧室数*1500+卫生间数*350+客厅数*800";
     */
    
    //计算单价
    if (index_type==1){
        
        if ([formula isEqualToString:@"a"]) {
            math_return=1;
        }
        else if ([formula isEqualToString:@"b"]) {
            math_return=3950+255*area_total_ws;
        }
        else if ([formula isEqualToString:@"c"]) {
            math_return=5000+360*area_total_ws;
        }
        else if ([formula isEqualToString:@"d"]) {
           math_return=3380+360*area_total_ws;
        }
        else if ([formula isEqualToString:@"e"]) {
            math_return=1400+totalcount_ws*3000+totalcount_wsj*600+totalcount_kt*1500;
        }
        else if ([formula isEqualToString:@"f"]) {
            math_return=5000+300*area_total_ws;
        }
        else if ([formula isEqualToString:@"g"]) {
           math_return=5920+4000*totalcount_ws+800*totalcount_wsj+totalcount_kt*2000;
        }
        else if ([formula isEqualToString:@"h"]) {
            math_return=3360+area_total_ws*120;
        }
        else if ([formula isEqualToString:@"i"]) {
            math_return=3360+area_total_ws*144;
        }
        else if ([formula isEqualToString:@"j"]) {
            math_return=950+1500*totalcount_ws+350*totalcount_wsj+totalcount_kt*800;
        }
        else if ([formula isEqualToString:@"k"]) {
            math_return=2500+120*area_total_ws;
        }
        else if ([formula isEqualToString:@"l"]) {
            math_return=2500+144*area_total_ws;
        }
        else if ([formula isEqualToString:@"m"]) {
            math_return=950+1200*totalcount_ws+650*totalcount_wsj+totalcount_kt*600;
        }
        else if ([formula isEqualToString:@"n"]) {
            math_return=3000+240*area_total_ws;
        }
        else if ([formula isEqualToString:@"o"]) {
            math_return=3000+360*area_total_ws;
        }
        else if ([formula isEqualToString:@"p"]) {
            math_return=900+1500*totalcount_ws+800*totalcount_wsj+totalcount_kt*800;
        }
    }
    
    /*
     //量公式
     NSString *a=@"区域面积*2.3";
     NSString *b=@"区域面积*1";
     NSString *c=@"区域面积开根号*4";
     NSString *d=@"卫生间个数";
     NSString *e=@"卧室面积+客厅面积+餐厅面积";
     NSString *f=@"总面积*1";
     NSString *g=@"总面积*2.3";
     NSString *h=@"(厨房面积+卫生间面积)*2.3";
     NSString *i=@"房间数";
     NSString *j=@"总面积<100：项目量3；总面积100~150：项目量5；总面积>150:项目量8";
     NSString *k=@"区域面积*1.3";
     NSString *l=@"区域面积*2";
     NSString *m=@"区域面积*3";
     */
    
    //计算工程量
   else if (index_type==2) {
        if ([formula isEqualToString:@"a"]) {
            math_return=index_area*2.3;
        }
        else if ([formula isEqualToString:@"b"]) {
            math_return=index_area*1;
        }
        else if ([formula isEqualToString:@"c"]) {
            math_return=sqrtf(index_area)*4;
        }
        else if ([formula isEqualToString:@"d"]) {
            math_return=totalcount_wsj;
        }
        else if ([formula isEqualToString:@"e"]) {
            math_return=area_total_ws+area_total_kt;
        }
        else if ([formula isEqualToString:@"f"]) {
            math_return=area_total_all*1;
        }
        else if ([formula isEqualToString:@"g"]) {
            math_return=area_total_all*2.3;
        }
        else if ([formula isEqualToString:@"h"]) {
            math_return=(area_total_wsj+[[dict objectForKey:@"厨房"] floatValue])*2.3;
        }
        else if ([formula isEqualToString:@"i"]) {
            math_return=totalcount_ws+totalcount_kt+totalcount_wsj+totalcount_yt+1;
        }
        else if ([formula isEqualToString:@"j"]) {
            if(area_total_all<100) math_return=3;
            else if (area_total_all>=100 && area_total_all<=150)  math_return=5;
            else if(area_total_all>150) math_return=8;
        }
        else if ([formula isEqualToString:@"k"]) {
            math_return=index_area*1.3;
        }
        else if ([formula isEqualToString:@"l"]) {
            math_return=index_area*2;
        }
        else if ([formula isEqualToString:@"m"]) {
            math_return=index_area*3;
        }
        else if ([formula isEqualToString:@"n"]) {
            math_return=index_area*0.7;
        }
        else if ([formula isEqualToString:@"o"]) {
            math_return=index_area*4;
        }
        else if ([formula isEqualToString:@"p"]) {
            math_return=area_total_all*2.6;
        }
        else if ([formula isEqualToString:@"q"]) {
            math_return=([[dict objectForKey:@"厨房"] floatValue]+area_total_wsj)*4;
        }
    }
    return math_return;
}

-(void)area{
   
    //获得我的房型的面积
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    if (!dict) {
        dict=[NSMutableDictionary dictionary];
    }
    
    float ketingResult = 0;
    float cantingResult = 0;
    float zhuwoResult = 0;
    float ciwoResult = 0;
    float kewoResult = 0;
    float xiaohaiwofang = 0;
    float laorenwofang = 0;
    float chufangResult = 0;
    float ggwsjResult = 0;
    float zhuwowsjResult = 0;
    float ciwowsjResult = 0;
    float tingyangtaiResult = 0;
    float chufangyangtaiResult = 0;
    float zhuwoyangtaiResult = 0;
    float shuidianResult = 0;
    float zongheResult = 0;
    float zcckResult = 0;
    
       if([self.arr_type count]) [self.arr_type removeAllObjects];
       for(int j=0; j<[self.arr_get count]; j++)
       {
           SqliteHubgetObj *obj=[self.arr_get objectAtIndex:j];
           NSInteger contentype=[obj.ContentType integerValue];
           switch (contentype) {
               case 0:
                   if([[dict objectForKey:@"客厅"] floatValue]>0)
                   ketingResult +=[self makeProjectValue:obj type:0 area:[[dict objectForKey:@"客厅"] floatValue] roomtype:@"客厅"];
                   break;
               case 1:
                   if([[dict objectForKey:@"餐厅"] floatValue]>0)
                    cantingResult += [self makeProjectValue:obj type:1 area:[[dict objectForKey:@"餐厅"] floatValue] roomtype:@"餐厅"];
                   break;
               case 2:
                   if([[dict objectForKey:@"主卧"] floatValue]>0)
                    zhuwoResult +=[self makeProjectValue:obj type:2 area:[[dict objectForKey:@"主卧"] floatValue] roomtype:@"主卧"];
                   break;
               case 3:
                   if([[dict objectForKey:@"次卧"] floatValue]>0)
                   ciwoResult += [self makeProjectValue:obj type:3 area:[[dict objectForKey:@"次卧"] floatValue] roomtype:@"次卧"];
                   if([[dict objectForKey:@"客卧"] floatValue]>0)
                   kewoResult +=[self makeProjectValue:obj type:3 area:[[dict objectForKey:@"客卧"] floatValue] roomtype:@"客卧"];
                   if([[dict objectForKey:@"小孩卧房"] floatValue]>0)
                   xiaohaiwofang += [self makeProjectValue:obj type:3 area:[[dict objectForKey:@"小孩卧房"] floatValue] roomtype:@"小孩卧房"];
                   if([[dict objectForKey:@"老人卧房"] floatValue]>0)
                   laorenwofang +=[self makeProjectValue:obj type:3 area:[[dict objectForKey:@"老人卧房"] floatValue] roomtype:@"老人卧房"];
                   break;
               case 4:
                   if([[dict objectForKey:@"厨房"] floatValue]>0)
                    chufangResult +=[self makeProjectValue:obj type:4 area:[[dict objectForKey:@"厨房"] floatValue] roomtype:@"厨房"];
                   break;
               case 5:
                   if([[dict objectForKey:@"公共卫生间"] floatValue]>0)
                    ggwsjResult +=[self makeProjectValue:obj type:5 area:[[dict objectForKey:@"公共卫生间"] floatValue] roomtype:@"公共卫生间"];
                   if([[dict objectForKey:@"主卧卫生间"] floatValue]>0)
                   zhuwowsjResult+=[self makeProjectValue:obj type:5 area:[[dict objectForKey:@"主卧卫生间"] floatValue] roomtype:@"主卧卫生间"];
                   if([[dict objectForKey:@"次卧卫生间"] floatValue]>0)
                   ciwowsjResult += [self makeProjectValue:obj type:5 area:[[dict objectForKey:@"次卧卫生间"] floatValue] roomtype:@"次卧卫生间"];
                   break;
                   
               case 6:
                   if([[dict objectForKey:@"厅阳台"] floatValue]>0)
                   tingyangtaiResult += [self makeProjectValue:obj type:6 area:[[dict objectForKey:@"厅阳台"] floatValue] roomtype:@"厅阳台"];
                   if([[dict objectForKey:@"厨房阳台"] floatValue]>0)
                   chufangyangtaiResult +=[self makeProjectValue:obj type:6 area:[[dict objectForKey:@"厨房阳台"] floatValue] roomtype:@"厨房阳台"];
                   if([[dict objectForKey:@"主卧阳台"] floatValue]>0)
                   zhuwoyangtaiResult +=[self makeProjectValue:obj type:6 area:[[dict objectForKey:@"主卧阳台"] floatValue] roomtype:@"主卧阳台"];
                   break;
               case 7:
                    shuidianResult +=[self makeProjectValue:obj type:7 area:0 roomtype:@"水电安装"];
                   break;
               case 8:
                    zongheResult += [self makeProjectValue:obj type:8 area:0 roomtype:@"综合其他"];
                   break;
               case 9:
                    zongheResult += [self makeProjectValue:obj type:9 area:0 roomtype:@"综合其他"];
                   break;
               case 10:{
                    zcckResult+=[self makeProjectValue:obj type:10 area:0 roomtype:@"主材报价"];
               }
                   break;
                   
               default:
                   break;
           }
       }
    
    NSMutableArray *arr_=[self.all_dictionary objectForKey:@"综合其他"];
    MyhudgetInfoObj *obj=[arr_ lastObject];
    obj.ThePrice=[NSString stringWithFormat:@"%.0f",(ketingResult+cantingResult+zhuwoResult+ciwoResult+kewoResult+xiaohaiwofang+laorenwofang+ggwsjResult+zhuwowsjResult+ciwowsjResult+tingyangtaiResult+chufangyangtaiResult+zhuwoyangtaiResult+chufangResult+shuidianResult+zongheResult)*0.05];
    
    obj.totalprice=[NSString stringWithFormat:@"%f",(ketingResult+cantingResult+zhuwoResult+ciwoResult+kewoResult+xiaohaiwofang+laorenwofang+ggwsjResult+zhuwowsjResult+ciwowsjResult+tingyangtaiResult+chufangyangtaiResult+zhuwoyangtaiResult+chufangResult+shuidianResult+zongheResult)*0.05*1];
    [arr_ replaceObjectAtIndex:[arr_ count]-1 withObject:obj];
    [self.all_dictionary setObject:arr_ forKey:@"综合其他"];
    
    zongheResult+=(ketingResult+cantingResult+zhuwoResult+ciwoResult+kewoResult+xiaohaiwofang+laorenwofang+ggwsjResult+zhuwowsjResult+ciwowsjResult+tingyangtaiResult+chufangyangtaiResult+zhuwoyangtaiResult+chufangResult+shuidianResult+zongheResult)*0.05;

    
    //存储各个居室报价
    NSMutableDictionary *dict_sub=[dict objectForKey:@"各项总价"];
    if (!dict_sub) {
        dict_sub=[NSMutableDictionary dictionary];
    }
    [dict_sub removeAllObjects];
    
    if(ketingResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",ketingResult] forKey:@"客厅"];
        [self.arr_type addObject:@"客厅"];
    }
    if(cantingResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",cantingResult] forKey:@"餐厅"];
        [self.arr_type addObject:@"餐厅"];
    }
    if(zhuwoResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",zhuwoResult] forKey:@"主卧"];
        [self.arr_type addObject:@"主卧"];
    }
    if(ciwoResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",ciwoResult] forKey:@"次卧"];
        [self.arr_type addObject:@"次卧"];
    }
    if(kewoResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",kewoResult] forKey:@"客卧"];
        [self.arr_type addObject:@"客卧"];
    }
    if(xiaohaiwofang){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",xiaohaiwofang] forKey:@"小孩卧房"];
        [self.arr_type addObject:@"小孩卧房"];
    }
    if(laorenwofang){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",laorenwofang] forKey:@"老人卧房"];
        [self.arr_type addObject:@"老人卧房"];
    }
    if(chufangResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",chufangResult] forKey:@"厨房"];
        [self.arr_type addObject:@"厨房"];
    }
    if(ggwsjResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",ggwsjResult] forKey:@"公共卫生间"];
        [self.arr_type addObject:@"公共卫生间"];
    }
    if(zhuwowsjResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",zhuwowsjResult] forKey:@"主卧卫生间"];
        [self.arr_type addObject:@"主卧卫生间"];
    }
    if(ciwowsjResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",ciwowsjResult] forKey:@"次卧卫生间"];
        [self.arr_type addObject:@"次卧卫生间"];
    }
    if(tingyangtaiResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",tingyangtaiResult] forKey:@"厅阳台"];
        [self.arr_type addObject:@"厅阳台"];
    }
    if(chufangyangtaiResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",chufangyangtaiResult] forKey:@"厨房阳台"];
        [self.arr_type addObject:@"厨房阳台"];
    }
    if(zhuwoyangtaiResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",zhuwoyangtaiResult] forKey:@"主卧阳台"];
        [self.arr_type addObject:@"主卧阳台"];
    }
    if(shuidianResult){
        [dict_sub setObject:[NSString stringWithFormat:@"%f",shuidianResult] forKey:@"水电安装"];
        [self.arr_type addObject:@"水电安装"];
    }
    if(zongheResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",zongheResult] forKey:@"综合其他"];
        [self.arr_type addObject:@"综合其他"];
    }
    if(zcckResult){
    [dict_sub setObject:[NSString stringWithFormat:@"%f",zcckResult] forKey:@"主材报价"];
        [self.arr_type addObject:@"主材报价"];
    }
    
    [dict setObject:dict_sub forKey:@"各项总价"];
    [dict writeToFile:_filename atomically:NO];
  
    //计算总金额
    self.totalMoney=0.0;
    self.totalMoney=ketingResult+cantingResult+zhuwoResult+ciwoResult+kewoResult+xiaohaiwofang+laorenwofang+tingyangtaiResult+zhuwoyangtaiResult+chufangyangtaiResult+ggwsjResult+zhuwowsjResult+ciwowsjResult+chufangResult+shuidianResult+zongheResult+zcckResult;
    
    if (self.totalMoney>0)
    [self createTableView];
}
-(float)makeProjectValue:(SqliteHubgetObj *)obj_sq type:(NSInteger)type area:(float)area_qy roomtype:(NSString *)roomtype{
    float theValue = 0, price = 0, theAcre = 0;
    NSInteger isPrice = [obj_sq.IsPrice integerValue];
    NSInteger isFormula = [obj_sq.IsFormula integerValue];
    NSString *thePrice =obj_sq.ThePrice;
    NSString *theFormula = obj_sq.TheFormula;
    if ( isPrice == 0 ) {
        // 固定单价
        price =[thePrice floatValue];
    }
    else {
        // 需要公式计算的单价
        NSString *key =thePrice;
        if ([key isEqualToString:@"a"]) {
//            haveThis++;
//            Log.i("-----项目总价5%", "----------先记录下来，最后计算----------");
            price=0;
        }
        else {
            price =[self CalculatingArea:area_qy type:1 formula:key];
        }
    }
    if ( isFormula == 0 ) {
        // 固定面积
            theAcre = [theFormula floatValue];
    }
    else {
        // 需要公式计算的面积
        NSString *key = theFormula;
        theAcre =[self CalculatingArea:area_qy type:2 formula:key];
    }
    theValue = price * theAcre;

    NSMutableArray *arr_next=[self.all_dictionary objectForKey:roomtype];
    if(!arr_next){
        arr_next = [[NSMutableArray alloc]initWithCapacity:0];
    }
    MyhudgetInfoObj *obj=[[MyhudgetInfoObj alloc]init];
    obj.ProjectName=obj_sq.ProjectName;
    obj.ThePrice=[NSString stringWithFormat:@"%.0f%@",price,obj_sq.TheUnit];
    obj.TheFormula=[NSString stringWithFormat:@"%f",theAcre];
    obj.totalprice=[NSString stringWithFormat:@"%f",theValue];
    obj.TheDesc=obj_sq.TheDesc;
    [arr_next addObject:obj];
    [self.all_dictionary setObject:arr_next forKey:roomtype];
    return theValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

//获得存放数据库文件的地址。
-(NSString *)databaseFilePath
{
    NSString *dbFilePath=[[NSBundle mainBundle]pathForResource:@"db_idiaa_data" ofType:@"sqlite"];
    return dbFilePath;
}

//创建数据库的操作
-(void)creatDatabase
{
    db = [FMDatabase databaseWithPath:[self databaseFilePath]];
    
    [self creatTable];
}

//创建表
-(void)creatTable
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!db) {
        [self creatDatabase];
    }
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    //为数据库设置缓存，提高查询效率
    [db setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![db tableExists:@"T_HOUSE"]){
        [db executeUpdate:@"CREATE TABLE T_HOUSE (GradeType INTEGER DEFAULT (null) ,ContentType INTEGER DEFAULT (null) ,HouseType INTEGER DEFAULT (null) ,StyleType INTEGER DEFAULT (null) ,IsPrice INTEGER DEFAULT (null) ,IsFormula INTEGER DEFAULT (null) ,ProjectName VARCHAR DEFAULT (null) ,ThePrice VARCHAR DEFAULT (null) ,TheUnit VARCHAR DEFAULT (null) ,TheFormula VARCHAR DEFAULT (null) ,TheDesc VARCHAR DEFAULT (null))"];
    }
    
}
-(NSMutableArray *)exquery:(NSString *)string_sql  {
    NSMutableArray *array_main=[NSMutableArray array];
    if([db open]){
        FMResultSet * rs= [db executeQuery:string_sql];
        while ([rs next]){
            SqliteHubgetObj *obj=[[SqliteHubgetObj alloc]init];
            if([rs stringForColumn:@"ContentType"])
                obj.ContentType=[rs stringForColumn:@"ContentType"];
            if([rs stringForColumn:@"IsPrice"])
                obj.IsPrice=[rs stringForColumn:@"IsPrice"];
            if([rs stringForColumn:@"IsFormula"])
                obj.IsFormula=[rs stringForColumn:@"IsFormula"];
            if([rs stringForColumn:@"ProjectName"])
                obj.ProjectName=[rs stringForColumn:@"ProjectName"];
            if([rs stringForColumn:@"ThePrice"])
                obj.ThePrice=[rs stringForColumn:@"ThePrice"];
            if([rs stringForColumn:@"TheUnit"])
                obj.TheUnit=[rs stringForColumn:@"TheUnit"];
            if([rs stringForColumn:@"TheFormula"])
                obj.TheFormula=[rs stringForColumn:@"TheFormula"];
            if([rs stringForColumn:@"TheDesc"])
                obj.TheDesc=[rs stringForColumn:@"TheDesc"];
            else
                obj.TheDesc=@"";
            [array_main addObject:obj];
        }
        [rs close];
    }
    [db close];
    return array_main;
}

- (void)clickNavRightBtn:(id)sender {
    [self startRequestWithString:@"一键发布装修中..."];
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
        [postDict setObject:@"ID0044" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"iOS" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        
        
        NSString *totalMoneyStr = [NSString stringWithFormat:@"%.2f",self.totalMoney];
        
        
        NSDictionary *bodyDic = @{@"communityName":self.addressNameStr,
                                  @"renovationSquare":self.totalAreaStr,
                                  @"renovationBudget":totalMoneyStr,
                                  @"renovationLevel": self.decorationLevelStr,
                                  @"provinceCode":self.provinceCode,
                                  @"cityCode":self.cityCode,
                                  @"areaCode":self.areaCode,
                                  };
        NSString *string02=[bodyDic JSONString];
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
                // NSLog(@"login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopRequest];
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
//                        LoginVC *longVC = [[LoginVC alloc]init];
//                        longVC.delegate = self;
//                        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:longVC];
//                        [self presentViewController:nav animated:YES completion:nil];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 10441) {
                        [self stopRequest];
                        [TLToast showWithText:@"发布成功"];
                     
                        DecorationInfoViewController *decorationInfoVC = [[DecorationInfoViewController alloc]init];
                        decorationInfoVC.hidesBottomBarWhenPushed = YES;
                        decorationInfoVC.fromType=@"MyZhaoBiao";
                        [self.navigationController pushViewController:decorationInfoVC animated:YES];
                        
                        return;
                    }
                    
                    [TLToast showWithText:@"发布失败"];
                    return;
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"发布失败"];
                              });
                          }
                               method:url postDict:post];
    });

}

#pragma mark -
#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
