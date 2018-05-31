//
//  SWWaitingCell.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWMyTaskData.h"

@interface SWWaitingCell : UITableViewCell

@property (nonatomic, retain) SWMyTaskData *data;

+ (instancetype)initWithTableViewCell:(UITableView *)tableView;


/**
 待响应的cell

 @param date 发布时间
 @param content 标题
 */
- (void)showData:(NSString *)date content:(NSString *)content data:(SWMyTaskData *)data;


/**
 待开始的cell

 @param date 发布时间
 @param content 标题
 @param status 待开始：等待确认付款状态位0 已确认付款状态位1

 */
- (void)showWaitingData:(NSString *)date content:(NSString *)content status:(NSInteger)status data:(SWMyTaskData *)data;

@end
