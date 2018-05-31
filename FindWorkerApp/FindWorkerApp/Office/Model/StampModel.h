//
//  StampModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/29.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StampModel : NSObject

@property(nonatomic , copy)NSString *add_time;

@property(nonatomic , copy)NSString *company_address;

@property(nonatomic , copy)NSString *company_id;

@property(nonatomic , copy)NSString *company_name;

@property(nonatomic , copy)NSString *company_tel;

@property(nonatomic , strong)NSDictionary *contract_id;

@property(nonatomic , copy)NSString *department_describe;

@property(nonatomic , copy)NSString *department_id;

@property(nonatomic , copy)NSString *department_name;

@property(nonatomic , copy)NSString *department_power;

@property(nonatomic , copy)NSString *departmental;

@property(nonatomic , strong)NSArray *info;

@property(nonatomic , copy)NSString *request_seal_id;

@property(nonatomic , copy)NSString *uid;

@property(nonatomic , copy)NSString *user_name;

@property(nonatomic , copy)NSString *project_manager_id;

@property(nonatomic , strong)NSDictionary *project_manager_name;

@property(nonatomic , copy)NSString *project_manager;

@property(nonatomic , strong)NSArray *many_enclosure;

@end
