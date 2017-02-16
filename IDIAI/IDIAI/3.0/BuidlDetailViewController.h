//
//  BuidlDetailViewController.h
//  UTopGD
//
//  Created by Ricky on 15/9/19.
//  Copyright (c) 2015年 yangfan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralViewController.h"
#import "GeneralWithBackBtnViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface BuidlDetailViewController : GeneralWithBackBtnViewController
@property(nonatomic,strong)NSString *foremanSitesId;
@property(nonatomic,strong)NSString *calNum;
@end
