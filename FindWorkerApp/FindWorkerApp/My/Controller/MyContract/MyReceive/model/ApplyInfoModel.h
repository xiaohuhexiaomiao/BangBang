//
//  ApplyInfoModel.h
//  BangBangGongRen
//
//  Created by cxz on 2018/3/27.
//  Copyright © 2018年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyInfoModel : NSObject

@property (nonatomic, copy) NSString *apply_id;//

@property (nonatomic, copy) NSString *inspection_id;//报验单id

@property (nonatomic, assign) NSInteger inspection_state;//报验单状态

@property (nonatomic, copy) NSString *inspection_reason;//拒绝理由

@property (nonatomic, copy) NSString *settlement_id;//结验单id

@property (nonatomic, assign) NSInteger settlement_state;//结验单状态  0 未处理 1 同意 2 拒绝

@property (nonatomic, copy) NSString *settlement_reason;//拒绝理由

@property (nonatomic, assign) double money;//本次结算金额


@end
