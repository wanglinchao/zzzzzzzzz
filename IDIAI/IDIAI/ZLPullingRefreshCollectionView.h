//
//  ZLPullingRefreshCollectionView.h
//  IDIAI
//
//  Created by PM on 16/6/22.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kZLPRStateNormal = 0,                     //正常状态
    kZLPRStatePulling = 1,                    //拉动中
    kZLPRStateLoading = 2,                    //加载中
    kZLPRStateHitTheEnd = 3                   //遇到底部
} ZLPRState;

@interface ZLLoadingView : UIView {
    UILabel *_stateLabel;
    UILabel *_dateLabel;
    UIImageView *_arrowView;
    UIActivityIndicatorView *_activityView;
    CALayer *_arrow;
    BOOL _loading;
}
@property (nonatomic,getter = isLoading) BOOL loading;
@property (nonatomic,getter = isAtTop) BOOL atTop;
@property (nonatomic) ZLPRState state;

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;

- (void)updateRefreshDate:(NSDate *)date;
- (void)setState:(ZLPRState)state animated:(BOOL)animated;
@end

@protocol ZLPullingRefreshCollectionViewDelegate;

@interface ZLPullingRefreshCollectionView : UICollectionView<UIScrollViewDelegate>
{
    ZLLoadingView *_headerView;           //表格头部视图
    ZLLoadingView *_footerView;           //表格根部视图
    UILabel *_msgLabel;                 //消息标签
    BOOL _loading;                      //是否在加载中
    BOOL _isFooterInAction;             //是否加载更多中
    NSInteger _bottomRow;               //底部的行数
}
@property (assign,nonatomic) id <ZLPullingRefreshCollectionViewDelegate> pullingDelegate;
@property (nonatomic) BOOL autoScrollToNextPage;
@property (nonatomic) BOOL reachedTheEnd;
@property (nonatomic,getter = isHeaderOnly) BOOL headerOnly;

//added  by liangliang
@property (nonatomic,getter = isFooterOnly) BOOL footerOnly;

- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<ZLPullingRefreshCollectionViewDelegate>)aPullingDelegate FlowLayout:(UICollectionViewFlowLayout*)flowLayout;

- (void)collectionViewDidScroll:(UIScrollView *)scrollView;

- (void)collectionViewDidEndDragging:(UIScrollView *)scrollView;

- (void)collectionViewDidFinishedLoading;

- (void)collectionViewDidFinishedLoadingWithMessage:(NSString *)msg;

- (void)launchRefreshing;

- (void)flashMessage:(NSString *)msg;
@end



@protocol ZLPullingRefreshCollectionViewDelegate <NSObject>

@required
- (void)pullingCollectionViewDidStartRefreshing:(ZLPullingRefreshCollectionView *)collectionView;

@optional
//Implement this method if headerOnly is false
- (void)pullingCollectionViewDidStartLoading:(ZLPullingRefreshCollectionView *)collectionView;
//Implement the follows to set date you want,Or Ignore them to use current date
- (NSDate *)pullingCollectionViewRefreshingFinishedDate;
- (NSDate *)pullingCollectionViewLoadingFinishedDate;
@end

//Usage example
/*
 _collectionView = [[ZLPullingRefreshCollectionView alloc] initWithFrame:frame pullingDelegate:aPullingDelegate FlowLayout:flowLayout];
 [self.view addSubview:_collectionView];
 _collectionView.autoScrollToNextPage = NO;
 _collectionView.delegate = self;
 _collectionView.dataSource = self;
 */



