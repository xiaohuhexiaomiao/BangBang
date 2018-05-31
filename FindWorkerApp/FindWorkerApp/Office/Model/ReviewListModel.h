//
//  ReviewListModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/6/17.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewListModel : NSObject

@property(nonatomic ,copy) NSString *participation_id;

@property(nonatomic ,copy) NSString *approval_id;

@property(nonatomic ,copy) NSString *uid;

@property(nonatomic ,copy) NSString *approval_order;

@property(nonatomic ,copy) NSString *is_agree;

@property(nonatomic ,copy) NSString *opinion;

@property(nonatomic ,copy) NSString *sign;

@property(nonatomic ,copy) NSString *add_time;// 创建时间  注：对于已处理文件为：当前人审批时间

@property(nonatomic ,copy) NSString *company_id;

@property(nonatomic ,copy) NSString *company_name;

@property(nonatomic ,copy) NSString *found_uid;

@property(nonatomic ,assign) NSInteger approval_state;

@property(nonatomic ,copy) NSString *a_id;

@property(nonatomic ,copy) NSString *a_num;

@property(nonatomic ,assign) NSInteger type;

@property(nonatomic ,copy) NSString *type_id;

@property(nonatomic ,copy) NSString *name;

@property(nonatomic ,copy) NSString *avatar;

@property(nonatomic ,copy) NSString *title;

@property(nonatomic ,copy) NSString *withdrawal_reason;//撤销理由

@property(nonatomic ,copy) NSString *creat_time;// 对于已处理为 ：发起时间

@property(nonatomic ,copy) NSString *tagging;// 标记颜色

@property(nonatomic ,copy) NSString *save_time;// 对于已处理为 ：财务回执时间

@property(nonatomic ,copy) NSString *receipt_content;// 财务回执内容

@property(nonatomic ,copy) NSString *finance_state;// 财务回执状态 0 未处理 1回执 2忽略

@property(nonatomic ,copy) NSString *approval_personal_id;//个人审批id

@end
