//
//  SWAcceptCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWAcceptCmd : BaseCommand

@property (nonatomic, retain) NSString *eid;

/** 雇佣状态1接受2拒绝 */
@property (nonatomic, retain) NSString *invite_status;

@end
