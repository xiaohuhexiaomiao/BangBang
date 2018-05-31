//
//  SWWorkerDetailCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWWorkerDetailCmd : BaseCommand

/** 工人ID */
@property (nonatomic, retain) NSString *uid;

/** 用户ID */
@property (nonatomic, retain) NSString *user_id;

@end
