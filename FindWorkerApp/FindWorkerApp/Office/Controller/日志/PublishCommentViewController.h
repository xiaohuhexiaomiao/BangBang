//
//  PublishCommentViewController.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/15.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "CXZBaseViewController.h"

@interface PublishCommentViewController : CXZBaseViewController

@property(nonatomic ,assign)NSInteger comment_type;//1 发布评论 2 点评-评分

@property(nonatomic ,copy)NSString *publish_id;//中间表id

@property(nonatomic ,copy)NSString *log_id;//日志id

@property(nonatomic ,copy)NSString *parent_id;// 如果为nil 回复日志 ，否则 回复某条评论

@end
