//
//  MyhouseTypeVC.m
//  IDIAI
//
//  Created by iMac on 14-7-16.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyhouseTypeVC.h"
#import "HexColor.h"
#import "CustomPickerView.h"
#import "TLToast.h"
#import "savelogObj.h"
#import "DistrictView.h"
#import "HRCoreAnimationEffect.h"
#import "MypieChartVC.h"
#import "util.h"
#import "IDIAIAppDelegate.h"
#import "NSStringAdditions.h"
#import "CustomProvinceCApicker.h"
#import "savelogObj.h"

#define klabnameofftag_first 100
#define klabnameofftag_second 200
#define klabnameofftag_three 300

#define klabnameofftag_first_bottom 400
#define klabnameofftag_second_bottom 500
#define klabnameofftag_three_bottom 600

@interface MyhouseTypeVC ()<CustomPickerViewDelegate,UITextFieldDelegate,CustomProvinceCApickerDelegate> {
     UILabel *_districtLabel;
    UITextField *_nameTF;//小区名
    UILabel *_areaUnitLabel;
}

@end

@implementation MyhouseTypeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor blackColor];
    lab_nav_title.text=@"智能报价";
    self.navigationItem.titleView = lab_nav_title;
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.totale_area=0.00;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    self.totale_area=[[dict objectForKey:@"合计"] floatValue];
    
    [mtableview reloadData];
}

- (void)backButtonPressed:(id)sender {
     [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [savelogObj saveLog:@"预算" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:7];
    
    CGRect rect = CGRectMake(100, 0, kMainScreenWidth - 135, 44);
    //区域
    _districtLabel = [[UILabel alloc]initWithFrame:rect];
    _districtLabel.textColor = [UIColor darkTextColor];
    _districtLabel.font = [UIFont systemFontOfSize:14];
    _districtLabel.textAlignment = NSTextAlignmentRight;
    //小区名称
    _nameTF = [[UITextField alloc]initWithFrame:rect];
     _nameTF.placeholder = @"请输入小区名称";
    _nameTF.tag = 101;
    _nameTF.textAlignment = NSTextAlignmentRight;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Village]) {
        self.villageName=[[NSUserDefaults standardUserDefaults]objectForKey:User_Village];
    } else {
        self.villageName=@"";
    }
    //面积单位
    _areaUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth - 20, 0, 10, 10)];
    _areaUnitLabel.textColor = [UIColor darkTextColor];
    _areaUnitLabel.text = @"m²";
    
//    if(IS_iOS7_8)
//        self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
//    [self customizeNavigationBar];
    
    is_scroll=NO;
    mtableview=[[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
//    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
//    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mtableview];
    
    //footerView
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 100)];
    UIButton *analyzeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    analyzeBtn.layer.cornerRadius = 3;
    analyzeBtn.frame = CGRectMake(10, 0, kMainScreenWidth - 10 * 2, 40);
    analyzeBtn.backgroundColor = kThemeColor;
    [analyzeBtn setTitle:@"预算分析" forState:UIControlStateNormal];
    analyzeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [analyzeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [analyzeBtn addTarget:self action:@selector(clickAnalyzeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:analyzeBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 3, kMainScreenWidth, .6)];
    lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.25];
