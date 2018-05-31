//
//  SWStopCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWStopCmd.h"
#import "BaseRespond.h"

@implementation SWStopCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/stopProject";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
