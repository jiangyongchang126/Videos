//
//  MusicModel.h
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/6.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

/** mp3音频*/
@property(nonatomic,strong)NSString *mp3Url;

/** id*/
@property(nonatomic,strong)NSString *ID;

/** 名字name*/
@property(nonatomic,strong)NSString *name;

/** 照片picUrl*/
@property(nonatomic,strong)NSString *picUrl;

/** blurPicUrl*/
@property(nonatomic,strong)NSString *blurPicUrl;

/** 相簿album*/
@property(nonatomic,strong)NSString *album;

/** 歌手singer*/
@property(nonatomic,strong)NSString *singer;

/** 持续时间duration*/
@property(nonatomic,assign)NSInteger duration;

/** 歌词lyric*/
//@property(nonatomic,strong)NSString *lyric;

/**  歌曲的作者*/
@property (nonatomic, strong) NSString * artists_name;

/** 自己的方法*/
@property(nonatomic,strong)NSMutableArray *selfDataArray;

/**存放所有封装后的歌词*/
@property(nonatomic,strong)NSMutableArray *lyricArray;


@end
