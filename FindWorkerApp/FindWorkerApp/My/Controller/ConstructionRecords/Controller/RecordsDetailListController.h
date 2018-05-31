//
//  RecordsDetailListController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/5/10.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SWBaseController.h"

@interface RecordsDetailListController : SWBaseController

@property (nonatomic, copy)NSString *productionName;

@property (nonatomic, assign)NSInteger workerType;// 1 为甲方 雇主, 2 为乙方 工人

@property (nonatomic ,copy)NSString *constractid;//合同ID

@end
