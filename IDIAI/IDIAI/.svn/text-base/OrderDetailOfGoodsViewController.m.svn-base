//
//  OrderDetailOfGoodsViewController.m
//  IDIAI
//
//  Created by Ricky on 15/5/11.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "OrderDetailOfGoodsViewController.h"
#import "LoginView.h"
#import "OrderOfGoodsListModel.h"
#import "UIImageView+WebCache.h"
#import "CommentOfGoodsViewController.h"
#import "RefundOfApplyGoodsViewController.h"
#import "TLToast.h"
#import "AfterSaleOfGoodsViewController.h"
#import "IDIAIAppDelegate.h"
#import "PayingConfirmViewController.h"
#import "InputPayPsdViewController.h"
#import "ShopOfGoodsViewController.h"
#import "ShoppingCartOfGoodsModel.h"
#import "GoodsDetailViewController.h"
#import "util.h"
#import "savelogObj.h"
#import "CustomPromptView.h"
#import "OnlinePayViewController.h"
#import "PreferentialObject.h"
#import "CouponMainViewController.h"
#define IS_iOS8 [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue]

@interface OrderDetailOfGoodsViewController () <UITableViewDataSource, UITableViewDelegate,LoginViewDelegate,UIAlertViewDelegate>{
 
    UITableView *_theTableView;
    UIView *_row1View;
    UIView *_lastRowView2;
    NSArray *_rowDataArr;
    OrderOfGoodsListModel *_detailModel;
//    NSString *_callNum;
    CustomPromptView *customPromp;
}

@property (strong, nonatomic) UIButton *btn_phone;
@property(nonatomic,strong)PreferentialObject *preferential;
@property(nonatomic,assign)double couponNum;
@end

@implementation OrderDetailOfGoodsViewController


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    [self customizeNavigationBar];
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav setNavigationBarHidden:NO animated:NO];
    
    [self requestGoodsDetail];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderStatus:) name:kNCUpdateOrderStatus object:nil];
    //导航右按钮
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 90, 40)];
    [rightButton setImage:[UIImage imageNamed:@"btn_dianhua"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0, 25, 0, -5);
    [rightButton addTarget:self
                    action:@selector(PressBarItemRight:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setFrame:CGRectMake(5, 5, 40, 40)];
//    [rightButton setImage:[UIImage imageNamed:@"ico_kefu"] forState:UIControlStateNormal];
//    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [rightButton addTarget:self
//                    action:@selector(PressBarItemRight:)
//          forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    _theTableView = [[UITableView alloc]initWithFrame:kTableViewFrame style:UITableViewStyleGrouped];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_theTableView];
    
    _row1View = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 20, 44)];
    UIImageView *shopHeadIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    shopHeadIV.tag = 1001;
    shopHeadIV.layer.masksToBounds = YES;
    shopHeadIV.layer.cornerRadius = 12;
    UILabel *shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(34+ 5, 0, kMainScreenWidth - 20 - 34 - 5, 44)];
    shopNameLabel.tag = 1002;
    [_row1View addSubview:shopHeadIV];
    [_row1View addSubview:shopNameLabel];
    UITapGestureRecognizer *tapShopViewGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShopView:)];
    [_row1View addGestureRecognizer:tapShopViewGR];
    
    _lastRowView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 20, 44)];
    _lastRowView2.backgroundColor = [UIColor whiteColor];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 addTarget:self action:@selector(clickActionBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.tag = 10010;
    btn1.frame = CGRectMake(kMainScreenWidth - 20 - 10 - 80, 2, 80, 30);
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 3;
    btn1.layer.borderColor = kThemeColor.CGColor;
    btn1.layer.borderWidth = 1.0;
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn2 addTarget:self action:@selector(clickActionBtn2:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.tag = 10011;
    btn2.frame = CGRectMake(btn1.frame.origin.x - 10 - 80, 2, 80, 30);
    btn2.layer.masksToBounds = YES;
    btn2.layer.cornerRadius = 3;
    btn2.layer.borderColor = kThemeColor.CGColor;
    btn2.layer.borderWidth = 1.0;
    [_lastRowView2 addSubview:btn1];
    [_lastRowView2 addSubview:btn2];
    
    [self loadImageviewBG];
//    [self requestCallNum];
    [self createPhone];

}
- (void)updateOrderStatus:(NSNotification *)notification {
    [self requestGoodsDetail];
//    [_theTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.couponNum>0) {
        return 3;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section==1){
        if (self.couponNum>0) {
            return 1;
        }else{
            return [_detailModel.shopOrderDetailes count]+4;
        }
    }
    else {
     return [_detailModel.shopOrderDetailes count]+4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 175+5;
    }else if (indexPath.section==1){
        if (self.couponNum>0) {
            return 44;
        }else{
            if (indexPath.row == 0 || indexPath.row == [_detailModel.shopOrderDetailes count]+1) {
                return 44;
            }
            else if(indexPath.row == [_detailModel.shopOrderDetailes count]+2){
                _detailModel.userMessage =[_detailModel.userMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if(_detailModel.userMessage.length>=1){
                    CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"给卖家留言：%@",_detailModel.userMessage] width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:14]];
                    return 44+size.height+70;
                }
                else{
                    if (_detailModel.orderTotalMoney!=_detailModel.originalTotalFee){
                       return 44+20;
                    }else{
                        return 44;
                    }
                    
                }
                
            }
            else if(indexPath.row == [_detailModel.shopOrderDetailes count]+3){
                if (_detailModel.state == 4 || _detailModel.state == 5  || _detailModel.state == 7){
                    _lastRowView2.frame=CGRectMake(0, 0, kMainScreenWidth , 0);
                    return 0;
                }
                else return 44;
            }
            else {
                //当state=4 即已完成时 才显示评论、售后等按钮
                if (_detailModel.state == 4) return 130;
                else return 100;
            }

        }
        
    }
    else {
//        if (indexPath.row == 0 || indexPath.row == [_detailModel.shopOrderDetailes count]+3 || indexPath.row == [_detailModel.shopOrderDetailes count]+2 || indexPath.row == [_detailModel.shopOrderDetailes count]+1) {
//            return 44;
//        } else {
//            return 120;
//        }
        
        if (indexPath.row == 0 || indexPath.row == [_detailModel.shopOrderDetailes count]+1) {
            return 44;
        }
        else if(indexPath.row == [_detailModel.shopOrderDetailes count]+2){
            _detailModel.userMessage =[_detailModel.userMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if(_detailModel.userMessage.length>=1){
                CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"给卖家留言：%@",_detailModel.userMessage] width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:14]];
                return 44+size.height+70;
            }
            else{
                if (_detailModel.orderTotalMoney!=_detailModel.originalTotalFee){
                    return 44+20;
                }else{
                    return 44;
                }
//                return 44;
            }
            
        }
        else if(indexPath.row == [_detailModel.shopOrderDetailes count]+3){
            if (_detailModel.state == 4 || _detailModel.state == 5  || _detailModel.state == 7){
                _lastRowView2.frame=CGRectMake(0, 0, kMainScreenWidth , 0);
                return 0;
            }
            else return 44;
        }
        else {
            //当state=4 即已完成时 才显示评论、售后等按钮
            if (_detailModel.state == 4) return 130;
            else return 100;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier1 = [NSString stringWithFormat:@"Cell1%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier2 = [NSString stringWithFormat:@"Cell2%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier3 = [NSString stringWithFormat:@"Cell3%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier4 = [NSString stringWithFormat:@"Cell4%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier5 = [NSString stringWithFormat:@"Cell5%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier6 = [NSString stringWithFormat:@"Cell6%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier7 = [NSString stringWithFormat:@"Cell7%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];

    }else if (indexPath.section==1){
        if (self.couponNum>0) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier7];
        }else{
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
                
            } else if (indexPath.row == [_detailModel.shopOrderDetailes count]+3) {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
                
            } else if (indexPath.row == [_detailModel.shopOrderDetailes count]+2) {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
                
            } else if (indexPath.row == [_detailModel.shopOrderDetailes count]+1) {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier5];
                
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier6];
                
            }
        }
    }
    else {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];

        } else if (indexPath.row == [_detailModel.shopOrderDetailes count]+3) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];

        } else if (indexPath.row == [_detailModel.shopOrderDetailes count]+2) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4];

        } else if (indexPath.row == [_detailModel.shopOrderDetailes count]+1) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier5];

        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier6];

        }
    }
    
