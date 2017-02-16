//
//  IDIAI3AccountDetailViewController.m
//  IDIAI
//
//  Created by Ricky on 15/11/29.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "IDIAI3AccountDetailViewController.h"

@interface IDIAI3AccountDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@end

@implementation IDIAI3AccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"收支详情";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"ic_fanhui.png"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    [leftButton addTarget:self
                   action:@selector(PressBarItemLeft)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    self.table =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.table.delegate =self;
    self.table.dataSource =self;
    self.table.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    // Do any additional setup after loading the view.
}
- (void)PressBarItemLeft {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 76;
    }else{
        return 53;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }else{
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier1 = @"designerDetailCell1";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (!cell1) {
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        if (indexPath.section ==0) {
            UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, (76-15)/2, 40, 15)];
            titlelbl.font =[UIFont systemFontOfSize:15];
            titlelbl.textColor =[UIColor colorWithHexString:@"#575757"];
            if ([self.accountObject.expenditureType integerValue]==1) {
                titlelbl.text =@"收入";
            }else{
                titlelbl.text =@"支出";
            }
            
            cell1.tag =100;
            [cell1 addSubview:titlelbl];
            
            UILabel *moneylbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-15-100, (76-20)/2, 100, 20)];
            moneylbl.font =[UIFont systemFontOfSize:20];
            moneylbl.textColor =[UIColor colorWithHexString:@"#ef6562"];
            moneylbl.tag =101;
            moneylbl.textAlignment =NSTextAlignmentRight;
            [cell1 addSubview:moneylbl];
        }else{
            UILabel *titlelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, (76-15)/2, 70, 15)];
            titlelbl.font =[UIFont systemFontOfSize:15];
            titlelbl.textColor =[UIColor colorWithHexString:@"#575757"];
            if (indexPath.row ==0) {
                titlelbl.text =@"交易单号";
            }else if (indexPath.row ==1){
                titlelbl.text =@"类型";
            }else if (indexPath.row ==2){
                titlelbl.text =@"时间";
            }else if (indexPath.row ==3){
                titlelbl.text =@"余额";
            }else if (indexPath.row ==4){
                titlelbl.text =@"备注";
            }
            cell1.tag =100;
            [cell1 addSubview:titlelbl];
            
            UILabel *cotentlbl =[[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-15-300*kMainScreenWidth/375, (76-15)/2, 300*kMainScreenWidth/375, 15)];
            cotentlbl.font =[UIFont systemFontOfSize:15];
            cotentlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            cotentlbl.tag =101;
//            cotentlbl.backgroundColor =[UIColor redColor];
            cotentlbl.textAlignment =NSTextAlignmentRight;
            [cell1 addSubview:cotentlbl];
        }
    }
    if (indexPath.section ==0) {
        UILabel *moneylbl =(UILabel *)[cell1 viewWithTag:101];
        moneylbl.text =self.accountObject.money;
    }else{
        UILabel *cotentlbl =(UILabel *)[cell1 viewWithTag:101];
        if (indexPath.row ==0) {
            cotentlbl.text =self.accountObject.orderNo;
        }else if (indexPath.row==1){
            cotentlbl.text =self.accountObject.recordType;
        }else if (indexPath.row==2){
            cotentlbl.text =self.accountObject.expenditureDate;
        }else if (indexPath.row==3){
            cotentlbl.text =self.accountObject.balance;
        }else if (indexPath.row==4){
            UIFont *font = [UIFont fontWithName:@"Arial" size:15];
            CGSize size = CGSizeMake(300*kMainScreenWidth/375,40);
            CGSize labelsize = [self.accountObject.remark sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            cotentlbl.text =self.accountObject.remark;
            cotentlbl.font =font;
            if (labelsize.height>20) {
                cotentlbl.frame =CGRectMake(cotentlbl.frame.origin.x, cotentlbl.frame.origin.y-labelsize.height-7.5, labelsize.width, labelsize.height);
            }
            cotentlbl.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeTailTruncation;
            cotentlbl.numberOfLines =2;
            
        }
    }
    cell1.backgroundColor =[UIColor whiteColor];
    cell1.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==1) {
        return 14;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerview =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 14)];
    headerview.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    return headerview;
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
