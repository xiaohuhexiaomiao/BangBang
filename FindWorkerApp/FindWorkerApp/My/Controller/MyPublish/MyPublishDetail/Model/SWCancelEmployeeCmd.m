//
//  SWCancelEmployeeCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/11.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWCancelEmployeeCmd.h"
#import "BaseRespond.h"

@implementation SWCancelEmployeeCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/cancelEmployment";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
