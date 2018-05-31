//
//  SWAreaCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWAreaCmd.h"
#import "BaseRespond.h"

@implementation SWAreaCmd

- (instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/area";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
