//
//  WokerTypeModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/9/22.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WokerTypeModel : NSObject

@property (nonatomic, copy) NSString *wid;

@property (nonatomic, copy) NSString *type_name;

@property (nonatomic, assign) BOOL is_manage;

@end
