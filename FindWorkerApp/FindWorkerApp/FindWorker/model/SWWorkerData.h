//
//  SWWorkerData.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/1.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWWorkerData : Jastor

@property (nonatomic, retain) NSString *avatar;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, retain) NSArray *type;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *longitude;

@property (nonatomic, retain) NSString *latitude;

@property (nonatomic, retain) NSString *nice;

@property (nonatomic, retain) NSString *sex;

@property (nonatomic, assign) NSInteger distance;

@property (nonatomic, retain) NSString *phone;

@property (nonatomic, retain) NSString *tjr_name;//推荐人姓名

@property (nonatomic, assign) NSInteger registe;//推荐人姓名

@property (nonatomic, retain) NSString *work_years;//推荐人姓名

@property (nonatomic, assign) BOOL is_selected;

@end
