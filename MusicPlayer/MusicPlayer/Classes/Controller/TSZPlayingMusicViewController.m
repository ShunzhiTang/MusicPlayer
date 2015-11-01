//
//  TSZPlayingMusicViewController.m
//  MusicPlayer
//
//  Created by Tsz on 15/10/31.
//  Copyright © 2015年 Tsz. All rights reserved.

#import "TSZPlayingMusicViewController.h"
#import "UIView+AdjustFrame.h"
#import "TSZMusics.h"
#import "TSZMusicTool.h"
#import <AVFoundation/AVFoundation.h>
#import "TSZAudioTool.h"
@interface TSZPlayingMusicViewController ()

//记录播放的音乐
@property (nonatomic , strong)TSZMusics *playingMusic;

//播放器
@property (nonatomic ,strong)AVAudioPlayer *player;

//音乐的label
@property (weak, nonatomic) IBOutlet UILabel *songLabel;

//歌手的  label
@property (weak, nonatomic) IBOutlet UILabel *songerLabel;

//歌手的封面
@property (weak, nonatomic) IBOutlet UIImageView *singerIcon;
//音乐总时长
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

//拖拽按钮
@property (weak, nonatomic) IBOutlet UIButton *sliderButton;

//拖拽按钮与左边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderLeftConstraint;
//显示 进度的时间
@property (weak, nonatomic) IBOutlet UILabel *showTimeLabel;

//暂定 播放
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;

//

@end

@implementation TSZPlayingMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark: 对控制器进行操作
/**
 *显示界面
 */

- (void)show{
    
    //0 、 判断音乐是否发生了变化
    if (self.playingMusic && self.playingMusic != [TSZMusicTool playingMusic]){
        //停止音乐
        [self stopPlayingMusic];
    }
    
    //分析 ，我们需要把这个控制器的view 添加到 window上
    
    //1、拿到window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    window.userInteractionEnabled = NO;
    //2、设置view的frame
    self.view.frame = window.bounds;
    
    //3、将自身添加到window上
    [window addSubview:self.view];
    
    
    //4、设置动画效果
    self.view.y = self.view.height;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        //开始 播放音乐
        [self startPlayingMusic];
    }];
}

#pragma mark 开始播放音乐
- (void)startPlayingMusic{
    
    //1、拿到正在播放的音乐
    TSZMusics *playingMusic = [TSZMusicTool playingMusic];
    if(playingMusic == self.playingMusic){
        
        return;
    }
    
    self.playingMusic = playingMusic;
    //2、设置界面基本信息
    self.songLabel.text = playingMusic.name;
    
    self.songerLabel.text = playingMusic.singer;
    
    self.singerIcon.image = [UIImage imageNamed:playingMusic.icon];
    

    //3、播放音乐
    
    self.player = [TSZAudioTool playMusicWithName:playingMusic.filename];
    //秒数 duration 播放器
    self.totalTimeLabel.text = [self stringWithTime:self.player.duration];
    
    //4、改变按钮的状态
    self.playOrPauseButton.selected = NO;
}

#pragma mark  停止播放音乐
- (void)stopPlayingMusic{
    //1、清除界面数据
    self.songerLabel.text = nil;
    self.songLabel.text = nil;
    self.singerIcon.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.totalTimeLabel.text = nil;
    
    //停止播放音乐
    [TSZAudioTool stopMusicWithName:self.playingMusic.filename];
}

//退出音乐播放
- (IBAction)exitPlay {
    //1、拿到window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    window.userInteractionEnabled = NO;
    
    //执行行动
    
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = self.view.height;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
}

//上一曲
- (IBAction)prefixSong {
    
    [self stopPlayingMusic];
    
    [TSZMusicTool previousMusic];
    
    [self startPlayingMusic];
}

//下一曲
- (IBAction)nextSong {
    [self stopPlayingMusic];
    
    [TSZMusicTool nextMusic];
    
    [self startPlayingMusic];
}

- (IBAction)playOrPause {
    self.playOrPauseButton.selected = !self.playOrPauseButton.selected;
    
    if (self.player.playing) {
        [self.player pause];
    }else{
        [self.player play];
    }
    
}

#pragma mark 把纳秒 转化为固定的格式
- (NSString *)stringWithTime:(NSTimeInterval)time {
    NSInteger minute = time / 60;
    NSInteger second = (NSInteger)time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
}


@end
