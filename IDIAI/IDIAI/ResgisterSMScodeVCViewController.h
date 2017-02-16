//
//  ResgisterSMScodeVCViewController.h
//  IDIAI
//
//  Created by iMac on 14-7-3.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol registerVCDelegate <NSObject>


@end

@interface ResgisterSMScodeVCViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic)  UILabel *descriptitlee;
@property (strong, nonatomic)  UITextField *Textfield_input;
@property (strong, nonatomic) UIButton *Next_btn;

@property (strong, nonatomic) NSString *resgi_Number;
@property (strong, nonatomic) NSString *Req_type;
@property (copy, nonatomic) NSString *previousVCName;


@end
