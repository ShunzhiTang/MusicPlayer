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
#import "TSZLyricsView.h"
#import <MediaPlayer/MediaPlayer.h>
@interface TSZPlayingMusicViewController ()<AVAudioPlayerDelegate,AVAudioSessionDelegate>

//记录播放的音乐
@property (nonatomic , strong)TSZMusics *playingMusic;

//播放器
@property (nonatomic ,strong)AVAudioPlayer *player;

//进度的定时器
@property (nonatomic ,strong)NSTimer  *progressTimer;

//歌词的定时器
@property (nonatomic ,strong)CADisplayLink *lrcTimer;

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
@property (weak, nonatomic) IBOutlet TSZLyricsView *lyricsView;

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
        [self addLrcTimer];
        return;
    }
    
    self.playingMusic = playingMusic;
    
    //2、设置界面基本信息
    self.songLabel.text = playingMusic.name;
    
    self.songerLabel.text = playingMusic.singer;
    
    self.singerIcon.image = [UIImage imageNamed:playingMusic.icon];
    
    self.lyricsView.lrcname = playingMusic.lrcname;
    //3、播放音乐
    self.player = [TSZAudioTool playMusicWithName:playingMusic.filename];
    
    //秒数 duration 播放器
    self.totalTimeLabel.text = [self stringWithTime:self.player.duration];
    //遵守代理
    self.player.delegate = self;
    
    
    //4、添加定时器
    [self addProgressTimer];
    [self updateInfo];
    
    [self addLrcTimer];
    [self updateLrcTime];
    
    //5、改变按钮的状态
    self.playOrPauseButton.selected = NO;
    
    //6、锁屏实现 开启信息
    [self updateLockInfo];
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

#pragma mark 添加歌词的定时器
-(void)addLrcTimer{
    
    if (self.lyricsView.hidden) {
        return;
    }
    
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcTime)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self updateLrcTime];
    
}
//移除歌词的定时器
- (void)removeLrcTimer{
    [self.lrcTimer invalidate];
    
    self.lrcTimer = nil;
}

#pragma mark 更新歌词
- (void)updateLrcTime{
    self.lyricsView.currentTime = self.player.currentTime;
    //更新歌词
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
    
    //3、移除定时器
    [self removeLrcTimer];
    [self removeProgressTimer];
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
        [self removeLrcTimer];
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
        [self removeProgressTimer];
        [self removeLrcTimer];
        
    }else{
        [self.player play];
        [self addProgressTimer];
        [self addLrcTimer];
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
    if (point.x <= self.sliderButton.width * 0.5) {
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
    
    [sender setTranslation:CGPointZero inView:sender.view];
    
    //2、改变button 的约束
    if (self.sliderLeftConstraint.constant + point.x <= 0){
        
        self.sliderLeftConstraint.constant = 0;
        
    }else if(self.sliderLeftConstraint.constant +  point.x >= self.view.width - self.sliderButton.width * 0.5){
        self.sliderLeftConstraint.constant = self.view.width -  self.sliderButton.width -1 ;
        
    }else {
        
        self.sliderLeftConstraint.constant += point.x;
    }
    
    //3、获取拖拽进度对应的 播放时间
    CGFloat progressRatio = self.sliderLeftConstraint.constant / (self.view.width - self.sliderButton.width);
    CGFloat currentTime = progressRatio * self.player.duration;
    
    //4、更新文字
    NSString *currentTimeStr = [self stringWithTime:currentTime];
    
    [self.sliderButton setTitle:currentTimeStr forState:UIControlStateNormal];
    
    self.showTimeLabel.text = currentTimeStr;
    
    
    //监听拖拽手势
    
    if (sender.state  == UIGestureRecognizerStateBegan){
        
        // 移除 定时器
        [self removeProgressTimer];
        
        self.showTimeLabel.hidden = NO;
        
    }else if(sender.state == UIGestureRecognizerStateEnded){
        
        //更新播放器时间
        self.player.currentTime = currentTime;
        
        // 添加定时器
        [self addProgressTimer];
        
        self.showTimeLabel.hidden = YES;
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
    
    self.lyricsView.hidden = !self.lyricsView.hidden;
    
    if(self.lyricsView.hidden){
        [self removeLrcTimer];
    }else{
        [self addLrcTimer];
    }
}


#pragma mark:显示锁屏 信息
- (void)updateLockInfo{
    //1、获取当前的播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    //2、设置显示信息
    NSMutableDictionary * infos = [NSMutableDictionary dictionary];
    
    //2.1、歌曲的名称
    infos[MPMediaItemPropertyAlbumTitle] = self.playingMusic.name;
    
    //2.2、设置歌手的名称
    infos[MPMediaItemPropertyAlbumArtist] = self.playingMusic.singer;
    
    //2.3 、设置歌曲封面
    infos[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:self.playingMusic.icon]];
    
    //2.4、设置歌曲总时长
    infos[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    
    //2.5、设置当前播放时间
    infos[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.player.currentTime);
    
    //赋值
    [center setNowPlayingInfo:infos];
    
    
    //3、 开启监听远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //4、成为第一响应者
    [self becomeFirstResponder];
    
}

- (BOOL)canBecomeFirstResponder{
    return  YES;
}

#pragma mark 点击功能键可以实现  对应的功能
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            //播放暂停
            [self playOrPauseButton];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            //下一首
            [self nextSong];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            //前一首
            [self prefixSong];
            break;
        default:
            break;
    }
}


@end
