//
//  CXZImageUtil.m
//  ImHere
//
//  Created by 卢明渊 on 15-3-10.
//  Copyright (c) 2015年 我在这. All rights reserved.
//

#import "CXZImageUtil.h"
#import "CXZ.h"
#import "UIImageView+WebCache.h"
#import "ConfigUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DDPhotoListViewController.h"

@implementation CXZImageUtil


+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize) size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//跳转图片旋转
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//最大公约数
+ (int)gcda:(int)a b:(int)b {
    int r;
    while(b != 0) {
        r = a % b;
        a = b;
        b = r;
    }
    if(a <= 0) {
        return 1;
    }
    return a;
}

//缩放尺寸到size
+ (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize) size {
    UIImage *finalImage = [CXZImageUtil fixOrientation:image];
    CGImageRef imgRef = [finalImage CGImage];
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    if(width <= size.width || height <= size.height) {
        return finalImage;
    }
    
    int r = [CXZImageUtil gcda:width b:height];
    int width1 = width / r;
    int height1 = height / r;
    
    float vRadio = size.height*1.0/height1;
    float hRadio = size.width*1.0/width1;
    float radio = 1;
    if(vRadio>1 && hRadio>1) {
        radio = hRadio > vRadio ? vRadio : hRadio;
        radio = ceil(radio);
    }
    
    width = width1*radio;
    height = height1*radio;
    
    CGSize newSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage* scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}


//压缩图片，尺寸默认屏幕尺寸
+ (UIImage*)ZIPUIImage:(UIImage*)image {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    return [CXZImageUtil ZIPUIImage:image size:size];
}

//压缩图片，尺寸为size
+ (UIImage*)ZIPUIImage:(UIImage*)image size:(CGSize)size {
    NSData* data = [CXZImageUtil ZIPUIImageBackData:image size:size];
    return [UIImage imageWithData:data];
}

//压缩图片，返回nsdata
+ (NSData*)ZIPUIImageBackData:(UIImage*)image size:(CGSize)size {
    UIImage* scaleImage = [self scaleImage:image toSize:CGSizeMake(size.width, size.height)];
    return [CXZImageUtil ZIPImageSize:scaleImage];
}

//质量压缩图片
+ (NSData*)ZIPImageSize:(UIImage*)image {
    CGFloat rate = 0.7;
    NSData* data = UIImageJPEGRepresentation(image, rate);
    while([data length] > 184320 && rate > 0.05) {
        rate -= 0.1;
        data = UIImageJPEGRepresentation(image, rate);
    }
    return data;
}

