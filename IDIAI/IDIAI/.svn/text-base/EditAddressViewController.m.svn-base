//
//  EditAddressViewController.m
//  IDIAI
//
//  Created by Ricky on 15/5/6.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "EditAddressViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "CustomProvinceCApicker.h"
#import "NSStringAdditions.h"
#import "TLToast.h"
#import "util.h"
#import "LoginView.h"

@interface EditAddressViewController () <UITableViewDataSource, UITableViewDelegate,CustomProvinceCApickerDelegate> {
    UITableView *_theTableView;
    UITextField *_usernameTF;
    UITextField *_cellphoneTF;
    UITextField *_postcodeTF;
    UILabel *_areaTitleLabel;
    UIButton *_areaBtn;
    UITextField *_detailAddressTF;
    NSMutableArray *arr_Province; //省市区数组
}

@property (nonatomic,strong) NSString *provinceCode;
@property (nonatomic,strong) NSString *cityCode;
@property (nonatomic,strong) NSString *areaCode;

@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑收货地址";
    _theTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 60) style:UITableViewStyleGrouped];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    [self.view addSubview:_theTableView];
    
    _usernameTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 135, 44)];
    _usernameTF.placeholder = @"请输入姓名";
    _cellphoneTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 135, 44)];
    _cellphoneTF.placeholder = @"请输入联系人电话";
    _cellphoneTF.keyboardType = UIKeyboardTypePhonePad;
    _postcodeTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 135, 44)];
    _postcodeTF.placeholder = @"请输入邮政编码";
    _postcodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _areaTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 90, 44)];
    _areaTitleLabel.font = [UIFont systemFontOfSize:17];
    _areaTitleLabel.text = @"所在地区:";
    _areaBtn = [[UIButton alloc]initWithFrame:CGRectMake(110, 0, kMainScreenWidth - 110, 44)];
    [_areaBtn setTitle:@"请选择区域" forState:UIControlStateNormal];
    _areaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _areaBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [_areaBtn setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
    [_areaBtn addTarget:self action:@selector(clickAreaBtn:) forControlEvents:UIControlEventTouchUpInside];
    _detailAddressTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 135, 44)];
    _detailAddressTF.placeholder = @"请输入详细地址";
    
    if ([self.actionStr isEqualToString:@"modify"]) {
        if (self.nameStr) {
            _usernameTF.text = self.nameStr;
        }
        if (self.cellphoneStr) {
            _cellphoneTF.text = self.cellphoneStr;
        }
        if (self.postcodeStr) {
            _postcodeTF.text = self.postcodeStr;
        }
        if (self.areaStr) {
            if([self.provinceStr isEqualToString:self.cityStr])
                [_areaBtn setTitle:[NSString stringWithFormat:@"%@%@",self.provinceStr,self.areaStr] forState:UIControlStateNormal];
            else
                [_areaBtn setTitle:[NSString stringWithFormat:@"%@%@%@",self.provinceStr,self.cityStr,self.areaStr] forState:UIControlStateNormal];
            [_areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        if (self.provinceCodeStr) {
            self.provinceCode = self.provinceCodeStr;
        }
        
        if (self.cityCodeStr) {
            self.cityCode = self.cityCodeStr;
        }
        
        if (self.areaCodeStr) {
            self.areaCode = self.areaCodeStr;
        }
        
        if (self.addressStr) {
            _detailAddressTF.text = self.addressStr;
        }

        if(!arr_Province) arr_Province=[NSMutableArray arrayWithObjects:@[self.provinceStr,self.provinceCode],@[self.cityStr,self.cityCode],@[self.areaStr,self.areaCode],nil];
    }
    
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(10, kMainScreenHeight - 60, kMainScreenWidth - 20, 60)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 10, kMainScreenWidth - 20, 40);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    btn.backgroundColor = kThemeColor;
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([self.actionStr isEqualToString:@"modify"])
        [btn addTarget:self action:@selector(requestModifyAddress) forControlEvents:UIControlEventTouchUpInside];
    else
    [btn addTarget:self action:@selector(requestAddAddress) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    [self.view addSubview:footerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"收货人姓名:";
            cell.accessoryView = _usernameTF;
        } else {
            cell.textLabel.text = @"联系电话:";
            cell.accessoryView = _cellphoneTF;
        }
            
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"邮政编码:";
            cell.accessoryView = _postcodeTF;
        } else if (indexPath.row == 1) {
            [cell.contentView addSubview:_areaTitleLabel];
            [cell.contentView addSubview:_areaBtn];
        } else {
            cell.textLabel.text = @"详细地址:";
            cell.accessoryView = _detailAddressTF;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)actionSheetProvinceCAPickerView:(CustomProvinceCApicker *)pickerView didSelectTitles:(NSArray *)titles{
    
    NSMutableString *province_name=[NSMutableString string];
    if([arr_Province count]) [arr_Province removeAllObjects];
    for(int i=0;i<[titles count];i++){
        NSArray *arr=[titles objectAtIndex:i];
        [arr_Province addObject:arr];
        
        if(i==1 && [@"上海市北京市天津市重庆市" rangeOfString:[arr objectAtIndex:0]].length>0)[province_name appendFormat:@"%@",@""]; //获取省市区名字
        else [province_name appendFormat:@"%@",[arr objectAtIndex:0]]; //获取省市区名字
        
        //获取省市区code码
        if(i==0) self.provinceCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
        else if(i==1) self.cityCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
        else if(i==2) self.areaCode=[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
    }
    
    //台湾、澳门、香港没有市区
    if([titles count]==1){
        self.cityCode=@"";
        self.areaCode=@"";
    }
    
    [_areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_areaBtn setTitle:province_name forState:UIControlStateNormal];
}

- (void)clickAreaBtn:(UIButton *)btn {
    
    [self.view endEditing:YES];
    CustomProvinceCApicker *picker_pro = [[CustomProvinceCApicker alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250)title:@"选择省市区"];
    picker_pro.delegate=self;
    [picker_pro setSelectedTitles:arr_Province animated:YES];
    [picker_pro show];
    
}

#pragma mark - 增加地址
-(void)requestAddAddress {
    
    if ([NSString isEmptyOrWhitespace:_usernameTF.text]) {
        [TLToast showWithText:@"请输入姓名"];
        return;
    } else if (_usernameTF.text.length < 2 || _usernameTF.text.length > 4) {
        [TLToast showWithText:@"请填写2～4字的收货人姓名"];
        return;
    } else if ([NSString isEmptyOrWhitespace:_cellphoneTF.text]) {
        [TLToast showWithText:@"请输入联系人电话"];
        return;
    } else if (![util checkTel:_cellphoneTF.text]) {
        return;
    } else if ([NSString isEmptyOrWhitespace:_postcodeTF.text]) {
        [TLToast showWithText:@"请输入邮政编码"];
        return;
    } else if (_postcodeTF.text.length != 6) {
        [TLToast showWithText:@"请输入6位邮政编码"];
        return;
    } else if ([_areaBtn.titleLabel.text isEqualToString:@"请选择区域"]) {
        [TLToast showWithText:@"请选择区域"];
        return;
    } else if ([NSString isEmptyOrWhitespace:_detailAddressTF.text]) {
        [TLToast showWithText:@"请输入详细地址"];
        return;
    } else if (_detailAddressTF.text.length < 4 || _detailAddressTF.text.length > 40) {
        [TLToast showWithText:@"请填写4～40字的收货地址"];
        return;
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
        [postDict setObject:@"ID0220" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        
       // NSString *wantAddressStr = [_areaBtn.titleLabel.text stringByAppendingString:_detailAddressTF.text];
         NSString *wantAddressStr =_detailAddressTF.text;
        
        NSDictionary *bodyDic = @{@"buyerName":_usernameTF.text,@"buyerPhone":_cellphoneTF.text,@"postCode":_postcodeTF.text,@"provice":self.provinceCode,@"city":self.cityCode,@"area":self.areaCode,@"buyerAddress":wantAddressStr};
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
                 NSLog(@"添加地址返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        [self stopRequest];
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 102201) {
                        [self stopRequest];
                  
                        if (self.delegate && [self.delegate respondsToSelector:@selector(addressEditSuccess)]) {
                            [self.delegate addressEditSuccess];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [self stopRequest];
                        [TLToast showWithText:@"添加失败"];
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

#pragma mark - 修改地址
-(void)requestModifyAddress {
    
    if ([NSString isEmptyOrWhitespace:_usernameTF.text]) {
        [TLToast showWithText:@"请输入姓名"];
        return;
    } else if (_usernameTF.text.length < 2 || _usernameTF.text.length > 4) {
        [TLToast showWithText:@"请输入正确的姓名(2-4个字符)"];
        return;
    } else if ([NSString isEmptyOrWhitespace:_cellphoneTF.text]) {
        [TLToast showWithText:@"请输入联系人电话"];
        return;
    } else if (![util checkTel:_cellphoneTF.text]) {
        return;
    } else if ([NSString isEmptyOrWhitespace:_postcodeTF.text]) {
        [TLToast showWithText:@"请输入邮政编码"];
        return;
    } else if (_postcodeTF.text.length != 6) {
        [TLToast showWithText:@"请输入6位邮政编码"];
        return;
    } else if ([_areaBtn.titleLabel.text isEqualToString:@"请选择区域"]) {
        [TLToast showWithText:@"请选择区域"];
        return;
    } else if ([NSString isEmptyOrWhitespace:_detailAddressTF.text]) {
        [TLToast showWithText:@"请输入详细地址"];
        return;
    } else if (_detailAddressTF.text.length < 4 || _detailAddressTF.text.length > 40) {
        [TLToast showWithText:@"请输入正确的地址(4-40个字符)"];
        return;
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
        [postDict setObject:@"ID0221" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"ios" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        NSDictionary *bodyDic = @{@"buyerName":_usernameTF.text,@"buyerPhone":_cellphoneTF.text,@"postCode":_postcodeTF.text,@"provice":self.provinceCode,@"city":self.cityCode,@"area":self.areaCode,@"buyerAddress":_detailAddressTF.text,@"addressId":[NSString stringWithFormat:@"%ld",(long)self.addressIDInteger]};
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
                        [login show];
                        return;
                    }
                    
                    if (kResCode == 102211) {
                        [self stopRequest];
                        [TLToast showWithText:@"修改成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [self stopRequest];
                        [TLToast showWithText:@"修改失败"];
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

@end
