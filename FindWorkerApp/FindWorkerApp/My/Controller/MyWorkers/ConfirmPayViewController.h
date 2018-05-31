//
//  ConfirmPayViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/1/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface ConfirmPayViewController : CXZBaseViewController

@property (nonatomic,strong)NSArray *confirmArray;

@property (nonatomic,strong)NSMutableDictionary *moneyDictionay;

@property (nonatomic,assign)CGFloat totalPay;

@end
