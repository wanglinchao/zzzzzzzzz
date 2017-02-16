//
//  MyOrderDetailConfirmViewController.m
//  IDIAI
//
//  Created by Ricky on 15-1-23.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MyOrderDetailConfirmViewController.h"
#import "util.h"
#import "UIButton+WebCache.h"
#import "AutomaticLogin.h"
//#import "LoginVC.h"
#import "LoginView.h"
#import "TLToast.h"
#import "AttenceTimelineCell.h"
#import "ContractModel.h"
#import "ContractPhaseModel.h"
#import "IDIAIAppDelegate.h"
#import "InputPayPsdViewController.h"
#import "savelogObj.h"

#define KButtonTag 100
#define Kcelltag 1000

@interface MyOrderDetailConfirmViewController () <UITableViewDataSource, UITableViewDelegate, LoginViewDelegate> {
    UITableView *_theTableView;
    NSMutableArray *dataSourceArr;
    ContractModel *_contractModel;
    NSArray *_contractPhaseModelArr;
}

@property (nonatomic,strong) UIButton *btn_phone;

@end

@implementation MyOrderDetailConfirmViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
//        [self customizeNavigationBar];
      [[[self navigationController] navigationBar] setHidden:NO];
}

- (void)customizeNavigationBar {
    
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"查看合同详情" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:58];
    
    self.title = @"合同详情";
        self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
   // self.navigationController.navigationBar.barTintColor = kThemeColor;
    [self customizeNavigationBar];
    
    _theTableView = [[UITableView alloc]initWithFrame:kTableViewFrame style:UITableViewStylePlain];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_theTableView];
    
//    self.count_first=1;
    self.count_first = 0;
    self.count_second=0;
    self.count_third = 0;
    self.count_fouth = 0;
