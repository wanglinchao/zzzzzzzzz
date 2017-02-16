//
//  CaseShowPicViewController.h
//  IDIAI
//
//  Created by iMac on 16/4/7.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralViewController.h"
#import "MyeffectPictureObj.h"

@interface CaseShowPicViewController : GeneralViewController<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *data_array;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger  pic_id;
@property (nonatomic,strong) MyeffectPictureObj *obj_effect;

@end
