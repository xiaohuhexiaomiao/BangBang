//
//  SWMyPublishDetailInfo.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@class SWMyPublishDetailData;

@interface SWMyPublishDetailInfo : Jastor

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, retain) NSString *message;

@property (nonatomic, retain) SWMyPublishDetailData *data;

@end
