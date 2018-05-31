//
//  CXZStruct.m
//  DiaoDiao
//
//  Created by wangzeng on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import "DDStruct.h"


@implementation PageParams

- (id)init {
    self = [super init];
    _num = 20;
    _page = 0;
    _hasMore = YES;
    _result = [NSMutableArray array];
    _didLoaded = NO;
    return self;
}

@end