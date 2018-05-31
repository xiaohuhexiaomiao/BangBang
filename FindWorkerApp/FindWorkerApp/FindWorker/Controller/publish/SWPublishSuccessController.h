//
//  SWPublishSuccessController.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

#import "SWPublishWorkCmd.h"


@interface SWPublishSuccessController : CXZBaseViewController

@property (nonatomic, retain) SWPublishWorkCmd *publishWorkCmd;

@property (nonatomic, retain) NSArray *workArr;

@end
