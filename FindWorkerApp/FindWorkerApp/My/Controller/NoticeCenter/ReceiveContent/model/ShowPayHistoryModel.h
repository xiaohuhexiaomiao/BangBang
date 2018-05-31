//
//  ShowPayHistoryModel.h
//  FindWorkerApp
//
//  Created by cxz on 2018/5/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowPayHistoryModel : NSObject

@property (nonatomic, assign) NSInteger status;//付款状态 0,处理中1,已付款，2 拒绝

@property (nonatomic, copy) NSString *add_time;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, copy) NSString *apply_pay_id;//工程ID

@end
