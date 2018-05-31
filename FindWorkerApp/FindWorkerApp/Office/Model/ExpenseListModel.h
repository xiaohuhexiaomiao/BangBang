//
//  ExpenseListModel.h
//  FindWorkerApp
//
//  Created by cxz on 2018/1/8.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpenseListModel : NSObject

@property(nonatomic , copy)NSString *remarks;

@property(nonatomic , copy)NSString *month_day;

@property(nonatomic , copy)NSString *content;

@property(nonatomic , assign)NSInteger amount;

@property(nonatomic , assign)float price;

@property(nonatomic , copy)NSString *big_price;

@end
