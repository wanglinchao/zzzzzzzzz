//
//  AddressManageViewController.m
//  IDIAI
//
//  Created by Ricky on 15/5/6.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "AddressManageViewController.h"
#import "EditAddressViewController.h"
#import "AddressManagerCell.h"
#import "LoginView.h"
#import "TLToast.h"
#import "util.h"

@interface AddressManageViewController () <UITableViewDataSource, UITableViewDelegate,EditAddressDelegate,LoginViewDelegate> {
    UITableView *_theTableView;
    NSMutableArray *_addressModelMutArr;
    AddressManageModel *_addressModel;
}

@end

@implementation AddressManageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self requestAddressList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    if ([self.fromStr isEqualToString:@"myInfoVC"]) {
        self.title = @"地址管理";
    }else{
        self.title = @"选择收货地址";
    }
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    [self.view addSubview:_theTableView];
    
    _theTableView.tableFooterView = [[UIView alloc]init];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(10, kMainScreenHeight -64- 60, kMainScreenWidth - 20, 60)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 10, kMainScreenWidth - 20, 40);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    btn.backgroundColor = kThemeColor;
    [btn setTitle:@"新增地址" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickAddAddress:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    [self.view addSubview:footerView];
    
    [self loadImageviewBG];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressModelMutArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height=10;
    AddressManageModel *addressModel = [_addressModelMutArr objectAtIndex:indexPath.row];
    NSString *address;
    if([addressModel.provinceName isEqualToString:addressModel.cityName]) address=[NSString stringWithFormat:@"%@%@%@",addressModel.provinceName,addressModel.areaName,addressModel.address];
    else address=[NSString stringWithFormat:@"%@%@%@%@",addressModel.provinceName,addressModel.cityName,addressModel.areaName,addressModel.address];
    CGSize size=[util calHeightForLabel:address width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:15]];
    height+=size.height+10;
    height+=50;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddressManagerCell" owner:self options:nil]lastObject];
    }

    AddressManageModel *addressModel = [_addressModelMutArr objectAtIndex:indexPath.row];
    
    float height=10;
    NSString *address;
    if([addressModel.provinceName isEqualToString:addressModel.cityName]) address=[NSString stringWithFormat:@"%@%@%@",addressModel.provinceName,addressModel.areaName,addressModel.address];
    else address=[NSString stringWithFormat:@"%@%@%@%@",addressModel.provinceName,addressModel.cityName,addressModel.areaName,addressModel.address];
    CGSize size=[util calHeightForLabel:address width:kMainScreenWidth-120 font:[UIFont systemFontOfSize:15]];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, height, kMainScreenWidth-150, 20)];
    nameLabel.textColor=[UIColor darkGrayColor];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.font=[UIFont systemFontOfSize:17];
    nameLabel.text=[NSString stringWithFormat:@"收货人：%@",addressModel.buyerName];
    [cell addSubview:nameLabel];
    
    UILabel *cellPhoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-130, height, 120, 20)];
    cellPhoneLabel.textColor=[UIColor darkGrayColor];
    cellPhoneLabel.textAlignment=NSTextAlignmentLeft;
    cellPhoneLabel.font=[UIFont systemFontOfSize:17];
    cellPhoneLabel.text=[NSString stringWithFormat:@"%@",addressModel.buyerPhone];
    [cell addSubview:cellPhoneLabel];
    
    height+=25;
    
    UILabel *addressLabelTitle=[[UILabel alloc]initWithFrame:CGRectMake(30, height, 80, 20)];
    addressLabelTitle.textColor=[UIColor darkGrayColor];
    addressLabelTitle.textAlignment=NSTextAlignmentLeft;
    addressLabelTitle.font=[UIFont systemFontOfSize:15];
    addressLabelTitle.text=@"收货地址：";
    [cell addSubview:addressLabelTitle];
    
    UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(105, height+2, kMainScreenWidth-115, size.height)];
    addressLabel.textColor=[UIColor darkGrayColor];
    addressLabel.textAlignment=NSTextAlignmentLeft;
    addressLabel.font=[UIFont systemFontOfSize:15];
    addressLabel.numberOfLines=0;
    addressLabel.text=address;
    [cell addSubview:addressLabel];
    
    height+=size.height+7;
    
    UILabel *postcodeLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, height, kMainScreenWidth-30, 20)];
    postcodeLabel.textColor=[UIColor darkGrayColor];
    postcodeLabel.textAlignment=NSTextAlignmentLeft;
    postcodeLabel.font=[UIFont systemFontOfSize:15];
    postcodeLabel.text=[NSString stringWithFormat:@"邮政编码:  %@",addressModel.zipCode];
    [cell addSubview:postcodeLabel];
    
    height+=25;
    
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(0, (height-60)/2, 30, 60);
    selectBtn.tag = 1000+indexPath.row;
    [selectBtn setImage:[UIImage imageNamed:@"ic_xuanze_nor.png"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"ic_xuanze.png"] forState:UIControlStateSelected];
    selectBtn.backgroundColor=[UIColor clearColor];
    [selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:selectBtn];
    if ([self.fromStr isEqualToString:@"myInfoVC"]){
        selectBtn.userInteractionEnabled =NO;
    }
    if (addressModel.defaultFlag) {
        selectBtn.selected = YES;
    }
    
