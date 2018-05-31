//
//  ReplyApprovalContentModel.h
//  FindWorkerApp
//
//  Created by cxz on 2018/4/11.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyApprovalContentModel : NSObject

@property(nonatomic ,copy)NSString *descriptionStr;//简单详情

@property(nonatomic ,assign)NSInteger type;//审批表单类型

@property(nonatomic ,copy)NSString *approval_id;//审批id

@property(nonatomic ,copy)NSString *uid;//回复人uid

@property(nonatomic ,copy)NSString *name;//回复人姓名

@property(nonatomic ,copy)NSString *avatar;//回复人头像

@property(nonatomic ,copy)NSString *company_id;//

@property(nonatomic ,copy)NSString *add_time;//

@end
