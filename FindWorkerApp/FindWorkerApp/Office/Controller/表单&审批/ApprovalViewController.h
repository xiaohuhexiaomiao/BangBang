//
//  ApprovalViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface ApprovalViewController : CXZBaseViewController

@property(nonatomic , copy)NSString *companyID;

@property(nonatomic , assign) BOOL isSpecial;

@property(nonatomic ,strong)NSArray *companyArr;

@end
