//
//  FlickingViewController.h
//  IDIAI
//
//  Created by iMac on 15-7-2.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickingViewController : UIViewController
{
    BOOL isTapImagePicker;  //是否点击了相册
}

@property (nonatomic,strong) NSString *outsideUrl;

@end
