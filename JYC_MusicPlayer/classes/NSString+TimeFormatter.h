//
//  NSString+TimeFormatter.h
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/8.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeFormatter)

// 150 --> 02:30
+ (NSString *)getStringFormateByTime:(float)seconds;



// 02:30 ---> 150
- (float)getSecondsFormateByTimeString;



@end
