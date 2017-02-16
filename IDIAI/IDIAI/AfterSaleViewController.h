//
//  AfterSaleViewController.h
//  IDIAI
//
//  Created by Ricky on 15-1-26.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface AfterSaleViewController : GeneralWithBackBtnViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *reasonTV;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn1;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn2;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn3;
- (IBAction)clickImgBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
- (IBAction)clickApplyBtn:(id)sender;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *theScrollView;

@property (copy, nonatomic) NSString *orderIDStr;
@property (copy, nonatomic) NSString *serviceProviderIdStr;

@property (nonatomic, retain) UIImage *photo1;
@property (nonatomic, retain) UIImage *photo2;
@property (nonatomic, retain) UIImage *photo3;

@property (strong, nonatomic) UILabel *uilabel;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
