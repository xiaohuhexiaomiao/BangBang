//
//  SWChangeJobStateCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/6.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWChangeJobStateCmd.h"
#import "BaseRespond.h"

@implementation SWChangeJobStateCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/setJob";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
