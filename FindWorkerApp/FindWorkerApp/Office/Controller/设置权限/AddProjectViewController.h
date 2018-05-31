//
//  AddProjectViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"
@protocol ProjectViewControllerDelegate <NSObject>

-(void)selectedProject:(NSDictionary*)projectDict;

@end
@interface AddProjectViewController : CXZBaseViewController

@property(nonatomic ,copy) NSString *company_id;

@property(nonatomic , assign)BOOL is_add_project;//yes 添加工程 NO 纯列表展示

@property(nonatomic ,weak)id <ProjectViewControllerDelegate> delegate;

@end
