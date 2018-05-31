//
//  ContractStatusModel.h
//  FindWorkerApp
//
//  Created by cxz on 2018/3/26.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContractStatusModel : NSObject

@property (nonatomic, assign) NSInteger contract_id;//合同id

@property (nonatomic, copy) NSString *contract_name;//合同名称

@property (nonatomic, copy) NSString *user_id;//

@property (nonatomic, copy) NSString *worker_id;//工人id

@property (nonatomic, assign) NSInteger apply_status;//申请状态 0暂无申请，1正在申请

@property (nonatomic, copy) NSString *apply_id;//申请id 如果申请状态为1 则有

@property (nonatomic, copy) NSString *add_time;//

@property (nonatomic, assign) NSInteger contract_type_id;//合同类型

@property (nonatomic, assign) NSInteger take_effect;//合同状态 0雇主已签字工人待同意，1工人已签字同意,雇主未支付预付款，2工人不同意重新审核，3工人拒绝合同，4合同生效，双方都签字且支付预付款，5完工，6合同生效，无需支付预付款

@property (nonatomic, assign) NSInteger apply_is_ok;//申请中间表状态 如果申请状态为1 则显示此状态 ：0，未处理，1，同意，甲方未付款，2俩份单据都拒绝，3同意一份，4拒绝一份

@property (nonatomic, copy) NSString *worker_name;//工人名称

@property (nonatomic, copy) NSString *employ_name;//名称

@property (nonatomic, assign)double total_price;

@property (nonatomic, assign) NSInteger worker_apply;//申请完工状态 0暂无申请，1正在申请 2 申请通过

@property (nonatomic, copy) NSString *acceptance_id;//申请完工状态

@property (nonatomic, copy) NSString *apply_pay;//申请付款

@end
