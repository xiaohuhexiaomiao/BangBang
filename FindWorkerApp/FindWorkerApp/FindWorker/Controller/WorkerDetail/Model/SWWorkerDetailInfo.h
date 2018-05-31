//
//  SWWorkerDetailInfo.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@class SWWorkerDetailData;

@interface SWWorkerDetailInfo : Jastor

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, retain) NSString *message;

@property (nonatomic, retain) SWWorkerDetailData *data;

@end