//    [footerView addSubview:lineView];
    
    mtableview.tableFooterView = footerView;

    
    self.data_Array=[NSMutableArray arrayWithCapacity:0];
    self.data_Array2 = [NSMutableArray arrayWithCapacity:10];
    self.data_Array_bottom=[NSMutableArray arrayWithCapacity:0];
        self.data_Array_bottom2=[NSMutableArray arrayWithCapacity:0];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    
    self.data_Array2=[NSMutableArray arrayWithObjects:@"装修风格",@"装修档次", nil];
    
    self.data_Array_bottom2=[NSMutableArray arrayWithCapacity:0];
    if ([[dict objectForKey:@"装修风格"] length]>1) [self.data_Array_bottom2 addObject:[dict objectForKey:@"装修风格"]];
    else [self.data_Array_bottom2 addObject:@"现代简约"];
    if ([[dict objectForKey:@"装修档次"]length]>1) [self.data_Array_bottom2 addObject:[dict objectForKey:@"装修档次"]];
    else [self.data_Array_bottom2 addObject:@"经济适用"];
    self.fourth_Array=[NSMutableArray arrayWithObjects:@"现代简约", @"田园",@"欧式",@"中式",@"美式",@"地中海",@"东南亚", nil];
    self.fifth_Array=[NSMutableArray arrayWithObjects:@"经济适用", @"中档装饰", @"高档豪华", nil];
    
    if([dict objectForKey:@"种类"]) self.first_Array=[NSMutableArray arrayWithObjects:[dict objectForKey:@"种类"], nil];
    else self.first_Array=[NSMutableArray arrayWithCapacity:0];
    if([dict objectForKey:@"户型"]){
        NSString *sting=[dict objectForKey:@"户型"];
        self.second_Array=[NSMutableArray arrayWithObjects:[sting substringWithRange:NSMakeRange(0, 2)],[sting substringWithRange:NSMakeRange(2, 2)],[sting substringWithRange:NSMakeRange(4, 2)],[sting substringWithRange:NSMakeRange(6, 2)], nil];
    }
    else
        self.second_Array=[NSMutableArray arrayWithObjects:@"1室",@"0厅",@"0卫",@"0阳", nil];
    if([dict objectForKey:@"类型"]) self.three_Array=[NSMutableArray arrayWithObjects:[dict objectForKey:@"类型"], nil];
    else self.three_Array=[NSMutableArray arrayWithCapacity:0];
  
        if([dict objectForKey:@"种类"])
       [self.data_Array addObject:[dict objectForKey:@"种类"]];
    else
       [self.data_Array addObject:@"新房装修"];
    if([dict objectForKey:@"户型"])
        [self.data_Array addObject:[dict objectForKey:@"户型"]];
    else
        [self.data_Array addObject:@"1室0厅0卫0阳"];
    if([dict objectForKey:@"类型"])
        [self.data_Array addObject:[dict objectForKey:@"类型"]];
    else
        [self.data_Array addObject:@"普通住宅"];
  
    if([dict objectForKey:@"户型"]){
        NSArray *array_first=[NSArray arrayWithObjects:@"主卧",@"次卧",@"客卧",@"小孩卧房",@"老人卧房", nil];
        NSArray *array_second=[NSArray arrayWithObjects:@"客厅",@"餐厅", nil];
        NSArray *array_three=[NSArray arrayWithObjects:@"公共卫生间",@"主卧卫生间",@"次卧卫生间", nil];
        NSArray *array_four=[NSArray arrayWithObjects:@"厅阳台",@"厨房阳台",@"主卧阳台", nil];
        for(int i=0;i<4;i++){
            @autoreleasepool {
            if(i==0){
                for(int j=0;j<[[[dict objectForKey:@"户型"] substringWithRange:NSMakeRange(0, 1)] intValue];j++){
                    [self.data_Array_bottom addObject:[array_first objectAtIndex:j]];
                }
            }
            if(i==1){
                if([[[dict objectForKey:@"户型"] substringWithRange:NSMakeRange(2, 1)] intValue]!=0)
                    for(int j=0;j<[[[dict objectForKey:@"户型"] substringWithRange:NSMakeRange(2, 1)] intValue];j++){
                        [self.data_Array_bottom addObject:[array_second objectAtIndex:j]];
                    }
            }
            if(i==2){
                if([[[dict objectForKey:@"户型"] substringWithRange:NSMakeRange(4, 1)] intValue]!=0)
                    for(int j=0;j<[[[dict objectForKey:@"户型"] substringWithRange:NSMakeRange(4, 1)] intValue];j++){
                        [self.data_Array_bottom addObject:[array_three objectAtIndex:j]];
                    }
            }
            if(i==3){
                if([[[dict objectForKey:@"户型"] substringWithRange:NSMakeRange(6, 1)] intValue]!=0)
                    for(int j=0;j<[[[dict objectForKey:@"户型"] substringWithRange:NSMakeRange(6, 1)] intValue];j++){
                        [self.data_Array_bottom addObject:[array_four objectAtIndex:j]];
                    }
            }
        }
    }
    [self.data_Array_bottom addObject:@"厨房"];
    [self.data_Array_bottom addObject:@"合计"];
    }
    else{
        NSArray *arr_=[NSArray arrayWithObjects:@"主卧",@"厨房",@"合计", nil];
        for(int j=0;j<3;j++){
            @autoreleasepool {
            [self.data_Array_bottom addObject:[arr_ objectAtIndex:j]];
            }
        }
    }
    
    
    //获取省市区id
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceCode] length]>1) self.provinceCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceCode];
    else self.provinceCode=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_CityCode] length]>1) self.cityCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_CityCode];
    else self.cityCode=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaCode] length]>1) self.areaCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaCode];
    else self.areaCode=@"";
    //获取省市区名字
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceName] length]>0) self.provinceName=[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceName];
    else self.provinceName=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_CityName] length]>0) self.cityName=[[NSUserDefaults standardUserDefaults] objectForKey:User_CityName];
    else self.cityName=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaName] length]>0) self.areaName=[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaName];
    else self.areaName=@"";
    
    if(!arr_Province) arr_Province=[NSMutableArray arrayWithObjects:@[self.provinceName,self.provinceCode],@[self.cityName,self.cityCode],@[self.areaName,self.areaCode],nil];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 2;
    } else if (section==2) {
        return 3;
    } else {
        return [self.data_Array_bottom count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"MyHouseAddressCell%d%d",indexPath.section,indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"区域";
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            [cell.contentView addSubview:_districtLabel];
            _districtLabel.textAlignment = NSTextAlignmentRight;
            
            
            if([self.provinceName length]>=1){
                if([self.provinceName isEqualToString:self.cityName]){
                    _districtLabel.text = [NSString stringWithFormat:@"%@%@",self.provinceName,self.areaName];
                    _districtLabel.textColor=[UIColor darkTextColor];
                }
                else{
                    _districtLabel.text = [NSString stringWithFormat:@"%@%@%@",self.provinceName,self.cityName,self.areaName];
                    _districtLabel.textColor =  [UIColor darkTextColor];
                }
            }
            else{
                _districtLabel.text = @"请选择区域";
                _districtLabel.textColor = kFontPlacehoderColor;
            }
            
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"小区名称";
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            [cell.contentView addSubview:_nameTF];
            _nameTF.textAlignment = NSTextAlignmentRight;
            _nameTF.textColor = [UIColor darkTextColor];
            _nameTF.font = [UIFont systemFontOfSize:14];
            _nameTF.delegate = self;
            _nameTF.tag = 101;
            _nameTF.text =self.villageName;
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        NSString *cellid= [NSString stringWithFormat:@"mycellid%d%d",indexPath.section,indexPath.row];
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, -2, kMainScreenWidth, 2)];
            line.image=[UIImage imageNamed:@"细分割线.png"];
