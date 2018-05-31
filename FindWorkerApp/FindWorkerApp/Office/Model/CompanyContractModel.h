//
//  CompanyContractModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/16.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyContractModel : NSObject

@property(nonatomic ,copy) NSString *add_time;

@property(nonatomic ,copy) NSString *company_address;

@property(nonatomic ,copy) NSString *b_name;

@property(nonatomic ,copy) NSString *contract_address;

@property(nonatomic ,copy) NSString *contract_begin_time;

@property(nonatomic ,copy) NSString *contract_draft_id;

@property(nonatomic ,copy) NSString *contract_end_time;

@property(nonatomic ,copy) NSString *contract_name;

@property(nonatomic ,copy) NSString *contract_type_id;

@property(nonatomic ,copy) NSString *is_tax;

@property(nonatomic ,copy) NSString *result_ids;

@property(nonatomic ,copy) NSString *sign_time;

@property(nonatomic ,assign) NSInteger subtotal;

@property(nonatomic ,copy) NSString *user_id;




@end
