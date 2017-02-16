//
//  DecorateViewController.m
//  UTOP
//
//  Created by iMac on 14-11-21.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "DecorateViewController.h"

#import "TPKeyboardAvoidingTableView.h"
#import "HRCoreAnimationEffect.h"
#import "DistrictView.h"
#import "util.h"
#import "NSStringAdditions.h"
#import "DecorationInfoViewController.h"
#import "TLToast.h"
#import "IDIAIAppDelegate.h"
#import "AutomaticLogin.h"
#import "CustomProvinceCApicker.h"
#import "LoginView.h"
#import "savelogObj.h"

#define kPRBGColor [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:.7]

@interface DecorateViewController ()<CustomProvinceCApickerDelegate,UITextFieldDelegate,LoginViewDelegate> {
    TPKeyboardAvoidingTableView *_theTableView;
    UIButton *_styleBtn1;//装修风格按钮1
    UIButton *_styleBtn2;//装修风格按钮2
    UIButton *_styleBtn3;//装修风格按钮3
    UILabel *_districtLabel;
    UITextField *_nameTF;
    UITextField *_areaTF;
    UITextField *_budgetTF;
    UILabel *_areaUnitLabel;
    UILabel *_moneyUnitLabel;
    UIView *_barView;
    UIView *_msgHintView;//消息提醒视图
    
    UIView *footerView;
}

@end

@implementation DecorateViewController

- (void)customizeNavigationBar {
    [[[self navigationController] navigationBar] setHidden:NO];
    
    UILabel *lab_nav_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 25)];
    lab_nav_title.font=[UIFont systemFontOfSize:19];
    lab_nav_title.textAlignment=NSTextAlignmentCenter;
    lab_nav_title.backgroundColor=[UIColor clearColor];
    lab_nav_title.textColor=[UIColor blackColor];
    lab_nav_title.text=@"我要装修";
    self.navigationItem.titleView = lab_nav_title;
    
    [self.theBackButton setImage:[UIImage imageNamed:@"ic_fh_2.png"] forState:UIControlStateNormal];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self requestNumberForDistibution];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [savelogObj saveLog:@"进入装修招标" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:37];
    
    [self customizeNavigationBar];
    //导航栏颜色
