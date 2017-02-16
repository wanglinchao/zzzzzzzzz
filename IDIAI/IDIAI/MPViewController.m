//
//  MPViewController.m
//  IDIAI
//
//  Created by iMac on 14-12-23.
//  Copyright (c) 2014年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "MPViewController.h"
 #import <MediaPlayer/MediaPlayer.h>

@interface MPViewController ()
{
    MPMoviePlayerController *moviePlayer;
}
@end

@implementation MPViewController
@synthesize url_str;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0){
        [[self view] setBounds:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        [[self view] setCenter:CGPointMake(kMainScreenWidth/2, kMainScreenHeight/2)];
        [[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    }

    // 设置视频播放器
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url_str]];
    if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0){
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*0.5);
        moviePlayer.view.transform = transform;
        [moviePlayer.view setFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    }
    else [moviePlayer.view setFrame:CGRectMake(0, 0, kMainScreenHeight, kMainScreenWidth)];
    moviePlayer.allowsAirPlay = YES;
    moviePlayer.controlStyle=MPMovieControlStyleFullscreen;
    moviePlayer.scalingMode=MPMovieScalingModeAspectFit;
    [self.view addSubview:moviePlayer.view];
    // 播放完视频之后，MPMoviePlayerController 将发送
    // MPMoviePlayerPlaybackDidFinishNotification 消息
    // 登记该通知，接到该通知后，调用playVideoFinished:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    
    [moviePlayer play];
}

- (void)playVideoFinished:(NSNotification *)theNotification{
    // 取消监听
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    // 将视频视图从父视图中删除
    [moviePlayer.view removeFromSuperview];
     [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
