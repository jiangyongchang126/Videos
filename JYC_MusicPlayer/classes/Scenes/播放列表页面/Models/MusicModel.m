//
//  MusicModel.m
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/6.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        
        self.ID = value;
    }else if([key isEqualToString:@"lyric"]){
        
        // 对歌词进行封装
        
        [self formatLyricWithLyric:value];

        
    }
}

- (void)formatLyricWithLyric:(NSString *)lyric{
    // 1.\n  一句一句歌词
    NSArray *returnArray = [lyric componentsSeparatedByString:@"\n"];
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    
    for (NSString *tempString in returnArray) {
        
        if (![tempString isEqualToString:@""]) {
           
            // 2.使用"]"来拆分字符串 ([00:01)(歌词...)
            NSArray *timeAndlyricArr = [tempString componentsSeparatedByString:@"]"];
            
            NSString *time = [[timeAndlyricArr firstObject] substringWithRange:NSMakeRange(1, 5)];

            // 以"00:00"作为key 歌词作为value 放在字典中
            NSDictionary *lyricDic = @{time:[timeAndlyricArr lastObject]};
            
            [self.lyricArray addObject:lyricDic];
            
            [mutableDict setObject:[timeAndlyricArr lastObject] forKey:time];
            
        }
        
    }
    [self.selfDataArray addObject:mutableDict];
}

// 懒加载初始化歌词数组
- (NSMutableArray *)lyricArray{
    
    if (_lyricArray == nil) {
        
        _lyricArray = [NSMutableArray array];
    }
    
    return _lyricArray;
}





@end