//    is_open_first=YES;
//    is_change=YES;
    
    [self requestOrderDetail];
    
    [self createPhone];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + _contractPhaseModelArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (_contractPhaseModelArr.count == 4) {
        if (section == 1) {
            return self.count_first;
        } else if (section == 2) {
            return self.count_second;
        } else if (section == 3) {
            return self.count_third;
        } else {
            return self.count_fouth;
        }

    } else if (_contractPhaseModelArr.count == 2) {
        if (section == 1) {
            return self.count_first;
        } else if (section == 2) {
            return self.count_second;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.1;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CGFloat height =458;
        NSString *str_userAddr =[NSString stringWithFormat:@"小区地址:%@", _contractModel.userAddr];
        CGSize sizeuserAdd=[util calHeightForLabel:str_userAddr width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:17]];
        if (sizeuserAdd.height>20) {
            height+=sizeuserAdd.height;
        }else{
            height+=21;
        }
        NSString *str_userCommunityName =[NSString stringWithFormat:@"小区名称:%@", _contractModel.userCommunityName];
        CGSize sizeuserCommunityName=[util calHeightForLabel:str_userCommunityName width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:17]];
        if (sizeuserCommunityName.height>20) {
            height+=sizeuserCommunityName.height;
        }else{
            height+=21;
        }
        return height;
    } else {
         ContractPhaseModel *contractPhaseModel = [_contractPhaseModelArr objectAtIndex:indexPath.section - 1];
        
           NSString *string_=contractPhaseModel.phraseDesc;
        
            CGSize size=[util calHeightForLabel:string_ width:kMainScreenWidth-60-20 font:[UIFont systemFontOfSize:15]];
            
            return size.height + 10;
        }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"MyOrderDetailConfirmCell";
    static NSString *CellIdentifier2 = @"MyOrderDetailConfirmCell2";
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
//            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderDetailConfirmCell" owner:self options:nil]lastObject];
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            
            UIView *backView =[[UIView alloc] init];
            backView.tag =119;
            backView.backgroundColor =[UIColor whiteColor];
            [cell.contentView addSubview:backView];
            
            UIImageView *footView =[[UIImageView alloc] init];
            footView.tag =120;
            footView.image =[UIImage imageNamed:@"bg_dingdan.png"];
            [cell.contentView addSubview:footView];
            
            UIView *headLineView =[[UIView alloc] initWithFrame:CGRectMake(9, 44, kMainScreenWidth-18, 1)];
            headLineView.backgroundColor =[UIColor colorWithHexString:@"#cccccc"];
            [backView addSubview:headLineView];
            
            UILabel *businessNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 15, kMainScreenWidth-20, 21)];
            businessNameLabel.tag =101;
            [backView addSubview:businessNameLabel];
            
            UILabel *orderStateNameLabel =[[UILabel alloc] init];
            orderStateNameLabel.font =[UIFont systemFontOfSize:17.0];
            orderStateNameLabel.textColor =[UIColor redColor];
            orderStateNameLabel.tag =102;
            [backView addSubview:orderStateNameLabel];
            
            UILabel *orderNumLabel =[[UILabel alloc] init];
            orderNumLabel.font =[UIFont systemFontOfSize:17.0];
            orderNumLabel.textColor =[UIColor darkGrayColor];
            orderNumLabel.tag =103;
            [backView addSubview:orderNumLabel];
            
            UILabel *orderDateLabel =[[UILabel alloc] init];
            orderDateLabel.font =[UIFont systemFontOfSize:17.0];
            orderDateLabel.textColor =[UIColor darkGrayColor];
            orderDateLabel.tag =104;
            [backView addSubview:orderDateLabel];
            
            UILabel *orderTypeLabel =[[UILabel alloc] init];
            orderTypeLabel.font =[UIFont systemFontOfSize:17.0];
            orderTypeLabel.textColor =[UIColor darkGrayColor];
            orderTypeLabel.tag =105;
            [backView addSubview:orderTypeLabel];
            
            UILabel *PartyOne =[[UILabel alloc] init];
            PartyOne.font =[UIFont systemFontOfSize:17.0];
            PartyOne.textColor =[UIColor redColor];
            PartyOne.tag =115;
            [backView addSubview:PartyOne];
            
            UIView *partyline =[[UIView alloc] init];
            partyline.backgroundColor =[UIColor redColor];
            partyline.tag =116;
            [backView addSubview:partyline];
            
            UILabel *FirstPartyNameLabel =[[UILabel alloc] init];
            FirstPartyNameLabel.font =[UIFont systemFontOfSize:17.0];
            FirstPartyNameLabel.textColor =[UIColor darkGrayColor];
            FirstPartyNameLabel.tag =106;
            [backView addSubview:FirstPartyNameLabel];
            
            UILabel *FirstPartyTelLabel =[[UILabel alloc] init];
            FirstPartyTelLabel.font =[UIFont systemFontOfSize:17.0];
            FirstPartyTelLabel.textColor =[UIColor darkGrayColor];
            FirstPartyTelLabel.tag =107;
            [backView addSubview:FirstPartyTelLabel];
            
            UILabel *houseAreaLabel =[[UILabel alloc] init];
            houseAreaLabel.font =[UIFont systemFontOfSize:17.0];
            houseAreaLabel.textColor =[UIColor darkGrayColor];
            houseAreaLabel.tag =108;
            [backView addSubview:houseAreaLabel];
            
            UILabel *communityNameLabel =[[UILabel alloc] init];
            communityNameLabel.font =[UIFont systemFontOfSize:17.0];
            communityNameLabel.textColor =[UIColor darkGrayColor];
            communityNameLabel.tag =109;
            [backView addSubview:communityNameLabel];
            
            UILabel *communityAddressLabel =[[UILabel alloc] init];
            communityAddressLabel.font =[UIFont systemFontOfSize:17.0];
            communityAddressLabel.textColor =[UIColor darkGrayColor];
            communityAddressLabel.tag =110;
            [backView addSubview:communityAddressLabel];
            
            UILabel *partyTwo =[[UILabel alloc] init];
            partyTwo.font =[UIFont systemFontOfSize:17.0];
            partyTwo.textColor =[UIColor redColor];
            partyTwo.tag =117;
            [backView addSubview:partyTwo];
            
            UIView *partytwoline =[[UIView alloc] init];
            partytwoline.backgroundColor =[UIColor redColor];
            partytwoline.tag =118;
            [backView addSubview:partytwoline];
            
            UILabel *partyBNameLabel =[[UILabel alloc] init];
            partyBNameLabel.font =[UIFont systemFontOfSize:17.0];
            partyBNameLabel.textColor =[UIColor darkGrayColor];
            partyBNameLabel.tag =111;
            [backView addSubview:partyBNameLabel];
            
            UILabel *partyBTelLabel =[[UILabel alloc] init];
            partyBTelLabel.font =[UIFont systemFontOfSize:17.0];
            partyBTelLabel.textColor =[UIColor darkGrayColor];
            partyBTelLabel.tag =112;
            [backView addSubview:partyBTelLabel];
            
            UILabel *partyBMoneyLabel =[[UILabel alloc] init];
            partyBMoneyLabel.font =[UIFont systemFontOfSize:17.0];
            partyBMoneyLabel.textColor =[UIColor darkGrayColor];
            partyBMoneyLabel.tag =113;
            [backView addSubview:partyBMoneyLabel];
            
            UILabel *periodLabel =[[UILabel alloc] init];
            periodLabel.font =[UIFont systemFontOfSize:17.0];
            periodLabel.textColor =[UIColor darkGrayColor];
            periodLabel.tag =114;
            [backView addSubview:periodLabel];
        }
        NSString *str_userAddr =[NSString stringWithFormat:@"小区地址:%@", _contractModel.userAddr];
        CGSize sizeuserAdd=[util calHeightForLabel:str_userAddr width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:17]];
        NSString *str_userCommunityName =[NSString stringWithFormat:@"小区名称:%@", _contractModel.userCommunityName];
        CGSize sizeuserCommunityName=[util calHeightForLabel:str_userCommunityName width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:17]];
        UIView *back =(UIView *)[cell viewWithTag:119];
        back.frame =CGRectMake(10, 0, kMainScreenWidth-20,458+sizeuserAdd.height+sizeuserCommunityName.height-11);
        
        UIImageView *footimage =(UIImageView *)[cell viewWithTag:120];
        footimage.frame =CGRectMake(back.frame.origin.x, back.frame.origin.y+back.frame.size.height, kMainScreenWidth-20, 11);
        
        UILabel *businessNameLabel = (UILabel *)[cell viewWithTag:101];
                businessNameLabel.text = _contractModel.servantName;//服务商名称
        businessNameLabel.frame =CGRectMake(10, 15, 75, 21);
        
        UILabel *orderStateNameLabel = (UILabel *)[cell viewWithTag:102];
        orderStateNameLabel.frame =CGRectMake(kMainScreenWidth-130, 14, 103, 21);
        NSString *orderStateStr;
        if (self.orderStateInteger == 1) {
            orderStateStr = @"待确认";
        } else if (self.orderStateInteger == 2) {
            orderStateStr = @"待托管";
        }
        orderStateNameLabel.text = orderStateStr;
        
        UILabel *orderNumLabel = (UILabel *)[cell viewWithTag:103];
        orderNumLabel.text = [NSString stringWithFormat:@"订单编号: %@",self.orderIDStr];
        orderNumLabel.frame =CGRectMake(8, 53, kMainScreenWidth-36, 21);
        
        UILabel *orderDateLabel = (UILabel *)[cell viewWithTag:104];
        orderDateLabel.frame =CGRectMake(orderNumLabel.frame.origin.x, orderNumLabel.frame.size.height+orderNumLabel.frame.origin.y+9, kMainScreenWidth-36, 21);
        orderDateLabel.text = [NSString stringWithFormat:@"订单日期: %@",_contractModel.createTimeShow];
        UILabel *orderTypeLabel = (UILabel *)[cell viewWithTag:105];
        orderTypeLabel.frame =CGRectMake(orderDateLabel.frame.origin.x, orderDateLabel.frame.size.height+orderDateLabel.frame.origin.y+9, kMainScreenWidth-36, 21);
        NSString *orderTypeStr;
        if (_contractModel.contractType == 1) {
            orderTypeStr = @"设计合同";
        } else if (_contractModel.contractType == 4) {
            orderTypeStr = @"施工合同";
        } else if (_contractModel.contractType == 6) {
            orderTypeStr = @"监理合同";
        }
        orderTypeLabel.text =[NSString stringWithFormat:@"订单类型: %@",orderTypeStr];
        
        UILabel *PartyOne =(UILabel *)[cell viewWithTag:115];
        PartyOne.text =@"甲方";
        PartyOne.frame=CGRectMake(8, orderTypeLabel.frame.origin.y+orderTypeLabel.frame.size.height+8, 73, 21);
        
        UIView *partyline =(UIView *)[cell viewWithTag:116];
        partyline.frame =CGRectMake(53, PartyOne.frame.origin.y+10, kMainScreenWidth-73-16, 1);
        //甲方 用户
        UILabel *FirstPartyNameLabel = (UILabel *)[cell viewWithTag:106];
        FirstPartyNameLabel.text = [NSString stringWithFormat:@"甲       方: %@",_contractModel.userName];
        FirstPartyNameLabel.frame =CGRectMake(orderTypeLabel.frame.origin.x, PartyOne.frame.origin.y+PartyOne.frame.size.height+9, kMainScreenWidth-16, 21);
        UILabel *FirstPartyTelLabel = (UILabel *)[cell viewWithTag:107];
        FirstPartyTelLabel.text = [NSString stringWithFormat:@"电       话: %@",_contractModel.userPhoneNo];
        FirstPartyTelLabel.frame =CGRectMake(FirstPartyNameLabel.frame.origin.x, FirstPartyNameLabel.frame.origin.y+FirstPartyNameLabel.frame.size.height+9, kMainScreenWidth-36, 21);
        UILabel *houseAreaLabel = (UILabel *)[cell viewWithTag:108];
        houseAreaLabel.text = [NSString stringWithFormat:@"房屋面积: %dm²",_contractModel.houseArea];
        houseAreaLabel.frame =CGRectMake(FirstPartyTelLabel.frame.origin.x, FirstPartyTelLabel.frame.origin.y+FirstPartyTelLabel.frame.size.height+9, kMainScreenWidth-36, 21);
        
        UILabel *communityNameLabel = (UILabel *)[cell viewWithTag:109];
