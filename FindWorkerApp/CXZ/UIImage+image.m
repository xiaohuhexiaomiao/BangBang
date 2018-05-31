//
//  UIImage+image.m
//  微博个人详情
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 XHR. All rights reserved.
//

#import "UIImage+image.h"

@implementation UIImage (image)

+(UIImage *)imageWithColor:(UIColor *)color {
    
    //设置图布大小1*1
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    //获取画布,开始渲染
    UIGraphicsBeginImageContext(rect.size);
    //获取画布上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //填充颜色
    CGContextSetFillColorWithColor(context,color.CGColor);
    //画一个圆
    CGContextFillRect(context, rect);
    //转换为UIImage
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //结束渲染
    UIGraphicsEndImageContext();
    
    return img;
}

@end
