//
//  SWFindWorkCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWFindWorkCmd.h"
#import "BaseRespond.h"

@implementation SWFindWorkCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/find_work";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
