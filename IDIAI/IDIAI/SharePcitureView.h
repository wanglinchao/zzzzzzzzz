//
//  SharePcitureView.h
//  IDIAI
//
//  Created by iMac on 15-3-5.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SharePicViewDelegate <NSObject>
-(void)SharePicCustomclickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface SharePcitureView : UIView
{
    UIControl *control;
}
@property(nonatomic,assign)BOOL isdiary;
@property (nonatomic, weak) id<SharePicViewDelegate>delegate;


-(id)initWithFrame:(CGRect)frame;
- (void)show;

@end
