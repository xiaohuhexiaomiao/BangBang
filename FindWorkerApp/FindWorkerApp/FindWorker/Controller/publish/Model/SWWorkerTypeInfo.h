//
//  SWWorkerTypeInfo.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/6.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWWorkerTypeInfo : Jastor

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, retain) NSString *message;

@property (nonatomic, retain) NSArray *data;

@end
