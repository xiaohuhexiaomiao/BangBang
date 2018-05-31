//
//  CXZImageUtil.h
//  ImHere
//
//  Created by 卢明渊 on 15-3-10.
//  Copyright (c) 2015年 我在这. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DDChoosePhotoViewController.h"

@interface CXZImageUtil : NSObject

+ (UIImage*) imageWithColor:(UIColor*) color Size:(CGSize) size;

// 调整图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//压缩图片，尺寸默认屏幕尺寸
+ (UIImage*)ZIPUIImage:(UIImage*)image;

//压缩图片，尺寸为size
+ (UIImage*)ZIPUIImage:(UIImage*)image size:(CGSize)size;

//对于一个图片进行中间剪裁
+ (UIImage*)imageWithCenterCrop:(UIImage *)src targetSize:(CGSize)targetSize;

//获取聊天图片压缩的系数
+ (CGFloat)getChatZipRate:(UIImage*)image;

// 显示头像
+ (void) showHeadImage:(NSString *)head withImageView:(UIImageView*) view;

//显示图片
+ (void) showPicImage:(NSString *)head withImageView:(UIImageView*) view size:(CGSize)size;

//返回缩略图文件名  xxx.yyy  ->   xxx_thumb.yyy
+ (NSString*) thumbName:(NSString*)name;

// 从相册获取图片
+ (void)pickPhotosLimit:(NSInteger)limit Orignal:(BOOL)orignal ChooseDelegate:(id<DDChoosePhotoDelegate>)delegate ViewController:(UIViewController*)controller;

// 从相机获取图片
+ (void)takePhoto:(UIViewController *)controller TakeDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)takeDelegate;

//预加载png图片大小
+(CGSize)pngImageSizeWithHeaderData:(NSString *)urlStr;

//预加载png图片大小
+(CGSize)jpgImageSizeWithHeaderData:(NSString *)urlStr;
@end
