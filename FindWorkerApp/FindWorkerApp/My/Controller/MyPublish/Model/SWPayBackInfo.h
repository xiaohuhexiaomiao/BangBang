//
//  SWPayBackInfo.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWPayBackInfo : BaseCommand

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, retain) NSString *message;

@property (nonatomic, retain) NSString *data;

@end
