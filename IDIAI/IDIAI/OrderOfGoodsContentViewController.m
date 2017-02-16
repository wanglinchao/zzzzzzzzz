//
//  OrderOfGoodsViewController.m
//  IDIAI
//
//  Created by Ricky on 15/5/7.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "OrderOfGoodsContentViewController.h"
#import "PullingRefreshTableView.h"
#import "LoginView.h"
#import "OrderDetailOfGoodsViewController.h"
#import "OrderOfGoodsListModel.h"
#import "UIImageView+WebCache.h"
#import "IDIAIAppDelegate.h"
#import "CommentOfGoodsViewController.h"
#import "TLToast.h"
#import "RefundOfApplyGoodsViewController.h"
#import "AfterSaleOfGoodsViewController.h"
#import "ShopOfGoodsViewController.h"
#import "util.h"
#import "savelogObj.h"
#import "PayingConfirmViewController.h"
#import "InputPayPsdViewController.h"
#import "CustomPromptView.h"
#import "OnlinePayViewController.h"
#define IS_iOS8 [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue]

#define kOrderOperation_Tag 100000

#define kView_Tag 1000000

@interface OrderOfGoodsContentViewController () <PullingRefreshTableViewDelegate,UITableViewDataSource, UITableViewDelegate,LoginViewDelegate>{
    
    UIView *_row1View;
    UIView *_lastRowView;
    NSArray *_rowDataArr;
    PullingRefreshTableView *mtableview;
    BOOL isFirstInt;
    
  
    NSMutableArray *_orderOfGoodsListModelArr;
    CustomPromptView *customPromp;
}
@property(nonatomic,assign)int selectCancle;
@end

@implementation OrderOfGoodsContentViewController

@synthesize selected_mark;

