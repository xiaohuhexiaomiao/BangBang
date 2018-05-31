//
//  SWMyPublishDetailData.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWMyPublishDetailData : Jastor

@property (nonatomic, retain) NSString *address;

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSString *start_time;

@property (nonatomic, retain) NSString *budget;

@property (nonatomic, retain) NSString *schedule;

@property (nonatomic, retain) NSString *remark;

@property (nonatomic, copy) NSString *iid;

@property (nonatomic, retain) NSArray *worker;

@end
