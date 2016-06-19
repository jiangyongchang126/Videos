//
//  PlayerManager.m
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/7.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import "PlayerManager.h"
#import "DataHelper.h"
#import <UIKit/UIKit.h>
#import "MusicModel.h"
#import "PlayerViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+TimeFormatter.h"

#define HEPLER [DataHelper shareDataHelper]

@interface PlayerManager ()

///** 音乐播放对象 */
@property(nonatomic,strong)AVPlayer *player;

/** 当前播放的下标*/
@property(nonatomic,assign)NSUInteger currentIndex;

// 定时器(让代理不断执行协议中的方法)
@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)AVAudioPlayer *pal;


@end

@implementation PlayerManager

/**
 *  单例一般以 standarXXX  onlyXXX defaultXXX sharedXXX开头
 *  获取管理播放器功能的单例对象
 *  @return 单例对象
 */
+ (instancetype)defaultManager{
    
    static PlayerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc]init];
    });
    
    return manager;
}

// 初始化赋值
- (instancetype)init{
    
    if (self = [super init]) {
        
        
        

        
        self.currentIndex = -1;
        self.playing = NO;
        self.a = 0;
        // 添加观察者
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didMusicPlayFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
        
        
//        //处理中断事件的通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];

        
    }
    
    return self;
}

// 当当前音乐播放完毕时,执行下面这个方法
-(void)didMusicPlayFinished{
   
    if (self.a == 0) {
        
        // 下一首
        [self prepareMusicWithIndex:self.currentIndex + 1 < [HEPLER getCountOfMusic] ? self.currentIndex + 1 : 0];
//        [self.player play];
        
    }else if(self.a == 1){
        self.currentIndex -= 1;
        [self prepareMusicWithIndex:self.currentIndex + 1 < [HEPLER getCountOfMusic] ? self.currentIndex + 1 : 0];
        
//        [self.player play];
        
    }else if(self.a == -1){
        
        [self prepareMusicWithIndex:arc4random()%([HEPLER getCountOfMusic]-1)];
//        [self.player play];
    }
    
//    [self nextMusic];
    
}


- (void)nextMusic{
    
    
    if (self.a == 0) {
        
        // 下一首
        [self prepareMusicWithIndex:self.currentIndex + 1 < [HEPLER getCountOfMusic] ? self.currentIndex + 1 : 0];
//        [self.player play];
        
    }else if(self.a == 1){
        
        [self prepareMusicWithIndex:self.currentIndex + 1 < [HEPLER getCountOfMusic] ? self.currentIndex + 1 : 0];
        
//        [self.player play];
        
    }else if(self.a == -1){
        
        [self prepareMusicWithIndex:arc4random()%([HEPLER getCountOfMusic]-1)];
//        [self.player play];
    }

    
    
//    [self prepareMusicWithIndex:self.currentIndex + 1 < [HEPLER getCountOfMusic] ? self.currentIndex + 1 : 0];
//    
//    [self.player play];
    
    
    
}


- (void)forwardMusic{
    
    
    
    
    [self prepareMusicWithIndex:self.currentIndex == 0 ? [HEPLER getCountOfMusic]-1 : self.currentIndex - 1];
    
    [self.player play];
    
}


/**
 *  根据下标,准备要播放的歌曲
 *
 *  @param index 要播放哪一首
 */

- (void)prepareMusicWithIndex:(NSUInteger)index{
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld",index];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"indexArrayInclude" object:indexStr];
    
    
//    PlayerViewController *playerVC = [PlayerViewController sharePlayerViewController];
    
// 正在播放歌曲的时候,如果退回列表页面,在点进去还会重播,这一步避免了这个
    if (_currentIndex != index) {
        
        _currentIndex = index;
    
        
    

    // 第二种方式:改变dataHelper方法中的参数类型
     MusicModel *music = [HEPLER getMusicModelWithIndexPath:_currentIndex];
//

//        [PlayerViewController sharePlayerViewController].myBlock(music);
        

        
        // 实例化一个playerItem作为player要播放的歌曲
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:music.mp3Url ]];
    
    // 替换当前的playItem
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    // 播放音乐
    [self musicPlay];
        
        // 安全判断delegate-协议
        if ([_delegate respondsToSelector:@selector(didSkippedMusic:)]) {
            
            [_delegate didSkippedMusic:music];
        }
        
        
    
    }
}




// 播放音乐
- (void)musicPlay{
    
    if (_timer == nil) {
        
    
    // 创建一个定时器,0.1秒执行一次方法
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
}
    // 播放
    
    [self.player play];
    self.playing = YES;
    
}

- (void)timerAction{
    
    // 安全判断
    if ([_delegate respondsToSelector:@selector(isPlayingMusicAsTime:)]) {
        
        // 获取当前时间并转化成秒数
        CGFloat seconds = CMTimeGetSeconds(self.player.currentTime);
        
        [_delegate isPlayingMusicAsTime:[NSString getStringFormateByTime:seconds]];
    }
    
    
}


// 暂停音乐
- (void)pausePlay{
    
    [self.timer invalidate];
    _timer = nil;
    
    [self.player pause];
    self.playing = NO;
    
}



// 调节音量
- (void)changeVoiceValue:(float)value{
    
    self.player.volume = value;
    
}


- (void)musicSeekToTime:(float)time{
    
    // 公式:Value/timescale = seconds
    
    [self.player seekToTime:CMTimeMake(time * self.player.currentTime.timescale, self.player.currentTime.timescale)];
    
    
}


//// 拔掉耳机
//-(void)routeChange:(NSNotification *)notification{
//    NSDictionary *dic=notification.userInfo;
//    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
//    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
//    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
//        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
//        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
//        //原设备为耳机则暂停
//        if ([portDescription.portType isEqualToString:@"Headphones"]) {
//            [self pausePlay];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"zantingbtn" object:nil];
//        }
//    }
//}

////处理中断事件
//-(void)handleInterreption:(NSNotification *)sender
//{
//    if(self.isPlaying)
//    {
//        [self pausePlay];
//    }
//    else
//    {
//        [self musicPlay];
//    }
//}
//


// 懒加载创建player对象
- (AVPlayer *)player{
    
    if (_player == nil) {
        
        _player = [[AVPlayer alloc]init];
        
    }
    
    return _player;
}




@end
