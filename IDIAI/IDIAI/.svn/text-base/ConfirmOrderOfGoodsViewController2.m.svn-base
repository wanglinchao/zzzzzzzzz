//
//  ConfirmOrderOfGoodsViewController.m
//  IDIAI
//
//  Created by Ricky on 15/5/11.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "ConfirmOrderOfGoodsViewController2.h"
#import "TextStepperField.h"
#import "ShoppingCartOfShopModel.h"
#import "ShoppingCartOfGoodsModel.h"
#import "UIImageView+WebCache.h"
#import "ShopSectionItem.h"
#import "GoodsRowItem.h"
#import "LoginView.h"
#import "TLToast.h"
#import "AddressManageViewController.h"
#import "AddressManageModel.h"
#import "TPKeyboardAvoidingTableView.h"
#import "PayingConfirmViewController.h"
#import "ConfirmOrderOfGoodsModel.h"
#import "util.h"
#import "savelogObj.h"
#import "CustomPromptView.h"
#import "PreferentialObject.h"
#import "CouponMainViewController.h"
#import "OnlinePayViewController.h"
#define IS_iOS8 [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue]
#define KtextviewTag  10000

@interface ConfirmOrderOfGoodsViewController2 () <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UITextViewDelegate, ManageAddressVCDelegate,UITextFieldDelegate,LoginViewDelegate> {
    
    UITableView *_theTableView;
    UILabel *_hintLabel;
    NSInteger counter;
    UILabel *_moneyValueLabel;
    NSMutableArray *_requestMutArr;
    AddressManageModel *_addressModel;
    ConfirmOrderOfGoodsModel *_confirmOrderOfGoodsModel;
    CustomPromptView *customPromp;
}
@property(nonatomic,strong)PreferentialObject *preferential;
@property(nonatomic,assign)int couponNum;
@property(nonatomic,assign)double priceFee;
@property(nonatomic,assign)int noCouponNum;
@property(nonatomic,strong)UITapGestureRecognizer *tapView;
@end

@implementation ConfirmOrderOfGoodsViewController2

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"购物车结算" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:79];
//    self.couponNum =1;
    self.title = @"确认订单";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [self requestGoodsOrderAddress];
    _requestMutArr = [NSMutableArray arrayWithCapacity:10];
    
    
    NSMutableArray *goodsMutArr = [NSMutableArray arrayWithCapacity:10];
    self.tapView =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewEndEditing:)];
/****************************************************************************************/
/****************************************************************************************/
    // “一个商家对应一件自己商品”
        /*
            for (ShoppingCartOfShopModel *model in self.selectedShopModelMutArr) {
                NSDictionary *dict2;
                for (ShoppingCartOfGoodsModel *goodsModel in model.cartGoodsDetails) {
                    dict2 = @{@"goodsColor":goodsModel.goodsColor,@"goodsCount":@(goodsModel.goodsCount),@"goodsId":@(goodsModel.goodsId),@"goodsModel":goodsModel.goodsModel,@"goodsName":goodsModel.goodsName,@"goodsPrice":@(goodsModel.goodsPrice),@"goodsUrl":goodsModel.goodsUrl,@"orderDetailId":@(goodsModel.orderDetailId),@"shipFee":@(goodsModel.shipFee),@"shopId":@(goodsModel.shopId)};
     
                    [goodsMutArr addObject:dict2];
                }
     
                NSDictionary *dict = @{@"buyerid":@(model.buyerid),@"cartId":@(model.cartId),@"shopId":@(model.shopId),@"shopLogoPath":model.shopLogoPath,@"shopName":model.shopName,@"cartGoodsDetails":goodsMutArr};
                [_requestMutArr addObject:dict];
            }
        */
    
////////////////////////////////////////////////////////////////////////////////
    
    // 将“一个商家对应一件自己商品”转换为“一个商家对应多件自己的商品”，即多件商品同为一个商家所卖时将其归为一组里面。
    NSMutableArray *dateMutablearray = [@[] mutableCopy];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.selectedShopModelMutArr];
    
    for (int i = 0; i < array.count; i ++) {
        ShoppingCartOfShopModel *model = array[i];
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:model];
        
        for (int j = i+1; j < array.count; j ++) {
            ShoppingCartOfShopModel *model_last = array[j];
            if(model.shopId==model_last.shopId){
                [tempArray addObject:model_last];
                [array removeObjectAtIndex:j];
            }
        }
        [dateMutablearray addObject:tempArray];
    }
    
    NSMutableArray *arr_end=[NSMutableArray array];    //最终归类出来的组
    for(NSArray *arr_ in dateMutablearray){
        NSMutableArray *exchang_arr=[NSMutableArray array];
        for(ShoppingCartOfShopModel *model in arr_){
            [exchang_arr addObject:[model.cartGoodsDetails firstObject]];
        }
        
        ShoppingCartOfShopModel *model=[arr_ firstObject];
        model.cartGoodsDetails=exchang_arr;
        
        [arr_end addObject:model];
    }
    self.selectedShopModelMutArr=arr_end;
    
    //先创建一个没有买家留言的数组
    self.message_arr=[NSMutableArray arrayWithCapacity:0];
    for(int k=0;k<[self.selectedShopModelMutArr count];k++) [self.message_arr addObject:@""];
 