- (void)dealloc {
     [[NSNotificationCenter defaultCenter]removeObserver:self name:kNCUpdateOrderStatus object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if ([self.fromVcNameStr isEqualToString:@"utopVCStatusBtn"]) {
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav setNavigationBarHidden:NO animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.fromVcNameStr isEqualToString:@"utopVCStatusBtn"]) {
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav setNavigationBarHidden:YES animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title = @"商品订单";
    self.currentPage=0;
    _orderOfGoodsListModelArr = [NSMutableArray arrayWithCapacity:10];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateOrderStaus:) name:kNCUpdateOrderStatus object:nil];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mtableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-40) style:UITableViewStyleGrouped];
    mtableview.pullingDelegate=self;
    if ([self.fromVcNameStr isEqualToString:@"utopVCStatusBtn"]) {
        mtableview.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64);
    }
    mtableview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    mtableview.dataSource=self;
    mtableview.delegate=self;
    mtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //[mtableview setHeaderOnly:YES];          //只有下拉刷新
    //[mtableview setFooterOnly:YES];         //只有上拉加载
    [mtableview launchRefreshing];
    [self.view addSubview:mtableview];
    
    [self loadImageviewBG];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _orderOfGoodsListModelArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[_orderOfGoodsListModelArr objectAtIndex:section] shopOrderDetailes] count]+3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderOfGoodsListModel *_detailModel = [_orderOfGoodsListModelArr objectAtIndex:indexPath.section];
    if (indexPath.row == 0 || indexPath.row == [[[_orderOfGoodsListModelArr objectAtIndex:indexPath.section]shopOrderDetailes]count]+1) {
        return 44;
    }
    else if ( indexPath.row == [[[_orderOfGoodsListModelArr objectAtIndex:indexPath.section]shopOrderDetailes]count]+2) {
        if (_detailModel.state == 4 || _detailModel.state == 5  || _detailModel.state == 7){
            return 44;
        }
        else{
            if (_detailModel.state ==10) {
                return 44+60;
            }
            return 44+30;
        }
    }
    else {
        OrderOfGoodsListModel *orderOfGoodsListModel = [_orderOfGoodsListModelArr objectAtIndex:indexPath.section];
        if (orderOfGoodsListModel.state ==4) {
            return 130;
        }else{
            return 100;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier0 = [NSString stringWithFormat:@"Cell0%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier1 = [NSString stringWithFormat:@"Cell1%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier2 = [NSString stringWithFormat:@"Cell2%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier3 = [NSString stringWithFormat:@"Cell3%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell;
    
        if (indexPath.row == 0) {
            cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
        } else if (indexPath.row == [[[_orderOfGoodsListModelArr objectAtIndex:indexPath.section]shopOrderDetailes] count] + 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        } else if (indexPath.row == [[[_orderOfGoodsListModelArr objectAtIndex:indexPath.section]shopOrderDetailes]count] + 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        }
        
//        if (cell == nil) {
    
            if (indexPath.row == 0) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0];
                UIView *row1View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth , 45)];
                row1View.backgroundColor = [UIColor whiteColor];
                UIImageView *shopHeadIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
                shopHeadIV.tag = 1001;
                shopHeadIV.layer.masksToBounds = YES;
                shopHeadIV.layer.cornerRadius = 12;
                UILabel *shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(34+ 5, 0, kMainScreenWidth - 20 - 34 - 5, 44)];
                shopNameLabel.tag = 1002;
                [row1View addSubview:shopHeadIV];
                [row1View addSubview:shopNameLabel];
                
                [cell.contentView addSubview:row1View];
                
                UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 40, kMainScreenWidth-20, 0.5)];
                line.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
                [row1View addSubview:line];
                
                row1View.layer.cornerRadius = 5.0f;
                row1View.layer.masksToBounds = YES;
                
            } else if (indexPath.row == [[[_orderOfGoodsListModelArr objectAtIndex:indexPath.section]shopOrderDetailes] count] + 2) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
                
                OrderOfGoodsListModel *_detailModel = [_orderOfGoodsListModelArr objectAtIndex:indexPath.section];
                
                UIView *lastRowView=(UIView *)[cell.contentView viewWithTag:kView_Tag+indexPath.section];
                if(!lastRowView) lastRowView = [[UIView alloc]init];
                lastRowView.tag=kView_Tag+indexPath.section;
                if (_detailModel.state == 4 || _detailModel.state == 5 || _detailModel.state == 6 || _detailModel.state == 7)
                    lastRowView.frame=CGRectMake(0, 0, kMainScreenWidth - 80, 44);
                else{
                    if (_detailModel.state ==10) {
                        lastRowView.frame=CGRectMake(0, 0, kMainScreenWidth, 44 + 60);
                    }else{
                        lastRowView.frame=CGRectMake(0, 0, kMainScreenWidth, 44 + 30);
                    }
                    
                }
                
                lastRowView.backgroundColor = [UIColor whiteColor];
                UILabel *alreadyPay =[[UILabel alloc] init];
                UILabel *waitePay =[[UILabel alloc] init];
                if (_detailModel.state ==10) {
                    alreadyPay.frame =CGRectMake(10, 12, (kMainScreenWidth-20)/2, 20);
                    alreadyPay.font =[UIFont systemFontOfSize:15];
                    alreadyPay.tag =1010;
                    waitePay.frame =CGRectMake(10+(kMainScreenWidth-20)/2, 12, (kMainScreenWidth-70)/2, 20);
                    waitePay.font =[UIFont systemFontOfSize:15];
                    waitePay.textAlignment =NSTextAlignmentRight;
                    waitePay.tag =1011;
                    [lastRowView addSubview:alreadyPay];
                    [lastRowView addSubview:waitePay];
                }
                UILabel *dealStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 100, 20)];
                if (_detailModel.state ==10) {
                    dealStatusLabel.frame =CGRectMake(dealStatusLabel.frame.origin.x, alreadyPay.frame.origin.y+alreadyPay.frame.size.height+8, dealStatusLabel.frame.size.width, dealStatusLabel.frame.size.height);
                }
                dealStatusLabel.textColor = kThemeColor;
                dealStatusLabel.tag = 1003;
                dealStatusLabel.font=[UIFont systemFontOfSize:15];
                
                UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth - 140, 12, 120, 20)];//注：frame根据内容动态设置 暂不
                moneyLabel.textAlignment = NSTextAlignmentCenter;
                moneyLabel.textColor = kThemeColor;
                moneyLabel.tag = 1004;
                moneyLabel.font=[UIFont systemFontOfSize:19];
                if (_detailModel.state ==10) {
                    moneyLabel.frame =CGRectMake(moneyLabel.frame.origin.x, dealStatusLabel.frame.origin.y, moneyLabel.frame.size.width, moneyLabel.frame.size.height);
                }
                moneyLabel.textAlignment=NSTextAlignmentLeft;
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.frame.origin.x - 60 - 10, 14, 60, 20)];
                titleLabel.text = @"实付：";
                titleLabel.tag = 1005;
                titleLabel.font=[UIFont systemFontOfSize:12];
                titleLabel.textAlignment=NSTextAlignmentRight;
                if (_detailModel.state ==10) {
                    titleLabel.frame =CGRectMake(titleLabel.frame.origin.x, dealStatusLabel.frame.origin.y-2, titleLabel.frame.size.width, titleLabel.frame.size.height);
                }
                [lastRowView addSubview:dealStatusLabel];
                [lastRowView addSubview:moneyLabel];
                [lastRowView addSubview:titleLabel];
                
                [cell.contentView addSubview:lastRowView];
                
                lastRowView.layer.cornerRadius = 5.0f;
                lastRowView.layer.masksToBounds = YES;
                
                UIButton *btn1 = (UIButton *)[cell viewWithTag:kOrderOperation_Tag+indexPath.section];
                if(!btn1) btn1 = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth - 20 - 10 - 70, 40, 70, 25)];
                if (_detailModel.state ==10) {
                    btn1.frame =CGRectMake(btn1.frame.origin.x, dealStatusLabel.frame.origin.y+dealStatusLabel.frame.size.height+8, btn1.frame.size.width, btn1.frame.size.height);
                }
                [btn1 addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
                [btn1 setTitleColor:kThemeColor forState:UIControlStateNormal];
                btn1.tag = kOrderOperation_Tag+indexPath.section;
                btn1.titleLabel.font=[UIFont systemFontOfSize:13];
                btn1.layer.masksToBounds = YES;
                btn1.layer.cornerRadius = 3;
                btn1.layer.borderColor = kThemeColor.CGColor;
                btn1.layer.borderWidth = 1.0;
                [cell addSubview:btn1];
                
                UIButton *btn2 = (UIButton *)[cell viewWithTag:kOrderOperation_Tag*2+indexPath.section];
                if(!btn2) btn2 = [[UIButton alloc]initWithFrame:CGRectMake(btn1.frame.origin.x - 10 - 70, 40, 70, 25)];
                [btn2 addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
                [btn2 setTitleColor:kThemeColor forState:UIControlStateNormal];
                btn2.tag = kOrderOperation_Tag*2+indexPath.section;
                btn2.titleLabel.font=[UIFont systemFontOfSize:13];
                btn2.layer.masksToBounds = YES;
                btn2.layer.cornerRadius = 3;
                btn2.layer.borderColor = kThemeColor.CGColor;
                btn2.layer.borderWidth = 1.0;
                if (_detailModel.state ==10) {
                    btn2.frame =CGRectMake(btn2.frame.origin.x, dealStatusLabel.frame.origin.y+dealStatusLabel.frame.size.height+8, btn2.frame.size.width, btn2.frame.size.height);
                }
                [cell addSubview:btn2];
                if (_detailModel.state == 1||_detailModel.state ==10) {
                    [btn1 setTitle:@"立即付款" forState:UIControlStateNormal];
                    if (_detailModel.state ==10) {
                        btn2.hidden =YES;
                    }else{
                        [btn2 setTitle:@"关闭订单" forState:UIControlStateNormal];
                        btn2.hidden =NO;
                    }
                    
                    
                } else if (_detailModel.state == 2) {
                    [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
                    btn2.hidden = YES;
                } else if (_detailModel.state == 3) {
                    [btn1 setTitle:@"确认收货" forState:UIControlStateNormal];
                    [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
                    btn2.hidden =NO;
                } else if (_detailModel.state == 4 || _detailModel.state == 5 || _detailModel.state == 6 || _detailModel.state == 7) {
                    //6代表取消订单中,7订单已取消
                    btn1.hidden = YES;
                    btn2.hidden = YES;
                    if (_detailModel.state==6) {
                        [btn1 setTitle:@"关闭申请" forState:UIControlStateNormal];
                        btn1.hidden =NO;
                    }
                }
                
            } else if (indexPath.row == [[[_orderOfGoodsListModelArr objectAtIndex:indexPath.section]shopOrderDetailes]count] + 1) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
                UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"OrderOfGoodsView2" owner:self options:nil]lastObject];
                view.frame = CGRectMake(0, 0, kMainScreenWidth, view.frame.size.height);
                [cell.contentView addSubview:view];

//                UIView *line=[[UIView alloc]initWithFrame:CGRectMake(20, 3, kMainScreenWidth-40, 0.3)];
//                line.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
//                [cell addSubview:line];
                
//                UIView *line_bottom=[[UIView alloc]initWithFrame:CGRectMake(20, 42, kMainScreenWidth-40, 0.3)];
//                line_bottom.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.3];
//                [cell addSubview:line_bottom];
            } else {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
                UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"OrderOfGoodsView" owner:self options:nil]lastObject];
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
                OrderOfGoodsListModel *orderOfGoodsListModel = [_orderOfGoodsListModelArr objectAtIndex:indexPath.section];
                if (orderOfGoodsListModel.state == 4) {
                    commentBtn.hidden = NO;
                    refundBtn.hidden = NO;
                    afterSaleBtn.hidden = NO;
//                    view.backgroundColor =[UIColor redColor];
                    view.frame =CGRectMake(0, 0, kMainScreenWidth, 130);
                }
                else{
                    commentBtn.hidden = YES;
                    refundBtn.hidden = YES;
                    afterSaleBtn.hidden = YES;
//                    view.backgroundColor =[UIColor orangeColor];
                    view.frame =CGRectMake(0, 0, kMainScreenWidth, 100);
                }
                
            }
            
