//
//  PersonaldataVC.h
//  IDIAI
//
//  Created by iMac on 14-7-14.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraAndPhotosView.h"

@interface PersonaldataVC : UIViewController<UITableViewDataSource,UITableViewDelegate,CameraAndPhotosViewDelegate>
{
    UITableView *mtableview;
}
@property (nonatomic,strong)  UILabel *lab_address;
@property (nonatomic,strong) NSMutableArray *dataArray_first;
@property (nonatomic,strong) NSMutableArray *dataArray_second;
@property (nonatomic,strong) UIButton *photoButton;
@property (nonatomic,strong) NSMutableArray *Array_personal;
@property (nonatomic,strong) NSString *sex_selected;

@end
