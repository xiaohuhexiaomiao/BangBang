//
//  NoticeModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/1/5.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject

@property (nonatomic, copy) NSString *add_time;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *xid;

@property (nonatomic, copy) NSString *information_id;//工程ID

@end
