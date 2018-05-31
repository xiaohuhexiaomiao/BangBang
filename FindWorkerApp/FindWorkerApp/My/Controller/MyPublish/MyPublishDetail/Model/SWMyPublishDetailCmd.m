//
//  SWMyPublishDetailCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/9.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyPublishDetailCmd.h"
#import "BaseRespond.h"

@implementation SWMyPublishDetailCmd

- (instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/releaseDetail";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
