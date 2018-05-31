//
//  SWInviteCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWInviteCmd.h"
#import "BaseRespond.h"

@implementation SWInviteCmd

- (instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/invite";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