//        }
    
        OrderOfGoodsListModel *orderOfGoodsListModel = [_orderOfGoodsListModelArr objectAtIndex:indexPath.section];
        
        if (indexPath.row == 0) {
            UIImageView *shopHeadIV = (UIImageView *)[cell viewWithTag:1001];
            NSString *imgUrlStr= orderOfGoodsListModel.shopLogoPath;
            [shopHeadIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
            UILabel *shopNameLabel = (UILabel *)[cell viewWithTag:1002];
            shopNameLabel.text = orderOfGoodsListModel.shopName;
        } else if (indexPath.row == [[[_orderOfGoodsListModelArr objectAtIndex:indexPath.section]shopOrderDetailes] count] + 2) {
            UILabel *alreadyPayLabel = (UILabel *)[cell viewWithTag:1010];
            UILabel *waitePayLabel = (UILabel *)[cell viewWithTag:1011];
            if (orderOfGoodsListModel.state ==10) {
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已支付:￥%.2f",orderOfGoodsListModel.alreadyPayment]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(4,str.length-4)];
                alreadyPayLabel.attributedText = str;
                
                
                NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"未支付:￥%.2f",orderOfGoodsListModel.waitePayment]];
                [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
                [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ef6562"] range:NSMakeRange(4,str1.length-4)];
                waitePayLabel.attributedText = str1;
            }else{
//                UILabel *alreadyPayLabel = (UILabel *)[cell viewWithTag:1010];
                alreadyPayLabel.text =@"";
//                UILabel *waitePayLabel = (UILabel *)[cell viewWithTag:1011];
                waitePayLabel.text =@"";
            }
            CGSize size =CGSizeZero;
            size=[util calHeightForLabel:[NSString stringWithFormat:@"￥%.2f",orderOfGoodsListModel.orderTotalMoney] width:120 font:[UIFont systemFontOfSize:19]];
//            if (orderOfGoodsListModel.state ==10) {
//                size=[util calHeightForLabel:[NSString stringWithFormat:@"￥%.2f",orderOfGoodsListModel.waitePayment] width:120 font:[UIFont systemFontOfSize:19]];
//            }
            
            UILabel *statusLabel = (UILabel *)[cell viewWithTag:1003];
            statusLabel.text = orderOfGoodsListModel.stateName;
            if (orderOfGoodsListModel.state !=10) {
                statusLabel.frame =CGRectMake(10, 12, 100, 20);
            }else{
                statusLabel.frame =CGRectMake(statusLabel.frame.origin.x, alreadyPayLabel.frame.origin.y+alreadyPayLabel.frame.size.height+8, statusLabel.frame.size.width, statusLabel.frame.size.height);
            }
            
            UILabel *montyLabel = (UILabel *)[cell viewWithTag:1004];
            montyLabel.text = [NSString stringWithFormat:@"￥%.2f",orderOfGoodsListModel.orderTotalMoney];
//            if (orderOfGoodsListModel.state ==10) {
//                montyLabel.text =[NSString stringWithFormat:@"￥%.2f",orderOfGoodsListModel.waitePayment];
//            }
            
            UILabel *moneyLabelTitle = (UILabel *)[cell viewWithTag:1005];
            
            montyLabel.frame=CGRectMake(kMainScreenWidth - 35-size.width, 13, size.width, 20);
            if (orderOfGoodsListModel.state ==10) {
                montyLabel.frame =CGRectMake(montyLabel.frame.origin.x, statusLabel.frame.origin.y, montyLabel.frame.size.width, montyLabel.frame.size.height);
            }
            moneyLabelTitle.frame=CGRectMake(kMainScreenWidth - 35-size.width-42, 13, 50, 20);
            if (orderOfGoodsListModel.state ==10) {
                moneyLabelTitle.frame =CGRectMake(moneyLabelTitle.frame.origin.x, statusLabel.frame.origin.y, moneyLabelTitle.frame.size.width, moneyLabelTitle.frame.size.height);
            }
            
            UIButton *btn1 = (UIButton *)[cell viewWithTag:kOrderOperation_Tag+indexPath.section];
            UIButton *btn2 = (UIButton *)[cell viewWithTag:kOrderOperation_Tag*2+indexPath.section];
            if (orderOfGoodsListModel.state !=10) {
                btn2.frame =CGRectMake(btn1.frame.origin.x - 10 - 70, 40, 70, 25);
                btn1.frame =CGRectMake(kMainScreenWidth - 20 - 10 - 70, 40, 70, 25);
            }else{
                btn2.frame =CGRectMake(btn2.frame.origin.x, statusLabel.frame.origin.y+statusLabel.frame.size.height+8, btn2.frame.size.width, btn2.frame.size.height);
                btn1.frame =CGRectMake(btn1.frame.origin.x, statusLabel.frame.origin.y+statusLabel.frame.size.height+8, btn1.frame.size.width, btn1.frame.size.height);
            }
            if (orderOfGoodsListModel.state == 1) {
                [btn1 setTitle:@"立即付款" forState:UIControlStateNormal];
                [btn2 setTitle:@"关闭订单" forState:UIControlStateNormal];
                btn1.hidden = NO;
                btn2.hidden = NO;
            } else if (orderOfGoodsListModel.state == 2) {
                [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
                btn1.hidden = NO;
                btn2.hidden = YES;
            } else if (orderOfGoodsListModel.state == 3) {
                [btn1 setTitle:@"确认收货" forState:UIControlStateNormal];
                [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
                btn1.hidden = NO;
                btn2.hidden = NO;
            }
            if (orderOfGoodsListModel.state == 4 || orderOfGoodsListModel.state == 5 || orderOfGoodsListModel.state == 6 || orderOfGoodsListModel.state == 7) {
                //6代表取消订单中,7订单已取消
                btn1.hidden = YES;
                btn2.hidden = YES;
                if (orderOfGoodsListModel.state==6) {
                    [btn1 setTitle:@"关闭申请" forState:UIControlStateNormal];
                    btn1.hidden =NO;
                }
            }
            
            UIView *lastRowView=(UIView *)[cell.contentView viewWithTag:kView_Tag+indexPath.section];
            if (orderOfGoodsListModel.state == 4 || orderOfGoodsListModel.state == 5  || orderOfGoodsListModel.state == 7)
                lastRowView.frame=CGRectMake(0, 0, kMainScreenWidth, 44);
            else{
                if (orderOfGoodsListModel.state ==10) {
                    lastRowView.frame=CGRectMake(0, 0, kMainScreenWidth, 44 + 60);
                }else{
                    lastRowView.frame=CGRectMake(0, 0, kMainScreenWidth, 44 + 30);
                }
                
            }
            
            
        } else if (indexPath.row == [[[_orderOfGoodsListModelArr objectAtIndex:indexPath.section]shopOrderDetailes]count] + 1) {
            
            UILabel *numLabel = (UILabel *)[cell viewWithTag:101];
            UILabel *moneyLabel = (UILabel *)[cell viewWithTag:102];
            UILabel *shipFeeLabel = (UILabel *)[cell viewWithTag:103];
            
            NSInteger count = 0;
            for (NSDictionary *dic in [[_orderOfGoodsListModelArr objectAtIndex:indexPath.section]shopOrderDetailes]) {
                count += [[dic objectForKey:@"goodsCount"]integerValue];
            }
            
            numLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
            moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",orderOfGoodsListModel.goodsTotalMoney];
            shipFeeLabel.text = [NSString stringWithFormat:@"￥%.2f",orderOfGoodsListModel.shipFee];
            NSLog(@"%d-%d",(int)indexPath.section,(int)indexPath.row);
            NSLog(@"%@",[[cell.contentView.subviews objectAtIndex:0] subviews]);
            
        } else {
            UIImageView *goodsIV = (UIImageView *)[cell viewWithTag:101];
            
            UILabel *goodsNameLabel = (UILabel *)[cell viewWithTag:102];
            
            UILabel *guigeLabel = (UILabel *)[cell viewWithTag:103];
            
            UILabel *priceAndNumLabel = (UILabel *)[cell viewWithTag:104];
            
            UILabel *sizeLable = (UILabel *)[cell viewWithTag:10005];
            
            
            NSDictionary *goodsInfoDic = [orderOfGoodsListModel.shopOrderDetailes objectAtIndex:indexPath.row - 1];
            
            NSString *imgUrlStr = [goodsInfoDic objectForKey:@"goodsUrl"];
            [goodsIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
            
            goodsNameLabel.text =[goodsInfoDic objectForKey:@"goodsName"];
            if([[goodsInfoDic objectForKey:@"goodsColor"] length]>=1)
                guigeLabel.text = [NSString stringWithFormat:@"颜色：%@",[goodsInfoDic objectForKey:@"goodsColor"]];
            else
                guigeLabel.hidden=YES;
            if([[goodsInfoDic objectForKey:@"goodsModel"] length]>=1)
                sizeLable.text = [NSString stringWithFormat:@"规格：%@",[goodsInfoDic objectForKey:@"goodsModel"]];
            else
                sizeLable.hidden=YES;
            
            priceAndNumLabel.text = [NSString stringWithFormat:@"￥%.2f x %ld",[[goodsInfoDic objectForKey:@"goodsPrice"]floatValue],(long)[[goodsInfoDic objectForKey:@"goodsCount"]integerValue]];
        }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderOfGoodsListModel *orderOfGoodsListModel = [_orderOfGoodsListModelArr objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        ShopOfGoodsViewController *shopOfGoodsVC = [[ShopOfGoodsViewController alloc]init];
        shopOfGoodsVC.shopIdStr = [NSString stringWithFormat:@"%ld",(long)orderOfGoodsListModel.shopId];
        shopOfGoodsVC.fromWhere=@"no";
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav pushViewController:shopOfGoodsVC animated:YES];
    } else {
    
        OrderDetailOfGoodsViewController *orderDetailOfGoodsVC = [[OrderDetailOfGoodsViewController alloc]init];
        orderDetailOfGoodsVC.orderIdStr = [NSString stringWithFormat:@"%ld",(long)orderOfGoodsListModel.orderId];
        IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.nav pushViewController:orderDetailOfGoodsVC animated:YES];
        
    }
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    if (self.refreshing==YES) {
        
        self.currentPage=0;
        [self requestGoodsOrderList];
    }
    else {
        if(self.totalPages>self.currentPage){
            [self requestGoodsOrderList];
        }
        else{
            
            [mtableview tableViewDidFinishedLoading]; //加载完成（可设置信息）
            mtableview.reachedTheEnd = YES;  //是否加载到底了
        }
    }
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    self.refreshing=YES;
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
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

//上拉加载  Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    if(isFirstInt==YES){
        self.refreshing=NO;
        [self performSelector:@selector(loadData) withObject:nil afterDelay:0.0f];
    }
    else {
        [mtableview tableViewDidFinishedLoading];
        isFirstInt=!isFirstInt;
    }
}

