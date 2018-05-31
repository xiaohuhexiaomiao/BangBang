//
//  SWEvaluateCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWEvaluateCmd : BaseCommand

@property (nonatomic, retain) NSString *uid;

@property (nonatomic, retain) NSString *worker_id;

@property (nonatomic, retain) NSString *information_id;

@property (nonatomic, retain) NSString *rated_type;

@property (nonatomic, retain) NSString *details;

@end
