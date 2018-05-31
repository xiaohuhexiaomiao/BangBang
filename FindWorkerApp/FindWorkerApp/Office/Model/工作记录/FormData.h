//
//  FormData.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormData : NSObject

@property(nonatomic ,copy) NSString *add_time;

@property(nonatomic ,copy) NSString *cc;

@property(nonatomic ,copy) NSString *company_id;

@property(nonatomic ,strong) NSArray *enclosure;

@property(nonatomic ,assign) BOOL is_del;

@property(nonatomic ,copy) NSString *log_id;

@property(nonatomic ,assign) NSInteger log_type;//1 日志 2 周计划 3 月计划

@property(nonatomic ,assign) NSInteger form_type;

@property(nonatomic ,assign) NSInteger custom_form_type;

@property(nonatomic ,strong) NSArray *custom_form_elements;//自定义表单规范
//
//@property(nonatomic ,copy) NSString *custom_form_result;// 日志结果集

@property(nonatomic ,copy) NSString *reciewer_time;

@property(nonatomic ,copy) NSString *reviewer;

@property(nonatomic ,copy) NSString *reviewer_content;

@property(nonatomic ,copy) NSString *reviewer_name;

@property(nonatomic ,assign) NSInteger reviewer_fraction;

@property(nonatomic ,assign) NSTimeInterval start_time;

//@property(nonatomic ,copy) NSString *summary_today;
//
//@property(nonatomic ,copy) NSString *tomorrow_plan;

@property(nonatomic ,copy) NSString *uid;

//@property(nonatomic ,copy) NSString *work_exp;

@end
