//
//  EditRequermentViewController.h
//  IDIAI
//
//  Created by iMac on 15-6-26.
//  Copyright (c) 2015年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditRequermentVCDelegate;
@interface EditRequermentViewController : UIViewController<UITextViewDelegate>
{
    UITextView *_textView;
}

@property (weak, nonatomic) id<EditRequermentVCDelegate> delegate;
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) NSString *fromwhere;

@end

@protocol EditRequermentVCDelegate <NSObject>

-(void)GetEditRequerment:(NSString *) title;

@end
