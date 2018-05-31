//
//  UploadPhotoAndTextViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2018/5/28.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface UploadPhotoAndTextViewController : CXZBaseViewController

@property(nonatomic ,copy)NSString *companyID;

@property(nonatomic ,assign)NSInteger payType;//请款依据类型

@property(nonatomic ,copy)NSString *contractName;//合同名称

@property(nonatomic ,copy)NSString *approval_ID;//

@end
