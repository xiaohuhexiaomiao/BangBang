//
//  PostContractViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/1.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"
@interface PostContractViewController : CXZBaseViewController
@property (nonatomic , copy) NSString *uid; //用户ID；

@property (nonatomic , copy) NSString *workID;//工人ID

@property (nonatomic , copy) NSString *information_id;//工人ID

@property (nonatomic ,strong) NSDictionary *detailDict;

@property (nonatomic , copy) NSString *contractTypeID;//合同类型ID

@property (nonatomic ,assign) BOOL isBack;// YES 退回修改的合同

@property (nonatomic , copy) NSString *contractID;//合同ID

@property (nonatomic , assign) BOOL isCompany;//YES  公司合同 NO 个人合同

@property (nonatomic , assign) BOOL is_save;//YES  编辑公司模板合同 保存并分享

@property (nonatomic , copy) NSString *company;//公司ID



@end
