//
//  ShoppingCartViewController.m
//  IDIAI
//
//  Created by Ricky on 15/5/13.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ShoppingCartViewController2.h"
#import "IDIAIAppDelegate.h"
#import "PullingRefreshTableView.h"
#import "ShoppingCartOfShopModel.h"
#import "LoginView.h"
#import "UIImageView+WebCache.h"
#import "ShoppingCartOfGoodsModel.h"
#import "ShopSectionItem.h"
#import "goodsRowItem.h"
#import "ConfirmOrderOfGoodsViewController2.h"
#import "TLToast.h"
#import "GoodsDetailViewController.h"
#import "ShopOfGoodsViewController.h"
#import "CustomPromptView.h"
#import "ShoppingMallViewController.h"

#define IS_iOS8 [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue]

@interface ShoppingCartViewController2 () <PullingRefreshTableViewDelegate,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,LoginViewDelegate> {
    
    PullingRefreshTableView *_theTableView;
    UIView *_lastRowView;
    NSArray *_theDataArr;
    UILabel *_hintLabel;
    
    NSInteger counter;
    
    UIImageView *imageview_bg;
    UILabel *label_bg;
    UIButton *btn_goShop;
    
    NSMutableArray *_shoppingCartModelMutArr;
  

    CGFloat _totalPrice;
    UILabel *_moneyValueLabel;
    
    NSMutableArray *_orderMutArr;
    NSMutableArray *_orderSectionItemMutArr;
    
    NSMutableArray *_selectedShopModelMutArr;
    CustomPromptView *customPromp;
    
}

@end

@implementation ShoppingCartViewController2






- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"goumaiSucceed" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
   
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",counter]forKey:User_GoodsNumberInShoppingCart];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购物车";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleConfirmOrderSuccess) name:@"goumaiSucceed" object:nil];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    _orderMutArr = [NSMutableArray arrayWithCapacity:10];
    _orderSectionItemMutArr = [NSMutableArray arrayWithCapacity:10];
    
    _selectedShopModelMutArr = [NSMutableArray arrayWithCapacity:5];

    _theTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 60-50) style:UITableViewStyleGrouped];
    _theTableView.pullingDelegate=self;
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _theTableView.headerOnly=YES;
    [_theTableView launchRefreshing];
    [self.view addSubview:_theTableView];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight -64-50, kMainScreenWidth, 50)];
    footerView.backgroundColor = [UIColor whiteColor];
    UILabel *moneyTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 50, 20)];
    moneyTitleLabel.font=[UIFont systemFontOfSize:13];
    moneyTitleLabel.text = @"合计：";
    moneyTitleLabel.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
    _moneyValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, kMainScreenWidth-145, 20)];
    _moneyValueLabel.textColor = kThemeColor;
    _moneyValueLabel.font=[UIFont systemFontOfSize:18];
    _moneyValueLabel.text = @"￥0.00";
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(kMainScreenWidth - 10 - 80, 7.5, 80, 35);
    [confirmBtn setTitle:@"结算" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = kThemeColor;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 3;
    
    [footerView addSubview:moneyTitleLabel];
    [footerView addSubview:_moneyValueLabel];
    [footerView addSubview:confirmBtn];
    
    [self.view addSubview:footerView];
    
    [self loadImageviewBG];
}

