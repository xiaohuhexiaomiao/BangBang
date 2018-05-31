//
//  SWSendCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWSendCmd.h"
#import "BaseRespond.h"

@implementation SWSendCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/User/send_validate_code";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
