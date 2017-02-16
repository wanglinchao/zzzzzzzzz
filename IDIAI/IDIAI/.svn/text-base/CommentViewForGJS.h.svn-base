//
//  CommentViewForGJS.h
//  IDIAI
//
//  Created by iMac on 15/10/26.
//  Copyright © 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentsViewDelegate <NSObject>
-(void)didFinishedComments:(NSString *)comment_title star:(NSArray *)star_arr;
@end

@interface CommentViewForGJS : UIView<UITextViewDelegate>
{
    UIControl *control;
}

@property (nonatomic, weak) id<CommentsViewDelegate>delegate;
@property (nonatomic, strong) UIButton *btn_tj;
@property (nonatomic, strong) UIButton *btn_qx;

@property (nonatomic, strong) UITextView *textf;

@property (nonatomic, assign) NSInteger numberStart;
@property (nonatomic, strong) UIView *startView;
@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property (nonatomic, assign) NSInteger numberStart_two;
@property (nonatomic, strong) UIView *startView_two;
@property (nonatomic, strong) NSMutableArray *imageViewArray_two;

@property (nonatomic, assign) NSInteger numberStart_three;
@property (nonatomic, strong) UIView *startView_three;
@property (nonatomic, strong) NSMutableArray *imageViewArray_three;

- (id)initWithFrame:(CGRect)frame title:(NSArray *)title_arr;
- (void)show;
-(void)dismiss;

@end