#pragma mark -
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _shoppingCartModelMutArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[_shoppingCartModelMutArr objectAtIndex:section]cartGoodsDetails]count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    } else {
        return 120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier1 = [NSString stringWithFormat:@"Cell1%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier2 = [NSString stringWithFormat:@"Cell2%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    }
    
    if (cell == nil) {

        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            
            UIView *row1View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth , 44)];
            row1View.tag = 10001;
            row1View.backgroundColor = [UIColor whiteColor];
            
            UIImageView *shopHeadIV = [[UIImageView alloc]initWithFrame:CGRectMake(35, 5, 34, 34)];
            shopHeadIV.tag = 1001;
            shopHeadIV.layer.masksToBounds = YES;
            shopHeadIV.layer.cornerRadius = 17;
            
            UILabel *shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(77 + 5, 0, 200, 44)];
            shopNameLabel.textAlignment=NSTextAlignmentLeft;
            shopNameLabel.tag = 1002;
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, row1View.frame.size.height, kMainScreenWidth - 20, 0.5)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
            
            UIButton *cellPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cellPhoneBtn.frame = CGRectMake(kMainScreenWidth  - 40, 5, 34, 34);
            [cellPhoneBtn setImage:[UIImage imageNamed:@"ic_dianhua.png"] forState:UIControlStateNormal];
            [cellPhoneBtn addTarget: self action:@selector(clickCellPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
            cellPhoneBtn.tag = 1003;
            
 
            UIButton *selectShopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selectShopBtn.frame = CGRectMake(0, 0, 35, 44);
            [selectShopBtn setImage:[UIImage imageNamed:@"ic_xuanze_nor.png"] forState:UIControlStateNormal];
            [selectShopBtn setImage:[UIImage imageNamed:@"ic_xuanze.png"] forState:UIControlStateSelected];
            selectShopBtn.tag = 1004;
            [selectShopBtn addTarget:self action:@selector(clickSelectShopBtn:) forControlEvents:UIControlEventTouchUpInside];

            [row1View addSubview:shopHeadIV];
            [row1View addSubview:shopNameLabel];
            [row1View addSubview:lineView];
            [row1View addSubview:cellPhoneBtn];
            [row1View addSubview:selectShopBtn];
            [cell.contentView addSubview:row1View];
            
        } else {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            
            UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"ShoppingCartView" owner:self options:nil]lastObject];
              view.frame = CGRectMake(0, 0, kMainScreenWidth , view.frame.size.height);
            
            UIButton *selectGoodsBtn = (UIButton *)[view viewWithTag:106];
            [selectGoodsBtn addTarget:self action:@selector(clickSelectGoodsBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *deleteBtn = (UIButton *)[view viewWithTag:105];
            deleteBtn.layer.masksToBounds = YES;
            deleteBtn.layer.cornerRadius = 3;
            deleteBtn.layer.borderColor = kThemeColor.CGColor;
            deleteBtn.layer.borderWidth = 1;
            [deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            TextStepperField *stepper = [[TextStepperField alloc] initWithFrame:CGRectMake(kMainScreenWidth - 130, 83, 100, 30)];
            stepper.textField.delegate = self;
            stepper.tag = 107;
//            stepper.Current = _theFloat != 0?_theFloat:1;
                counter = 1;
                stepper.Step = 1;
                stepper.Minimum = 0;
                stepper.Maximum = 10000;
                stepper.NumDecimals = 0;
                stepper.IsEditableTextField = YES;
            stepper.textField.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            [stepper addTarget:self
                        action:@selector(programmaticallyCreatedStepperDidStep:)
              forControlEvents:UIControlEventValueChanged];
            [view addSubview:stepper];
            [cell.contentView addSubview:view];
        }
    }
    
    ShoppingCartOfShopModel *shopModel = [_shoppingCartModelMutArr objectAtIndex:indexPath.section];
//    _goodsModelMutArr = shoppingCartOfShopModel.cartGoodsDetails;
 

    if (indexPath.row == 0) {
        UIImageView *shopIV = (UIImageView *)[cell viewWithTag:1001];
        NSString *imgUrlStr = shopModel.shopLogoPath;
        [shopIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
        UILabel *shopNameLabel = (UILabel *)[cell viewWithTag:1002];
        shopNameLabel.text = shopModel.shopName;
        
//        ShopSectionItem *item = [_sectionItemMutArr objectAtIndex:indexPath.section];
        UIButton *selectShopBtn = (UIButton *)[cell viewWithTag:1004];
        
        int count = 0;
        for (ShoppingCartOfGoodsModel *goodsModel in shopModel.cartGoodsDetails) {
            if (goodsModel.isSelect) {
                count++;
            }
        }
        if (count == shopModel.cartGoodsDetails.count) {
            selectShopBtn.selected = YES;
        } else {
            selectShopBtn.selected = NO;
        }
        
//        if (item.isSelected) {
//            selectShopBtn.selected = YES;
//            
//        } else {
//            selectShopBtn.selected = NO;
//        }
       
    } else {
        ShoppingCartOfGoodsModel *goodsModel = [shopModel.cartGoodsDetails objectAtIndex:indexPath.row-1];
        
        UIImageView *goodsIV = (UIImageView *)[cell viewWithTag:101];
        goodsIV.backgroundColor = kThemeColor;
        NSString *imgUrlStr = goodsModel.goodsUrl;
        [goodsIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
        UILabel *goodsName = (UILabel *)[cell viewWithTag:102];
        goodsName.text = goodsModel.goodsName;
        
        UILabel *guigeLabel = (UILabel *)[cell viewWithTag:103];
        if([goodsModel.goodsColor length]>=1){
            if(kMainScreenWidth>320) guigeLabel.text =[NSString stringWithFormat:@"颜色：%@        规格：%@",goodsModel.goodsColor,goodsModel.goodsModel];
            else guigeLabel.text =[NSString stringWithFormat:@"颜色：%@    规格：%@",goodsModel.goodsColor,goodsModel.goodsModel];
        }
        else
            guigeLabel.text =[NSString stringWithFormat:@"规格：%@",goodsModel.goodsModel];
            
        UILabel *montyAndAmountLabel = (UILabel *)[cell viewWithTag:104];
        montyAndAmountLabel.text = [NSString stringWithFormat:@"￥%.2f x %ld",goodsModel.goodsPrice,(long)goodsModel.goodsCount];
        TextStepperField *steper = (TextStepperField *)[cell viewWithTag:107];
        steper.Current = goodsModel.goodsCount;
        
//        UILabel *saveValueLabel = (UILabel *)[cell viewWithTag:110];
//        CGFloat singleGoodsPrice = shoppogCartOfGoodsModel.goodsPrice * shoppogCartOfGoodsModel.goodsCount;
//        saveValueLabel.text = [NSString stringWithFormat:@"%.2f",singleGoodsPrice];
        
//        ShopSectionItem *item = [_sectionItemMutArr objectAtIndex:indexPath.section];
//
//        GoodsRowItem *goodsItem = [item.goodsRowArr objectAtIndex:indexPath.row-1];
         UIButton *selectGoodsBtn = (UIButton *)[cell viewWithTag:106];
        if (goodsModel.isSelect) {
            selectGoodsBtn.selected = YES;
//            goodsItem.goodsPrice = shoppingCartOfGoodsModel.goodsPrice * shoppingCartOfGoodsModel.goodsCount;
        } else {
            selectGoodsBtn.selected = NO;
        }
   
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ShoppingCartOfGoodsModel *shopModel = [_shoppingCartModelMutArr objectAtIndex:indexPath.section];
        ShopOfGoodsViewController *shopOfGoodsVC = [[ShopOfGoodsViewController alloc]init];
        shopOfGoodsVC.shopIdStr = [NSString stringWithFormat:@"%ld",(long)shopModel.shopId];
        [self.navigationController pushViewController:shopOfGoodsVC animated:YES];
    }
    else{
        ShoppingCartOfShopModel *shopModel = [_shoppingCartModelMutArr objectAtIndex:indexPath.section];
        ShoppingCartOfGoodsModel *goodsModel = [shopModel.cartGoodsDetails objectAtIndex:indexPath.row - 1];
        
        NSString *goodsIdStr = [NSString stringWithFormat:@"%ld",(long)goodsModel.goodsId];
        GoodsDetailViewController *goodsDetailVC = [[GoodsDetailViewController alloc]init];
        goodsDetailVC.goodsIdStr = goodsIdStr;
        goodsDetailVC.type=@"jsBridge";
        [self.navigationController pushViewController:goodsDetailVC animated:YES];
    }
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

//加载数据方法
- (void)loadData
{
    [self requestShoppongCartList];
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // NSLog(@"%s - [%d]",__FUNCTION__,__LINE__);
    imageview_bg.hidden=YES;
    label_bg.hidden = YES;
    btn_goShop.hidden=YES;
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

#pragma mark -
#pragma mark - ScrollView Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_theTableView.contentOffset.y<-60) {
        _theTableView.reachedTheEnd = NO;  //是否加载到底了
    }
    //手指开始拖动方法
    [_theTableView tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_theTableView tableViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark - Other Methods

- (void)ibStepperDidStep:(id)sender {
    
}

- (void)clickCellPhoneBtn:(UIButton *)btn {
    
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)btn.superview.superview.superview;
    else
        cell= (UITableViewCell *)btn.superview.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
    
    ShoppingCartOfShopModel *shopModel = [_shoppingCartModelMutArr objectAtIndex:indexPath.section];
    NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",shopModel.shopMobile];
    UIWebView *callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
    [self.view addSubview:callWebview];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    TextStepperField *stepper = (TextStepperField *)textField.superview;
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)stepper.superview.superview.superview;
    else
        cell= (UITableViewCell *)stepper.superview.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
    
    ShoppingCartOfShopModel *shopModel = [_shoppingCartModelMutArr objectAtIndex:indexPath.section];
    ShoppingCartOfGoodsModel *goodsModel = [shopModel.cartGoodsDetails objectAtIndex:indexPath.row - 1];
    goodsModel.goodsCount = stepper.Current;
    
   
        for (ShoppingCartOfShopModel *selectedShopModel in _selectedShopModelMutArr) {
            for (ShoppingCartOfGoodsModel *selectedGoodsModel in selectedShopModel.cartGoodsDetails) {
                if (selectedGoodsModel.goodsId == goodsModel.goodsId) {
                
                    selectedGoodsModel.goodsCount = stepper.Current;
                    
                }
                
                    
            }
        }
    
    
    double price = 0.0;
    for (ShoppingCartOfShopModel *selectedShopModel in _selectedShopModelMutArr) {
        for (ShoppingCartOfGoodsModel *selectedGoodsModel in selectedShopModel.cartGoodsDetails) {
            
            UIButton *selectGoodsBtn = (UIButton *)[cell viewWithTag:106];
            if (selectGoodsBtn.selected) {
                //                            CGFloat price = [[_moneyValueLabel.text stringByReplacingOccurrencesOfString:@"￥" withString:@""]floatValue];
                
                price += selectedGoodsModel.goodsPrice * selectedGoodsModel.goodsCount;
                
                
                
            }

            
        }
    }

    
    _moneyValueLabel.text = [NSString stringWithFormat:@"￥%.2f",price];

    
    [_theTableView reloadData];
}

- (void)programmaticallyCreatedStepperDidStep:(TextStepperField *)stepper {
    
    if ([stepper.textField isFirstResponder]) {
        
        return;
    }
    
    if (stepper.TypeChange == TextStepperFieldChangeKindNegative) {
        counter -= 1;
        UITableViewCell *cell;
        if(IS_iOS8>=8)
            cell= (UITableViewCell *)stepper.superview.superview.superview;
        else
            cell= (UITableViewCell *)stepper.superview.superview.superview.superview;
        NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
        
        ShoppingCartOfShopModel *shopModel = [_shoppingCartModelMutArr objectAtIndex:indexPath.section];
        if(indexPath.row==0) return;
        ShoppingCartOfGoodsModel *goodsModel = [shopModel.cartGoodsDetails objectAtIndex:indexPath.row - 1];

        if (goodsModel.goodsCount > 1) {
        goodsModel.goodsCount -= 1;
            
            for (ShoppingCartOfShopModel *selectedShopModel in _selectedShopModelMutArr) {
                for (ShoppingCartOfGoodsModel *selectedGoodsModel in selectedShopModel.cartGoodsDetails) {
                    if (selectedGoodsModel.goodsId == goodsModel.goodsId) {
                        
                        if (selectedGoodsModel.goodsCount > 1) {
                            selectedGoodsModel.goodsCount -= 1;
                            
                            UIButton *selectGoodsBtn = (UIButton *)[cell viewWithTag:106];
                            if (selectGoodsBtn.selected) {
                                double price = [[_moneyValueLabel.text stringByReplacingOccurrencesOfString:@"￥" withString:@""]doubleValue];
                                
                                
//                                for (ShoppingCartOfGoodsModel *goodsModel in shopModel.cartGoodsDetails) {
                                
                                    price -= goodsModel.goodsPrice;
//                                }
                                
                                _moneyValueLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
                            }
                            

                            
                        }
                        
                        
                    }
                }
            }
        
        }
    }
    else {
        counter += 1;
        UITableViewCell *cell;
       if(IS_iOS8>=8)
            cell= (UITableViewCell *)stepper.superview.superview.superview;
        else
            cell= (UITableViewCell *)stepper.superview.superview.superview.superview;
        NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
        
        ShoppingCartOfShopModel *shopModel = [_shoppingCartModelMutArr objectAtIndex:indexPath.section];
        if(indexPath.row==0) return;
        ShoppingCartOfGoodsModel *goodsModel = [shopModel.cartGoodsDetails objectAtIndex:indexPath.row - 1];
        if (goodsModel.goodsCount >= 1)
            goodsModel.goodsCount += 1;
    
        
        for (ShoppingCartOfShopModel *selectedShopModel in _selectedShopModelMutArr) {
            for (ShoppingCartOfGoodsModel *selectedGoodsModel in selectedShopModel.cartGoodsDetails) {
                if (selectedGoodsModel.goodsId == goodsModel.goodsId) {
                    
                    
                    if (selectedGoodsModel.goodsCount >= 1) {
                        selectedGoodsModel.goodsCount += 1;
                        
                        UIButton *selectGoodsBtn = (UIButton *)[cell viewWithTag:106];
                        if (selectGoodsBtn.selected) {
                            double price = [[_moneyValueLabel.text stringByReplacingOccurrencesOfString:@"￥" withString:@""]doubleValue];
                            
                            
//                            for (ShoppingCartOfGoodsModel *selectedGoodsModel in selectedShopModel.cartGoodsDetails) {
                            
                                price += selectedGoodsModel.goodsPrice;
//                            }
                            
                            _moneyValueLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
                        }

                    
                }
            }
        }
        
        
        
            
        }
    }
    
    [_theTableView reloadData];
    
}


- (void)clickDeleteBtn:(UIButton *)btn {
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)btn.superview.superview.superview;
    else
        cell= (UITableViewCell *)btn.superview.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
    
    ShoppingCartOfShopModel *shopModel = [_shoppingCartModelMutArr objectAtIndex:indexPath.section];
    ShoppingCartOfGoodsModel *goodsModel = [shopModel.cartGoodsDetails objectAtIndex:indexPath.row - 1];
    
    
    [self requestDeleteGoods:[NSString stringWithFormat:@"%ld",(long)goodsModel.cartId] btn:btn];
}

- (void)clickSelectShopBtn:(UIButton *)btn {
    
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)btn.superview.superview.superview;
    else
        cell= (UITableViewCell *)btn.superview.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
    
    ShoppingCartOfShopModel *shopModel = [_shoppingCartModelMutArr objectAtIndex:indexPath.section];
   
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        for (ShoppingCartOfGoodsModel *goodsModel in shopModel.cartGoodsDetails) {
            goodsModel.isSelect = YES;
        }
    } else {
        for (ShoppingCartOfGoodsModel *goodsModel in shopModel.cartGoodsDetails) {
            goodsModel.isSelect = NO;
        }
    }
    
    
    for (ShoppingCartOfShopModel *selectedShopModel in _selectedShopModelMutArr) {
        if (selectedShopModel.shopId == shopModel.shopId) {
            [_selectedShopModelMutArr removeObject:selectedShopModel];
            break;
        }
    }

    
    for (ShoppingCartOfGoodsModel *goodsModel in shopModel.cartGoodsDetails) {
        if (goodsModel.isSelect) {
            ShoppingCartOfShopModel *shopModel = [_shoppingCartModelMutArr objectAtIndex:indexPath.section];
            
            
            NSMutableArray *goodsMutArr = [NSMutableArray arrayWithCapacity:5];
            
            NSMutableDictionary *shopMutDic = [NSMutableDictionary dictionaryWithDictionary:@{@"buyerid":@(shopModel.buyerid),@"cartId":@(shopModel.cartId),@"shopId":@(shopModel.shopId),@"shopLogoPath":shopModel.shopLogoPath,@"shopName":shopModel.shopName,@"cartGoodsDetails":goodsMutArr,@"shopMobile":shopModel.shopMobile}];
            
            
            NSMutableDictionary *goodsDic = [NSMutableDictionary dictionaryWithDictionary:@{@"goodsColor":goodsModel.goodsColor,@"goodsCount":@(goodsModel.goodsCount),@"goodsId":@(goodsModel.goodsId),@"goodsModel":goodsModel.goodsModel,@"goodsName":goodsModel.goodsName,@"goodsPrice":@(goodsModel.goodsPrice),@"goodsUrl":goodsModel.goodsUrl,@"isExistApplyingAfterSale":@(goodsModel.isExistApplyingAfterSale),@"isExistApplyingRefund":@(goodsModel.isExistApplyingRefund),@"orderDetailId":@(goodsModel.orderDetailId),@"shipFee":@(goodsModel.shipFee),@"shopId":@(goodsModel.shopId),@"isSelect":@(goodsModel.isSelect),@"cartId":@(goodsModel.cartId)}];
            
            [goodsMutArr addObject:goodsDic];
            
            ShoppingCartOfShopModel *selectModel = [ShoppingCartOfShopModel objectWithKeyValues:shopMutDic];
            
            [_selectedShopModelMutArr addObject:selectModel];
        } else {
            for (int i = 0; i < _selectedShopModelMutArr.count; i++) {
                ShoppingCartOfShopModel *selectedShopModel = [_selectedShopModelMutArr objectAtIndex:i];
                if (selectedShopModel.shopId == shopModel.shopId) {
              [_selectedShopModelMutArr removeObject:selectedShopModel];
                }
                
            }
        }
        
    }
    
  
    double price = 0.0;
    for (ShoppingCartOfShopModel *shopModel in _selectedShopModelMutArr) {
        for (ShoppingCartOfGoodsModel *goodsModel in shopModel.cartGoodsDetails) {
            
            price += goodsModel.goodsPrice*goodsModel.goodsCount;
            
        }
    }
    _moneyValueLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
    
    
   [_theTableView reloadData];
}

