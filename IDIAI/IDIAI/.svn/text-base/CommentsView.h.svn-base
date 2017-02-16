//
//  CommentsView.h
//  IDIAI
//
//  Created by iMac on 14-12-23.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentsViewDelegate <NSObject>
-(void)didFinishedComments:(NSString *)comment_title star:(NSInteger)star_int;
@end

@interface CommentsView : UIView<UITextViewDelegate>
{
    UIControl *control;
}

@property (nonatomic, weak) id<CommentsViewDelegate>delegate;
@property (nonatomic, strong) UITextView *textf;
@property (nonatomic, strong) UIButton *btn_tj;
@property (nonatomic, strong) UIButton *btn_qx;
@property (nonatomic, strong) UILabel *lab_tx;
@property (nonatomic, assign) NSInteger numberStart;
@property (nonatomic, strong) UIView *startView;
@property (nonatomic, strong) NSMutableArray *imageViewArray;

- (id)initWithFrame:(CGRect)frame;
- (void)show;
-(void)dismiss;

@end
