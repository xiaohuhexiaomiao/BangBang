//
//  SignFormModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/23.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignFormModel : NSObject

@property(nonatomic ,copy) NSString *add_time;

@property(nonatomic ,copy) NSString *cc;

@property(nonatomic ,copy) NSString *company_id;

@property(nonatomic ,copy) NSString *describe;

@property(nonatomic ,strong) NSArray *enclosure;

@property(nonatomic ,assign) NSInteger form_type;

@property(nonatomic ,assign) BOOL is_del;

@property(nonatomic ,assign) float latitude;

@property(nonatomic ,assign) float longitude;

@property(nonatomic ,copy) NSString *punch_id;

@property(nonatomic ,copy) NSString *remarks;

@property(nonatomic ,copy) NSString *uid;
@end
