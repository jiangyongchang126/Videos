//
//  MusicListTableViewCell.m
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/6.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import "MusicListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MusicListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *musicPic;



@end


@implementation MusicListTableViewCell

// 通过重写setter方法,实现对Cell上的控件赋值

-(void)setMusic:(MusicModel *)music{
    
    self.musicNameLabel.text = music.name;
    
    self.singerNameLabel.text = music.singer;
    
    [self.musicPic sd_setImageWithURL:[NSURL URLWithString:music.picUrl] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] options:SDWebImageRefreshCached];

    

    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
