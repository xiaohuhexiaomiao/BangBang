//
//  UIImage+Resize.h
//  Aijia
//
//  Created by 黄黎雯 on 16/1/25.
//  Copyright © 2016年 黄黎雯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)
/**
 *  加载图片
 *
 *  @param name 图片名
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
@end
