//
//  DataBase.m
//  FMDBDemo
//
//  Created by Zeno on 16/5/18.
//  Copyright © 2016年 zenoV. All rights reserved.
//

#import "DataBase.h"

#import <FMDB/FMDB.h>

#import "FileModel.h"

static DataBase *_DBCtl = nil;

@interface DataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
    
}




@end

@implementation DataBase

+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[DataBase alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    
    return _DBCtl;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [super allocWithZone:zone];
        
    }
    
    return _DBCtl;
    
}

-(id)copy{
    
    return self;
    
}

-(id)mutableCopy{
    
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    return self;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return self;
    
}


-(void)initDataBase{
    // 获得Documents目录路径
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    
    // 实例化FMDataBase对象
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];
    
    if ([_db tableExists:@"file"] == NO)
    {
        NSString *personSql = @"CREATE TABLE 'file' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'file_id' VARCHAR(255),'file_name' VARCHAR(255),'file_path' VARCHAR(255),'file_add_time' VARCHAR(255),'file_user_id' VARCHAR(255),'file_type' VARCHAR(255),'file_all_name' VARCHAR(255)) ";
        
        
       
        BOOL result =  [_db executeUpdate:personSql];
        if (result) {
                    NSLog(@"创建表单成功");
        }else{
                    NSLog(@"创建表单失败");
        }
    }
    // 初始化数据表
    

    
    
    [_db close];

}
#pragma mark - 接口

- (void)addFile:(FileModel *)file{
    
    [_db open];
    
//    NSNumber *maxID = @(0);
//    
//    FMResultSet *res = [_db executeQuery:@"SELECT * FROM file "];
//    //获取数据库中最大的ID
//    while ([res next]) {
//        if ([maxID integerValue] < [[res stringForColumn:@"file_id"] integerValue]) {
//            maxID = @([[res stringForColumn:@"file_id"] integerValue] ) ;
//        }
//        
//    }
//    maxID = @([maxID integerValue] + 1);
    
   BOOL result =  [_db executeUpdate:@"INSERT INTO file(file_id,file_name,file_path,file_add_time,file_user_id,file_all_name,file_type)VALUES(?,?,?,?,?,?,?)",file.file_id,file.file_name,file.file_path,file.file_add_time,file.file_user_id,file.file_all_name,file.file_type];
    if (result) {
        NSLog(@"添加成功");
    }else{
         NSLog(@"添加失败");
    }
    
    
    [_db close];
    
}

- (void)deleteFile:(FileModel *)file{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM file WHERE file_id = ?",file.file_id];

    [_db close];
}

- (void)updateFile:(FileModel *)file{
    [_db open];
    
    [_db executeUpdate:@"UPDATE 'file' SET file_name = ?  WHERE file_id = ? ",file.file_name,file.file_id];
    [_db executeUpdate:@"UPDATE 'file' SET file_path = ?  WHERE file_id = ? ",file.file_path,file.file_id];
    [_db executeUpdate:@"UPDATE 'file' SET file_add_time = ?  WHERE file_id = ? ",file.file_add_time,file.file_id];
    [_db executeUpdate:@"UPDATE 'file' SET file_user_id = ?  WHERE file_id = ? ",file.file_user_id,file.file_id];
    [_db executeUpdate:@"UPDATE 'file' SET file_all_name = ?  WHERE file_id = ? ",file.file_all_name,file.file_id];
    [_db executeUpdate:@"UPDATE 'file' SET file_type = ?  WHERE file_id = ? ",file.file_type,file.file_id];

    
    [_db close];
}

- (NSMutableArray *)getAllFile{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *usr_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM file WHERE file_user_id = ?",usr_id];
    
    while ([res next]) {
        FileModel *file = [[FileModel alloc] init];
        file.file_id = [NSString stringWithFormat:@"%@",@([[res stringForColumn:@"file_id"] integerValue])];
        file.file_name = [res stringForColumn:@"file_name"];
        file.file_path = [res stringForColumn:@"file_path"] ;
        file.file_add_time = [res stringForColumn:@"file_add_time"] ;
        file.file_user_id = [res stringForColumn:@"file_user_id"];
        file.file_all_name = [res stringForColumn:@"file_all_name"];
        file.file_type = [res stringForColumn:@"file_type"];
        [dataArray insertObject:file atIndex:0];
        
    }
    
    [_db close];
    
    
    return dataArray;
    
    
}

@end
