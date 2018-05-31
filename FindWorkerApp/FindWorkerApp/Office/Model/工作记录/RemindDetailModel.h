//
//  RemindDetailModel.h
//  FindWorkerApp
//
//  Created by cxz on 2017/12/14.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindDetailModel : NSObject

@property(nonatomic ,copy) NSString *avatar;

@property(nonatomic ,copy) NSString *reply_content;//回复我的评论

@property(nonatomic ,copy) NSString *description_detail;//被回复内容

@property(nonatomic ,copy) NSString *enclosure;

@property(nonatomic ,copy) NSString *name;

@property(nonatomic ,copy) NSString *publish_id;

@property(nonatomic ,copy) NSString *reply_id;

@property(nonatomic ,assign) NSInteger publish_type;

@property(nonatomic ,copy) NSString *time;

@property(nonatomic ,copy) NSString *uid;

@property(nonatomic ,assign) NSTimeInterval start_time;

@property(nonatomic ,assign) NSInteger log_type;


@end
