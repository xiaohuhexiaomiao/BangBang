//
//  ReviewDetailModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/17.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewDetailModel : NSObject

@property(nonatomic ,copy) NSString *company_id;

@property(nonatomic ,copy) NSString *add_time;

@property(nonatomic ,copy) NSString *approval_contract_company_id;

@property(nonatomic ,copy) NSString *company_address;

@property(nonatomic ,copy) NSString *company_name;

@property(nonatomic ,copy) NSString *company_tel;

@property(nonatomic ,copy) NSString *contract_company_id;

@property(nonatomic ,copy) NSString *contract_name;

@property(nonatomic ,copy) NSString *contract_num;//合同编号

@property(nonatomic ,assign) NSInteger is_enclosure;//

@property(nonatomic ,copy) NSString *enclosure_id;//

@property(nonatomic ,strong) NSArray *content;

@property(nonatomic ,copy) NSString *type;

@property(nonatomic ,copy) NSString *remarks;

@property(nonatomic ,copy) NSString *uid;

@property(nonatomic ,strong) NSDictionary *project_manager_name;

@property(nonatomic , copy)NSString *project_manager;

@property(nonatomic , copy)NSString *project_manager_id;

@property(nonatomic , copy)NSString *contract_id;

@property(nonatomic , copy)NSString *contract_name_new;//合同名称

@end
