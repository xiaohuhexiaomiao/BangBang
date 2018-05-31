//
//  SWEvaluateData.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWEvaluateData : Jastor

@property (nonatomic, retain) NSString *user_id;

/** 满意程度id */
@property (nonatomic, retain) NSString *rated_type;

/** 内容 */
@property (nonatomic, retain) NSString *details;

@property (nonatomic, retain) NSString *add_time;

@property (nonatomic, retain) NSString *avatar;

@property (nonatomic, retain) NSString *phone;

@end
