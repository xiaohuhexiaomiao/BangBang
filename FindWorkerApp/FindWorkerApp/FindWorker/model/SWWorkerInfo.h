//
//  SWWorkerInfo.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/1.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@class SWWorkerDetail;

@interface SWWorkerInfo : Jastor

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, retain) NSString *message;

@property (nonatomic, retain) SWWorkerDetail *data;

@end