#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (mtableview.contentOffset.y<-60) {
        mtableview.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [mtableview tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [mtableview tableViewDidEndDragging:scrollView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DisPlayLoginView{
    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    login.delegate=self;
    [login show];
    return;
}

//请求商品订单列表
-(void)requestGoodsOrderList{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0201\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"requestRow\":\"10\",\"currentPage\":\"%ld\",\"selectType\":\"%ld\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],(long)self.currentPage+1,(long)self.index + 1];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"商品订单列表返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (kResCode == 10002 || kResCode == 10003) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [mtableview tableViewDidFinishedLoading];
                        [self performSelector:@selector(DisPlayLoginView) withObject:nil afterDelay:0.5];
                    });
                }
                else if (code==102011) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *resArr=[jsonDict objectForKey:@"orderList"];
                        self.totalPages=[[jsonDict objectForKey:@"totalPage"] integerValue];
                        self.currentPage=[[jsonDict objectForKey:@"currentPage"]integerValue];
                        if (resArr.count) {
                            if(self.refreshing==YES && [_orderOfGoodsListModelArr count]) [_orderOfGoodsListModelArr removeAllObjects];
                            
                            [_orderOfGoodsListModelArr addObjectsFromArray:[OrderOfGoodsListModel objectArrayWithKeyValuesArray:resArr]];
                        }
                        
                        if (_orderOfGoodsListModelArr.count) {
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [mtableview tableViewDidFinishedLoading];
                        } else {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                            [mtableview tableViewDidFinishedLoading];
                        }
                        
                        [mtableview reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                        [mtableview tableViewDidFinishedLoading];
                    });
                }
            });
            
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [mtableview tableViewDidFinishedLoading];
                              });
                          }
                               method:url postDict:nil];
    });
    
}



