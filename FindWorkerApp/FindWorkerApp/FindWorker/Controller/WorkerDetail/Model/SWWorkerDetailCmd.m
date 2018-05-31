//
//  SWWorkerDetailCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWWorkerDetailCmd.h"
#import "BaseRespond.h"

@implementation SWWorkerDetailCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/worker_info";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