//            [cell addSubview:line];
        }
        
        UILabel *Name_bottom=(UILabel *)[cell viewWithTag:klabnameofftag_first+indexPath.row];
        if(!Name_bottom)
            Name_bottom=[[UILabel alloc]initWithFrame:CGRectMake(15, 7, 100, 30)];
        Name_bottom.tag=klabnameofftag_first+indexPath.row;
        Name_bottom.backgroundColor=[UIColor clearColor];
//        Name_bottom.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];;
        Name_bottom.textAlignment=NSTextAlignmentLeft;
        Name_bottom.font=[UIFont systemFontOfSize:17];
        Name_bottom.text=[self.data_Array2 objectAtIndex:indexPath.row];
        [cell addSubview:Name_bottom];
        
        UILabel *Name_value=(UILabel *)[cell viewWithTag:klabnameofftag_second+indexPath.row];
        if(!Name_value)
            Name_value=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth - 135, 7, 100, 30)];
        Name_value.tag=klabnameofftag_second+indexPath.row;
//        Name_value.backgroundColor=[UIColor clearColor];
//        Name_value.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];;
        Name_value.textAlignment=NSTextAlignmentRight;
        Name_value.font=[UIFont systemFontOfSize:14];
        Name_value.text=[self.data_Array_bottom2 objectAtIndex:indexPath.row];
        Name_value.textColor = [UIColor darkTextColor];
        [cell addSubview:Name_value];
        
        UIImageView *icon_image=(UIImageView *)[cell viewWithTag:klabnameofftag_three+indexPath.row];
        if(!icon_image)
            icon_image=[[UIImageView alloc]initWithFrame:CGRectMake(290, 15, 20, 30)];
        icon_image.image=[UIImage imageNamed:@"展开图标.png"];
        icon_image.tag=klabnameofftag_three+indexPath.row;
//        [cell addSubview:icon_image];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;

        
    } else if (indexPath.section==2) {
        NSString *cellid_top=[NSString stringWithFormat:@"mycellid_second_%d_%d",indexPath.row,indexPath.section];;
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid_top];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid_top];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if(indexPath.row!=2){
            UIImageView *line_=[[UIImageView alloc]initWithFrame:CGRectMake(0, 69, kMainScreenWidth, 2)];
            line_.image=[UIImage imageNamed:@"细分割线.png"];
//            [cell addSubview:line_];
            }
        }
        NSArray *arr_type=[NSArray arrayWithObjects:@"种类",@"户型",@"类型", nil];
        
        UILabel *typeName=(UILabel *)[cell viewWithTag:klabnameofftag_first+indexPath.row];
        typeName.textAlignment = NSTextAlignmentRight;
        if(!typeName)
            typeName=[[UILabel alloc]initWithFrame:CGRectMake(15, 7, 80, 30)];
        typeName.tag=klabnameofftag_first+indexPath.row;
            typeName.backgroundColor=[UIColor clearColor];
