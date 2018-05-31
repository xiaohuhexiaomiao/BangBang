//
//  SWWorkerInfoCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/1.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWWorkerInfoCmd : BaseCommand

@property (nonatomic, retain) NSString *uid;

/** 工作类型ID */
@property (nonatomic, retain) NSString *wid;

/** 籍贯id */
@property (nonatomic, retain) NSString *area_id;

/** 排序规则'd'按距离，’n‘按好评率，’w‘按雇佣次数 */
@property (nonatomic, retain) NSString *order;

@property (nonatomic, assign) NSInteger size; //最大距离



@end
