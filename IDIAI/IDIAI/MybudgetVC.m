//
//  MybudgetVC.m
//  IDIAI
//
//  Created by iMac on 14-7-21.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MybudgetVC.h"
#import "HexColor.h"
#import "MyhouseTypeVC.h"
#import "CustomPickerView.h"
#import "MypieChartVC.h"
#import "JSONKit.h"
#import "savelogObj.h"
#import "TLToast.h"

#define klabnameofftag_first 100
#define klabnameofftag_second 200
#define klabnameofftag_three 300

@interface MybudgetVC ()<CustomPickerViewDelegate>

@end

@implementation MybudgetVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:YES];
    
    UIImageView *nav_bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"导航条.png"]];
    nav_bg.frame=CGRectMake(0, 20, 320, 44);
    nav_bg.userInteractionEnabled=YES;
    [self.view addSubview:nav_bg];
    
    CGRect frame = CGRectMake(80, 29, 160, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    label.text = @"我的预算基础";
    [self.view addSubview:label];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(10, 25, 50, 28)];
    rightButton.tag=1;
    [rightButton setBackgroundImage:[UIImage imageNamed:@"返回键.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(backTouched:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:statusBarView];
}
-(void)backTouched:(UIButton *)btn{
    if(btn.tag==1)
    [self.navigationController popViewControllerAnimated:YES];
    else if (btn.tag==2){
        MyhouseTypeVC *housevc=[[MyhouseTypeVC alloc]init];
        [self.navigationController pushViewController:housevc animated:YES];
    }
    else if (btn.tag==3){
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* doc_path = [path objectAtIndex:0];
        NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
        if(!dict) dict=[NSMutableDictionary dictionary];
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
        
        pievc.sql_string=[NSString stringWithFormat:@"select * from T_HOUSE where GradeType=%d and ContentType in (%d,%d,%d,%d,%d,%d,%d,7,%d,10) and HouseType in (%d,3) and StyleType in (%d,7)",[self.second_Array indexOfObject:[self.data_Array_bottom lastObject]],index_one,index_two,index_three,index_four,index_five,index_six,index_seven,index_eight,[arr_house indexOfObject:[dict objectForKey:@"类型"]],[self.first_Array indexOfObject:[self.data_Array_bottom firstObject]]];
        
        [self.navigationController pushViewController:pievc animated:YES];
        }
        else{
            [TLToast showWithText:@"请填写房屋信息" topOffset:220.0f duration:1.5];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"用户进入了房屋预算" userID:[NSString stringWithFormat:@" %d",[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:7];
    if(IS_iOS7_8)
        self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
    [self customizeNavigationBar];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    
    self.data_Array=[NSMutableArray arrayWithObjects:@"装修风格",@"装修档次", nil];
    self.data_Array_bottom=[NSMutableArray arrayWithCapacity:0];
    if ([[dict objectForKey:@"装修风格"] length]>1) [self.data_Array_bottom addObject:[dict objectForKey:@"装修风格"]];
    else [self.data_Array_bottom addObject:@"现代简约"];
    if ([[dict objectForKey:@"装修档次"]length]>1) [self.data_Array_bottom addObject:[dict objectForKey:@"装修档次"]];
    else [self.data_Array_bottom addObject:@"经济适用"];
    
    mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    mtableview.backgroundColor=[UIColor clearColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mtableview];
    
   // [self createTableviewheader];
    [self createTableviewfooter];
    
     self.first_Array=[NSMutableArray arrayWithObjects:@"现代简约", @"田园",@"欧式",@"中式",@"美式",@"地中海",@"东南亚", nil];
     self.second_Array=[NSMutableArray arrayWithObjects:@"经济适用", @"中档装饰", @"高档豪华", nil];
}

-(void)createTableviewheader{
    
    UIView *header_bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    header_bg.backgroundColor=[UIColor clearColor];
    mtableview.tableHeaderView=header_bg;
    
    CGRect frame = CGRectMake(10, 10, 300, 120);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18.0];
    label.numberOfLines=5;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithHexString:@"#6d2907" alpha:1.0];
    label.text = @"本预算工具将根据我的房型中的信息做出装修预算。预算价格因地理位置，定制需求不同有一定的差异，运算结果仅供参考，让你对所需费用的区间有所了解！";
    [header_bg addSubview:label];
    
    UIButton *Button_house = [UIButton buttonWithType:UIButtonTypeCustom];
    [Button_house setFrame:CGRectMake(190, 140, 120, 50)];
    Button_house.tag=2;
    [Button_house setTitle:@"我的房型" forState:UIControlStateNormal];
    [Button_house setTitleColor:[UIColor colorWithHexString:@"#6d2907" alpha:1.0] forState:UIControlStateNormal];
    [Button_house setBackgroundImage:[UIImage imageNamed:@"确认按钮.png"] forState:UIControlStateNormal];
    [Button_house setBackgroundImage:[UIImage imageNamed:@"确认按钮点击效果.png"] forState:UIControlStateHighlighted];
    [Button_house addTarget:self
                     action:@selector(backTouched:)
           forControlEvents:UIControlEventTouchUpInside];
    Button_house.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0, 8.0, 0.0);
    [header_bg addSubview:Button_house];
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 197, kMainScreenWidth, 3)];
    line.image=[UIImage imageNamed:@"粗分割线.png"];
    [header_bg addSubview:line];
}

