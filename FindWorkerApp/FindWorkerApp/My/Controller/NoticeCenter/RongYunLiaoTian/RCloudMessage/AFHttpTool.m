
//
//  AFHttpTool.m
//  RCloud_liv_demo
//
//  Created by Liv on 14-10-22.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "AFHttpTool.h"
#import "CXZ.h"
#import "AFNetworking.h"
#import <RongIMKit/RongIMKit.h>

#import "RCDSettingUserDefaults.h"

#define DevDemoServer @"http://119.254.110.241/"         // Beijing SUN-QUAN 测试环境（北京）
#define ProDemoServer @"http://119.254.110.79:8080/"     // Beijing Liu-Bei 线上环境（北京）
#define PrivateCloudDemoServer @"http://139.217.26.223/" //私有云测试

#define DemoServer @"http://api.sealtalk.im/" //线上正式环境
//#define DemoServer @"http://apiqa.rongcloud.net/" //线上非正式环境
//#define DemoServer @"http://api.hitalk.im/" //测试环境

//#define ContentType @"text/plain"
#define ContentType @"application/json"

@implementation AFHttpTool

+ (AFHttpTool *)shareInstance {
    static AFHttpTool *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

// get user info
+ (void)getUserInfo:(NSString *)userId success:(void (^)(id response))success failure:(void (^)(NSError *err))failure {
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:[NSString stringWithFormat:@"user/%@", userId]
//                           params:nil
//                          success:success
//                          failure:failure];
}

// set user portraitUri
+ (void)setUserPortraitUri:(NSString *)portraitUrl
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{@"portraitUri" : portraitUrl};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"user/set_portrait_uri"
//                           params:params
//                          success:success
//                          failure:failure];
}

// invite user
+ (void)inviteUser:(NSString *)userId success:(void (^)(id response))success failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{
//        @"friendId" : userId,
//        @"message" : [NSString stringWithFormat:@"我是%@", [RCIM sharedRCIM].currentUserInfo.name]
//    };
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"friendship/invite"
//                           params:params
//                          success:success
//                          failure:failure];
}

// find user by phone
+ (void)findUserByPhone:(NSString *)Phone
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure {
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:[NSString stringWithFormat:@"user/find/86/%@", Phone]
//                           params:nil
//                          success:success
//                          failure:failure];
}

// get token
+ (void)getTokenSuccess:(void (^)(id response))success failure:(void (^)(NSError *err))failure {
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:@"user/get_token"
//                           params:nil
//                          success:success
//                          failure:failure];
}

// get friends
+ (void)getFriendsSuccess:(void (^)(id response))success failure:(void (^)(NSError *err))failure {
    //获取包含自己在内的全部注册用户数据
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:@"friends" params:nil success:success failure:failure];
}

// get upload image token
+ (void)getUploadImageTokensuccess:(void (^)(id response))success failure:(void (^)(NSError *err))failure {
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:@"user/get_image_token"
//                           params:nil
//                          success:success
//                          failure:failure];
}

