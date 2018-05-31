//
//  SWMyFavoriteWorker.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWMyFavoriteWorker : Jastor

/** 头像 */
@property (nonatomic, retain) NSString *avatar;

/** 工人id */
@property (nonatomic, retain) NSString *uid;

/** 工人姓名 */
@property (nonatomic, retain) NSString *name;

/** 工人类型 */
@property (nonatomic, retain) NSArray *type;

@end
