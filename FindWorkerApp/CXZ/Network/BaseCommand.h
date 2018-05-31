//
//  CXZCommand.h
//  DiaoDiao
//
//  Created by wangzeng on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
#import <UIKit/UIKit.h>

#pragma mark - 消息基础类
@interface BaseCommand : Jastor
@property(nonatomic, retain) NSString *channelId; // 自己的uid
@property(nonatomic, copy) NSString* app_token; // token 验证
//@property(nonatomic,assign)NSInteger _request_timestamp;
@property(nonatomic, copy) NSString* addr; // 本地使用 拼接url用的
@property (nonatomic, retain) NSString *phone_type;
@property(nonatomic, copy) Class respondType;

@property (nonatomic, retain) NSString *skey;// token 验证

@property (nonatomic, retain) NSString *skey_uid;

- (NSString*) toJsonString;
- (NSData*) toJsonData;
- (NSDictionary*) toDicData;

@end

@interface BaseCommandN : Jastor
@property(nonatomic, copy) NSString* addr; // 本地使用 拼接url用的
@property(nonatomic, copy) Class respondType;

- (NSString*) toJsonString;
- (NSData*) toJsonData;

@end

// 注册
@interface Register : BaseCommand

@property(nonatomic, copy) NSString* account;
@property(nonatomic, copy) NSString* code;
@property(nonatomic, copy) NSString* nick;
@property(nonatomic, assign) int type;
@property(nonatomic, assign) int sex;
@property(nonatomic, copy) NSString* head;
@end


//登录命令
@interface LoginRequest : BaseCommand

@property(nonatomic, copy) NSString* account; // 用户名
@property(nonatomic, copy) NSString* code; // 验证码
@property(nonatomic, assign) int type;
@property(nonatomic,strong)NSString*access_token;
@end

// 检查帐号
@interface CheckAccount : BaseCommand

@property(nonatomic, copy) NSString* account;
@property(nonatomic, assign) int type; // 1-手机，2-qq，3-微信，4-微博

@end

//获取验证码
@interface GetVerifyCode : BaseCommand

@property(nonatomic, copy) NSString* mobile;

@end

//验证验证码
@interface VerifyCode : BaseCommand

@property(nonatomic, copy) NSString* mobile;
@property(nonatomic, copy) NSString* verify_code;
@end

//重置密码
@interface ResetPassword : BaseCommand

@property(nonatomic, copy) NSString* mobile;
@property(nonatomic, copy) NSString* newpass;

@end

//修改密码
@interface EditPassword : BaseCommand

@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString* oldpass;
@property(nonatomic, copy) NSString* newpass;

- (void)editPassword:(NSString*)oldpass NewPass:(NSString*)newpass mobile:(NSString *)mobile;

@end

