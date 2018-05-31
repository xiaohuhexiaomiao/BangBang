//
//  SWSeeWokerView.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/23.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWLookUserData.h"

@class SWSeeWokerView;

@protocol SWSeeWorkerDelegate <NSObject>

- (void)applyWorker:(SWSeeWokerView *)workerView data:(SWLookUserData*)data;

- (void)cancelWorker:(SWSeeWokerView *)workerView;

- (void)payToWorker:(SWSeeWokerView *)workerView;

- (void)commentToWorker:(SWSeeWokerView *)workerView;

- (void)refuseApply:(SWSeeWokerView *)workerView;

- (void)cancelConract:(SWSeeWokerView *)workerView;

@end

@interface SWSeeWokerView : UIView

@property (nonatomic, retain) SWLookUserData *data;

@property (nonatomic, weak) id<SWSeeWorkerDelegate> seeDelegate;

@property (nonatomic, retain) NSString *btnStr;



/** 0：申请的工人 1: 浏览的工人 2: 雇佣的工人 */
@property (nonatomic, assign) NSInteger type;

//展示申请的工人和流浪过的工人数据
//image:头像
//name:姓名
//jobs:工种
- (void)showUnWorkerData:(NSString *)imageName name:(NSString *)name jobs:(NSArray *)jobs status:(NSInteger)status;

//展示雇佣的工人数据
//image:头像
//name:姓名
//jobs:工种
//state:1:待同意 2:已同意 3:付预付款 4:已付款
- (void)showWorkerData:(NSString *)imageName name:(NSString *)name jobs:(NSArray *)jobs state:(NSInteger)state;


- (void)showWorkerCommentView:(NSString *)imageName name:(NSString *)name jobs:(NSArray *)jobs status:(BOOL)rate;

- (void)showOngoingWorkerData:(NSString *)imageName name:(NSString *)name jobs:(NSArray *)jobs status:(NSInteger)status;

@end
