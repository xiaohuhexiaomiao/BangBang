//
//  PersonalApprovalResultModel.h
//  FindWorkerApp
//
//  Created by cxz on 2018/5/9.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalApprovalResultModel : NSObject

@property(nonatomic ,copy) NSString *approval_personal_id;//个人审批 ID

@property(nonatomic ,assign) NSInteger approval_state;

@property(nonatomic ,assign) NSInteger can_approval;//公司ID

@property(nonatomic ,copy) NSString *handle_time;//

@property(nonatomic ,copy) NSString *handler_name;

@property(nonatomic ,copy) NSString *handler_uid;

@property(nonatomic ,copy) NSString *opinion;

@property(nonatomic ,copy) NSString *picture_enclosure;

@property(nonatomic ,copy) NSString *title;

@property(nonatomic ,copy) NSString *type;

@property(nonatomic ,copy) NSString *type_id;

@property(nonatomic ,copy) NSString *found_name;

@end
