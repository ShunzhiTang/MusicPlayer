//
//  TSZMusicTool.h
//  MusicPlayer
//
//  Created by Tsz on 15/10/31.
//  Copyright © 2015年 Tsz. All rights reserved.
//

//把数据模型进行封装到这个tools 中 ，便于管理

#import <Foundation/Foundation.h>

@class TSZMusics;
@interface TSZMusicTool : NSObject


/**
 *  获取所有的音乐数据
 *
 *  @return 所有的音乐数据
 */
+ (NSArray *)musics;

/**
 *  获取当前正在播放的音乐
 *
 *  @return 正在播放的音乐
 */
+ (TSZMusics *)playingMusic;

/**
 *  设置正在播放的音乐
 *
 *  @param playingMusic 正在播放的音乐
 */
+ (void)setPlayingMusic:(TSZMusics *)playingMusic;

/**
 *  获取下一首音乐
 *
 *  @return 下一首音乐
 */
+ (TSZMusics *)nextMusic;

/**
 *  获取上一首音乐
 *
 *  @return 上一首音乐
 */
+ (TSZMusics *)previousMusic;

@end
