//
//  FileModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/10/20.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject //本地文件

@property(nonatomic ,copy)NSString *file_id;

@property(nonatomic ,copy)NSString *file_name;

@property(nonatomic ,copy)NSString *file_path;

@property(nonatomic ,copy)NSString *file_add_time;

@property(nonatomic ,copy)NSString *file_user_id;

@property(nonatomic ,copy)NSString *file_all_name;

@property(nonatomic ,copy)NSString *file_type;

@end
