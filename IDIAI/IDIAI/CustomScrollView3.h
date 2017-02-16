//
//  CustomScrollView3.h
//  IDIAI
//
//  Created by Ricky on 15/10/23.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomScrollView3 : UIView{
    NSMutableArray *imageUrls;
    UIScrollView *scroll;
}
-(id)initWithFrame:(CGRect)frame imageURL:(NSMutableArray *)urls;
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);
@end
