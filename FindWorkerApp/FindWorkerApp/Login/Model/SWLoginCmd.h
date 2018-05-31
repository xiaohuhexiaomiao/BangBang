//
//  SWLoginCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWLoginCmd : BaseCommand

@property (nonatomic, retain) NSString *phone;

@property (nonatomic, retain) NSString *password;

@end
