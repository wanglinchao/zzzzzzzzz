//
//  EffectTAOTUPictureInfo.h
//  IDIAI
//
//  Created by iMac on 15-3-5.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyeffectPictureObj.h"

@interface EffectTAOTUPictureInfo : GeneralViewController<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *data_array;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottom_bg;
@property (nonatomic, strong) UILabel *xiaoquName;
@property (nonatomic, strong) UILabel *descName;

@property (nonatomic, strong) UILabel *doorModel_Area_price;

@property (nonatomic,strong) MyeffectPictureObj *obj_pic;
@property(nonatomic,assign) NSInteger taotuID;
@property (strong, nonatomic) UIImageView *imageView;
//@property (assign, nonatomic) NSInteger type_into;
@property (nonatomic,assign) BOOL ishome;
typedef void (^SelectBlock)(MyeffectPictureObj *pic_obj);
@property (nonatomic, copy) SelectBlock selectDone;
@end
