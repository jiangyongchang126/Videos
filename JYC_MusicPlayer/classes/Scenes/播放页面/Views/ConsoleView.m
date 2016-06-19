//
//  ConsoleView.m
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/7.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import "ConsoleView.h"
#import "PlayerViewController.h"
#import "PlayerManager.h"
#import "DataHelper.h"
#import "NSString+TimeFormatter.h"

#define Manager [PlayerManager defaultManager]

NSInteger i = 0;

@interface ConsoleView ()

@property(nonatomic,assign)BOOL flag;// 手指是否离开

@end


@implementation ConsoleView

// 初始化
- (void)prepareSubViewsInitStatus:(MusicModel*)music{
    
    // 当前播放时间
    self.currentTimeLabel.text = @"00:00";
    
    
    // 歌曲的总时间
    int seconds = (int)music.duration / 1000;
    
    self.TimeNeededLabel.text = [NSString getStringFormateByTime:(float)seconds];
    
    // 滑块最大值
    self.timeSlider.maximumValue = seconds;
    
    
    [self.timeSlider addTarget:self action:@selector(didClickTimeSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.timeSlider addTarget:self action:@selector(didClickTimeSliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.timeSlider addTarget:self action:@selector(didClickTimeSliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    
    [self.voiceSlider addTarget:self action:@selector(VoiceValue:) forControlEvents:UIControlEventValueChanged];
    
    // 播放按钮
    [self.startButton addTarget:self action:@selector(didClickStartButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 上一首歌曲
    [self.forwardButton addTarget:self action:@selector(didClickForwardButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 下一首歌曲
    [self.nextButton addTarget:self action:@selector(didClickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 功能按钮
    [self.functionButton addTarget:self action:@selector(didClickFunctionButton:) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    
}
#pragma mark--------------timeSlider的相关方法---------
// timeSlider的值改变
- (void)didClickTimeSliderValueChange:(UISlider *)slider{
    
//    _flag = YES;
//    [[PlayerManager defaultManager]musicSeekToTime:slider.value];
    
    
}
// 点击timeSlider 当拖动slider时,歌曲不耽误唱
- (void)didClickTimeSliderTouchUpInside:(UISlider *)slider{
    
    _flag = NO;
    
    [[PlayerManager defaultManager]musicSeekToTime:slider.value];
    
}

- (void)didClickTimeSliderTouchDown:(UISlider *)slider{
    
    _flag = YES;
}



//
-(void)VoiceValue:(UISlider *)sender{
    
    [Manager changeVoiceValue:sender.value];
    
}

// 点击播放
- (void)didClickStartButton:(UIButton *)button{
    /**
    if (Manager.isPlaying == YES) {
        
        [Manager pausePlay];
        Manager.playing = NO;
        [self.startButton setTitle:@"播放" forState:UIControlStateNormal];
        
        [[PlayerViewController sharePlayerViewController] removeAnimation];
        
//        [[PlayerViewController sharePlayerViewController].musicPic.layer removeAllAnimations];

        
    }else{
        
        [Manager musicPlay];
        Manager.playing = YES;
        [self.startButton setTitle:@"暂停" forState:UIControlStateNormal];
        
        [[PlayerViewController sharePlayerViewController] startAnimation];
        
    }
    */

    if ([button.titleLabel.text isEqualToString:@"暂停"]) {
        
        [[PlayerManager defaultManager] pausePlay];
        
        [button setTitle:@"播放" forState:UIControlStateNormal];
    }else if ([button.titleLabel.text isEqualToString:@"播放"]){
        
        [[PlayerManager defaultManager] musicPlay];
        
//        [[PlayerManager defaultManager].player setRate:1.5];
        
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        
    }

    
}

-(void)didClickFunctionButton:(UIButton *)button{
    
    if (Manager.a == 0) {
        Manager.a = 1;
        [self.functionButton setTitle:@"单曲" forState:UIControlStateNormal];
        
    }else if(Manager.a == 1){
        Manager.a = -1;
        [self.functionButton setTitle:@"随机" forState:UIControlStateNormal];
        
    }else if (Manager.a == -1){
        Manager.a = 0;
        [self.functionButton setTitle:@"顺序播放" forState:UIControlStateNormal];
        
    }
    
    
}


// 上一首点击事件
- (void)didClickForwardButton:(UIButton *)button{
    
    [[PlayerManager defaultManager] forwardMusic];

    
    
    
}

// 下一首点击事件
-(void)didClickNextButton:(UIButton *)button{
    
    [[PlayerManager defaultManager] nextMusic];

    
    

}

- (void)changeTimeSliderAndCurrentLabelWithTimeString:(NSString *)string{
    

    
    if (_flag == NO) {
        
        // 类目方法 (字符串转换为时间)
        self.timeSlider.value = [string getSecondsFormateByTimeString];
        
        self.currentTimeLabel.text = string;

    }else{
        
        self.currentTimeLabel.text = [NSString getStringFormateByTime:self.timeSlider.value ];

    }
    
    [self.startButton setTitle:@"暂停" forState:UIControlStateNormal];
    

}


@end
