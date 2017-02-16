//
//  PointMallViewController.h
//  IDIAI
//
//  Created by PM on 16/6/13.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "GeneralWithBackBtnViewController.h"
#import "ZLPullingRefreshCollectionView.h"
@interface PointMallViewController : GeneralWithBackBtnViewController<ZLPullingRefreshCollectionViewDelegate>

@property(nonatomic,strong)ZLPullingRefreshCollectionView * zlCollectionView;
@property(nonatomic,copy)NSString * city;

@end
