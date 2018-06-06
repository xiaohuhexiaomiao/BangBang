//
//  SWCollectCmd.h
//  FindWorkerApp
//
//  Created by cxz on 2017/4/28.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface SignNameViewController : CXZBaseViewController

@property(nonatomic, assign) NSInteger contranctTypeID;//合同类型id

@property(nonatomic, assign) NSInteger contranctID;//合同id

@property (nonatomic , copy) NSString *workID;//工人ID

@property (nonatomic , copy) NSString *projectID; //工程json；

@property (nonatomic , copy) NSString *contentJson; //内容json；

@property(nonatomic ,assign)NSInteger signType;//0 公司合同 1 个人合同  2 报验单签名 3 结算单签名 4 修改个人合同 5 公司 处理报验单

@property(nonatomic ,copy)NSString *applyid;//0 公司合同 1 个人合同  2 报验单签名 3 结算单签名 4 修改个人合同

@end
