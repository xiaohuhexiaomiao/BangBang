//
//  SWCollectCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/5.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWCollectCmd.h"
#import "BaseRespond.h"

@implementation SWCollectCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/collect";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
