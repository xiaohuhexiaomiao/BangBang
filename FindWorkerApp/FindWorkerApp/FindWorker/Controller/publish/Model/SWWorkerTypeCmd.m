//
//  SWWorkerTypeCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/6.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWWorkerTypeCmd.h"
#import "BaseRespond.h"

@implementation SWWorkerTypeCmd

-(instancetype)init {
    
    if(self = [super init]){
        
        self.addr = @"/index.php/Mobile/Find/worker_type";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
