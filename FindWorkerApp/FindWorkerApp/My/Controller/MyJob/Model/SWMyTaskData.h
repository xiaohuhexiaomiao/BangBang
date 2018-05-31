//
//  SWMyTaskData.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWMyTaskData : Jastor

@property (nonatomic, retain) NSString *add_time;

@property (nonatomic, retain) NSString *eid;

@property (nonatomic, retain) NSString *information_id;

@property (nonatomic, retain) NSString *title;


/**
 待响应：等待用户接受或拒绝0 已接受1 已拒绝2
 
 待开始：等待确认付款状态位0 已确认付款状态位1
 
 待完成：等待确认完成状态位2 已确认完成状态位3
 
 已结束：返回状态位0
 */
@property (nonatomic, assign) NSInteger status;

@end
