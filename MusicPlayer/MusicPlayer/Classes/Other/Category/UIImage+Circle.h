//
//  UIImage+Circle.h
//  04-黑马音乐
//
//  Created by apple on 15-3-22.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Circle)

/**
 *  根据图片名称,返回一个圆形图片
 *
 *  @param name        图片的名称
 *  @param borderWidth 圆的边框
 *  @param borderColor 边框的颜色
 *
 *  @return 修剪后的图片
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
