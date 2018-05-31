//
//  SWDetailWorkerComments.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWDetailWorkerComments : Jastor

@property (nonatomic, retain) NSString *rid;

@property (nonatomic, retain) NSString *worker_id;

@property (nonatomic, retain) NSString *user_id;

/**满意程度 0:满意 1:一般 2:不满意 */
@property (nonatomic, retain) NSString *rated_type;

/** 印象id */
@property (nonatomic, retain) NSString *sensation_id;

@property (nonatomic, retain) NSString *details;

@property (nonatomic, retain) NSString *add_time;

@property (nonatomic, retain) NSString *phone;

@property (nonatomic, retain) NSString *avatar;

@end
