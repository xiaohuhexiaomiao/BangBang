//
//  SWApplyCmd.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "BaseCommand.h"

@interface SWApplyCmd : BaseCommand

/** 申请者uid当type=1时不可为空 */
@property (nonatomic, retain) NSString *uid;

/** 申请的信息iid当type=1时不可为空 */
@property (nonatomic, retain) NSString *iid;

/** 申请工人类型wid当type=1时不可为空 */
@property (nonatomic, retain) NSString *wid;

/** 1申请2取消 */
@property (nonatomic, retain) NSString *type;

/** 申请aid 当type=2时不可为空 */
@property (nonatomic, retain) NSString *aid;

@end
