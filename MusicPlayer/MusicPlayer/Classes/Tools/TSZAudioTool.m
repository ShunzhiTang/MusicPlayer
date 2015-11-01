//
//  TSZAudioTool.m
//  MusicPlayer
//
//  Created by Tsz on 15/10/31.
//  Copyright © 2015年 Tsz. All rights reserved.
//
/**
 * 播放 音频的工具类的实现
    包括  音乐长 的，音效短的
 */

/**
    播放声音的原理：
 
*/

#import "TSZAudioTool.h"

@implementation TSZAudioTool

static NSMutableDictionary *_soundIDs;
static NSMutableDictionary *_musics;

#pragma mark -播放音乐
+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName{
    
    //0、判断音乐的是否为空
    assert(musicName);
    
    //取出 播放器
    AVAudioPlayer *player = _musics[musicName];
    
    //2、判断播放器的是否为nil
    if (player == nil){
        
        //2.0、获取资源URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        
        //2.1、创建播放器对象
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        //2.2、准备播放
        [player prepareToPlay];
        
        //2.3、存入字典中
        _musics[musicName] = player;
    }
    
    //3、播放音乐
    [player play];
    
    return player;
    
}

//暂停播放器
+ (void)pauseMusicWithName:(NSString *)musicName{
    assert(musicName);
    
    //取出播放器
    
    AVAudioPlayer *player = _musics[musicName];
    
    if (player) {
        [player pause];
    }
}

//停止播放器
+ (void)stopMusicWithName:(NSString *)musicName{
    assert(musicName);
    
    AVAudioPlayer *player = _musics[musicName];
    
    if (player) {
        [player stop];
    }
}


#pragma mark: 播放音效
+ (void)playSoundWithName:(NSString *)soundName{
    //1、从字典中取出音效的soundID
    SystemSoundID soundID = [_soundIDs[soundName] unsignedIntValue];
    
    //2、取出如果是 0 就进行获取   ==0 相当于 初始化
    if (soundID == 0){
        //2.1、获取资源的URL
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        
        //2.2、给soundID赋值
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &soundID);
        
        //2.3、给soundID 放入字典
        _soundIDs[soundName] = @(soundID);
    }
    //3、播放音效
    AudioServicesPlayAlertSound(soundID);
}

//音效的销毁
+ (void)disposeSoundWihtName:(NSString *)soundName{
    //1、从字典  取出 音效的额ID
    SystemSoundID soundID = [_soundIDs[soundName] unsignedIntValue];
    
    //2、给soundID 有值 就进行销毁
    if (soundName){
        AudioServicesDisposeSystemSoundID(soundID);
    }
}

@end
