//
//  SeeWorkerCell.h
//  FindWorkerApp
//
//  Created by cxz on 2018/3/30.
//  Copyright © 2018年 SimonWest. All rights reserved.
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

@interface SeeWorkerCell : UITableViewCell

@property (nonatomic, retain) SWLookUserData *data;

@property (nonatomic, weak) id<SWSeeWorkerDelegate> seeDelegate;

@property (nonatomic, retain) NSString *btnStr;

/** 0：申请的工人 1: 浏览的工人 2: 雇佣的工人 */
@property (nonatomic, assign) NSInteger type;

- (void)showUnWorkerData:(NSString *)imageName name:(NSString *)name jobs:(NSArray *)jobs status:(NSInteger)status is_send:(BOOL)is_send;

@end
