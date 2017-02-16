//
//  CommentOfGoodsViewController.h
//  IDIAI
//
//  Created by Ricky on 15/5/27.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SWAddPhotoView.h"
#import "QBImagePickerController.h"
@interface CommentOfGoodsViewController : GeneralWithBackBtnViewController<QBImagePickerControllerDelegate,SWAddPhotoViewDelegate>

@property (nonatomic, assign) NSInteger numberStart;
@property (nonatomic, strong) UIView *startView;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (weak, nonatomic) IBOutlet UIImageView *goodsIV;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentComtentTV;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)clickSubmitBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *theScrollView;

@property (copy, nonatomic) NSString *orderIdStr;
@property (copy, nonatomic) NSString *shopOrderDetailStr;
@property (copy, nonatomic) NSString *shopGoodsDetailIdStr;
@property (copy, nonatomic) NSString *shopIdStr;

@property (strong, nonatomic) NSDictionary *goodsInfoDic;
@property(nonatomic,strong)SWAddPhotoView *addPhotoView;
@end