//            typeName.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:0.6];
            typeName.textAlignment=NSTextAlignmentLeft;
            typeName.font=[UIFont systemFontOfSize:17];
        typeName.text=[arr_type objectAtIndex:indexPath.row];
            [cell addSubview:typeName];
        
        UILabel *Name=(UILabel *)[cell viewWithTag:klabnameofftag_second+indexPath.row];
        Name.textAlignment = NSTextAlignmentRight;
        if(!Name)
            Name=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth - 135, 7, 100, 30)];
         Name.tag=klabnameofftag_second+indexPath.row;
        Name.backgroundColor=[UIColor clearColor];
//        Name.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];
        Name.textColor = [UIColor darkTextColor];
        Name.textAlignment=NSTextAlignmentRight;
        Name.font=[UIFont systemFontOfSize:14];
        Name.text=[self.data_Array objectAtIndex:indexPath.row];
        [cell addSubview:Name];
        
        UIImageView *icon_image=(UIImageView *)[cell viewWithTag:klabnameofftag_three+indexPath.row];
         if(!icon_image)
             icon_image=[[UIImageView alloc]initWithFrame:CGRectMake(290, 20, 20, 30)];
             icon_image.image=[UIImage imageNamed:@"展开图标.png"];
            icon_image.tag=klabnameofftag_three+indexPath.row;
//           [cell addSubview:icon_image];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       return cell;
    }
    
    else {
        NSString *cellid_bottom=[NSString stringWithFormat:@"mycellid_second_%d_%d",indexPath.row,indexPath.section];
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid_bottom];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid_bottom];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UIImageView *line_=[[UIImageView alloc]initWithFrame:CGRectMake(0, 69, kMainScreenWidth, 2)];
            line_.image=[UIImage imageNamed:@"细分割线.png"];
//            [cell addSubview:line_];
            UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"展开图标.png"]];
            iv.frame = CGRectMake(200, 0, 30, 30);
        }
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
        UILabel *areaUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth - 40, 7, 30, 30)];
        areaUnitLabel.textAlignment = NSTextAlignmentRight;
        areaUnitLabel.text = @"m²";
        areaUnitLabel.textColor = [UIColor darkTextColor];
        [cell.contentView addSubview:areaUnitLabel];
        //获取存储的房型面积
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
        if (!dict) {
            dict=[NSMutableDictionary dictionary];
        }
    
        UILabel *Name_bottom=(UILabel *)[cell.contentView viewWithTag:klabnameofftag_first_bottom+indexPath.row];
        if(!Name_bottom)
            Name_bottom=[[UILabel alloc]initWithFrame:CGRectMake(15, 7, 100, 30)];
         Name_bottom.tag=klabnameofftag_first_bottom+indexPath.row;
        Name_bottom.backgroundColor=[UIColor clearColor];
//        Name_bottom.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];;
//        Name_bottom.textAlignment=NSTextAlignmentRight;
        Name_bottom.font=[UIFont systemFontOfSize:17];
        Name_bottom.text=[self.data_Array_bottom objectAtIndex:indexPath.row];
        [cell.contentView addSubview:Name_bottom];
        
        if(indexPath.row!=([self.data_Array_bottom count]-1)){
          
            UIImageView *image_bg=(UIImageView *)[cell.contentView viewWithTag:klabnameofftag_three_bottom+indexPath.row];
            if(!image_bg)
                image_bg=[[UIImageView alloc]initWithFrame:CGRectMake(120, 7, 180, 50)];
            image_bg.userInteractionEnabled=YES;
            image_bg.tag=klabnameofftag_three_bottom+indexPath.row;
            image_bg.image=[UIImage imageNamed:@"我的房型输入框.png"];
//            [cell.contentView addSubview:image_bg];
            
           UITextField *textf_input=(UITextField *)[cell.contentView viewWithTag:klabnameofftag_second_bottom+indexPath.row];
           if(!textf_input)
           textf_input=[[UITextField alloc]initWithFrame:CGRectMake(105, 7, kMainScreenWidth - 140, 30)];
            textf_input.textAlignment = NSTextAlignmentRight;
            textf_input.delegate=self;
            textf_input.keyboardType=UIKeyboardTypeDecimalPad;
            textf_input.inputAccessoryView=[self createToolbar];
            textf_input.tag=klabnameofftag_second_bottom+indexPath.row;
//           textf_input.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];
            textf_input.textColor = [UIColor darkTextColor];
           textf_input.returnKeyType=UIReturnKeyDone;
            textf_input.text=[dict objectForKey:Name_bottom.text];
           [cell.contentView addSubview:textf_input];

        } else {
            
            UILabel *total_lab=(UILabel *)[cell.contentView viewWithTag:1000];
            if(!total_lab)
                total_lab=[[UILabel alloc]initWithFrame:CGRectMake(105, 7, kMainScreenWidth - 140, 30)];
            total_lab.tag=1000;
            total_lab.backgroundColor=[UIColor clearColor];
//            total_lab.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];
            total_lab.textColor = [UIColor darkTextColor];
            total_lab.textAlignment=NSTextAlignmentRight;
            total_lab.font=[UIFont systemFontOfSize:17];
            total_lab.text=[NSString stringWithFormat:@"%.2f",self.totale_area];
            [cell.contentView addSubview:total_lab];
            
        }
      
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self selectIndecPath:indexPath.row section:indexPath.section];
    
