//
//  ApplyForAcceptModel.h
//  BangBangGongRen
//
//  Created by cxz on 2018/3/27.
//  Copyright © 2018年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyForAcceptModel : NSObject

@property (nonatomic, assign) NSUInteger contract_id;//合同id

@property (nonatomic, assign) NSInteger id;//申请id

@property (nonatomic, copy) NSString *user_id;//

@property (nonatomic, copy) NSString *other_party_id;//甲方id

@property (nonatomic, copy) NSString *settlement_id;//结验单id

@property (nonatomic, copy) NSString *inspection_id;//报验单id

@property (nonatomic, copy) NSString *opinion;//意见

@property (nonatomic, assign) double money;//

@property (nonatomic, copy) NSString *add_time;//

@end
