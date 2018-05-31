//
//  SWUploadPositionCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/3.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWUploadPositionCmd.h"
#import "BaseRespond.h"

@implementation SWUploadPositionCmd

-(instancetype)init {
    
    if(self = [super init]) {
    
        self.addr = @"/index.php/Mobile/Find/my_position";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
