//
//  SWSearchWorkerViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/2/20.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

typedef NS_ENUM(NSInteger,SearchType) {
     SearchWorkerType,
     SearchJobType,
    searchApprovalType,
    searchPesonApprovalType
};

@interface SWSearchWorkerViewController : CXZBaseViewController

@property(nonatomic, assign) SearchType searchType;

@property(nonatomic,assign)NSInteger is_vip;

@property(nonatomic,copy)NSString *companyID;

@end
