//
//  SWMyEvaluateCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/21.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMyEvaluateCmd.h"

@implementation SWMyEvaluateCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/myEvaluation";
        
    }
    
    return self;
    
}

@end
