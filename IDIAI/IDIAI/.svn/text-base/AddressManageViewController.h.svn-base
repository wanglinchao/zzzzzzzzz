//
//  AddressManageViewController.h
//  IDIAI
//
//  Created by Ricky on 15/5/6.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "AddressManageModel.h"

@protocol ManageAddressVCDelegate <NSObject>

- (void)addressDidSelect:(AddressManageModel *)addressManageModel;

@end

@interface AddressManageViewController : GeneralWithBackBtnViewController

@property (copy, nonatomic) NSString *fromStr;
@property (assign, nonatomic) id <ManageAddressVCDelegate> delegate;
@property (assign, nonatomic) NSInteger addressIdInteger;

@end
