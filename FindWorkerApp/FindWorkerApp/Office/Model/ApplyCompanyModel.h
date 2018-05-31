//
//  ApplyCompanyModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/1.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyCompanyModel : NSObject

@property(nonatomic , copy)NSString *add_time;

@property(nonatomic , copy)NSString *avatar;

@property(nonatomic , copy)NSString *company_tel;

@property(nonatomic , copy)NSString *company_id;//要申请加入的公司id

@property(nonatomic , copy)NSString *deal_with_id;

@property(nonatomic , copy)NSString *manage_uid;

@property(nonatomic , copy)NSString *request_content;

@property(nonatomic , copy)NSString *request_id;

@property(nonatomic , copy)NSString *request_state;

@property(nonatomic , assign)NSInteger request_type;

@property(nonatomic , copy)NSString *request_user_id;

@property(nonatomic , copy)NSString *request_user_name;

@property(nonatomic , copy)NSString *request_user_phone;

@property(nonatomic , assign)NSInteger state;//state：0 未处理，1 同意，2拒绝
@end
