//
//  UIImage+SWSubimage.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "UIImage+SWSubimage.h"

typedef NS_ENUM(NSUInteger, DiscardImageType) {
    
    DiscardImageUnkown = 0,
    DiscardImageTopSide = 1,
    DiscardImageRightSide = 2,
    DiscardImageBottomSide = 3,
    DiscardImageLeftSide = 4,
    
};

@implementation UIImage (SWSubimage)

/** 截取当前image对象rect区域内的图像 */
+ (UIImage *)subimageInRect:(UIImage *)image rect:(CGRect)rect {
    
    CGImageRef newImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    
    UIImage *img = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    
    return img;
    
}

/** 压缩图片至指定尺寸，会变形 */
+ (UIImage *)scaleImageNotKeepingRatio:(UIImage *)image targetSize:(CGSize)targetSize {
 
    CGRect rect = (CGRect){CGPointZero,targetSize};
    
    UIGraphicsBeginImageContext(rect.size);
    
    [image drawInRect:rect];
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
    
}

/** 压缩图片至指定像素点 */
+ (UIImage *)scaleImageAtPixel:(UIImage *)image pixel:(CGFloat)pixel {
    
    CGSize size = image.size;
    
    if(size.width <= pixel && size.height <= pixel) {
        
        return image;
        
    }
    
    CGFloat scale = size.width / size.height;
    
    if(size.width > size.height) {
        
        size.width = pixel;
        size.height = size.width / scale;
        
    } else {
        
        size.height = pixel;
        size.width = size.height / scale;
        
    }
    
    return [UIImage scaleImageNotKeepingRatio:image targetSize:size];
    
}

/** 在指定的size里面生成一个平铺的图片 */
+ (UIImage *)tiledImage:(UIImage *)image targetSize:(CGSize)targetSize {
    
    UIView *tempView = [[UIView alloc] init];
    
    tempView.bounds = (CGRect){CGPointZero, targetSize};
    
    tempView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    UIGraphicsBeginImageContext(targetSize);
    
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
}

/** UIView 转换为UIImage */
+ (UIImage *)imageWithView:(UIView *)view {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

/** 将两张图片生成一张图片 */
+ (UIImage *)mergeImage:(UIImage *)image otherImage:(UIImage *)otherImage {
    
    CGFloat width = image.size.width;
    
    CGFloat height = image.size.height;
    
    CGFloat otherWidth = image.size.width;
    
    CGFloat otherHeight = image.size.height;
    
    UIGraphicsBeginImageContext(image.size);
    
    [image drawInRect:CGRectMake(0, 0, width, height)];
    
    [otherImage drawInRect:CGRectMake(0, 0, otherWidth, otherHeight)];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
}

@end
