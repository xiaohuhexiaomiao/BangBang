//
//  DDRespond.h
//  DiaoDiao
//
//  Created by wangzeng on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#ifndef diaodiao_Respond_h
#define diaodiao_Respond_h

#import <Foundation/Foundation.h>
#import "Jastor.h"

#pragma mark - 消息响应基础类
@interface BaseRespond : Jastor

@property(nonatomic, assign) int code;
@property(nonatomic, copy) NSString* message;
@property(nonatomic, strong) id data;

- (id)initWithJsonData:(NSData*)jsonData;
- (Class)data_class:(NSNumber*)index;

@end

#endif