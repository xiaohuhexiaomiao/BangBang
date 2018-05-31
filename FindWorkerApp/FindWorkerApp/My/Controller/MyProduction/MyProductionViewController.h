//
//  MyProductionViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/4/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXZ.h"
@interface MyProductionViewController : CXZBaseViewController

@property(nonatomic,assign) BOOL is_other_worker;//yes 其他工人的作品

@property(nonatomic,copy) NSString *other_worker_uid;

@end