//    if (cell == nil) {

        if (indexPath.section == 0) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailOfGoodsCell" owner:self options:nil]lastObject];
            
        }else if (indexPath.section==1){
            if (self.couponNum<=0) {
                if (indexPath.row == 0) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
                    [cell.contentView addSubview:_row1View];
                    
                    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 42, kMainScreenWidth-20, 0.3)];
                    line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
                    [cell addSubview:line];
                    
                } else if (indexPath.row == [_detailModel.shopOrderDetailes count]+3) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
                    [cell.contentView addSubview:_lastRowView2];
                } else if (indexPath.row == [_detailModel.shopOrderDetailes count]+2) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier4];
                    
                    UILabel *moneyLabel = (UILabel *)[cell viewWithTag:1004];
                    if(!moneyLabel) moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 32, (kMainScreenWidth-40)/2-50, 20)];//注：frame根据内容动态设置 暂不
                    moneyLabel.textAlignment = NSTextAlignmentLeft;
                    moneyLabel.textColor = kThemeColor;
                    moneyLabel.font=[UIFont systemFontOfSize:20];
                    moneyLabel.tag = 1004;
                    [cell addSubview:moneyLabel];
                    
                    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1005];
                    if(!titleLabel) titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 32, kMainScreenWidth/2, 20)];
                    titleLabel.tag = 1005;
                    titleLabel.font=[UIFont systemFontOfSize:11];
                    titleLabel.textAlignment = NSTextAlignmentRight;
                    titleLabel.textColor=[UIColor darkGrayColor];
                    if (_detailModel.originalTotalFee!=_detailModel.orderTotalMoney) {
                        titleLabel.text = @"合计：";
                    }else{
                        titleLabel.text = @"实付：";
                    }
                    [cell addSubview:titleLabel];
                    if (_detailModel.orderTotalMoney!=_detailModel.originalTotalFee) {
                        UILabel *realPayLabel = (UILabel *)[cell viewWithTag:1006];
                        if(!realPayLabel) realPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+(kMainScreenWidth-40)/2, 40, (kMainScreenWidth-40)/2, 20)];//注：frame根据内容动态设置 暂不
                        realPayLabel.textAlignment = NSTextAlignmentRight;
                        realPayLabel.textColor = kThemeColor;
                        realPayLabel.font=[UIFont systemFontOfSize:20];
                        realPayLabel.tag = 1006;
                        [cell addSubview:realPayLabel];
                    }
                    
                    
                    UILabel *alreadyPay =[[UILabel alloc] init];
                    UILabel *waitePay =[[UILabel alloc] init];
                    if (_detailModel.state ==10) {
                        alreadyPay.frame =CGRectMake(20, 12, (kMainScreenWidth-40)/2, 20);
                        alreadyPay.font =[UIFont systemFontOfSize:15];
                        alreadyPay.tag =1010;
                        waitePay.frame =CGRectMake(20+(kMainScreenWidth-40)/2, 12, (kMainScreenWidth-40)/2, 20);
                        waitePay.font =[UIFont systemFontOfSize:15];
                        waitePay.textAlignment =NSTextAlignmentRight;
                        waitePay.tag =1011;
                        [cell addSubview:alreadyPay];
                        [cell addSubview:waitePay];
                    }
                    
                    UILabel *label_message = (UILabel *)[cell viewWithTag:108];
                    if(!label_message)label_message=[[UILabel alloc]initWithFrame:CGRectMake(15, 55, kMainScreenWidth-30, 20)];
                    label_message.tag=108;
                    label_message.backgroundColor=[UIColor clearColor];
                    label_message.font=[UIFont systemFontOfSize:14];
                    label_message.textColor=[UIColor grayColor];
                    label_message.textAlignment=NSTextAlignmentLeft;
                    label_message.numberOfLines=0;
                    [cell addSubview:label_message];
                    
                } else if (indexPath.row == [_detailModel.shopOrderDetailes count]+1) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier5];
                    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"OrderOfGoodsView2" owner:self options:nil]lastObject];
                    view.frame = CGRectMake(0, 0, kMainScreenWidth , view.frame.size.height);
                    [cell.contentView addSubview:view];
                    
                    //                UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 3, kMainScreenWidth-20, 0.3)];
                    //                line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
                    //                [cell addSubview:line];
                    //
                    //                UIView *line_bottom=[[UIView alloc]initWithFrame:CGRectMake(10, 42, kMainScreenWidth-20, 0.3)];
                    //                line_bottom.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
                    //                [cell addSubview:line_bottom];
                    
                } else {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier6];
                    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"OrderOfGoodsView" owner:self options:nil]lastObject];
                    UITapGestureRecognizer *tapGoodsViewGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGoodsView:)];
                    [view addGestureRecognizer:tapGoodsViewGR];
                    view.frame = CGRectMake(0, 0, kMainScreenWidth, view.frame.size.height);
                    [cell.contentView addSubview:view];
                    
                    UIButton *commentBtn = (UIButton *)[cell viewWithTag:105];
                    [commentBtn addTarget:self action:@selector(clickCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
                    UIButton *refundBtn = (UIButton *)[cell viewWithTag:106];
                    [refundBtn addTarget: self action:@selector(clickRefundBtn:) forControlEvents:UIControlEventTouchUpInside];
                    UIButton *afterSaleBtn= (UIButton *)[cell viewWithTag:107];
                    [afterSaleBtn addTarget:self action:@selector(clickAfterSaleBtn:) forControlEvents:UIControlEventTouchUpInside];
                    
                    commentBtn.layer.masksToBounds = YES;
                    commentBtn.layer.cornerRadius = 3;
                    commentBtn.layer.borderColor = kThemeColor.CGColor;
                    commentBtn.layer.borderWidth = 1;
                    
                    refundBtn.layer.masksToBounds = YES;
                    refundBtn.layer.cornerRadius = 3;
                    refundBtn.layer.borderColor = kThemeColor.CGColor;
                    refundBtn.layer.borderWidth = 1;
                    
                    afterSaleBtn.layer.masksToBounds = YES;
                    afterSaleBtn.layer.cornerRadius = 3;
                    afterSaleBtn.layer.borderColor = kThemeColor.CGColor;
                    afterSaleBtn.layer.borderWidth = 1;
                    
                    //当state=4 即已完成时 才显示这三个按钮
                    //                OrderOfGoodsListModel *orderOfGoodsListModel = [_detailModel.shopOrderDetailes objectAtIndex:indexPath.row];
                    if (_detailModel.state == 4) {
                        commentBtn.hidden = NO;
                        refundBtn.hidden = NO;
                        afterSaleBtn.hidden = NO;
                        view.frame =CGRectMake(0, 0, kMainScreenWidth, 130);
                    }
                    else{
                        commentBtn.hidden = YES;
                        refundBtn.hidden = YES;
                        afterSaleBtn.hidden = YES;
                        view.frame =CGRectMake(0, 0, kMainScreenWidth, 100);
                    }
                    
                }

            }else{
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier7];
                UIButton *couponbtn =[UIButton buttonWithType:UIButtonTypeCustom];
                couponbtn.frame =CGRectMake(15, 0, kMainScreenWidth-30, 44);
