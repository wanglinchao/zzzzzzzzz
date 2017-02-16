//
//  SWAddPhotoView.h
//  SubWayWifi
//
//  Created by apple on 15-1-4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SWAddPhotoViewDelegate <NSObject>

@optional
-(void)addPhotoCount:(NSInteger)count;
-(void)pickPhotoCount:(NSInteger)count;
-(void)detelePhotoCount:(NSInteger)count;
-(void)longTouchPhotoCount:(NSInteger)count;
@end
@interface SWAddPhotoView : UIView
@property(nonatomic,strong)NSMutableArray *photos;//可以是图片，也可以是图片地址
@property(nonatomic,assign)NSInteger photocount;
@property(nonatomic,strong)UILabel * maxOrMinPicNumLab;
@property(nonatomic,assign)NSInteger minPicNum;
@property (nonatomic, assign) id<SWAddPhotoViewDelegate> delegate;
-(void)addImages:(NSMutableArray *)images;
@property(nonatomic,strong)UIButton *addPhotobtn;
@property(nonatomic,strong)UIButton *pickPhoto;
@end
