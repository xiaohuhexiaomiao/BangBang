//
//  SWMyUserData.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWMyUserData : Jastor

@property (nonatomic, retain) NSString *uid;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *avatar;

/** 0：代表未开启接活 1：代表开启接活 2：正在接活 */
@property (nonatomic, assign) NSInteger work_status;

@end
