//
//  HttpNetwork.m
//  DiaoDiao
//
//  Created by wangzeng on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import "HttpNetwork.h"
#import "CXZ.h"
#import "SWLoginController.h"
@interface HttpNetwork()

@property(nonatomic, strong) NSMutableDictionary* cmdDict;

@end

static HttpNetwork* g_instance = nil;
@implementation HttpNetwork
+ (HttpNetwork*) getInstance {
    @synchronized(self) {
        if (g_instance == nil) {
            g_instance = [[self alloc] init];
        }
        return g_instance;
    }
}

- (id) init {
    if (self = [super init]) {
        _imageQueue = [[NSOperationQueue alloc] init];
        _cmdDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSURLSessionDataTask *)requestPOST:(BaseCommand *)cmd success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSString *key = [NSString stringWithFormat:@"%@|%@", cmd.addr, [cmd toJsonString]];
//    int now = [[NSDate date] timeIntervalSince1970];
//    if ([_cmdDict objectForKey:key] && now - [[_cmdDict objectForKey:key] intValue] < 4) {
//        // 3秒之类重复请求过滤
//        return nil;
//    }
//    NSLog(@"request:%@%@", API_HOST, key);
//    [_cmdDict setObject:[NSNumber numberWithInt:now] forKey:key];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置返回类型
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
//    session.requestSerializer = [AFHTTPRequestSerializer serializer];
//    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    session.requestSerializer.timeoutInterval = 60;//请求超时时间
    NSURLSessionDataTask *request;
    NSString *url = [NSString stringWithFormat:@"%@%@", API_HOST, cmd.addr];
    

    
    NSDictionary *dic = [cmd toDicData];
    
    request = [session POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [[HttpNetwork getInstance].cmdDict removeObjectForKey:key];
        BaseRespond *baserespond = [[cmd.respondType alloc] init];
        NSDictionary *respond = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"***add:%@", respond);
        if (respond != nil) {
            int code = [[respond objectForKey:@"code"] intValue];
            baserespond.code = code;
            baserespond.data = respond;
            baserespond.message = respond[@"message"];
            
            if (code==251 || code==252 ) {
                static NSString *alertTitle;
                if (code == 251) {
                    alertTitle = @"您的账号被其他设备登录已下线，请重新登录！";
                }else{
                    alertTitle = @"您的登录授权已过期，请重新登录！";
                }
                UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:alertTitle  message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alerVC addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    SWLoginController *logVC = [[SWLoginController alloc]init];
                    UIViewController *resultVC = [self topViewController];
                    [resultVC presentViewController:logVC animated:YES completion:nil];
                    
                }]];
                UIViewController *resultVC = [self topViewController];
                
                [resultVC presentViewController:alerVC animated:YES completion:nil];
                
            }else {
                success(baserespond);
            }
            
        } else {
            if (failed) {
                failed(baserespond, @"请求数据失败");
            }
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (failed) {
            NSString *errors = error.localizedFailureReason;
            if (IS_EMPTY(errors)) {
                errors = [NSString stringWithFormat:@"网络异常:%@",errors];
            }
            failed(nil, errors);
        }
        
    }];
    
    return request;
}

- (NSURLSessionDataTask *)requestGET:(BaseCommand *)cmd success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSString *key = [NSString stringWithFormat:@"%@|%@", cmd.addr, [cmd toJsonString]];
    int now = [[NSDate date] timeIntervalSince1970];
    if ([_cmdDict objectForKey:key] && now - [[_cmdDict objectForKey:key] intValue] < 4) {
        // 3秒之类重复请求过滤
        return nil;
    }
    NSLog(@"request:%@%@", API_HOST, key);
    [_cmdDict setObject:[NSNumber numberWithInt:now] forKey:key];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置返回类型
    
    //    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval = 60;//请求超时时间
    NSURLSessionDataTask *request;
    NSString *url = [NSString stringWithFormat:@"%@%@", API_HOST, cmd.addr];
    NSDictionary *dic = [cmd toDicData];
    //    NSLog(@"%@",dic);
    request = [session GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[HttpNetwork getInstance].cmdDict removeObjectForKey:key];
        BaseRespond *baserespond = [[cmd.respondType alloc] init];
        NSDictionary *respond = (NSDictionary *) responseObject;
        //        NSLog(@"%@",responseObject);
        if (respond != nil) {
            int code = [[respond objectForKey:@"code"] intValue];
            baserespond.code = code;
            baserespond.data = respond;
            
            if (code >= 0) {
                if (code==251 || code==252 ) {
                    static NSString *alertTitle;
                    if (code == 251) {
                        alertTitle = @"您的账号被其他设备登录已下线，请重新登录！";
                    }else{
                        alertTitle = @"您的登录授权已过期，请重新登录！";
                    }
                    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:alertTitle  message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [alerVC addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        SWLoginController *logVC = [[SWLoginController alloc]init];
                        UIViewController *resultVC = [self topViewController];
                        [resultVC presentViewController:logVC animated:YES completion:nil];
                        
                    }]];
                    UIViewController *resultVC = [self topViewController];
                    
                    [resultVC presentViewController:alerVC animated:YES completion:nil];
                    
                }else {
                    success(baserespond);
                }
            } else {
                    if (failed) {
                        failed(baserespond, @"请求数据失败");
                    }
            }
        } else {
            if (failed) {
                failed(baserespond, @"请求数据失败");
            }
        }
    }   failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failed) {
            NSString *errors = error.localizedFailureReason;
            NSLog(@"%@",error);
            if (IS_EMPTY(errors)) {
                errors = @"网络异常";
            }
            failed(nil, errors);
        }
    }];
    
    
    return request;
}



