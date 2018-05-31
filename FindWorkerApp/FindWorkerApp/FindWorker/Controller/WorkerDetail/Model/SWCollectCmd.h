//
//  SWCollectCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWCollectCmd : BaseCommand

@property (nonatomic, retain) NSString *worker_id;

@property (nonatomic, retain) NSString *uid;

/** 1收藏，0取消收藏 */
@property (nonatomic, assign) NSInteger status;

@end
