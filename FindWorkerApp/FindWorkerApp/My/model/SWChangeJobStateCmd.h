//
//  SWChangeJobStateCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/6.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWChangeJobStateCmd : BaseCommand

@property (nonatomic, retain) NSString *uid;

@property (nonatomic, assign) NSInteger work_status; //接活状态 0 正常 1禁用

@end
