//
//  DataBase.h
//  FMDBDemo
//
//  Created by Zeno on 16/5/18.
//  Copyright © 2016年 zenoV. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FileModel;




@interface DataBase : NSObject

@property(nonatomic,strong) FileModel *file;


+ (instancetype)sharedDataBase;


#pragma mark - Person
/**
 *  添加person
 *
 */
- (void)addFile:(FileModel *)file;
/**
 *  删除person
 *
 */
- (void)deleteFile:(FileModel *)file;
/**
 *  更新person
 *
 */
- (void)updateFile:(FileModel *)file;

/**
 *  获取所有数据
 *
 */
- (NSMutableArray *)getAllFile;

@end
