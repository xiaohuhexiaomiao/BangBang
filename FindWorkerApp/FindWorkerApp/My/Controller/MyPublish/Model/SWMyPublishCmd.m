//
//  SWMyPublishCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyPublishCmd.h"
#import "BaseRespond.h"

@implementation SWMyPublishCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/myRelease";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