//    if (tableView.tag == 101) {
//        _indexPath = indexPath;
//        [mtableview reloadData];
//        [self dismiss];
////        //保存装修地址
//        [[NSUserDefaults standardUserDefaults]setObject:@(_indexPath.row) forKey:kUDDecorationDistrictOfRow];
//        [[NSUserDefaults standardUserDefaults]setObject:_nameTF.text forKey:kUDDecorationAddress];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//
//    } else {
//        if (indexPath.section == 0 && indexPath.row == 0) {
//            [self show];
//        }
//    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (tableView.tag == 101) {
//        return 44;
//    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 80, 44)];
        titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.03];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(0, 0, 40, 30);
        titleLabel.center = titleView.center;
        titleLabel.text = @"区域";
        [titleView addSubview:titleLabel];
        return titleView;
    }
    return nil;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(is_scroll==YES){
        [self.view endEditing:YES];
//        [mtableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.index_selected inSection:3] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        is_scroll=NO;
    }
}


#pragma mark -
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //huangrun
    if (textField.tag == 101) {
        return;
    }
    
    is_scroll=YES;
    
    NSInteger index=textField.tag-klabnameofftag_second_bottom;
//    [mtableview setContentOffset:CGPointMake(0, 250+index*70) animated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //huangrun
    if (textField.tag == 101) {
        return;
    }
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    if (!dict) {
        dict=[NSMutableDictionary dictionary];
    }
    
    self.index_selected=textField.tag-klabnameofftag_second_bottom;
    NSString *lab_key=[self.data_Array_bottom objectAtIndex:textField.tag-klabnameofftag_second_bottom];
    if(![textField.text isEqual:[NSNull null]]&&[textField.text length])
        [dict setObject:textField.text forKey:lab_key];
    else
        [dict setObject:@"" forKey:lab_key];
    
    //保存面积到plist文件
    [dict writeToFile:_filename atomically:NO];
    
    //下面是计算总面积
    self.totale_area=0.00;
    for (int i=0; i<[self.data_Array_bottom count]-1; i++) {
        @autoreleasepool {
        NSMutableDictionary *dict_get=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
        if (!dict_get) {
            dict_get=[NSMutableDictionary dictionary];
        }
        self.totale_area+=[[dict_get objectForKey:[self.data_Array_bottom objectAtIndex:i]] floatValue];
        }
    }

    [dict setObject:[NSString stringWithFormat:@"%.2f",self.totale_area] forKey:@"合计"];
    
    //保存面积到plist文件
    [dict writeToFile:_filename atomically:NO];
    
    UITableViewCell *cell=[mtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.data_Array_bottom count]-1 inSection:3]];
    UILabel *total_lab=(UILabel *)[cell.contentView viewWithTag:1000];
    total_lab.text=[NSString stringWithFormat:@"%.2f",self.totale_area];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark _
#pragma mark - SaveFileToDisk

