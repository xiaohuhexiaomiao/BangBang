//
//  SWRegisterCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWRegisterCmd.h"
#import "BaseRespond.h"

@implementation SWRegisterCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/skey/register";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
