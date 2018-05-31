//
//  SWMoneyInfo.h
//  FindWorkerApp
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@interface SWMoneyInfo : Jastor

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, retain) NSString *message;

@property (nonatomic, retain) NSDictionary *data;

@end
