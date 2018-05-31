
//
//  SWAuditContractCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWAuditContractCmd.h"

@implementation SWAuditContractCmd

-(instancetype)init {

    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/audit";
        
    }
    
    return self;
    
}

@end
