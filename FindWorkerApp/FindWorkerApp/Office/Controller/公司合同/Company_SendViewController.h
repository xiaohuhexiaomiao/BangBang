//
//  Company_SendViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/16.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@class CompanyContractModel;

@protocol CompanySendViewControllerDelegate <NSObject>

-(void)selectedContract:(CompanyContractModel*)contractModel;

@end

@interface Company_SendViewController : CXZBaseViewController

@property(nonatomic , copy)NSString *companyID;

@property(nonatomic , assign)BOOL isSelected;

@property(nonatomic , weak) id <CompanySendViewControllerDelegate> delegate;

@end
