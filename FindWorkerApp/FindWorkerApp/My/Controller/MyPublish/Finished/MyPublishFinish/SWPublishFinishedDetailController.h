//
//  SWPublishFinishedDetailController.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/26.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface SWPublishFinishedDetailController : CXZBaseViewController

/** 发布id */
@property (nonatomic, retain) NSString *iid;

@property (nonatomic, retain) NSString *titleStr;

- (void)hideView;

@end