//        NSString *str_userCommunityName =[NSString stringWithFormat:@"小区名称:%@", _contractModel.userCommunityName];
//        CGSize sizeuserCommunityName=[util calHeightForLabel:str_userCommunityName width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:17]];
        communityNameLabel.frame =CGRectMake(houseAreaLabel.frame.origin.x, houseAreaLabel.frame.origin.y+houseAreaLabel.frame.size.height+9, kMainScreenWidth-36, sizeuserCommunityName.height);
        communityNameLabel.numberOfLines =0;
        communityNameLabel.text = str_userCommunityName;

        UILabel *communityAddressLabel = (UILabel *)[cell viewWithTag:110];
//        NSString *str_userAddr =[NSString stringWithFormat:@"小区地址:%@", _contractModel.userAddr];
//        CGSize sizeuserAdd=[util calHeightForLabel:str_userAddr width:kMainScreenWidth-40 font:[UIFont systemFontOfSize:17]];
        communityAddressLabel.frame =CGRectMake(communityNameLabel.frame.origin.x, communityNameLabel.frame.origin.y+communityNameLabel.frame.size.height+9, kMainScreenWidth-36, sizeuserAdd.height);
        communityAddressLabel.numberOfLines =0;
        communityAddressLabel.text = str_userAddr;
        
        UILabel *partyTwo =(UILabel *)[cell viewWithTag:117];
        partyTwo.text =@"乙方";
        partyTwo.frame=CGRectMake(8, communityAddressLabel.frame.origin.y+communityAddressLabel.frame.size.height+8, 73, 21);
        
        UIView *partytwoline =(UIView *)[cell viewWithTag:118];
        partytwoline.frame =CGRectMake(53, partyTwo.frame.origin.y+10, kMainScreenWidth-73-16, 1);
        
        
        //乙方 服务商
        UILabel *partyBNameLabel = (UILabel *)[cell viewWithTag:111];
        partyBNameLabel.text = [NSString stringWithFormat:@"乙       方: %@",_contractModel.servantName];
        partyBNameLabel.frame =CGRectMake(partyTwo.frame.origin.x, partyTwo.frame.origin.y+partyTwo.frame.size.height+9, kMainScreenWidth-16, 21);
        UILabel *partyBTelLabel = (UILabel *)[cell viewWithTag:112];
        partyBTelLabel.text = [NSString stringWithFormat:@"电       话: %@",_contractModel.servantPhoneNo];
        partyBTelLabel.frame =CGRectMake(partyBNameLabel.frame.origin.x, partyBNameLabel.frame.origin.y+partyBNameLabel.frame.size.height+9, kMainScreenWidth-36, 21);
        UILabel *partyBMoneyLabel = (UILabel *)[cell viewWithTag:113];
