//
//  SWInviteCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWInviteCmd : BaseCommand

/** 工人id */
@property (nonatomic, retain) NSString *worker_id;

/** 发布任务ID */
@property (nonatomic, retain) NSString *iid;

@end
