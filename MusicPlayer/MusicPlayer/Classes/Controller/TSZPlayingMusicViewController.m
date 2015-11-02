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


@interface TSZPlayingMusicViewController ()<AVAudioPlayerDelegate>

//记录播放的音乐
@property (nonatomic , strong)TSZMusics *playingMusic;

//播放器
@property (nonatomic ,strong)AVAudioPlayer *player;

//进度的定时器
@property (nonatomic ,strong)NSTimer  *progressTimer;

//进度条滑动
- (IBAction)tapProgressBackground:(UITapGestureRecognizer *)sender;

- (IBAction)panSliderButton:(UIPanGestureRecognizer *)sender;

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

// 歌词的  view
@property (weak, nonatomic) IBOutlet UIView *lyricsView;

//点击显示歌词

- (IBAction)lyricsClickButton:(UIButton *)sender;



@end

@implementation TSZPlayingMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //剪裁显示时间的label
//    self.showTimeLabel.clipsToBounds = YES;
    self.showTimeLabel.layer.cornerRadius = 5.0;
    self.showTimeLabel.layer.masksToBounds = YES;
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
        [self addProgressTimer];
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
    //遵守代理
    self.player.delegate = self;
    
    
    //4、添加定时器
    [self addProgressTimer];
    [self updateInfo];
    //5、改变按钮的状态
    self.playOrPauseButton.selected = NO;
}

#pragma mark 对定时器的操作

//添加进度条的定时器
- (void)addProgressTimer{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
    //加入运行循环
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

/**
 * 移除定时器
 */
- (void)removeProgressTimer{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

#pragma mark 更新进度条

- (void)updateInfo{
    //1、更新播放比例
    CGFloat progressRatio = self.player.currentTime / self.player.duration;
    
    //2、更新滑块的位置
    self.sliderLeftConstraint.constant = progressRatio * (self.view.width - self.sliderButton.width);
    //3、更新滑块的文字
    NSString *currentTimerStr = [self stringWithTime:self.player.currentTime];
    [self.sliderButton setTitle:currentTimerStr forState:UIControlStateNormal];
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
        
        //移除定时器
        [self removeProgressTimer];
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

#pragma mark 把秒 转化为固定的格式
- (NSString *)stringWithTime:(NSTimeInterval)time {
    NSInteger minute = time / 60;
    NSInteger second = (NSInteger)time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
}


- (IBAction)tapProgressBackground:(UITapGestureRecognizer *)sender {
    
    //1、获取用户点击位置
    CGPoint point = [sender locationInView:sender.view];
    
    //2、改变silderB的约束
    if (point.x <= self.sliderButton.width *0.5) {
        self.sliderLeftConstraint.constant = 0;
    }else if(point.x >= self.view.width - self.sliderButton.width * 0.5){
        self.sliderLeftConstraint.constant = self.view.width - self.sliderButton.width -1;
    }else{
        self.sliderLeftConstraint.constant = point.x - self.sliderButton.width * 0.5;
    }
    //3、改变当前播放的时间
    CGFloat progressRatio = self.sliderLeftConstraint.constant / (self.view.width - self.sliderButton.width);
    CGFloat currentTime = progressRatio * self.player.duration;
    
    self.player.currentTime = currentTime;
    
    //更新文字
    [self updateInfo];
}

- (IBAction)panSliderButton:(UIPanGestureRecognizer *)sender {
    
    //1、获取用户点击位置
    CGPoint point = [sender locationInView:sender.view];
    
    //2、改变button 的约束
    if (point.x <= self.sliderButton.width * 0.5){
        self.sliderLeftConstraint.constant = 0;
    }else if(point.x >= self.view.width - self.sliderButton.width){
        self.sliderLeftConstraint.constant = self.sliderButton.width;
    }else {
        self.sliderLeftConstraint.constant = point.x - self.sliderButton.width * 0.5;
    }
    
}

#pragma mark  AVAuidoPlayer的代理方法

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        [self nextSong];
    }
}

//音乐打断开始
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    [self playOrPauseButton];
}

//打断结束

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player{
    [self playOrPauseButton];
}

#pragma mark 点击显示歌词

- (IBAction)lyricsClickButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    
    
}
@end
