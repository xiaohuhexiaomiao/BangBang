//
//  SWTools.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWTools : NSObject

/**字符串转换为固定格式的日期，再转换成字符串 */
+ (NSString *)dateFormate:(NSString *)dateStr formate:(NSString *)formate;

@end
