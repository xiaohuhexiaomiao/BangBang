//
//  AcceptDetailController.h
//  BangBangGongRen
//
//  Created by cxz on 2018/3/20.
//  Copyright © 2018年 cxz. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface ReceiveAcceptDetailController : CXZBaseViewController

@property (nonatomic, assign) NSInteger operation_type;//0 上传 1修改

@property (nonatomic, assign) NSInteger contract_id;//合同id

@property (nonatomic, copy) NSString* apply_id;//验收id

@end