-(void)saveFileToDisk:(NSMutableDictionary *)dict{
    NSString *aPath=[NSString stringWithFormat:@"%@/Documents/User_Area.plist",NSHomeDirectory()];
    [dict writeToFile:aPath atomically:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}
-(void)selectIndecPath:(NSInteger)index section:(NSInteger)section{
    [self.view endEditing:YES];
    if(section==0) {
        if (index == 0) {
            CustomProvinceCApicker *picker_pro = [[CustomProvinceCApicker alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250)title:@"选择省市区"];
            picker_pro.delegate=self;
            [picker_pro setSelectedTitles:arr_Province animated:YES];
            [picker_pro show];
        }
        
    }
    else if (section == 1) {
        if (index == 0) {
            CustomPickerView *picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250) title:@"装修风格"];
            picker.delegate=self;
            [picker setTag:4];
            [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                             [NSArray arrayWithObjects:@"现代简约", @"田园",@"美式",@"中式",@"欧式",@"地中海",@"东南亚", nil],
                                             nil]];
            [picker setSelectedTitles:[NSArray arrayWithObjects:[self.data_Array_bottom2 firstObject],nil] animated:YES];
            [picker show];
        }
        if (index == 1) {
            CustomPickerView *picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250)title:@"装修档次"];
            picker.delegate=self;
            [picker setTag:5];
            [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                             [NSArray arrayWithObjects:@"经济适用", @"中档装饰", @"高档豪华", nil],
                                             nil]];
            [picker setSelectedTitles:[NSArray arrayWithObjects:[self.data_Array_bottom2 lastObject],nil] animated:YES];
            [picker show];
        }
    }
    
    else if (section == 2) {
        if(index==0){
        
            CustomPickerView *picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250)title:@"种类"];
            picker.delegate=self;
            [picker setTag:1];
            [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                         [NSArray arrayWithObjects:@"新房装修", @"旧房翻新", nil],
                                         nil]];
            [picker setSelectedTitles:self.first_Array animated:YES];
            picker.alpha=0.0;
            [picker show];
        }
    
        if(index==1){
            CustomPickerView *picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250)title:@"户型"];
            picker.delegate=self;
            [picker setTag:2];
            [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                [NSArray arrayWithObjects:@"1室", @"2室", @"3室", @"4室", @"5室", nil],
                                [NSArray arrayWithObjects:@"0厅", @"1厅", @"2厅", nil],
                                [NSArray arrayWithObjects:@"0卫", @"1卫", @"2卫", @"3卫", nil],
                                [NSArray arrayWithObjects:@"0阳", @"1阳", @"2阳", @"3阳", nil],
                                 nil]];
            [picker setSelectedTitles:self.second_Array animated:YES];
            [picker show];
        }
    
        if(index==2){
            CustomPickerView *picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250)title:@"类型"];
            picker.delegate=self;
            [picker setTag:3];
            [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                         [NSArray arrayWithObjects:@"普通住宅", @"复式", @"别墅", nil],
                                         nil]];
            [picker setSelectedTitles:self.three_Array animated:YES];
            [picker show];
        }
    }
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
        if(i==0) {
            self.provinceCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
            self.provinceName=[arr objectAtIndex:0];
        }
        else if(i==1) {
            self.cityCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
            self.cityName=[arr objectAtIndex:0];
        }
        else if(i==2) {
            self.areaCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
            self.areaName=[arr objectAtIndex:0];
        }
    }
    
    //台湾、澳门、香港没有市区
    if([titles count]==1){
        self.cityCode=@"";
        self.areaCode=@"";
    }
    
    _districtLabel.text=province_name;
    _districtLabel.textColor=[UIColor darkTextColor];

}

