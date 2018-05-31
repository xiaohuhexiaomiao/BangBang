//
//  SelectedDepartmentViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/12.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@protocol SelectedDepartmentDelegate <NSObject>

-(void)didSelectedDepartment:(NSDictionary*)department;

@end

@interface SelectedDepartmentViewController : CXZBaseViewController

@property(nonatomic , copy) NSString *companyid;

@property(nonatomic , weak) id <SelectedDepartmentDelegate> delegate;

@property(nonatomic ,assign) NSInteger isShow;

@end
