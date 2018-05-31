//
//  DDRespond.m
//  DiaoDiao
//
//  Created by wangzeng on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import "BaseRespond.h"
#import "CXZ.h"

@implementation BaseRespond

- (id)initWithJsonData:(NSData *)jsonData {
    NSError* error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (dic != nil && [dic count] > 0 && (self = [super initWithDictionary:dic])) {
        NSString* dataStr = (NSString*)self.data;
        if(!IS_EMPTY(dataStr)) {
            self.data = [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
            if(!self.data) {
                self.data = (NSDictionary*)dataStr;
            }
        }
    }
    return self;
}

- (Class)data_class:(NSNumber*)index {
    return [NSDictionary class];
}

@end
