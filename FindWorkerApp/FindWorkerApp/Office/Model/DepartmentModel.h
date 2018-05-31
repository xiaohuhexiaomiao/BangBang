//
//  DepartmentModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/19.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DepartmentModel : NSObject

@property(nonatomic ,strong)NSString *name;

@property(nonatomic ,assign)NSInteger type;

@property(nonatomic ,strong)NSArray *job;

@end
