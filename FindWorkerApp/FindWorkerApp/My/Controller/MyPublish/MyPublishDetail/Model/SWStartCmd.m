//
//  SWStartCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/11.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWStartCmd.h"
#import "BaseRespond.h"

@implementation SWStartCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/startProjecr";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
