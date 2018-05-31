//
//  CXZBaseViewController.h
//  DiaoDiao
//
//  Created by wangzeng on 14-10-20.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXZBaseViewController : UIViewController
@property (nonatomic, assign) BOOL isAutorotate;
-(void)removeTapGestureRecognizer;
- (void)registerHideKeyWindow;
- (void) setupBack;
- (void) setupBackw;
- (void) setupBackWithImage:(UIImage*) image withString:(NSString*) text;
- (void) setupNextWithImage:(UIImage*) image;
- (void) setupNextWithArray:(NSArray*) array;
- (void) setupNextWithString:(NSString*) text;
- (void) setupNextWithString:(NSString *)text withColor:(UIColor *)color;
- (void) setupTitleWithString:(NSString*) text withColor:(UIColor*) color;
- (void) setupBackWithString:(NSString *)text withColor:(UIColor *)color;
- (void) setupTitle;
-(void)setUpNextWithFirstImages:(NSString*)firstImage Second:(NSString*)secondImage;
-(void)setUpNextWithFirstTitle:(NSString*)firstTitle Second:(NSString*)secondTitle;

// 回调  子类继承各自处理
- (void)onBack;
- (void)onNext;
- (void)clickTitle;
-(void)clickRrightFirstItem;
-(void)clickRrightSecondItem;
- (void)popByDrag;
- (BOOL)needDragBack;
- (BOOL)needRegisterHideKeyboard;
- (void)hideKeyWindow;

// 进度效果
- (void)showLoading;
- (void)hideLoading;
@end
