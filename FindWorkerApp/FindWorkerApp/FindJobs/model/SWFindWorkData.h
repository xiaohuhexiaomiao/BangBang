//
//  SWFindWorkData.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWFindWorkData : Jastor

@property (nonatomic, retain) NSString *iid; //工作的id

@property (nonatomic, retain) NSString *add_time;

@property (nonatomic, assign) NSInteger isface; //是否面议

@property (nonatomic, retain) NSString *budget; //工资

@property (nonatomic, retain) NSString *longitude;

@property (nonatomic, retain) NSString *latitude;

@property (nonatomic, retain) NSString *name; //发布人的姓名

@property (nonatomic, retain) NSString *avatar; //发布人的头像

@property (nonatomic, retain) NSString *distance; //距离

@property (nonatomic, retain) NSArray *worker; //需要的工种

@end
