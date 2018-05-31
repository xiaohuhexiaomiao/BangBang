//
//  ApprovalReplyModel.h
//  FindWorkerApp
//
//  Created by cxz on 2018/4/9.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApprovalReplyModel : NSObject

@property(nonatomic ,copy)NSString *name;//评论人姓名

@property(nonatomic ,copy)NSString *uid;//评论人uid

@property(nonatomic ,copy)NSString *return_person_name;//被评论人姓名

@property(nonatomic ,copy)NSString *return_person_uid;//被评论人uid

@property(nonatomic ,copy)NSString *reply_content;//评论内容

@property(nonatomic ,copy)NSString *add_time;//评论时间

@property(nonatomic ,strong)NSArray *many_enclosure;//附件

@end
