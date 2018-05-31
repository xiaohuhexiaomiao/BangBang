//
//  SWWorkerDetail.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWWorkerDetail.h"
#import "SWWorkerData.h"
#import "SWWorkerArea.h"

@implementation SWWorkerDetail

- (Class)nworker_class {

    return [SWWorkerData class];
    
}

- (Class)narea_class {
    
    return [SWWorkerArea class];
    
}

@end
