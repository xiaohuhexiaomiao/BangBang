//
//  StampViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/29.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface StampViewController : CXZBaseViewController

@property(nonatomic ,copy)NSString *companyID;

@property(nonatomic ,assign)NSInteger form_type;//0 公司审批 1 个人审批

@end
