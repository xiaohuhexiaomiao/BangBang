//
//  CXZBaseTableViewController.h
//  DiaoDiao
//
//  Created by wangzeng on 14-10-20.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "NSGCDThread.h"

typedef void (^ DidSelectObjectBlock)(BOOL choosed,  CGFloat money);

@interface CXZBaseTableViewController : UITableViewController

@property (nonatomic, assign) BOOL preScrollEnable;
@property (nonatomic, assign) BOOL preInterEnable;
@property (nonatomic, assign) CGFloat moveY;

- (void)registerHideKeyWindow;
- (void)hideKeyWindow;


- (void) setupBack;
- (void) setupNextWithImage:(UIImage*) image;
- (UIButton*) setupNextWithString:(NSString*) text;
- (void) setupNextWithString:(NSString *)text withColor:(UIColor *)color;
- (void)setupTitleWithString:(NSString *)text withColor:(UIColor *)color;



// 回调  子类继承各自处理
- (void)onBack;   //返回
- (void)onNext;  //下一步
//- (void)titleItemClicked:(UIButton*)button; //自定义顶部按钮回调
- (void)popByDrag;  //侧拉返回的回调
- (BOOL)needDragBack; //是否需要侧拉返回
- (BOOL)needRegisterHideKeyboard;  //是否需要自动隐藏键盘
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch;

// 进度效果
- (void)showLoading;
- (void)hideLoading;

@end
