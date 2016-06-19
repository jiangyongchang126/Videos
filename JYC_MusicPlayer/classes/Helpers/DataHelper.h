//
//  DataHelper.h
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/6.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void(^SUCCESS)(NSMutableArray *array);
//typedef void(^SearchBlock)(NSMutableArray *searchArray);

@class MusicModel;

@interface DataHelper : NSObject

@property(nonatomic,assign)NSInteger timeTime;

//@property(nonatomic,copy)SearchBlock searchBlock;

/** 获取单例对象*/
+(instancetype)shareDataHelper;

/** 根据Model获取下标*/
- (NSInteger )getIndexAccordingToTheModel:(MusicModel *)model;


/** 请求网路数据并解析,封装成model对象 */ //  (void(^)(NSMutableArray *array)) block的类型

-(void)requestAllMusicModelsWithUrlString:(NSString *)urlString DidFinish:(SUCCESS)success;


/**
 *  获取歌曲的总格数
 *
 *  @return 个数
 */
-(NSUInteger)getCountOfMusic;



/**
 *  通过indexPath获取指定的music对象
 *
 *  @param indexPath indexPath对象
 *
 *  @return 返回指定的music对象
 */
//- (MusicModel *)getMusicModelWithIndexPath:(NSIndexPath *)indexPath;

/**
 *  根据下标获取某个音乐对象
 *
 *  @param index 下标
 *
 *  @return 某个音乐对象
 */
- (MusicModel *)getMusicModelWithIndexPath:(NSUInteger)index;



@end