//                [couponbtn addTarget:self action:@selector(couponbtn:) forControlEvents:UIControlEventTouchUpInside];
                couponbtn.tag =10001;
                [cell addSubview:couponbtn];
                
                UILabel *couponlbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 13.5, 51, 17)];
                couponlbl.text =@"优惠券";
                couponlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                couponlbl.tag =100;
                [couponbtn addSubview:couponlbl];
                
                NSString *contentstr =[NSString string];
                contentstr =[NSString stringWithFormat:@"已优惠￥ %.2f",self.couponNum];
//                if (self.preferential) {
//                    if (self.preferential.couponType==0) {
//                        if (_detailModel.orderTotalMoney>[self.preferential.couponValue doubleValue]) {
//                            contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %@",self.preferential.couponValue];
//                        }else{
//                            contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %.0f",_detailModel.orderTotalMoney];
//                        }
//                        
//                    }else{
//                        contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %.2f",_detailModel.orderTotalMoney-_detailModel.orderTotalMoney*[self.preferential.couponValue doubleValue]/10];
//                    }
//                }
                CGSize labelsize = [util calHeightForLabel:contentstr width:kMainScreenWidth-81 font:[UIFont systemFontOfSize:15]];
                UILabel *couponcontent =[[UILabel alloc] initWithFrame:CGRectMake(couponlbl.frame.origin.x+couponlbl.frame.size.width+10, 13.5, labelsize.width+20, labelsize.height)];
                //        if (self.preferential&&[self.contractDetail.state intValue]==1) {
                //            couponcontent.frame =CGRectMake(couponlbl.frame.origin.x+couponlbl.frame.size.width+10, 8.5, labelsize.width+20, labelsize.height);
                //        }
                couponcontent.tag =101;
                couponcontent.textColor =[UIColor whiteColor];
                couponcontent.backgroundColor =[UIColor colorWithHexString:@"#ef6562"];
                couponcontent.font =[UIFont systemFontOfSize:15];
                couponcontent.text =contentstr;
                couponcontent.layer.masksToBounds = YES;
                couponcontent.layer.cornerRadius = 5;
                couponcontent.layer.borderColor = [UIColor colorWithHexString:@"#ef6562"].CGColor;
                couponcontent.layer.borderWidth = 1;
                couponcontent.textAlignment =NSTextAlignmentCenter;
                [couponbtn addSubview:couponcontent];
            }
        }
        else {
            if (indexPath.row == 0) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
                [cell.contentView addSubview:_row1View];
                
                UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 42, kMainScreenWidth-20, 0.3)];
                line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
                [cell addSubview:line];
                
            } else if (indexPath.row == [_detailModel.shopOrderDetailes count]+3) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
                [cell.contentView addSubview:_lastRowView2];
            } else if (indexPath.row == [_detailModel.shopOrderDetailes count]+2) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier4];
                
                UILabel *moneyLabel = (UILabel *)[cell viewWithTag:1004];
                if(!moneyLabel) moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 32, kMainScreenWidth-120, 20)];//注：frame根据内容动态设置 暂不
                moneyLabel.textAlignment = NSTextAlignmentLeft;
                moneyLabel.textColor = kThemeColor;
                moneyLabel.font=[UIFont systemFontOfSize:20];
                moneyLabel.tag = 1004;
                [cell addSubview:moneyLabel];
                
                UILabel *titleLabel = (UILabel *)[cell viewWithTag:1005];
                if(!titleLabel) titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 32, kMainScreenWidth/2, 20)];
                titleLabel.tag = 1005;
                titleLabel.font=[UIFont systemFontOfSize:11];
                titleLabel.textAlignment = NSTextAlignmentRight;
                titleLabel.textColor=[UIColor darkGrayColor];
                titleLabel.text = @"合计：";
                [cell addSubview:titleLabel];
                
                if (_detailModel.orderTotalMoney!=_detailModel.originalTotalFee) {
                    UILabel *realPayLabel = (UILabel *)[cell viewWithTag:1006];
                    if(!realPayLabel) realPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+(kMainScreenWidth-40)/2, 40, (kMainScreenWidth-40)/2, 20)];//注：frame根据内容动态设置 暂不
                    realPayLabel.textAlignment = NSTextAlignmentRight;
                    realPayLabel.textColor = kThemeColor;
                    realPayLabel.font=[UIFont systemFontOfSize:20];
                    realPayLabel.tag = 1006;
                    [cell addSubview:realPayLabel];
                }
                
                UILabel *alreadyPay =[[UILabel alloc] init];
                UILabel *waitePay =[[UILabel alloc] init];
                if (_detailModel.state ==10) {
                    alreadyPay.frame =CGRectMake(20, 12, (kMainScreenWidth-40)/2, 20);
                    alreadyPay.font =[UIFont systemFontOfSize:15];
                    alreadyPay.tag =1010;
                    waitePay.frame =CGRectMake(20+(kMainScreenWidth-40)/2, 12, (kMainScreenWidth-40)/2, 20);
                    waitePay.font =[UIFont systemFontOfSize:15];
                    waitePay.textAlignment =NSTextAlignmentRight;
                    waitePay.tag =1011;
                    [cell addSubview:alreadyPay];
                    [cell addSubview:waitePay];
                }
                
                UILabel *label_message = (UILabel *)[cell viewWithTag:108];
                if(!label_message)label_message=[[UILabel alloc]initWithFrame:CGRectMake(15, 55, kMainScreenWidth-30, 20)];
                label_message.tag=108;
                label_message.backgroundColor=[UIColor clearColor];
                label_message.font=[UIFont systemFontOfSize:14];
                label_message.textColor=[UIColor grayColor];
                label_message.textAlignment=NSTextAlignmentLeft;
                label_message.numberOfLines=0;
                [cell addSubview:label_message];

            } else if (indexPath.row == [_detailModel.shopOrderDetailes count]+1) {
                 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier5];
                UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"OrderOfGoodsView2" owner:self options:nil]lastObject];
                view.frame = CGRectMake(0, 0, kMainScreenWidth , view.frame.size.height);
                [cell.contentView addSubview:view];

