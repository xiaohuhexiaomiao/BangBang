//
//  PurchaseModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/28.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PersonalApprovalResultModel;

@interface PurchaseModel : NSObject

@property(nonatomic , copy)NSString *add_time;

@property(nonatomic , copy)NSString *arrival_time;

@property(nonatomic , copy)NSString *company_address;

@property(nonatomic , copy)NSString *company_id;

@property(nonatomic , copy)NSString *company_name;

@property(nonatomic , copy)NSString *company_tel;

@property(nonatomic , copy)NSString *consignee;

@property(nonatomic , copy)NSString *consignee_phone;

@property(nonatomic , strong)NSArray *content;

@property(nonatomic , copy)NSString *contract_responsible;

@property(nonatomic , copy)NSString *department_describe;

@property(nonatomic , copy)NSString *department_id;

@property(nonatomic , copy)NSString *department_name;

@property(nonatomic , copy)NSString *department_power;

@property(nonatomic , assign)NSInteger is_add_plan;

@property(nonatomic , assign)NSInteger is_urgent;

@property(nonatomic , copy)NSString *request_buy_department;

@property(nonatomic , copy)NSString *request_buy_id;

@property(nonatomic , copy)NSString *request_contract_address;

@property(nonatomic , copy)NSString *responsible_tel;

@property(nonatomic , strong)NSDictionary *enclosure_id;

@property(nonatomic , copy)NSString *uid;

@property(nonatomic , assign)NSInteger type;

@property(nonatomic , assign)float total;

@property(nonatomic , copy)NSString *project_manager_id;

@property(nonatomic , strong)NSDictionary *project_manager_name;

@property(nonatomic , copy)NSString *project_manager;

@property(nonatomic , copy)NSString *receive_address;

@property(nonatomic , copy)NSString *buy_person;
//
@property(nonatomic , copy)NSString *buy_person_phone;

@property(nonatomic , copy)NSString *contract_name_new;

@property(nonatomic , strong)NSArray *many_enclosure;

@property(nonatomic , copy)NSString *consignee_uid;//收货人uid

@property(nonatomic , copy)NSString *buy_person_uid;//采购执行人uid

@property(nonatomic , strong)PersonalApprovalResultModel *approval_content;//个人审批
@end
