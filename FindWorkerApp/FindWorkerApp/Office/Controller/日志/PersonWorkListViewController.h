//
//  PersonWorkListViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/24.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface PersonWorkListViewController : CXZBaseViewController

@property(nonatomic ,assign)NSInteger type;//1日志，2签到

@property(nonatomic ,copy) NSString *companyID;

@property(nonatomic ,copy) NSString *look_uid;

@end