- (void)clickSelectGoodsBtn:(UIButton *)btn {
    
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)btn.superview.superview.superview;
    else
        cell= (UITableViewCell *)btn.superview.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];

    
    ShoppingCartOfShopModel *shopModel = [_shoppingCartModelMutArr objectAtIndex:indexPath.section];
    ShoppingCartOfGoodsModel *goodsModel = [shopModel.cartGoodsDetails objectAtIndex:indexPath.row-1];

    goodsModel.isSelect = !btn.selected;
    
    if (goodsModel.isSelect) {
        ShoppingCartOfShopModel *shopModel = [_shoppingCartModelMutArr objectAtIndex:indexPath.section];
    
        NSMutableArray *goodsMutArr = [NSMutableArray arrayWithCapacity:5];
        
        NSMutableDictionary *shopMutDic = [NSMutableDictionary dictionaryWithDictionary:@{@"buyerid":@(shopModel.buyerid),@"cartId":@(shopModel.cartId),@"shopId":@(shopModel.shopId),@"shopLogoPath":shopModel.shopLogoPath,@"shopName":shopModel.shopName,@"cartGoodsDetails":goodsMutArr,@"shopMobile":shopModel.shopMobile}];
        
        
        NSMutableDictionary *goodsDic = [NSMutableDictionary dictionaryWithDictionary:@{@"goodsColor":goodsModel.goodsColor,@"goodsCount":@(goodsModel.goodsCount),@"goodsId":@(goodsModel.goodsId),@"goodsModel":goodsModel.goodsModel,@"goodsName":goodsModel.goodsName,@"goodsPrice":@(goodsModel.goodsPrice),@"goodsUrl":goodsModel.goodsUrl,@"isExistApplyingAfterSale":@(goodsModel.isExistApplyingAfterSale),@"isExistApplyingRefund":@(goodsModel.isExistApplyingRefund),@"orderDetailId":@(goodsModel.orderDetailId),@"shipFee":@(goodsModel.shipFee),@"shopId":@(goodsModel.shopId),@"isSelect":@(goodsModel.isSelect),@"cartId":@(goodsModel.cartId)}];
        
        [goodsMutArr addObject:goodsDic];
        
        ShoppingCartOfShopModel *selectModel = [ShoppingCartOfShopModel objectWithKeyValues:shopMutDic];
        
        [_selectedShopModelMutArr addObject:selectModel];
        
    } else {
    
        for (ShoppingCartOfShopModel *selectedShopModel in _selectedShopModelMutArr) {
            for (ShoppingCartOfGoodsModel *selectedGoodsModel in selectedShopModel.cartGoodsDetails) {
                if (selectedGoodsModel.goodsId == goodsModel.goodsId) {
                    [selectedShopModel.cartGoodsDetails removeObject:selectedGoodsModel];
                }
            }
            
            if (selectedShopModel.cartGoodsDetails.count == 0) {
                [_selectedShopModelMutArr removeObject:selectedShopModel];
                 break;
            }
           
        }
        
            
        
    
}

    [_theTableView reloadData];
    
    double price = 0.0;
    for (ShoppingCartOfShopModel *shopModel in _selectedShopModelMutArr) {
        for (ShoppingCartOfGoodsModel *goodsModel in shopModel.cartGoodsDetails) {
            price += goodsModel.goodsPrice*goodsModel.goodsCount;
        }
    }
    _moneyValueLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
}

