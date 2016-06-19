//
//  PlayerViewController.m
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/7.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlayerManager.h"
#import "UIImageView+WebCache.h"
#import "NSString+TimeFormatter.h"

@interface PlayerViewController ()<UITableViewDataSource,UITableViewDelegate,PlayerManagerDelegate>

@property(nonatomic,strong)MusicModel *musicModel;

@property (weak, nonatomic) IBOutlet UIImageView *musicPic;

// 接受歌词的数组
@property(nonatomic,strong)NSMutableArray *lyricDataArray;


@property (weak, nonatomic) IBOutlet UITableView *lyricTableView;

@property (weak, nonatomic) IBOutlet ConsoleView *controlView;


@end

@implementation PlayerViewController


- (void)viewWillAppear:(BOOL)animated{
    // 播放页面将要出现的时候,准备开始播放音乐
    [[PlayerManager defaultManager]prepareMusicWithIndex:_index];
    

}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    

    
}

// 控制器里的单例对象
+ (instancetype)sharePlayerViewController{
    
    static PlayerViewController *playerVC = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 获取MainStordboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        // 通过storyboardID,找到对应的viewController;
        playerVC = [storyboard instantiateViewControllerWithIdentifier:@"playerVC"];
        
        
    });
    
    return playerVC;
}


-(void)startAnimation{
    

    /**
    // 照片旋转
    CABasicAnimation *baseA4 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    baseA4.fromValue = @0;
    baseA4.toValue = @180;
    baseA4.duration = 300;
//    baseA4.removedOnCompletion = NO;
    
    baseA4.fillMode = kCAFillModeForwards;
    
    [self.musicPic.layer addAnimation:baseA4 forKey:@"旋转"];
    
*/
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//  block
    
    /**
    __weak PlayerViewController *weakSelf = self;
    weakSelf.myBlock = ^(MusicModel *model){
        
        self.musicModel = model;
    };
    */
    
    

    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.view.bounds];

    imageV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2.jpg"]];
    
    [self.view addSubview:imageV];
    
    [self.view sendSubviewToBack:imageV];
    

    

    //自定义协议设置代理
    [PlayerManager defaultManager].delegate = self;
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnTitle:) name:@"zantingbtn" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];


}

// 拔掉耳机
-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            
//            [[PlayerManager defaultManager] pausePlay];
            
            [self.controlView didClickStartButton:self.controlView.startButton];
        }
    }
}

#pragma mark---------实现PlayerManagerDelegate协议

- (void)isPlayingMusicAsTime:(NSString *)timeString{
    
    // 先让图片旋转起来
    
    self.musicPic.transform = CGAffineTransformRotate(self.musicPic.transform, M_PI/180.0);
    
    [_controlView changeTimeSliderAndCurrentLabelWithTimeString:timeString];
    
    
    // 歌词随时间滚动
    // 遍历当前歌词数组
    for (int i = 0; i < _lyricDataArray.count; i++) {
        
        NSDictionary *lyricDic = _lyricDataArray[i];
        
        
        if ([timeString isEqualToString:[lyricDic allKeys].firstObject]) {
           // 显示当前对应的歌词
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            [self.lyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
    
}

//
- (void)didSkippedMusic:(MusicModel *)music{
    
    // 初始化consoleView上的子控件;
    [_controlView prepareSubViewsInitStatus:music];
    
    [self.musicPic sd_setImageWithURL:[NSURL URLWithString:music.picUrl] placeholderImage:nil options:SDWebImageRefreshCached];
    
    self.navigationItem.title = music.name;

    // 获取歌词
    self.lyricDataArray = [NSMutableArray arrayWithArray:music.lyricArray];
    // 刷新表示图
    [self.lyricTableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark-----------------------实现tableView相关协议方法-----------

// 分区里有几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _lyricDataArray.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    NSDictionary *dict =  _lyricDataArray[indexPath.row];
    
    cell.textLabel.text = [dict allValues].lastObject;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.numberOfLines = 0;
    
    
    // 设置文字的高亮颜色
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    
    // 设置选中的时候的backgroundView
    UIView *backView = [[UIView alloc]initWithFrame:cell.contentView.frame];
    backView.backgroundColor = [UIColor colorWithRed:0.5 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    
    cell.selectedBackgroundView = backView;
    
    
    return cell;
}


//根据歌词拖动来改变音乐进度

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 获取当前页面显示的歌词的数组
    NSArray *showArray = [self.lyricTableView indexPathsForVisibleRows];
    
//    int row = (int)[[showArray firstObject] row];
    
    int row1 = (int)[showArray[3] row];
    
    NSString *time = [[self.lyricDataArray[row1] allKeys] firstObject];

    // 获取当前时间
    float seconds = [time getSecondsFormateByTimeString];
    
    // 修改时间
    [[PlayerManager defaultManager]musicSeekToTime:seconds];
    
}

// 点击歌词播放
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *time = [[self.lyricDataArray[indexPath.row] allKeys] firstObject];
    
    float seconds = [time getSecondsFormateByTimeString];
    
    [[PlayerManager defaultManager]musicSeekToTime:seconds];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





@end
