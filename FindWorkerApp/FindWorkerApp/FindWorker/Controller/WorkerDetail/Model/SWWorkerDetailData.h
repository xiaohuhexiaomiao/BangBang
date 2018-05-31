//
//  SWWorkerDetailData.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@class SWDetailWorkerInfo;

@interface SWWorkerDetailData : Jastor

@property (nonatomic, retain) SWDetailWorkerInfo *worker;

@property (nonatomic, retain) NSArray *employer;

/** 输出issc=0是没有被收藏，issc=1被收藏 */
@property (nonatomic, assign) NSInteger issc;

@end
