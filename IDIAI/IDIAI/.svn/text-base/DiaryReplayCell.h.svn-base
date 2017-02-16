//
//  DiaryReplayCell.h
//  IDIAI
//
//  Created by Ricky on 15/11/25.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryReplyObject.h"
@protocol DiaryReplayCellDelegate <NSObject>
-(void)touchHead:(DiaryReplyObject *)object;
@end
@interface DiaryReplayCell : UITableViewCell
@property(nonatomic,strong)DiaryReplyObject *reply;
@property (nonatomic, weak) id<DiaryReplayCellDelegate>delegate;
-(CGFloat)getCellHeight;
@end
