//
//  PayRecordsModel.h
//  FindWorkerApp
//
//  Created by cxz on 2018/3/21.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayRecordsModel : NSObject

@property(nonatomic,copy)NSString *book_id;

@property(nonatomic,copy)NSString *uid;

@property(nonatomic,copy)NSString *body;

@property(nonatomic,copy)NSString *alipay_id;

@property(nonatomic,copy)NSString *phone;

@property(nonatomic,copy)NSString *bank;

@property(nonatomic,copy)NSString *bank_card_id;

@property(nonatomic,assign)NSInteger pay_type;

@property(nonatomic,assign)double money;

@property(nonatomic,copy)NSString *amount_paid;

@property(nonatomic,assign)double pay_paid;

@property(nonatomic,copy)NSString *year;

@property(nonatomic,copy)NSString *month;

@property(nonatomic,copy)NSString *add_time;

@property(nonatomic,copy)NSString *account_name;

@property(nonatomic,copy)NSString *basis;

@end
