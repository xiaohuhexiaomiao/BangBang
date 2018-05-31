//
//  ComporationModel.h
//  FindWorkerApp
//
//  Created by cxz on 2018/5/14.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComporationModel : NSObject

@property(nonatomic , copy)NSString *company_big_id;

@property(nonatomic , copy)NSString *company_big_name;

@property(nonatomic , copy)NSString *add_time;

@property(nonatomic , assign)BOOL is_del;


@end