/****************************************************************************************/
/****************************************************************************************/
    
    self.section_address=1;
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kNavigationBarHeight - 60) style:UITableViewStyleGrouped];
    _theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    [self.view addSubview:_theTableView];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight - 64 -60, kMainScreenWidth, 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    UILabel *moneyTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 50, 20)];
    moneyTitleLabel.font=[UIFont systemFontOfSize:13];
    moneyTitleLabel.text = @"合计：";
    _moneyValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, kMainScreenWidth-145, 20)];
    _moneyValueLabel.font=[UIFont systemFontOfSize:18];
    _moneyValueLabel.textAlignment=NSTextAlignmentLeft;
    _moneyValueLabel.textColor = kThemeColor;
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(kMainScreenWidth - 10 - 115, 15, 115, 30);
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.backgroundColor = kThemeColor;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 3;
    [confirmBtn addTarget:self action:@selector(requestConfirmOrderOfGoods) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:moneyTitleLabel];
    [footerView addSubview:_moneyValueLabel];
    [footerView addSubview:confirmBtn];
    
    [self.view addSubview:footerView];
    
    double price = 0.00;
    double shipFeeFloat = 0.00;
    for (ShoppingCartOfShopModel *shopModel in self.selectedShopModelMutArr) {
        for (ShoppingCartOfGoodsModel *goodsModel in shopModel.cartGoodsDetails) {
            price += goodsModel.goodsPrice*goodsModel.goodsCount;
            shipFeeFloat = goodsModel.shipFee;
            if (goodsModel.shipFee > shipFeeFloat) {
                shipFeeFloat = goodsModel.shipFee;
            }

        }
        price += shipFeeFloat;
    }
    
    _moneyValueLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
    self.priceFee =price-shipFeeFloat;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.couponNum>0) {
        return self.selectedShopModelMutArr.count + self.section_address+1;
    }else{
        return self.selectedShopModelMutArr.count + self.section_address;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        NSString *address;
        if([_addressModel.provinceName isEqualToString:_addressModel.cityName]) address=[NSString stringWithFormat:@"%@%@%@",_addressModel.provinceName,_addressModel.areaName,_addressModel.address];
        else address=[NSString stringWithFormat:@"%@%@%@%@",_addressModel.provinceName,_addressModel.cityName,_addressModel.areaName,_addressModel.address];
        CGSize size=[util calHeightForLabel:address width:kMainScreenWidth-100 font:[UIFont systemFontOfSize:15]];
        if(size.height<20) size.height=20;
        
        return 50+size.height;
    } else if (indexPath.section !=self.selectedShopModelMutArr.count + self.section_address) {
    
        if (indexPath.row == 0 || indexPath.row == [[[self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1]cartGoodsDetails]count] + 1) {
            return 44;
        
        } else if (indexPath.row == [[[self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1]cartGoodsDetails]count] + 2 ) {
            return 90;
        
        } else {
            return 120;
        }
    }else{
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if(section !=self.selectedShopModelMutArr.count + self.section_address){
        return [[[self.selectedShopModelMutArr objectAtIndex:section - 1]cartGoodsDetails]count] + 3;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NSString *CellIdentifier1 = [NSString stringWithFormat:@"Cell1%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier2 = [NSString stringWithFormat:@"Cell2%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier3 = [NSString stringWithFormat:@"Cell3%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier4 = [NSString stringWithFormat:@"Cell4%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *CellIdentifier5 = [NSString stringWithFormat:@"Cell5%ld%ld",(long)indexPath.section,(long)indexPath.row];
     NSString *CellIdentifier6 = [NSString stringWithFormat:@"Cell6%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell;
    
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    } else {
        
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        } else if (indexPath.row == [[[self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1]cartGoodsDetails]count] + 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
        } else if (indexPath.row == [[[self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1]cartGoodsDetails]count] + 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier5];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        }
    }
    
    if (cell == nil) {
        
        if (indexPath.section == 0) {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (!_addressModel) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
                
                UILabel *nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 13, 200, 20)];
                nameLabel1.font=[UIFont systemFontOfSize:15];
                nameLabel1.text = @"尚未添加收货地址";
                nameLabel1.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                UILabel *nameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 37, 200, 20)];
                nameLabel2.font=[UIFont systemFontOfSize:15];
                nameLabel2.text = @"立即添加";
                nameLabel2.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                [cell.contentView addSubview:nameLabel1];
                [cell.contentView addSubview:nameLabel2];
            } else {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ConfirmOrderCell1" owner:self options:nil]lastObject];
                UIView *view=(UIView *)[cell viewWithTag:104];
                view.hidden=YES;
                
                NSString *address;
                if([_addressModel.provinceName isEqualToString:_addressModel.cityName]) address=[NSString stringWithFormat:@"%@%@%@",_addressModel.provinceName,_addressModel.areaName,_addressModel.address];
                else address=[NSString stringWithFormat:@"%@%@%@%@",_addressModel.provinceName,_addressModel.cityName,_addressModel.areaName,_addressModel.address];
                CGSize size=[util calHeightForLabel:address width:kMainScreenWidth-100 font:[UIFont systemFontOfSize:15]];
                if(size.height<20) size.height=20;
                UILabel *add_lab=[[UILabel alloc]initWithFrame:CGRectMake(90, 40, kMainScreenWidth-100, size.height)];
                
                add_lab.textColor=[UIColor grayColor];
                add_lab.textAlignment=NSTextAlignmentLeft;
                add_lab.font=[UIFont systemFontOfSize:15];
                add_lab.numberOfLines=0;
                add_lab.text=address;
                add_lab.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                [cell.contentView addSubview:add_lab];

            }

            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if(indexPath.section !=self.selectedShopModelMutArr.count + self.section_address){
            if (indexPath.row == 0) {
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
                
                UIView *row1View = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 20, 44)];
                row1View.tag = 9998;
                row1View.backgroundColor = [UIColor whiteColor];
                
                UIImageView *shopHeadIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 34, 34)];
                shopHeadIV.tag = 1001;
                shopHeadIV.layer.masksToBounds = YES;
                shopHeadIV.layer.cornerRadius = 17;
                
                UILabel *shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(54 + 5, 0, 200, 44)];
                shopNameLabel.tag = 1002;
                
                UIView *lineView = (UIView *)[cell viewWithTag:100000+indexPath.section];
                if(!lineView) lineView = [[UIView alloc]initWithFrame:CGRectMake(10, row1View.frame.size.height, kMainScreenWidth - 20, 0.5)];
                lineView.tag=100000+indexPath.section;
                lineView.backgroundColor=[UIColor colorWithHexString:@"#efeff4" alpha:0.5];
                
                UIButton *cellPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                cellPhoneBtn.frame = CGRectMake(kMainScreenWidth - 20 - 40, 5, 34, 34);
                [cellPhoneBtn setImage:[UIImage imageNamed:@"ic_dianhua.png"] forState:UIControlStateNormal];
                [cellPhoneBtn addTarget: self action:@selector(clickCellPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
                cellPhoneBtn.tag = 1003;
                
                [row1View addSubview:shopHeadIV];
                [row1View addSubview:shopNameLabel];
                [cell addSubview:lineView];
                [row1View addSubview:cellPhoneBtn];
                [cell.contentView addSubview:row1View];
            
            } else if (indexPath.row == [[[self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1]cartGoodsDetails]count] + 2) {
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier4];
                
                UIView *lastRowView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 20, 98)];
                
                UILabel *placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 180, 20)];
                placeholderLabel.tag = 9999;
                placeholderLabel.text = @"给卖家留言：0-100个字";
                placeholderLabel.font = [UIFont systemFontOfSize:11];
                placeholderLabel.textColor = kFontPlacehoderColor;
                
                UITextView *textView=(UITextView *)[lastRowView viewWithTag:KtextviewTag+indexPath.section];
                if(!textView) textView= [[UITextView alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth - 40, 68)];
                textView.layer.masksToBounds = YES;
                textView.tag=KtextviewTag+indexPath.section;
                textView.layer.cornerRadius = 5;
                textView.layer.borderColor = kFontPlacehoderCGColor;
                textView.layer.borderWidth = 0.5;
                textView.delegate = self;
                [textView addSubview:placeholderLabel];
                
                //限制输入字数
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                            name:@"UITextViewTextDidChangeNotification"
                                                          object:textView];
                
                [lastRowView addSubview:textView];

                [cell.contentView addSubview:lastRowView];
            } else if (indexPath.row == [[[self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1]cartGoodsDetails]count] + 1) {
              cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier5];
                UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"OrderOfGoodsView2" owner:self options:nil]lastObject];
                  view.frame = CGRectMake(10, 0, kMainScreenWidth - 20, view.frame.size.height);
                [cell.contentView addSubview:view];
            } else {
                
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
                
                UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"ConfirmOrderOfGoodsView" owner:self options:nil]lastObject];
                view.frame = CGRectMake(0, 0, kMainScreenWidth, 120);

                TextStepperField *stepper = (TextStepperField *)[view viewWithTag:110];
                stepper.textField.delegate = self;
                counter = 1;
                stepper.Step = 1;
                stepper.Minimum = 0;
                stepper.Maximum = 10000;
                stepper.NumDecimals = 0;
                stepper.IsEditableTextField = YES;
                stepper.hidden =YES;
                [stepper addTarget:self
                            action:@selector(programmaticallyCreatedStepperDidStep:)
                  forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:view];
            }
        }else{
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier6];
//            UIImageView *couponlinehead =[[UIImageView alloc] initWithFrame:CGRectMake(15, 0, kMainScreenWidth-30, 1)];
//            couponlinehead.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//            [cell addSubview:couponlinehead];
            
            UIButton *couponbtn =[UIButton buttonWithType:UIButtonTypeCustom];
            couponbtn.frame =CGRectMake(15, 0, kMainScreenWidth-30, 44);
            [couponbtn addTarget:self action:@selector(couponbtn:) forControlEvents:UIControlEventTouchUpInside];
            couponbtn.tag =10001;
            [cell addSubview:couponbtn];
            
            UILabel *couponlbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 13.5, 51, 17)];
            couponlbl.text =@"优惠券";
            couponlbl.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            couponlbl.tag =100;
            [couponbtn addSubview:couponlbl];
            
            NSString *contentstr =[NSString string];
            contentstr =[NSString stringWithFormat:@"可用%d优惠券",self.couponNum];
            double price = 0.00;
            double shipFeeFloat = 0.00;
            for (ShoppingCartOfShopModel *shopModel in self.selectedShopModelMutArr) {
                for (ShoppingCartOfGoodsModel *goodsModel in shopModel.cartGoodsDetails) {
                    price += goodsModel.goodsPrice*goodsModel.goodsCount;
                    shipFeeFloat = goodsModel.shipFee;
                    if (goodsModel.shipFee > shipFeeFloat) {
                        shipFeeFloat = goodsModel.shipFee;
                    }
                    
                }
                price += shipFeeFloat;
            }
            if (self.preferential) {
                if (self.preferential.couponType==0) {
                    if (self.priceFee>[self.preferential.couponValue doubleValue]) {
                        contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %@",self.preferential.couponValue];
                        _moneyValueLabel.text = [NSString stringWithFormat:@"￥%.2f",shipFeeFloat+self.priceFee-[self.preferential.couponValue doubleValue]];
                    }else{
                        contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %.2f",self.priceFee];
                        _moneyValueLabel.text = [NSString stringWithFormat:@"￥%.2f",shipFeeFloat];
                    }
                    
                }else{
                    contentstr =[NSString stringWithFormat:@"抵用1张   优惠￥ %.2f",self.priceFee-self.priceFee*[self.preferential.couponValue doubleValue]/10];
                    _moneyValueLabel.text = [NSString stringWithFormat:@"￥%.2f",shipFeeFloat+self.priceFee*[self.preferential.couponValue doubleValue]/10];
                }
            }
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
            
            
//            UIImageView *couponlinefoot =[[UIImageView alloc] initWithFrame:CGRectMake(15, couponbtn.frame.origin.y+couponbtn.frame.size.height+20, kMainScreenWidth-30, 1)];
//            couponlinefoot.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
//            [cell addSubview:couponlinefoot];
        }
 
    }
    
    if (indexPath.section !=self.selectedShopModelMutArr.count + self.section_address) {
        if (indexPath.section == 0) {
            
            if (!_addressModel) {
                
                UILabel *nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 200, 20)];
                
                nameLabel1.text = @"  尚未添加收货地址";
                UILabel *nameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 50, 200, 20)];
                
                nameLabel2.text = @"  立即添加";
                
            } else {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ConfirmOrderCell1" owner:self options:nil]lastObject];
                UIView *view=(UIView *)[cell viewWithTag:104];
                view.hidden=YES;
                
                UILabel *nameLabel;
                UILabel *cellPhoneLabel;
                
                nameLabel = (UILabel *)[cell viewWithTag:101];
                nameLabel.text = _addressModel.buyerName;
                cellPhoneLabel = (UILabel *)[cell viewWithTag:102];
                cellPhoneLabel.text = _addressModel.buyerPhone;
                
                NSString *address;
                if([_addressModel.provinceName isEqualToString:_addressModel.cityName]) address=[NSString stringWithFormat:@"%@%@%@",_addressModel.provinceName,_addressModel.areaName,_addressModel.address];
                else address=[NSString stringWithFormat:@"%@%@%@%@",_addressModel.provinceName,_addressModel.cityName,_addressModel.areaName,_addressModel.address];
                CGSize size=[util calHeightForLabel:address width:kMainScreenWidth-100 font:[UIFont systemFontOfSize:15]];
                if(size.height<20) size.height=20;
                UILabel *add_lab=[[UILabel alloc]initWithFrame:CGRectMake(90, 40, kMainScreenWidth-100, size.height)];
                
                add_lab.textColor=[UIColor blackColor];
                add_lab.textAlignment=NSTextAlignmentLeft;
                add_lab.font=[UIFont systemFontOfSize:15];
                add_lab.numberOfLines=0;
                add_lab.text=address;
                add_lab.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
                [cell.contentView addSubview:add_lab];
                
            }
            
        } else if (indexPath.row == [[[self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1]cartGoodsDetails]count] + 2) {
            
        } else if (indexPath.row == [[[self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1]cartGoodsDetails]count] + 1) {
            
            ShoppingCartOfShopModel *shopModel = [self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1];
            
            UILabel *numLabel = (UILabel *)[cell viewWithTag:101];
            NSInteger count = 0;
            double moneyTotalFloat = 0.00;
            double shipFeeFloat = 0.0;
            for (ShoppingCartOfGoodsModel *selectedGoodsModel in shopModel.cartGoodsDetails) {
                
                count += selectedGoodsModel.goodsCount;
                moneyTotalFloat += selectedGoodsModel.goodsPrice * selectedGoodsModel.goodsCount;
                shipFeeFloat = selectedGoodsModel.shipFee;
                if (selectedGoodsModel.shipFee > shipFeeFloat) {
                    shipFeeFloat = selectedGoodsModel.shipFee;
                }
            }
            numLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
            UILabel *moneyLabel = (UILabel *)[cell viewWithTag:102];
            moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",moneyTotalFloat];
            UILabel *shipFeeLabel = (UILabel *)[cell viewWithTag:103];
            shipFeeLabel.text = [NSString stringWithFormat:@"￥%.2f",shipFeeFloat];
        } else {
            
            ShoppingCartOfShopModel *shopModel = [self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1];
            
            if (indexPath.row == 0) {
                UIImageView *shopIV = (UIImageView *)[cell viewWithTag:1001];
                NSString *imgUrlStr = shopModel.shopLogoPath;
                [shopIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
                UILabel *shopNameLabel = (UILabel *)[cell viewWithTag:1002];
                shopNameLabel.text = shopModel.shopName;
                
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 43.5, kMainScreenWidth - 40, 0.5)];
                lineView.backgroundColor=[UIColor colorWithHexString:@"#B5B5B8" alpha:0.35];
                [cell addSubview:lineView];
                
            } else if (indexPath.row == [[[self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1]cartGoodsDetails]count] + 1) {
                
            } else {
                ShoppingCartOfGoodsModel *goodsModel = [shopModel.cartGoodsDetails objectAtIndex:indexPath.row-1];
                
                UIImageView *goodsIV = (UIImageView *)[cell viewWithTag:101];
                goodsIV.backgroundColor = kThemeColor;
                NSString *imgUrlStr = goodsModel.goodsUrl;
                [goodsIV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"bg_taotubeijing.png"]];
                UILabel *goodsName = (UILabel *)[cell viewWithTag:102];
                goodsName.text = goodsModel.goodsName;
                
                UILabel *guigeLabel = (UILabel *)[cell viewWithTag:103];
                if([goodsModel.goodsColor length]>=1)
                    guigeLabel.text =[NSString stringWithFormat:@"颜色：%@          规格：%@",goodsModel.goodsColor,goodsModel.goodsModel];
                else
                    guigeLabel.text =[NSString stringWithFormat:@"规格：%@",goodsModel.goodsModel];
                
                UILabel *montyAndAmountLabel = (UILabel *)[cell viewWithTag:104];
                montyAndAmountLabel.text = [NSString stringWithFormat:@"￥%.2f x %ld",goodsModel.goodsPrice,(long)goodsModel.goodsCount];
                TextStepperField *steper = (TextStepperField *)[cell viewWithTag:110];
                steper.Current = goodsModel.goodsCount;
                steper.textField.textColor =[UIColor colorWithHexString:@"#a0a0a0"];
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)couponbtn:(id)sender{
    NSString *goodsIds =[NSString string];
    for (int i=0; i<self.selectedShopModelMutArr.count; i++) {
        ShoppingCartOfShopModel *shopModel = [self.selectedShopModelMutArr objectAtIndex:i];
        for (int j=0; j<shopModel.cartGoodsDetails.count; j++) {
            ShoppingCartOfGoodsModel *goods =[shopModel.cartGoodsDetails objectAtIndex:j];
            if (i==0&&j==0) {
                goodsIds =[NSString stringWithFormat:@"%d",(int)goods.goodsId];
            }else{
                goodsIds =[NSString stringWithFormat:@",%d",(int)goods.goodsId];
            }
        }
    }
    double price = 0.00;
    double shipFeeFloat = 0.00;
    for (ShoppingCartOfShopModel *shopModel in self.selectedShopModelMutArr) {
        for (ShoppingCartOfGoodsModel *goodsModel in shopModel.cartGoodsDetails) {
            price += goodsModel.goodsPrice*goodsModel.goodsCount;
            shipFeeFloat = goodsModel.shipFee;
            if (goodsModel.shipFee > shipFeeFloat) {
                shipFeeFloat = goodsModel.shipFee;
            }
            
        }
        price += shipFeeFloat;
    }
    CouponMainViewController *couponmain =[[CouponMainViewController alloc] init];
    couponmain.contract=nil;
    couponmain.orderCode =nil;
    couponmain.couponNum =self.couponNum;
    couponmain.noCouponNum =self.noCouponNum;
    couponmain.objIds =goodsIds;
    couponmain.orderType =2;
    couponmain.totalFee =[NSString stringWithFormat:@"%.2f",price];
    couponmain.selectDone =^(PreferentialObject *prefrential){
        self.preferential =prefrential;
        [_theTableView reloadData];
    };
    [self.navigationController pushViewController:couponmain animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AddressManageViewController *addressManageVC = [[AddressManageViewController alloc]init];
        addressManageVC.delegate = self;
        addressManageVC.addressIdInteger = _addressModel.ID;
        [self.navigationController pushViewController:addressManageVC animated:YES];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   // [self.view endEditing:YES];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    /*添加点击手势，点击self.view时结束编辑*/
    [self.view addGestureRecognizer:self.tapView];

    return YES;
}

//给UITextView添加placeholder
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    UILabel *placeholderLabel = (UILabel *)[textView viewWithTag:9999];
    
    if (range.location>0 && text.length!=0) {
        placeholderLabel.hidden = YES;
    }else{
        if (range.location==0&&range.length==0) {
            placeholderLabel.hidden =YES;
        }
        if (range.location ==0&&range.length ==1) {
            placeholderLabel.hidden = NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    TextStepperField *stepper = (TextStepperField *)textField.superview;
    UITableViewCell *cell = (UITableViewCell *)stepper.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
    
    ShoppingCartOfShopModel *shopModel = [_selectedShopModelMutArr objectAtIndex:indexPath.section - 1];
    ShoppingCartOfGoodsModel *goodsModel = [shopModel.cartGoodsDetails objectAtIndex:indexPath.row - 1];
    goodsModel.goodsCount = stepper.Current;
    
    
//    for (ShoppingCartOfShopModel *selectedShopModel in _selectedShopModelMutArr) {
//        for (ShoppingCartOfGoodsModel *selectedGoodsModel in selectedShopModel.cartGoodsDetails) {
//            if (selectedGoodsModel.goodsId == goodsModel.goodsId) {
//                
//                selectedGoodsModel.goodsCount = stepper.Current;
//                
//                
//            }
//            
//            
//        }
//    }
    
    
    double price = 0.00;
    double shipFeeFloat = 0.00;
    for (ShoppingCartOfShopModel *selectedShopModel in _selectedShopModelMutArr) {
        for (ShoppingCartOfGoodsModel *selectedGoodsModel in selectedShopModel.cartGoodsDetails) {
            
//            UIButton *selectGoodsBtn = (UIButton *)[cell viewWithTag:106];
//            if (selectGoodsBtn.selected) {
                //                            CGFloat price = [[_moneyValueLabel.text stringByReplacingOccurrencesOfString:@"￥" withString:@""]floatValue];
                
                price += selectedGoodsModel.goodsPrice * selectedGoodsModel.goodsCount;
            shipFeeFloat = selectedGoodsModel.shipFee;
            if (selectedGoodsModel.shipFee > shipFeeFloat) {
                shipFeeFloat = selectedGoodsModel.shipFee;
            }
        }
        price += shipFeeFloat;
            
        
    }
    
    
    _moneyValueLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
    self.priceFee=price-shipFeeFloat;
    
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
        
        ShoppingCartOfShopModel *selectedShopModel = [self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1];
        ShoppingCartOfGoodsModel *selectedGoodsModel = [selectedShopModel.cartGoodsDetails objectAtIndex:indexPath.row - 1];
        
        if (selectedGoodsModel.goodsCount > 1) {
//            double price = [[_moneyValueLabel.text stringByReplacingOccurrencesOfString:@"￥" withString:@""]floatValue];
            double price =self.priceFee;
            for (ShoppingCartOfGoodsModel *goodsModel in selectedShopModel.cartGoodsDetails) {
                price -= goodsModel.goodsPrice*goodsModel.goodsCount;

            }    //总价-改变数量之前的所在店铺的所有商品的总价
            
            selectedGoodsModel.goodsCount -= 1;
            
            for (ShoppingCartOfGoodsModel *goodsModel in selectedShopModel.cartGoodsDetails) {
                price += goodsModel.goodsPrice*goodsModel.goodsCount;
            }   //减去后的总价+改变数量之后的所在店铺的所有商品的总价
            
            _moneyValueLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
            self.priceFee =price;
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
        
        ShoppingCartOfShopModel *selectedShopModel = [self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1];
        ShoppingCartOfGoodsModel *selectedGoodsModel = [selectedShopModel.cartGoodsDetails objectAtIndex:indexPath.row - 1];
        
//        double price = [[_moneyValueLabel.text stringByReplacingOccurrencesOfString:@"￥" withString:@""]floatValue];
        double price =self.priceFee;
        for (ShoppingCartOfGoodsModel *selectedGoodsModel in selectedShopModel.cartGoodsDetails) {
            price -= selectedGoodsModel.goodsPrice*selectedGoodsModel.goodsCount;
        }   //总价-改变数量之前的所在店铺的所有商品的总价
        
        if (selectedGoodsModel.goodsCount >= 1) selectedGoodsModel.goodsCount += 1;  //数量加一

        for (ShoppingCartOfGoodsModel *selectedGoodsModel in selectedShopModel.cartGoodsDetails) {
            price += selectedGoodsModel.goodsPrice*selectedGoodsModel.goodsCount;
        }  //减去后的总价+改变数量之后的所在店铺的所有商品的总价
        
        _moneyValueLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
        self.priceFee =price;
    }

    [_theTableView reloadData];

}

#pragma mark - 确认订单
-(void)requestConfirmOrderOfGoods {
    
    if([self.selectedShopModelMutArr count]==0) {
        [TLToast showWithText:@"暂无可确认的订单信息"];
        return;
    }
    
    if([_requestMutArr count]) [_requestMutArr removeAllObjects];
    
    for (int i=0;i<self.selectedShopModelMutArr.count;i++) {
        ShoppingCartOfShopModel *model=[self.selectedShopModelMutArr objectAtIndex:i];
        NSMutableArray *goodsMutArr = [NSMutableArray arrayWithCapacity:10];
        NSDictionary *dict2=[NSDictionary dictionary];
        
       // UITableViewCell *cell=[_theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[[self.selectedShopModelMutArr objectAtIndex:i]cartGoodsDetails]count] + 2 inSection:i+1]];
       // UITextView *tf=(UITextView *)[cell viewWithTag:KtextviewTag+i+1];
        
        for (ShoppingCartOfGoodsModel *goodsModel in model.cartGoodsDetails) {
            dict2 = @{@"goodsColor":goodsModel.goodsColor,@"goodsCount":@(goodsModel.goodsCount),@"goodsId":@(goodsModel.goodsId),@"goodsModel":goodsModel.goodsModel,@"goodsName":goodsModel.goodsName,@"goodsPrice":@(goodsModel.goodsPrice),@"goodsUrl":goodsModel.goodsUrl,@"orderDetailId":@(goodsModel.orderDetailId),@"shipFee":@(goodsModel.shipFee),@"shopId":@(goodsModel.shopId),@"cartId":@(goodsModel.cartId)};
            [goodsMutArr addObject:dict2];
        }
        
        NSDictionary *dict = @{@"buyerid":@(model.buyerid),@"shopId":@(model.shopId),@"shopLogoPath":model.shopLogoPath,@"shopName":model.shopName,@"message":[self.message_arr objectAtIndex:i],@"cartGoodsDetails":goodsMutArr};
        [_requestMutArr addObject:dict];
    }
    
    NSString *wantAddressStr;
    if (_addressModel) {
        wantAddressStr = [NSString stringWithFormat:@"%ld",(long)_addressModel.ID];
    }
    if (!wantAddressStr) {
        [TLToast showWithText:@"请选择地址"];
        return ;
    }

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
        [postDict setObject:@"ID0218" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        NSString *string=[postDict JSONString];
        
        NSString *jsonArr = [self arrayToJson:_requestMutArr];
        NSDictionary *bodyDic = @{@"addressId":wantAddressStr,@"orderInfo":jsonArr,@"sucId":[NSNumber numberWithInt:self.preferential.sucId]};
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
                 NSLog(@"确认返回信息：%@",jsonDict);
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
                    
                    if (kResCode == 102181) {
                        [self stopRequest];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *resDic = [jsonDict objectForKey:@"shopOrder"];
                            _confirmOrderOfGoodsModel = [ConfirmOrderOfGoodsModel objectWithKeyValues:resDic];
                            [self gotoPayingConfirmPage:_confirmOrderOfGoodsModel];
                        
                            //确认订单成功后清除数据刷新本页面
                            if([_requestMutArr count])[_requestMutArr removeAllObjects];
                            if([self.selectedShopModelMutArr count])[self.selectedShopModelMutArr removeAllObjects];
                            _moneyValueLabel.text = @"￥0.00";
                            self.priceFee =0;
                            self.section_address=0;
                            [_theTableView reloadData];
                            
                            //确认订单成功后通知购物车请求刷新
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"goumaiSucceed" object:nil];
                        });
                    } else if (kResCode == 102184) {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"库存不足";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"库存不足"];
                       
                    } else  {
                        [self stopRequest];
                        customPromp =[[CustomPromptView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
                        customPromp.contenttxt =@"确认失败";
                        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction:)];
                        [customPromp addGestureRecognizer:tap];
                        [customPromp show];
//                        [TLToast showWithText:@"确认失败"];
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
-(void)hideAction:(id)sender{
    [customPromp dismiss];
}
//请求商品订单默认地址
-(void)requestGoodsOrderAddress {
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
        NSString *goodsIds =[NSString string];
        for (int i=0; i<self.selectedShopModelMutArr.count; i++) {
            ShoppingCartOfShopModel *shopModel = [self.selectedShopModelMutArr objectAtIndex:i];
            for (int j=0; j<shopModel.cartGoodsDetails.count; j++) {
                ShoppingCartOfGoodsModel *goods =[shopModel.cartGoodsDetails objectAtIndex:j];
                if (i==0&&j==0) {
                    goodsIds =[NSString stringWithFormat:@"%d",(int)goods.goodsId];
                }else{
                    goodsIds =[NSString stringWithFormat:@",%d",(int)goods.goodsId];
                }
            }
        }
        double price = 0.00;
        double shipFeeFloat = 0.00;
        for (ShoppingCartOfShopModel *shopModel in self.selectedShopModelMutArr) {
            for (ShoppingCartOfGoodsModel *goodsModel in shopModel.cartGoodsDetails) {
                price += goodsModel.goodsPrice*goodsModel.goodsCount;
                shipFeeFloat = goodsModel.shipFee;
                if (goodsModel.shipFee > shipFeeFloat) {
                    shipFeeFloat = goodsModel.shipFee;
                }
                
            }
            price += shipFeeFloat;
        }
//        ShoppingCartOfShopModel *shopModel = [self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1];
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0223\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"goodsIds\":\"%@\",\"goodsTotalMoneys\":\"%.2f\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],goodsIds,price];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"获取默认收货地址返回信息：%@",jsonDict);
                
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
                
                
                if (code==102231) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        NSDictionary *resDic=[jsonDict objectForKey:@"enableAddressInfo"];
                        self.couponNum =[[jsonDict objectForKey:@"couponNum"] intValue];
                        self.noCouponNum =[[jsonDict objectForKey:@"noCouponNum"] intValue];
                        if (resDic.count) {
                            _addressModel = [AddressManageModel objectWithKeyValues:resDic];
                            [_theTableView reloadData];
                        } else {
                            
                        }
                        
                    });
                }
                else if (code==10379) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [self stopRequest];
                    });
                }

            });
            
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                              });
                          }
                               method:url postDict:nil];
    });
    
}