- (NSURLSessionDataTask*)request:(BaseCommand *)cmd success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSString* key = [NSString stringWithFormat:@"%@|%@",cmd.addr, [cmd toJsonString]];
    int now = [[NSDate date] timeIntervalSince1970];
    if ([_cmdDict objectForKey:key] && now - [[_cmdDict objectForKey:key] intValue] < 4) {
        // 3秒之类重复请求过滤
        return nil;
    }
    NSLog(@"%@", key);
    [_cmdDict setObject:[NSNumber numberWithInt:now] forKey:key];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置返回类型
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    session.requestSerializer.timeoutInterval = 60;//请求超时时间
    NSURLSessionDataTask *request;
    NSString *url = [NSString stringWithFormat:@"%@%@", API_HOST, cmd.addr];
    NSDictionary*dic=[cmd toDicData];
    request=[session POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[HttpNetwork getInstance].cmdDict removeObjectForKey:key];
        BaseRespond* baserespond = [[cmd.respondType alloc] init];
        NSDictionary*respond = (NSDictionary*)responseObject;
        if (respond!=nil) {
            int code=[[respond objectForKey:@"ret"] intValue];
            baserespond.code=code;
            baserespond.data=respond;
            if(code >=0) {
                if (code==251 || code==252 ) {
                    static NSString *alertTitle;
                    if (code == 251) {
                        alertTitle = @"您的账号被其他设备登录已下线，请重新登录！";
                    }else{
                        alertTitle = @"您的登录授权已过期，请重新登录！";
                    }
                    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:alertTitle  message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [alerVC addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        SWLoginController *logVC = [[SWLoginController alloc]init];
                        UIViewController *resultVC = [self topViewController];
                        [resultVC presentViewController:logVC animated:YES completion:nil];
                        
                    }]];
                    UIViewController *resultVC = [self topViewController];
                    
                    [resultVC presentViewController:alerVC animated:YES completion:nil];
                    
                }else {
                    success(baserespond);
                }
            }else {
                if (code == -110 && [HttpNetwork getInstance].checkTokenFailed != nil) {
                    [HttpNetwork getInstance].checkTokenFailed(1);
                }else if (code == -109 && [HttpNetwork getInstance].checkTokenFailed != nil){
                    [HttpNetwork getInstance].checkTokenFailed(2);
                } else {
                    if (failed) {
                        failed(baserespond, @"请求数据失败");
                    }
                }
            }
        }else{
            if (failed) {
                failed(baserespond, @"请求数据失败");
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            NSString* errors = error.localizedFailureReason;
            if(IS_EMPTY(errors)) {
                errors = @"网络异常";
            }
            failed(nil, errors);
        }
        
    }];
    
    return request;
}


#pragma mark 上传图片接口
- (void)upload:(NSString *)url filepath:(NSString *)filepath progressView:(UIProgressView *)indicator success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSArray* paths = [[NSArray alloc] initWithObjects:filepath, nil];
    [self upload:url filepaths:paths params:nil progressView:indicator success:success failed:failed];
}

- (void)upload:(NSString *)url filepath:(NSString *)filepath params:(NSDictionary *)params progressView:(UIProgressView *)indicator success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSArray* paths = [[NSArray alloc] initWithObjects:filepath, nil];
    [self upload:url filepaths:paths params:params progressView:indicator success:success failed:failed];
}

- (void)upload:(NSString *)url filepaths:(NSArray *)filepaths progressView:(UIProgressView *)indicator success:(SuccessBlock)success failed:(FailedBlock)failed {
    [self upload:url filepaths:filepaths params:nil progressView:indicator success:success failed:failed];
}

