//
//  DiaryDetailModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FormData;
@interface DiaryDetailModel : NSObject

@property(nonatomic ,copy) NSString *add_time;

@property(nonatomic ,copy) NSString *avatar;

@property(nonatomic ,copy) NSString *company_id;

@property(nonatomic ,strong) FormData *form_data;

@property(nonatomic ,copy) NSString *found_id;

@property(nonatomic ,copy) NSString *like_id;

@property(nonatomic ,copy) NSString *name;

@property(nonatomic ,copy) NSString *publish_id;

@property(nonatomic ,copy) NSString *type;

@property(nonatomic ,copy) NSString *type_id;




@end