-(void)actionSheetPickerView:(CustomPickerView *)pickerView didSelectTitles:(NSArray *)titles{
     NSMutableString *string=[NSMutableString stringWithCapacity:0];
    if(pickerView.tag==1){
        [self.first_Array removeAllObjects];
        for(NSString *name in titles){
            [string appendString:name];
            [self.first_Array addObject:name];
        }
        [self.data_Array replaceObjectAtIndex:0 withObject:string];
    }
    if(pickerView.tag==2){
        
        [savelogObj saveLog:@"选择房型" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:8];
        
        [self.data_Array_bottom removeAllObjects];
        [self.second_Array removeAllObjects];
        for(NSString *name in titles){
            [string appendString:name];
            [self.second_Array addObject:name];
        }
         [self.data_Array replaceObjectAtIndex:1 withObject:string];
        
        NSArray *array_first=[NSArray arrayWithObjects:@"主卧",@"次卧",@"客卧",@"小孩卧房",@"老人卧房", nil];
        NSArray *array_second=[NSArray arrayWithObjects:@"客厅",@"餐厅", nil];
        NSArray *array_three=[NSArray arrayWithObjects:@"公共卫生间",@"主卧卫生间",@"次卧卫生间", nil];
        NSArray *array_four=[NSArray arrayWithObjects:@"厅阳台",@"厨房阳台",@"主卧阳台", nil];
        if(pickerView.tag==2){
            for(int i=0;i<4;i++){
                if(i==0){
                    for(int j=0;j<[[string substringWithRange:NSMakeRange(0, 1)] intValue];j++){
                        [self.data_Array_bottom addObject:[array_first objectAtIndex:j]];
                    }
                }
                if(i==1){
                    if([[string substringWithRange:NSMakeRange(2, 1)] intValue]!=0)
                        for(int j=0;j<[[string substringWithRange:NSMakeRange(2, 1)] intValue];j++){
                            [self.data_Array_bottom addObject:[array_second objectAtIndex:j]];
                        }
                }
                if(i==2){
                    if([[string substringWithRange:NSMakeRange(4, 1)] intValue]!=0)
                        for(int j=0;j<[[string substringWithRange:NSMakeRange(4, 1)] intValue];j++){
                            [self.data_Array_bottom addObject:[array_three objectAtIndex:j]];
                        }
                }
                if(i==3){
                    if([[string substringWithRange:NSMakeRange(6, 1)] intValue]!=0)
                        for(int j=0;j<[[string substringWithRange:NSMakeRange(6, 1)] intValue];j++){
                            [self.data_Array_bottom addObject:[array_four objectAtIndex:j]];
                        }
                }
            }
        }
        [self.data_Array_bottom addObject:@"厨房"];
        [self.data_Array_bottom addObject:@"合计"];
    }
    if(pickerView.tag==3){
        [self.three_Array removeAllObjects];
        for(NSString *name in titles){
            [string appendString:name];
            [self.three_Array addObject:name];
        }
         [self.data_Array replaceObjectAtIndex:2 withObject:string];
    }
    
    if(pickerView.tag==4){
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
        if (!dict) {
            dict =[NSMutableDictionary dictionary];
        }

        [self.data_Array_bottom2 replaceObjectAtIndex:0 withObject:[titles firstObject]];
        [dict setObject:[titles firstObject] forKey:@"装修风格"];
        [dict writeToFile:_filename atomically:NO];

        self.villageName=_nameTF.text;
        [mtableview reloadData];
        
        return;
    }
    if(pickerView.tag==5){
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
        if (!dict) {
            dict =[NSMutableDictionary dictionary];
        }

        [self.data_Array_bottom2 replaceObjectAtIndex:1 withObject:[titles firstObject]];
        [dict setObject:[titles firstObject] forKey:@"装修档次"];
        [dict writeToFile:_filename atomically:NO];
        
        self.villageName=_nameTF.text;
        [mtableview reloadData];
        
        return;
    }
    
    self.totale_area=0.00;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    for (int i=0; i<[self.data_Array_bottom count]-1; i++) {
        if (!dict) {
            dict=[NSMutableDictionary dictionary];
        }
        NSLog(@"%@",[self.data_Array_bottom objectAtIndex:i]);
        NSLog(@"%f",[[dict objectForKey:[self.data_Array_bottom objectAtIndex:i]] floatValue]);
        self.totale_area+=[[dict objectForKey:[self.data_Array_bottom objectAtIndex:i]] floatValue];
    }
    
     self.villageName=_nameTF.text;
    
    [mtableview reloadData];

    [dict setObject:[self.data_Array objectAtIndex:0] forKey:@"种类"];
    [dict setObject:[self.data_Array objectAtIndex:1] forKey:@"户型"];
    [dict setObject:[self.data_Array objectAtIndex:2] forKey:@"类型"];
//        [dict setObject:[self.data_Array_bottom2 objectAtIndex:0] forKey:@"装修风格"];
//        [dict setObject:[self.data_Array_bottom2 objectAtIndex:0] forKey:@"装修档次"];
    //保存面积到plist文件
    [dict writeToFile:_filename atomically:NO];
    
    
    NSArray *arr_second=[NSArray arrayWithArray:self.data_Array_bottom];
    NSArray *text_arr=[NSArray arrayWithArray:arr_second];
    NSArray *path_second = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path_secon = [path_second objectAtIndex:0];
    NSString* _filename_second = [doc_path_secon stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict_seond=[NSMutableDictionary dictionaryWithContentsOfFile:_filename_second];
    if (!dict_seond) {
            dict_seond=[NSMutableDictionary dictionary];
    }
    NSArray *all_arr_=[[NSArray alloc]initWithObjects:@"主卧",@"次卧",@"客卧",@"小孩卧房",@"老人卧房",@"客厅",@"餐厅",@"公共卫生间",@"主卧卫生间",@"次卧卫生间",@"厅阳台",@"厨房阳台",@"主卧阳台",nil];
    for (int i=0; i<[all_arr_ count]; i++) {
        if ([text_arr indexOfObject:[all_arr_ objectAtIndex:i]]>15) {
            [dict_seond removeObjectForKey:[all_arr_ objectAtIndex:i]];
        }
    }
    [dict_seond setObject:[NSString stringWithFormat:@"%f",self.totale_area] forKey:@"合计"];
    //保存面积到plist文件
    [dict_seond writeToFile:_filename atomically:NO];
}

/*
 填面积时的文本：
 室：主卧、次卧、客卧、小孩卧房、老人卧房
 厅：客厅、餐厅
 卫：公共卫生间、主卧卫生间、次卧卫生间
 阳：厅阳台、厨房阳台、主卧阳台
 厨房
*/


//判断是否为整形：

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

-(UIToolbar*) createToolbar {
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *space3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(textFieldDone)];
    toolBar.items = @[space1, space2, space3, done];
    
    return toolBar;
}

