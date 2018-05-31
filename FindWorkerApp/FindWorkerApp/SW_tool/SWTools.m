//
//  SWTools.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWTools.h"

@implementation SWTools

/**字符串转换为固定格式的日期，再转换成字符串 */
+ (NSString *)dateFormate:(NSString *)dateStr formate:(NSString *)formate {
    
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    
    [dateFormate setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    
    NSDate *date = [dateFormate dateFromString:dateStr];
    
    NSDateFormatter *dateFormate1 = [[NSDateFormatter alloc] init];
    
    [dateFormate1 setDateFormat:@"yyyy-MM-dd"]; //设置时间固定格式
    
    return [dateFormate1 stringFromDate:date];
    
}

@end
