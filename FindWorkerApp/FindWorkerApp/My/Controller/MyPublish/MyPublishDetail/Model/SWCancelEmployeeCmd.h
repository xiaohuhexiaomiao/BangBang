//
//  SWCancelEmployeeCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/11.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWCancelEmployeeCmd : BaseCommand

/** 雇佣id */
@property (nonatomic, retain) NSString *eid;

@end
