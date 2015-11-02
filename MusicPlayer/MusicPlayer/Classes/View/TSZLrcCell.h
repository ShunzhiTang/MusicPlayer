//
//  TSZLrcCell.h
//  MusicPlayer
//
//  Created by Tsz on 15/11/1.
//  Copyright © 2015年 Tsz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSZLyricsLine;

@interface TSZLrcCell : UITableViewCell

//传入数据的模型
@property (nonatomic ,strong)TSZLyricsLine *lyriceLine;

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;
@end
