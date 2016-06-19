//
//  PlayerViewController.h
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/7.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsoleView.h"
#import "MusicModel.h"

//typedef void(^MyBlock)(MusicModel *model);

@interface PlayerViewController : UIViewController

// 接受上个页面传来的值
@property(nonatomic,assign)NSUInteger index;

//@property(nonatomic,copy)MyBlock myBlock;




+ (instancetype)sharePlayerViewController;








@end