#warning 待修改 huangrun
        partyBMoneyLabel.text = [NSString stringWithFormat:@"订单金额: ￥%.2f",_contractModel.contractTotalFeeShow];//待后台添加阶段金额字段后 再修改为显示为阶段金额 huangrun
        partyBMoneyLabel.frame =CGRectMake(partyBTelLabel.frame.origin.x, partyBTelLabel.frame.origin.y+partyBTelLabel.frame.size.height+9, kMainScreenWidth-36, 21);
        
        UILabel *periodLabel = (UILabel *)[cell viewWithTag:114];
        periodLabel.text = [NSString stringWithFormat:@"工       期: %d天",_contractModel.duration];
        periodLabel.frame =CGRectMake(partyBMoneyLabel.frame.origin.x, partyBMoneyLabel.frame.origin.y+partyBMoneyLabel.frame.size.height+9, kMainScreenWidth-36, 21);
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        
        ContractPhaseModel *contractPhaseModel = [_contractPhaseModelArr objectAtIndex:indexPath.section - 1];
        
        NSString *sting_= contractPhaseModel.phraseDesc;
        
        if(sting_==nil) sting_=@"";
        CGSize size=[util calHeightForLabel:sting_ width:kMainScreenWidth-60 - 20 font:[UIFont systemFontOfSize:15]];
        UILabel *cs=(UILabel *)[cell.contentView viewWithTag:KButtonTag+indexPath.row+indexPath.section];
        if(!cs)
            cs = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-60 - 20, size.height)];
        cs.tag=KButtonTag+indexPath.row+indexPath.section;
        cs.backgroundColor = [UIColor whiteColor];
        cs.textColor = [UIColor grayColor];
        cs.font = [UIFont systemFontOfSize:15.0];
        cs.textAlignment = NSTextAlignmentLeft;
        cs.text=sting_;
        cs.numberOfLines=0;
        
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIView class]]) {
                [view removeFromSuperview];
            }
        }
        
        UIView *cellBgView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, kMainScreenWidth-60 - 8, size.height+10)];
        cellBgView.backgroundColor = [UIColor whiteColor];
        [cellBgView addSubview:cs];
        [cell.contentView addSubview:cellBgView];
        
        UIView *verticalLineView = (UIView *)[cell.contentView viewWithTag:100000+indexPath.section];
        if (verticalLineView == nil)
            verticalLineView = [[UIView alloc]initWithFrame:CGRectMake(32.5, 0, 2, size.height + 20)];
        verticalLineView.tag = 100000+indexPath.section;
        verticalLineView.backgroundColor = kThemeColor;
        [cell.contentView addSubview:verticalLineView];
    
        if (indexPath.section == _contractPhaseModelArr.count) {
            UIView *verticalLineView = (UIView *)[cell.contentView viewWithTag:100000+indexPath.section];
            [verticalLineView removeFromSuperview];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
         ContractPhaseModel *contractPhaseModel = [_contractPhaseModelArr objectAtIndex:section - 1];
        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(60, 5, kMainScreenWidth - 60 - 8, 45)];
//        UIImage *img = [UIImage imageNamed:@"AttenceTimelineCellMessage2"];//huangrun 改界面
//        img = [img stretchableImageWithLeftCapWidth:20 topCapHeight:20]
//        ;
        view_.backgroundColor=[UIColor clearColor];
//        UIImageView *bgIV = [[UIImageView alloc]initWithImage:img];
//        bgIV.frame = view_.frame;
//        [view_ addSubview:bgIV];
        
        UIView *bgView = [[UIView alloc]initWithFrame:view_.frame];
        bgView.backgroundColor = [UIColor whiteColor];
        [view_ addSubview:bgView];
        
//        UIView *line_first_header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
//        line_first_header.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
//        [view_ addSubview:line_first_header];
        
        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, kMainScreenWidth - 100, 30)];
        designer_jianj.backgroundColor = [UIColor clearColor];
        designer_jianj.font = [UIFont systemFontOfSize:18.0];
        designer_jianj.textAlignment = NSTextAlignmentLeft;
