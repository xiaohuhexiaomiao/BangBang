//
//  CXZStringUtil.m
//  ImHere
//
//  Created by 卢明渊 on 15/3/19.
//  Copyright (c) 2015年 我在这. All rights reserved.
//

#import "CXZStringUtil.h"
#import "MarkupParser.h"
#import "CustomMethod.h"
#import "NSAttributedString+Attributes.h"
#import "CXZ.h"
#import "CommonCrypto/CommonDigest.h"
//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>
@implementation CXZStringUtil

+ (CGFloat)labelHeightWithContent:(NSString *)content withWidth:(CGFloat)width {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"];
    NSString *text = [CustomMethod transformString:content emojiDic:[NSDictionary dictionaryWithContentsOfFile:path]];
    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup: text];
    [attString setFont:[UIFont systemFontOfSize:14.0f]];
    CGSize size = [attString sizeConstrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;
}
+ (CGSize)labeSizeWithContent:(NSString *)content withWidth:(CGFloat)width {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"];
    NSString *text = [CustomMethod transformString:content emojiDic:[NSDictionary dictionaryWithContentsOfFile:path]];
    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup: text];
    [attString setFont:[UIFont systemFontOfSize:14.0f]];
    CGSize size = [attString sizeConstrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
    return size;
}

+ (CGSize)setLabel:(OHAttributedLabel *)label withContent:(NSString *)content withWidth:(CGFloat)width {
    NSString * path=[[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"];
    NSString *text = [CustomMethod transformString:content emojiDic:[NSDictionary dictionaryWithContentsOfFile:path]];
    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup: text];
    [attString setFont:[UIFont systemFontOfSize:14]];
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    [label setAttString:attString withImages:wk_markupParser.images];
    return [CXZStringUtil labeSizeWithContent:content withWidth:width];
}

+ (CGSize)setLabel:(OHAttributedLabel *)label withForwardContent:(NSString *)content withSize:(CGSize)size {
    NSError* error;
    NSArray* data = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSMutableString *forward_content = [[NSMutableString alloc]init];
    [label removeAllCustomLinks];
    NSMutableDictionary* linkMap = [NSMutableDictionary dictionary];
    for(NSDictionary* item in data) {
        NSString* nick = [item objectForKey:@"nickname"];
        NSString* word = [item objectForKey:@"word"];
        if(item == [data firstObject]){
            [forward_content appendString:[NSString stringWithFormat:@"%@", word]];
        }else{
            [forward_content appendString:[NSString stringWithFormat:@"//@%@:%@", nick, word]];
            NSString* key = [NSString stringWithFormat:@"@%@:", nick];
            [linkMap setObject:[NSURL URLWithString:[item objectForKey:@"uid"]] forKey:key];
        }
    }
    
    NSString * path=[[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"];
    NSString *text = [CustomMethod transformString:forward_content emojiDic:[NSDictionary dictionaryWithContentsOfFile:path]];
    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup: text];
    [attString setFont:[UIFont systemFontOfSize:14]];
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    [label setAttString:attString withImages:wk_markupParser.images];
    
    NSString* resultString = attString.string;
    NSRange currentRange = {0, resultString.length};
    for (NSString* key in linkMap) {
        currentRange = [resultString rangeOfString:key options:0 range:currentRange];
        [label addCustomLink:[linkMap objectForKey:key] inRange:currentRange];
        currentRange.location = currentRange.location+currentRange.length;
        currentRange.length = resultString.length-currentRange.location;
    }
    CGFloat height = [CXZStringUtil labelHeightWithContent:forward_content withWidth:size.width];
    if (size.height == 0) {
        return CGSizeMake(size.width, height);
    } else {
        return CGSizeMake(size.width, MIN(size.height, height));
    }
}

+(CGSize)setLabel:(OHAttributedLabel *)label withForwardContent:(NSString *)content withWidth:(CGFloat)width withLenth:(int)nameLength{
    NSString * path=[[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"];
    NSString *text = [CustomMethod transformString:content emojiDic:[NSDictionary dictionaryWithContentsOfFile:path]];
    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup: text];
    [attString setFont:[UIFont systemFontOfSize:14]];
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    [label setAttString:attString withImages:wk_markupParser.images];
    [attString addAttribute:NSForegroundColorAttributeName value:HexRGB(0x0070BD) range:NSMakeRange(2, nameLength)];
    return [CXZStringUtil labeSizeWithContent:content withWidth:width];
}

+ (NSString *)getRealForwardContent:(NSString *)content {
    NSError* error;
    NSArray* data = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    NSMutableString *forward_content = [[NSMutableString alloc]init];
    for(NSDictionary* item in data) {
        NSString* nick = [item objectForKey:@"nickname"];
        NSString* word = [item objectForKey:@"word"];
        if(item == [data firstObject]){
            [forward_content appendString:[NSString stringWithFormat:@"%@",word]];
        }else{
            [forward_content appendString:[NSString stringWithFormat:@"//@%@:%@", nick, word]];
        }
    }
    return forward_content;
}

// 数值变化
+(NSString*)changePrice:(CGFloat)price{
    CGFloat newPrice = 0;
    NSString *danwei = @"万";
    if ((int)price>10000) {
        newPrice = price / 10000 ;
    }
    if ((int)price>10000000) {
        newPrice = price / 10000000 ;
        danwei = @"千万";
    }
    if ((int)price>100000000) {
        newPrice = price / 100000000 ;
        danwei = @"亿";
    }
    NSString *newstr = [[NSString alloc] initWithFormat:@"%.0f%@",newPrice,danwei];
    return newstr;
}

//判断是否为数字
+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

// 数值变化
+(NSString*)changeNum:(int)num{
    int newPrice = num;
    NSString*danwei=@"";
    if (num>999) {
        newPrice = 999 ;
        danwei=@"+";
    }

    NSString *newstr = [[NSString alloc] initWithFormat:@"%d%@",newPrice,danwei];
    return newstr;
}

+(NSString*)getConstellation:(int)num{
    NSString *constellation=@" ";
    switch (num) {
        case 1:
            constellation=@"水瓶座";
            break;
        case 2:
            constellation=@"双鱼座";
            break;
        case 3:
            constellation=@"白羊座";
            break;
        case 4:
            constellation=@"金牛座";
            break;
        case 5:
            constellation=@"双子座";
            break;
        case 6:
            constellation=@"巨蟹座";
            break;
        case 7:
            constellation=@"狮子座";
            break;
        case 8:
            constellation=@"处女座";
            break;
        case 9:
            constellation=@"天秤座";
            break;
        case 10:
            constellation=@"天蝎座";
            break;
        case 11:
            constellation=@"射手座";
            break;
        case 12:
            constellation=@"摩羯座";
            break;
        default:
            break;
    }
    return  constellation;
}

+(NSString*)getJuli:(CGFloat)num{
    NSString*fhz=@"";
    CGFloat newNum=num;
    if (newNum>1000) {
        fhz=@"千里之外";
    }else{
        fhz=[NSString stringWithFormat:@"%0.02fkm",newNum];
    }
    return fhz;
}

+ (UIImage *)imageFromBase64String:(NSString *)base64
{
    if (!IS_EMPTY(base64)) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *_decodedImage = [UIImage imageWithData:imageData];
        return _decodedImage;
    }
    else {
        return nil;
    }
}

+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (NSString *)filterEmoji:(NSString *)string {
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [string UTF8String];
    char *newUTF8 = malloc( sizeof(char) * len );
    int j = 0;
    
    //0xF0(4) 0xE2(3) 0xE3(3) 0xC2(2) 0x30---0x39(4)
    for ( int i = 0; i < len; i++ ) {
        unsigned int c = utf8;
        BOOL isControlChar = NO;
        if ( c == 4294967280 ||
            c == 4294967089 ||
            c == 4294967090 ||
            c == 4294967091 ||
            c == 4294967092 ||
            c == 4294967093 ||
            c == 4294967094 ||
            c == 4294967095 ||
            c == 4294967096 ||
            c == 4294967097 ||
            c == 4294967088 ) {
            i = i + 3;
            isControlChar = YES;
        }
        if ( c == 4294967266 || c == 4294967267 ) {
            i = i + 2;
            isControlChar = YES;
        }
        if ( c == 4294967234 ) {
            i = i + 1;
            isControlChar = YES;
        }
        if ( !isControlChar ) {
            newUTF8[j] = utf8;
            j++;
        }
    }
    newUTF8[j] = '\0';
    NSString *encrypted = [NSString stringWithCString:(const char*)newUTF8
                                             encoding:NSUTF8StringEncoding];
    free( newUTF8 );
    return encrypted;
}

//是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+(int) getzflen: (NSString *) inPutText{
    int fhz=0;
    for (int i = 0; i<[inPutText length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [inPutText substringWithRange:NSMakeRange(i, 1)];
        fhz++;
        if ([self isZhongwen:s]) {
            fhz++;
        }
    }
    return  fhz;
}

+ (BOOL)isZhongwen:(NSString*)string
{
    NSString *      regex = @"[\u4e00-\u9fa5]";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}


@end
