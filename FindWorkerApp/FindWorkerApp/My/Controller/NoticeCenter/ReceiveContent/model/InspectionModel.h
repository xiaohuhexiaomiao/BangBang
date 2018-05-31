//
//  InspectionModel.h
//  BangBangGongRen
//
//  Created by cxz on 2018/3/28.
//  Copyright © 2018年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InspectionModel : NSObject

@property (nonatomic, copy) NSString* inspection_type_id;//报验单类型id

@property (nonatomic, copy) NSString* form_element_ids;//

@property (nonatomic, copy) NSString *inspection_name;//报验单名称

@property (nonatomic, copy) NSString *refer_html;//

@end
