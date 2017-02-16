//
//  PersonalinformationVC.h
//  IDIAI
//
//  Created by iMac on 14-7-3.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LoginVC.h"
#import "LoginView.h"

@interface PersonalinformationVC : UIViewController<UITableViewDataSource,UITableViewDelegate,LoginViewDelegate>
{
    UITableView *mtableview;
}
@property (nonatomic,strong)  UILabel *lab_name;
@property (nonatomic,strong)  UILabel *lab_address;
@property (nonatomic,strong)   UIImageView *photo;

@end
