//
//  RefundOfApplyGoodsViewController.h
//  IDIAI
//
//  Created by iMac on 15-8-10.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface RefundOfApplyGoodsViewController : GeneralWithBackBtnViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (retain, nonatomic)  UITextView *reasonTV;
@property (retain, nonatomic)  UITextField *moneyTF;
@property (retain, nonatomic)  UIView *TFView;
@property (retain, nonatomic)  UIButton *imgBtn1;
@property (retain, nonatomic)  UIButton *imgBtn2;
@property (retain, nonatomic)  UIButton *imgBtn3;
@property (retain, nonatomic)  UIButton *applyRefundBtn;
@property (retain, nonatomic)  TPKeyboardAvoidingScrollView *theScrollView;
@property (retain, nonatomic)  UIButton *typeBtn1;
@property (retain, nonatomic)  UIButton *typeBtn2;

@property (nonatomic, retain) UIImage *photo1;
@property (nonatomic, retain) UIImage *photo2;
@property (nonatomic, retain) UIImage *photo3;

@property (copy, nonatomic) NSString *sourceVCStr;

@property (strong, nonatomic) UILabel *uilabel;

@property (copy, nonatomic) NSString *orderIdStr;
@property (copy, nonatomic) NSString *shopOrderDetailStr;
@property (copy, nonatomic) NSString *shopGoodsDetailIdStr;
@property (copy, nonatomic) NSString *shopIdStr;

@property (copy, nonatomic) NSString *goodsTotalMoneyStr;
@property (nonatomic,copy) NSString *goodsName;
@end