-(void)DisPlayLoginView{
    LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
    login.delegate=self;
    [login show];
    return;
}

//请求购物车列表
-(void)requestShoppongCartList{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0216\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
               NSLog(@"购物车列表返回信息：%@",jsonDict);
                
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                
                //token为空或验证未通过处理 huangrun
                if (kResCode == 10002 || kResCode == 10003) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        [_theTableView tableViewDidFinishedLoading];
                        [self performSelector:@selector(DisPlayLoginView) withObject:nil afterDelay:0.5];
                    });
                }
                else if (code==102161) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSArray *resArr=[jsonDict objectForKey:@"shopCartList"];
                        if (resArr.count) {
                            _shoppingCartModelMutArr = [NSMutableArray arrayWithArray:[ShoppingCartOfShopModel objectArrayWithKeyValuesArray:resArr]];
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                             btn_goShop.hidden=YES;
                            
                            [_theTableView tableViewDidFinishedLoading];
                            [_theTableView reloadData];
                            
                        } else {
                            _shoppingCartModelMutArr = [NSMutableArray arrayWithArray:[ShoppingCartOfShopModel objectArrayWithKeyValuesArray:resArr]];
                            [_theTableView reloadData];
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                             btn_goShop.hidden=NO;
                        }
                        
                        [_theTableView tableViewDidFinishedLoading];
                        [_theTableView reloadData];
                    });
                }
                else if (code==102163) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if([_shoppingCartModelMutArr count]) {
                            btn_goShop.hidden=YES;
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                        }
                        else {
                            btn_goShop.hidden=NO;
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        
                        [_theTableView tableViewDidFinishedLoading];
                        [_theTableView reloadData];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        if([_shoppingCartModelMutArr count]) {
                            btn_goShop.hidden=YES;
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                        }
                        else {
                            btn_goShop.hidden=NO;
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        
                        [_theTableView tableViewDidFinishedLoading];
                        [_theTableView reloadData];
                    });
                }
            });
            
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  if([_shoppingCartModelMutArr count]) {
                                      btn_goShop.hidden=YES;
                                      imageview_bg.hidden=YES;
                                      label_bg.hidden = YES;
                                  }
                                  else {
                                      btn_goShop.hidden=NO;
                                      imageview_bg.hidden=NO;
                                      label_bg.hidden = NO;
                                  }
                                  
                                  [_theTableView tableViewDidFinishedLoading];
                                  [_theTableView reloadData];
                              });
                          }
                               method:url postDict:nil];
    });
    
}

