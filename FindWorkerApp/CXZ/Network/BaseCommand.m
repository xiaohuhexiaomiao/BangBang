//
//  DDCommand.m
//  DiaoDiao
//
//  Created by wangzeng on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import "BaseCommand.h"
#import "BaseRespond.h"
#import "ConfigUtil.h"
#import "CXZ.h"
@implementation BaseCommand

- (instancetype) init {
    if (self = [super init]) {
        self.addr = @"";
        self.respondType = [BaseRespond class];
        self.channelId = [[NSUserDefaults standardUserDefaults] objectForKey:@"registerID"];
        self.phone_type = @"ios";
        self.app_token = [ConfigUtil stringWithKey:APP_TOKEN];
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"app_token"];
        self.skey = token;
        NSString *uid =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        self.skey_uid = uid;
    }
    return self;
}

- (NSString*) toJsonString {
    NSData* data = [self toJsonData];
    if (data != nil) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSData*) toJsonData {
    NSError* error = nil;
    NSDictionary *dic = [self toDictionary:^BOOL(NSString *propertyName) {
        if ([propertyName isEqualToString:@"addr"] ||
            [propertyName isEqualToString:@"respondType"]) {
            return NO;
        }
        return YES;
    }];
    NSData* result = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    if (error != nil) {
        return nil;
    }
    return result;
}

- (NSDictionary*) toDicData{
    NSDictionary *dic = [self toDictionary:^BOOL(NSString *propertyName) {
        if ([propertyName isEqualToString:@"addr"] ||
            [propertyName isEqualToString:@"respondType"]) {
            return NO;
        }
        return YES;
    }];
    return dic;
}
@end

@implementation BaseCommandN

- (id) init {
    if (self = [super init]) {
        self.addr = @"";
        self.respondType = [BaseRespond class];
    }
    return self;
}

- (NSString*) toJsonString {
    NSData* data = [self toJsonData];
    if (data != nil) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSData*) toJsonData {
    NSError* error = nil;
    NSDictionary *dic = [self toDictionary:^BOOL(NSString *propertyName) {
        if ([propertyName isEqualToString:@"addr"] ||
            [propertyName isEqualToString:@"respondType"]) {
            return NO;
        }
        return YES;
    }];
    NSData* result = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    if (error != nil) {
        return nil;
    }
    return result;
}
@end

// 注册
@implementation Register

- (id) init {
    if (self = [super init]) {
        self.addr = @"/Mobile/User/register";
        self.respondType = [BaseRespond class];
    }
    return self;
}

@end

//登录命令
@implementation LoginRequest

- (id) init {
    if (self = [super init]) {
        self.addr = @"/Mobile/User/login";
        self.respondType = [BaseRespond class];
    }
    return self;
}

@end

// 检查帐号
@implementation CheckAccount

- (id) init {
    if (self = [super init]) {
        self.addr = @"/Mobile/User/check_account";
        self.respondType = [BaseRespond class];
    }
    return self;
}

@end

// 获取验证码
@implementation GetVerifyCode

- (id) init {
    if (self = [super init]) {
        self.addr = @"/Mobile/App/get_verify_code";
        self.respondType = [BaseRespond class];
    }
    return self;
}

@end

//验证验证码
@implementation VerifyCode

- (id) init {
    if (self = [super init]) {
        self.addr = @"/App/verify_code";
        self.respondType = [BaseRespond class];
    }
    return self;
}

@end


//重置密码
@implementation ResetPassword

- (id) init {
    if (self = [super init]) {
        self.addr = @"/User/reset_password";
        self.respondType = [BaseRespond class];
    }
    return self;
}

@end

//修改密码
@implementation EditPassword

- (id) init {
    if (self = [super init]) {
        self.addr = @"/User/change_password";
        self.respondType = [BaseRespond class];
    }
    return self;
}

- (void)editPassword:(NSString*)oldpass NewPass:(NSString*)newpass mobile:(NSString *)mobile {
    self.mobile  = mobile;
    self.oldpass = oldpass;
    self.newpass = newpass;
}
@end


