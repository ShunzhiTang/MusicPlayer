//
//  AppDelegate.m
//  MusicPlayer
//
//  Created by Tsz on 15/10/31.
//  Copyright © 2015年 Tsz. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1、AVAudioSession
    AVAudioSession *session  = [AVAudioSession sharedInstance];
    
    //2、设置类型
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //3、激活
    [session setActive:YES error:nil];
    return YES;
}

//开启后台应用
- (void)applicationDidEnterBackground:(UIApplication *)application{
    
    [application beginBackgroundTaskWithExpirationHandler:nil];
}

@end
