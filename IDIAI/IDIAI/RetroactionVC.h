//
//  RetroactionVC.h
//  IDIAI
//
//  Created by iMac on 14-7-15.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralWithBackBtnViewController.h"

@interface RetroactionVC : GeneralWithBackBtnViewController


@property (weak, nonatomic) IBOutlet UITextView *textview_input;
@property (weak, nonatomic) IBOutlet UITextField *textfield_input;

@property (nonatomic, strong) IBOutlet UIButton *btn_tj;
@property (nonatomic, assign) NSInteger index;
- (IBAction)clickCallBtn:(id)sender;

@end
