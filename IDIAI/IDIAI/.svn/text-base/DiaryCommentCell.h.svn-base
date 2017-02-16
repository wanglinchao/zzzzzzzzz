//
//  DiaryCommentCell.h
//  IDIAI
//
//  Created by Ricky on 15/11/24.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryCommentObject.h"
@protocol DiaryCommentCellDelegate <NSObject>
-(void)touchReplay:(DiaryReplyCommentObject *)object Row:(NSInteger)row;
-(void)touchComment:(DiaryCommentObject *)object Row:(NSInteger)row;
-(void)touchCommentHead:(DiaryCommentObject *)object;
-(void)touchnickName:(DiaryReplyCommentObject *)object;
-(void)touchtonickName:(DiaryReplyCommentObject *)object;
@end
@interface DiaryCommentCell : UITableViewCell
@property(nonatomic,strong)DiaryCommentObject *commentobject;
@property(nonatomic,assign)NSInteger row;
@property (nonatomic, weak) id<DiaryCommentCellDelegate>delegate;
-(CGFloat)getCellHeight;
@end
