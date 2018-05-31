//
//  SWApplyCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWApplyCmd.h"
#import "BaseRespond.h"

@implementation SWApplyCmd

- (instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/saveSq";;
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