//        designer_jianj.textColor = kThemeColor;
        designer_jianj.text = [NSString stringWithFormat:@"%@ %.2f元",contractPhaseModel.phraseName,contractPhaseModel.phraseFee/100];
        [view_ addSubview:designer_jianj];
        
        UIImageView *roundIV1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
        roundIV1.image = [UIImage imageNamed:@"bg_shuzi_1.png"];
        [view_ addSubview:roundIV1];
        
        UIView *verticalLineView1 = [[UIView alloc]initWithFrame:CGRectMake(32.5, roundIV1.frame.origin.y + roundIV1.frame.size.height, 2, 25)];
        verticalLineView1.backgroundColor = kThemeColor;
        [view_ addSubview:verticalLineView1];
        
        self.imv_zkai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
        self.imv_zkai.frame = CGRectMake(kMainScreenWidth-30, 18, 10, 20);
        [view_ addSubview:self.imv_zkai];
        if(is_change_first==YES){
            if(is_open_first){
                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                [spinAnimation setFromValue:[NSNumber numberWithFloat:0]];
                [spinAnimation setToValue:[NSNumber numberWithDouble:M_PI/2]];
                [spinAnimation setDelegate:self];
                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [spinAnimation setDuration:0.2];
                [self.imv_zkai.layer addAnimation:spinAnimation forKey:@"spin"];
                [self.imv_zkai.layer setTransform:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)];
                
//                UIImage *img = [UIImage imageNamed:@"AttenceTimelineCellMessage2"];//huangrun 改界面
//                img = [img stretchableImageWithLeftCapWidth:20 topCapHeight:20]
//                ;
//                bgIV.image = img;
//                bgIV.backgroundColor = [UIColor whiteColor];
            }
            else{
                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                [spinAnimation setFromValue:[NSNumber numberWithFloat:M_PI/2]];
                [spinAnimation setToValue:[NSNumber numberWithDouble:0]];
                [spinAnimation setDelegate:self];
                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [spinAnimation setDuration:0.2];
                [self.imv_zkai.layer addAnimation:spinAnimation forKey:@"spin"];
                [self.imv_zkai.layer setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];
            }
        }
        
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headerBtn.frame = CGRectMake(0, 0, kMainScreenWidth, 50);
        headerBtn.tag = 1001;
        [headerBtn addTarget:self
                      action:@selector(tapHeader:)
            forControlEvents:UIControlEventTouchUpInside];
        [view_ addSubview:headerBtn];
        
        return view_;
    }
    else if(section==2){
        ContractPhaseModel *contractPhaseModel = [_contractPhaseModelArr objectAtIndex:section - 1];
        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(60, 5, kMainScreenWidth - 60 - 8, 45)];
        view_.backgroundColor=[UIColor clearColor];
        
        UIView *bgView = [[UIView alloc]initWithFrame:view_.frame];
        bgView.backgroundColor = [UIColor whiteColor];
        [view_ addSubview:bgView];
        
//        UIView *line_secon_header=[[UIView alloc]initWithFrame:CGRectMake(20, 0, kMainScreenWidth-20, 0.5)];
//        line_secon_header.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
//        [view_ addSubview:line_secon_header];
        
        
        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, kMainScreenWidth - 100, 30)];
        designer_jianj.backgroundColor = [UIColor clearColor];
        designer_jianj.font = [UIFont systemFontOfSize:18.0];
        designer_jianj.textAlignment = NSTextAlignmentLeft;
//        designer_jianj.textColor = kThemeColor;
        designer_jianj.text = [NSString stringWithFormat:@"%@ %.2f元",contractPhaseModel.phraseName,contractPhaseModel.phraseFee/100];
        [view_ addSubview:designer_jianj];
        
        UIImageView *roundIV2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
        roundIV2.image = [UIImage imageNamed:@"bg_shuzi_2.png"];
        [view_ addSubview:roundIV2];
        
        if([_contractPhaseModelArr count]!=2){
            UIView *verticalLineView2 = [[UIView alloc]initWithFrame:CGRectMake(32.5, roundIV2.frame.origin.y + roundIV2.frame.size.height, 2, 25)];
            verticalLineView2.backgroundColor = kThemeColor;
            [view_ addSubview:verticalLineView2];
        }
        
        self.imv_zkai_seond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
        self.imv_zkai_seond.frame = CGRectMake(kMainScreenWidth-30, 18, 10, 20);
        [view_ addSubview:self.imv_zkai_seond];
        if(is_change_second==YES){
            if(is_open_second){
                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                [spinAnimation setFromValue:[NSNumber numberWithFloat:0]];
                [spinAnimation setToValue:[NSNumber numberWithDouble:M_PI/2]];
                [spinAnimation setDelegate:self];
                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [spinAnimation setDuration:0.2];
                [self.imv_zkai_seond.layer addAnimation:spinAnimation forKey:@"spin"];
                [self.imv_zkai_seond.layer setTransform:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)];
                
            }
            else{
                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                [spinAnimation setFromValue:[NSNumber numberWithFloat:M_PI/2]];
                [spinAnimation setToValue:[NSNumber numberWithDouble:0]];
                [spinAnimation setDelegate:self];
                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [spinAnimation setDuration:0.2];
                [self.imv_zkai_seond.layer addAnimation:spinAnimation forKey:@"spin"];
                [self.imv_zkai_seond.layer setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];
            }
        }
        
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headerBtn.frame = CGRectMake(0, 0, kMainScreenWidth, 50);
        headerBtn.tag = 1002;
        [headerBtn addTarget:self
                      action:@selector(tapHeader:)
            forControlEvents:UIControlEventTouchUpInside];
        [view_ addSubview:headerBtn];
        
        return view_;
    } if(section==3){
        ContractPhaseModel *contractPhaseModel = [_contractPhaseModelArr objectAtIndex:section - 1];
        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(60, 5, kMainScreenWidth - 60 - 8, 45)];
        view_.backgroundColor=[UIColor clearColor];
        
        UIView *bgView = [[UIView alloc]initWithFrame:view_.frame];
        bgView.backgroundColor = [UIColor whiteColor];
        [view_ addSubview:bgView];
        
