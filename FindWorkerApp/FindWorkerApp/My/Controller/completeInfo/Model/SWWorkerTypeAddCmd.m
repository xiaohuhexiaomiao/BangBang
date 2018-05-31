//
//  SWWorkerTypeAddCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWWorkerTypeAddCmd.h"
#import "BaseRespond.h"

@implementation SWWorkerTypeAddCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/worker_type_add";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
