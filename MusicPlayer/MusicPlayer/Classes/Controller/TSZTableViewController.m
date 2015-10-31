//  ViewController.m
//  MusicPlayer
//
//  Created by Tsz on 15/10/31.
//  Copyright © 2015年 Tsz. All rights reserved.

#import "TSZTableViewController.h"
#import "MJExtension.h"
#import "TSZMusics.h"
#import "UIImage+Circle.h"


@interface TSZTableViewController ()

//声明一个 全局属性
@property (nonatomic , strong)NSArray *music;
@end

@implementation TSZTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置cell的高度
    self.tableView.rowHeight = 80;
    
    
}

//数组懒加载
- (NSArray *)music {
    
    if (_music == nil) {
        self.music = [TSZMusics objectArrayWithFilename:@"Musics.plist"];
    }
    return _music;
}


#pragma mark tableView的代理方法

//选中行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取消cell的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.music.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //注册Identify
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    TSZMusics *music = self.music[indexPath.row];
    
    cell.imageView.image = [UIImage circleImageWithName:music.singerIcon borderWidth:5 borderColor:[UIColor orangeColor]];
    cell.textLabel.text = music.name;
    cell.detailTextLabel.text = music.singer;
    return  cell;
    
}
@end
