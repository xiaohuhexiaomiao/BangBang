//
//  PaymentsFormViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/19.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@class PaymentModel;

@interface PaymentsFormViewController : CXZBaseViewController

@property(nonatomic ,copy)NSString *companyID;

@property(nonatomic ,assign)NSInteger payType;//请款依据类型

@property(nonatomic ,copy)NSString *formID;//表单ID

@property(nonatomic ,copy)NSString *contractName;//合同名称

@property(nonatomic ,assign)NSInteger form_type;//0 公司审批 1 个人审批

@property(nonatomic ,copy)NSString *worker_user_id;

@end
