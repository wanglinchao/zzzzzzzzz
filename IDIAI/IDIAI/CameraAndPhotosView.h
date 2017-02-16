//
//  CameraAndPhotosView.h
//  IDIAI
//
//  Created by iMac on 14-7-14.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraAndPhotosViewDelegate <NSObject>
-(void)CameraAndPhotoCustom:(UIView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface CameraAndPhotosView : UIView
{
    UIControl *control;
}

@property (nonatomic, weak) id<CameraAndPhotosViewDelegate>delegate;
@property (nonatomic, strong) UIButton *photo_Button;
@property (nonatomic, strong) UIButton *camera_Button;
@property (nonatomic, strong) UIButton *back_Button;
@property (nonatomic, strong) UILabel *photo_Lab;
@property (nonatomic, strong) UILabel *camera_Lab;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)show;

@end