#pragma mark -  更新订单状态
- (void)updateOrderStaus:(NSNotification *)notification {
    [mtableview launchRefreshing];
}

- (void)clickCommentBtn:(UIButton *)btn {
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)btn.superview.superview.superview;
    else
        cell= (UITableViewCell *)btn.superview.superview.superview.superview;
    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
    
    OrderOfGoodsListModel *orderOfGoodsListModel = [_orderOfGoodsListModelArr objectAtIndex:indexPath.section];
    
    NSDictionary *goodsInfoDic = [orderOfGoodsListModel.shopOrderDetailes objectAtIndex:indexPath.row - 1];
    
    CommentOfGoodsViewController *commentOfGoodsVC = [[CommentOfGoodsViewController alloc]initWithNibName:@"CommentOfGoodsViewController" bundle:nil];
    
    
    commentOfGoodsVC.shopIdStr= [NSString stringWithFormat:@"%ld",(long)orderOfGoodsListModel.shopId];
    commentOfGoodsVC.shopGoodsDetailIdStr = [NSString stringWithFormat:@"%ld",(long)[[goodsInfoDic objectForKey:@"goodsId"]integerValue]];
    commentOfGoodsVC.shopOrderDetailStr = [NSString stringWithFormat:@"%ld",(long)[[goodsInfoDic objectForKey:@"orderDetailId"]integerValue]];
    commentOfGoodsVC.goodsInfoDic = goodsInfoDic;
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.nav pushViewController:commentOfGoodsVC animated:YES];
}

