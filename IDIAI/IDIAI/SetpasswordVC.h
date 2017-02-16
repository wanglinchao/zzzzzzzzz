//
//  SetpasswordVC.h
//  IDIAI
//
//  Created by iMac on 14-7-1.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetpasswordVC : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic)  UITextField *Textfield_first;
@property (strong, nonatomic)  UITextField *Textfield_second;
@property (strong, nonatomic) NSString *pwd_Number;
@property (strong, nonatomic) NSString *Req_typepwd;

@end
