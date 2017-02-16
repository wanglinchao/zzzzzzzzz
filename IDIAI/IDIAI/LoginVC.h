//
//  LoginVC.h
//  IDIAI
//
//  Created by iMac on 14-7-1.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loggedDelegate;
@interface LoginVC : UIViewController<UITextFieldDelegate>
{
    id<loggedDelegate>delegate;
}
@property (strong, nonatomic)  UITextField *MobileNumber;
@property (strong, nonatomic)  UITextField *Password;
@property (weak, nonatomic) id<loggedDelegate> delegate;
@end

@protocol loggedDelegate <NSObject>
- (void)logged:(NSDictionary*)dict;
- (void)cancel;
@end