//                UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 3, kMainScreenWidth-20, 0.3)];
//                line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
//                [cell addSubview:line];
//                
//                UIView *line_bottom=[[UIView alloc]initWithFrame:CGRectMake(10, 42, kMainScreenWidth-20, 0.3)];
//                line_bottom.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
//                [cell addSubview:line_bottom];
            
            } else {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier6];
                UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"OrderOfGoodsView" owner:self options:nil]lastObject];
                UITapGestureRecognizer *tapGoodsViewGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGoodsView:)];
                [view addGestureRecognizer:tapGoodsViewGR];
                view.frame = CGRectMake(0, 0, kMainScreenWidth, view.frame.size.height);
                [cell.contentView addSubview:view];
                
                UIButton *commentBtn = (UIButton *)[cell viewWithTag:105];
                [commentBtn addTarget:self action:@selector(clickCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
                UIButton *refundBtn = (UIButton *)[cell viewWithTag:106];
                [refundBtn addTarget: self action:@selector(clickRefundBtn:) forControlEvents:UIControlEventTouchUpInside];
                UIButton *afterSaleBtn= (UIButton *)[cell viewWithTag:107];
                [afterSaleBtn addTarget:self action:@selector(clickAfterSaleBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                commentBtn.layer.masksToBounds = YES;
                commentBtn.layer.cornerRadius = 3;
                commentBtn.layer.borderColor = kThemeColor.CGColor;
                commentBtn.layer.borderWidth = 1;
                
                refundBtn.layer.masksToBounds = YES;
                refundBtn.layer.cornerRadius = 3;
                refundBtn.layer.borderColor = kThemeColor.CGColor;
                refundBtn.layer.borderWidth = 1;
                
                afterSaleBtn.layer.masksToBounds = YES;
                afterSaleBtn.layer.cornerRadius = 3;
                afterSaleBtn.layer.borderColor = kThemeColor.CGColor;
                afterSaleBtn.layer.borderWidth = 1;
                
                //当state=4 即已完成时 才显示这三个按钮
//                OrderOfGoodsListModel *orderOfGoodsListModel = [_detailModel.shopOrderDetailes objectAtIndex:indexPath.row];
                if (_detailModel.state == 4) {
                    commentBtn.hidden = NO;
                    refundBtn.hidden = NO;
                    afterSaleBtn.hidden = NO;
                    view.frame =CGRectMake(0, 0, kMainScreenWidth, 130);
                }
                else{
                    commentBtn.hidden = YES;
                    refundBtn.hidden = YES;
                    afterSaleBtn.hidden = YES;
                    view.frame =CGRectMake(0, 0, kMainScreenWidth, 100);
                }
                
            }

        }

    
//    }
    
    if (indexPath.section == 0) {
        
        UILabel *statusLabel = (UILabel *)[cell viewWithTag:101];
        statusLabel.text = _detailModel.stateName;
        UILabel *orderNumLabel = (UILabel *)[cell viewWithTag:102];
        orderNumLabel.text = [NSString stringWithFormat:@"%@",_detailModel.orderCode];
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:103];
        dateLabel.text = _detailModel.createAt;
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:104];
        nameLabel.text = _detailModel.buyerName;
        UILabel *cellPhoneLabel = (UILabel *)[cell viewWithTag:105];
        cellPhoneLabel.text = _detailModel.buyerPhone;
        UILabel *addressLabel = (UILabel *)[cell viewWithTag:106];
        addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",_detailModel.buyerAddress];
    }else if (indexPath.section ==1){
        if (self.couponNum<=0) {
            if (indexPath.row == 0) {
                UIImageView *shopHeadIV = (UIImageView *)[cell viewWithTag:1001];
                NSString *imgUrlStr = _detailModel.shopLogoPath;
                [shopHeadIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
                UILabel *shopNameLabel = (UILabel *)[cell viewWithTag:1002];
                shopNameLabel.text = _detailModel.shopName;
                
            } else if (indexPath.row == _detailModel.shopOrderDetailes.count + 3) {
                
                UIButton *btn1 = (UIButton *)[cell viewWithTag:10010];
                [btn1 setTitleColor:kThemeColor forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
                UIButton *btn2 = (UIButton *)[cell viewWithTag:10011];
                [btn2 setTitleColor:kThemeColor forState:UIControlStateNormal];
                [btn2 addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
                if (_detailModel.state == 1||_detailModel.state ==10) {
                    [btn1 setTitle:@"立即付款" forState:UIControlStateNormal];
                    [btn2 setTitle:@"关闭订单" forState:UIControlStateNormal];
                    btn1.hidden = NO;
                    btn2.hidden = NO;
                    if (_detailModel.state ==10) {
                        btn2.hidden =YES;
                    }
                } else if (_detailModel.state == 2) {
                    [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
                    btn1.hidden=NO;
                    btn2.hidden = YES;
                } else if (_detailModel.state == 3) {
                    [btn1 setTitle:@"确认收货" forState:UIControlStateNormal];
                    [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
                    btn1.hidden = NO;
                    btn2.hidden = NO;
                } else if (_detailModel.state == 4 || _detailModel.state == 5 || _detailModel.state == 6 || _detailModel.state == 7) {
                    //6代表取消订单中,7订单已取消
                    
                    btn1.hidden = YES;
                    btn2.hidden = YES;
                    if (_detailModel.state==6) {
                        [btn1 setTitle:@"关闭申请" forState:UIControlStateNormal];
                        btn1.hidden =NO;
                    }else{
                        btn1.hidden =YES;
                    }
                }
                
                
                
            } else if (indexPath.row == _detailModel.shopOrderDetailes.count + 2) {
                CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"￥%.2f",_detailModel.orderTotalMoney] width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:20]];
                
                
                UILabel *moneyLabelTitle = (UILabel *)[cell viewWithTag:1005];
                UILabel *moneyLabel = (UILabel *)[cell viewWithTag:1004];
                UILabel *realPayLabel = (UILabel *)[cell viewWithTag:1006];
                moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_detailModel.originalTotalFee];
                if (realPayLabel) {
                    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付:￥%.2f",_detailModel.orderTotalMoney]];
                    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,3)];
                    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str1.length-3)];
                    [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 3)];
                    [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(3,str1.length-3)];
                    realPayLabel.attributedText =str1;
                }
//                if (self.preferential) {
//                    if (self.preferential.couponType==0) {
//                        if (_detailModel.orderTotalMoney>[self.preferential.couponValue doubleValue]) {
////                            contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %@",self.preferential.couponValue];
//                            moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_detailModel.originalTotalFee];
//                            if (realPayLabel) {
//                                NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付:￥%.2f",_detailModel.orderTotalMoney]];
//                                [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,3)];
//                                [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str1.length-3)];
//                                [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 3)];
//                                [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(3,str1.length-3)];
//                                realPayLabel.attributedText =str1;
//                            }
//                        }else{
////                            contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %.0f",_detailModel.orderTotalMoney];
//                            moneyLabel.text = [NSString stringWithFormat:@"￥0.00"];
//                        }
//                        
//                    }else{
////                        contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %.2f",_detailModel.orderTotalMoney-_detailModel.orderTotalMoney*[self.preferential.couponValue doubleValue]/10];
//                        moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_detailModel.orderTotalMoney*[self.preferential.couponValue doubleValue]/10];
//                    }
//                }else{
//                    moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_detailModel.orderTotalMoney];
//
//                }
                
                CGSize size1=[util calHeightForLabel:moneyLabelTitle.text width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:11]];
                
                
                float alreadyPayheight=0;
                if (_detailModel.state ==10) {
                    UILabel *alreadyPayLabel = (UILabel *)[cell viewWithTag:1010];
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已支付:￥%.2f",_detailModel.alreadyPayment]];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(4,str.length-4)];
                    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 4)];
                    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(4,str.length-4)];
                    alreadyPayLabel.attributedText = str;
                    
                    UILabel *waitePayLabel = (UILabel *)[cell viewWithTag:1011];
                    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"未支付:￥%.2f",_detailModel.waitePayment]];
                    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
                    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(4,str1.length-4)];
                    [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 4)];
                    [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(4,str.length-4)];
                    waitePayLabel.attributedText = str1;
                    moneyLabel.frame=CGRectMake(20+size1.width, 42, 100, 20);
                    moneyLabelTitle.frame=CGRectMake(20, 42, size1.width, 20);
//                    moneyLabel.backgroundColor =[UIColor purpleColor];
                    alreadyPayheight +=moneyLabelTitle.frame.origin.y+moneyLabelTitle.frame.size.height;
                }else{
                    UILabel *alreadyPayLabel = (UILabel *)[cell viewWithTag:1010];
                    alreadyPayLabel.text =@"";
                    UILabel *waitePayLabel = (UILabel *)[cell viewWithTag:1011];
                    waitePayLabel.text =@"";
                    moneyLabel.frame=CGRectMake(20+size1.width, 12, 100, 20);
                    moneyLabelTitle.frame=CGRectMake(20, 12, size1.width, 20);
//                    moneyLabel.backgroundColor =[UIColor purpleColor];
                    alreadyPayheight +=moneyLabelTitle.frame.origin.y+moneyLabelTitle.frame.size.height;
                }
                
                _detailModel.userMessage =[_detailModel.userMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if(_detailModel.userMessage.length>=1){
                    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, alreadyPayheight+12, kMainScreenWidth-20, 0.3)];
                    line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
                    [cell addSubview:line];
                    
                    CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"给卖家留言：%@",_detailModel.userMessage] width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:14]];
                    UILabel *label_message = (UILabel *)[cell viewWithTag:108];
                    label_message.frame=CGRectMake(15, line.frame.origin.y+line.frame.size.height+10, kMainScreenWidth-30, size.height);
                    label_message.text=[NSString stringWithFormat:@"给卖家留言：%@",_detailModel.userMessage];