// upload file
+ (void)uploadFile:(NSData *)fileData
            userId:(NSString *)userId
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure {
//    [AFHttpTool getUploadImageTokensuccess:^(id response) {
//        if ([response[@"code"] integerValue] == 200) {
//            NSDictionary *result = response[@"result"];
//            NSString *defaultDomain = result[@"domain"];
//            NSString *uploadUrl = result[@"upload_url"];
//            if (uploadUrl.length > 0 && ![uploadUrl hasPrefix:@"http"]) {
//                uploadUrl = [NSString stringWithFormat:@"http://%@", uploadUrl];
//            }
//            [DEFAULTS setObject:defaultDomain forKey:@"QiNiuDomain"];
//            [DEFAULTS synchronize];
//
//            //设置七牛的Token
//            NSString *token = result[@"token"];
//            NSMutableDictionary *params = [NSMutableDictionary new];
//            [params setValue:token forKey:@"token"];
//
//            //获取系统当前的时间戳
//            NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
//            NSTimeInterval now = [dat timeIntervalSince1970] * 1000;
//            NSString *timeString = [NSString stringWithFormat:@"%f", now];
//            NSString *key = [NSString stringWithFormat:@"%@%@", userId, timeString];
//            //去掉字符串中的.
//            NSMutableString *str = [NSMutableString stringWithString:key];
//            for (int i = 0; i < str.length; i++) {
//                unichar c = [str characterAtIndex:i];
//                NSRange range = NSMakeRange(i, 1);
//                if (c == '.') { //此处可以是任何字符
//                    [str deleteCharactersInRange:range];
//                    --i;
//                }
//            }
//            key = [NSString stringWithString:str];
//            [params setValue:key forKey:@"key"];
//
//            NSMutableDictionary *ret = [NSMutableDictionary dictionary];
//            [params addEntriesFromDictionary:ret];
//
//            NSString *url = uploadUrl.length > 0 ? uploadUrl : @"https://up.qbox.me";
//
//            NSData *imageData = fileData;
//
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            if (uploadUrl.length > 0) {
//                NSMutableSet *contentTypes =
//                    [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
//                [contentTypes addObject:@"text/html"];
//                manager.responseSerializer.acceptableContentTypes = [contentTypes copy];
//            }
//            [manager POST:url
//                parameters:params
//                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                    [formData appendPartWithFileData:imageData
//                                                name:@"file"
//                                            fileName:key
//                                            mimeType:@"application/octet-stream"];
//                }
//                success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    if (uploadUrl.length > 0) {
//                        NSMutableDictionary *responseDic =
//                            [[NSMutableDictionary alloc] initWithDictionary:responseObject];
//                        [responseDic setValue:defaultDomain forKey:@"domain"];
//                        success([responseDic copy]);
//                    } else {
//                        success(responseObject);
//                    }
//
//                }
//                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    NSLog(@"请求失败");
//                }];
//        }
//    }
//                                   failure:^(NSError *err){
//
//                                   }];
}

// get square info
+ (void)getSquareInfoSuccess:(void (^)(id response))success Failure:(void (^)(NSError *err))failure {
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:@"misc/demo_square"
//                           params:nil
//                          success:success
//                          failure:failure];
}

// create group
+ (void)createGroupWithGroupName:(NSString *)groupName
                 groupMemberList:(NSArray *)groupMemberList
                         success:(void (^)(id response))success
                         failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{@"name" : groupName, @"memberIds" : groupMemberList};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"group/create"
//                           params:params
//                          success:success
//                          failure:failure];
}

+ (void)getMyGroupsSuccess:(void (^)(id response))success failure:(void (^)(NSError *err))failure {
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:@"user/groups" params:nil success:success failure:failure];
}

// get group by id
+ (void)getGroupByID:(NSString *)groupID
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure {
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:[NSString stringWithFormat:@"group/%@", groupID]
//                           params:nil
//                          success:success
//                          failure:failure];
}

// set group portraitUri
+ (void)setGroupPortraitUri:(NSString *)portraitUrl
                    groupId:(NSString *)groupId
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{@"groupId" : groupId, @"portraitUri" : portraitUrl};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"group/set_portrait_uri"
//                           params:params
//                          success:success
//                          failure:failure];
}

// get group members by id
+ (void)getGroupMembersByID:(NSString *)groupID
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure {
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:[NSString stringWithFormat:@"group/%@/members", groupID]
//                           params:nil
//                          success:success
//                          failure:failure];
}

// join group by groupId
+ (void)joinGroupWithGroupId:(NSString *)groupID
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{@"groupId" : groupID};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"group/join"
//                           params:params
//                          success:success
//                          failure:failure];
}

// add users into group
+ (void)addUsersIntoGroup:(NSString *)groupID
                  usersId:(NSMutableArray *)usersId
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{@"groupId" : groupID, @"memberIds" : usersId};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"group/add" params:params success:success failure:failure];
}

