//
//  SelectedContractViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/22.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"
@protocol SelectedContractDelegate<NSObject>

-(void)selectedContractWithDict:(NSDictionary*)dict type:(NSInteger)type;

@end
@interface SelectedContractViewController : CXZBaseViewController

@property(nonatomic, weak)id <SelectedContractDelegate> delegate;

@property(nonatomic ,assign) BOOL isWorkerList;//YES 个人合同 NO  公司合同

@property(nonatomic ,copy)NSString *companyID;
@end
