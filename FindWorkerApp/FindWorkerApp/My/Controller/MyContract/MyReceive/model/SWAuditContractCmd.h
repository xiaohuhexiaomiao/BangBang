//
//  SWAuditContractCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWAuditContractCmd : BaseCommand

@property (nonatomic, retain) NSString *information_id;//非必填

@property (nonatomic, retain) NSString *uid;

/** 1通过 2 雇主重新编写合同，3结束 */
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, retain) NSString *contract_id;

@end
