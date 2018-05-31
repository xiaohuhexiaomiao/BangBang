//
//  UIImage+Resize.m
//  Aijia
//
//  Created by 黄黎雯 on 16/1/25.
//  Copyright © 2016年 黄黎雯. All rights reserved.
//

#import "UIImage+Resize.h"
#import "CXZ.h"
@implementation UIImage (Resize)
+ (UIImage *)imageWithName:(NSString *)name
{
    if (IOS7) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        UIImage *image = [UIImage imageNamed:newName];
        if (image == nil) { // 没有_os7后缀的图片
            image = [UIImage imageNamed:name];
        }
        return image;
    }
    
    // 非iOS7
    return [UIImage imageNamed:name];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}
@end
