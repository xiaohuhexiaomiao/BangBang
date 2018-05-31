//
//  SWRegisterCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWRegisterCmd : BaseCommand

@property (nonatomic, retain) NSString *sender;

@property (nonatomic, retain) NSString *password;

@property (nonatomic, retain) NSString *check_password;

/** 0雇主，1工人 */
@property (nonatomic, retain) NSString  *type;

@end
