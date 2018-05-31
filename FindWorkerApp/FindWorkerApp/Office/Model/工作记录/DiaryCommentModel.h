//
//  DiaryCommentModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/11/21.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiaryCommentModel : NSObject

@property(nonatomic ,assign) NSInteger comment_id;

@property(nonatomic ,copy) NSString *uid;

@property(nonatomic ,copy) NSString *publish_id;

@property(nonatomic ,copy) NSString *content;

@property(nonatomic ,assign) NSInteger categary_id;

@property(nonatomic ,copy) NSString *add_time;

@property(nonatomic ,copy) NSString *name;

@property(nonatomic ,copy) NSString *avatar;

@property(nonatomic ,copy) NSString *reply_name;

@property(nonatomic ,copy) NSString *reply_uid;

@property(nonatomic ,strong) NSArray *enclosure;
@end
