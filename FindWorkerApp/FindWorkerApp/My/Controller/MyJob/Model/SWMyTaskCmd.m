//
//  SWMyTaskCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyTaskCmd.h"
#import "BaseRespond.h"

@implementation SWMyTaskCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/myTask2";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