//        UIView *line_secon_header=[[UIView alloc]initWithFrame:CGRectMake(20, 0, kMainScreenWidth-20, 0.5)];
//        line_secon_header.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
//        [view_ addSubview:line_secon_header];
        
        
        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, kMainScreenWidth - 100, 30)];
        designer_jianj.backgroundColor = [UIColor clearColor];
        designer_jianj.font = [UIFont systemFontOfSize:18.0];
        designer_jianj.textAlignment = NSTextAlignmentLeft;
//        designer_jianj.textColor = kThemeColor;
        designer_jianj.text = [NSString stringWithFormat:@"%@ %.2f元",contractPhaseModel.phraseName,contractPhaseModel.phraseFee/100];
        [view_ addSubview:designer_jianj];
        
        UIImageView *roundIV3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
        roundIV3.image = [UIImage imageNamed:@"bg_shuzi_3.png"];
        [view_ addSubview:roundIV3];
        
        UIView *verticalLineView3 = [[UIView alloc]initWithFrame:CGRectMake(32.5, roundIV3.frame.origin.y + roundIV3.frame.size.height, 2, 25)];
        verticalLineView3.backgroundColor = kThemeColor;
        [view_ addSubview:verticalLineView3];
        
        self.imv_zkai_third = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
        self.imv_zkai_third.frame = CGRectMake(kMainScreenWidth-30, 18, 10, 20);
        [view_ addSubview:self.imv_zkai_third];
        if(is_change_third==YES){
            if(is_open_third){
                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                [spinAnimation setFromValue:[NSNumber numberWithFloat:0]];
                [spinAnimation setToValue:[NSNumber numberWithDouble:M_PI/2]];
                [spinAnimation setDelegate:self];
                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [spinAnimation setDuration:0.2];
                [self.imv_zkai_third.layer addAnimation:spinAnimation forKey:@"spin"];
                [self.imv_zkai_third.layer setTransform:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)];
                
            }
            else{
                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                [spinAnimation setFromValue:[NSNumber numberWithFloat:M_PI/2]];
                [spinAnimation setToValue:[NSNumber numberWithDouble:0]];
                [spinAnimation setDelegate:self];
                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [spinAnimation setDuration:0.2];
                [self.imv_zkai_third.layer addAnimation:spinAnimation forKey:@"spin"];
                [self.imv_zkai_third.layer setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];
            }
        }
        
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headerBtn.frame = CGRectMake(0, 0, kMainScreenWidth, 50);
        headerBtn.tag = 1003;
        [headerBtn addTarget:self
                      action:@selector(tapHeader:)
            forControlEvents:UIControlEventTouchUpInside];
        [view_ addSubview:headerBtn];
        
        return view_;
    } if(section==4){
        ContractPhaseModel *contractPhaseModel = [_contractPhaseModelArr objectAtIndex:section - 1];
        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(60, 5, kMainScreenWidth - 60 - 8, 45)];
        view_.backgroundColor=[UIColor clearColor];
        
        UIView *bgView = [[UIView alloc]initWithFrame:view_.frame];
        bgView.backgroundColor = [UIColor whiteColor];
        [view_ addSubview:bgView];
        
//        UIView *line_secon_header=[[UIView alloc]initWithFrame:CGRectMake(20, 0, kMainScreenWidth-20, 0.5)];
//        line_secon_header.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.5];
//        [view_ addSubview:line_secon_header];
        
        
        UILabel *designer_jianj = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, kMainScreenWidth - 100, 30)];
        designer_jianj.backgroundColor = [UIColor clearColor];
        designer_jianj.font = [UIFont systemFontOfSize:18.0];
        designer_jianj.textAlignment = NSTextAlignmentLeft;
