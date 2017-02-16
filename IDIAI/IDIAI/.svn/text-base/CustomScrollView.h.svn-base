//
//  CustomScrollView.h
//  IDIAI
//
//  Created by iMac on 14-7-30.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomScrollViewDelegate;

@interface CustomScrollView : UIView
{
    id<CustomScrollViewDelegate> delegate;
}
@property (weak, nonatomic) id<CustomScrollViewDelegate> delegate;
@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , readonly) UIScrollView *scrollView;
/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

/**
 数据源：获取总的page个数
 **/
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);
/**
 数据源：获取第pageIndex个位置的contentView
 **/
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);

@end

@protocol CustomScrollViewDelegate <NSObject>
- (void)scrollviewToCurrent:(NSInteger)index;

@end