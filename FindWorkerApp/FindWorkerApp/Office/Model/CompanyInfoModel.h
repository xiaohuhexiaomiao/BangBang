//
//  CompanyInfoModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/1.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyInfoModel : NSObject

@property(nonatomic , copy)NSString *add_time;

@property(nonatomic , copy)NSString *boss;

@property(nonatomic , copy)NSString *company_address;

@property(nonatomic , copy)NSString *company_id;

@property(nonatomic , copy)NSString *company_name;

@property(nonatomic , copy)NSString *company_tel;

@property(nonatomic , assign)NSInteger is_quit;



@end