//        designer_jianj.textColor = kThemeColor;
        designer_jianj.text = [NSString stringWithFormat:@"%@ %.2f元",contractPhaseModel.phraseName,contractPhaseModel.phraseFee/100];
        [view_ addSubview:designer_jianj];
        
        UIImageView *roundIV4 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
        roundIV4.image = [UIImage imageNamed:@"bg_shuzi_4.png"];
        [view_ addSubview:roundIV4];
        
        self.imv_zkai_fourth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_jiantou_lb"]];
        self.imv_zkai_fourth.frame = CGRectMake(kMainScreenWidth-30, 18, 10, 20);
        [view_ addSubview:self.imv_zkai_fourth];
        if(is_change_fourth==YES){
            if(is_open_fourth){
                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                [spinAnimation setFromValue:[NSNumber numberWithFloat:0]];
                [spinAnimation setToValue:[NSNumber numberWithDouble:M_PI/2]];
                [spinAnimation setDelegate:self];
                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [spinAnimation setDuration:0.2];
                [self.imv_zkai_fourth.layer addAnimation:spinAnimation forKey:@"spin"];
                [self.imv_zkai_fourth.layer setTransform:CATransform3DMakeRotation(M_PI/2, 0, 0, 1)];
                
            }
            else{
                CABasicAnimation *spinAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                [spinAnimation setFromValue:[NSNumber numberWithFloat:M_PI/2]];
                [spinAnimation setToValue:[NSNumber numberWithDouble:0]];
                [spinAnimation setDelegate:self];
                [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [spinAnimation setDuration:0.2];
                [self.imv_zkai_fourth.layer addAnimation:spinAnimation forKey:@"spin"];
                [self.imv_zkai_fourth.layer setTransform:CATransform3DMakeRotation(0, 0, 0, 1)];
            }
        }
        
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headerBtn.frame = CGRectMake(0, 0, kMainScreenWidth, 50);
        headerBtn.tag = 1004;
        [headerBtn addTarget:self
                      action:@selector(tapHeader:)
            forControlEvents:UIControlEventTouchUpInside];
        [view_ addSubview:headerBtn];
        
        return view_;
    } else {
        UIView *view_=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.1)];
        view_.backgroundColor=[UIColor clearColor];
        return nil;
    }

}


-(void)PressBarItemLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapHeader:(UIButton *)sender {
    if (sender.tag==1001) {
        is_change_first=YES;
        is_change_second = NO;
        is_change_third = NO;
        is_change_fourth = NO;
        self.count_second=0;
        self.count_third = 0;
        self.count_fouth = 0;
        if(is_open_first) {
            is_open_second=NO;
            is_open_third = NO;
            is_open_fourth = NO;
            is_open_first=!is_open_first;
            self.count_first=0;
        }
        else {
            is_open_second=NO;
            is_open_third = NO;
            is_open_fourth = NO;
            is_open_first=!is_open_first;
            self.count_first=1;
        }
        [_theTableView reloadData];
    }
    if (sender.tag==1002) {
        is_change_first=NO;
        is_change_second = YES;
        is_change_third = NO;
        is_change_fourth = NO;
        self.count_first=0;
        self.count_third = 0;
        self.count_fouth = 0;
        if(is_open_second) {
            is_open_first=NO;
            is_open_third = NO;
            is_open_fourth = NO;
            is_open_second=!is_open_second;
            self.count_second=0;
        }
        else {
            is_open_first=NO;
            is_open_third = NO;
            is_open_fourth = NO;
            is_open_second=!is_open_second;
            self.count_second=1;
        }
        [_theTableView reloadData];
    }
    if (sender.tag==1003) {
        is_change_first=NO;
        is_change_second = NO;
        is_change_third = YES;
        is_change_fourth = NO;
        self.count_first=0;
        self.count_second = 0;
        self.count_fouth = 0;
        if(is_open_third) {
            is_open_first=NO;
            is_open_second = NO;
            is_open_fourth = NO;
            is_open_third=!is_open_third;
            self.count_third=0;
        }
        else {
            is_open_first=NO;
            is_open_second = NO;
            is_open_fourth = NO;
            is_open_third=!is_open_third;
            self.count_third=1;
        }
        [_theTableView reloadData];
    }
    if (sender.tag==1004) {
        is_change_first=NO;
        is_change_second = NO;
        is_change_third = NO;
        is_change_fourth = YES;
        self.count_first=0;
        self.count_second = 0;
        self.count_third = 0;
        if(is_open_fourth) {
            is_open_first=NO;
            is_open_second = NO;
            is_open_third = NO;
            is_open_fourth=!is_open_fourth;
            self.count_fouth=0;
        }
        else {
            is_open_first=NO;
            is_open_second = NO;
            is_open_third = NO;
            is_open_fourth=!is_open_fourth;
            self.count_fouth=1;
        }
        [_theTableView reloadData];
    }
}

//请求订单详情(合同形式)
-(void)requestOrderDetail{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0112\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"orderCode\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.orderIDStr];
        [self startRequestWithString:@"加载中..."];
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                //token为空或验证未通过处理 huangrun
                if (kResCode == 10002 || kResCode == 10003) {
                    self.view.tag = 1002;
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                    login.delegate=self;
                    [login show];
                    return;
                    });
                }

                if (code==1) {
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary *contractResDic = [jsonDict objectForKey:@"contractInfo"];
                        _contractModel = [ContractModel objectWithKeyValues:contractResDic];
                        NSMutableArray *phaseListArr = [jsonDict objectForKey:@"phaseList"];
                        _contractPhaseModelArr = [ContractPhaseModel objectArrayWithKeyValuesArray:phaseListArr];
                        if ([self.sourceVC isEqualToString:@"myOrderContentVC"])
                        [self configBottomView];
                        [_theTableView reloadData];
                    });
                }
                else if (code == 0){
                    [self stopRequest];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [TLToast showWithText:@"数据加载失败"];
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:nil];
    });
    
    
}

