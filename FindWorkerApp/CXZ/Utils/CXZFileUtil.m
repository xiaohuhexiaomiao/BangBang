
//
//  CXZFileUtil.m
//  ImHere
//
//  Created by 卢明渊 on 15/3/20.
//  Copyright (c) 2015年 我在这. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "CXZFileUtil.h"
#define TEMP_DIR @"tmp/"

@implementation CXZFileUtil
//获取本地存储目录 指定目录
+ (NSString*)getLocalPath:(NSString*)pathName {
    return [CXZFileUtil getLocalPath:pathName ForCache:YES];
}

//获取本地存储目录 指定目录
+ (NSString*)getLocalPath:(NSString*)pathName ForCache:(BOOL)forCache {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(forCache?NSCachesDirectory:NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:pathName];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return path;
}

//获取本地存储文件名 指定目录和文件名
+ (NSString*)getLocalFilename:(NSString*)name Path:(NSString*)path {
    return [[CXZFileUtil getLocalPath:path] stringByAppendingPathComponent:name];
}

+ (NSString*)getThumb:(NSString*)pathName{
    NSString*newName=[[NSString alloc] init];
    NSString*filename=[pathName lastPathComponent];
    newName=[NSString stringWithFormat:@"%@m_%@",[pathName stringByReplacingOccurrencesOfString:filename withString:@""],filename];
    return newName;
}

//保存数据到指定文件
+ (NSString*)saveData:(NSData *)data Dir:(NSString *)dir Filename:(NSString *)filename {
    NSString* realDir = [NSString stringWithFormat:@"%@/%@", dir, [filename stringByDeletingLastPathComponent]];
    NSString* realName = [filename lastPathComponent];
    
    NSString *filePath = [CXZFileUtil getLocalPath:realDir];
    
    NSString *absFilePath = [filePath stringByAppendingPathComponent:realName];
    [self saveData:data Path:absFilePath];
    return absFilePath;
}

//保存数据到指定文件
+ (BOOL)saveData:(NSData *)data Path:(NSString*)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager createFileAtPath:path contents:data attributes:nil];
    return res;
}

// 保存为临时文件
+ (NSString*) saveTempImage:(UIImage*) image {
    NSTimeInterval sec = [NSDate date].timeIntervalSince1970;
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    
    NSString* path = [CXZFileUtil getLocalPath:TEMP_DIR ForCache:YES];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%.3f.jpg", sec]];
    NSLog(@"------path%@",path);
    if ([CXZFileUtil saveData:data Path:path]) {
        return path;
    } else {
        return nil;
    }
}

+ (NSString*) saveImage:(UIImage *)image path:(NSString *)file {
    if ([CXZFileUtil saveData:UIImageJPEGRepresentation(image, 1.0f) Path:file]) {
        return file;
    } else {
        return nil;
    }
}

+ (NSString *)saveImage:(UIImage *)image dir:(NSString *)dir {
    NSTimeInterval sec = [NSDate date].timeIntervalSince1970;
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    
    NSString* path = [CXZFileUtil getLocalPath:dir ForCache:NO];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%.0f.jpg", sec]];
    if ([CXZFileUtil saveData:data Path:path]) {
        return path;
    } else {
        return nil;
    }
}

//删除指定文件
+ (BOOL)deleteFile:(NSString*)filename Dir:(NSString*)dir {
    return [self deleteFilename:[CXZFileUtil getLocalFilename:filename Path:dir]];
}

//删除指定文件
+ (BOOL)deleteFilename:(NSString*)filename {
    NSError* error = nil;
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filename error:&error];
    if(error != nil) {
        return NO;
    }
    return YES;
}

// 删除
+ (void) cleanTmp {
    NSString* path = [CXZFileUtil getLocalPath:TEMP_DIR ForCache:YES];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [CXZFileUtil deleteFilename:filename];
    }
}

+ (BOOL)fileExists:(NSString *)filepath {
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filepath];
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少Bit
+ (long long)folderSizeAtPath:(NSString*)folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

+(void)readyDatabase:(NSString*)dbName patch:(NSString*)patch{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    BOOL success;
    NSString* localDBPath = [CXZFileUtil getLocalFilename:dbName Path:patch];
    success = [fileManager fileExistsAtPath:localDBPath];
    if(!success) {
        NSString* defaultDBPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", dbName] ofType:nil];
        success = [fileManager fileExistsAtPath:defaultDBPath];
        if(!success) {
            //NSLog(@"no extis");
        }
        success = [fileManager copyItemAtPath:defaultDBPath toPath:localDBPath error:&error];
        if(!success) {
            //NSLog(@"error : %@", [error description]);
        }
    }
}

+ (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return CFBridgingRelease(MIMEType);
    return nil;
}
@end
