//
//  SWLoginCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWLoginCmd.h"
#import "BaseRespond.h"

@implementation SWLoginCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
//        self.addr = @"/index.php/Mobile/User/login";
        self.addr = @"/index.php/Mobile/skey/login";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
