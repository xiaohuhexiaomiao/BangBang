//
//  UIImage+SWSubimage.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SWSubimage)

/** 截取当前image对象rect区域内的图像 */
+ (UIImage *)subimageInRect:(UIImage *)image rect:(CGRect)rect;

/** 压缩图片至指定尺寸，会变形 */
+ (UIImage *)scaleImageNotKeepingRatio:(UIImage *)image targetSize:(CGSize)targetSize;

/** 压缩图片至指定像素点 */
+ (UIImage *)scaleImageAtPixel:(UIImage *)image pixel:(CGFloat)pixel;

/** 在指定的size里面生成一个平铺的图片 */
+ (UIImage *)tiledImage:(UIImage *)image targetSize:(CGSize)targetSize;

/** UIView 转换为UIImage */
+ (UIImage *)imageWithView:(UIView *)view;

/** 将两张图片生成一张图片 */
+ (UIImage *)mergeImage:(UIImage *)image otherImage:(UIImage *)otherImage;

/** 不变形拉伸 */
+ (UIImage *)scaleImageKeepingRadio:(UIImage *)image targetSize:(CGSize)targetSize;

@end
