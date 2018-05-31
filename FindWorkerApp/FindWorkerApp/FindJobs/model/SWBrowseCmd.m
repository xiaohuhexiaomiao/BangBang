//
//  SWBrowseCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/10.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWBrowseCmd.h"
#import "BaseRespond.h"

@implementation SWBrowseCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/getBrowse";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
