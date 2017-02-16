//
//  PayingConfirmViewController.h
//  IDIAI
//
//  Created by Ricky on 15-1-27.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"


@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;


@end

@interface PayingConfirmViewController : GeneralWithBackBtnViewController

@property (copy, nonatomic) NSString *serviceNameStr;
@property (assign, nonatomic) double moneyFloat;
@property (copy, nonatomic) NSString *orderNo;
@property (nonatomic,strong)NSString *amounts;

@property (copy, nonatomic) NSString *typeStr;
@property (copy, nonatomic) NSString *fromStr;
@property (nonatomic,strong) NSString *fromController;
@property (nonatomic,assign) BOOL isRecharge;
@end
