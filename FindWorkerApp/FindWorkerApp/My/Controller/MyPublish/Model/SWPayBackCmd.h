//
//  SWPayBackCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWPayBackCmd : BaseCommand

@property (nonatomic ,retain) NSString *oid;

@property (nonatomic, retain) NSString *information_id;

@property (nonatomic, retain) NSString *uid;



@end
