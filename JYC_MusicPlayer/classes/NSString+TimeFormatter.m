//
//  NSString+TimeFormatter.m
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/8.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import "NSString+TimeFormatter.h"

@implementation NSString (TimeFormatter)

// 时间转成字符串
+(NSString *)getStringFormateByTime:(float)seconds{

   // 分钟 (int)seconds/60;
   // 秒   (int)seconds%60;
    
    return [NSString stringWithFormat:@"%02d:%02d",(int)seconds/60,(int)seconds%60];
    
    
}

// 字符串转换成秒
- (float)getSecondsFormateByTimeString{
    
    NSArray *tempArray = [self componentsSeparatedByString:@":"];
    
    return [tempArray.firstObject integerValue] * 60.0 + [tempArray.lastObject integerValue];
    
}


@end
