//
//  PlayerManager.h
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/7.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class MusicModel;


@protocol PlayerManagerDelegate <NSObject>

// 当音乐不断播放时,代理要实现的方法  时间字符串
- (void)isPlayingMusicAsTime:(NSString *)timeString;

/**
 *  当切割时,代理要实现的方法
 *
 *  @param music 哪一首歌曲
 */
- (void)didSkippedMusic:(MusicModel *)music;


@end



@interface PlayerManager : NSObject

@property(nonatomic,assign)id<PlayerManagerDelegate> delegate;

@property(nonatomic,assign,getter=isPlaying)BOOL playing;

@property(nonatomic,assign)NSInteger a;

/** 音乐播放对象 */
//@property(nonatomic,strong)AVPlayer *player;


/**
 *  单例一般以 standarXXX  onlyXXX defaultXXX sharedXXX开头
 *  获取管理播放器功能的单例对象
 *  @return 单例对象
 */

+ (instancetype)defaultManager;

/**
 *  播放音乐
 */

- (void)musicPlay;


/**
 *  暂停音乐
 */

- (void)pausePlay;


/**
 *  上一首
 */

- (void)forwardMusic;


/**
 *  下一首
 */

- (void)nextMusic;


/**
 *  调节音量[0.0 ~ 1.0]
 *
 *  @param value 设置音量值
 */

- (void)changeVoiceValue:(float)value;


/**
 *  根据时间跳转到指定时间播放音乐
 *
 *  @param time 跳转到的时间
 */

- (void)musicSeekToTime:(float)time;


/**
 *  根据下标,准备要播放的歌曲
 *
 *  @param index 要播放哪一首
 */

- (void)prepareMusicWithIndex:(NSUInteger)index;



//- (MusicModel *)getMusicModelIsValue:(NSUInteger)index;



@end
