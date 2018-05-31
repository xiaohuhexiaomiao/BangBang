//
//  WorkerListViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/10/16.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@protocol WorkerListControllerDelegate <NSObject>

-(void)didSelsectWorker:(NSMutableArray*)selectedArray;

-(void)didSelsectOneWorker:(NSDictionary*)personDict;

@end

@interface WorkerListViewController : CXZBaseViewController

@property(nonatomic ,strong)NSArray *alreadySelectedArray;

@property(nonatomic ,assign)BOOL is_search;// yes

@property(nonatomic ,assign)BOOL is_single;// yes 单选 NO 多选

@property(nonatomic ,weak) id <WorkerListControllerDelegate> delegate;

@end
