//
//  Transaction.h
//  FindWorkerApp
//
//  Created by cxz on 2017/1/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject

@property (nonatomic, copy) NSString *addtime;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, assign) NSInteger amount_type;

@property (nonatomic, assign) float amount;

@property (nonatomic, copy) NSString *order_sn;

@end