- (void)clickRefundBtn:(UIButton *)btn {
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)btn.superview.superview.superview;
    else
        cell= (UITableViewCell *)btn.superview.superview.superview.superview;
    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
    
    OrderOfGoodsListModel *orderOfGoodsListModel = [_orderOfGoodsListModelArr objectAtIndex:indexPath.section];
    
    NSDictionary *goodsInfoDic = [orderOfGoodsListModel.shopOrderDetailes objectAtIndex:indexPath.row - 1];
    
    
    if ([[goodsInfoDic objectForKey:@"isExistApplyingRefund"]integerValue] == 1) {
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"您已申请退款，不能重复申请";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
//        [TLToast showWithText:@"您已申请退款，不能重复申请"];
        return;
    }
    
    RefundOfApplyGoodsViewController *refundOfGoodsVC = [[RefundOfApplyGoodsViewController alloc] init];
    refundOfGoodsVC.orderIdStr = [NSString stringWithFormat:@"%ld",(long)orderOfGoodsListModel.orderId];
    refundOfGoodsVC.shopOrderDetailStr = [NSString stringWithFormat:@"%ld",(long)[[goodsInfoDic objectForKey:@"orderDetailId"]integerValue]];
    refundOfGoodsVC.shopGoodsDetailIdStr = [NSString stringWithFormat:@"%ld",(long)[[goodsInfoDic objectForKey:@"goodsId"]integerValue]];
    float goosCount =[[[orderOfGoodsListModel.shopOrderDetailes objectAtIndex:indexPath.row-1] objectForKey:@"goodsCount"] floatValue];
    float goodsPrice =[[[orderOfGoodsListModel.shopOrderDetailes objectAtIndex:indexPath.row-1] objectForKey:@"goodsPrice"] floatValue];
    refundOfGoodsVC.goodsTotalMoneyStr = [NSString stringWithFormat:@"%.2f",[[[orderOfGoodsListModel.shopOrderDetailes objectAtIndex:indexPath.row-1] objectForKey:@"couponTotalFee"] doubleValue]];
    refundOfGoodsVC.goodsName =[goodsInfoDic objectForKey:@"goodsName"];
    refundOfGoodsVC.shopIdStr = [NSString stringWithFormat:@"%ld",(long)orderOfGoodsListModel.shopId ];
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav pushViewController:refundOfGoodsVC animated:YES];
}