/*
    if ([self.fromStr isEqualToString:@"myInfoVC"]) {
        selectBtn.hidden = YES;
    }
*/
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EditAddressViewController *editAddressVC = [[EditAddressViewController alloc]init];
    AddressManageModel *addressModel = [_addressModelMutArr objectAtIndex:indexPath.row];
    editAddressVC.nameStr = addressModel.buyerName;
    editAddressVC.cellphoneStr = addressModel.buyerPhone;
    editAddressVC.postcodeStr = addressModel.zipCode;
    editAddressVC.provinceCodeStr = addressModel.provinceCode;
    editAddressVC.cityCodeStr = addressModel.cityCode;
    editAddressVC.areaCodeStr = addressModel.areaCode;
    editAddressVC.provinceStr = addressModel.provinceName;
    editAddressVC.cityStr = addressModel.cityName;
    editAddressVC.areaStr = addressModel.areaName;
    editAddressVC.addressStr = addressModel.address;
    
    editAddressVC.actionStr = @"modify";
    editAddressVC.addressIDInteger = addressModel.ID;
    [self.navigationController pushViewController:editAddressVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressManageModel *addressModel = [_addressModelMutArr objectAtIndex:indexPath.row];
    [self requestDeleteAddress:addressModel];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)clickAddAddress:(UIButton *)btn {
    EditAddressViewController *editAddressVC = [[EditAddressViewController alloc]init];
    editAddressVC.delegate = self;
    [self.navigationController pushViewController:editAddressVC animated:YES];
}


//请求地址列表
-(void)requestAddressList{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0219\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,[[[NSUserDefaults standardUserDefaults] objectForKey:cityCodeKey] objectForKey:@"cityCode"]];
        
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
                if (code==102191) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                         NSArray *arr_address=[jsonDict objectForKey:@"shopOrderAddressList"];
                        if (arr_address.count) {
                            _addressModelMutArr = [NSMutableArray arrayWithArray:[AddressManageModel objectArrayWithKeyValuesArray:arr_address]];
                            
                            for (AddressManageModel *model in _addressModelMutArr) {
                                if (model.ID == self.addressIdInteger) {
                                    model.defaultFlag = YES;
                                }
                            }

                            
                            imageview_bg.hidden=YES;
                            label_bg.hidden = YES;
                            [_theTableView reloadData];
                        } else {
                            imageview_bg.hidden=NO;
                            label_bg.hidden = NO;
                        }
                        
                    });
                }
                else if (code==10379) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self stopRequest];
                        imageview_bg.hidden=NO;
                        label_bg.hidden = NO;
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

//请求删除地址
-(void)requestDeleteAddress:(AddressManageModel *)addressModel {
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
        [postDict setObject:@"ID0222" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"addressId":[NSString stringWithFormat:@"%ld",(long)addressModel.ID]};
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
                    
                    if (kResCode == 102221) {
                        [self stopRequest];
                        [_addressModelMutArr removeObject:addressModel];
                        [_theTableView reloadData];
                        [TLToast showWithText:@"删除成功"];
                    } else {
                        [self stopRequest];
                        [TLToast showWithText:@"删除失败"];
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

- (void)clickSelectBtn:(UIButton *)btn {
 
    for (AddressManageModel *model2 in _addressModelMutArr) {
        model2.defaultFlag = NO;
    }
    
    AddressManageModel *model = [_addressModelMutArr objectAtIndex:btn.tag-1000];
    
    model.defaultFlag = YES;
    
    [_theTableView reloadData];
    
    for (AddressManageModel *model in _addressModelMutArr) {
        if (model.defaultFlag) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(addressDidSelect:)]) {
                [self.delegate addressDidSelect:model];
            }
        }
        else {
            continue;
        }
    }
    if(![self.fromStr isEqualToString:@"myInfoVC"]) [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonPressed:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(addressDidSelect:)]) {
//        [self.delegate addressDidSelect:_addressModel];
//        [self.navigationController popViewControllerAnimated:YES];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }

    for (AddressManageModel *model in _addressModelMutArr) {
        if (model.defaultFlag) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(addressDidSelect:)]) {
                        [self.delegate addressDidSelect:model];
            }
        }
        else {
            continue;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addressEditSuccess {
    if (_addressModelMutArr.count>0) {
        AddressManageModel *model = [_addressModelMutArr objectAtIndex:0];
        model.defaultFlag = YES;
    }
    [_theTableView reloadData];
}

@end