//对于一个图片进行中间剪裁
+ (UIImage*)imageWithCenterCrop:(UIImage *)src targetSize:(CGSize)targetSize {
    
    CGFloat width = CGImageGetWidth(src.CGImage);
    CGFloat height = CGImageGetHeight(src.CGImage);
    
    CGRect rect;
    if(width * targetSize.height > height * targetSize.width) {
        rect = CGRectMake((CGImageGetWidth(src.CGImage) - (targetSize.width/targetSize.height) * height) / 2, 0, width, height);
    }
    else {
        rect = CGRectMake(0, (CGImageGetHeight(src.CGImage) - (targetSize.height/targetSize.width) * width) / 2, width, height);
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(src.CGImage, rect);
    
    CGRect smallBounds = CGRectMake(0, 0, targetSize.width, targetSize.height);
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

//获取聊天图片压缩的系数
+ (CGFloat)getChatZipRate:(UIImage*)image {
    CGFloat rate = 0.45;
    NSData* data = UIImageJPEGRepresentation(image, rate);
    while([data length] > 1638400 && rate > 0.05) {
        rate -= 0.1;
        data = UIImageJPEGRepresentation(image, rate);
    }
    return rate;
}

+ (void) showHeadImage:(NSString *)head withImageView:(UIImageView*) view {
    if(IS_EMPTY(head)) {
        [view setImage:[UIImage imageNamed:@"default_avatar"]];
    }
    else {
        if ([head rangeOfString:@"http"].location != NSNotFound) {
            [view sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        } else {
            NSArray* array = [head componentsSeparatedByString:@","];
            NSString* url = [NSString stringWithFormat:@"%@%@", IMAGE_HOST, [array objectAtIndex:0]];
            NSLog(@"MYdata%@",url);
           
            NSString* thumbUrl = [CXZImageUtil thumbName:url];
            NSLog(@"thumbUrl%@",thumbUrl);
            [view sd_setImageWithURL:[NSURL URLWithString:thumbUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"] options:SDWebImageRetryFailed];
        }
    }
}

+ (void) showPicImage:(NSString *)head withImageView:(UIImageView*) view size:(CGSize)size {
    if(IS_EMPTY(head)) {
        [view setImage:[CXZImageUtil imageWithColor:HexRGB(0xeeeeee) Size:size]];
    }
    else {
        if ([head rangeOfString:@"http"].location != NSNotFound) {
            [view sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[CXZImageUtil imageWithColor:HexRGB(0xeeeeee) Size:size]];
        } else {
            NSArray* array = [head componentsSeparatedByString:@","];
            NSString* url = [NSString stringWithFormat:@"%@%@", IMAGE_HOST, [array objectAtIndex:0]];
            NSLog(@"MYdata%@",url);
            
            NSString* thumbUrl = [CXZImageUtil thumbName:url];
            NSLog(@"thumbUrl%@",thumbUrl);
            [view sd_setImageWithURL:[NSURL URLWithString:thumbUrl] placeholderImage:[CXZImageUtil imageWithColor:HexRGB(0xeeeeee) Size:size] options:SDWebImageRetryFailed];
        }
    }
}

//返回缩略图文件名  xxx.yyy  ->   xxx_thumb.yyy
+ (NSString*) thumbName:(NSString*)name {
    if(IS_EMPTY(name)) {
        return name;
    }
    NSString* filename = [name lastPathComponent];
    filename = [NSString stringWithFormat:@"m_%@", filename];
    NSString* finalStr = [NSString stringWithFormat:@"%@/%@", [name stringByDeletingLastPathComponent], filename];
    return finalStr;
}

+ (void)pickPhotosLimit:(NSInteger)limit Orignal:(BOOL)orignal ChooseDelegate:(id<DDChoosePhotoDelegate>)delegate ViewController:(UIViewController*)controller {
    
    BOOL everPicker = [ConfigUtil boolWithKey:PICK_IMAGE_FLAG];
    if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized || !everPicker) {
        [ConfigUtil saveBool:YES withKey:PICK_IMAGE_FLAG];
        UIStoryboard* story = [UIStoryboard storyboardWithName:@"photo" bundle:nil];
        UINavigationController* nav = [story instantiateViewControllerWithIdentifier:@"ChoosePhotoNav"];
        DDPhotoListViewController* listController = [nav.viewControllers objectAtIndex:0];
        listController.limit = limit;
        listController.orignal = orignal;
        listController.delegate = delegate;
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [controller presentViewController:nav animated:YES completion:nil];
    }
    else {
        UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"照片权限未开启"
                                                         message:@"请在手机设置－隐私－照片开启照片访问权限以选择照片上传"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
        [prompt setAlertViewStyle:UIAlertViewStyleDefault];
        [prompt show];
    }
     
}

+ (void)takePhoto:(UIViewController *)controller TakeDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)takeDelegate {
    
    BOOL everTake = [ConfigUtil boolWithKey:TACK_IMAGE_FLAG];
    BOOL authed = YES;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if(!(IOS7 && [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized)) {
        authed =  NO;
    }
#endif
    if ((authed && [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) || !everTake){
        [ConfigUtil saveBool:YES withKey:TACK_IMAGE_FLAG];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = takeDelegate;
        //设置拍照后的图片不可被编辑，因为使用自己的剪裁
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [controller presentViewController:picker animated:YES completion:nil];
    }
    else {
        UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"相册权限未开启"
                                                         message:@"请在手机设置－隐私－相机开启相册权限以拍照上传照片"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
        [prompt setAlertViewStyle:UIAlertViewStyleDefault];
        [prompt show];
    }
}

+(CGSize)pngImageSizeWithHeaderData:(NSString *)urlStr{
    // 初始化请求, 这里是变长的, 方便扩展
   NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    // 发送同步请求, data就是返回的数据
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return CGSizeZero;
    }
    int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    [data getBytes:&w3 range:NSMakeRange(2, 1)];
    [data getBytes:&w4 range:NSMakeRange(3, 1)];
    int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
    
    int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
    [data getBytes:&h1 range:NSMakeRange(4, 1)];
    [data getBytes:&h2 range:NSMakeRange(5, 1)];
    [data getBytes:&h3 range:NSMakeRange(6, 1)];
    [data getBytes:&h4 range:NSMakeRange(7, 1)];
    int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
    
    return CGSizeMake(w, h);
}

+(CGSize)jpgImageSizeWithHeaderData:(NSString *)urlStr{
    // 初始化请求, 这里是变长的, 方便扩展
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

@end
