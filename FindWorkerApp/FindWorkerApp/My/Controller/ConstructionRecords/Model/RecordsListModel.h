//
//  RecordsListModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/5/11.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordsListModel : NSObject

@property (nonatomic, copy) NSString *contract_id;

@property (nonatomic, copy) NSString *sign_time;

@property (nonatomic, copy) NSString *contract_name;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *worker_id;

@property (nonatomic, copy) NSString *a_name;

@property (nonatomic, copy) NSString *b_name;

@property (nonatomic, assign) NSInteger user_type;//user_type = 1 为甲方 雇主,user_type = 2 为乙方 工人 a_name = 甲方姓名 ，b_name = 乙方姓名

@end
