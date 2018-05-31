//
//  SWInviteInfo.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWInviteInfo : Jastor

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, retain) NSString *message;

/** 返回的是invite对应添加的自增ID */
@property (nonatomic, retain) NSString *data;

@end
