//
//  AppDelegate.m
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/6.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    
//    UIBackgroundTaskIdentifier ID = [application beginBackgroundTaskWithExpirationHandler:^{
//        [application endBackgroundTask:ID];
//    }];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];

    
//    //开启远程事件(锁屏时使用)
    [application beginReceivingRemoteControlEvents];
    
    
    //处理中断事件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
    return YES;
}

//处理中断事件
-(void)handleInterreption:(NSNotification *)sender
{
    if([PlayerManager defaultManager].isPlaying)
    {
        [[PlayerManager defaultManager] pausePlay];
    }
    else
    {
        [[PlayerManager defaultManager] musicPlay];
    }
}



#pragma mark 接收远程事件
-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    //判断是否为远程事件
    if (event.type == UIEventTypeRemoteControl) {
        //调用block
        
        
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [[PlayerManager defaultManager] musicPlay];
                break;
            case UIEventSubtypeRemoteControlPause:
                [[PlayerManager defaultManager] pausePlay];
                break;
            case UIEventSubtypeRemoteControlStop:
                [[PlayerManager defaultManager] pausePlay];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if ([PlayerManager defaultManager].isPlaying) {
                    [[PlayerManager defaultManager] pausePlay];
                }else{
                    [[PlayerManager defaultManager] musicPlay];
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"Next...");
                [[PlayerManager defaultManager] nextMusic];
                
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"Previous...");
                
                [[PlayerManager defaultManager] forwardMusic];
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                NSLog(@"Begin seek forward...");
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
                NSLog(@"End seek forward...");
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                NSLog(@"Begin seek backward...");
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                NSLog(@"End seek backward...");
                break;
            default:
                break;
        
    }

    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        
//    }];
    
//    UIBackgroundTaskIdentifier ID = [application beginBackgroundTaskWithExpirationHandler:^{
//        [application endBackgroundTask:ID];
//    }];
//
//    
//    
//    UIApplication *app = [UIApplication sharedApplication];
//    
//    __block  UIBackgroundTaskIdentifier bgTask;
//    
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//       
//        dispatch_async(dispatch_get_main_queue(), ^{
//           
//            if (bgTask != UIBackgroundTaskInvalid) {
//                
//                bgTask = UIBackgroundTaskInvalid;
//            }
//            
//        });
//        
//    }];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//       
//        dispatch_async(dispatch_get_main_queue(), ^{
//           
//            if (bgTask != UIBackgroundTaskInvalid) {
//                
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//        
//    });
    
    
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
