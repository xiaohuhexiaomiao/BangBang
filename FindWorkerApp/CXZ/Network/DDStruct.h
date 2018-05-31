//
//  CXZStruct.h
//  DiaoDiao
//
//  Created by wangzeng on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#ifndef diaodiao_Struct_h
#define diaodiao_Struct_h

#import "Jastor.h"

#import "CXZ.h"

@interface PageParams : NSObject
@property(nonatomic, strong) NSMutableArray* result;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int num;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL didLoaded;

@end

#endif
