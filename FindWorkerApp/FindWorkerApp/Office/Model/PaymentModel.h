//
//  PaymentModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/26.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PersonalApprovalResultModel;

@interface PaymentModel : NSObject

@property(nonatomic , copy)NSString *account_name;

@property(nonatomic , copy)NSString *add_time;

@property(nonatomic , copy)NSString *balance_subtotal;

@property(nonatomic , copy)NSString *bank_address;

@property(nonatomic , copy)NSString *bank_card;

@property(nonatomic , copy)NSString *company_address;

@property(nonatomic , copy)NSString *company_id;

@property(nonatomic , copy)NSString *company_name;

@property(nonatomic , copy)NSString *company_tel;

@property(nonatomic , strong)NSArray *contract_id;

@property(nonatomic , copy)NSString *contract_name;

@property(nonatomic , copy)NSString *contract_state;

@property(nonatomic , copy)NSString *gain_reduction_subtotal;

@property(nonatomic , copy)NSString *phone;

@property(nonatomic , copy)NSString *request_content;

@property(nonatomic , copy)NSString *request_money_id;

@property(nonatomic , copy)NSString *request_name;

@property(nonatomic , copy)NSString *request_num;

@property(nonatomic , copy)NSString *request_subtotal;

@property(nonatomic , copy)NSString *subtotal;

@property(nonatomic , copy)NSString *uid;

@property(nonatomic , strong)NSArray *worker_contract_id;

@property(nonatomic , copy)NSString *worker_type;

@property(nonatomic , assign)NSInteger type;

@property(nonatomic , copy)NSString *draw_money_name;

@property(nonatomic , copy)NSString *draw_money_time;

@property(nonatomic , copy)NSString *project_manager_id;//项目经理UID

@property(nonatomic , strong)NSDictionary *project_manager_name;//项目经理

@property(nonatomic , copy)NSString *project_manager;//项目经理姓名

@property(nonatomic ,assign)NSInteger request_money_basis_type;

@property(nonatomic , copy)NSString *form_approval_id;

@property(nonatomic , copy)NSString *contract_name_new;

@property(nonatomic , assign)NSInteger approval_type;

@property(nonatomic , copy)NSString *money;

@property(nonatomic , strong)NSArray *many_enclosure;

@property(nonatomic , strong)PersonalApprovalResultModel *approval_content;

@end
