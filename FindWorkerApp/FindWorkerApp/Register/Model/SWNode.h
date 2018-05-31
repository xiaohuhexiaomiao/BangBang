//
//  SWNode.h
//  FindWorkerApp
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "Jastor.h"

@class SWNodeData;

@interface SWNode : Jastor

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, retain) NSString *message;

@property (nonatomic, retain) SWNodeData *data;

@end
