//  ViewController.m
//  MusicPlayer
//
//  Created by Tsz on 15/10/31.
//  Copyright © 2015年 Tsz. All rights reserved.

#import "TSZTableViewController.h"
#import "MJExtension.h"
#import "TSZMusics.h"
#import "UIImage+Circle.h"
#import "TSZMusicTool.h"
#import "TSZAudioTool.h"
#import "TSZPlayingMusicViewController.h"
@interface TSZTableViewController ()

//跳转的控制器
@property (nonatomic , strong)TSZPlayingMusicViewController *plaingVc;

@end

@implementation TSZTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置cell的高度
    self.tableView.rowHeight = 80;
    
    
}

#pragma mark 懒加载控制器
-(TSZPlayingMusicViewController *)plaingVc{
    if (_plaingVc == nil) {
        _plaingVc = [[TSZPlayingMusicViewController alloc]init];
    }
    return  _plaingVc;
}


#pragma mark tableView的代理方法

//选中行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取消cell的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //得到整个数组
    TSZMusics *music = [TSZMusicTool musics][indexPath.row];
    [TSZMusicTool setPlayingMusic:music];
    
    //弹出这个控制器
    [self.plaingVc show];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TSZMusicTool musics].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //注册Identify
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    TSZMusics *music = [TSZMusicTool musics][indexPath.row];
    
    cell.imageView.image = [UIImage circleImageWithName:music.singerIcon borderWidth:5 borderColor:[UIColor orangeColor]];
    cell.textLabel.text = music.name;
    cell.detailTextLabel.text = music.singer;
    return  cell;
    
}

- (BOOL)prefersStatusBarHidden{
    return  YES;
    
}
@end
