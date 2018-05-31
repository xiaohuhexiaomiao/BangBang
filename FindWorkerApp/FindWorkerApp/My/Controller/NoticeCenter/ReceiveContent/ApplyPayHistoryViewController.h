//
//  ApplyPayHistoryViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2018/5/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface ApplyPayHistoryViewController : CXZBaseViewController

@property(nonatomic ,assign)NSInteger type;// 0 乙方 等待付款 1 甲方去付款

@property (nonatomic, assign) NSInteger contract_id;//合同id


@end