- (void)addressDidSelect:(AddressManageModel *)addressManageModel {
    _addressModel = addressManageModel;
    [_theTableView reloadData];
}

#pragma mark - 字典转json
- (NSString *)dictionaryToJson:(NSDictionary *)dictionary
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark 数组转json
- (NSString *)arrayToJson:(NSArray *)array
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - KeyBord

- (void)keyboardWillShow:(NSNotification *)notif {
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat kbSize = rect.size.height;
    //MJLog(@"willShow---键盘高度：%f",kbSize);
    
    [UIView animateWithDuration:duration animations:^{
        _theTableView.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-kNavigationBarHeight-kbSize);
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    //CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //CGFloat kbSize = rect.size.height;
    //MJLog(@"willHide---键盘高度：%f",kbSize);
    
    [UIView animateWithDuration:duration animations:^{
        _theTableView.frame=CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-kNavigationBarHeight-60);
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

#pragma mark - UIGestureRecognizer
-(void)tapViewEndEditing:(UIGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    UITableViewCell *cell;
    [self.view removeGestureRecognizer:self.tapView];
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)textView.superview.superview.superview;
    else
        cell= (UITableViewCell *)textView.superview.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
    NSString *message=[NSString stringWithFormat:@"%@ ",textView.text];
    if(indexPath.section>=1) [self.message_arr replaceObjectAtIndex:indexPath.section - 1 withObject:message];
}

- (void)clickCellPhoneBtn:(UIButton *)btn {
    UITableViewCell *cell;
    if(IS_iOS8>=8)
        cell= (UITableViewCell *)btn.superview.superview.superview;
    else
        cell= (UITableViewCell *)btn.superview.superview.superview.superview;
    NSIndexPath *indexPath = [_theTableView indexPathForCell:cell];
    
    if(indexPath.section>=1){
        ShoppingCartOfShopModel *shopModel = [self.selectedShopModelMutArr objectAtIndex:indexPath.section - 1];
        NSString *callNumStr = [NSString stringWithFormat:@"tel://%@",shopModel.shopMobile];
        UIWebView *callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callNumStr]]];
        [self.view addSubview:callWebview];
    }
}

