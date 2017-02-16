//
//  VerificationCodeViewController.h
//  UTopGD
//
//  Created by Ricky on 15/9/19.
//  Copyright (c) 2015年 yangfan. All rights reserved.
//
////3.6.6已废弃  byzhangliang
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface VerificationCodeViewController : GeneralViewController{
    MBProgressHUD *phud;
}
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userMobile;
@property(nonatomic,strong)NSString *userpassWord;
@property(nonatomic,strong)NSString *provinceCode;
@property(nonatomic,strong)NSString *cityCode;
@property(nonatomic,strong)NSString *areaCode;
@property(nonatomic,strong)NSString *serviceType;
@property(assign, nonatomic)int type;
@end
