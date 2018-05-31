//
//  CreatPlanViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface CreatPlanViewController : CXZBaseViewController

@property(nonatomic ,copy) NSString *company_id;

@property(nonatomic ,assign) NSInteger type; //发表类型；1 日志，2周志，3月志

@property(nonatomic ,assign) NSInteger form_id; //表单规范id

@end
