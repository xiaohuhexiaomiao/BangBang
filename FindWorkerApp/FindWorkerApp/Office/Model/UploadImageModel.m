//
//  UploadImageModel.m
//  FindWorkerApp
//
//  Created by cxz on 2017/12/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "UploadImageModel.h"
#import "CXZ.h"

@implementation UploadImageModel


-(void)setImage:(UIImage *)image
{
    if (image) {
//        [self uploadPhotoWithImage:image];
        _image = image;
    }
}

-(void)setHashString:(NSString *)hashString
{
    if (hashString) {
        _hashString = hashString;
    }
}
#pragma mark 七牛相关

-(void)uploadPhotoWithImage
{
//     NSOperationQueue *queue = [NSOperationQueue mainQueue];
//
//    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
//        [[NetworkSingletion sharedManager]getQiNiuTokenWithSync:[NSString stringWithFormat:@"uid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]] onSucceed:^(NSDictionary *dict) {
////                     NSLog(@"**respond*%@",dict);
//            if ([dict[@"code"] integerValue]==0) {
//               _imageToken = [dict objectForKey:@"data"];
//                
//            }
//            
//        } OnError:^(NSString *error) {
//            
//        }];
//    }];
//    
//    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
//        [self uploadImageToQNFilePath:image token:self.imageToken];
//    }];
//    [queue addOperation:op1];
//    [queue addOperation:op2];
//    [op2 addDependency:op1];
    [[NetworkSingletion sharedManager]getQiNiuToken:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]} onSucceed:^(NSDictionary *dict) {
//         NSLog(@"**respond*%@",dict);
        if ([dict[@"code"] integerValue]==0) {
            _imageToken = [dict objectForKey:@"data"];
            [self uploadImageToQNFilePath:self.image token:self.imageToken];
        }
    } OnError:^(NSString *error) {
        
    }];
    
}

- (void)uploadImageToQNFilePath:(UIImage*)image token:(NSString*)imageToken{
    
    NSString *filePath = [self getImagePath:image];
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    __weak typeof(self) weakself = self;
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
//         NSLog(@"**respond*%@*%@",@(self.tag),@(percent*100.0));
        weakself.uploadProgress = percent*100.0;
        if (_UploadImageProgress) {
            _UploadImageProgress(percent*100,weakself.tag);
        }
       
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:filePath key:nil token:imageToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        //        NSLog(@"info ===== %@", info);
        //        NSLog(@"resp ===== %@", resp);
//         NSLog(@"**respond2*%",@(self.tag));
        self.hashString = [resp objectForKey:@"hash"];
        
     
    }
                option:uploadOption];
    
    
}

//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image
{
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [NSString stringWithFormat:@"/theImage%li.png",self.tag];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}



@end
