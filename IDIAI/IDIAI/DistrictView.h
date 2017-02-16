//
//  DistrictView.h
//  IDIAI
//
//  Created by Ricky on 14-11-26.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VCName) {
    VCNameEffectyPic,
    VCNameMyCollection
};

@interface DistrictView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *theDataArr;

@property (strong, nonatomic) NSIndexPath *theIndexPath_one;//记录选中的行列
@property (strong, nonatomic) NSIndexPath *theIndexPath_two;//记录选中的行列
@property (strong, nonatomic) NSIndexPath *theIndexPath_three;//记录选中的行列

@property (assign, nonatomic) VCName vCName;

@end
