//
//  CXZStringUtil.h
//  ImHere
//
//  Created by 卢明渊 on 15/3/19.
//  Copyright (c) 2015年 我在这. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
//#import "MomentStruct.h"

@interface CXZStringUtil : NSObject


// 获取带表情的实际文本高度
+ (CGFloat) labelHeightWithContent:(NSString*)content withWidth:(CGFloat) width;

// 设置带表情的文本
+ (CGSize) setLabel:(OHAttributedLabel*) label withContent:(NSString*) content withWidth:(CGFloat) width;

// 设置带表情带链接的转发文本
+ (CGSize) setLabel:(OHAttributedLabel*) label withForwardContent:(NSString*) content withSize:(CGSize) size;

// 设置回复别人的回复且带表情的文本
+ (CGSize) setLabel:(OHAttributedLabel*) label withForwardContent:(NSString*) content withWidth:(CGFloat) width withLenth:(int)nameLength;

// 获取实际的转发文本
+ (NSString*) getRealForwardContent:(NSString*)content;

// 数值变化
+(NSString*)changePrice:(CGFloat)price;

//判断是否为数字
+ (BOOL)isPureInt:(NSString *)string;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;

//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email;

+(NSString*)changeNum:(int)num;

+(NSString*)getConstellation:(int)num;

+(NSString*)getJuli:(CGFloat)num;

+ (UIImage *)imageFromBase64String:(NSString *)base64;

//MD5加密
+(NSString *) md5: (NSString *) inPutText;

//过滤emoji
+ (NSString *)filterEmoji:(NSString *)string;

//判断是否包换emoji
+ (BOOL)stringContainsEmoji:(NSString *)string;

//获取文字长度
+(int) getzflen: (NSString *) inPutText;
@end
