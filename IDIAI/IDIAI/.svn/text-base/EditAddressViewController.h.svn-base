//
//  EditAddressViewController.h
//  IDIAI
//
//  Created by Ricky on 15/5/6.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "AddressManageModel.h"

@protocol EditAddressDelegate <NSObject>

- (void)addressEditSuccess;

@end

@interface EditAddressViewController : GeneralWithBackBtnViewController

@property (copy, nonatomic) NSString *nameStr;
@property (copy, nonatomic) NSString *cellphoneStr;
@property (copy, nonatomic) NSString *postcodeStr;
@property (copy, nonatomic) NSString *provinceCodeStr;
@property (copy, nonatomic) NSString *cityCodeStr;
@property (copy, nonatomic) NSString *areaCodeStr;
@property (copy, nonatomic) NSString *provinceStr;
@property (copy, nonatomic) NSString *cityStr;
@property (copy, nonatomic) NSString *areaStr;
@property (copy, nonatomic) NSString *addressStr;

@property (copy, nonatomic) NSString *actionStr;
@property (assign, nonatomic) NSInteger addressIDInteger;
@property (assign, nonatomic) id <EditAddressDelegate> delegate;

@end