-(void)loadImageviewBG{
    UIImage *image_failed = [UIImage imageNamed:@"ic_moren"];
    if(!imageview_bg)
        imageview_bg=[[UIImageView alloc] initWithImage:image_failed ];
    imageview_bg.frame=CGRectMake((kMainScreenWidth-image_failed.size.width)/2, (kMainScreenHeight-64-40-image_failed.size.height)/2, image_failed.size.width, image_failed.size.height);
    imageview_bg.tag=111;
    imageview_bg.hidden=YES;
    [self.view addSubview:imageview_bg];
    if (!label_bg)
        label_bg = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview_bg.frame.origin.y + imageview_bg.frame.size.height + 5, kMainScreenWidth, 21)];
    label_bg.textAlignment = NSTextAlignmentCenter;
    label_bg.font = [UIFont systemFontOfSize:13];
    label_bg.textColor = [UIColor lightGrayColor];
    label_bg.hidden = YES;
    label_bg.text = @"购物车空空，赶快去选择商品吧";
    [self.view addSubview:label_bg];
    
    btn_goShop=[[UIButton alloc]initWithFrame:CGRectMake((kMainScreenWidth-80)/2, label_bg.frame.origin.y + label_bg.frame.size.height + 10, 80, 30)];
    btn_goShop.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn_goShop setTitle:@"去逛逛" forState:UIControlStateNormal];
    [btn_goShop setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn_goShop setTitleColor:[UIColor colorWithHexString:@"#EF6562" alpha:1.0] forState:UIControlStateHighlighted];
    //给按钮加一个白色的板框
    btn_goShop.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    btn_goShop.layer.borderWidth = 0.5f;
    //给按钮设置弧度,这里将按钮变成了圆形
    btn_goShop.layer.cornerRadius = 5.0f;
    btn_goShop.layer.masksToBounds = YES;
    btn_goShop.backgroundColor=[UIColor clearColor];
    [btn_goShop addTarget:self action:@selector(gotoShopping:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_goShop];
    btn_goShop.hidden=YES;
}

