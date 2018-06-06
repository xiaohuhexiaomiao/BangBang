//
//  Company_ReceiveViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/16.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface ListViewController : CXZBaseViewController

@property (nonatomic , copy) NSString *uid; //用户ID；

@property (nonatomic , copy) NSString *workID;//工人ID

@property(nonatomic , assign)NSInteger list_type;// 0 公司合同模板 1 个人合同模板 2 报验单类型列表 3 结算单类型列表 4 公司报验单类型列表

@property(nonatomic , copy)NSString* project_id;// 工程id

@property(nonatomic , copy)NSString* company_id;// 工程id

@property(nonatomic , assign)NSInteger contract_id;// 0 合同id

@end