- (void)configBottomView {
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight - kNavigationBarHeight - 60, kMainScreenWidth, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    if (self.orderStateInteger == 1) {
        UIButton *firstBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 10, (kMainScreenWidth-100)/3 , 40)];
        [firstBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        firstBtn.backgroundColor = [UIColor clearColor];
        firstBtn.layer.masksToBounds = YES;
        firstBtn.layer.cornerRadius = 3;
        firstBtn.layer.borderColor = kThemeColor.CGColor;
        firstBtn.layer.borderWidth = 1;
        
        UIButton *secondBtn = [[UIButton alloc]initWithFrame:CGRectMake(50 +(kMainScreenWidth-100)/3 * 2, 10,  (kMainScreenWidth-100)/3 , 40)];
        [secondBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        secondBtn.backgroundColor = kThemeColor;
        secondBtn.layer.masksToBounds = YES;
        secondBtn.layer.cornerRadius = 3;
        
        [firstBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        firstBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [firstBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        [secondBtn setTitle:@"确认订单" forState:UIControlStateNormal];
        secondBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [secondBtn addTarget:self action:@selector(requestConfirmOrderOrConfirmPaying:) forControlEvents:UIControlEventTouchUpInside];
        
        [bottomView addSubview:firstBtn];
        [bottomView addSubview:secondBtn];
    }
    
    [self.view addSubview:bottomView];
    _theTableView.frame = CGRectMake(0, 0, _theTableView.frame.size.width, _theTableView.frame.size.height - 65);
}

#pragma mark - 确认、拒绝订单与确定付款
-(void)requestConfirmOrderOrConfirmPaying:(UIButton *)sender {
    
    NSString *actionTypeStr;
    if (self.orderStateInteger == 1) {
        actionTypeStr = @"2";
    } else {
        actionTypeStr = @"";
    }
    
    NSString *secretKeyStr;
    if (self.orderStateInteger != 7 && self.orderStateInteger != 8) {
        secretKeyStr = @"";
    } else {
        
    }
    
    //确认订单（合同）记日志
    if(self.orderStateInteger == 1) [savelogObj saveLog:@"确认订单（合同）" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:59];
    
    
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
        [postDict setObject:@"ID0113" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"orderCode":self.orderIDStr,@"actionType":actionTypeStr,@"secretKey":secretKeyStr};
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
                    [self stopRequest];
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 11301) {
                        [TLToast showWithText:@"订单确认成功"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNCUpdateOrderStatus object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else if (kResCode == 11302) {
                        [TLToast showWithText:@"订单确认失败"];
                    } else if (kResCode == 11303) {
                        [TLToast showWithText:@"请输入或设置支付密码"];
                    }else if (kResCode == 11305) {
                        [TLToast showWithText:@"支付密码不正确"];
                    }else{
                        [TLToast showWithText:@"订单确认失败"];
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

-(void)createPhone{
    self.btn_phone = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_phone.frame=CGRectMake(kMainScreenWidth-50, kMainScreenHeight-250, 50, 50);
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh_mor.png"] forState:UIControlStateNormal];
    [self.btn_phone setBackgroundImage:[UIImage imageNamed:@"bt_ddh.png"] forState:UIControlStateHighlighted];
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

- (void)pressbtn:(UIButton *)sender {
    NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",_contractModel.servantPhoneNo];
    UIWebView *callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
    [self.view addSubview:callWebview];
}

#pragma mark - 取消订单
- (void)cancelOrder:(UIButton *)sender {
    NSString *actionTypeStr;
    if (self.orderStateInteger == 1) {
        actionTypeStr = @"3";
    } else {
        actionTypeStr = @"";
    }
    
    NSString *secretKeyStr;
    
    if (self.orderStateInteger == 7) {
        
        [savelogObj saveLog:@"确认付款" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:62];
        
        InputPayPsdViewController *inputPayPsdVC = [[InputPayPsdViewController alloc]init];
        inputPayPsdVC.myOrderModel = self.myOrderModel;
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav pushViewController:inputPayPsdVC animated:YES];
        return;
        
    } else if (self.orderStateInteger == 8) {
        
    } else {
        secretKeyStr = @"";
    }
    
    //取消订单（合同）记日志
    if(self.orderStateInteger == 1) [savelogObj saveLog:@"取消订单（合同）" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:60];
    
    
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
        [postDict setObject:@"ID0113" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"orderCode":self.orderIDStr,@"actionType":actionTypeStr,@"secretKey":secretKeyStr};
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
                    [self stopRequest];
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 11301) {
                        [TLToast showWithText:@"订单取消成功"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNCUpdateOrderStatus object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else if (kResCode == 11302) {
                        [TLToast showWithText:@"订单取消失败"];
                    } else if (kResCode == 11303) {
                        [TLToast showWithText:@"请输入或设置支付密码"];
                    }else if (kResCode == 11305) {
                        [TLToast showWithText:@"支付密码不正确"];
                    }else{
                        [TLToast showWithText:@"订单确认失败"];
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
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self requestOrderDetail];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self requestOrderDetail];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
