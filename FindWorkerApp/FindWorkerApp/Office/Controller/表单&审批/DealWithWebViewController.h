//
//  DealWithWebViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2018/6/4.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface DealWithWebViewController : CXZBaseViewController

@property(nonatomic ,assign)BOOL is_aready_approval;// YES  已处理 No 未处理

@property(nonatomic ,assign)BOOL is_cancel;// YES  可以取消审批

@property(nonatomic ,copy)NSString *approvalID;

@property(nonatomic ,copy)NSString *company_id;

@property(nonatomic , copy)NSString *participation_id;

@end
