//
//  SWJobDetailData.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWJobDetailData : Jastor

/** 用户id */
@property (nonatomic, retain) NSString *user_id;

/** 标题 */
@property (nonatomic, retain) NSString *title;

/** 工期 */
@property (nonatomic, retain) NSString *schedule;

/** 工资 */
@property (nonatomic, retain) NSString *budget;

/** 开始时间 */
@property (nonatomic, retain) NSString *start_time;

/** 地址 */
@property (nonatomic, retain) NSString *address;

@property (nonatomic, retain) NSString *longitude;

@property (nonatomic, retain) NSString *latitude;

/** 发布者姓名 */
@property (nonatomic, retain) NSString *name;

/** 发布者手机号 */
@property (nonatomic, retain) NSString *phone;

/** 头像 */
@property (nonatomic, retain) NSString *avatar;

/** 是否雇佣 1已申请，2：未申请 */
@property (nonatomic, assign) NSInteger isapply;

@property (nonatomic, retain) NSArray *worker;

/** 申请id */
@property (nonatomic, retain) NSString *aid;

@end
