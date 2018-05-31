//
//  SWAuditWorkerCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWAuditWorkerCmd : BaseCommand

/** 情况判断；1从申请表雇佣2从浏览表雇佣 */
@property (nonatomic, assign) NSInteger type;

/** 申请aid当type=1时必须 */
@property (nonatomic, retain) NSString *aid;

/** 发布iid当type=2时必须 */
@property (nonatomic, retain) NSString *iid;

/** 发布工人uid当type=2时必须 */
@property (nonatomic, retain) NSString *worker_id;



@end