//                    label_message.backgroundColor =[UIColor blueColor];
                    
                    
                    
                    UIView *line_bottom=[[UIView alloc]initWithFrame:CGRectMake(10, 100+size.height+10, kMainScreenWidth-20, 1)];
                    line_bottom.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
                    [cell addSubview:line_bottom];
//                    cell.backgroundColor =[UIColor redColor];
                }
                
            } else if (indexPath.row == _detailModel.shopOrderDetailes.count + 1) {
                
                UILabel *numLabel = (UILabel *)[cell viewWithTag:101];
                NSInteger count = 0;
                for (NSDictionary *dic in _detailModel.shopOrderDetailes) {
                    count += [[dic objectForKey:@"goodsCount"]integerValue];
                }
                numLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
                
                UILabel *moneyLabel = (UILabel *)[cell viewWithTag:102];
                moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_detailModel.goodsTotalMoney];
                UILabel *shipFeeLabel = (UILabel *)[cell viewWithTag:103];
                shipFeeLabel.text = [NSString stringWithFormat:@"￥%.2f",_detailModel.shipFee];
            }  else {
                UIImageView *goodsIV = (UIImageView *)[cell viewWithTag:101];
                
                UILabel *goodsNameLabel = (UILabel *)[cell viewWithTag:102];
                
                UILabel *guigeLabel = (UILabel *)[cell viewWithTag:103];
                
                UILabel *priceAndNumLabel = (UILabel *)[cell viewWithTag:104];
                
                UILabel *sizeLable = (UILabel *)[cell viewWithTag:10005];
                
                UIButton *commentBtn = (UIButton *)[cell viewWithTag:105];
                
                UIButton *refundBtn = (UIButton *)[cell viewWithTag:106];
                
                UIButton *afterSaleBtn= (UIButton *)[cell viewWithTag:107];
                
                NSDictionary *goodsInfoDic = [_detailModel.shopOrderDetailes objectAtIndex:indexPath.row - 1];
                
                NSString *imgUrlStr = [goodsInfoDic objectForKey:@"goodsUrl"];
                [goodsIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
                
                goodsNameLabel.text = [goodsInfoDic objectForKey:@"goodsName"];
                
                if([[goodsInfoDic objectForKey:@"goodsColor"] length]>=1)
                    guigeLabel.text = [NSString stringWithFormat:@"颜色：%@",[goodsInfoDic objectForKey:@"goodsColor"]];
                else
                    guigeLabel.hidden=YES;
                if([[goodsInfoDic objectForKey:@"goodsModel"] length]>=1)
                    sizeLable.text = [NSString stringWithFormat:@"规格：%@",[goodsInfoDic objectForKey:@"goodsModel"]];
                else
                    sizeLable.hidden=YES;
                
                priceAndNumLabel.text = [NSString stringWithFormat:@"￥%.2f x %ld",[[goodsInfoDic objectForKey:@"goodsPrice"]floatValue],(long)[[goodsInfoDic objectForKey:@"goodsCount"]integerValue]];
                
                if (_detailModel.state == 4) {
                    commentBtn.hidden = NO;
                    refundBtn.hidden = NO;
                    afterSaleBtn.hidden = NO;
                }
                
            }
        }else{
            NSString *contentstr =[NSString string];
            contentstr =[NSString stringWithFormat:@"已优惠￥ %.2f",self.couponNum];
//            if (self.preferential) {
//                if (self.preferential.couponType==0) {
//                    if (_detailModel.orderTotalMoney>[self.preferential.couponValue doubleValue]) {
//                        contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %@",self.preferential.couponValue];
//                    }else{
//                        contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %.0f",_detailModel.orderTotalMoney];
//                    }
//                    
//                }else{
//                    contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %.2f",_detailModel.orderTotalMoney-_detailModel.orderTotalMoney*[self.preferential.couponValue doubleValue]/10];
//                }
//            }
            UIButton *couponbtn =(UIButton *)[cell viewWithTag:10001];
            CGSize labelsize = [util calHeightForLabel:contentstr width:kMainScreenWidth-81 font:[UIFont systemFontOfSize:15]];
            UILabel *couponcontent =[couponbtn viewWithTag:101];
            couponcontent.frame =CGRectMake(couponcontent.frame.origin.x, couponcontent.frame.origin.y, labelsize.width+20, labelsize.height);
            couponcontent.text =contentstr;
        }
    }
    else {
        
    if (indexPath.row == 0) {
        UIImageView *shopHeadIV = (UIImageView *)[cell viewWithTag:1001];
        NSString *imgUrlStr = _detailModel.shopLogoPath;
        [shopHeadIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
        UILabel *shopNameLabel = (UILabel *)[cell viewWithTag:1002];
        shopNameLabel.text = _detailModel.shopName;
        
    } else if (indexPath.row == _detailModel.shopOrderDetailes.count + 3) {
        
        UIButton *btn1 = (UIButton *)[cell viewWithTag:10010];
        [btn1 setTitleColor:kThemeColor forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *btn2 = (UIButton *)[cell viewWithTag:10011];
        [btn2 setTitleColor:kThemeColor forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
        if (_detailModel.state == 1||_detailModel.state ==10) {
            [btn1 setTitle:@"立即付款" forState:UIControlStateNormal];
            [btn2 setTitle:@"关闭订单" forState:UIControlStateNormal];
            btn1.hidden = NO;
            btn2.hidden = NO;
            if (_detailModel.state ==10) {
                btn2.hidden =YES;
            }
        } else if (_detailModel.state == 2) {
            [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
            btn1.hidden=NO;
            btn2.hidden = YES;
        } else if (_detailModel.state == 3) {
            [btn1 setTitle:@"确认收货" forState:UIControlStateNormal];
            [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
            btn1.hidden = NO;
            btn2.hidden = NO;
        } else if (_detailModel.state == 4 || _detailModel.state == 5 || _detailModel.state == 6 || _detailModel.state == 7) {
            //6代表取消订单中,7订单已取消
            btn1.hidden = YES;
            btn2.hidden = YES;
            if (_detailModel.state==6) {
                [btn1 setTitle:@"关闭申请" forState:UIControlStateNormal];
                btn1.hidden =NO;
            }
        }
        
       
        
    } else if (indexPath.row == _detailModel.shopOrderDetailes.count + 2) {
        CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"￥%.2f",_detailModel.orderTotalMoney] width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:20]];
        
        
        UILabel *moneyLabelTitle = (UILabel *)[cell viewWithTag:1005];
        UILabel *moneyLabel = (UILabel *)[cell viewWithTag:1004];
        UILabel *realPayLabel = (UILabel *)[cell viewWithTag:1006];
        moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_detailModel.originalTotalFee];
        if (realPayLabel) {
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付:￥%.2f",_detailModel.orderTotalMoney]];
            [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,3)];
            [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(3,str1.length-3)];
            [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 3)];
            [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(3,str1.length-3)];
            realPayLabel.attributedText =str1;
        }
//        if (self.preferential) {
//            if (self.preferential.couponType==0) {
//                if (_detailModel.orderTotalMoney>[self.preferential.couponValue doubleValue]) {
//                    //                            contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %@",self.preferential.couponValue];
//                    moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_detailModel.orderTotalMoney-[self.preferential.couponValue doubleValue]];
//                }else{
//                    //                            contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %.0f",_detailModel.orderTotalMoney];
//                    moneyLabel.text = [NSString stringWithFormat:@"￥0.00"];
//                }
//                
//            }else{
//                //                        contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %.2f",_detailModel.orderTotalMoney-_detailModel.orderTotalMoney*[self.preferential.couponValue doubleValue]/10];
//                moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_detailModel.orderTotalMoney*[self.preferential.couponValue doubleValue]/10];
//            }
//        }else{
//            moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_detailModel.orderTotalMoney];
//        }
        CGSize size1=[util calHeightForLabel:moneyLabelTitle.text width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:11]];
        
        
        float alreadyPayheight=0;
        if (_detailModel.state ==10) {
            UILabel *alreadyPayLabel = (UILabel *)[cell viewWithTag:1010];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已支付:￥%.2f",_detailModel.alreadyPayment]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(4,str.length-4)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 4)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(4,str.length-4)];
            alreadyPayLabel.attributedText = str;
            
            UILabel *waitePayLabel = (UILabel *)[cell viewWithTag:1011];
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"未支付:￥%.2f",_detailModel.waitePayment]];
            [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
            [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(4,str1.length-4)];
            [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 4)];
            [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(4,str.length-4)];
            waitePayLabel.attributedText = str1;
            moneyLabel.frame=CGRectMake(20+size1.width, 42, 100, 20);
            moneyLabelTitle.frame=CGRectMake(20, 42, size1.width, 20);
