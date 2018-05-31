//
//  CompanyContractReviewModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/8.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyContractReviewModel : NSObject

@property(nonatomic , copy)NSString *a_name;

@property(nonatomic , copy)NSString *add_time;

@property(nonatomic , copy)NSString *approval_contract_company_id;

@property(nonatomic , copy)NSString *arrive_time;

@property(nonatomic , copy)NSString *boss;

@property(nonatomic , copy)NSString *company_address;

@property(nonatomic , copy)NSString *company_id;

@property(nonatomic , copy)NSString *company_name;

@property(nonatomic , copy)NSString *company_tel;

@property(nonatomic , copy)NSString *contract_name;

@property(nonatomic , copy)NSString *contract_num;

@property(nonatomic , copy)NSString *difference;

@property(nonatomic , copy)NSString *enclosure_id;

@property(nonatomic , copy)NSString *end_time;

@property(nonatomic , copy)NSString *executor;

@property(nonatomic , copy)NSString *is_enclosure;

@property(nonatomic , copy)NSString *is_quit;

@property(nonatomic , copy)NSString *pay_method;

@property(nonatomic , copy)NSString *prive;

@property(nonatomic , copy)NSString *project_manager;

@property(nonatomic , copy)NSString *project_manager_id;

@property(nonatomic , strong)NSDictionary *project_manager_name;

@property(nonatomic , copy)NSString *remarks;

@property(nonatomic , copy)NSString *total_prive;

@property(nonatomic , copy)NSString *uid;

@property(nonatomic , copy)NSString *b_name;

@property(nonatomic , copy)NSString *contract_id;

@property(nonatomic , copy)NSString *contract_name_new;//合同名称

@property(nonatomic , strong)NSDictionary *attachments_id;

@property(nonatomic , strong)NSArray *many_enclosure;
@end
