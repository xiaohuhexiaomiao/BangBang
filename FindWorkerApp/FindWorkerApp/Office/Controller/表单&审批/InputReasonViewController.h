//
//  InputReasonViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2018/2/7.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface InputReasonViewController : CXZBaseViewController

@property(nonatomic ,copy)NSString *company_id;//

@property(nonatomic ,copy)NSString *approval_id;//审批表单ID  inputType == 0 时上传

@property(nonatomic ,assign)NSInteger inputType;//0 输入撤销理由 1 报销单拒绝理由  2 结算单拒绝理由

@property(nonatomic ,copy)NSString *apply_id;// 1 报销单  2 结算单 传此id

@property(nonatomic ,copy)NSString *contract_id;// 1 报销单  2 结算单 传此id

@end