//            moneyLabel.backgroundColor =[UIColor purpleColor];
            alreadyPayheight +=moneyLabelTitle.frame.origin.y+moneyLabelTitle.frame.size.height;
        }else{
            UILabel *alreadyPayLabel = (UILabel *)[cell viewWithTag:1010];
            alreadyPayLabel.text =@"";
            UILabel *waitePayLabel = (UILabel *)[cell viewWithTag:1011];
            waitePayLabel.text =@"";
            moneyLabel.frame=CGRectMake(20+size1.width, 12, 100, 20);
            moneyLabelTitle.frame=CGRectMake(20, 12, size1.width, 20);
//            moneyLabel.backgroundColor =[UIColor purpleColor];
            alreadyPayheight +=moneyLabelTitle.frame.origin.y+moneyLabelTitle.frame.size.height;
        }
        
        _detailModel.userMessage =[_detailModel.userMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(_detailModel.userMessage.length>=1){
            UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, alreadyPayheight+12, kMainScreenWidth-20, 0.3)];
            line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
            [cell addSubview:line];
            
            CGSize size=[util calHeightForLabel:[NSString stringWithFormat:@"给卖家留言：%@",_detailModel.userMessage] width:kMainScreenWidth-30 font:[UIFont systemFontOfSize:14]];
            UILabel *label_message = (UILabel *)[cell viewWithTag:108];
            label_message.frame=CGRectMake(15, line.frame.origin.y+line.frame.size.height+10, kMainScreenWidth-30, size.height);
            label_message.text=[NSString stringWithFormat:@"给卖家留言：%@",_detailModel.userMessage];
//            label_message.backgroundColor =[UIColor blueColor];
            
            
            
            UIView *line_bottom=[[UIView alloc]initWithFrame:CGRectMake(10, label_message.frame.origin.y+size.height+10, kMainScreenWidth-20, 0.5)];
            line_bottom.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
            [cell addSubview:line_bottom];
//            cell.backgroundColor =[UIColor redColor];
        }
        
    } else if (indexPath.row == _detailModel.shopOrderDetailes.count + 1) {
 
        UILabel *numLabel = (UILabel *)[cell viewWithTag:101];
        NSInteger count = 0;
        for (NSDictionary *dic in _detailModel.shopOrderDetailes) {
            count += [[dic objectForKey:@"goodsCount"]integerValue];
        }
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
        
        UILabel *moneyLabel = (UILabel *)[cell viewWithTag:102];
        moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_detailModel.goodsTotalMoney];
        UILabel *shipFeeLabel = (UILabel *)[cell viewWithTag:103];
        shipFeeLabel.text = [NSString stringWithFormat:@"￥%.2f",_detailModel.shipFee];
    }  else {
        UIImageView *goodsIV = (UIImageView *)[cell viewWithTag:101];
        
        UILabel *goodsNameLabel = (UILabel *)[cell viewWithTag:102];
        
        UILabel *guigeLabel = (UILabel *)[cell viewWithTag:103];
        
        UILabel *priceAndNumLabel = (UILabel *)[cell viewWithTag:104];
        
        UILabel *sizeLable = (UILabel *)[cell viewWithTag:10005];
        
        UIButton *commentBtn = (UIButton *)[cell viewWithTag:105];
        
        UIButton *refundBtn = (UIButton *)[cell viewWithTag:106];
        
        UIButton *afterSaleBtn= (UIButton *)[cell viewWithTag:107];
        
        NSDictionary *goodsInfoDic = [_detailModel.shopOrderDetailes objectAtIndex:indexPath.row - 1];
        
        NSString *imgUrlStr = [goodsInfoDic objectForKey:@"goodsUrl"];
        [goodsIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
        
        goodsNameLabel.text = [goodsInfoDic objectForKey:@"goodsName"];
        
        if([[goodsInfoDic objectForKey:@"goodsColor"] length]>=1)
            guigeLabel.text = [NSString stringWithFormat:@"颜色：%@",[goodsInfoDic objectForKey:@"goodsColor"]];
        else
            guigeLabel.hidden=YES;
        if([[goodsInfoDic objectForKey:@"goodsModel"] length]>=1)
            sizeLable.text = [NSString stringWithFormat:@"规格：%@",[goodsInfoDic objectForKey:@"goodsModel"]];
        else
            sizeLable.hidden=YES;
        
        priceAndNumLabel.text = [NSString stringWithFormat:@"￥%.2f x %ld",[[goodsInfoDic objectForKey:@"goodsPrice"]floatValue],(long)[[goodsInfoDic objectForKey:@"goodsCount"]integerValue]];
  
        if (_detailModel.state == 4) {
            commentBtn.hidden = NO;
            refundBtn.hidden = NO;
            afterSaleBtn.hidden = NO;
        }

    }

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)clickActionBtn1:(UIButton *)btn {
    
}

- (void)clickActionBtn2:(UIButton *)btn {
    
}
-(void)couponbtn:(id)sender{
    CouponMainViewController *couponmain =[[CouponMainViewController alloc] init];
    couponmain.contract=nil;
    couponmain.orderCode =nil;
    couponmain.couponNum =self.couponNum;
    couponmain.noCouponNum =0;
    couponmain.selectDone =^(PreferentialObject *prefrential){
        self.preferential =prefrential;
        [_theTableView reloadData];
    };
    [self.navigationController pushViewController:couponmain animated:YES];
}
#pragma mark - 请求商品详情
-(void)requestGoodsDetail{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0202\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"orderId\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],self.orderIdStr];
        
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
                
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                //token为空或验证未通过处理 huangrun
                if (kResCode == 10002 || kResCode == 10003) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    });
                }
                
                
                if (code==102021) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSDictionary *resDic=[jsonDict objectForKey:@"shopOrder"];
                        if (resDic) {
                            
                            _detailModel = [OrderOfGoodsListModel objectWithKeyValues:resDic];
                           
                        } else {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                          
                        }
                        self.couponNum =_detailModel.originalTotalFee-_detailModel.orderTotalMoney;
                        [_theTableView reloadData];
                        
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                        [_theTableView reloadData];
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


- (void)clickCommentBtn:(UIButton *)btn {
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)btn.superview.superview.superview;
    else
        cell= (UITableViewCell *)btn.superview.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
    
    NSDictionary *goodsInfoDic = [_detailModel.shopOrderDetailes objectAtIndex:indexPath.row - 1];
    
    CommentOfGoodsViewController *commentOfGoodsVC = [[CommentOfGoodsViewController alloc]initWithNibName:@"CommentOfGoodsViewController" bundle:nil];
    
    
    commentOfGoodsVC.shopIdStr= [NSString stringWithFormat:@"%ld",(long)_detailModel.shopId];
    commentOfGoodsVC.shopGoodsDetailIdStr = [NSString stringWithFormat:@"%ld",(long)[[goodsInfoDic objectForKey:@"goodsId"]integerValue]];
    commentOfGoodsVC.shopOrderDetailStr = [NSString stringWithFormat:@"%ld",(long)[[goodsInfoDic objectForKey:@"orderDetailId"]integerValue]];
    commentOfGoodsVC.goodsInfoDic = goodsInfoDic;
    
    [self.navigationController pushViewController:commentOfGoodsVC animated:YES];
}

