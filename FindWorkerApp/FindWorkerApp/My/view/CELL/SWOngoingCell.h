//
//  SWOngoingCell.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMyTaskData.h"

@interface SWOngoingCell : UITableViewCell

@property (nonatomic, retain) SWMyTaskData *taskData;

+ (instancetype)initWithTableViewCell:(UITableView *)tableView;


/**
 显示数据

 @param date 发布时间
 @param content 标题
 @param status 待完成：等待确认完成状态位2 已确认完成状态位3
 */
- (void)showData:(NSString *)date content:(NSString *)content status:(NSInteger)status;

@end
