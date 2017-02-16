//
//  messageSound.m
//  UTopSP
//
//  Created by iMac on 16/9/7.
//  Copyright © 2016年 Qttec Technology (SiChuan) Co., Ltd. All rights reserved.
//

#import "messageSound.h"

@implementation messageSound

static messageSound *_sharedInstance;
static messageSound *_sharedInstanceForSound;

+ (id)sharedInstanceForVibrate {
    @synchronized ([messageSound class]) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[messageSound alloc] initForPlayingVibrate];
        }
    }
    return _sharedInstance;
}

+ (id)sharedInstanceForSound {
    @synchronized ([messageSound class]) {
        if (_sharedInstanceForSound == nil) {
            _sharedInstanceForSound = [[messageSound alloc] initForPlayingSystemSoundEffectWith:@"sms-received1" ofType:@"caf"];
        }
    }
    return _sharedInstanceForSound;
}
- (id)initForPlayingVibrate
{
    self=[super init];
    if(self){
        soundID=kSystemSoundID_Vibrate;
    }
    return self;
}

-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type
{
    self=[super init];
    if(self){
        
        //NSString *path=[[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:resourceName ofType:type];
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",resourceName,type];
        if(path){
            
            SystemSoundID theSoundID;
            OSStatus error =AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&theSoundID);
            
            if(error == kAudioServicesNoError){
                soundID=theSoundID;
            }else{
                NSLog(@"Failed to create sound");
            }
            
        }
        
    }
    return  self;
}
-(id)initForPlayingSoundEffectWith:(NSString *)filename
{
    self=[super init];
    if(self){
        
        NSURL *fileURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if(fileURL!=nil){

            SystemSoundID theSoundID;
            OSStatus error=AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            
            if(error ==kAudioServicesNoError){
                soundID=theSoundID;
            }else{
                NSLog(@"Failed to create sound");
            }
        }
    }
    
    return self;
    
}
-(void)play
{
    AudioServicesPlaySystemSound(soundID);
}
-(void)cancleSound
{
    _sharedInstance=nil;
    //AudioServicesRemoveSystemSoundCompletion(soundID);
}
-(void)dealloc
{
    AudioServicesDisposeSystemSoundID(soundID);
}

@end