- (void)clickRefundBtn:(UIButton *)btn {
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)btn.superview.superview.superview;
    else
        cell= (UITableViewCell *)btn.superview.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
    
    NSDictionary *goodsInfoDic = [_detailModel.shopOrderDetailes objectAtIndex:indexPath.row - 1];
    
    
    if ([[goodsInfoDic objectForKey:@"isExistApplyingRefund"]integerValue] == 1) {
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"您已申请退款，不能重复申请";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
//        [TLToast showWithText:@"您已申请退款，不能重复申请"];
        return;
    }
    
    [savelogObj saveLog:@"商品订单-申请退款" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:84];
    
    
    RefundOfApplyGoodsViewController *refundOfGoodsVC = [[RefundOfApplyGoodsViewController alloc]init];
    refundOfGoodsVC.orderIdStr = [NSString stringWithFormat:@"%ld",(long)_detailModel.orderId];
    refundOfGoodsVC.shopOrderDetailStr = [NSString stringWithFormat:@"%ld",(long)[[goodsInfoDic objectForKey:@"orderDetailId"]integerValue]];
    refundOfGoodsVC.shopGoodsDetailIdStr = [NSString stringWithFormat:@"%ld",(long)[[goodsInfoDic objectForKey:@"goodsId"]integerValue]];
    refundOfGoodsVC.goodsName =[goodsInfoDic objectForKey:@"goodsName"];
    refundOfGoodsVC.goodsTotalMoneyStr = [NSString stringWithFormat:@"%.2f",_detailModel.couponTotalFee];
//    refundOfGoodsVC.goodsTotalMoneyStr = [NSString stringWithFormat:@"%.2f",_detailModel.orderTotalMoney];
    refundOfGoodsVC.shopIdStr = [NSString stringWithFormat:@"%ld",(long)_detailModel.shopId ];
    [self.navigationController pushViewController:refundOfGoodsVC animated:YES];
    
}

- (void)clickAfterSaleBtn:(UIButton *)btn {
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)btn.superview.superview.superview;
    else
        cell= (UITableViewCell *)btn.superview.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
    
    NSDictionary *goodsInfoDic = [_detailModel.shopOrderDetailes objectAtIndex:indexPath.row - 1];
    
    
    if ([[goodsInfoDic objectForKey:@"isExistApplyingAfterSale"]integerValue] == 1) {
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"您已申请售后，不能重复申请";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
//        [TLToast showWithText:@"您已申请售后，不能重复申请"];
        return;
    }
    
    [savelogObj saveLog:@"商品订单-申请售后" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:85];
    
    AfterSaleOfGoodsViewController *afterSaleOfGoodsVC = [[AfterSaleOfGoodsViewController alloc]initWithNibName:@"AfterSaleOfGoodsViewController" bundle:nil];
    afterSaleOfGoodsVC.orderIdStr = [NSString stringWithFormat:@"%ld",(long)_detailModel.orderId];
   afterSaleOfGoodsVC.shopOrderDetailStr = [NSString stringWithFormat:@"%ld",(long)[[goodsInfoDic objectForKey:@"orderDetailId"]integerValue]];
    afterSaleOfGoodsVC.goodsid =[NSString stringWithFormat:@"%d",[[goodsInfoDic objectForKey:@"goodsId"] intValue]];
    afterSaleOfGoodsVC.shopIdStr = [NSString stringWithFormat:@"%ld",(long)_detailModel.shopId ];
    
    [self.navigationController pushViewController:afterSaleOfGoodsVC animated:YES];
}

- (void)clickBtn1:(id)sender {
    if (_detailModel.state == 1) {
        //立即付款
        [self gotoPayingConfirmPage:nil];
    } else if (_detailModel.state == 2) {
        //取消订单
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"是否取消订单?" message:@"取消订单需与卖家协商，确定取消该订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag=10;
        [alert show];
    } else if (_detailModel.state == 3) {
        //确认收货
        [self confirmDeliveryOfGoods];
    }else if (_detailModel.state ==6){
        //关闭申请
        [self closeApply];
    }
}

- (void)clickBtn2:(id)sender {
    if (_detailModel.state == 1) {
        //关闭订单
        [self closeOrderOfGoods];
    } else if (_detailModel.state == 3) {
        //取消订单
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"是否取消订单?" message:@"取消订单需与卖家协商，确定取消该订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag=10;
        [alert show];
    }
}
#pragma mark - 关闭申请
-(void)closeApply{
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
        [postDict setObject:@"ID0336" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"orderId":[NSString stringWithFormat:@"%d",(int)_detailModel.orderId]};
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
                    
                    if (kResCode == 103361) {
                        [self stopRequest];
                        [self requestGoodsDetail];
                        [TLToast showWithText:@"关闭申请成功"];
                    } else if (kResCode == 103369) {
                        [self stopRequest];
                        [TLToast showWithText:@"关闭申请失败"];
                    }else if (kResCode == 103364){
                        [self stopRequest];
                        [TLToast showWithText:@"该订单不是取消中订单"];
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
#pragma mark - 立即付款
- (void)gotoPayingConfirmPage:(id)sender {
    
    [savelogObj saveLog:@"商品订单-确认付款" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:83];
    
    if(_detailModel.orderTotalMoney==0){
        [self OrderMoneyIsZero:_detailModel];
    }
    else{
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
            url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0273\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"mobile\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],[[NSUserDefaults standardUserDefaults] objectForKey:User_Mobile]];
            
            NetworkRequest *req = [[NetworkRequest alloc] init];
            req.isCacheRequest=YES;
            [req setHttpMethod:GetMethod];
            
            [req sendToServerInBackground:^{
                dispatch_async(parsingQueue, ^{
                    ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                    [request setResponseEncoding:NSUTF8StringEncoding];
                    NSString *respString = [request responseString];
                    NSDictionary *jsonDict = [respString objectFromJSONString];
                    NSLog(@"日记列表返回信息：%@",jsonDict);
                    NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            //                        login.delegate=self;
                            //                        [login show];
                            [self performSelector:@selector(DisPlayLoginView) withObject:nil afterDelay:0.5f];
                        });
                    }
                    if (code==102731) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            if ([[jsonDict objectForKey:@"walletAssets"] doubleValue]<=0&&[[jsonDict objectForKey:@"decorationLoanAssets"] doubleValue]<=0) {
                                OnlinePayViewController *onlinepay =[[OnlinePayViewController alloc] init];
                                onlinepay.serviceNameStr =[NSString stringWithFormat:@"%ld,",(long)_detailModel.orderId];
                                onlinepay.remaining =_detailModel.orderTotalMoney;
                                if (_detailModel.state ==10) {
                                    onlinepay.remaining =_detailModel.waitePayment;
                                }
                                onlinepay.typeStr =@"商城";
                                onlinepay.orderNo =_detailModel.orderCode;
                                onlinepay.fromStr=@"orderDetailOfGoodsVC";
                                onlinepay.amounts =[NSString stringWithFormat:@"%.2f",_detailModel.orderTotalMoney];
                                IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
                                onlinepay.hidesBottomBarWhenPushed =YES;
                                [delegate.nav pushViewController:onlinepay animated:YES];
                            }else{
                                PayingConfirmViewController *payingConfirmVC = [[PayingConfirmViewController alloc]init];
                                payingConfirmVC.typeStr = @"商城";
                                payingConfirmVC.serviceNameStr=[NSString stringWithFormat:@"%ld,",(long)_detailModel.orderId];
                                payingConfirmVC.moneyFloat = _detailModel.orderTotalMoney;
                                payingConfirmVC.orderNo = _detailModel.orderCode;
                                payingConfirmVC.amounts =[NSString stringWithFormat:@"%.2f",_detailModel.orderTotalMoney];
                                [self.navigationController pushViewController:payingConfirmVC animated:YES];
                            }
                        });
                    }
                    else if (code==102732) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            [TLToast showWithText:@"获取账户信息失败"];
                        });
                    }
                    else if (code==102729){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            [TLToast showWithText:@"获取账户信息失败"];
                        });
                    }
                });
            }
                              failedBlock:^{
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self stopRequest];
                                      [TLToast showWithText:@"获取账户信息失败"];
                                  });
                              }
                                   method:url postDict:nil];
        });
        
    }
}

