//
//  NSObject+Ext.h
//  Aijia
//
//  Created by 黄黎雯 on 16/1/25.
//  Copyright © 2016年 黄黎雯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Ext)
/**
 * 对象序列成字典
 *
 * @param obj 需要序列化的对象
 *
 * @return 字典
 */
- (NSDictionary*)getDictionaryFromObject_Ext:(id)obj;

/**
 * 将对象序列换成JSON字符串
 *
 * @param obj 需要序列换的参数
 * @param error 失败时，失败信息
 *
 * @return 修改的json的数据data
 */
- (NSData*)getJSON_Ext:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;
@end