// kick users out of group
+ (void)kickUsersOutOfGroup:(NSString *)groupID
                    usersId:(NSMutableArray *)usersId
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{@"groupId" : groupID, @"memberIds" : usersId};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"group/kick"
//                           params:params
//                          success:success
//                          failure:failure];
}

// quit group with groupId
+ (void)quitGroupWithGroupId:(NSString *)groupID
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{@"groupId" : groupID};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"group/quit"
//                           params:params
//                          success:success
//                          failure:failure];
}

// dismiss group with groupId
+ (void)dismissGroupWithGroupId:(NSString *)groupID
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{@"groupId" : groupID};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"group/dismiss"
//                           params:params
//                          success:success
//                          failure:failure];
}

// rename group with groupId
+ (void)renameGroupWithGroupId:(NSString *)groupID
                     GroupName:(NSString *)groupName
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{@"groupId" : groupID, @"name" : groupName};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"group/rename"
//                           params:params
//                          success:success
//                          failure:failure];
}

+ (void)getFriendListFromServerSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure {
    //获取除自己之外的好友信息
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:[NSString stringWithFormat:@"friendship/all"]
//                           params:nil
//                          success:success
//                          failure:failure];
}

+ (void)processInviteFriendRequest:(NSString *)friendUserId
                      currentUseId:(NSString *)currentUserId
                              time:(NSString *)now
                           success:(void (^)(id))success
                           failure:(void (^)(NSError *))failure {
//    NSDictionary *params = @{@"friendId" : friendUserId, @"currentUserId" : currentUserId, @"time" : now};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"agree" params:params success:success failure:failure];
}

+ (void)processInviteFriendRequest:(NSString *)friendUserId
                           success:(void (^)(id))success
                           failure:(void (^)(NSError *))failure {
//    NSDictionary *params = @{@"friendId" : friendUserId};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"friendship/agree"
//                           params:params
//                          success:success
//                          failure:failure];
}

//加入黑名单
+ (void)addToBlacklist:(NSString *)userId
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{@"friendId" : userId};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"user/add_to_blacklist"
//                           params:params
//                          success:success
//                          failure:failure];
}

//从黑名单中移除
+ (void)removeToBlacklist:(NSString *)userId
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{@"friendId" : userId};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"user/remove_from_blacklist"
//                           params:params
//                          success:success
//                          failure:failure];
}

//获取黑名单列表
+ (void)getBlacklistsuccess:(void (^)(id response))success failure:(void (^)(NSError *err))failure {
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:@"user/blacklist"
//                           params:nil
//                          success:success
//                          failure:failure];
}

//讨论组接口，暂时保留
+ (void)updateName:(NSString *)userName success:(void (^)(id response))success failure:(void (^)(NSError *err))failure {
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"update_profile"
//                           params:@{@"username" : userName}
//                          success:success
//                          failure:failure];
}

//获取版本信息
+ (void)getVersionsuccess:(void (^)(id response))success failure:(void (^)(NSError *err))failure {
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:@"/misc/client_version"
//                           params:nil
//                          success:success
//                          failure:failure];
}

//设置好友备注
+ (void)setFriendDisplayName:(NSString *)friendId
                 displayName:(NSString *)displayName
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure {
//    NSDictionary *params = @{@"friendId" : friendId, @"displayName" : displayName};
//    [AFHttpTool requestWihtMethod:RequestMethodTypePost
//                              url:@"friendship/set_display_name"
//                           params:params
//                          success:success
//                          failure:failure];
}

//获取用户详细资料
+ (void)getFriendDetailsByID:(NSString *)friendId
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure {
//    [AFHttpTool requestWihtMethod:RequestMethodTypeGet
//                              url:[NSString stringWithFormat:@"friendship/%@/profile", friendId]
//                           params:nil
//                          success:success
//                          failure:failure];
}
@end
