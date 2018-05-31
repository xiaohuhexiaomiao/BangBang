//
//  SWMyUserInfoCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyUserInfoCmd.h"
#import "BaseRespond.h"

@implementation SWMyUserInfoCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/User/user_info";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
