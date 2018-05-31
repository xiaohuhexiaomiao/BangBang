//
//  PurchaseViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/27.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"



@interface PurchaseViewController : CXZBaseViewController


@property(nonatomic ,copy)NSString *companyID;

@property(nonatomic ,assign)NSInteger form_type;//0 公司审批 1 个人审批

@property(nonatomic ,copy)NSString *worker_user_id;

@end
