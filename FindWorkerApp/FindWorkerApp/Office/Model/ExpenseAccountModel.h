//
//  ExpenseAccountModel.h
//  FindWorkerApp
//
//  Created by cxz on 2018/1/8.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PersonalApprovalResultModel;


@interface ExpenseAccountModel : NSObject

@property(nonatomic , copy)NSString *add_time;

@property(nonatomic , copy)NSString *approval_id;

@property(nonatomic , copy)NSString *baoxiao_id;

@property(nonatomic , copy)NSString *company_id;

@property(nonatomic , copy)NSString *company_name;

@property(nonatomic , strong)NSArray *content;

@property(nonatomic , strong)NSArray *many_enclosure;

@property(nonatomic , assign)double money;

@property(nonatomic , copy)NSString *project_manager_id;

@property(nonatomic , strong)NSDictionary *project_manager_name;

@property(nonatomic , copy)NSString *project_manager;

@property(nonatomic , copy)NSString *title;

@property(nonatomic , copy)NSString *uid;

@property(nonatomic , copy)NSString *big_money;


@property(nonatomic , strong)PersonalApprovalResultModel *approval_content;

@end
