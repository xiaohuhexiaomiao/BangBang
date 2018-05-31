//
//  CustomMethod.h
//  MessageList
//
//  Created by 刘超 on 13-11-13.
//  Copyright (c) 2013年 刘超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegexKitLite.h"
#import "OHAttributedLabel.h"
#import "SCGIFImageView.h"

#define TELPHONE_REGEX @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[358]+\\d{9}|\\d{8}|\\d{7}"

#define WWW_REGEX @"(https?|ftp|file)+://[^\\s]*"

#define EMAIL_REGEX @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*.\\w+([-.]\\w+)*"

@interface CustomMethod : NSObject

+ (NSString *)escapedString:(NSString *)oldString;
+ (void)drawImage:(OHAttributedLabel *)label;
+ (UIView*)getDrawView:(OHAttributedLabel *)label;
+ (NSMutableArray *)addHttpArr:(NSString *)text;
+ (NSMutableArray *)addPhoneNumArr:(NSString *)text;
+ (NSMutableArray *)addEmailArr:(NSString *)text;
+ (NSString *)transformString:(NSString *)originalStr  emojiDic:(NSDictionary *)_emojiDic;

@end
