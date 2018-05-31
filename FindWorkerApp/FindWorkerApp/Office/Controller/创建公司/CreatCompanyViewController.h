//
//  CreatCompanyViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/13.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface CreatCompanyViewController : CXZBaseViewController

@property(nonatomic ,assign)BOOL is_creat_subCompany;//YES 创建群（子公司）

@property(nonatomic ,copy)NSString *compony_id;
@end
