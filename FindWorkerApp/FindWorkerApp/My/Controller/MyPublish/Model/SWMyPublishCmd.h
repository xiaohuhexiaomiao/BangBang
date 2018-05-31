//
//  SWMyPublishCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWMyPublishCmd : BaseCommand

@property (nonatomic, retain) NSString *uid;

@property (nonatomic, assign) NSInteger status; // 1进行中 2结束

@end
