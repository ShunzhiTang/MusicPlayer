//
//  TSZLyricsView.h
//  MusicPlayer
//
//  Created by Tsz on 15/11/1.
//  Copyright © 2015年 Tsz. All rights reserved.
//

#import "DRNRealTimeBlurView.h"
@interface TSZLyricsView : DRNRealTimeBlurView

@property (nonatomic ,copy) NSString *lrcname;

@property (nonatomic ,assign) NSTimeInterval currentTime;
@end
