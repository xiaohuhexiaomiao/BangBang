//
//  SWWorkerInfoCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/1.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWWorkerInfoCmd.h"
#import "BaseRespond.h"

@implementation SWWorkerInfoCmd

- (instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/nearby_worker";
       
    }
    
    return self;
    
}

@end
