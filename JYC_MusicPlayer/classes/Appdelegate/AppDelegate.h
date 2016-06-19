//
//  AppDelegate.h
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/6.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^playerRemoteEventBlock)(UIEvent *event);


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) playerRemoteEventBlock myRemoteEventBlock;

@end

