//
//  PersonelModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/13.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonelModel : NSObject

@property(nonatomic ,copy) NSString *personnel_id;//在公司的 ID

@property(nonatomic ,copy) NSString *uid;//用户ID

@property(nonatomic ,copy) NSString *company_id;//公司ID

@property(nonatomic ,copy) NSString *department_id;//部门ID

@property(nonatomic ,copy) NSString *name;

@property(nonatomic ,copy) NSString *phone;

@property(nonatomic ,copy) NSString *avatar;

@property(nonatomic ,copy) NSString *department_name;//部门名称

@property(nonatomic ,copy) NSString *job_name;//职位名称

@property(nonatomic ,copy) NSString *job_id;//职位 id

@property(nonatomic ,assign) BOOL is_selected;//是否被选中

//@property(nonatomic ,copy) NSString *firstName;//姓名首字母

@end
