//
//  SWUploadContractCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWUploadContractCmd.h"
#import "BaseRespond.h"

@implementation SWUploadContractCmd

- (instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/contract";
        self.respondType = [BaseRespond class];
        
    }
    
    return self;
    
}

@end
