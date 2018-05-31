//
//  AcceptInfoModel.h
//  BangBangGongRen
//
//  Created by cxz on 2018/3/27.
//  Copyright © 2018年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ApplyInfoModel;
@interface AcceptInfoModel : NSObject

@property (nonatomic, copy) NSString* contract_id;//合同id

@property (nonatomic, copy) NSString *contract_name;//

@property (nonatomic, copy) NSString *worker_id;//	乙方id

@property (nonatomic, copy) NSString *worker_name;//	乙方

@property (nonatomic, copy) NSString *contract_begin_time;//合同开始时间

@property (nonatomic, copy) NSString *contract_end_time;//合同结束时间

@property (nonatomic, assign) double  subtotal;//合同总金额

@property (nonatomic, assign) double amount_received;//已领金额

@property (nonatomic, strong) ApplyInfoModel *apply_content;//报验单id

@end
