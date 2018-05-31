//
//  SWFindWorkCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWFindWorkCmd : BaseCommand

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *wid;

@property (nonatomic, copy) NSString *order;

@property (nonatomic, assign) NSInteger p;

@property (nonatomic, copy) NSString *each;

@property (nonatomic, copy) NSString *company_id;

@end
