//
//  DDChoosePhotoViewController.h
//  DiaoDiao
//
//  Created by wangzeng on 14-10-23.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDPhotoListViewController.h"
#import "DDChoosePhotoBottom.h"
#import "CXZBaseTableViewController.h"
@import Photos;
@protocol DDChoosePhotoDelegate;

@interface DDChoosePhotoViewController : CXZBaseTableViewController {
    PHFetchResult * photoList;
    NSMutableOrderedSet* setIndex;
    NSMutableOrderedSet* setRow;
    DDChoosePhotoBottom* addView;
    BOOL ensureChoose;
}

//跳转参数
@property (nonatomic, weak) PHAssetCollection *assetsGroup;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) BOOL orignal;
@property (nonatomic, weak) id<DDChoosePhotoDelegate> delegate;


@end
