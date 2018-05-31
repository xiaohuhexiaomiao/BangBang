//
//  SWAuditWorkerCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWAuditWorkerCmd.h"
#import "BaseRespond.h"

@implementation SWAuditWorkerCmd

-(instancetype)init {
    
    if(self = [super init]) {
    
        self.addr = @"/index.php/Mobile/Myinfo/auditWorker";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
