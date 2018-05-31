//
//  DiaryModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/22.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiaryModel : NSObject

@property(nonatomic ,copy) NSString *add_time;

@property(nonatomic ,copy) NSString *avatar;

@property(nonatomic ,copy) NSString *cc;

@property(nonatomic ,strong) NSDictionary *enclosure;

@property(nonatomic ,copy) NSString *company_id;

@property(nonatomic ,assign) NSInteger is_del;

@property(nonatomic ,copy) NSString *like_id;

@property(nonatomic ,copy) NSString *log_id;

@property(nonatomic ,assign) NSInteger log_type;//1.日志 2 周志 3 月志

@property(nonatomic ,assign) NSInteger custom_form_type;//自定义日志类型type

@property(nonatomic ,strong) NSArray *custom_form_elements;

@property(nonatomic ,copy) NSString *name;

@property(nonatomic ,copy) NSString *publish_id;

@property(nonatomic ,copy) NSString *reciewer_time;

@property(nonatomic ,copy) NSString *reviewer;

@property(nonatomic ,copy) NSString *reviewer_content;

@property(nonatomic ,copy) NSString *reviewer_name;

@property(nonatomic ,assign) NSInteger reviewer_fraction;

@property(nonatomic ,assign) NSTimeInterval start_time;

@property(nonatomic ,copy) NSString *uid;

@property(nonatomic ,assign) NSInteger form_type;//1 日志 2 签到

@property(nonatomic ,assign) float latitude;//签到 纬度

@property(nonatomic ,assign) float longitude;//签到 经度

@property(nonatomic ,copy) NSString *remarks;//签到 备注内容

@property(nonatomic ,copy) NSString *describe;//签到 备注内容

@end
