//
//  NSDictionary+SWDictionary.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/16.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SWDictionary)

//字典转字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;


//字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
