//
//  AddColleagueViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/12.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"
#import "PersonelModel.h"

@interface AddColleagueViewController : CXZBaseViewController

@property (nonatomic ,copy)NSString *company_id;

@property (nonatomic ,assign)BOOL isUpdate;//yes  更改部门

@property (nonatomic ,strong)PersonelModel *personal;//更改部门

@end
