//
//  SWAddContactCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/13.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWAddContactCmd : BaseCommand

@property (nonatomic, retain) NSString *worker_id;

@property (nonatomic, retain) NSString *information_id;

@end
