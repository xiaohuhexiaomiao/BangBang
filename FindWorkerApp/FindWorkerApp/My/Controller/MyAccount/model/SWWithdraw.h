//
//  SWWithdraw.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWWithdraw : BaseCommand

@property (nonatomic, retain) NSString *user_id;

@property (nonatomic, retain) NSString *money;

@end
