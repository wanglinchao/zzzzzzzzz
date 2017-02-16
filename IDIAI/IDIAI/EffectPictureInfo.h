//
//  EffectPictureInfo.h
//  IDIAI
//
//  Created by iMac on 14-7-29.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyeffectPictureObj.h"
@class EffectPictureInfo;

@protocol EffectPicInfoDelegate <NSObject>

- (void)picDidCollect:(EffectPictureInfo *)effectPicInfo collectNum:(NSInteger)collectNum cell:(UITableViewCell *)cell;

@end

@interface EffectPictureInfo : ACBaseViewController

@property (nonatomic,strong) MyeffectPictureObj *obj_effect;
@property (assign, nonatomic) NSInteger collectionNum;
@property (strong, nonatomic) UITableViewCell *cell;
@property (assign, nonatomic) NSInteger browseNumInteger;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *img_;

@property (assign, nonatomic) id <EffectPicInfoDelegate> delegate;
typedef void (^SelectBlock)(MyeffectPictureObj *pic_obj);
@property (nonatomic, copy) SelectBlock selectDone;
@end
