//
//  ConsoleView.h
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/7.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"


@interface ConsoleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeNeededLabel;

@property (weak, nonatomic) IBOutlet UISlider *timeSlider;

@property (weak, nonatomic) IBOutlet UISlider *voiceSlider;


@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIButton *functionButton;


// 初始化View上面的控件
- (void)prepareSubViewsInitStatus:(MusicModel*)music;


// 根据时间字符串,来设置timeSlider和currentTimeLabel
- (void)changeTimeSliderAndCurrentLabelWithTimeString:(NSString *)string;

- (void)didClickStartButton:(UIButton *)button;


@end
