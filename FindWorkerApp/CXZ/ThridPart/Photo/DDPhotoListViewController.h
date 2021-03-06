//
//  DDPhotoListViewController.h
//  DiaoDiao
//
//  Created by wangzeng on 14-10-23.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDChoosePhotoViewController.h"
#import "CXZBaseTableViewController.h"
@import Photos;
typedef enum {
    QBImagePickerFilterTypeAllAssets,
    QBImagePickerFilterTypeAllPhotos,
    QBImagePickerFilterTypeAllVideos
} QBImagePickerFilterType;

@protocol DDChoosePhotoDelegate <NSObject>

@required
- (void)choosePhotos:(NSArray*)data;
- (void)chooseCancel;

@end

@interface DDPhotoListViewController : CXZBaseTableViewController

//跳转参数
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) BOOL orignal;
@property (nonatomic, weak) id<DDChoosePhotoDelegate> delegate;

@property (nonatomic, assign) QBImagePickerFilterType filterType;
@property (nonatomic, strong) NSMutableArray* albumList;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
