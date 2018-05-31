//
//  XMNBottomToolBar.h
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/1/29.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XMNBottomBarType) {
    XMNCollectionBottomBar,
    XMNPreviewBottomBar,
};

@interface XMNBottomBar: UIView

@property (nonatomic, assign, readonly) XMNBottomBarType barType;
@property (nonatomic, assign, readonly) CGFloat totalSize;
@property (nonatomic, assign, readonly) BOOL selectOriginEnable;
@property (nonatomic, copy)   void(^confirmBlock)();


- (instancetype)initWithBarType:(XMNBottomBarType)barType;

- (void)updateBottomBarWithAssets:(NSArray *)assets;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com