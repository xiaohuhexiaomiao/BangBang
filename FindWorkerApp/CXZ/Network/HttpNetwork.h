//
//  HttpNetwork.h
//  DiaoDiao
//
//  Created by wangzeng on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCommand.h"
#import "BaseRespond.h"
#import "AFNetworking.h"

@class BaseRespond;
@class BaseCommand;

typedef void (^SuccessBlock)(BaseRespond* respond);
typedef void (^FailedBlock)(BaseRespond* respond, NSString* error);

@interface HttpNetwork : NSObject {
    NSOperationQueue* _imageQueue; //图片请求队列
}

@property(nonatomic, copy) void(^checkTokenFailed)(int type);

+ (HttpNetwork*) getInstance;

// 请求消息
- (NSURLSessionDataTask*)requestPOST:(BaseCommand*)cmd success:(SuccessBlock)success failed:(FailedBlock)failed;
- (NSURLSessionDataTask *)requestGET:(BaseCommand *)cmd success:(SuccessBlock)success failed:(FailedBlock)failed;


// 请求消息
- (NSURLSessionDataTask*)request:(BaseCommand*)cmd success:(SuccessBlock)success failed:(FailedBlock)failed;

// 上传接口
- (void)upload:(NSString*)url filepath:(NSString*)filepath progressView:(UIProgressView*)indicator success:(SuccessBlock)success failed:(FailedBlock)failed;

- (void)upload:(NSString*)url filepath:(NSString*)filepath params:(NSDictionary*)params progressView:(UIProgressView*)indicator success:(SuccessBlock)success failed:(FailedBlock)failed;

- (void)upload:(NSString*)url filepaths:(NSArray*)filepaths progressView:(UIProgressView*)indicator success:(SuccessBlock)success failed:(FailedBlock)failed;

- (void)upload:(NSString*)url filepaths:(NSArray*)filepaths params:(NSDictionary*)params progressView:(UIProgressView*)indicator success:(SuccessBlock)success failed:(FailedBlock)failed;

- (void)download:(NSString*)url file:(NSString*)file progressDelegate:(UIProgressView *)indicator success:(FailedBlock)success failed:(FailedBlock)failed;
@end
