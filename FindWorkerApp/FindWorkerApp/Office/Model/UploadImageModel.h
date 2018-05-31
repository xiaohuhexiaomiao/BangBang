//
//  UploadImageModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/12/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UploadImageModel : NSObject

@property(nonatomic ,strong) UIImage *image;

@property(nonatomic ,copy)NSString *hashString;

@property(nonatomic ,copy)NSString *imageToken;

@property(nonatomic ,assign)NSInteger tag;

@property(nonatomic ,assign)BOOL is_webImage;

@property(nonatomic ,assign)CGFloat uploadProgress;

@property(nonatomic ,copy) void(^UploadImageProgress)(CGFloat progress ,NSInteger tag);

-(void)setImage:(UIImage *)image;

-(void)setHashString:(NSString *)hashString;

-(void)uploadPhotoWithImage;


@end
