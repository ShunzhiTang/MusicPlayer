//
//  TSZMusicTool.m
//  MusicPlayer
//
//  Created by Tsz on 15/10/31.
//  Copyright © 2015年 Tsz. All rights reserved.
//

#import "TSZMusicTool.h"
#import "TSZMusics.h"
#import "MJExtension.h"
@implementation TSZMusicTool

//定义一个数组进行保存音乐的数据
static NSArray *_musics;

//当前正在 播放的音乐
static TSZMusics *_playingMusic;

//在加载类的时间进行数据的存储
+ (void)initialize{
    _musics = [TSZMusics objectArrayWithFilename:@"Musics.plist"];
}


#pragma mark 实现定义的tools方法
//获取数据
+ (NSArray *)musics{
    return _musics;
}

+ (TSZMusics *)playingMusic{
    return _playingMusic;
}

+(void)setPlayingMusic:(TSZMusics *)playingMusic{
    assert(playingMusic);
    _playingMusic = playingMusic;
}

//下一首
+ (TSZMusics *)nextMusic{
    //1、获取当前正在播放的音乐
    NSInteger  currentIndex  = [_musics indexOfObject:_playingMusic];
    
    currentIndex++;
    
    //2、判断是否越界
    if (currentIndex > _musics.count -1){
        currentIndex = 0;
    }
    
    //3、取出下一首 音乐
    TSZMusics *nextmusic  = _musics[currentIndex];
    
    //赋值当前播放 音乐
    _playingMusic = nextmusic;
    
    return  nextmusic;
}

//上一首
+ (TSZMusics *)previousMusic{
   
    //1、获取当前正在播放的音乐
    NSInteger currentIdex = [_musics indexOfObject:_playingMusic];
    
    //2、判断是否越界
    if (currentIdex < 0) {
        currentIdex = _musics.count -1;
    }
    
    //3、取出音乐
    TSZMusics *previousMusic = _musics[currentIdex];
    _playingMusic = previousMusic;
    
    return  previousMusic;
}


@end
