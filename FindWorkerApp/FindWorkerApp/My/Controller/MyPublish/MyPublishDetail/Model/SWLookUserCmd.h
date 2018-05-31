//
//  SWLookUserCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWLookUserCmd : BaseCommand

/** 请求类型；1申请的用户2浏览的用户3雇佣的用户 */
@property (nonatomic, assign) NSInteger type;

/** 信息iid */
@property (nonatomic, retain) NSString *iid;

@property (nonatomic, retain) NSString *uid;

@end
