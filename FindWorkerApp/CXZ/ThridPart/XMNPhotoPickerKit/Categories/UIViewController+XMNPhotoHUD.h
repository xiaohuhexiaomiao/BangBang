//
//  UIViewController+HUD.h
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/2/2.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (XMNPhotoHUD)

/**
 *  显示一个alert提示框
 *  只显示提示信息,和一个确定按钮
 *  @param title 具体提示的message
 */
- (void)showAlertWithMessage:(NSString *)message;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com