-(void)textFieldDone{
    [self.view endEditing:YES];
//    [mtableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.index_selected inSection:3] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark - 点击预算分析按钮
- (void)clickAnalyzeBtn:(UIButton *)btn {
    if (_nameTF.text.length <2 || _nameTF.text.length>30) {
        [TLToast showWithText:@"请填写2～30位的小区名称"];
        return;
    }
  
    for (int i = 0; i < self.data_Array_bottom.count; i++) {
        UITableViewCell *cell = [mtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:3]];
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                if (![util checkIsPureFloat:((UITextField *)view).text display:@"面积"]) {
                    return;
                }
            }
        }
    }       //增加   // by jiangt
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    if(!dict) dict=[NSMutableDictionary dictionary];
    NSLog(@"%f",[[dict objectForKey:@"合计"] floatValue]);
    if([[dict objectForKey:@"合计"] floatValue]>10000){
        [TLToast showWithText:@"面积只能为1～10000平米"];
        return;
    }     //增加  by jiangt
    
    if([[dict objectForKey:@"合计"] integerValue]>0){
        MypieChartVC *pievc=[[MypieChartVC alloc]init];
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
        
        NSInteger index_one;
        NSInteger index_two;
        NSInteger index_three;
        NSInteger index_four;
        NSInteger index_five;
        NSInteger index_six;
        NSInteger index_seven;
        NSInteger index_eight;
        
        NSString *strin_house=[dict objectForKey:@"户型"];
        if ([[strin_house substringWithRange:NSMakeRange(0, 1)] intValue]>=2) {
            index_one=2;
            index_two=3;
        }
        else{
            index_one=2;
            index_two=2;
        }
        if ([[strin_house substringWithRange:NSMakeRange(2, 1)] intValue]==0) {
            index_three=2;
            index_four=2;
        }
        else  if ([[strin_house substringWithRange:NSMakeRange(2, 1)] intValue]==1) {
            index_three=0;
            index_four=2;
        }
        else{
            index_three=0;
            index_four=1;
        }
        
        if ([[strin_house substringWithRange:NSMakeRange(4, 1)] intValue]==0) {
            index_five=2;
        }
        else{
            index_five=5;
            
        }
        
        if ([[strin_house substringWithRange:NSMakeRange(6, 1)] intValue]==0) {
            index_six=2;
        }
        else{
            index_six=6;
        }
        index_seven=4;
        
        
        NSArray *arr_house=[NSArray arrayWithObjects:@"普通住宅", @"复式", @"别墅", nil];
        NSArray *arr_type=[NSArray arrayWithObjects:@"新房装修", @"旧房翻新", nil];
        
        NSInteger index=[arr_type indexOfObject:[dict objectForKey:@"种类"]];
        if (index==0) {
            index_eight=8;
        }
        else{
            index_eight=9;
        }
        
        pievc.sql_string=[NSString stringWithFormat:@"select * from T_HOUSE where GradeType=%d and ContentType in (%d,%d,%d,%d,%d,%d,%d,7,%d,10) and HouseType in (%d,3) and StyleType in (%d,7)",[self.fifth_Array indexOfObject:[self.data_Array_bottom2 lastObject]],index_one,index_two,index_three,index_four,index_five,index_six,index_seven,index_eight,[arr_house indexOfObject:[dict objectForKey:@"类型"]],[self.fourth_Array indexOfObject:[self.data_Array_bottom2 firstObject]]];
        
        
        //保存装修地址
//        [[NSUserDefaults standardUserDefaults]setObject:@(_indexPath.row) forKey:kUDDecorationDistrictOfRow];
//        [[NSUserDefaults standardUserDefaults]setObject:_nameTF.text forKey:kUDDecorationAddress];
//        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if (!self.provinceCode) {
            [TLToast showWithText:@"请填选择名称"];
            return;
        }
        
        pievc.provinceCode=self.provinceCode;
        pievc.cityCode=self.cityCode;
        pievc.areaCode=self.areaCode;
        
        pievc.addressNameStr = _nameTF.text;
        
        if (!pievc.addressNameStr || [NSString isEmptyOrWhitespace:pievc.addressNameStr]) {
            [TLToast showWithText:@"请填写小区名称"];
            return;
        }
        
        pievc.totalAreaStr = [NSString stringWithFormat:@"%.2f",self.totale_area];
        NSString *levelStr = [self.data_Array_bottom2 objectAtIndex:1];
        if ([levelStr isEqualToString:@"经济适用"]) {
            pievc.decorationLevelStr = @"0";
        } else if ([levelStr isEqualToString:@"中档装饰"]) {
            pievc.decorationLevelStr = @"1";
        } else if ([levelStr isEqualToString:@"高档豪华"]) {
            pievc.decorationLevelStr = @"2";
        }

        [self.navigationController pushViewController:pievc animated:YES];
    }
    else{
        [TLToast showWithText:@"请填写房屋信息,然后点击\"预算分析\"进行计算." topOffset:220.0f duration:1.5];
    }
}

@end