- (void)upload:(NSString *)url filepaths:(NSArray *)filepaths params:(NSDictionary *)params progressView:(UIProgressView *)indicator success:(SuccessBlock)success failed:(FailedBlock)failed {
    if (filepaths == nil || filepaths.count == 0) {
        if (failed) {
            failed(nil, @"不能上传空文件列表");
        }
       
    }else{
        
    }
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置返回类型
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval = 120;//请求超时时间
    [session POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
        // 添加上传的文件
        for (int i=0; i < filepaths.count; i++) {
            NSString*filePath=[filepaths objectAtIndex:i];
            NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
            NSString *fileName = [[filePath componentsSeparatedByString:@"/"] lastObject];
            
            fileName = [[fileName componentsSeparatedByString:@"."] firstObject];
            NSError *error;
            BOOL success = [formData appendPartWithFileURL:fileUrl name:fileName error:&error];
//            [formData appendPartWithFileData:imageData name:fileName fileName:dateStr mimeType:@"image/jpeg"];
            if (!success)
                NSLog(@"appendPartWithFileURL error: %@", error);

        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"%f",1.0*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        indicator.progress=1.0*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        //        if([[UIDevice currentDevice].systemVersion doubleValue]>=9.0){
        //            indicator.observedProgress=uploadProgress;
        //        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseRespond* baserespond = [[BaseRespond alloc] init];
        NSLog(@"response图片 %@", responseObject);
        NSDictionary*respond = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        int code=[[respond objectForKey:@"code"] intValue];
        baserespond.code=code;
        baserespond.data=respond;
        if(code == 0) {
            if (success) {
                success(baserespond);
            }
        }
        else {
            if(failed) {
                failed(baserespond, respond[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            NSString* errors = error.localizedFailureReason;
            if(IS_EMPTY(errors)) {
                errors = @"网络异常";
            }
            failed(nil, errors);
        }
        
    }];
    
}

- (void) download:(NSString *)url file:(NSString *)file progressDelegate:(UIProgressView *)indicator success:(FailedBlock)success failed:(FailedBlock)failed {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSURLRequest*request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask*downloadTask = [session downloadTaskWithRequest:request progress:^(NSProgress*_Nonnull downloadProgress) {
        
        NSLog(@"%f",1.0* downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        indicator.progress=1.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
        if([[UIDevice currentDevice].systemVersion doubleValue]>=9.0){
            indicator.observedProgress=downloadProgress;
        }
        
    }destination:^NSURL*_Nonnull(NSURL*_Nonnull targetPath,NSURLResponse*_Nonnull response) {
        
        NSLog(@"%@",targetPath);
        
        NSString*fullpath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)lastObject]stringByAppendingPathComponent:response.suggestedFilename];
        
        if (success) {
            success(nil, fullpath);
        }
        return [NSURL fileURLWithPath:fullpath];
    }completionHandler:^(NSURLResponse*_Nonnull response,NSURL*_Nullable filePath,NSError*_Nullable error) {
        
        NSLog(@"%@",filePath);
        if (failed) {
            NSString* errors = error.localizedFailureReason;
            if(IS_EMPTY(errors)) {
                errors = @"网络异常";
            }
            failed(nil, errors);
        }
        
    }];
    
    //执行下载操作
    
    [downloadTask resume];
    
}

-(NSString*)getSign:(NSString*)parmas
{
    //    [parmas removeObjectForKey:@"respondType"];
    //    [parmas removeObjectForKey:@"addr"];
    NSString*str=[[NSString alloc] init];
    //    NSMutableArray* array=[[NSMutableArray alloc] init];
    //    for (NSString* key in parmas) {
    //        [array addObject:[NSString stringWithFormat:@"%@=%@",key,[parmas objectForKey:key]]];
    //        //char c = pinyinFirstLetter([key characterAtIndex:0]);
    //    }
    //    NSArray *newArray = [array sortedArrayUsingSelector:@selector(compare:)];
    //    newArray=[[newArray reverseObjectEnumerator] allObjects];
    //    for (int i=0; i<newArray.count; i++) {
    //        str=[str stringByAppendingString:[NSString stringWithFormat:@"%@&",newArray[i]]];
    //    }
    //    str=[str substringToIndex:[str length] - 1];
    str=[str stringByAppendingString:parmas];
    str=[str stringByAppendingString:Session_Key];
    NSLog(@"签名前：%@",str);
    str=[CXZStringUtil md5:str];
    return str;
}


// 获取topviewcontroller
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
