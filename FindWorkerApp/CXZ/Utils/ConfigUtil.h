//
//  ConfigUtil.h
//  ImHere
//
//  Created by 卢明渊 on 15/3/16.
//  Copyright (c) 2015年 我在这. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConfigUtil : UIView

+ (int) intWithKey:(NSString*) key;

+ (void) saveInt:(int) val withKey:(NSString*) key;

+ (BOOL) boolWithKey:(NSString*) key;

+ (BOOL) boolWithKey:(NSString*) key default:(BOOL) def;

+ (void) saveBool:(BOOL) val withKey:(NSString*) key;

+ (double)doubleWithKey:(NSString *)key;

+ (void)saveDouble:(double)val withKey:(NSString *)key;

+ (NSString*)stringWithKey:(NSString *)key;

+ (void)saveString:(NSString*)val withKey:(NSString *)key;

+ (BOOL)isalreadyHasObject:(NSString *)key;

+(NSObject *) getUserDefaults:(NSString *) name;

+(void) setUserDefaults:(NSObject *) defaults forKey:(NSString *) key;
@end
