//
//  SWPublishWorkCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/6.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWPublishWorkCmd : BaseCommand

@property (nonatomic, retain) NSString *uid;

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSString *budget;

@property (nonatomic, retain) NSString *isface;

@property (nonatomic, retain) NSString *longtitude;

@property (nonatomic, retain) NSString *latitude;

@property (nonatomic, retain) NSString *start_time;

@property (nonatomic, retain) NSString *end_time;

@property (nonatomic, retain) NSString *remark;

@property (nonatomic, retain) NSString *typeId;//

@property (nonatomic, retain) NSString *typenum;

@property (nonatomic, retain) NSString *schedule;

@property (nonatomic, retain) NSString *address;

@property (nonatomic, retain) NSString *company_id;

@end
