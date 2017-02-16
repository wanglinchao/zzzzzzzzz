//
//  CollectPictureCell.h
//  IDIAI
//
//  Created by iMac on 14-8-13.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "TMQuiltViewCell.h"
#import "TMQuiltViewCell.h"

@interface CollectPictureCell : TMQuiltViewCell
@property (nonatomic, retain) UIImageView *bottom_bg;
@property (nonatomic, retain) UIImageView *photoView;
@property (nonatomic, retain) UIImageView *image_collect;
@property (nonatomic, retain) UIImageView *image_love;
@property (nonatomic, retain) UILabel *lab_love;
@property (nonatomic, assign) NSInteger indexID;

@property (nonatomic, retain) UIImageView *collectIV;
@property (nonatomic, retain) UILabel *collectNumLabel;

@property (nonatomic, retain) UIImageView *browseNumIV;
@property (strong, nonatomic) UILabel *browseNumLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index_id;
@end
