//
//  SWComfirmCompletionCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/13.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWComfirmCompletionCmd.h"

@implementation SWComfirmCompletionCmd

-(instancetype)init {
    
    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/confirmCompletion";
        
    }
    
    return self;
    
}

@end
