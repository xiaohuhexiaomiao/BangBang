//
//  SWWorkerLocationCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/6.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWWorkerLocationCmd.h"
#import "BaseRespond.h"

@implementation SWWorkerLocationCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/user_position";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
