//
//  SWWorkerDetailData.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWWorkerDetailData.h"
#import "SWDetailWorkerInfo.h"
#import "SWDetailWorkerComments.h"

@implementation SWWorkerDetailData

- (Class)worker_class {
    
    return [SWDetailWorkerInfo class];
    
}

- (Class)employer_class {
    
    return [SWDetailWorkerComments class];
    
}

@end
