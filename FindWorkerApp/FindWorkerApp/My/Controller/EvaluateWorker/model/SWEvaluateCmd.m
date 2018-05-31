//
//  SWEvaluateCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWEvaluateCmd.h"

@implementation SWEvaluateCmd

- (instancetype)init {

    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Find/comment";
        
    }
    
    return self;
    
}

@end
