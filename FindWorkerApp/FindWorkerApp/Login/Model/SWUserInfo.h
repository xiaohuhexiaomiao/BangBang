//
//  SWUserInfo.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@class SWUserData;

@interface SWUserInfo : Jastor

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, retain) NSString *message;

@property (nonatomic, retain) SWUserData *data;

@end
