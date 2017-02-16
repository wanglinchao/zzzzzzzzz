//
//  MBProgressHUDAdditoin.m
//  FJColorPrinting
//
//  Created by Jet Xiao on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MBProgressHUDAdditoin.h"

@implementation MBProgressHUD (addition)

#pragma mark - show error and succeeded view
- (void)showErrorViewAndSleep:(NSString*)string seconds:(float)seconds
{
    [self showErrorView:string];
    sleep(seconds);    
}
- (void)showSucceededViewAndSleep:(NSString*)string seconds:(float)seconds
{
    [self showSucceededView:string];
    sleep(seconds);
}

- (void)showErrorView:(NSString*)string
{
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Warning.png"]];
    self.mode = MBProgressHUDModeCustomView;
    self.labelText = string;      
}

- (void)showSucceededView:(NSString*)string
{
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.mode = MBProgressHUDModeCustomView;
    self.labelText = string;    
}

+ (void)hideAndReleaseView:(MBProgressHUD*)hud waitUntilDone:(BOOL)waitUntilDone
{
    if(hud)
    {
        if([NSThread isMainThread])
        {
            [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:waitUntilDone];
        }
        else
        {
            [hud removeFromSuperview];
        }
        hud = nil;      
    }
}
+ (void)hideAndReleaseCurrentView:(UIView*)parentView waitUntilDone:(BOOL)waitUntilDone
{
    MBProgressHUD* hud = [self getCurrentMBProgressHUD:parentView];
    if(hud)
    {
        [self hideAndReleaseView:hud waitUntilDone:waitUntilDone];
    }
}

#pragma mark - init and show、 hide waitting view
+ (MBProgressHUD*)showWaitingView:(NSString*)str parentView:(UIView*)parentView delegate:(id)delegate
{    
    MBProgressHUD* hud = [[MBProgressHUD alloc]initWithView:parentView];
    hud.delegate = delegate;
    hud.labelText = str;
    hud.tag = MBHUD_VIEW_TAG;
    [parentView addSubview:hud];
    [hud show:YES];
    
    return hud;
}
+ (MBProgressHUD*)showWaitingViewWithYOffset:(NSString*)str parentView:(UIView*)parentView yOffset:(int)yOffset delegate:(id)delegate
{
    MBProgressHUD* hud = [[MBProgressHUD alloc]initWithView:parentView];
    hud.delegate = delegate;
    hud.labelText = str;
    hud.yOffset = yOffset;
    hud.tag = MBHUD_VIEW_TAG;
    [parentView addSubview:hud];
    [hud show:YES];
    
    return hud;    
}
+ (MBProgressHUD*)showHUDSucceededViewWithYOffset:(NSString*)str parentView:(UIView*)parentView yOffset:(int)yOffset delegate:(id)delegate
{
    MBProgressHUD* hud = [[MBProgressHUD alloc]initWithView:parentView];

    hud.delegate = delegate;

    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;    
    hud.labelText = str;
    hud.yOffset = yOffset;
    
    hud.tag = MBHUD_VIEW_TAG;
    
    [parentView addSubview:hud];
    [hud show:YES];
    
    return hud;        
}

+ (void)hideWaittingView:(UIView*)parentView
{
    UIView* pView = [parentView viewWithTag:MBHUD_VIEW_TAG];
    if(pView)
    {
        if([NSThread isMainThread])
        {
            [pView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        }
        else
        {
            [pView removeFromSuperview];
        }        
    }
}

+ (MBProgressHUD*)getCurrentMBProgressHUD:(UIView*)parentView
{
    MBProgressHUD* hud = (MBProgressHUD*)[parentView viewWithTag:MBHUD_VIEW_TAG];
    return hud;
}

@end
