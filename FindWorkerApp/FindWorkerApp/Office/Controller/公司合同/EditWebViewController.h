//
//  EditContractViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2018/3/22.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface EditWebViewController : CXZBaseViewController

@property (nonatomic , copy) NSString *projectID;//工程ID

@property (nonatomic , copy) NSString *workID;//工人ID

@property (nonatomic , assign) NSInteger form_Type_ID;//表单类型ID

@property(nonatomic, copy) NSString *titleString;//标题

@property(nonatomic, assign) NSInteger editType;// 0 编辑公司合同  1 编辑个人合同 2 编辑报验单  3 编辑结算单 4修改个人合同 5 修改报验单 6 修改结算单  7 查看个人合同 8 查看公司合同 9 查看报验单 10 查看结算单 11 编辑公司报验单 12 修改公司报验单 13 查看公司报验单

@property (nonatomic , assign) NSInteger contractID;////合同ID 验收结算单id 共用一个

@property (nonatomic , assign) NSInteger formid;//验收结算单id 共用一个

@property(nonatomic, assign) NSInteger  apply_id;//验收申请id

@property(nonatomic, copy) NSString *company_id;//公司验收单 用 公司id

@end
