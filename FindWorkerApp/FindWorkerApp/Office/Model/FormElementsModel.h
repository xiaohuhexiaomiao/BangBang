//
//  FormElementsModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/12/15.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormElementsModel : NSObject

@property(nonatomic ,assign)NSInteger field_id;

@property(nonatomic ,copy)NSString *flag;

@property(nonatomic ,assign)NSInteger form_element_id;

@property(nonatomic ,copy)NSString *id;

@property(nonatomic ,copy)NSString *meta_data;

@property(nonatomic ,copy)NSString *result;

@property(nonatomic ,copy)NSString *title;

@property(nonatomic ,copy)NSString *type;

@property(nonatomic ,copy)NSString *version;

@end
