//
//  CompanyDepartmentModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyDepartmentModel : NSObject

@property(nonatomic ,strong)NSString *department_describe;

@property(nonatomic ,strong)NSString *department_name;

@property(nonatomic ,assign)NSInteger department_id;

@property(nonatomic ,strong)NSArray *job;

@property(nonatomic ,assign)NSInteger is_automatic;

@property(nonatomic ,assign)NSInteger number;
@end
