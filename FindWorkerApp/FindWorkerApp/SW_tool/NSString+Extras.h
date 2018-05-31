//
//  NSString+Extras.h
//  FindWorkerApp
//
//  Created by cxz on 2017/1/11.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extras)

- (NSString*)toPinyinWithTone;

- (NSString*)toPinyinWithoutTone;

+ (BOOL) isBlankString:(NSString *)string;

+ (NSString*)dictionaryToJson:(id)dic;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;

/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum;
/**
 *  将金额转化为大写
 */
+(NSString *)digitUppercase:(NSString *)numstr;

+(NSTimeInterval)toTimeIntervalWithDateString:(NSString*)dateString;//转化时间戳

+(NSString*)toDateStringWithTimeInterval:(NSTimeInterval)interval;//时间戳转化成日期 格式 :yyyy年MM月dd日

+(NSString*)toMondyWithDateString:(NSString*)dateString;//根据当前日期获取本周第一天

+(NSString*)toSundyWithDateString:(NSString*)dateString;//根据当前日期获取本周最后一天

+(NSString*)toDateBeforOrAfterOfDays:(NSInteger)days withDate:(NSString*)currentDate;//获取多少天前或后的日期

@end
