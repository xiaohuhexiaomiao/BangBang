//
//  SWWorkerDetailController.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/23.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface SWWorkerDetailController : CXZBaseViewController

@property (nonatomic, retain) NSString *uid; //工人的id

@property (nonatomic, retain) NSString *workerName;


/**
 是否查看工人详情
 */
@property (nonatomic, assign) BOOL is_detail;



@end