- (void)clickAfterSaleBtn:(UIButton *)btn {
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)btn.superview.superview.superview;
    else
        cell= (UITableViewCell *)btn.superview.superview.superview.superview;
    NSIndexPath *indexPath = [mtableview indexPathForCell:cell];
    
    OrderOfGoodsListModel *orderOfGoodsListModel = [_orderOfGoodsListModelArr objectAtIndex:indexPath.section];
    
    NSDictionary *goodsInfoDic = [orderOfGoodsListModel.shopOrderDetailes objectAtIndex:indexPath.row - 1];
    
    
    if ([[goodsInfoDic objectForKey:@"isExistApplyingAfterSale"]integerValue] == 1) {
        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        customPromp.contenttxt =@"您已申请售后，不能重复申请";
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
        [customPromp addGestureRecognizer:tap];
        [customPromp show];
//        [TLToast showWithText:@"您已申请售后，不能重复申请"];
        return;
    }
    
    AfterSaleOfGoodsViewController *afterSaleOfGoodsVC = [[AfterSaleOfGoodsViewController alloc]initWithNibName:@"AfterSaleOfGoodsViewController" bundle:nil];
    afterSaleOfGoodsVC.orderIdStr = [NSString stringWithFormat:@"%ld",(long)orderOfGoodsListModel.orderId];
    afterSaleOfGoodsVC.shopOrderDetailStr = [NSString stringWithFormat:@"%ld",(long)[[goodsInfoDic objectForKey:@"orderDetailId"]integerValue]];
     afterSaleOfGoodsVC.goodsid =[NSString stringWithFormat:@"%d",[[goodsInfoDic objectForKey:@"goodsId"] intValue]];
    afterSaleOfGoodsVC.shopIdStr = [NSString stringWithFormat:@"%ld",(long)orderOfGoodsListModel.shopId ];
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav pushViewController:afterSaleOfGoodsVC animated:YES];
}

- (void)clickBtn1:(UIButton *)sender {
    OrderOfGoodsListModel *_detailModel = [_orderOfGoodsListModelArr objectAtIndex:sender.tag-kOrderOperation_Tag];
    
    if (_detailModel.state == 1||_detailModel.state ==10) {
        //立即付款
        if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
            [self gotoPayingConfirmPage:_detailModel index:sender.tag-kOrderOperation_Tag];
        }else{
            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
            login.delegate=self;
            [login show];
        }
    } else if (_detailModel.state == 2) {
        //取消订单
        self.selectCancle =(int)sender.tag-kOrderOperation_Tag;
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"是否取消订单?" message:@"取消订单需与卖家协商，确定取消该订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    } else if (_detailModel.state == 3) {
        //确认收货
        [self confirmDeliveryOfGoods:_detailModel];
    } else if (_detailModel.state ==6){
        [self closeApply:_detailModel index:sender.tag-kOrderOperation_Tag];
    }
}

