//
//  MusicListTableViewController.m
//  JYC_MusicPlayer
//
//  Created by 蒋永昌 on 16/1/6.
//  Copyright © 2016年 蒋永昌. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "PlayerViewController.h"
#import "MusicListTableViewCell.h"
#import "PlayerManager.h"
#import "MusicModel.h"
#import "DataHelper.h"
#import "Urls.h"

#define HELPER [DataHelper shareDataHelper]

@interface MusicListTableViewController ()<UISearchBarDelegate>

@property(nonatomic,strong)UISearchBar *searchBar;

@property(nonatomic,assign)NSInteger searchIndex;

//@property(nonatomic,strong)MusicModel *model;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *data1Array;

@property(nonatomic,strong)NSMutableArray *indexPathArray;

@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.dataArray = [NSMutableArray array];
    
    self.indexPathArray = [NSMutableArray array];
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1.jpg"]];
    
    
    // 注册
    UINib *nib = [UINib nibWithNibName:@"MusicListTableViewCell" bundle:nil];
    // 注册cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"listCell"];
    
    
    self.tableView.rowHeight = 90;// 行高
    
    // 网路数据请求与解析
    [HELPER requestAllMusicModelsWithUrlString:kPlaylistURL DidFinish:^(NSMutableArray *array) {
        
        self.dataArray = array;
        self.data1Array = self.dataArray;

        
//        NSLog(@"%@",self.dataArray);
        // 刷新表示图
        [self.tableView reloadData];
        
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showPlayerDetail:)];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changIndexPathArray:) name:@"indexArrayInclude" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    return [HELPER getCountOfMusic];
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
    // 之前的版本
//    cell.music = [HELPER getMusicModelWithIndexPath:indexPath];
    
    MusicModel *model = self.dataArray[indexPath.row];

    cell.music = model;
    
    //
//    cell.music = [HELPER getMusicModelWithIndexPath:indexPath.row];

    
    return cell;
}


- (void)changIndexPathArray:(NSNotification *)notificatio{
    
    [self.indexPathArray removeAllObjects];
    
    NSString *indexStr = notificatio.object;
    
    [self.indexPathArray addObject:indexStr];
    
}

// 点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.indexPathArray removeAllObjects];
    [self.indexPathArray addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    
    
    // 获取播放页面对象(单例)
    PlayerViewController *playerVC = [PlayerViewController sharePlayerViewController];
    
    // 准备播放
//    [[PlayerManager defaultManager] prepareMusicWithIndex:indexPath.row];
    
    
    MusicModel *model = self.dataArray[indexPath.row];
    
    self.searchIndex = [[DataHelper shareDataHelper]getIndexAccordingToTheModel:model];
    
    if (self.searchIndex) {
        
        playerVC.index = self.searchIndex;
    }else{
        
        playerVC.index = indexPath.row;
 
    }
    

    
    // 跳转到播放页面
    [self.navigationController showViewController:playerVC sender:self];
    
}

- (void)showPlayerDetail:(UIBarButtonItem *)sender{
    
    // 获取播放页面对象(单例)
    PlayerViewController *playerVC = [PlayerViewController sharePlayerViewController];

    if (self.indexPathArray.count > 0) {
        
        NSInteger index = [self.indexPathArray.lastObject integerValue];
        
        MusicModel *model = self.dataArray[index];

        self.searchIndex = [[DataHelper shareDataHelper]getIndexAccordingToTheModel:model];
        
        if (self.searchIndex) {
            
            playerVC.index = self.searchIndex;
        }else{
            
            playerVC.index = index;
            
        }

        
//        playerVC.index = self.searchIndex;

    }else{
        
        // 准备播放
        //    [[PlayerManager defaultManager] prepareMusicWithIndex:indexPath.row];
        
        
        MusicModel *model = self.dataArray[0];
        
        self.searchIndex = [[DataHelper shareDataHelper]getIndexAccordingToTheModel:model];
        
        if (self.searchIndex) {
            
            playerVC.index = self.searchIndex;
        }else{
            
            playerVC.index = 0;
            
        }

        
//        playerVC.index = self.searchIndex;

    }
    
    

    
    
    
    // 跳转到播放页面
    [self.navigationController showViewController:playerVC sender:self];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    
    self.searchBar.delegate =self;

    
    return self.searchBar;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

#pragma mark------------searchBar代理方法-----------

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    if ([searchText isEqualToString:@""]) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.dataArray = self.data1Array;
            
            [self.tableView reloadData];
            
        });


        
    }else{
        
        self.dataArray = self.data1Array;
        
        NSMutableArray *array = [NSMutableArray array];
        
        
        for (MusicModel *model in self.data1Array) {
            
            
            if ([model.name containsString:searchText]) {
                
                [array addObject:model];
                
            }
            
            
        }
        
//        [DataHelper shareDataHelper].searchBlock(array);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.dataArray = array;
            
            
            [self.tableView reloadData];
            
        });
}

    
    
    
    NSLog(@"hahah");
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
