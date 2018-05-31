//
//  SWUploadContractCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWUploadContractCmd : BaseCommand

/** 用户ID */
@property (nonatomic, retain) NSString *uid;

/** 雇佣信息ID */
@property (nonatomic, retain) NSString *information_id;

/** 是否含税 1是 2不是 */
@property (nonatomic, assign) NSInteger is_tax;

/** 工程内容 */
@property (nonatomic, retain) NSString *project_detail;


/** 付款比例 */
@property (nonatomic, retain) NSString *payment_ratio;

@property (nonatomic, retain) NSString *worker_id;

@property (nonatomic, copy) NSString *contract_begin_time;
@property (nonatomic, copy) NSString *contract_end_time;
@property (nonatomic, copy) NSString *contract_address;

@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, copy) NSString *information_remark;
@property (nonatomic, copy) NSString *subtotal;
@property (nonatomic, copy) NSString *univalent;//单价
@property (nonatomic, copy) NSString *area;//单价
@end