-(void)gotoShopping:(UIButton *)sender{
    ShoppingMallViewController *shoppingMallVC = [[ShoppingMallViewController alloc]init];
    [self.navigationController pushViewController:shoppingMallVC animated:YES];
}

- (void)clickConfirmBtn:(UIButton *)btn {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:User_Token]){
        if (!_selectedShopModelMutArr.count) {
            [TLToast showWithText:@"请至少选择一件商品"];
            return;
        }
        
        
        ConfirmOrderOfGoodsViewController2 *confirmOrderGoodsVC = [[ConfirmOrderOfGoodsViewController2 alloc]init];
        
        confirmOrderGoodsVC.selectedShopModelMutArr = _selectedShopModelMutArr;
        [self.navigationController pushViewController:confirmOrderGoodsVC animated:YES];
    }else{
        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
        login.delegate=self;
        [login show];
    }
    
    
}

#pragma mark - 删除购物车商品
-(void)requestDeleteGoods:(NSString *)cartIdStr btn:(UIButton *)btn {
    
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)btn.superview.superview.superview;
    else
        cell= (UITableViewCell *)btn.superview.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
    
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
        [postDict setObject:@"ID0217" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        NSString *string=[postDict JSONString];
    
        NSDictionary *bodyDic = @{@"cartId":cartIdStr};
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
                    
                    if (kResCode == 102171) {
                        [self stopRequest];
                        [TLToast showWithText:@"删除成功"];
                        
                        ShoppingCartOfShopModel *shopModel=[_shoppingCartModelMutArr objectAtIndex:indexPath.section];
                        [shopModel.cartGoodsDetails removeObjectAtIndex:indexPath.row-1];  //点击删除商品
                        if([shopModel.cartGoodsDetails count])
                            [_shoppingCartModelMutArr replaceObjectAtIndex:indexPath.section withObject:shopModel];
                        else
                            [_shoppingCartModelMutArr removeObjectAtIndex:indexPath.section];
                        
                        [_theTableView reloadData];
                        
                        if([_shoppingCartModelMutArr count]) {
                            btn_goShop.hidden=YES;
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                        }
                        else {
                            btn_goShop.hidden=NO;
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                      
                    } else {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"删除失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"删除失败"];
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
-(void)hideAction:(id)sender{
    [customPromp dismiss];
}
- (void)backButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"goumaiSucceed" object:nil];
    if ([self.fromStr isEqualToString:@"jsBridge"])
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 购买成功后的通知处理
- (void)handleConfirmOrderSuccess {
    [_selectedShopModelMutArr removeAllObjects];
    [self requestShoppongCartList];
}

#pragma mark -
#pragma mark - LoginDelegate

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict{
    
}

@end
