//
//  SWPublishWorkCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/6.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWPublishWorkCmd.h"
#import "BaseRespond.h"

@implementation SWPublishWorkCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/release";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