- (void)clickBtn2:(UIButton *)sender {
    OrderOfGoodsListModel *_detailModel = [_orderOfGoodsListModelArr objectAtIndex:sender.tag-kOrderOperation_Tag*2];
    
    if (_detailModel.state == 1) {
        //关闭订单
        [self closeOrderOfGoods:_detailModel index:sender.tag-kOrderOperation_Tag*2];
    } else if (_detailModel.state == 3) {
        //取消订单
        self.selectCancle =(int)sender.tag-kOrderOperation_Tag*2;
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"是否取消订单?" message:@"取消订单需与卖家协商，确定取消该订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
//        [self cancelOrderOfGoods:_detailModel index:sender.tag-kOrderOperation_Tag*2];
    }
}

#pragma mark - 关闭申请
-(void)closeApply:(OrderOfGoodsListModel *)_detailModel index:(NSInteger)index{
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
                        [TLToast showWithText:@"关闭申请成功"];
                        _detailModel.state=[[jsonDict objectForKey:@"state"] integerValue];
                        _detailModel.stateName=[jsonDict objectForKey:@"stateName"];
                        
                        [_orderOfGoodsListModelArr replaceObjectAtIndex:index withObject:_detailModel];
                        [mtableview reloadData];
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
- (void)gotoPayingConfirmPage:(OrderOfGoodsListModel *)_detailModel index:(NSInteger)index{
    [savelogObj saveLog:@"商品订单-确认付款" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:83];
    
    if(_detailModel.orderTotalMoney==0){
        [self OrderMoneyIsZero:_detailModel index:index];
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
                                payingConfirmVC.fromStr = @"orderDetailOfGoodsVC";
                                payingConfirmVC.typeStr = @"商城";
                                payingConfirmVC.serviceNameStr=[NSString stringWithFormat:@"%ld,",(long)_detailModel.orderId];
                                payingConfirmVC.moneyFloat = _detailModel.orderTotalMoney;
                                if (_detailModel.state ==10) {
                                    payingConfirmVC.moneyFloat =_detailModel.waitePayment;
                                }
                                payingConfirmVC.orderNo = _detailModel.orderCode;
                                payingConfirmVC.amounts =[NSString stringWithFormat:@"%.2f",_detailModel.orderTotalMoney];
                                IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
                                [delegate.nav pushViewController:payingConfirmVC animated:YES];
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
- (void)cancelOrderOfGoods:(OrderOfGoodsListModel *)_detailModel  index:(NSInteger)index {
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
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        self.view.tag = 1002;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                           // login.delegate=self;
                            [login show];
                            
                        });
                        
                        return;
                    }
                    
                    if (kResCode == 102051) {
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            [TLToast showWithText:@"取消订单成功"];
                            _detailModel.state=[[jsonDict objectForKey:@"state"] integerValue];
                            _detailModel.stateName=[jsonDict objectForKey:@"stateName"];
                        
                            [_orderOfGoodsListModelArr replaceObjectAtIndex:index withObject:_detailModel];
                            [mtableview reloadData];
                        });
                        
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
- (void)closeOrderOfGoods:(OrderOfGoodsListModel *)_detailModel index:(NSInteger)index {
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
                 NSLog(@"关闭订单login返回信息：%@",jsonDict);
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
                        
                        
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [TLToast showWithText:@"关闭订单成功"];
                        _detailModel.state=[[jsonDict objectForKey:@"state"] integerValue];
                        _detailModel.stateName=[jsonDict objectForKey:@"stateName"];
                        
                        [_orderOfGoodsListModelArr replaceObjectAtIndex:index withObject:_detailModel];
                        [mtableview reloadData];
                        
                     });
                        
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

#pragma mark - 支付金额为0的订单的付款方式
- (void)OrderMoneyIsZero:(OrderOfGoodsListModel *)_detailModel index:(NSInteger)index {
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
        
        NSString *orderIdStr = [NSString stringWithFormat:@"%ld",(long)_detailModel.orderCode];
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
                            [_orderOfGoodsListModelArr replaceObjectAtIndex:index withObject:_detailModel];
                            [mtableview reloadData];
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

-(void)hideAction:(id)sender{
    [customPromp dismiss];
}
#pragma mark - 确认收货
- (void)confirmDeliveryOfGoods:(OrderOfGoodsListModel *)_detailModel {
    
    InputPayPsdViewController *inputPayPsdVC = [[InputPayPsdViewController alloc]init];
    inputPayPsdVC.sourceVC = @"orderDetailOfGoodsVC";
    inputPayPsdVC.fromStr = @"orderDetailOfGoodsVC";
    inputPayPsdVC.detailModel = _detailModel;
    IDIAIAppDelegate *delegate = (IDIAIAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.nav pushViewController:inputPayPsdVC animated:YES];
}
#pragma mark -AlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        OrderOfGoodsListModel *_detailModel = [_orderOfGoodsListModelArr objectAtIndex:self.selectCancle];
        [self cancelOrderOfGoods:_detailModel index:self.selectCancle];
    }
}
@end
