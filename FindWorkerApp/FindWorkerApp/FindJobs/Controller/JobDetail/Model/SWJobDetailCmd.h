//
//  SWJobDetailCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWJobDetailCmd : BaseCommand

/** 用户id  */
@property (nonatomic, retain) NSString *uid;

/** 发布任务id */
@property (nonatomic, retain) NSString *iid;

@end
