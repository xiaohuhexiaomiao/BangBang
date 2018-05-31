//
//  ApprovalFileModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/7/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PersonalApprovalResultModel;

@interface ApprovalFileModel : NSObject

@property(nonatomic , copy)NSString *add_time;

@property(nonatomic , copy)NSString *chengpi_id;

@property(nonatomic , copy)NSString *chengpi_num;

@property(nonatomic , copy)NSString *company_id;

@property(nonatomic , copy)NSString *company_name;

@property(nonatomic , copy)NSString *content;

@property(nonatomic , strong)NSDictionary *contract_id;

@property(nonatomic , copy)NSString *department_id;

@property(nonatomic , copy)NSString *department_name;

@property(nonatomic , copy)NSString *title;

@property(nonatomic , copy)NSString *uid;

@property(nonatomic , copy)NSString *project_manager_id;

@property(nonatomic , strong)NSDictionary *project_manager_name;

@property(nonatomic , copy)NSString *project_manager;

@property(nonatomic , strong)NSArray *many_enclosure;

@property(nonatomic , strong)PersonalApprovalResultModel *approval_content;

@end