-(void)createTableviewfooter{
    UIView *footer_bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    footer_bg.backgroundColor=[UIColor clearColor];
    mtableview.tableFooterView=footer_bg;
    
    UIButton *Button_next = [UIButton buttonWithType:UIButtonTypeCustom];
    [Button_next setFrame:CGRectMake(20, 30, 280, 60)];
    Button_next.tag=3;
    [Button_next setTitle:@"下一步" forState:UIControlStateNormal];
    [Button_next setTitleColor:[UIColor colorWithHexString:@"#6d2907" alpha:1.0] forState:UIControlStateNormal];
    [Button_next setBackgroundImage:[UIImage imageNamed:@"确认按钮.png"] forState:UIControlStateNormal];
    [Button_next setBackgroundImage:[UIImage imageNamed:@"确认按钮点击效果.png"] forState:UIControlStateHighlighted];
    [Button_next addTarget:self
                     action:@selector(backTouched:)
           forControlEvents:UIControlEventTouchUpInside];
    Button_next.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0, 8.0, 0.0);
    [footer_bg addSubview:Button_next];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycellid";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, -2, kMainScreenWidth, 2)];
        line.image=[UIImage imageNamed:@"细分割线.png"];
        [cell addSubview:line];
    }
    
    UILabel *Name_bottom=(UILabel *)[cell viewWithTag:klabnameofftag_first+indexPath.row];
    if(!Name_bottom)
        Name_bottom=[[UILabel alloc]initWithFrame:CGRectMake(20, 15, 100, 30)];
    Name_bottom.tag=klabnameofftag_first+indexPath.row;
    Name_bottom.backgroundColor=[UIColor clearColor];
    Name_bottom.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];;
    Name_bottom.textAlignment=NSTextAlignmentLeft;
    Name_bottom.font=[UIFont systemFontOfSize:18];
    Name_bottom.text=[self.data_Array objectAtIndex:indexPath.row];
    [cell addSubview:Name_bottom];
    
    UILabel *Name_value=(UILabel *)[cell viewWithTag:klabnameofftag_second+indexPath.row];
    if(!Name_value)
        Name_value=[[UILabel alloc]initWithFrame:CGRectMake(140, 15, 140, 30)];
    Name_value.tag=klabnameofftag_second+indexPath.row;
    Name_value.backgroundColor=[UIColor clearColor];
    Name_value.textColor=[UIColor colorWithHexString:@"#6d2907" alpha:1.0];;
    Name_value.textAlignment=NSTextAlignmentRight;
    Name_value.font=[UIFont systemFontOfSize:18];
    Name_value.text=[self.data_Array_bottom objectAtIndex:indexPath.row];
    [cell addSubview:Name_value];
    
    UIImageView *icon_image=(UIImageView *)[cell viewWithTag:klabnameofftag_three+indexPath.row];
    if(!icon_image)
        icon_image=[[UIImageView alloc]initWithFrame:CGRectMake(290, 15, 20, 30)];
    icon_image.image=[UIImage imageNamed:@"展开图标.png"];
    icon_image.tag=klabnameofftag_three+indexPath.row;
    [cell addSubview:icon_image];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        CustomPickerView *picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250) title:@"装修风格"];
        picker.delegate=self;
        [picker setTag:1];
        [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                         [NSArray arrayWithObjects:@"现代简约", @"田园",@"美式",@"中式",@"欧式",@"地中海",@"东南亚", nil],
                                         nil]];
        [picker setSelectedTitles:[NSArray arrayWithObjects:[self.data_Array_bottom firstObject],nil] animated:YES];
        [picker show];
    }
    if (indexPath.row==1) {
        CustomPickerView *picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250)title:@"装修档次"];
        picker.delegate=self;
        [picker setTag:2];
        [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                         [NSArray arrayWithObjects:@"经济适用", @"中档装饰", @"高档豪华", nil],
                                         nil]];
        [picker setSelectedTitles:[NSArray arrayWithObjects:[self.data_Array_bottom lastObject],nil] animated:YES];
        [picker show];
    }
}

-(void)actionSheetPickerView:(CustomPickerView *)pickerView didSelectTitles:(NSArray *)titles{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* doc_path = [path objectAtIndex:0];
    NSString* _filename = [doc_path stringByAppendingPathComponent:@"Myhouse.plist"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:_filename];
    if (!dict) {
        dict =[NSMutableDictionary dictionary];
    }
    
    if(pickerView.tag==1){
        [self.data_Array_bottom replaceObjectAtIndex:0 withObject:[titles firstObject]];
        [dict setObject:[titles firstObject] forKey:@"装修风格"];
    }
    if(pickerView.tag==2){
        [self.data_Array_bottom replaceObjectAtIndex:1 withObject:[titles firstObject]];
        [dict setObject:[titles firstObject] forKey:@"装修档次"];
    }
    [dict writeToFile:_filename atomically:NO];
    
    [mtableview reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
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
