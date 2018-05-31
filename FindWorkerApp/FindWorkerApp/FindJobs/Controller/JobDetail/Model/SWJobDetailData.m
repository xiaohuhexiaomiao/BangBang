//
//  SWJobDetailData.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWJobDetailData.h"
#import "SWFindWorkType.h"

@implementation SWJobDetailData

- (Class)worker_class {
    
    return [SWFindWorkType class];
    
}

@end
