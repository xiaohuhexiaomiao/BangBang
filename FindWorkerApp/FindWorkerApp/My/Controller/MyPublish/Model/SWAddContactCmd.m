//
//  SWAddContactCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/13.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWAddContactCmd.h"

@implementation SWAddContactCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/add_contract";
        
    }
    
    return self;
    
}

@end
