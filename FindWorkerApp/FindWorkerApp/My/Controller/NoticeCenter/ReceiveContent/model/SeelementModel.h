//
//  SeelementModel.h
//  BangBangGongRen
//
//  Created by cxz on 2018/3/28.
//  Copyright © 2018年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeelementModel : NSObject

@property (nonatomic, copy) NSString* settlement_type_id;//报验单类型id

@property (nonatomic, copy) NSString* form_element_ids;//

@property (nonatomic, copy) NSString *inspection_name;//报验单名称

@property (nonatomic, copy) NSString *settlement_name;//

@end
