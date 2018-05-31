//
//  SWUploadCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/30.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWUploadCmd : BaseCommand

@property (nonatomic, assign) int uid;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *idcard;

@property (nonatomic, retain) NSString *qq;

@property (nonatomic, retain) NSString *wechat;

@property (nonatomic, retain) NSString *clipay;

@property (nonatomic, retain) NSString *bank_card;

@property (nonatomic, retain) NSString *address;

@property (nonatomic, retain) NSString *salary;

/**
 自我评价
 */
@property (nonatomic, retain) NSString *self_evaluation;

/**
 1雇主完善，2工人完善，用户升级，3工人修改
 */
@property (nonatomic, assign) NSInteger type;

@end