- (void)gotoPayingConfirmPage:(id)sender {
    if (_confirmOrderOfGoodsModel.totalMoney==0) {
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
            url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0091\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={\"orderCode\":\"%@\"}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"],_confirmOrderOfGoodsModel.orderCode];
            
            NetworkRequest *req = [[NetworkRequest alloc] init];
            req.isCacheRequest=YES;
            [req setHttpMethod:GetMethod];
            
            [req sendToServerInBackground:^{
                dispatch_async(parsingQueue, ^{
                    ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                    [request setResponseEncoding:NSUTF8StringEncoding];
                    NSString *respString = [request responseString];
                    NSDictionary *jsonDict = [respString objectFromJSONString];
                    NSLog(@"为0支付返回信息：%@",jsonDict);
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
                    if (code==100911) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            [TLToast showWithText:@"订单确认成功"];
                        });
                    }
                    else if (code==100919) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            [TLToast showWithText:@"订单确认失败"];
                        });
                    }
                });
            }
                              failedBlock:^{
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self stopRequest];
                                      [TLToast showWithText:@"托管失败"];
                                  });
                              }
                                   method:url postDict:nil];
        });
    }else{
//        [savelogObj saveLog:@"立即托管" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:61];
//        
//        NSMutableString *orderid=[NSMutableString string];
//        for(NSString *sting in _confirmOrderOfGoodsModel.orderIds){
//            [orderid appendFormat:@"%@,",sting];
//        }
//        PayingConfirmViewController *payingConfirmVC = [[PayingConfirmViewController alloc]init];
//        payingConfirmVC.typeStr = @"商城";
//        payingConfirmVC.serviceNameStr=orderid;
//        payingConfirmVC.moneyFloat = _confirmOrderOfGoodsModel.totalMoney;
//        payingConfirmVC.orderNo = _confirmOrderOfGoodsModel.orderCode;
//        payingConfirmVC.amounts =[NSString stringWithFormat:@"%@",_confirmOrderOfGoodsModel.amounts];
//        [self.navigationController pushViewController:payingConfirmVC animated:YES];
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
                            LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                            login.delegate=self;
                            [login show];
                        });
                    }
                    if (code==102731) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopRequest];
                            NSMutableString *orderid=[NSMutableString string];
                            for(NSString *sting in _confirmOrderOfGoodsModel.orderIds){
                                [orderid appendFormat:@"%@,",sting];
                            }
                            if ([[jsonDict objectForKey:@"walletAssets"] doubleValue]<=0&&[[jsonDict objectForKey:@"decorationLoanAssets"] doubleValue]<=0) {
                                OnlinePayViewController *onlinepay =[[OnlinePayViewController alloc] init];
                                onlinepay.serviceNameStr =[NSString stringWithFormat:@"%@,",orderid];
                                onlinepay.remaining =_confirmOrderOfGoodsModel.totalMoney;

                                onlinepay.typeStr =@"商城";
                                onlinepay.orderNo =_confirmOrderOfGoodsModel.orderCode;
//                                onlinepay.fromStr=@"orderDetailOfGoodsVC";
                                onlinepay.amounts =[NSString stringWithFormat:@"%.2f",_confirmOrderOfGoodsModel.totalMoney];
                                [self.navigationController pushViewController:onlinepay animated:YES];
                            }else{
                                PayingConfirmViewController *payingConfirmVC = [[PayingConfirmViewController alloc]init];
//                                payingConfirmVC.fromStr = @"orderDetailOfGoodsVC";
                                payingConfirmVC.typeStr = @"商城";
                                payingConfirmVC.serviceNameStr=[NSString stringWithFormat:@"%@,",orderid];
                                payingConfirmVC.moneyFloat = _confirmOrderOfGoodsModel.totalMoney;

                                payingConfirmVC.orderNo = _confirmOrderOfGoodsModel.orderCode;
                                payingConfirmVC.amounts =[NSString stringWithFormat:@"%.2f",_confirmOrderOfGoodsModel.totalMoney];
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

- (void)backButtonPressed:(id)sender {
    if ([self.fromStr isEqualToString:@"jsBridge"])
        [self dismissViewControllerAnimated:YES completion:nil];
    else
       [self.navigationController popViewControllerAnimated:YES];
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextView *textView = (UITextView *)obj.object;
    
    if (textView.text.length > 100) {
        [TLToast showWithText:@"留言不能超过100字"];
    }

    
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 100) {
                textView.text = [toBeString substringToIndex:100];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 100) {
            textView.text = [toBeString substringToIndex:100];
        }
    }
}


@end
