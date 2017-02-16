//
//  IMMessageSoundSettingViewController.m
//  UTopSP
//
//  Created by iMac on 16/9/7.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IMMessageSoundSettingViewController.h"

@interface IMMessageSoundSettingViewController ()

@property (nonatomic,strong) UISwitch *switchSound;
@property (nonatomic,strong) UISwitch *switchVibration;
@property (nonatomic,strong) UILabel *descContent;
@property (nonatomic,strong) NSArray *descArray;

@end

@implementation IMMessageSoundSettingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"新消息通知";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mtableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)
                                             style:UITableViewStyleGrouped];
    mtableview.delegate=self;
    mtableview.dataSource=self;
    [self.view addSubview:mtableview];
    
    _descArray=@[@"如果你要关闭或开启屋托邦的新消息通知，请在iPhone的“设置”-“通知”功能中，找到应用程序“屋托邦”更改",
                         @"当屋托邦运行时，你可以设置是否需要声音或者振动"];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGSize size=[util calHeightForLabel:_descArray[section] width:kMainScreenWidth-35 font:[UIFont systemFontOfSize:15]];
    return size.height+10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0) return 1;
    else return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return _descArray[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid=[NSString stringWithFormat:@"mycellID_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    NSArray *title_arr = @[@[@"接收新消息通知"],@[@"声音",@"振动"]];
    NSArray *sub_Arr = title_arr[indexPath.section];
    cell.textLabel.text = sub_Arr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    if(indexPath.section==0){
        if(!_descContent) _descContent=[[UILabel alloc]  init];
        _descContent.frame=CGRectMake(kMainScreenWidth-115, 15, 100, 20);
        _descContent.backgroundColor=[UIColor clearColor];
        _descContent.textAlignment=NSTextAlignmentRight;
        _descContent.font=[UIFont systemFontOfSize:15.5];
        _descContent.textColor=[UIColor lightGrayColor];
        _descContent.text=@"已关闭";
        [cell addSubview:_descContent];
        if([util isAllowedNotification]==YES) _descContent.text=@"已开启";
    }
    else if(indexPath.section==1 && indexPath.row==0){
        if(!_switchSound)
            _switchSound = [[UISwitch alloc] init];
        _switchSound.frame=CGRectMake(54.0f, 16.0f, 100.0f, 28.0f);
        [_switchSound setOnTintColor:[UIColor colorWithHexString:@"#35BB9D" alpha:1.0]];
        [_switchSound addTarget:self action:@selector(switchActionSound:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=_switchSound;
        
        BOOL isON=[[NSUserDefaults standardUserDefaults] boolForKey:ALiYW_IM_OpenOrCloseSound];
        if(isON==YES) _switchSound.on=YES;
        else _switchSound.on=NO;
    }
    else if(indexPath.section==1 && indexPath.row==1){
        if(!_switchVibration) _switchVibration = [[UISwitch alloc] init];
        _switchVibration.frame=CGRectMake(54.0f, 16.0f, 100.0f, 28.0f);
        [_switchVibration setOnTintColor:[UIColor colorWithHexString:@"#35BB9D" alpha:1.0]];
        [_switchVibration addTarget:self action:@selector(switchActionVibration:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=_switchVibration;
        
        BOOL isON=[[NSUserDefaults standardUserDefaults] boolForKey:ALiYW_IM_OpenOrCloseVibration];
        if(isON==YES) _switchVibration.on=YES;
        else _switchVibration.on=NO;
    }

    return cell;
}

#pragma mark -Action
-(void)switchActionSound:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    [[NSUserDefaults standardUserDefaults] setBool:isButtonOn forKey:ALiYW_IM_OpenOrCloseSound];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)switchActionVibration:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    [[NSUserDefaults standardUserDefaults] setBool:isButtonOn forKey:ALiYW_IM_OpenOrCloseVibration];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
