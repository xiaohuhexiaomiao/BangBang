//
//  NSString+Extras.m
//  FindWorkerApp
//
//  Created by cxz on 2017/1/11.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "NSString+Extras.h"

@implementation NSString (Extras)

- (NSString*)toPinyinWithTone{
    NSMutableString *str = [self mutableCopy];
    CFMutableStringRef cfstr = (__bridge CFMutableStringRef)(str);
    //CFRange strRange = CFRangeMake(0, str.length); //传 |Null| 表示所有都转换
    CFStringTransform(cfstr, NULL, kCFStringTransformMandarinLatin, false);
    return str;
}

- (NSString*)toPinyinWithoutTone{
    NSMutableString *str = [[self toPinyinWithTone]mutableCopy];
    CFMutableStringRef cfstr = (__bridge CFMutableStringRef)(str);
    //CFRange strRange = CFRangeMake(0, str.length); //传 |Null| 表示所有都转换
    CFStringTransform(cfstr, NULL, kCFStringTransformStripDiacritics, false);
    return str;
}
+(BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    NSString *str;
    if (![string isKindOfClass:[NSString class]]) {
        str = [NSString stringWithFormat:@"%@",str];
    }else{
        str = string;
    }
    NSString *tempStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (tempStr.length == 0) {
        return YES;
    }
    return NO;
}

//数组 字典 转化json
+ (NSString*)dictionaryToJson:(id )dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        //        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSArray *)arrayWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        //        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
//    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *chineseNumeralsArray = @[@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

+(NSString *)digitUppercase:(NSString *)numstr{
    double numberals=[numstr doubleValue];
    NSArray *numberchar = @[@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"];
    NSArray *inunitchar = @[@"",@"拾",@"佰",@"仟"];
    NSArray *unitname = @[@"",@"万",@"亿",@"万亿"];
    //金额乘以100转换成字符串（去除圆角分数值）
    NSString *valstr=[NSString stringWithFormat:@"%.2f",numberals];
    NSString *prefix;
    NSString *suffix;
    if (valstr.length<=2) {
        prefix=@"零元";
        if (valstr.length==0) {
            suffix=@"零角零分";
        }
        else if (valstr.length==1)
        {
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[valstr intValue]]];
        }
        else
        {
            NSString *head=[valstr substringToIndex:1];
            NSString *foot=[valstr substringFromIndex:1];
            suffix = [NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[head intValue]],[numberchar  objectAtIndex:[foot intValue]]];
        }
    }
    else
    {
        prefix=@"";
        suffix=@"";
        NSInteger flag = valstr.length - 2;
        NSString *head=[valstr substringToIndex:flag - 1];
        NSString *foot=[valstr substringFromIndex:flag];
        if (head.length>13) {
            return@"数值太大（最大支持13位整数），无法处理";
        }
        //处理整数部分
        NSMutableArray *ch=[[NSMutableArray alloc]init];
        for (int i = 0; i < head.length; i++) {
            NSString * str=[NSString stringWithFormat:@"%x",[head characterAtIndex:i]-'0'];
            [ch addObject:str];
        }
        int zeronum=0;
        
        for (int i=0; i<ch.count; i++) {
            int index=(ch.count -i-1)%4;//取段内位置
            NSInteger indexloc=(ch.count -i-1)/4;//取段位置
            if ([[ch objectAtIndex:i]isEqualToString:@"0"]) {
                zeronum++;
            }
            else
            {
                if (zeronum!=0) {
                    if (index!=3) {
                        prefix=[prefix stringByAppendingString:@"零"];
                    }
                    zeronum=0;
                }
                prefix=[prefix stringByAppendingString:[numberchar objectAtIndex:[[ch objectAtIndex:i]intValue]]];
                prefix=[prefix stringByAppendingString:[inunitchar objectAtIndex:index]];
            }
            if (index ==0 && zeronum<4) {
                prefix=[prefix stringByAppendingString:[unitname objectAtIndex:indexloc]];
            }
        }
        prefix =[prefix stringByAppendingString:@"元"];
        NSString *foot_head =  [foot substringToIndex:1];
        NSString *foot_last = [foot substringFromIndex:1];
        //处理小数位
        if ([foot_head isEqualToString:@"0"] && [foot_last isEqualToString:@"0"] ) {
            suffix =[suffix stringByAppendingString:@"整"];
        }
        else if ([foot_head isEqualToString:@"0"] && ![foot_last isEqualToString:@"0"])
        {
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"零%@分",[numberchar objectAtIndex:[footch intValue] ]];
        }
        else if (![foot_head isEqualToString:@"0"]&& [foot_last isEqualToString:@"0"])
        {
           NSString *headch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:0]-'0'];
            suffix=[NSString stringWithFormat:@"%@角整",[numberchar objectAtIndex:[headch intValue] ]];
        }
//        else if ([foot hasPrefix:@"0"])
//        {
//            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
//            suffix=[NSString stringWithFormat:@"零%@分整",[numberchar objectAtIndex:[footch intValue] ]];
//        }
        else
        {
            NSString *headch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:0]-'0'];
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[headch intValue]],[numberchar  objectAtIndex:[footch intValue]]];
        }
    }
    return [prefix stringByAppendingString:suffix];
}



+(NSTimeInterval)toTimeIntervalWithDateString:(NSString*)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [formatter dateFromString:dateString];
    NSTimeInterval interval = [date timeIntervalSince1970] ;
    return interval;
}

+(NSString*)toDateStringWithTimeInterval:(NSTimeInterval)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+(NSString*)toMondyWithDateString:(NSString*)dateString
{
    NSString *monday;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [formatter dateFromString:dateString];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    NSInteger weekDay = theComponents.weekday;//,@"Sunday", @"周一", @"周二/3", @"周三", @"周四", @"周五", @"周六"
    if (weekDay == 2) {
        monday = dateString;
    }else if (weekDay == 1){
        NSDate *tomorrow = [NSDate dateWithTimeInterval:-6*24*60*60 sinceDate:date];
        monday = [formatter stringFromDate:tomorrow];
    }else{
        NSDate *tomorrow = [NSDate dateWithTimeInterval:-(weekDay-2)*24*60*60 sinceDate:date];
        monday = [formatter stringFromDate:tomorrow];
    }
    return monday;
}


+(NSString*)toSundyWithDateString:(NSString*)dateString
{
    NSString *sunday;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [formatter dateFromString:dateString];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    NSInteger weekDay = theComponents.weekday;//,@"Sunday", @"周一", @"周二/3", @"周三", @"周四", @"周五", @"周六"
    if (weekDay == 1) {
        sunday = dateString;
    }else{
        NSDate *tomorrow = [NSDate dateWithTimeInterval:(7-weekDay+1)*24*60*60 sinceDate:date];
        sunday = [formatter stringFromDate:tomorrow];
    }
    return sunday;
}

+(NSString*)toDateBeforOrAfterOfDays:(NSInteger)days withDate:(NSString *)currentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [formatter dateFromString:currentDate];
    NSDate *yesterday = [NSDate dateWithTimeInterval:days*24*60*60 sinceDate:date];
    NSString *yesterdayStr = [formatter stringFromDate:yesterday];
    return yesterdayStr;
}

@end
