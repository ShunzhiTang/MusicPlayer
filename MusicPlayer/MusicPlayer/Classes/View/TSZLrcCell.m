//
//  TSZLrcCell.m
//  MusicPlayer
//
//  Created by Tsz on 15/11/1.
//  Copyright © 2015年 Tsz. All rights reserved.


#import "TSZLrcCell.h"
#import "TSZLyricsLine.h"

@implementation TSZLrcCell

//实现方法
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"LrcCell";
    
    TSZLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[TSZLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //1、去除cell 的背景
        cell.backgroundColor = [UIColor clearColor];
        
        //2、设置cell的文字为白色
        cell.textLabel.textColor = [UIColor whiteColor];
        
        //3、设置cell文字居中
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        //4、设置cell的选中样式
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return  cell;
}

//设置模型 数据

- (void)setLyriceLine:(TSZLyricsLine *)lyriceLine{
    
    _lyriceLine = lyriceLine;
    
    self.textLabel.text = lyriceLine.text;
}

@end
