//
//  SWMoneyCmd.m
//  FindWorkerApp
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 SimonWest. All rights reserved.
//

#import "SWMoneyCmd.h"

@implementation SWMoneyCmd

-(instancetype)init {

    if(self = [super init]) {
        
        self.addr = @"/index.php/Mobile/Myinfo/money";
        
    }
    
    return self;
    
}

@end
