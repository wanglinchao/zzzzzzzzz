//
//  MoreResourcesViewController.m
//  UTopGD
//
//  Created by Ricky on 15/11/13.
//  Copyright (c) 2015年 yangfan. All rights reserved.
//

#import "MoreResourcesViewController.h"
#import "HexColor.h"

@interface MoreResourcesViewController ()<UIAlertViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *nameArray;

@end

@implementation MoreResourcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"更多产品";
    self.nameArray =[NSArray arrayWithObjects:@"屋托邦看工地",@"屋托邦卖家版",@"屋托邦商城",@"装修设计",nil];
    self.titleArray =[NSArray arrayWithObjects:@"找工长 一键搞定",@"免费入驻 轻松赚钱",@"海量建材 一键淘回家",@"精选设计，畅享新家",nil];
    self.view.backgroundColor =[UIColor colorWithHexString:@"#f1f0f6"];
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.backgroundColor =[UIColor clearColor];
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    // Do any additional setup after loading the view.
}
- (void)PressBarItemLeft {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backview =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    backview.backgroundColor =[UIColor clearColor];
    return backview;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *footerimage =[[UIImageView alloc] initWithFrame:CGRectMake(10, 8.5, 37, 37)];
        [cell.contentView addSubview:footerimage];
        switch (indexPath.row) {
            case 0:
                footerimage.image =[UIImage imageNamed:@"ic_gongdi"];
                break;
            case 1:
                footerimage.image =[UIImage imageNamed:@"ic_maijiaban"];
                break;
            case 2:
                footerimage.image =[UIImage imageNamed:@"ic_shangcheng"];
                break;
            case 3:
                footerimage.image =[UIImage imageNamed:@"ic_sheji"];
                break;
            default:
                break;
        }
        UILabel *namelbl =[[UILabel alloc] initWithFrame:CGRectMake(footerimage.frame.size.width+footerimage.frame.origin.x+10, 8, 150, 18)];
        namelbl.font =[UIFont systemFontOfSize:15.5];
        namelbl.textColor =[UIColor colorWithHexString:@"#323232" alpha:1.0];
        namelbl.tag =101;
        [cell.contentView addSubview:namelbl];
        
        UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(footerimage.frame.size.width+footerimage.frame.origin.x+10, namelbl.frame.size.height+namelbl.frame.origin.y+5, 200, 16)];
        titlelbl.font =[UIFont systemFontOfSize:13];
        titlelbl.textColor =[UIColor colorWithHexString:@"#a7a7a7"];
        titlelbl.tag =102;
        [cell.contentView addSubview:titlelbl];
        
        UIImageView *downloadimage =[[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-22, 16, 12, 12)];
        downloadimage.image =[UIImage imageNamed:@"ic_xiazai-1"];
        [cell.contentView addSubview:downloadimage];
        
        UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(12, 54-0.5, kMainScreenWidth-12, 0.5)];
        line.backgroundColor =[UIColor colorWithHexString:@"#e6e6e6" alpha:0.8];
        [cell.contentView addSubview:line];
    }
    cell.contentView.backgroundColor =[UIColor colorWithHexString:@"#ffffff"];
    UILabel *namelbl =(UILabel*)[cell.contentView viewWithTag:101];
    namelbl.text =[self.nameArray objectAtIndex:indexPath.row];
    
    UILabel *titlelbl =(UILabel*)[cell.contentView viewWithTag:102];
    titlelbl.text =[self.titleArray objectAtIndex:indexPath.row];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self openUTopGDApp];
            break;
        case 1:
            [self openUTopSPApp];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mall.trond.cn/wap/index"]];
            break;
        case 3:
            [self openUTopALApp];
            break;
        default:
            break;
    }
}
#pragma mark -
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==100001) {
        if (buttonIndex==alertView.cancelButtonIndex) [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        else [self downloadUTopGDApp];
    }
    else if (alertView.tag==100002){
        if (buttonIndex ==alertView.cancelButtonIndex) [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        else [self downloadUTopSPApp];
    }
    else if (alertView.tag==100003){
        if (buttonIndex ==alertView.cancelButtonIndex) [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        else [self downloadUTopALApp];
    }
}

/***********屋托邦看工地App***********/
/*
 注意：URL Schemes必填， URL identifier选填。
 另外，URL Schemes建议都小写，因为之后接收到数据的时候，不区分大小写，都是转为小写。
 规定的格式是：URL Schemes://URL identifier ，其中(URL identifier可不填写)
 */
#pragma mark - 调起屋托邦看工地App
- (void)openUTopGDApp {
    NSString *UrlSchemes =@"qttecx.utopgd://";
    NSURL *urlApp = [NSURL URLWithString:[UrlSchemes stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([[UIApplication sharedApplication] canOpenURL:urlApp])
        [[UIApplication sharedApplication] openURL:urlApp];
    else{
        UIAlertView *alv=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您尚未安装“屋托邦看工地”，是否立即前往下载安装？" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"立即", nil];
        alv.tag=100001;
        [alv show];
    }
}

#pragma mark - 下载屋托邦看工地App
- (void)downloadUTopGDApp {
    NSString *sPappIDStr = @"1044950732";
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", sPappIDStr];
    NSURL *iTunesURL = [NSURL URLWithString:[iTunesString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([[UIApplication sharedApplication] canOpenURL:iTunesURL]) [[UIApplication sharedApplication] openURL:iTunesURL];
}

/***********屋托邦卖家版App***********/
#pragma mark - 调起屋托邦卖家版App
/*
 注意：URL Schemes必填， URL identifier选填。
 另外，URL Schemes建议都小写，因为之后接收到数据的时候，不区分大小写，都是转为小写。
 规定的格式是：URL Schemes://URL identifier ，其中(URL identifier可不填写)
 */
- (void)openUTopSPApp {
    NSString *UrlSchemes =@"qttecx.utopsp://";
    NSURL *urlApp = [NSURL URLWithString:[UrlSchemes stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([[UIApplication sharedApplication] canOpenURL:urlApp])
        [[UIApplication sharedApplication] openURL:urlApp];
    else{
        UIAlertView *alv=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您尚未安装“屋托邦卖家版”，是否立即前往下载安装？" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"立即", nil];
        alv.tag=100002;
        [alv show];
    }
}
#pragma mark - 下载屋托邦卖家版App
- (void)downloadUTopSPApp {
    NSString *sPappIDStr = @"967239506";
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", sPappIDStr];
    NSURL *iTunesURL = [NSURL URLWithString:[iTunesString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([[UIApplication sharedApplication] canOpenURL:iTunesURL]) [[UIApplication sharedApplication] openURL:iTunesURL];
}

/***********屋托邦装修设计App***********/
#pragma mark - 调起屋托邦装修设计App
- (void)openUTopALApp {
    NSString *UrlSchemes = @"qttecx.utoppic://";
    NSURL *urlApp = [NSURL URLWithString:[UrlSchemes stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([[UIApplication sharedApplication] canOpenURL:urlApp])
        [[UIApplication sharedApplication] openURL:urlApp];
    else{
        UIAlertView *alv=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未安装“装修设计”，是否立即前往下载安装？" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"立即", nil];
        alv.tag=100003;
        [alv show];
    }
}
#pragma mark - 下载屋托邦装修设计App
- (void)downloadUTopALApp {
    NSString *sPappIDStr = @"1102665552";
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", sPappIDStr];
    NSURL *iTunesURL = [NSURL URLWithString:[iTunesString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([[UIApplication sharedApplication] canOpenURL:iTunesURL]) [[UIApplication sharedApplication] openURL:iTunesURL];
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
