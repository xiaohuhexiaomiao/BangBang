//
//  SWMyTaskCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWMyTaskCmd : BaseCommand

@property (nonatomic, retain) NSString *uid;

@property (nonatomic, assign) NSInteger build_status; //0 待开始 1工作中 2完成待收款 3完成

@end