//    self.navigationController.navigationBar.barTintColor = kThemeColor;
    
    CGRect rect = CGRectMake(130, 0, kMainScreenWidth - 170, 44);
    //区域
    _districtLabel = [[UILabel alloc]initWithFrame:rect];
    _districtLabel.textAlignment = NSTextAlignmentRight;
    _districtLabel.font = [UIFont systemFontOfSize:16];
   
    //小区名称
    _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, kMainScreenWidth - 140, 44)];
    _nameTF.font = [UIFont systemFontOfSize:16];
    _nameTF.placeholder=@"请输入小区名称";
    _nameTF.textColor=[UIColor darkTextColor];
    _nameTF.textAlignment = NSTextAlignmentRight;
    
    //面积
    _areaTF = [[UITextField alloc]initWithFrame:rect];
    _areaTF.placeholder = @"请输入面积";
    _areaTF.textAlignment = NSTextAlignmentRight;
    _areaTF.keyboardType = UIKeyboardTypeNumberPad;
     _areaTF.font = [UIFont systemFontOfSize:16];
    //预算
    _budgetTF = [[UITextField alloc]initWithFrame:rect];
    _budgetTF.placeholder = @"请输入金额";
    _budgetTF.textAlignment = NSTextAlignmentRight;
    _budgetTF.keyboardType = UIKeyboardTypeNumberPad;
    _budgetTF.delegate = self;
     _budgetTF.font = [UIFont systemFontOfSize:16];

    //面积单位
    _areaUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(rect.size.width + 140, 6, 30, 30)];
    _areaUnitLabel.text = @"m²";
     _areaUnitLabel.font = [UIFont systemFontOfSize:16];
    //金额单位
    _moneyUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(rect.size.width + 140, 6, 30, 30)];
    _moneyUnitLabel.text = @"万";
     _moneyUnitLabel.font = [UIFont systemFontOfSize:16];
    
    _theTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
    _theTableView.dataSource = self;
    _theTableView.delegate = self;
    _theTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_theTableView];
    
    //footerView
    footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 300)];
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    publishBtn.layer.cornerRadius = 3;
    publishBtn.frame = CGRectMake(10, 50, kMainScreenWidth - 10 * 2, 40);
    publishBtn.backgroundColor = kThemeColor;
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(clickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:publishBtn];
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    infoBtn.frame = CGRectMake(10, 150, kMainScreenWidth - 10 * 2, 20);
    infoBtn.tag=10;
    [infoBtn setTitle:@"已发布的装修信息 >" forState:UIControlStateNormal];
    [infoBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(clickInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:infoBtn];
    
    _theTableView.tableFooterView = footerView;
    
    //省市区数据
    //获取省市区id
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceCode] length]>1) self.provinceCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceCode];
    else self.provinceCode=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_CityCode] length]>1) self.cityCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_CityCode];
    else self.cityCode=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaCode] length]>1) self.areaCode=[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaCode];
    else self.areaCode=@"";
    //获取省市区名字
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceName] length]>0) self.provinceName=[[NSUserDefaults standardUserDefaults] objectForKey:User_ProvinceName];
    else self.provinceName=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_CityName] length]>0) self.cityName=[[NSUserDefaults standardUserDefaults] objectForKey:User_CityName];
    else self.cityName=@"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaName] length]>0) self.areaName=[[NSUserDefaults standardUserDefaults] objectForKey:User_AreaName];
    else self.areaName=@"";
    
    if(!arr_Province) arr_Province=[NSMutableArray arrayWithObjects:@[self.provinceName,self.provinceCode],@[self.cityName,self.cityCode],@[self.areaName,self.areaCode],nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSArray *cellNameArr = @[@"区       域：",@"小区名称：",@"面       积：",@"预       算："];
    
    if([self.provinceName length]>=1){
        if([self.provinceName isEqualToString:self.cityName]){
            _districtLabel.text = [NSString stringWithFormat:@"%@%@",self.provinceName,self.areaName];
            _districtLabel.textColor=[UIColor darkTextColor];
        }
        else{
            _districtLabel.text = [NSString stringWithFormat:@"%@%@%@",self.provinceName,self.cityName,self.areaName];
            _districtLabel.textColor =  [UIColor darkTextColor];
        }
    }
    else{
        _districtLabel.text = @"请选择区域";
        _districtLabel.textColor = kFontPlacehoderColor;
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray *cellViewArr = @[_districtLabel,_nameTF,_areaTF,_budgetTF];
    if (indexPath.row != 4) {
        cell.textLabel.text = [cellNameArr objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:[cellViewArr objectAtIndex:indexPath.row]];
    }
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:User_Village] length]>=1) {
        _nameTF.text =[[NSUserDefaults standardUserDefaults]objectForKey:User_Village];
        _nameTF.textColor = [UIColor darkTextColor];
    } else {
        _nameTF.placeholder =@"请输入小区名称";
    }
    
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 2) {
        [cell.contentView addSubview:_areaUnitLabel];
    } else if (indexPath.row == 3) {
        [cell.contentView addSubview:_moneyUnitLabel];
    } else if (indexPath.row == 4) {
        NSArray *nameArray = @[@"经济实用",@"中档装修",@"高档装修"];
        //装修风格按钮
        
//        static dispatch_once_t onceToken;
        
//        dispatch_once(&onceToken, ^{
        
            
                _styleBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                _styleBtn1.layer.masksToBounds = YES;
                _styleBtn1.layer.borderColor = kFontPlacehoderCGColor;
                _styleBtn1.layer.borderWidth = 1;
                _styleBtn1.layer.cornerRadius = 15;
                
                CGFloat btnWidth = (kMainScreenWidth - 40)/3;
                _styleBtn1.frame = CGRectMake(10 + (10 +btnWidth) * 0, 5, btnWidth, cell.bounds.size.height - 10);
                [_styleBtn1 setTitle:[nameArray objectAtIndex:0] forState:UIControlStateNormal];
                [_styleBtn1 setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
                _styleBtn1.titleLabel.font = [UIFont systemFontOfSize:16];
                [_styleBtn1 addTarget:self action:@selector(clickStyleBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            _styleBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            _styleBtn2.layer.masksToBounds = YES;
            _styleBtn2.layer.borderColor = kFontPlacehoderCGColor;
            _styleBtn2.layer.borderWidth = 1;
            _styleBtn2.layer.cornerRadius = 15;
            

            _styleBtn2.frame = CGRectMake(10 + (10 +btnWidth) * 1, 5, btnWidth, cell.bounds.size.height - 10);
            [_styleBtn2 setTitle:[nameArray objectAtIndex:1] forState:UIControlStateNormal];
            [_styleBtn2 setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
            _styleBtn2.titleLabel.font = [UIFont systemFontOfSize:16];
            [_styleBtn2 addTarget:self action:@selector(clickStyleBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            _styleBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            _styleBtn3.layer.masksToBounds = YES;
            _styleBtn3.layer.borderColor = kFontPlacehoderCGColor;
            _styleBtn3.layer.borderWidth = 1;
            _styleBtn3.layer.cornerRadius = 15;
            
            _styleBtn3.frame = CGRectMake(10 + (10 +btnWidth) * 2, 5, btnWidth, cell.bounds.size.height - 10);
            [_styleBtn3 setTitle:[nameArray objectAtIndex:2] forState:UIControlStateNormal];
            [_styleBtn3 setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
            _styleBtn3.titleLabel.font = [UIFont systemFontOfSize:16];
            [_styleBtn3 addTarget:self action:@selector(clickStyleBtn:) forControlEvents:UIControlEventTouchUpInside];
            
                    _styleBtn1.selected = YES;
                    _styleBtn1.backgroundColor = kThemeColor;
                    _styleBtn1.layer.borderColor = [UIColor clearColor].CGColor;
                    [_styleBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
                
            [cell.contentView addSubview:_styleBtn1];
            [cell.contentView addSubview:_styleBtn2];
            [cell.contentView addSubview:_styleBtn3];
            
//        });
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0){
        [self.view endEditing:YES];
        CustomProvinceCApicker *picker_pro = [[CustomProvinceCApicker alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 250)title:@"选择省市区"];
        picker_pro.delegate=self;
        [picker_pro setSelectedTitles:arr_Province animated:YES];
        [picker_pro show];
    }
}

- (void)clickStyleBtn:(UIButton *)styleBtn {
    if ([styleBtn isEqual:_styleBtn1]) {
        styleBtn.selected = YES;
        styleBtn.backgroundColor = kThemeColor;
        styleBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [styleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _styleBtn2.selected = NO;
        _styleBtn2.backgroundColor = [UIColor whiteColor];
                _styleBtn2.layer.borderColor = kFontPlacehoderCGColor;
        [_styleBtn2 setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
        _styleBtn3.selected = NO;
        _styleBtn3.backgroundColor = [UIColor whiteColor];
                        _styleBtn3.layer.borderColor = kFontPlacehoderCGColor;
        [_styleBtn3 setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
    } else if ([styleBtn isEqual:_styleBtn2]) {
        styleBtn.selected = YES;
        styleBtn.backgroundColor = kThemeColor;
        styleBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [styleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _styleBtn1.selected = NO;
        _styleBtn1.backgroundColor = [UIColor whiteColor];
                        _styleBtn1.layer.borderColor = kFontPlacehoderCGColor;
        [_styleBtn1 setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
        _styleBtn3.selected = NO;
        _styleBtn3.backgroundColor = [UIColor whiteColor];
                        _styleBtn3.layer.borderColor = kFontPlacehoderCGColor;
        [_styleBtn3 setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
    } else {
        styleBtn.selected = YES;
        styleBtn.backgroundColor = kThemeColor;
        styleBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [styleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _styleBtn1.selected = NO;
        _styleBtn1.backgroundColor = [UIColor whiteColor];
                        _styleBtn1.layer.borderColor = kFontPlacehoderCGColor;
        [_styleBtn1 setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
        _styleBtn2.selected = NO;
        _styleBtn2.backgroundColor = [UIColor whiteColor];
                        _styleBtn2.layer.borderColor = kFontPlacehoderCGColor;
        [_styleBtn2 setTitleColor:kFontPlacehoderColor forState:UIControlStateNormal];
        
    }
}

- (void)clickPublishBtn:(id)sender {
    if ([_districtLabel.text isEqualToString:@"请选择区域"] || [NSString isEmptyOrWhitespace:_districtLabel.text]) {
        [self flashMessage:@"请选择区域"];
            return;
    } else if ([NSString isEmptyOrWhitespace:_nameTF.text]) {
        [self flashMessage:@"请输入小区名称"];
            return;
    }   else if (_nameTF.text.length > 30 &&_nameTF.text.length<2) {
        [self flashMessage:@"请填写2～30字的小区名称"];
        return;
    } else if ([NSString isEmptyOrWhitespace:_areaTF.text]) {
        [self flashMessage:@"请输入面积"];
            return;
    } else if ([_areaTF.text floatValue] > 10000) {
        [self flashMessage:@"面积不能超过10000m²"];
        return;
    } else if ([NSString isEmptyOrWhitespace:_budgetTF.text]) {
        [self flashMessage:@"请输入金额"];
            return;
    } else if ([_budgetTF.text floatValue] > 10000) {
        [self flashMessage:@"预算金额不能超过10000万元"];
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
        [postDict setObject:@"ID0044" forKey:@"cmdID"];
        [postDict setObject:string_token forKey:@"token"];
        [postDict setObject:string_userid forKey:@"userID"];
        [postDict setObject:@"iOS" forKey:@"deviceType"];
        [postDict setObject:kCityCode forKey:@"cityCode"];
        
        NSString *string=[postDict JSONString];
        
        NSInteger styleInteger = 0;
        if (_styleBtn1.selected) {
                styleInteger = 0;
            
        } else if (_styleBtn2.selected) {
                styleInteger = 1;
            
        } else if (_styleBtn3.selected) {
                styleInteger = 2;
        }
        
        NSString *levelStr = [NSString stringWithFormat:@"%ld",(long)styleInteger];
        
        NSDictionary *bodyDic = @{
                            @"communityName":_nameTF.text,
                            @"renovationSquare":_areaTF.text,
                            @"renovationBudget":_budgetTF.text,
                            @"renovationLevel": levelStr,
                            @"provinceCode":self.provinceCode ,
                            @"cityCode": self.cityCode,
                            @"areaCode": self.areaCode,
                        };
        NSString *string02=[bodyDic JSONString];
        NSMutableDictionary *post= [[NSMutableDictionary alloc] init];
        [post setObject:string forKey:@"header"];
        [post setObject:string02 forKey:@"body"];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        [req setHttpMethod:PostMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"login返回信息：%@",jsonDict);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopRequest];
                    //token为空或验证未通过处理 huangrun
                    if (kResCode == 10002 || kResCode == 10003) {
                        LoginView *login=[[LoginView alloc]initWithFrame:CGRectMake(30, (kMainScreenHeight-150)/2, kMainScreenWidth-60, 150)leftButtonTitle:@"登录" rightButtonTitle:@"注册" display:1 dismiss:2];
                        login.delegate=self;
                        [login show];
                        return;
                    }

                    
                    if (kResCode == 10441) {
                        [savelogObj saveLog:@"发布装修招标" userID:[NSString stringWithFormat:@"%ld ",(long)[[[NSUserDefaults standardUserDefaults] objectForKey:User_ID] integerValue]] modelType:38];
                        
                        [self stopRequest];
                        [TLToast showWithText:@"发布成功"];
                        //保存装修地址
//                        [[NSUserDefaults standardUserDefaults]setObject:@(_indexPath.row) forKey:kUDDecorationDistrictOfRow];
//                        [[NSUserDefaults standardUserDefaults]setObject:_nameTF.text forKey:kUDDecorationAddress];
//                        [[NSUserDefaults standardUserDefaults]synchronize];

                        DecorationInfoViewController *decorationInfoVC = [[DecorationInfoViewController alloc]init];
                        decorationInfoVC.hidesBottomBarWhenPushed = YES;
                        decorationInfoVC.fromType=@"MyZhaoBiao";
                        [self.navigationController pushViewController:decorationInfoVC animated:YES];
                        
                        return;
                    }
                    
                    [TLToast showWithText:@"发布失败"];
                    return;
                });
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self stopRequest];
                                  [TLToast showWithText:@"发布失败"];
                              });
                          }
                               method:url postDict:post];
    });
}

- (void)clickInfoBtn:(id)sender {
    DecorationInfoViewController *decorationInfoVC = [[DecorationInfoViewController alloc]init];
    decorationInfoVC.hidesBottomBarWhenPushed = YES;
    decorationInfoVC.fromType=@"AllZhaoBiao";
    [self.navigationController pushViewController:decorationInfoVC animated:YES];
}

#pragma mark -
#pragma mark -PickerViewDelegate

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
    
    _districtLabel.text=province_name;
    _districtLabel.textColor=[UIColor darkTextColor];
}

#pragma mark - 错误提示弹出条

- (void)flashMessage:(NSString *)msg{
    //Show message
    
    if (_msgHintView) {
        return;
    }
    
    __block CGRect rect = CGRectMake(0, _theTableView.contentOffset.y + 64 + 45, self.view.bounds.size.width, 30);
    UILabel *msgLabel;
    if (_msgHintView == nil) {
        _msgHintView = [[UIView alloc]init];
        _msgHintView.frame = rect;
        _msgHintView.backgroundColor = kPRBGColor;
        
        msgLabel = [[UILabel alloc]init];
        msgLabel.frame = CGRectMake(30, 0, self.view.bounds.size.width - 20, 30);
        msgLabel.font = [UIFont systemFontOfSize:14.f];
        msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        msgLabel.textAlignment = NSTextAlignmentLeft;
        msgLabel.textColor = kThemeColor;
        [_msgHintView addSubview:msgLabel];
        
        UIImageView *hintIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        hintIV.image = [UIImage imageNamed:@"ic_tx"];
        [_msgHintView addSubview:hintIV];
        
        [self.view addSubview:_msgHintView];
        
    }
    msgLabel.text = msg;
    
    rect.origin.y += 20;
    [UIView animateWithDuration:.4f animations:^{
        _msgHintView.frame = rect;
    } completion:^(BOOL finished){
        rect.origin.y -= 20;
        [UIView animateWithDuration:.4f delay:0.8f options:UIViewAnimationOptionCurveLinear animations:^{
            _msgHintView.frame = rect;
        } completion:^(BOOL finished){
            [_msgHintView removeFromSuperview];
            _msgHintView = nil;
        }];
    }];
    
}

//请求发布信息条数
-(void)requestNumberForDistibution{
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
        
        NSString *url=[NSString stringWithFormat:@"%@/dispatch/dispatch.action?header={\"cmdID\":\"ID0048\",\"deviceType\":\"ios\",\"token\":\"%@\",\"userID\":\"%@\",\"cityCode\":\"%@\"}&body={}",kDefaultUpdateVersionServerURL,string_token,string_userid,kCityCode];
        
        NetworkRequest *req = [[NetworkRequest alloc] init];
        req.isCacheRequest=YES;
        [req setHttpMethod:GetMethod];
        
        [req sendToServerInBackground:^{
            dispatch_async(parsingQueue, ^{
                ASIHTTPRequest *request = [[req getCurrentRequests] objectAtIndex:0];
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *respString = [request responseString];
                NSDictionary *jsonDict = [respString objectFromJSONString];
                NSLog(@"发布条数：返回信息：%@",jsonDict);
                NSInteger code=[[jsonDict objectForKey:@"resCode"] integerValue];
                if (code==10481) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIButton *btn=(UIButton *)[footerView viewWithTag:10];
                        [btn setTitle:[NSString stringWithFormat:@"已发布%@条装修信息 >",[jsonDict objectForKey:@"renovationCount"]] forState:UIControlStateNormal];
                    });
                }
                else if (code==10489) {
                    dispatch_async(dispatch_get_main_queue(), ^{

                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                
                    });
                }
            });
        }
                          failedBlock:^{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  //                                  imageview_bg.hidden=NO;
                              });
                          }
                               method:url postDict:nil];
    });
    
}

//UITextField 限制用户输入小数点后位数的方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag=0;
    const NSInteger limited = 1;
    for (int i = futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                return NO;
            }
            
            break;
        }
        flag++;
    }
    
    return YES;
}

#pragma mark -
#pragma mark - LoginDelegate
//-(void)logged:(NSDictionary *)dict{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

-(void)LoginViewDelegateClickedAtIndex:(NSInteger)buttonIndex inputInfo:(NSDictionary *)infoDict {
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
