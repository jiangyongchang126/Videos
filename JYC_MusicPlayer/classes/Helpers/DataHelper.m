//
//  DataHelper.m
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/6.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import "DataHelper.h"
#import "MusicModel.h"
#import <UIKit/UIKit.h>



@interface DataHelper ()

@property(nonatomic,assign)NSInteger flog;

/** 存放所有的model类*/
@property(nonatomic,strong)NSMutableArray *allMusicModels;


@end


@implementation DataHelper

+(instancetype)shareDataHelper{
    
    static DataHelper *helper = nil;

    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        helper = [[self alloc]init];
        
        
    });
    
    return helper;
}

-(void)requestAllMusicModelsWithUrlString:(NSString *)urlString DidFinish:(SUCCESS)success{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        
        
            // 生成url对象
            NSURL *url = [NSURL URLWithString:urlString];
            
            //根据url获取数据
            NSArray *array = [NSArray arrayWithContentsOfURL:url];
            
            // 便利数组,把每个字典,通过KVC封装成model对象
            
            for (NSDictionary *dict in array) {
                
                MusicModel *musicModel = [[MusicModel alloc]init];
                
                [musicModel setValuesForKeysWithDictionary:dict];
                
                [self.allMusicModels addObject:musicModel];
                
                //            NSLog(@"%@",musicModel.ID);
                
                
//            }
        }
        
        
        // 当数据封装完毕,回调Block,因为操作的是UI,使用主线程
        dispatch_async(dispatch_get_main_queue(), ^{
           
            success(_allMusicModels);
        });
        
    });
    
    
}


/**
 *  懒加载方式初始化数组
 */
-(NSMutableArray *)allMusicModels{
    
    if (_allMusicModels == nil) {
        
        // set方法
        self.allMusicModels = [NSMutableArray array];
        
    }
    return _allMusicModels;
    
}

- (NSInteger)getIndexAccordingToTheModel:(MusicModel *)model{

    
    return [self.allMusicModels indexOfObject:model];
    
}


-(NSUInteger)getCountOfMusic{
    
    return self.allMusicModels.count;
}



- (MusicModel *)getMusicModelWithIndexPath:(NSUInteger)index{
    
    return self.allMusicModels[index];
}

@end
