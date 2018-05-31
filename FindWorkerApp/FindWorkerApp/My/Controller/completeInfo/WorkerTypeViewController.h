//
//  WorkerTypeViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/22.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"
@class WokerTypeModel;
@protocol WorkerTypeControllerDelegate <NSObject>

-(void)selectedWorkerType:(WokerTypeModel*)wokerTypeModle;

@end

@interface WorkerTypeViewController : CXZBaseViewController

@property(nonatomic,weak)id <WorkerTypeControllerDelegate> delegate;

@end
