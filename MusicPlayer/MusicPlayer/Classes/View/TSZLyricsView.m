//
//  TSZLyricsView.m
//  MusicPlayer
//
//  Created by Tsz on 15/11/1.
//  Copyright © 2015年 Tsz. All rights reserved.

#import "TSZLyricsView.h"
#import "UIView+AdjustFrame.h"
#import "TSZLrcCell.h"
#import "TSZLyricsLine.h"
@interface TSZLyricsView () <UITableViewDataSource , UITableViewDelegate>
@property (nonatomic , weak) UITableView *tableView;
@property (nonatomic , weak)NSArray *lrcLines;

@property (nonatomic , assign) NSInteger currentIndex;

@end

@implementation TSZLyricsView


//设置界面的基础信息 ，在ios 7、 8 可以写在 initWithCoder，ios 9 就必须写在 awakeFromNib


- (void)awakeFromNib{

    [self setupTableView];
}

#pragma  mark 准备 tableVIew的界面

- (void)setupTableView{
    
    UITableView *tableView = [[UITableView alloc]init];
    
    tableView.frame = self.bounds;
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self addSubview:tableView];
    self.tableView = tableView;
    
    self.currentIndex = -1;
}

// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0, self.tableView.height * 0.5, 0);
    NSLog(@"layoutSubviews");
    NSLog(@"%@", NSStringFromCGRect(self.bounds));
}

#pragma mark 实现tableView的 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.lrcLines.count;
}

//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1、创建cell
    TSZLrcCell *cell = [TSZLrcCell lrcCellWithTableView:tableView];
    
    //2、给cell设置数据
    cell.lyriceLine= self.lrcLines[indexPath.row];
    return  cell;
}

#pragma mark 保存歌词的set方法
- (void)setLrcname:(NSString *)lrcname{
    //1、保存歌词
    _lrcname = lrcname;
    
    //2、 加载对应的歌词
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcname ofType:nil];
    
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //3、解析歌词
    
    NSArray *lrcLineStrs = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSString *lrcStr in lrcLineStrs) {
        //3.2 、不是歌词前面的 ，也不是 空行
        if([lrcStr hasPrefix:@"[ti"] || [lrcStr hasPrefix:@"[ar"] || [lrcStr hasPrefix:@"[al"] || ![lrcStr hasPrefix:@"["]){
            continue;
        }
        
        //3.3、截取 没一行的字符串
        
        NSArray *lrcLineStringParts = [lrcStr componentsSeparatedByString:@"]"];
        TSZLyricsLine *lyrics = [[TSZLyricsLine alloc] init];
        lyrics.text = [lrcLineStringParts lastObject];
        lyrics.text = [[lrcLineStringParts firstObject]  substringFromIndex:1];
        
        //将模型对象添加到数组
        [temp addObject:lyrics];
    }
    self.lrcLines = temp.copy;
    
    //刷新数据
    [self.tableView reloadData];
}

#pragma mark 当前的时间的 set 方法

- (void)setCurrentTime:(NSTimeInterval)currentTime{
    
    if (_currentTime > currentTime) {
        self.currentIndex = -1;
    }
    
    //保存 当前的时间
    _currentTime = currentTime;
    
}


@end