#pragma mark - 取消订单
- (void)cancelOrderOfGoods {
    [savelogObj saveLog:@"商品订单-申请取消订单" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:81];
    
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
        [postDict setObject:@"ID0205" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSString *orderIdStr = [NSString stringWithFormat:@"%ld",(long)_detailModel.orderId];
        NSDictionary *bodyDic = @{@"orderId":orderIdStr};
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
                        //                        LoginVC *longVC = [[LoginVC alloc]init];
                        //                        longVC.delegate = self;
                        self.view.tag = 1002;
                        //                        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:longVC];
                        //                        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
                        //                        [delegate.nav presentViewController:nav animated:YES completion:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [login show];
                            
                        });
                        
                        return;
                    }
                    
                    if (kResCode == 102051) {
                        [self stopRequest];
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNCUpdateOrderStatus object:nil];
                        [TLToast showWithText:@"取消订单成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else  {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"取消订单失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"取消订单失败"];
                    }
                    
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                  customPromp.contenttxt =@"操作失败";
                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                  [customPromp addGestureRecognizer:tap];
                                  [customPromp show];
//                                  [TLToast showWithText:@"操作失败"];
                              });
                          }
                               method:url postDict:post];
    });

}

#pragma mark - 关闭订单
- (void)closeOrderOfGoods {
    [savelogObj saveLog:@"商品订单-关闭订单" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:82];
    
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
        [postDict setObject:@"ID0204" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSString *orderIdStr = [NSString stringWithFormat:@"%ld",(long)_detailModel.orderId];
        NSDictionary *bodyDic = @{@"orderId":orderIdStr};
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
                        self.view.tag = 1002;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [login show];
                            
                        });
                        
                        return;
                    }
                    
                    if (kResCode == 102041) {
                        [self stopRequest];
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNCUpdateOrderStatus object:nil];
                        [TLToast showWithText:@"关闭订单成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else  {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"关闭订单失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"关闭订单失败"];
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

#pragma mark - 支付金额为0的订单的付款方式
- (void)OrderMoneyIsZero:(OrderOfGoodsListModel *) detailModel_{
    [self startRequestWithString:@"加载中..."];
    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
        
        NSString *string_token=@"";;
        NSString *string_userid=@"";;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Token] length]&&[[[NSUserDefaults standardUserDefaults]objectForKey:User_ID] length]){
            string_token=[[NSUserDefaults standardUserDefaults]objectForKey:User_Token];
            string_userid=[[NSUserDefaults standardUserDefaults]objectForKey:User_ID];
        }
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
        [postDict setObject:@"ID0091" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        NSString *string=[postDict JSONString];
        
        NSString *orderIdStr = [NSString stringWithFormat:@"%ld",(long)detailModel_.orderCode];
        NSDictionary *bodyDic = @{@"orderCode":orderIdStr};
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
                NSLog(@"订单金额为0返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopRequest];
                    if (kResCode == 10002 || kResCode == 10003) {
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }
                    else if (kResCode == 100911) {
                        [TLToast showWithText:@"支付成功"];
                        _detailModel.state=[[jsonDict objectForKey:@"state"] integerValue];
                        _detailModel.stateName=[jsonDict objectForKey:@"stateName"];
                        [_theTableView reloadData];
                    }
                    else  {
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"支付失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"支付失败"];
                    }
                    
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                                  customPromp.contenttxt =@"支付失败";
                                  UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                                  [customPromp addGestureRecognizer:tap];
                                  [customPromp show];
//                                  [TLToast showWithText:@"支付失败"];
                              });
                          }
                               method:url postDict:post];
    });
    
}

#pragma mark - 确认收货
- (void)confirmDeliveryOfGoods {

    InputPayPsdViewController *inputPayPsdVC = [[InputPayPsdViewController alloc]init];
    inputPayPsdVC.sourceVC = @"orderDetailOfGoodsVC";
    inputPayPsdVC.detailModel = _detailModel;
    [self.navigationController pushViewController:inputPayPsdVC animated:YES];
    
}

- (void)PressBarItemRight:(id)sender {
    [savelogObj saveLog:@"联系客服" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:29];
    
//    if (_callNum) {
        NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",callNumber];
        UIWebView *callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
        [self.view addSubview:callWebview];
//    } else {
//        [self requestCallNum];
//    }
}

//#pragma mark - 获取电话号码
//- (void)requestCallNum {
//    dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(parsingQueue, ^{
//        
//        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action",kDefaultUpdateVersionServerURL];
//        
//        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
//        [postDict setObject:@"ID0036" forKey:@"cmdID"];
//        [postDict setObject:@"" forKey:@"token"];
//        [postDict setObject:@"" forKey:@"userID"];
//        [postDict setObject:@"iOS" forKey:@"deviceType"];
//        NSString *string=[postDict JSONString];
//        
//        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
//        [post setObject:string forKey:@"header"];
//        [post setObject:@"" forKey:@"body"];
//        
//        
//        NetworkRequest *req = [[NetworkRequest alloc] init];
//        [req setHttpMethod:PostMethod];
//        
//        [req sendToServerInBackground:^{
//            dispatch_async(parsingQueue, ^{
//                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
//                [request setResponseEncoding:NSUTF8StringEncoding];
//                NSString *respString = [request responseString];
//                NSDictionary *jsonDict = [respString objectFromJSONString];
//                //NSLog(@"返回信息：%@",jsonDict);
//                if ([[jsonDict objectForKey:@"resCode"] integerValue]==10361) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        _callNum = [jsonDict objectForKey:@"fbPhoneNumber"];
//                        NSLog(@"获取电话成功");
//                    });
//                }
//                else if([[jsonDict objectForKey:@"resCode"] integerValue]==10369){
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSLog(@"获取电话失败");
//                    });
//                } else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                    });
//                }
//            });
//        }
//                          failedBlock:^{
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  
//                              });
//                          }
//                               method:url postDict:post];
//    });
//    
//    
//}

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
    NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",_detailModel.shopPhone];
    UIWebView *callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
    [self.view addSubview:callWebview];
}

- (void)tapGoodsView:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIView *view = tapGestureRecognizer.view;
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)view.superview.superview;
    else
        cell= (UITableViewCell *)view.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
    
    NSDictionary *goodsInfoDic = [_detailModel.shopOrderDetailes objectAtIndex:indexPath.row - 1];
    
    NSString *goodsIdStr = [NSString stringWithFormat:@"%ld",(long)[[goodsInfoDic objectForKey:@"goodsId"]integerValue]];
    GoodsDetailViewController *goodsDetailVC = [[GoodsDetailViewController alloc]init];
    goodsDetailVC.goodsIdStr = goodsIdStr;
    goodsDetailVC.fromWhere=@"no";
    goodsDetailVC.type=@"jsBridge";
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

- (void)tapShopView:(UITapGestureRecognizer *)tapGestureRecognizer {
    ShopOfGoodsViewController *shopVC=[[ShopOfGoodsViewController alloc]init];
    shopVC.shopIdStr=[NSString stringWithFormat:@"%ld",(long)_detailModel.shopId];
    shopVC.fromWhere=@"no";
    [self.navigationController pushViewController:shopVC animated:YES];
}
-(void)hideAction:(id)sender{
    [customPromp dismiss];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 10){
        if (buttonIndex == alertView.cancelButtonIndex) [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        else [self cancelOrderOfGoods];
    }
}

@end
