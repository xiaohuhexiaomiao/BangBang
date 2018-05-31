//
//  SignDetailModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/23.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SignFormModel;

@interface SignDetailModel : NSObject

@property(nonatomic ,copy) NSString *add_time;

@property(nonatomic ,copy) NSString *avatar;

@property(nonatomic ,copy) NSString *company_id;

@property(nonatomic ,strong) SignFormModel *form_data;

@property(nonatomic ,copy) NSString *found_id;

@property(nonatomic ,assign) BOOL is_del;

@property(nonatomic ,copy) NSString *like_id;

@property(nonatomic ,copy) NSString *name;

@property(nonatomic ,copy) NSString *publish_id;

@property(nonatomic ,assign) NSInteger type;

@property(nonatomic ,copy) NSString *type_id;

@end
