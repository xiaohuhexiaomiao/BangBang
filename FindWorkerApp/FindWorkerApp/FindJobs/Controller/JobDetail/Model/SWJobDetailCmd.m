//
//  SWJobDetailCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWJobDetailCmd.h"
#import "BaseRespond.h"

@implementation SWJobDetailCmd

- (instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/workDetails";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
