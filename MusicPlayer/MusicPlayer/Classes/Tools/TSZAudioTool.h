//
//  TSZAudioTool.h
//  MusicPlayer
//
//  Created by Tsz on 15/10/31.
//  Copyright © 2015年 Tsz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface TSZAudioTool : NSObject

/**
 * 播放音乐
 *
 * @param musicName: 音乐名称  返回的是
 */
+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName;


/**
 *  暂停音乐
 *
 *  @param musicName 音乐名称
 */
+ (void)pauseMusicWithName:(NSString *)musicName;

/**
 *  停止音乐
 *
 *  @param musicName 音乐名称
 */
+ (void)stopMusicWithName:(NSString *)musicName;

/**
 *  播放音效
 *
 *  @param soundName 音效名称
 */
+ (void)playSoundWithName:(NSString *)soundName;

/**
 *  销毁音效
 *
 *  @param soundName 音效名称
 */
+ (void)disposeSoundWihtName:(NSString *)soundName;


@end
