//
//  MBProgressHUDAdditoin.h
//  FJColorPrinting
//
//  Created by Jet Xiao on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MBProgressHUD (addition)

- (void)showErrorView:(NSString*)string;
- (void)showSucceededView:(NSString*)string;
- (void)showErrorViewAndSleep:(NSString*)string seconds:(float)seconds;
- (void)showSucceededViewAndSleep:(NSString*)string seconds:(float)seconds;

+ (void)hideAndReleaseView:(MBProgressHUD*)hud waitUntilDone:(BOOL)waitUntilDone;
+ (void)hideAndReleaseCurrentView:(UIView*)parentView waitUntilDone:(BOOL)waitUntilDone;

+ (MBProgressHUD*)showWaitingView:(NSString*)str parentView:(UIView*)parentView delegate:(id)delegate;
+ (MBProgressHUD*)showWaitingViewWithYOffset:(NSString*)str parentView:(UIView*)parentView yOffset:(int)yOffset delegate:(id)delegate;
+ (void)hideWaittingView:(UIView*)parentView;

+ (MBProgressHUD*)showHUDSucceededViewWithYOffset:(NSString*)str parentView:(UIView*)parentView yOffset:(int)yOffset delegate:(id)delegate;

+ (MBProgressHUD*)getCurrentMBProgressHUD:(UIView*)parentView;

@end
