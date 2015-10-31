//
//  TSZMusics.h
//  MusicPlayer
//
//  Created by Tsz on 15/10/31.
//  Copyright © 2015年 Tsz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSZMusics : NSObject
/**
 *  歌曲名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  歌曲对应的文件名称
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  歌词名称
 */
@property (nonatomic, copy) NSString *lrcname;

/**
 *  歌手
 */
@property (nonatomic, copy) NSString *singer;

/**
 *  歌手的头像
 */
@property (nonatomic, copy) NSString *singerIcon;

/**
 *  歌手的封面
 */
@property (nonatomic, copy) NSString *icon;
@end
