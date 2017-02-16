//
//  JTScrollLabelView.h
//  PlayVideoDemo
//
//  Created by iMac on 16/2/17.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTScrollLabelViewDelegate <NSObject>
-(void)JTScrollLabelViewClickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface JTScrollLabelView : UIView

@property (nonatomic,strong) UILabel *showLabelTop;
@property (nonatomic,strong) UILabel *showLabelMiddle;
@property (nonatomic,strong) UILabel *showLabelFoot;
@property (nonatomic,strong) UILabel *timeLabelTop;
@property (nonatomic,strong) UILabel *timeLabelMiddle;
@property (nonatomic,strong) UILabel *timeLabelFoot;

@property (nonatomic,strong) NSString *strShowTop;
@property (nonatomic,strong) NSString *strShowMiddle;
@property (nonatomic,strong) NSString *strShowFoot;
@property (nonatomic,strong) NSString *strTimeTop;
@property (nonatomic,strong) NSString *strTimeMiddle;
@property (nonatomic,strong) NSString *strTimeFoot;

@property (nonatomic,strong) NSArray *showLabelArr;
@property (nonatomic,strong) NSArray *timerLabelArr;
@property (nonatomic,assign) NSInteger showLabelsIndex;
@property (nonatomic,assign) NSTimeInterval scrollTimeInterval;
@property (nonatomic,assign) NSTimer *timerScr;

@property (nonatomic, weak) id<JTScrollLabelViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)beginScrollDatas:(NSArray *)dataArr TimerDatas:(NSArray *)timerArr TimeInterval:(NSTimeInterval)timer;

@end
