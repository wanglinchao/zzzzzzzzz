//
//  DiaryPhotosCell.h
//  IDIAI
//
//  Created by Ricky on 15/11/24.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DiaryPhotosCellDelegate <NSObject>
-(void)touchPhotos:(NSMutableArray *)photos index:(NSInteger)index view:(UIImageView *)imageView;
-(void)reloadCell;
@end
@interface DiaryPhotosCell : UITableViewCell
@property(nonatomic,strong)NSMutableArray *pics;
@property(nonatomic,weak)id<DiaryPhotosCellDelegate>delegate;
@property(nonatomic,assign)float countheight;
-(CGFloat)getCellHeight;
@end
