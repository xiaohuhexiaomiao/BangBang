//
//  SWListContractData.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"


@interface SWListContractData : Jastor

@property (nonatomic, copy) NSString *information_id;

@property (nonatomic, copy) NSString *contract_id;

@property (nonatomic, copy) NSString *add_time;

@property (nonatomic, copy) NSString *worker_id;

/** 0 等待工人审核合同 1 同意 2 雇主重新编写合同 3 结束用工 */
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger is_tax;


@property (nonatomic, copy)NSString *contract_address;

@property (nonatomic, copy)NSString *contract_begin_time;//开始时间
@property (nonatomic, copy)NSString *contract_end_time;
@property (nonatomic, copy)NSString *project_detail;
@property (nonatomic, copy)NSString *univalent;//价格
@property (nonatomic, copy)NSString *worker_name;
@property (nonatomic, copy)NSString *employ_name;



@end
