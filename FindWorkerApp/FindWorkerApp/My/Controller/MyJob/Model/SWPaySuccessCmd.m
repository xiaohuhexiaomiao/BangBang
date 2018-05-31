//
//  SWPaySuccessCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWPaySuccessCmd.h"

@implementation SWPaySuccessCmd

- (instancetype)init {

    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/pay_sucess";
        
    }
    
    return self;
    
}

@end
