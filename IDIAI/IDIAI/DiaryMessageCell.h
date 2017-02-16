//
//  DiaryMessageCell.h
//  IDIAI
//
//  Created by Ricky on 15/11/23.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryDetailObject.h"
@protocol DiaryMessageCellDelegate <NSObject>
-(void)touchPraise;
-(void)touchMessageComment;
-(void)touchHead:(DiaryDetailObject *)detail;
@end
@interface DiaryMessageCell : UITableViewCell
@property(nonatomic,strong)DiaryDetailObject *detail;
@property(nonatomic,weak)id<DiaryMessageCellDelegate>delegate;
-(CGFloat)getCellHeight;
@end
